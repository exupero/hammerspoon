(local actions {})

(fn get-app [nm]
  ; actually just all windows in the current space
  (each [_ win (pairs (hs.window.allWindows))]
    (let [app (win:application)]
      (when (= nm (app:name))
        (lua "return app"))))
  ; if we can't find a window in the current space, look for an app anywhere
  (hs.appfinder.appFromName nm))

(fn actions.activate [nm1 nm2]
  (fn []
    (let [app (or (get-app nm1) (get-app nm2))]
      (app:activate))))

(fn with-ax-hotfix [app f]
  (let [ax-app (hs.axuielement.applicationElement app)
        enhanced? ax-app.AXEnhancedUserInterface]
    (when enhanced?
      (tset ax-app :AXEnhancedUserInterface false))
    (f)
    (when enhanced?
      (tset ax-app :AXEnhancedUserInterface true))))

(fn actions.move-to [quad]
  (fn []
    (let [win (hs.window.focusedWindow)]
      (with-ax-hotfix
        (win:application)
        #(win:moveToUnit quad)))))

(fn actions.move-to-next-screen []
  (fn []
    (let [win (hs.window.focusedWindow)]
      (with-ax-hotfix
        (win:application)
        #(win:moveToScreen (: (win:screen) :next))))))

(fn actions.set-karabiner-profile! [nm]
  (fn []
    (hs.execute (.. "'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile '" nm "'"))
    (hs.alert.show (.. "Set keymap to '" nm "'"))))

(fn actions.toggle-mode [mode]
  (fn []
    (if mode.active?
      (do
        (mode:exit)
        (tset mode :active? false))
      (do
        (mode:enter)
        (tset mode :active? true)))))

actions
