(local arranging-mode (hs.hotkey.modal.new nil nil))
(global arranging-modal-id nil)

(fn arranging-mode.entered []
  (global arranging-modal-id (hs.alert.show "    ↑\n←   →\n    ↓" true))
  (tset arranging-mode :active? true))

(fn arranging-mode.exited []
  (hs.alert.closeSpecific arranging-modal-id)
  (global arranging-modal-id nil)
  (tset arranging-mode :active? false))

(fn arranging-mode.bind-keymap! [keymap]
  (each [k f (pairs keymap)]
    (when f
      (arranging-mode:bind nil k
        (fn []
          (f)
          (arranging-mode:exit))))))

arranging-mode
