(local webview {})

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
          (: :html (string.format "<html>
<head>
<meta charset=\"UTF-8\" />
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />
<link rel=\"shortcut icon\" href=\"data:,\" />
<link rel=\"apple-touch-icon\" href=\"data:,\" />
<script crossorigin src=\"https://unpkg.com/react@17/umd/react.production.min.js\"></script>
<script crossorigin src=\"https://unpkg.com/react-dom@17/umd/react-dom.production.min.js\"></script>
<script src=\"https://cdn.jsdelivr.net/npm/scittle@0.6.17/dist/scittle.js\" type=\"application/javascript\"></script>
<script src=\"https://cdn.jsdelivr.net/npm/scittle@0.6.17/dist/scittle.reagent.js\" type=\"application/javascript\"></script>
<script src=\"https://cdn.jsdelivr.net/npm/scittle@0.6.17/dist/scittle.cljs-ajax.js\" type=\"application/javascript\"></script>
</head>
<body>
<div id=\"app\"></div>
<script type=\"application/javascript\">
function sendData(data) { webkit.messageHandlers.%s.postMessage(data) }
</script>
<script type=\"application/x-scittle\">%s</script>
</body>
</html>" id script))
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
