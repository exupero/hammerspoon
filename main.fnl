(local actions (require :actions))
(local arranging-mode (require :arrange))
(local machine (require :machine))

(tset hs.window :animationDuration 0)
(tset hs.hints :hintChars [:a :o :e :u :i "," "." :p :y :q :j :k :x])

(arranging-mode.bind-keymap!
  {"," (actions.move-to {:x 0 :y 0 :w 0.5 :h 0.5})
   "." (actions.move-to {:x 0.5 :y 0 :w 0.5 :h 0.5})
   :a #(arranging-mode:exit)
   :o (actions.move-to hs.layout.left50)
   :e (actions.move-to hs.layout.right50)
   :q (actions.move-to {:x 0 :y 0.5 :w 0.5 :h 0.5})
   :j (actions.move-to {:x 0.5 :y 0.5 :w 0.5 :h 0.5})})

(local keymap
  {:a (actions.toggle-mode arranging-mode)})

(hs.hotkey.bind [:cmd :alt :ctrl] :8 (actions.set-karabiner-profile! "Normal people"))
(hs.hotkey.bind [:cmd :alt :ctrl] :9 (actions.set-karabiner-profile! "Weirded"))

(local hyper [:cmd :alt :ctrl :shift])

(fn set-hotkey-bindings! [bindings]
  (each [k f (pairs bindings)]
    (when f
      (hs.hotkey.bind hyper k f))))

(set-hotkey-bindings! keymap)
(set-hotkey-bindings! machine.keymap)

(local VimMode (hs.loadSpoon :VimMode))
(doto (VimMode:new)
  (: :bindHotKeys {:enter [[] :escape]})
  (: :disableForApp :iTerm2)
  (: :disableForApp :Terminal))

(fn reload-config [files]
  (each [_ file (pairs files)]
    (when (or (= ".lua" (file:sub -4))
              (= ".fnl" (file:sub -4)))
      (hs.console.clearConsole)
      (hs.reload)
      (lua :return))))

(global watcher
  (-> (hs.pathwatcher.new (.. (os.getenv "HOME") "/.hammerspoon/") reload-config)
      (: :start)))

(hs.alert.show "Config loaded")