;;; Compiled snippets and support files for `fundamental-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'fundamental-mode
                     '(("time" "`(current-time-string)`" "(current time)" nil nil nil nil nil nil)
                       ("mode" "`comment-start`-*- mode: ${1:mode} -*-`comment-end`" "mode" nil nil nil nil nil nil)
                       ("var" "`comment-start`-*- ${1:var}: ${2:value} -*-`comment-end`" "var" nil nil nil nil nil nil)
                       ("email" "`(replace-regexp-in-string \"@\" \"@NOSPAM.\" user-mail-address)`" "(user's email)" nil nil nil nil nil nil)
                       ("bash" "#!/bin/bash\n$0" "bash" nil nil nil nil nil nil)
                       ("!" "#!/usr/bin/env `(let ((found (ca-all-asscs interpreter-mode-alist major-mode))) (if found (yas/choose-value found) \"\"))`$0" "bang" nil nil nil nil nil nil)
                       ("_yas-setup.elc" ";ELC   \n;;; Compiled by vlad@vlad-W530 on Sat Aug  9 13:16:13 2014\n;;; from file /home/vlad/.emacs.d/elpa/yasnippet-20140729.1240/snippets/fundamental-mode/.yas-setup.el\n;;; in Emacs version 24.3.1\n;;; with all optimizations.\n\n;;; This file uses dynamic docstrings, first added in Emacs 19.29.\n\n;;; This file does not contain utf-8 non-ASCII characters,\n;;; and so can be loaded in Emacs versions earlier than 23.\n\n;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n\n\n#@58 returns a list of all corresponding values (like rassoc)\n(defalias 'ca-all-asscs #[(asslist query) \"\\204 \\302\\207@A	\\232\\203 @@\\303A	\\\"B\\207\\303A	\\\"\\207\" [asslist query nil ca-all-asscs] 4 (#$ . 559)])\n" "_yas-setup.elc" nil nil nil nil nil nil)
                       ("_yas-setup.el" "(defun ca-all-asscs (asslist query)\n  \"returns a list of all corresponding values (like rassoc)\"\n  (cond\n   ((null asslist) nil)\n   (t\n    (if (equal (cdr (car asslist)) query)\n        (cons (car (car asslist)) (ca-all-asscs (cdr asslist) query))\n      (ca-all-asscs (cdr asslist) query)))))\n" "_yas-setup.el" nil nil nil nil nil nil)))


;;; Do not edit! File generated at Tue Jun 13 15:07:06 2017
