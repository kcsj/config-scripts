;; FILE: ~/.emacs.d/config-el/general-config.el
;; AUTHOR: Matthew Ball (copyleft 2012)

;;; COMMENT: user variables
(defvar user-home-directory "~/" "Directory for user's home files.")

(defvar user-scripts-directory (concat user-home-directory ".conf-scripts/") "Directory for user's run-time scripts.")
(defvar user-documents-directory (concat user-home-directory "Documents/") "Directory for user's documents.")

(defvar user-audio-directory (concat user-home-directory "Music/") "Directory for user's music.")
(defvar user-video-directory (concat user-home-directory "Videos/") "Directory for user's videos.")

(defvar user-projects-directory (concat user-home-directory "Projects/") "Directory for user's projects.")
(defvar user-reading-directory (concat user-documents-directory "Reading/") "Directory for user's reading material.")
(defvar user-writing-directory (concat user-documents-directory "Writing/") "Directory for user's writing material.")
(defvar user-organisation-directory (concat user-documents-directory "Organisation/") "Directory for user's organisation files.")
(defvar user-university-directory (concat user-documents-directory "ANU/") "Directory for user's university files.")

(defvar user-org-university-file (concat user-organisation-directory "school.org") "File for user's university organisation.")
(defvar user-org-notes-file (concat user-organisation-directory "notes.org") "File for user's notes organisation.")
(defvar user-org-projects-file (concat user-organisation-directory "projects.org") "File for user's projects organisation.")
(defvar user-org-archive-file (concat user-organisation-directory "archive.org") "File for user's archive organisation.")

(defvar user-university-id "u4537508" "University ID for the user.")
(defvar user-primary-email-address "mathew.ball@gmail.com" "Primary email address for the user.")
(defvar user-secondary-email-address (concat user-university-id "@anu.edu.au") "Secondary email address for the user.")

;;; COMMENT: user functions
(defun eval-and-replace ()
  "Replace the preceding s-expression with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(defun occur-mode-clean-buffer ()
  "Removes all commentary from the *Occur* buffer, leaving the unadorned lines."
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

(defun insert-custom-header-text (&rest junk) ;; NOTE: need (substring ...) otherwise we pick up the \n character
  "Insert the header string for a file."
  (interactive)
  (insert (concat (make-string 2 (aref comment-start 0)) " FILE: " (buffer-file-name) "\n"
		  (concat (make-string 2 (aref comment-start 0)) " AUTHOR: " (user-full-name)
			  " (copyleft " (substring (shell-command-to-string "date +\"%Y\"") 0 4) ")"))))

(defun show-custom-structure (string &rest junk) ;; ERROR: seems to scan *all* buffers?
  "Show the outline structure of all files matching the same extension in a directory."
  (multi-occur-in-matching-buffers (file-name-extension (buffer-file-name)) string)
  ;; (occur-mode-clean-buffer) ;; ;; NOTE: clean up the occur-mode buffer
  (other-window 1))

(defun show-dot-file-structure (&rest junk) ;; FIX: this currently only works for .el extensions (???)
  "Show the outline structure of all configuration files matching the same extension."
  (interactive)
  (show-custom-structure (concat "^" (make-string 3 (aref comment-start 0)) "+")))

;;; COMMENT: highlight custom comment tags
(defvar font-lock-custom-comment-tag-face 'font-lock-custom-comment-tag-face "Face name to use for custom comment tags.")
(defface font-lock-custom-comment-tag-face '((t (:foreground "SpringGreen"))) "Font Lock mode face used to highlight custom comment tags." :group 'font-lock-faces)
(defvar custom-comment-tag-list '("AUTHOR" "BUG" "COMMENT" "DEBUG" "ERROR" "FILE" "FIX" "IMPORTANT" "NOTE" "TEST" "TODO" "WARNING") "Available custom comment tags.")
(defvar custom-comment-tag-mode-hooks
  '(emacs-lisp-mode-hook lisp-mode-hook shell-script-mode sh-mode-hook)
  "Major modes which enable highlighting of custom comment tags.")

;; TODO: Differentiate between `comment' and `todo' tags
;; (defvar font-lock-custom-comment-tag-face)
;; (defface font-lock-custom-comment-tag-face '((t (:foreground "SpringGreen"))))

;; (defvar font-lock-custom-todo-tag-face)
;; (defface font-lock-custom-todo-tag-face '((t (:foreground "OrangeRed"))))

(defun custom-comment-tag-regexp (&rest junk)
  "The \"optimised\" regular expresssion of the `custom-comment-tag-list' list variable."
  (concat (regexp-opt custom-comment-tag-list 'words) ":"))

(defun insert-custom-comment-tag (&rest junk) ;; TODO: there should be a check to make sure we have `ido-completing-read' available (???)
  "Insert a custom comment tag (see: `custom-comment-tag-list') in a source code file."
  (interactive)
  (insert (concat "" (make-string 2 (aref comment-start 0)) " " (ido-completing-read "Insert comment tag: " custom-comment-tag-list) ": ")))

(defun show-custom-comment-tag (&rest junk)
  "Show the custom comment tags (defined in the variable `custom-comment-tag-list') in an outline-mode structure.
This function depends on the multi-occur function `show-custom-structure'."
  (interactive)
  (show-custom-structure (custom-comment-tag-regexp)))

(defun activate-highlight-custom-comment-tags (&rest junk) ;; ERROR: the regxp produces a string with only single backslahes, but font-lock-keywords wants double back-slashes
  "Highlight custom comment tags in designated modes.
The custom comment \"tags\" are defined in the variable `custom-comment-tag-list'.
The \"designated\" modes are defined in the variable `custom-comment-tag-mode-hooks'."
  (mapc
   (lambda (mode-hook)
     (add-hook mode-hook
	       (lambda ()
		 (font-lock-add-keywords nil
					 ;; '(((custom-comment-tag-regexp) 0 font-lock-custom-comment-tag-face t)))))) ;; ERROR: doesn't work
					 '(("\\<\\(AUTHOR\\|BUG\\|COMMENT\\|DEBUG\\|ERROR\\|FI\\(?:LE\\|X\\)\\|IMPORTANT\\|NOTE\\|T\\(?:EST\\|ODO\\)\\|WARNING\\):"
					    1 font-lock-custom-comment-tag-face t))))));; FIX: this string should not be hardcoded
   custom-comment-tag-mode-hooks)
  (message "Custom highlight tags activated."))

(activate-highlight-custom-comment-tags) ;; NOTE: activate custom comment tags

;; TODO: move this somewhere ... (automatically generate it if possible)
;; TODO: this needs to be cleaned up ...
;; (defvar config-files (list 'appearance-config
;; 			   'dired-config
;; 			   'erc-config
;; 			   'eshell-config
;; 			   'general-config
;; 			   'gnus-config
;; 			   'key-bindings-config
;; 			   'latex-config
;; 			   'org-config
;; 			   'package-config
;; 			   'programming-config
;; 			   'user-config) "Stores a list of the names of the configuration files.")

;; (defun open-emacs-config-files (&rest junk))
;; (defun open-stumpwm-config-files (&rest junk))
;; (defun open-bash-config-files (&rest junk))
;; (defun open-config-files (&rest junk) ;; TODO: extend this to all configuration files
;;   "Opens all GNU Emacs user configuration files."
;;   (interactive)
;;   (find-file (concat (expand-file-name user-emacs-directory) "init.el"))
;;   (mapc (lambda (config-file)
;; 	  (find-file (concat (expand-file-name user-emacs-directory) "config-el/" (symbol-name config-file) ".el")))
;; 	config-files))

;; TODO: this needs to be changed ...
;; TODO: could probably be a function which opens the config-el directory ...
(defun switch-to-dot-emacs (&rest junk) ;; NOTE: this function serves no purpose anymore ... consider removing this function ... (???)
  "Switch to init.el file (or evaluate the buffer if the init.el file is present)."
  (interactive)
  ;; (config files)
  (if (equal (buffer-name) "init.el")
      (eval-buffer) ;; evaluate the current buffer
    (find-file (concat (expand-file-name user-emacs-directory) "init.el")))) ;; switch to the init.el file

(defun display-startup-echo-area-message (&rest junk)
  "Clear the message buffer initially."
  (message ""))

;;; COMMENT: default variable values
(setq inhibit-startup-message t ;; turn off startup message
      inhibit-startup-echo-area-message t ;; turn off startup echo area message
      initial-scratch-message (concat ";; For information about "
				      (substring (emacs-version) 0 16)
				      " and the GNU system, type C-h C-a.\n\n") ;; initial scratch message
      completion-ignore-case t ;; ignore case in auto-completing text
      read-file-name-completion-ignore-case t ;; ignore cases in filenames
      auto-compression-mode 1 ;; automatically parse an archive
      message-log-max 2000 ;; maximum number of lines to keep in the message log buffer (default is 100)
      show-trailing-whitespace 1 ;; show trailing whitespace
      scroll-margin 0 ;; use smooth scrolling
      scroll-conservatively 100000 ;; ... the defaults
      scroll-up-aggressively 0 ;; ... are very
      scroll-down-aggressively 0 ;; ... annoying
      scroll-preserve-screen-position t ;; preserve screen position with C-v/M-v
      auto-save-interval 1000 ;; change auto-save interval from 300 to 1000 keystrokes
      sentence-end-double-space 'nil ;; sentences end with a single space
      echo-keystrokes 0.1 ;; see what you are typing
      suggest-key-bindings nil) ;; do not show respective key-bindings

;;; COMMENT: default auto-mode list
;; (add-to-list 'auto-mode-alist '(".screenrc" . shell-script-mode)) ;; open .screenrc in shell script mode
;; (add-to-list 'auto-mode-alist '(".bash_aliases" . shell-script-mode)) ;; open .bash_aliases in shell script mode
;; (add-to-list 'auto-mode-alist '(".mpdconf/" . shell-script-mode)) ;; open any file in .mpdconf/ in shell script mode
;; (add-to-list 'auto-mode-alist '(".emacs" . emacs-lisp-mode)) ;; open .emacs in emacs lisp mode
;; (add-to-list 'auto-mode-alist '(".stumpwmrc$" . stumpwm-mode)) ;; open .stumpwmrc in stumpwm mode
;; (add-to-list 'auto-mode-alist '(".conkerorrc/" . javascript-mode)) ;; open any file in .conkerorrc/ in javaescript mode
(add-to-list 'auto-mode-alist '("bashrc" . shell-script-mode)) ;; open bashrc file in shell script mode
(add-to-list 'auto-mode-alist '("stumpwmrc" . common-lisp-mode)) ;; open stumpwmrc file in common lisp mode
;; (add-to-list 'auto-mode-alist '("stumpwmrc" . stumpwm-mode)) ;; open stumpwmrc file in stumpwm mode
(add-to-list 'auto-mode-alist '("README$" . org-mode)) ;; open README files in org-mode
(add-to-list 'auto-mode-alist '("NEWS$" . org-mode)) ;; open NEWS files in org-mode
(add-to-list 'auto-mode-alist '("/mutt" . mail-mode)) ;; open mutt-related buffers in mail mode
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode)) ;; open *.org files in org-mode
(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode)) ;; open *.js files in javascript mode
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode)) ;; open *.hs files in haskell mode
(add-to-list 'auto-mode-alist '("\\.cabal$" . haskell-cabal-mode)) ;; open *.cabal files in haskell cabal mode
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode)) ;; open *.py files in python mode
(add-to-list 'auto-mode-alist '("\\.cs$" . csharp-mode)) ;; open *.cs files in c# mode
(add-to-list 'auto-mode-alist '("\\.tex$" . LaTeX-mode)) ;; open *.tex files in LaTeX mode
(add-to-list 'auto-mode-alist '("\\.doc\\'" . no-word)) ;; open word documents with antiword
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode)) ;; open *.lua files in lua mode
(add-to-list 'auto-mode-alist '("\\.ot$" . otter-mode)) ;; open *.ot files in otter mode
(add-to-list 'auto-mode-alist '("\\.in$" . otter-mode)) ;; open *.in files in otter mode
(add-to-list 'interpreter-mode-alist '("python" . python-mode)) ;; open python files in a psuedo-python interpreter

;;; COMMENT: selection
(delete-selection-mode 1) ;; replace (delete) selected region

;;; COMMENT: ido mode
(require 'ido)
(require 'ido-ubiquitous)

(ido-mode 'both) ;; turn on interactive mode (files and buffers)
(ido-ubiquitous-mode t)

(setq ido-enable-flex-matching t ;; enable fuzzy matching
      ido-everywhere t ;; enable ido everywhere
      ido-create-new-buffer 'always ;; create new buffers (if name does not exist)
      ido-ignore-extensions t ;; ignore extentions
      ido-ignore-buffers '("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido" "^\*trace" "^\*compilation" "^\*GTAGS" "^session\.*" "^\*") ;; ignore
      ido-work-directory-list `(,(expand-file-name user-home-directory)
      				,(expand-file-name user-documents-directory)
      				,(expand-file-name user-university-directory)
      				,(expand-file-name user-organisation-directory))
      ido-case-fold t ;; enable case-insensitivity
      ido-enable-last-directory-history t ;; enable directory history
      ido-max-work-directory-list 30 ;; remember last used directories
      ido-max-work-file-list 50 ;; ... and files
      ido-max-prospects 8 ;; don't spam the mini buffer
      confirm-nonexistent-file-or-buffer nil) ;; the confirmation is rather annoying

(defun recentf-ido-find-file () ;; replace recentf-open-files
  "Find a recent file using Ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file (find-file file))))

(defun ido-goto-symbol (&optional symbol-list)
  "Refresh imenu and jump to a place in the buffer using Ido."
  (interactive)
  (unless (featurep 'imenu)
    (require 'imenu nil t))
  (cond
   ((not symbol-list)
    (let ((ido-mode ido-mode)
	  (ido-enable-flex-matching
	   (if (boundp 'ido-enable-flex-matching)
	       ido-enable-flex-matching t))
	  name-and-pos symbol-names position)
      (unless ido-mode
	(ido-mode 1)
	(setq ido-enable-flex-matching t))
      (while (progn
	       (imenu--cleanup)
	       (setq imenu--index-alist nil)
	       (ido-goto-symbol (imenu--make-index-alist))
	       (setq selected-symbol (ido-completing-read "Goto symbol: " symbol-names))
	       (string= (car imenu--rescan-item) selected-symbol)))
      (unless (and (boundp 'mark-active) mark-active)
	(push-mark nil t nil))
      (setq position (cdr (assoc selected-symbol name-and-pos)))
      (cond
       ((overlayp position)
	(goto-char (overlay-start position)))
       (t
	(goto-char position)))))
   ((listp symbol-list)
    (dolist (symbol symbol-list)
      (let (name position)
	(cond
	 ((and (listp symbol) (imenu--subalist-p symbol))
	  (ido-goto-symbol symbol))
	 ((listp symbol)
	  (setq name (car symbol))
	  (setq position (cdr symbol)))
	 ((stringp symbol)
	  (setq name symbol)
	  (setq position
		(get-text-property 1 'org-imenu-marker symbol))))
	(unless (or (null position) (null name)
		    (string= (car imenu--rescan-item) name))
	  (add-to-list 'symbol-names name)
	  (add-to-list 'name-and-pos (cons name position))))))))

(defvar ido-enable-replace-completing-read t
  "If t, use ido-completing-read instead of completing-read if possible.
    Set it to nil using let in around-advice for functions where the
    original completing-read is required.  For example, if a function
    foo absolutely must use the original completing-read, define some
    advice like this:

    (defadvice foo (around original-completing-read-only activate)
      (let (ido-enable-replace-completing-read) ad-do-it))")

(defadvice completing-read ;; replace completing-read wherever possible, unless directed otherwise
  (around use-ido-when-possible activate)
  (if (or (not ido-enable-replace-completing-read) ;; manual override disable ido
	  (and (boundp 'ido-cur-list)
	       ido-cur-list)) ;; avoid infinite loop from ido calling this
      ad-do-it
    (let ((allcomp (all-completions "" collection predicate)))
      (if allcomp
	  (setq ad-return-value
		(ido-completing-read prompt allcomp nil require-match initial-input hist def))
	ad-do-it))))

;;; COMMENT: smex mode
(require 'smex)
(setq smex-save-file (concat user-emacs-directory "smex-items"))
(smex-initialize) ;; super-charge ido mode

;;; COMMENT: ibuffer
(require 'ibuffer)

(setq ibuffer-saved-filter-groups
      `(("default"
	 ("Configuration" ;; run-time configuration related buffers
	  (or (filename . ,(expand-file-name user-emacs-directory))
	      (filename . ,(expand-file-name user-scripts-directory))))
	 ("University" ;; university related buffers
	  (filename . ,(expand-file-name user-university-directory)))
	 ("Reading" ;; reading (material and notes) related buffers
	  (or (filename . ,(expand-file-name user-reading-directory))
	      (mode . doc-view-mode)))
	 ("Writing" ;; writing related buffers
	  (filename . ,(expand-file-name user-writing-directory)))
	 ("Projects" ;; project related buffers
	  (filename . ,(expand-file-name user-projects-directory)))
	 ("Programming" ;; programming related buffers
	  (or (mode . c-mode)
	      (mode . c++-mode)
	      (mode . haskell-mode)
	      (mode . inferior-haskell-mode)
	      (mode . python-mode)
	      (mode . inferior-python-mode)
	      (mode . lisp-mode)
	      (mode . common-lisp-mode)
	      (mode . emacs-lisp-mode)
	      (mode . inferior-lisp-mode)
	      (mode . repl-mode)
	      (mode . slime-mode)
	      (mode . inferior-slime-mode)
	      (mode . fuzzy-completions-mode)
	      (mode . html-mode)
	      (mode . css-mode)
	      (mode . javascript-mode)
	      (mode . scheme-mode)
	      (mode . inferior-scheme-mode)
	      (name . "^\\*slime-events\\*$")
	      (name . "^\\*slime-threads\\*$")
	      (name . "^\\*slime-connections\\*$")
	      (name . "^\\*slime-repl sbcl\\*$")
	      (name . "^\\*slime-compilation\\*$")
	      (name . "^\\*inferior-lisp\\*$")))
	 ("Organisation" ;; org-mode related buffers
	  (or (mode . org-mode)
	      (mode . org-agenda-mode)
	      (mode . calendar-mode)
	      (mode . diary-mode)
	      (filename . ,(expand-file-name user-organisation-directory))))
	 ("ERC" ;; erc related buffers
	  (mode . erc-mode))
	 ("Web Browser" ;; w3m related buffers
	  (mode . w3m-mode))
	 ("File Manager" ;; dired related buffers
	  (or (mode . dired-mode)
	      (name . "^\\*Dired log\\*$")))
	 ("Shell" ;; shell related buffers
	  (or (mode . eshell-mode)
	      (mode . shell-mode)
	      (mode . term-mode)
	      (mode . locate-mode)))
	 ("Mathematics and Science" ;; buffers related to mathematics and science
	  (or (mode . calculator-mode)
	      (mode . calc-mode)
	      (mode . calc-trail-mode)
	      (mode . maxima-mode)
	      (mode . inferior-maxima-mode)))
	 ("Mail and News" ;; mail (and news) related buffers
	  (or (mode . gnus-group-mode)
	      (mode . gnus-topic-mode)
	      (mode . gnus-browse-mode)
	      (mode . gnus-summary-mode)
	      (mode . gnus-article-mode)
	      (mode . gnus-edit-form-mode)
	      (mode . message-mode)
	      (name . "^\\*gnus trace\\*$")
	      (filename . ".newsrc-dribble$")))
	 ("Information" ;; info related buffers
	  (or (mode . info-mode)
	      (mode . Info-mode)
	      (mode . apropos-mode)
	      (mode . Help-Mode)
	      (mode . help-mode)
	      (mode . Man-mode)
	      (mode . woman-mode)))
	 ("Process Manager" ;; process manager related buffers
	  (or (mode . proced-mode)
	      (mode . process-menu-mode)))
	 ("Version Control" ;; version control related buffers
	  (or (mode . diff-mode)
	      (mode . magit-status-mode)
	      (mode . magit-key-mode)
	      (mode . magit-log-edit-mode)
	      (mode . vc-mode)
	      (mode . vc-dir-mode)
	      (mode . vc-log-entry-mode)
	      (name . "^\\*magit-process\\*$")
	      (name . "^\\*magit-log-edit\\*$")))
	 ("Package Management" ;; apt-mode and elpa related buffers
	  (or (mode . apt-mode)
	      (mode . package-menu-mode)
	      (name . "^\\*Package Info\\*$")))
	 ("Miscellaneous" ;; miscellaneous special buffers
	  (or (mode . occur-mode)
	      (mode . customize-mode)
	      (mode . Custom-mode)
	      (mode . completion-list-mode)
	      (name . "\\*scratch\\*$")
	      (name . "\\*Messages\\*$")
	      (name . "\\*Keys\\*$")
	      (name . "\\*Disabled Command\\*$")
	      ;; (name . "\\*Process List\\*$")
	      (name . "\\*Help\\*$")
	      (name . "\\*Org PDF LaTeX Output\\*$"))))))

(setq ibuffer-show-empty-filter-groups nil ;; do not display empty groups
      ibuffer-default-sorting-mode 'major-mode ;; sort buffers by major-mode
      ibuffer-expert t ;; don't ask for confirmation
      ibuffer-shrink-to-minimum-size t
      ibuffer-always-show-last-buffer nil
      ibuffer-sorting-mode 'recency
      ibuffer-use-header-line t)

(add-hook 'ibuffer-mode-hook (lambda ()
			       (ibuffer-auto-mode 1) ;; automatically update buffer list
			       (ibuffer-switch-to-saved-filter-groups "default")))

;;; COMMENT: auto-complete mode
(when (require 'auto-complete-config nil 'noerror)
  (add-to-list 'ac-dictionary-directories (concat (expand-file-name user-emacs-directory) "ac-dict"))
  (setq ac-comphist-file (concat (expand-file-name user-emacs-directory) "ac-comphist.dat"))
  (ac-config-default))

(setq ac-auto-start 5 ;; start auto-complete after five characters
      ac-ignore-case t ;; always ignore case
      ac-auto-show-menu t) ;; automatically show menu

(set-face-background 'ac-candidate-face "lightgray")
(set-face-underline 'ac-candidate-face "darkgray")
(set-face-background 'ac-selection-face "steelblue")

(ac-flyspell-workaround) ;; apparently the flyspell-mode process disables auto-completion

(define-globalized-minor-mode real-global-auto-complete-mode ;; dirty fix for having AC everywhere
  auto-complete-mode (lambda ()
                       (if (not (minibufferp (current-buffer)))
			   (auto-complete-mode 1))))

(real-global-auto-complete-mode t)

;;; COMMENT: smart tab
(defun smart-tab () ;; implement a smarter TAB
  "This smart tab is minibuffer compliant: it acts as usual in the minibuffer.
 Else, if mark is active, indents region. Else if point is at the end of a symbol, expands it.
 Else indents the current line."
  (interactive)
  (if (minibufferp)
      (unless (minibuffer-complete)
	(auto-complete nil)) ;; use auto-complete
	;; (hippie-expand nil)) ;; use hippie-expand
	;; (dabbrev-expand nil)) ;; use dabbrev-expand
    (if mark-active
	(indent-region (region-beginning)
		       (region-end))
      (if (looking-at "\\_>")
	  (auto-complete nil) ;; use auto-complete
	  ;; (hippie-expand nil)) ;; use hippie-expand
	  ;; (dabbrev-expand nil) ;; use dabbrev-expand
	(indent-for-tab-command)))))

;;; COMMENT: enable/disable functions
(put 'overwrite-mode 'disabled t) ;; disable overwrite mode

;;; COMMENT: mini buffer
(file-name-shadow-mode t) ;; be smart about filenames in the mini buffer
(fset 'yes-or-no-p 'y-or-n-p) ;; changes all yes/no questions to y/n
(savehist-mode t) ;; keep mini buffer history between session

;;; COMMENT: stumpwm mode
(autoload 'stumpwm-mode "/usr/share/doc/stumpwm/stumpwm-mode" "Major mode for editing StumpWM." t)

;; FIX: this doesn't appear to work ...
;;; COMMENT: single line copy
;; (defadvice kill-ring-save (before slick-copy activate compile)
;;   "When called interactively with no active region, copy a single line instead."
;;   (interactive
;;     (if mark-active (list (region-beginning) (region-end))
;;       (message "Copied line")
;;       (list (line-beginning-position) (line-beginning-position 2)))))

;; FIX: this doesn't appear to work ...
;;; COMMENT: single line cut
;; (defadvice kill-region (before slick-cut activate compile)
;;   "When called interactively with no active region, kill a single line instead."
;;   (interactive
;;     (if mark-active (list (region-beginning) (region-end))
;;       (message "Killed line")
;;       (list (line-beginning-position) (line-beginning-position 2)))))

;;; COMMENT: tramp
(autoload 'tramp "Remote file manipulation with Tramp." t)
(setq tramp-default-method "ssh") ;; use ssh for tramp

;;; COMMENT: version control
(autoload 'magit-status "magit" "Version control with Git." t) ;; magit for use with github

(setq magit-save-some-buffers t ;; ask me to save buffers before running magit-status
      magit-process-popup-time 4) ;; Popup the process buffer if command takes too long

;;; COMMENT: backups
(setq-default delete-old-versions t) ;; delete excess file backups silently

(setq ;; backup-by-copying t ;; don't clobber symlinks
      ;; backup-inhibited t ;; disable backup
      ;; auto-save-default nil ;; disable auto save
      backup-directory-alist `(("." . ,(concat (expand-file-name user-emacs-directory) "save-files"))) ;; don't litter the fs
      kept-new-versions 6
      kept-old-versions 2
      version-control t) ;; use versioned backups

;;; COMMENT: recent files
;; (require 'recentf)
(autoload 'recentf-mode "recentf" "Recent files." t)

(setq recentf-save-file (concat (expand-file-name user-emacs-directory) "recentf") ;; recently saved files
      recentf-max-saved-items 500 ;; maximum saved items is 500
      recentf-max-menu-items 25) ;; maximum 25 files in menu

(recentf-mode t)

;;; COMMENT: desktop save mode
(autoload 'desktop-save-mode "desktop" "Save session file." t)

(desktop-save-mode 1) ;; enable desktop save mode

(setq desktop-path `(,(expand-file-name user-emacs-directory))
      desktop-dirname (expand-file-name user-emacs-directory)
      desktop-base-file-name "emacs-desktop"
      history-length 250)

(add-to-list 'desktop-globals-to-save 'file-name-history)

(setq desktop-globals-to-save ;; save a bunch of variables to the desktop file (for lists specify the len of the maximal saved data also)
      (append '((extended-command-history . 30)
                (file-name-history        . 100)
                (grep-history             . 30)
                (compile-history          . 30)
                (minibuffer-history       . 50)
                (query-replace-history    . 60)
                (read-expression-history  . 60)
                (regexp-history           . 60)
                (regexp-search-ring       . 20)
                (search-ring              . 20)
                (shell-command-history    . 50)
                tags-file-name
                register-alist)))

(defun emacs-process-p (pid) ;; over-ride stale lock
  "If pid is the process ID of an emacs process, return t, else nil. Also returns nil if pid is nil."
  (when pid
    (let* ((cmdline-file (concat "/proc/" (int-to-string pid) "/cmdline")))
      (when (file-exists-p cmdline-file)
        (with-temp-buffer
          (insert-file-contents-literally cmdline-file)
          (goto-char (point-min))
          (search-forward "emacs" nil t) pid)))))

(defadvice desktop-owner (after pry-from-cold-dead-hands activate)
  "Don't allow dead emacsen to own the desktop file."
  (when (not (emacs-process-p ad-return-value))
    (setq ad-return-value nil)))

;;; COMMENT: paredit
(autoload 'paredit-mode "paredit" "Minor mode for pseudo-structurally editing Lisp code." t)

(defun override-slime-repl-bindings-with-paredit () ;; stop SLIME's REPL from grabbing DEL, which is annoying when backspacing over a '('
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))

;; TODO: move hooks to programming-config.el
(add-hook 'emacs-lisp-mode-hook (lambda () (paredit-mode t)))
(add-hook 'lisp-mode-hook (lambda () (paredit-mode t)))
(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode t)))
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode t)))
(add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)

;;; COMMENT: flyspell
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checking" t)
(autoload 'flyspell-delay-command "flyspell" "Delay on command." t)
(autoload 'tex-mode-flyspell-verify "flyspell" "" t)

(add-hook 'text-mode-hook 'turn-on-flyspell) ;; turn on automatic spell check if in a text-mode

;;; COMMENT: ispell
(setq ispell-program-name "aspell" ;; use aspell for automatic spelling
      ispell-parser 'tex
      ispell-extra-args '("--sug-mode=ultra"))

;;; COMMENT: docview
(setq doc-view-continuous t)

;;; COMMENT: ansi-terminal
(defun symbol-value-in-buffer (sym buf)
  "Return the value of 'sym' in 'buf'."
  (save-excursion
    (with-current-buffer buf
      (symbol-value sym))))

(defun start-term (&rest junk)
 "Start an `ansi-term' shell in the directory of current buffer."
 (ansi-term "/bin/bash")
 ;; (term-line-mode)
 (message "Starting terminal session."))

(defun switch-term (&rest junk)
  "Switch to an active shell (if one exists) or create a new shell (if none exists)."
  (interactive)
  (let ((found nil))
    (loop for b in (buffer-list)
	  if (eq (symbol-value-in-buffer 'major-mode b) 'term-mode)
	  do (switch-to-buffer b) (setq found t))
    (when (not found) (start-term))))

(defun kill-term (&rest junk)
  "Close an ansi shell session and kill the remaining buffer."
  (interactive)
  (when (equal major-mode (or 'term-mode 'eshell-mode))
      (progn
	(term-kill-subjob)
	(kill-buffer))))

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(provide 'general-config)
