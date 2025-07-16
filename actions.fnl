(local actions {})

(fn get-app [nm]
  ; actually just all windows in the current space
  (each [_ win (ipairs (hs.window.allWindows))]
    (let [app (win:application)]
      (when (= nm (app:name))
        (lua "return app"))))
  ; if we can't find a window in the current space, look for an app anywhere
  (hs.application.get nm))

(fn actions.activate [nm1 nm2]
  (let [app (or (get-app nm1) (get-app nm2))]
    (when app
      (app:activate))))

(fn actions.with-ax-hotfix [app f]
  (let [ax-app (hs.axuielement.applicationElement app)
        enhanced? ax-app.AXEnhancedUserInterface]
    (when enhanced?
      (tset ax-app :AXEnhancedUserInterface false))
    (f)
    (when enhanced?
      (tset ax-app :AXEnhancedUserInterface true))))

(fn actions.move-window-to [win quad]
  (let [app (win:application)]
    (if app
      (actions.with-ax-hotfix app #(win:moveToUnit quad))
      (win:moveToUnit quad))))

(fn actions.move-to [quad]
  (actions.move-window-to (hs.window.focusedWindow) quad))

(fn actions.move-window-to-next-screen [win]
  (actions.with-ax-hotfix
    (win:application)
    #(win:moveToScreen (: (win:screen) :next))))

(fn actions.move-to-next-screen []
  (actions.move-window-to-next-screen (hs.window.focusedWindow)))

(fn actions.set-karabiner-profile! [nm]
  (hs.execute (.. "'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile '" nm "'"))
  (hs.alert.show (.. "Set keymap to '" nm "'")))

(fn actions.toggle-mode [mode]
  (if mode.active?
    (do
      (mode:exit)
      (tset mode :active? false))
    (do
      (mode:enter)
      (tset mode :active? true))))

actions
