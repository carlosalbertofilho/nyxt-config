(in-package #:nyxt-user)

(defvar *web-buffer-modes*
  '(nyxt/emacs-mode:emacs-mode
    nyxt/auto-mode:auto-mode
    nyxt/blocker-mode:blocker-mode
    nyxt/force-https-mode:force-https-mode
    nyxt/reduce-tracking-mode:reduce-tracking-mode
    nyxt/user-script-mode:user-script-mode)
  "The modes to enable in web-buffer by default.
Extension files (like dark-reader.lisp) are to append to this list.
Why the variable? Because one can only set `default-modes' once, so I
need to dynamically construct a list of modes and configure the slot
only after it's done.")

;;; Set new buffer URL (a.k.a. start page, new tab page).
(define-configuration buffer
  (default-modes (append *web-buffer-modes*)))

(define-configuration browser
  ((default-new-buffer-url (quri:uri "https://duckduckgo.com/"))))

;;; Enable proxy in nosave (private, incognito) buffers.
(define-configuration nosave-buffer
  ((default-modes (append '(nyxt/proxy-mode:proxy-mode) *web-buffer-modes* %slot-default%))))

;;; Set up QWERTY home row as the hint keys.
#+nyxt-2
(define-configuration nyxt/web-mode:web-mode
  ((nyxt/web-mode:hints-alphabet "DSJKHLFAGNMXCWEIO")))
#+nyxt-3
(define-configuration nyxt/hint-mode:hint-mode
  ((nyxt/hint-mode:hints-alphabet "DSJKHLFAGNMXCWEIO")
   ;; Same as default except it doesn't hint images
   (nyxt/hint-mode:hints-selector "a, button, input, textarea, details, select")))

;;; This makes auto-mode to prompt me about remembering this or that
;;; mode when I toggle it.
(define-configuration nyxt/auto-mode:auto-mode
  ((nyxt/auto-mode:prompt-on-mode-toggle t)))

;;; Setting WebKit-specific settings. Not exactly the best way to
;;; configure Nyxt. See
;;; https://webkitgtk.org/reference/webkit2gtk/stable/WebKitSettings.html
;;; for the full list of settings you can tweak this way.
(defmethod ffi-buffer-make :after ((buffer nyxt::gtk-buffer))
  (let* ((settings (webkit:webkit-web-view-get-settings (nyxt::gtk-object buffer))))
    (setf
     ;; Resizeable textareas. It's not perfect, but still a cool feature to have.
     (webkit:webkit-settings-enable-resizable-text-areas settings) t
     ;; Write console errors/warnings to the shell, to ease debugging.
     ;; (webkit:webkit-settings-enable-write-console-messages-to-stdout settings) t
     ;; "Inspect element" context menu option available at any moment.
     (webkit:webkit-settings-enable-developer-extras settings) t
     ;; Use Cantarell-18 as the default font.
     (webkit:webkit-settings-default-font-family settings) "Cantarell"
     (webkit:webkit-settings-default-font-size settings) 18)))

#+nyxt-3
(define-configuration nyxt/reduce-tracking-mode:reduce-tracking-mode
  ((nyxt/reduce-tracking-mode:preferred-user-agent
    ;; Safari on Mac. Taken from
    ;; https://techblog.willshouse.com/2012/01/03/most-common-user-agents
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Safari/605.1.15")))

;;; reduce-tracking-mode has a preferred-user-agent slot that it uses
;;; as the User Agent to set when enabled. What I want here is to have
;;; the same thing as reduce-tracking-mode, but with a different User
;;; Agent.
#+nyxt-3
(define-mode chrome-mimick-mode (nyxt/reduce-tracking-mode:reduce-tracking-mode)
  "A simple mode to set Chrome-like Windows user agent."
  ((nyxt/reduce-tracking-mode:preferred-user-agent
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.69 Safari/537.36")))

#+nyxt-3
(define-mode firefox-mimick-mode (nyxt/reduce-tracking-mode:reduce-tracking-mode)
  "A simple mode to set Firefox-like Linux user agent."
  ((nyxt/reduce-tracking-mode:preferred-user-agent
    "Mozilla/5.0 (X11; Linux x86_64; rv:94.0) Gecko/20100101 Firefox/94.0")))
