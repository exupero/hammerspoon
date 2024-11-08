(local webview {})

(local scittle-html
  (with-open [f (io.open "wv.html" :r)]
    (when f (f:read :*a))))

(fn webview.scittle [script]
  (let [id (.. "id" (: (hs.host.uuid) :gsub "-" ""))
        screen (. (hs.screen.allScreens) 2)
        pt (. (screen:frame) :topleft)
        rect (hs.geometry.rect [(+ pt.x 10) (+ pt.y 30)] "600x400")
        uc (hs.webview.usercontent.new id)]
    (values
      (-> (hs.webview.new rect {:developerExtrasEnabled true} uc)
          (: :windowStyle (bor hs.webview.windowMasks.titled hs.webview.windowMasks.closable hs.webview.windowMasks.HUD))
          (: :deleteOnClose true)
          (: :allowTextEntry true)
          (: :html (string.format scittle-html id script))
          (: :show))
      uc)))

; Use like the above function like this:
;
; (let [(view uc) (webview.scittle "(require '[reagent.core :as r] '[reagent.dom :as rdom])
; (def state (r/atom {:clicks 0}))
; (defn my-component []
;  [:div
;   [:p \"Clicks: \" (:clicks @state)]
;   [:p
;    [:button {:on-click (fn [_]
;                          (swap! state update :clicks inc)
;                          (js/sendData (@state :clicks)))}
;     \"Click me!\"]]])
; (rdom/render [my-component] (.getElementById js/document \"app\"))")]
;   (uc:setCallback (fn [input]
;                     (print (hs.inspect input)))))

webview
