;;; Compiled snippets and support files for `prog-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'prog-mode
                     '(("x" "`(yas-with-comment \"XXX: \")`" "xxx" nil nil nil nil nil nil)
                       ("t" "`(yas-with-comment \"TODO: \")`" "todo" nil nil nil nil nil nil)
                       ("fi" "`(yas-with-comment \"FIXME: \")`" "fixme" nil nil nil nil nil nil)
                       ("_yas-setup.elc" ";ELC   \n;;; Compiled by vlad@vlad-W530 on Sat Aug  9 13:16:13 2014\n;;; from file /home/vlad/.emacs.d/elpa/yasnippet-20140729.1240/snippets/prog-mode/.yas-setup.el\n;;; in Emacs version 24.3.1\n;;; with all optimizations.\n\n;;; This file uses dynamic docstrings, first added in Emacs 19.29.\n\n;;; This file does not contain utf-8 non-ASCII characters,\n;;; and so can be loaded in Emacs versions earlier than 23.\n\n;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n\n\n(defalias 'yas-with-comment #[(str) \"\\303\\304	\\n$\\207\" [comment-start str comment-end format \"%s%s%s\"] 5])\n" "_yas-setup.elc" nil nil nil nil nil nil)
                       ("_yas-setup.el" "(defun yas-with-comment (str)\n  (format \"%s%s%s\" comment-start str comment-end))\n" "_yas-setup.el" nil nil nil nil nil nil)))


;;; Do not edit! File generated at Tue Jun 13 15:07:06 2017
