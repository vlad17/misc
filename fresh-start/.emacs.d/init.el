;;; package --- Summary: my init file
;;; Commentary:
;; Vladimir Feinberg
;; init.el
;;; Code:

;; ----- Basic top-level packages -----

(require 'cc-mode)

;; ----- MELPA installation -----

;; Retrieve MELPA package info
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

;; ----- Autocomplete -----

;; Turn on yasnippet
(require 'yasnippet)
(setq yas-snippet-dirs '"~/.emacs.d/snippets")
(yas-global-mode 1)
;; Remove Yasnippet's default tab key binding
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
;; Set Yasnippet's key binding to shift+tab
(define-key yas-minor-mode-map (kbd "<backtab>") 'yas-expand)

;; YCMD client
(require 'ycmd)
(set-variable 'ycmd-global-config "/home/vlad/dev/ycmd/cpp/ycm/.ycm_extra_conf.py")
(add-hook 'after-init-hook #'global-ycmd-mode)
(setq ycmd-idle-change-delay 0.03)
(set-variable 'ycmd-server-command '("python2" "/home/vlad/dev/ycmd/ycmd"))

(require 'company-ycmd)
(company-ycmd-setup)
(add-hook 'after-init-hook 'global-company-mode)

(defun complete-or-indent ()
  (interactive)
  (if (company-manual-begin)
      (company-complete-common)
    (indent-according-to-mode)))

;; Make sure semantic's off, and install ac clang async
(semantic-mode 0) ; too slow

;; ----- Navigation -----

(require 'goto-chg)
(global-set-key (kbd "C-c c") 'goto-last-change)
(global-set-key (kbd "C-c v") 'goto-last-change-reverse)

;; ------ OCaml -----

(defvar merlin-use-auto-complete-mode)
(defvar merlin-error-after-save)
(add-hook 'tuareg-mode-hook 'tuareg-imenu-set-imenu)
(setq auto-mode-alist
      (append '(("\\.ml[ily]?$" . tuareg-mode)
                ("\\.topml$" . tuareg-mode))
              auto-mode-alist))
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
(add-hook 'tuareg-mode-hook 'merlin-mode)
(setq merlin-use-auto-complete-mode t)
(setq merlin-error-after-save nil)

;; ----- Merlin -----

(defvar opam-share)
(setq opam-share (substring (shell-command-to-string "opam config var share") 0 -1))
(add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))
(require 'merlin)

;; Enable Merlin for ML buffers
(add-hook 'tuareg-mode-hook 'merlin-mode)

;; So you can do it on a mac, where `C-<up>` and `C-<down>` are used
;; by spaces.
(define-key merlin-mode-map
  (kbd "C-c <up>") 'merlin-type-enclosing-go-up)
(define-key merlin-mode-map
  (kbd "C-c <down>") 'merlin-type-enclosing-go-down)
(set-face-background 'merlin-type-face "#88FF44")

;; Setup environment variables using opam
;(dolist
;   (var (car (read-from-string
;           (shell-command-to-string "opam config env --sexp"))))
; (setenv (car var) (cadr var)))
;; Update the emacs path
;(setq exec-path (split-string (getenv "PATH") path-separator))
;; Update the emacs load path
;(push (concat (getenv "OCAML_TOPLEVEL_PATH")
;          "/../../share/emacs/site-lisp") load-path)
;; Automatically load utop.el
;(autoload 'utop "utop" "Toplevel for OCaml" t)
;(autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
;(add-hook 'tuareg-mode-hook 'utop-minor-mode)

;; ----- Assembly mode -----

(defvar asm-comment-char)
(add-hook 'asm-mode-hook (lambda ()
  (setq indent-tabs-mode nil) ; use spaces to indent
  (electric-indent-mode -1) ; indentation in asm-mode is annoying
  ; you can use `comment-dwim' (M-;) for this kind of behaviour anyway
  (local-unset-key (vector asm-comment-char))
  ; asm-mode sets it locally to nil, to "stay closer to the old TAB behaviour".
  (setq tab-always-indent (default-value 'tab-always-indent))
  (setq tab-stop-list (number-sequence 2 60 2))))
(add-hook 'asm-mode-hook #'my-asm-mode-hook)

;; ----- Whitespace and Indentation -----

;; Auto indent on newline in c-mode (swap with C-j)
(defun swap-newline-kbd ()
  "Swaps roles for \\RET and \\C-\\j]."
  (local-set-key (kbd "RET") 'newline-and-indent)
  (local-set-key (kbd "C-j") 'newline))
(add-hook 'c-mode-common-hook 'swap-newline-kbd)
(add-hook 'asm-mode-hook 'swap-newline-kbd)

;; No tabs
(setq-default indent-tabs-mode nil)

;; Remove whitespace on save for some modes
(defvar vlad/code-modes)
(setq vlad/code-modes '(
  emacs-lisp-mode
  lisp-mode
  c++-mode
  scala-mode
  python-mode
  c-mode
  haskell-mode))
(defun vlad/rm-whitespace ()
  "Remove trailing whitespace in saved buffer and untabifies."
  (when (member major-mode vlad/code-modes)
    (delete-trailing-whitespace)
    (untabify (point-min) (point-max))))
(add-hook 'before-save-hook 'vlad/rm-whitespace)

;; ----- Display -----

;; Default theme folder
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; Zenburn
(load-theme 'zenburn 1)

;; No startup screen
(setq inhibit-startup-screen 1)

;; ----- File name extensions -----

(setq auto-mode-alist
  (append '(
    ;; Additional C++ file name extensions
    ("\\.h\\'" . c++-mode)
    ("\\.tpp\\'" . c++-mode)
    ("\\.include\\'" . c++-mode)
    ;; OCaml extentions
    ("\\.ml[ily]?\\'" . tuareg-mode)
    ("\\.topml\\'" . tuareg-mode)
    ;; Scala
    ("\\.scala\\'" . scala-mode)
    ;; Haskell
    ("\\.hs\\'" . haskell-mode)
    ;; Markdown Extensions
    ("\\.markdown\\'" . markdown-mode)
    ("\\.md\\'" . markdown-mode))
    auto-mode-alist))

;; ----- Misc convenience tools -----

;; Show column number in mode bar
(column-number-mode 1)

;; Set up ido mode
(require 'ido)
(ido-mode 1)

(defun font-lock-width-keyword (width)
  "Return a font-lock style keyword for a string beyond width WIDTH."
  `((,(format "^%s\\(.+\\)" (make-string width ?.))
     (1 font-lock-warning-face t))))

(font-lock-add-keywords 'c++-mode (font-lock-width-keyword 80))
(font-lock-add-keywords 'python-mode (font-lock-width-keyword 100))
(font-lock-add-keywords 'scala-mode (font-lock-width-keyword 100))

;; ----- Flycheck -----

(require 'flycheck-ycmd)
(flycheck-ycmd-setup)

(when (not (display-graphic-p))
  (setq flycheck-indication-mode nil))
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-clang-language-standard "c++11")
(setq-default flycheck-gcc-language-standard "c++11")

;; ----- Indentation -----

(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'python-mode-hook (function (lambda ()
  (setq indent-tabs-mode nil tab-width 2))))

;; ----- Extend package archives -----
(custom-set-variables
 '(package-archives (quote (("melpa" . "http://melpa.milkbox.net/packages/") ("gnu" . "http://elpa.gnu.org/packages/") ("melpa-stable" . "http://stable.melpa.org/packages/")))))

;; provide init just to please flycheck...
(provide 'init)
;;; init ends here
