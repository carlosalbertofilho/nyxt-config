(in-package #:nyxt-user)

(load (merge-pathnames #p"quicklisp/setup.lisp" (user-homedir-pathname)))
(ql:quickload 'slynk)
(define-nyxt-user-system-and-load :depends-on (slynk) :components ("my-slynk"))
