;; Vladimir Feinberg
;; init.el

;; Notes/useful keyboard definitions
;; C-x C-o (delete-blank-lines)
;; C-<tab> (company-ycmd)
;; <backtab> or <shift>-<tab> (yas-expand)
;; C-c c (goto-last-change)
;; C-c v (goto-last-change-reverse)
;; M-r (isearch-backward-regexp)
;; M-s (isearch-forward-regexp)

;;; Code:

;; ----- Basic top-level packages -----

(require 'cc-mode)
(require 'thingatpt)
(require 'cl-lib)

;; suppress annoying abbrev-file question on startup
(setq save-abbrevs 'silently)
(quietly-read-abbrev-file)

;; ----- MELPA installation -----

;; Retrieve MELPA package info
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives
             '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))

(defvar cfg-var:packages '(
  yasnippet
  ycmd
  ido
  elpy
  exec-path-from-shell
  flycheck-ycmd
  goto-chg
  company-ycmd
  asm-mode
  python-mode
  py-autopep8
  matlab-mode
  markdown-mode
  haskell-mode
  tuareg
  merlin
  company-go
  golint
  ))

(defun cfg:install-packages ()
  (let ((pkgs (cl-remove-if #'package-installed-p cfg-var:packages)))
    (when pkgs
      (message "%s" "Emacs refresh packages database...")
        (package-refresh-contents)
        (message "%s" " done.")
        (dolist (p cfg-var:packages)
          (package-install p)))))

(package-initialize)
(cfg:install-packages)

;; ----- PATH -----

(require 'exec-path-from-shell)
(setq exec-path-from-shell-check-startup-files nil)
(exec-path-from-shell-initialize)

;; ----- GUI stuff -----

(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

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
(set-variable 'ycmd-global-config "~/dev/ycmd/cpp/ycm/.ycm_extra_conf.py")
(add-hook 'after-init-hook #'global-ycmd-mode)
(setq ycmd-idle-change-delay 0.03)
(set-variable 'ycmd-server-command
  (list "python" (concat (getenv "HOME") "/dev/ycmd/ycmd")))

(require 'company-ycmd)
(company-ycmd-setup)
(add-hook 'after-init-hook 'global-company-mode)

(global-set-key (kbd "C-<tab>") 'company-ycmd)

(global-set-key (kbd "C-M-SPC") 'company-complete)

(defun complete-or-indent ()
  (interactive)
  (if (company-manual-begin)
      (company-complete-common)
    (indent-according-to-mode)))

;; ----- Navigation -----

(require 'goto-chg)
(global-set-key (kbd "C-c c") 'goto-last-change)
(global-set-key (kbd "C-c v") 'goto-last-change-reverse)
(global-set-key (kbd "M-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-s") 'isearch-forward-regexp)
(defalias 'qrr 'query-replace-regexp)

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
  go-mode
  scala-mode
  python-mode
  c-mode
  haskell-mode))
(defun vlad/rm-whitespace ()
  "Remove trailing whitespace in saved buffer and untabifies."
  (when (member major-mode vlad/code-modes)
    (delete-trailing-whitespace)
    (unless (eq major-mode 'go-mode) (untabify (point-min) (point-max)))))
(add-hook 'before-save-hook 'vlad/rm-whitespace)

;; ----- Python -----

(setq exec-path (append exec-path '("/home/vlad/dev/miniconda3/bin")))

(elpy-enable)

; Remove electric indent for python
(defun electric-indent-ignore-python (char)
  "Ignore electric indentation for python.  CHAR is ignored."
  (if (equal major-mode 'python-mode)
      'no-indent
    nil))
(add-hook 'electric-indent-functions 'electric-indent-ignore-python)

(require 'py-autopep8)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

(defun set-newline-and-indent ()
  "Map the return key with `newline-and-indent'."
  (local-set-key (kbd "RET") 'newline-and-indent))
(add-hook 'python-mode-hook 'set-newline-and-indent)

;; ----- Go -----

; Required bash setup
; sudo apt -y install golang-go
; mkdir -p ~/dev/goprojects
; go get -u github.com/nsf/gocode
; go get -u github.com/golang/lint/golint

(let ((gosrc "~/dev/goprojects/src/github.com/")
      (gobin "~/dev/goprojects/bin/"))
  (let ((goemacs-src (concat gosrc "nsf/gocode/emacs-company"))
        (golint-src (concat gosrc "golang/lint/misc/emacs")))
    (when (cl-every 'identity
                    (mapcar 'file-exists-p (list goemacs-src golint-src gobin)))
      (add-to-list 'load-path goemacs-src)
      (require 'company-go)
      (add-hook 'go-mode-hook
                (lambda ()
                  (set (make-local-variable 'company-backends) '(company-go))
                            (company-mode)))
      (add-hook 'go-mode-hook (lambda ()
                                (setq indent-tabs-mode t)))
      (add-hook 'before-save-hook 'gofmt-before-save)
      (add-to-list 'exec-path gobin)
      (add-to-list 'load-path golint-src)
      (require 'golint))))

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
    ;; LaTeX
    ("\\.tex\\'" . latex-mode)
    ;; Markdown Extensions
    ("\\.markdown\\'" . markdown-mode)
    ("\\.md\\'" . markdown-mode)
    ("\\.go\\'" . go-mode))
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
(font-lock-add-keywords 'python-mode (font-lock-width-keyword 79))
(font-lock-add-keywords 'scala-mode (font-lock-width-keyword 100))

;; ----- Flycheck -----

(require 'flycheck-ycmd)
(flycheck-ycmd-setup)

(when (not (display-graphic-p))
  (setq flycheck-indication-mode nil))
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-clang-language-standard "c++11")
(setq-default flycheck-gcc-language-standard "c++11")

(add-hook 'python-mode-hook
          (lambda ()
            (progn
              (setq flycheck-checker 'python-pylint
                    flycheck-checker-error-threshold 900)
              (let ((lintrc
                     (locate-dominating-file (buffer-file-name) ".pylintrc")))
                (when lintrc
                  (setq flycheck-pylintrc (concat lintrc ".pylintrc")))))))

(defun my-inhibit-semantic-p ()
  (not (equal major-mode 'python-mode)))

(with-eval-after-load 'semantic
      (add-to-list 'semantic-inhibit-functions #'my-inhibit-semantic-p))

;; ----- Indentation -----

(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'python-mode-hook (function (lambda ()
  (setq indent-tabs-mode nil tab-width 2))))

;; ----- MATLAB -----

(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
 (add-to-list
  'auto-mode-alist
  '("\\.m$" . matlab-mode))
 (setq-default matlab-indent-function t)
(setq-default matlab-shell-command "matlab")

;; ----- Spelling -----

(require 'ispell)

(setq ispell-program-name "aspell")
(setq ispell-tex-skip-alists
      (list
       (append
    (car ispell-tex-skip-alists)
    '(
      ("[^\\]\\$" . "[^\\]\\$")
      ))
       (cadr ispell-tex-skip-alists)))

(defun md-ispell ()
  (make-local-variable 'ispell-skip-region-alist)
  (add-to-list 'ispell-skip-region-alist '("[\\][\\][[]" "[\\][\\][]]"))
  (add-to-list 'ispell-skip-region-alist '("[\\][\\][(]" "[\\][\\][)]"))
  (add-to-list 'ispell-skip-region-alist '("```" "```")))
(add-hook 'markdown-mode-hook 'md-ispell)

(require 'flyspell)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(defun markdown-flyspell-predicate ()
  (not (thing-at-point 'url)))
(put 'markdown-mode 'flyspell-mode-predicate 'markdown-flyspell-predicate)

;; ----- TeX -----

(setq-default TeX-command-BibTeX "Biber")
(setq-default TeX-parse-self t)

;; Local Variables:
;; flycheck-disabled-checkers: (emacs-lisp-checkdoc)
;; End:
(put 'set-goal-column 'disabled nil)
