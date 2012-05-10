;; FILE: /home/chu/.conf-scripts/emacs-dir/my-modes/custom-comments.el
;; AUTHOR: Matthew Ball (copyleft 2012)

;; COMMENT:
;; Welcome to custom-comments - A minor mode extension for GNU Emacs managing highlighting of custom comments.
;; The mode also allows users to examine the structure of their configuration files.
;; The user just needs to enter what words they would like highlighted into the variables:
;; - `custom-comment-tag-alist-comment' : for 'comment' related comments.
;; - `custom-comment-tag-alist-warning' : for 'warning' related comments.
;; The major modes for which this extension works are available in the variable `custom-comment-tag-mode-hooks'.

;; An example configuration would be:
;; (require 'custom-comments)
;; (setq custom-comment-suppress-init-message t)
;; (add-to-list custom-comment-tag-alist-comment "COMMENT")
;; (add-to-list custom-comment-tag-alist-warning "WARNING")
;; (activate-highlight-custom-comment-tags)

;; TODO:
;; Make the two variables `custom-comment-tag-alist-comment' and `custom-comment-tag-alist-warning' both empty to start off with, and let the user populate them as they see fit.
;; Make the variable `custom-comment-tag-mode-hooks' empty to start off with, and let the user populate it as they see fit.
;; Create new variables `custom-comment-tag-colour-comment' and `custom-comment-tag-colour-warning' which set the font lock face colour for their respective tags (so this "mode" might work as intended a non-Zenburn theme).
;; In the function `insert-custom-comment-tag', make sure we have available to use the `ido-completing-read' functionality.

;;; COMMENT: highlight custom comment tags
(defvar custom-comment-tag-alist-comment '("AUTHOR" "COMMENT" "FILE" "IMPORTANT" "NOTE" "TODO") "Available custom comment tags.")
(defvar custom-comment-tag-alist-warning '("BUG" "DEBUG" "ERROR" "FIX" "WARNING" "TEST") "Available custom warning tags.")
(defvar custom-comment-tag-alist (append custom-comment-tag-alist-comment custom-comment-tag-alist-warning) "Available custom tags.")

;; NOTE: there's some obvious commonality between these two "sets"
(defvar font-lock-custom-comment-tag-face-comment 'font-lock-custom-comment-tag-face-comment "Face name to use for `custom-comment-tag-alist-comment' tags.")

(defvar font-lock-custom-comment-tag-face-warning 'font-lock-custom-comment-tag-face-warning "Face name to use for `custom-comment-tag-alist-warning' tags.")

(defface font-lock-custom-comment-tag-face-comment '((t (:foreground "SpringGreen"))) "Font lock face to highlight custom `custom-comment-tag-alist-comment' tags." :group 'font-lock-faces)

(defface font-lock-custom-comment-tag-face-warning '((t (:foreground "OrangeRed"))) "Font lock face to highlight custom `custom-comment-tag-alist-warning' tags." :group 'font-lock-faces)

(defvar custom-comment-tag-mode-hooks
  '(emacs-lisp-mode-hook lisp-mode-hook shell-script-mode-hook sh-mode-hook haskell-mode-hook scheme-mode-hook cc-mode-hook c-mode-hook python-mode-hook)
  "Major modes which enable highlighting of custom comment tags.")

(defvar custom-comment-suppress-init-message nil "Suppress the printing of the initial activation message.")

(defun activate-highlight-custom-comment-tags (&rest junk)
  "Highlight custom comment tags in designated modes.
The custom comment \"tags\" are defined in the variable `custom-comment-tag-list'.
The \"designated\" modes are defined in the variable `custom-comment-tag-mode-hooks'."
  (setq temp-custom-comment-tag-alist-comment (concat "\\<" (regexp-opt custom-comment-tag-alist-comment) ":"))
  (setq temp-custom-comment-tag-alist-warning (concat "\\<" (regexp-opt custom-comment-tag-alist-warning) ":"))
  (mapc
   (lambda (mode-hook)
     (add-hook mode-hook
	       (lambda ()
		 (font-lock-add-keywords nil `((,temp-custom-comment-tag-alist-comment 0 font-lock-custom-comment-tag-face-comment t)))
		 (font-lock-add-keywords nil `((,temp-custom-comment-tag-alist-warning 0 font-lock-custom-comment-tag-face-warning t))))))
   custom-comment-tag-mode-hooks)
  (when (eq custom-comment-suppress-init-message nil)
    (message "Custom highlight tags activated.")))

(defun custom-comment-tag-regexp (&rest junk)
  "The \"optimised\" regular expresssion of the `custom-comment-tag-alist' list variable."
  (concat (regexp-opt custom-comment-tag-alist 'words) ":"))

(defun insert-custom-comment-tag (&rest junk)
  "Insert a custom comment tag (see: `custom-comment-tag-alist') in a source code file."
  (interactive)
  ;; (if (fboundp 'ido-completing-read) ;; NOTE: this is a check to make sure we have `ido-completing-read' available
  ;;     (message "ido-completing-read is available.")
  ;;   (message "ido-completing-read is not available."))
  (insert (concat "" (make-string 2 (aref comment-start 0)) " " (ido-completing-read "Insert comment tag: " custom-comment-tag-alist) ": ")))

(defun show-custom-comment-tag (&rest junk)
  "Show the custom comment tags (defined in the variable `custom-comment-tag-alist') in an outline-mode structure.
NOTE: This function depends on the multi-occur function `show-custom-structure'."
  (interactive)
  (show-custom-structure (custom-comment-tag-regexp)))

(defun occur-mode-clean-buffer ()
  "Removes all commentary from the `*Occur*' buffer, leaving the unadorned lines."
  (interactive)
  (if (get-buffer "*Occur*")
      (save-excursion
	(set-buffer (get-buffer "*Occur*"))
	(goto-char (point-min))
	(toggle-read-only 0)
	(if (looking-at "^[0-9]+ lines matching \"")
	    (kill-line 1))
	(while (re-search-forward "^[ \t]*[0-9]+:" (point-max) t)
	  (replace-match "")
	  (forward-line 1)))
    (message "There is no buffer named \"*Occur*\".")))

(defun search-string-under-point (&rest junk)
  "Search for the string under point across all buffers with the same extension."
  (interactive)
  (show-custom-structure (thing-at-point 'word)))

(defun search-string (string &rest junk) ;; TODO: accept regexps
  "Show the outline of all file containings the text STRING in a single directory."
  (interactive "sEnter search string: ")
  (show-custom-structure string))

(defun show-custom-structure (string &rest junk) ;; ERROR: seems to scan *all* buffers?
  "Show the outline structure of all files matching the same extension in a directory."
  (multi-occur-in-matching-buffers (file-name-extension (buffer-file-name)) string)
  ;; (occur-mode-clean-buffer) ;; ;; NOTE: clean up the occur-mode buffer
  (other-window 1))

;; COMMENT: insert a custom header text (i.e. FILE and AUTHOR tags)
(defun insert-custom-header-text (&rest junk) ;; NOTE: need (substring ...) otherwise we pick up the \n character
  "Insert the header string for a file."
  (interactive)
  (insert (concat (make-string 2 (aref comment-start 0)) " FILE: " (buffer-file-name) "\n"
		  (concat (make-string 2 (aref comment-start 0)) " AUTHOR: " (user-full-name)
			  " (copyleft " (substring (shell-command-to-string "date +\"%Y\"") 0 4) ")"))))

(defun show-dot-file-structure (&rest junk) ;; FIX: this currently only works for .el extensions (???)
  "Show the outline structure of all configuration files matching the same extension."
  (interactive)
  (show-custom-structure (concat "^" (make-string 3 (aref comment-start 0)) "+")))

(provide 'custom-comments)
