#!/usr/bin/env spirit

(let [nodes (:out ($ "bspc query -N -n .tiled -d focused"))]
  
  (when (zero? (:exit ($ "pgrep polybar")))
    ($ "polybar-msg cmd hide"))
  
  (doseq [node nodes]
    ($ (str "bspc node " node " -g hidden=on"))))
