; Build script
(load "game.lisp")
(sb-ext:save-lisp-and-die "one-button-badass" :toplevel #'main :executable t :compression t)
