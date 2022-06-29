(in-package #:nyxt-user)

(define-command-global start-slynk (&optional (slynk-port *swank-port*))
  "Start a Slynk server.

Waits for incoming connections, e.g. from SLY.

    Warning: This allows Nyxt to be controlled remotely, that is, to execute
    arbitrary code with the privileges of the user running Nyxt.  Make sure
    you understand the security risks associated with this before running
    this command."
  (slynk:create-server :port slynk-port :dont-close t)
  (echo "Slynk server started at port ~a" slynk-port))
