;; FILE: ~/.emacs.d/config-el/programming-config.el
;; AUTHOR: Matthew Ball (copyleft 2012)

;;; COMMENT: general programming
(defun turn-on-general-programming-mode ()
  "General function for programming modes."
  (modify-syntax-entry ?- "w") ;; treat '-' as part of the word
  ;; (flymake-mode) ;; turn on flymake mode
  (hs-minor-mode))

;;; COMMENT: emacs lisp programming
(autoload 'eldoc-mode "eldoc" "GNU Emacs lisp documentation minor mode." t)

(eldoc-add-command
 'paredit-backward-delete
 'paredit-close-round)

;; (add-hook 'after-save-hook  (lambda () ;; NOTE: automatically byte-compile .el files
;; 			      (if (eq major-mode 'emacs-lisp-mode)
;; 				  (save-excursion (byte-compile-file buffer-file-name)))))

(add-hook 'emacs-lisp-mode-hook '(lambda () ;; NOTE: active general programming mode
				   (turn-on-general-programming-mode)
				   (eldoc-mode t)))

;;; COMMENT: common lisp programming
(setq inferior-lisp-program "/usr/bin/sbcl")

(add-hook 'lisp-mode-hook '(lambda ()
			     ;; (slime-mode t)
			     (turn-on-general-programming-mode)))

;; (add-hook 'inferior-lisp-mode-hook '(lambda () ((inferior-slime-mode t))))

;;; COMMENT: slime/swank
;; IMPORTANT: requires `quicklisp' and (ql:quickload "quicklisp-slime-helper")
(add-to-list 'load-path "/home/chu/quicklisp/dists/quicklisp/software/slime-20120208-cvs") ;; TODO: this is not an ideal setup

(require 'slime-autoloads)

(slime-setup '(slime-fancy
	       slime-tramp
	       slime-banner
	       slime-compiler-notes-tree
	       slime-package-fu
	       slime-indentation
	       slime-repl
	       slime-editing-commands
	       slime-fancy-inspector
	       slime-fontifying-fu
	       slime-fuzzy
	       slime-mdot-fu
	       slime-scratch
	       slime-xref-browser
	       slime-asdf
	       ;; slime-autodoc
	       ;; slime-indentation-fu
	       slime-references
	       slime-sbcl-exts))

(setq slime-net-coding-system 'utf-8-unix
      slime-complete-symbol*-fancy t
      slime-complete-symbol-function 'slime-fuzzy-complete-symbol)

;; (defun start-slime-automatically () ;; automatically start slime when opening a lisp file
;;   (unless (slime-connected-p)
;;     (save-excursion (slime))))

;; (add-hook 'slime-mode-hook '(lambda ()
;; 			      (turn-on-general-programming-mode)
;; 			      (start-slime-automatically)))

;;; COMMENT: haskell programming
(autoload 'haskell-mode "haskell-site-file" "Major mode for editing haskell source code." t)

(setq haskell-font-lock-symbols t) ;; enable unicode symbols for haskell

(defun custom-turn-on-haskell-modes (&rest junk)
  (turn-on-haskell-doc-mode) ;; enable haskell's documentation mode
  (turn-on-haskell-indent)) ;; enable haskell's indentation mode

(add-hook 'haskell-mode-hook '(lambda ()
				(turn-on-general-programming-mode)
				(custom-turn-on-haskell-modes)))

;;; COMMENT: shell script
(autoload 'shell-script-mode "sh-mode" "Major mode for editing shell script source code." t)

(add-hook 'shell-script-mode '(lambda ()
				(turn-on-general-programming-mode)))

;;; COMMENT: python programming
(autoload 'python-mode "python" "Major mode for editing python source code." t)

(add-hook 'python-mode-hook '(lambda ()
			       (turn-on-general-programming-mode)))

;;; COMMENT: maxima
(autoload 'maxima-mode "maxima" "Major mode for interaction with maxima." t)
(autoload 'maxima "maxima" "Major mode for maxima interaction." t)
(autoload 'imaxima "imaxima" "Major mode frontend for maxima with image support." t)
(autoload 'imath-mode "imath" "Imath mode for math formula input." t)

(setq imaxima-use-maxima-mode-flag t)

(provide 'programming-config)
