(in-package #:nyxt-user)

(defmethod customize-instance ((browser browser) &key)
  (setf (slot-value browser 'theme) theme:+dark-theme+))


;; Import Files
(nyxt::load-lisp "~/.config/nyxt/statusline.lisp")
(nyxt::load-lisp "~/.config/nyxt/stylesheet.lisp")
