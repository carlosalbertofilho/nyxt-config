(in-package #:nyxt-user)

(defmethod customize-instance ((browser browser) &key)
  (setf (slot-value browser 'theme) theme:+dark-theme+))
