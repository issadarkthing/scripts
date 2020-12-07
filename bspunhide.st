#!/usr/bin/env spirit


(def bspc-command "bspc query -N -n .hidden -d focused")
(def xdotool-command "xdotool search --name quick-term")


(let [nodes (:out ($ bspc-command))
      quick-term (string/split (:out ($ xdotool-command)))]
  
  ; show polybar if its running
  (when (= 0 (:exit ($ "pgrep polybar")))
    ($ "polybar-msg cmd show"))

  ; unhide other windows
  (doseq [node (string/split nodes)]
    ($ (str "bspc node " node " -g hidden=off")))

  ; hide back the quick terminal
  (when (> (count quick-term) 0)
    ($ (str "bspc node " (nth quick-term 0) " -g hidden=on"))))
