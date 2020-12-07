#!/usr/bin/env spirit

(def exit-status ($ "bspc query -N -n .focused.fullscreen -d focused"))


(if (= 1 (:exit exit-status))
  (do
    ($ "bspc node focused.tiled -t fullscreen")
    ($ "~/Documents/scripts/bsphide.st")
    ($ "polybar-msg cmd hide"))   
  (do
    ($ "bspc node focused.fullscreen -t tiled")
    ($ "~/Documents/scripts/bspunhide.st")
    ($ "polybar-msg cmd show")))

