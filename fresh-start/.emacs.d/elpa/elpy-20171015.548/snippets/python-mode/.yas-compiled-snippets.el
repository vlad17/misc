;;; Compiled snippets and support files for `python-mode'
;;; contents of the .yas-setup.el support file:
;;;
(defun elpy-snippet-split-args (arg-string)
  "Split a python argument string into ((name, default)..) tuples"
  (mapcar (lambda (x)
            (split-string x "[[:blank:]]*=[[:blank:]]*" t))
          (split-string arg-string "[[:blank:]]*,[[:blank:]]*" t)))

(defun elpy-snippet-current-method-and-args ()
  "Return information on the current definition."
  (let ((current-defun (python-info-current-defun))
        (current-arglist
         (save-excursion
           (python-nav-beginning-of-defun)
           (when (re-search-forward "(" nil t)
             (let* ((start (point))
                    (end (progn
                           (forward-char -1)
                           (forward-sexp)
                           (- (point) 1))))
               (elpy-snippet-split-args
                (buffer-substring-no-properties start end))))))
        class method args)
    (when (not current-arglist)
      (setq current-arglist '(("self"))))
    (if (and current-defun
             (string-match "^\\(.*\\)\\.\\(.*\\)$" current-defun))
        (setq class (match-string 1 current-defun)
              method (match-string 2 current-defun))
      (setq class "Class"
            method "method"))
    (setq args (mapcar #'car current-arglist))
    (list class method args)))

(defun elpy-snippet-init-assignments (arg-string)
  "Return the typical __init__ assignments for arguments."
  (let ((indentation (make-string (save-excursion
                                    (goto-char start-point)
                                    (current-indentation))
                                  ?\s)))
    (mapconcat (lambda (arg)
                 (if (string-match "^\\*" (car arg))
                     ""
                   (format "self.%s = %s\n%s"
                           (car arg)
                           (car arg)
                           indentation)))
               (elpy-snippet-split-args arg-string)
               "")))

(defun elpy-snippet-super-form ()
  "Return (Class, first-arg).method if Py2.
Else return ().method for Py3."
  (let* ((defun-info (elpy-snippet-current-method-and-args))
         (class (nth 0 defun-info))
         (method (nth 1 defun-info))
         (args (nth 2 defun-info))
         (first-arg (nth 0 args))
         (py-version-command " -c 'import sys ; print(sys.version_info.major)'")
         ;; Get the python version. Either 2 or 3
         (py-version-num (substring (shell-command-to-string (concat elpy-rpc-python-command py-version-command))0 1)))
    (if (string-match py-version-num "2")
        (format "(%s, %s).%s" class first-arg method)
      (format "().%s" method))))

(defun elpy-snippet-super-arguments ()
  "Return the argument list for the current method."
  (mapconcat (lambda (x) x)
             (cdr (nth 2 (elpy-snippet-current-method-and-args)))
             ", "))
;;; Snippet definitions:
;;;
(yas-define-snippets 'python-mode
                     '(("super" "super`(elpy-snippet-super-form)`(${1:`(elpy-snippet-super-arguments)`})\n$0" "super()" nil
                        ("Definitions")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/super" nil nil)
                       ("py3" "from __future__ import division, absolute_import\nfrom __future__ import print_function, unicode_literals\n" "from __future__ import ..." nil
                        ("Python 3")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/py3" nil nil)
                       ("pdb" "import pdb; pdb.set_trace()\n" "pdb.set_trace()" nil
                        ("Debug")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/pdb" nil nil)
                       ("from" "from ${1:module} import ${2:symbol}\n$0" "from MOD import SYM" nil
                        ("Header")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/from" nil nil)
                       ("env" "#!/usr/bin/env python\n" "#!/usr/bin/env python" nil
                        ("Header")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/env" nil nil)
                       ("enc" "# coding: utf-8\n" "# coding: utf-8" nil
                        ("Header")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/enc" nil nil)
                       ("defs" "def ${1:methodname}(self, ${2:arg}):\n    ${3:pass}\n" "def method(self, ...):" nil
                        ("Definitions")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/defs" nil nil)
                       ("class" "class ${1:ClassName}(${2:object}):\n    \"\"\"${3:Documentation for $1}\n\n    \"\"\"\n    def __init__(self${4:, args}):\n        super($1, self).__init__($5)\n        ${4:$(elpy-snippet-init-assignments yas-text)}\n        $0\n" "class(parent): ..." nil
                        ("Definitions")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/class" nil nil)
                       ("asr" "with self.assertRaises(${1:Exception}):\n    $0\n" "Assert Raises" nil
                        ("Testing")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/asr" nil nil)
                       ("asne" "self.assertNotEqual(${1:expected}, ${2:actual})\n" "Assert Not Equal" nil
                        ("Testing")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/asne" nil nil)
                       ("ase" "self.assertEqual(${1:expected}, ${2:actual})\n" "Assert Equal" nil
                        ("Testing")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/ase" nil nil)
                       ("__xor__" "def __xor__(self, other):\n    return $0\n" "__xor__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__xor__" nil nil)
                       ("__unicode__" "def __unicode__(self):\n    return $0\n" "__unicode__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__unicode__" nil nil)
                       ("__truediv__" "def __truediv__(self, other):\n    return $0\n" "__truediv__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__truediv__" nil nil)
                       ("__subclasscheck__" "def __subclasscheck__(self, instance):\n    return $0\n" "__subclasscheck__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__subclasscheck__" nil nil)
                       ("__sub__" "def __sub__(self, other):\n    return $0\n" "__sub__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__sub__" nil nil)
                       ("__str__" "def __str__(self):\n    return $0\n" "__str__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__str__" nil nil)
                       ("__slots__" "__slots__ = ($1)\n$0\n" "__slots__" nil
                        ("Class attributes")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__slots__" nil nil)
                       ("__setitem__" "def __setitem__(self, key, value):\n    $0\n" "__setitem__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__setitem__" nil nil)
                       ("__setattr__" "def __setattr__(self, name, value):\n    $0\n" "__setattr__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__setattr__" nil nil)
                       ("__set__" "def __set__(self, instance, value):\n    $0\n" "__set__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__set__" nil nil)
                       ("__rxor__" "def __rxor__(self, other):\n    return $0\n" "__rxor__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__rxor__" nil nil)
                       ("__rtruediv__" "def __rtruediv__(self, other):\n    return $0\n" "__rtruediv__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__rtruediv__" nil nil)
                       ("__rsub__" "def __rsub__(self, other):\n    return $0\n" "__rsub__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__rsub__" nil nil)
                       ("__rshift__" "def __rshift__(self, other):\n    return $0\n" "__rshift__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__rshift__" nil nil)
                       ("__rrshift__" "def __rrshift__(self, other):\n    return $0\n" "__rrshift__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__rrshift__" nil nil)
                       ("__rpow__" "def __rpow__(self, other):\n    return $0\n" "__rpow__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__rpow__" nil nil)
                       ("__ror__" "def __ror__(self, other):\n    return $0\n" "__ror__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__ror__" nil nil)
                       ("__rmul__" "def __rmul__(self, other):\n    return $0\n" "__rmul__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__rmul__" nil nil)
                       ("__rmod__" "def __rmod__(self, other):\n    return $0\n" "__rmod__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__rmod__" nil nil)
                       ("__rlshift__" "def __rlshift__(self, other):\n    return $0\n" "__rlshift__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__rlshift__" nil nil)
                       ("__rfloordiv__" "def __rfloordiv__(self, other):\n    return $0\n" "__rfloordiv__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__rfloordiv__" nil nil)
                       ("__reversed__" "def __reversed__(self):\n    return $0\n" "__reversed__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__reversed__" nil nil)
                       ("__repr__" "def __repr__(self):\n    return $0\n" "__repr__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__repr__" nil nil)
                       ("__rdivmod__" "def __rdivmod__(self, other):\n    return $0\n" "__rdivmod__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__rdivmod__" nil nil)
                       ("__rand__" "def __rand__(self, other):\n    return $0\n" "__rand__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__rand__" nil nil)
                       ("__radd__" "def __radd__(self, other):\n    return $0\n" "__radd__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__radd__" nil nil)
                       ("__pow__" "def __pow__(self, other, modulo=None):\n    return $0\n" "__pow__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__pow__" nil nil)
                       ("__pos__" "def __pos__(self):\n    return $0\n" "__pos__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__pos__" nil nil)
                       ("__or__" "def __or__(self, other):\n    return $0\n" "__or__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__or__" nil nil)
                       ("__oct__" "def __oct__(self):\n    return $0\n" "__oct__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__oct__" nil nil)
                       ("__nonzero__" "def __nonzero__(self):\n    return $0\n" "__nonzero__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__nonzero__" nil nil)
                       ("__new__" "def __new__(cls${1:, args}):\n    \"\"\"$2\n\n    \"\"\"\n    ${1:$(elpy-snippet-init-assignments yas-text)}\n" "__new__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__new__" nil nil)
                       ("__neg__" "def __neg__(self):\n    return $0\n" "__neg__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__neg__" nil nil)
                       ("__ne__" "def __ne__(self, other):\n    return $0\n" "__ne__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__ne__" nil nil)
                       ("__mul__" "def __mul__(self, other):\n    return $0\n" "__mul__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__mul__" nil nil)
                       ("__mod__" "def __mod__(self, other):\n    return $0\n" "__mod__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__mod__" nil nil)
                       ("__lt__" "def __lt__(self, other):\n    return $0\n" "__lt__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__lt__" nil nil)
                       ("__lshift__" "def __lshift__(self, other):\n    return $0\n" "__lshift__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__lshift__" nil nil)
                       ("__long__" "def __long__(self):\n    return $0\n" "__long__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__long__" nil nil)
                       ("__len__" "def __len__(self):\n    return $0\n" "__len__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__len__" nil nil)
                       ("__le__" "def __le__(self, other):\n    return $0\n" "__le__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__le__" nil nil)
                       ("__ixor__" "def __ixor__(self, other):\n    return $0\n" "__ixor__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__ixor__" nil nil)
                       ("__itruediv__" "def __itruediv__(self, other):\n    return $0\n" "__itruediv__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__itruediv__" nil nil)
                       ("__iter__" "def __iter__(self):\n    $0\n" "__iter__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__iter__" nil nil)
                       ("__isub__" "def __isub__(self, other):\n    return $0\n" "__isub__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__isub__" nil nil)
                       ("__irshift__" "def __irshift__(self, other):\n    return $0\n" "__irshift__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__irshift__" nil nil)
                       ("__ipow__" "def __ipow__(self, other):\n    return $0\n" "__ipow__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__ipow__" nil nil)
                       ("__ior__" "def __ior__(self, other):\n    return $0\n" "__ior__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__ior__" nil nil)
                       ("__invert__" "def __invert__(self):\n    return $0\n" "__invert__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__invert__" nil nil)
                       ("__int__" "def __int__(self):\n    $0\n" "__int__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__int__" nil nil)
                       ("__instancecheck__" "def __instancecheck__(self, instance):\n    return $0\n" "__instancecheck__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__instancecheck__" nil nil)
                       ("__init__" "def __init__(self${1:, args}):\n    \"\"\"$2\n\n    \"\"\"\n    ${1:$(elpy-snippet-init-assignments yas-text)}\n" "__init__ with assignment" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__init__" nil nil)
                       ("__index__" "def __index__(self):\n    return $0\n" "__index__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__index__" nil nil)
                       ("__imul__" "def __imul__(self, other):\n    return $0\n" "__imul__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__imul__" nil nil)
                       ("__imod__" "def __imod__(self, other):\n    return $0\n" "__imod__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__imod__" nil nil)
                       ("__ilshift__" "def __ilshift__(self, other):\n    return $0\n" "__ilshift__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__ilshift__" nil nil)
                       ("__ifloordiv__" "def __ifloordiv__(self, other):\n    return $0\n" "__ifloordiv__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__ifloordiv__" nil nil)
                       ("__idiv__" "def __idiv__(self, other):\n    return $0\n" "__idiv__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__idiv__" nil nil)
                       ("__iand__" "def __iand__(self, other):\n    return $0\n" "__iand__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__iand__" nil nil)
                       ("__iadd__" "def __iadd__(self, other):\n    return $0\n" "__iadd__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__iadd__" nil nil)
                       ("__hex__" "def __hex__(self):\n    return $0\n" "__hex__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__hex__" nil nil)
                       ("__hash__" "def __hash__(self):\n    return $0\n" "__hash__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__hash__" nil nil)
                       ("__gt__" "def __gt__(self, other):\n    return $0\n" "__gt__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__gt__" nil nil)
                       ("__getitem__" "def __getitem__(self, key):\n    return $0\n" "__getitem__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__getitem__" nil nil)
                       ("__getattribute__" "def __getattribute__(self, name):\n    return $0\n" "__getattribute__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__getattribute__" nil nil)
                       ("__getattr__" "def __getattr__(self, name):\n    return $0\n" "__getattr__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__getattr__" nil nil)
                       ("__get__" "def __get__(self, instance, owner):\n    return $0\n" "__get__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__get__" nil nil)
                       ("__ge__" "def __ge__(self, other):\n    return $0\n" "__ge__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__ge__" nil nil)
                       ("__floordiv__" "def __floordiv__(self, other):\n    return $0\n" "__floordiv__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__floordiv__" nil nil)
                       ("__float__" "def __float__(self):\n    return $0\n" "__float__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__float__" nil nil)
                       ("__exit__" "def __exit__(self, exc_type, exc_value, traceback):\n    $0\n" "__exit__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__exit__" nil nil)
                       ("__eq__" "def __eq__(self, other):\n    return $0\n" "__eq__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__eq__" nil nil)
                       ("__enter__" "def __enter__(self):\n    $0\n\n    return self" "__enter__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__enter__" nil nil)
                       ("__divmod__" "def __divmod__(self, other):\n    return $0\n" "__divmod__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__divmod__" nil nil)
                       ("__div__" "def __div__(self, other):\n    return $0\n" "__div__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__div__" nil nil)
                       ("__delitem__" "def __delitem__(self, key):\n    $0\n" "__delitem__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__delitem__" nil nil)
                       ("__delete__" "def __delete__(self, instance):\n    $0\n" "__delete__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__delete__" nil nil)
                       ("__delattr__" "def __delattr__(self, name):\n    $0\n" "__delattr__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__delattr__" nil nil)
                       ("__del__" "def __del__(self):\n    $0\n" "__del__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__del__" nil nil)
                       ("__contains__" "def __contains__(self, item):\n    return $0\n" "__contains__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__contains__" nil nil)
                       ("__complex__" "def __complex__(self):\n    return $0\n" "__complex__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__complex__" nil nil)
                       ("__coerce__" "def __coerce__(self, other):\n    return $0\n" "__coerce__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__coerce__" nil nil)
                       ("__cmp__" "def __cmp__(self, other):\n    return $0\n" "__cmp__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__cmp__" nil nil)
                       ("__call__" "def __call__(self, ${1:*args}):\n    return $0\n" "__call__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__call__" nil nil)
                       ("__bool__" "def __bool__(self):\n    return $0\n" "__bool__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__bool__" nil nil)
                       ("__and__" "def __and__(self, other):\n    return $0\n" "__and__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__and__" nil nil)
                       ("__add__" "def __add__(self, other):\n    return $0\n" "__add__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__add__" nil nil)
                       ("__abs__" "def __abs__(self):\n    return $0\n" "__abs__" nil
                        ("Special methods")
                        nil "/home/vlad/.emacs.d/elpa/elpy-20171015.548/snippets/python-mode/__abs__" nil nil)))


;;; Do not edit! File generated at Mon Oct 30 16:39:31 2017
