;;; Compiled snippets and support files for `python-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'python-mode
                     '(("fw" "from __future__ import with_statement" "with_statement" nil
                        ("future")
                        nil nil nil nil)
                       ("with" "with ${1:expr}${2: as ${3:alias}}:\n     $0" "with" nil
                        ("control structure")
                        nil nil nil nil)
                       ("wh" "while ${1:True}:\n      $0" "while" nil
                        ("control structure")
                        nil nil nil nil)
                       ("utf8" "# -*- coding: utf-8 -*-\n" "utf-8 encoding" nil nil nil nil nil nil)
                       ("un" "def __unicode__(self):\n    $0" "__unicode__" nil
                        ("dunder methods")
                        nil nil nil nil)
                       ("try" "try:\n    $1\nexcept $2:\n    $3\nelse:\n    $0" "tryelse" nil nil nil nil nil nil)
                       ("try" "try:\n    $1\nexcept ${2:Exception}:\n    $0" "try" nil nil nil nil nil nil)
                       ("tr" "import pdb; pdb.set_trace()" "trace" nil
                        ("debug")
                        nil nil nil nil)
                       ("tf" "import unittest\n${1:from ${2:test_file} import *}\n\n$0\n\nif __name__ == '__main__':\n    unittest.main()" "test_file" nil
                        ("testing")
                        nil nil nil nil)
                       ("tcs" "class Test${1:toTest}(${2:unittest.TestCase}):\n      $0\n" "test_class" nil
                        ("testing")
                        nil nil nil nil)
                       ("super" "super(${1:Class}, self).${2:function}(${3:args})" "super" nil
                        ("object oriented")
                        nil nil nil nil)
                       ("str" "def __str__(self):\n    $0" "__str__" nil
                        ("dunder methods")
                        nil nil nil nil)
                       ("sm" "@staticmethod\ndef ${1:func}($0):\n" "static" nil nil nil nil nil nil)
                       ("size" "sys.getsizeof($0)" "size" nil nil nil nil nil nil)
                       ("setup" "from setuptools import setup\n\npackage = '${1:name}'\nversion = '${2:0.1}'\n\nsetup(name=package,\n      version=version,\n      description=\"${3:description}\",\n      url='${4:url}'$0)\n" "setup" nil
                        ("distribute")
                        nil nil nil nil)
                       ("setdef" "${1:var}.setdefault(${2:key}, []).append(${3:value})" "setdef" nil nil nil nil nil nil)
                       ("sn" "self.$1 = $1" "selfassign" nil
                        ("object oriented")
                        nil nil nil nil)
                       ("s" "self" "self_without_dot" nil
                        ("object oriented")
                        nil nil nil nil)
                       ("." "self.$0" "self" nil
                        ("object oriented")
                        nil nil nil nil)
                       ("script" "#!/usr/bin/env python\n\ndef main():\n   pass\n\nif __name__ == '__main__':\n   main()\n" "script" nil nil nil nil nil nil)
                       ("r" "return $0" "return" nil nil nil nil nil nil)
                       ("repr" "def __repr__(self):\n    $0" "__repr__" nil
                        ("dunder methods")
                        nil nil nil nil)
                       ("reg" "${1:regexp} = re.compile(r\"${2:expr}\")\n$0" "reg" nil
                        ("general")
                        nil nil nil nil)
                       ("prop" "def ${1:foo}():\n   doc = \"\"\"${2:Doc string}\"\"\"\n   def fget(self):\n       return self._$1\n\n   def fset(self, value):\n       self._$1 = value\n\n   def fdel(self):\n       del self._$1\n   return locals()\n$1 = property(**$1())\n\n$0\n" "prop" nil nil nil nil nil nil)
                       ("p" "print($0)" "print" nil nil nil nil nil nil)
                       ("ps" "pass" "pass" nil nil nil nil nil nil)
                       ("pars" "parser = argparse.ArgumentParser(description='$1')\n$0" "parser" nil
                        ("argparser")
                        nil nil nil nil)
                       ("pargs" "def parse_arguments():\n    parser = argparse.ArgumentParser(description='$1')\n    $0\n    return parser.parse_args()" "parse_args" nil
                        ("argparser")
                        nil nil nil nil)
                       ("np" "import numpy as np\n$0" "np" nil
                        ("general")
                        nil nil nil nil)
                       ("not_impl" "raise NotImplementedError" "not_impl" nil nil nil nil nil nil)
                       ("md" "def ${1:name}(self$2):\n    \\\"\\\"\\\"$3\n    ${2:$(python-args-to-docstring)}\n    \\\"\\\"\\\"\n    $0" "method_docstring" nil
                        ("object oriented")
                        nil nil nil nil)
                       ("m" "def ${1:method}(self${2:, $3}):\n    $0" "method" nil
                        ("object oriented")
                        nil nil nil nil)
                       ("mt" "__metaclass__ = type" "metaclass" nil
                        ("object oriented")
                        nil nil nil nil)
                       ("main" "def main():\n    $0" "main" nil nil nil nil nil nil)
                       ("log" "logger = logging.getLogger(\"${1:name}\")\nlogger.setLevel(logging.${2:level})\n" "logging" nil nil nil nil nil nil)
                       ("ln" "logger = logging.getLogger(__name__)" "logger_name" nil nil nil nil nil nil)
                       ("lmod" "# Copyright (c) 2016, Vladimir Feinberg\n# Licensed under the BSD 3-clause license (see LICENSE)\n\n# This file was modified from the GPy project. Its file header is replicated\n# below. Its LICENSE.txt is replicated in the LICENSE file for this directory.\n\n$0" "lmod" nil nil nil nil nil nil)
                       ("li" "[${1:el} for $1 in ${2:list}]\n$0" "list" nil
                        ("definitions")
                        nil nil nil nil)
                       ("license" "# Copyright (c) 2016, Vladimir Feinberg\n# Licensed under the BSD 3-clause license (see LICENSE)\n\n$0" "license" nil nil nil nil nil nil)
                       ("lam" "lambda ${1:x}: $0" "lambda" nil nil nil nil nil nil)
                       ("iter" "def __iter__(self):\n    return ${1:iter($2)}" "__iter__" nil
                        ("dunder methods")
                        nil nil nil nil)
                       ("itr" "import ipdb; ipdb.set_trace()" "ipdb trace" nil
                        ("debug")
                        nil nil nil nil)
                       ("int" "import code; code.interact(local=locals())" "interact" nil nil nil nil nil nil)
                       ("id" "def __init__(self$1):\n    \\\"\\\"\\\"$2\n    ${1:$(python-args-to-docstring)}\n    \\\"\\\"\\\"\n    $0" "init_docstring" nil
                        ("definitions")
                        nil nil nil nil)
                       ("init" "def __init__(self${1:, args}):\n    ${2:\"${3:docstring}\"\n    }$0" "init" nil
                        ("definitions")
                        nil nil nil nil)
                       ("imp" "import ${1:lib}${2: as ${3:alias}}\n$0" "import" nil
                        ("general")
                        nil nil nil nil)
                       ("ifm" "if __name__ == '__main__':\n   ${1:main()}" "ifmain" nil nil nil nil nil nil)
                       ("ife" "if $1:\n   $2\nelse:\n   $0" "ife" nil
                        ("control structure")
                        nil nil nil nil)
                       ("if" "if ${1:cond}:\n   $0" "if" nil
                        ("control structure")
                        nil nil nil nil)
                       ("fd" "def ${1:name}($2):\n    \\\"\\\"\\\"$3\n    ${2:$(python-args-to-docstring)}\n    \\\"\\\"\\\"\n    $0" "function_docstring" nil
                        ("definitions")
                        nil nil nil nil)
                       ("f" "def ${1:fun}(${2:args}):\n    $0\n" "function" nil
                        ("definitions")
                        nil nil nil nil)
                       ("from" "from ${1:lib} import ${2:funs}" "from" nil
                        ("general")
                        nil nil nil nil)
                       ("for" "for ${var} in ${collection}:\n    $0" "for ... in ... : ..." nil
                        ("control structure")
                        nil nil nil nil)
                       ("eq" "def __eq__(self, other):\n    return self.$1 == other.$1" "__eq__" nil
                        ("dunder methods")
                        nil nil nil nil)
                       ("doc" ">>> ${1:function calls}\n${2:desired output}\n$0" "doctest" nil
                        ("testing")
                        nil nil nil nil)
                       ("d" "\"\"\"$0\n\"\"\"" "doc" nil nil nil nil nil nil)
                       ("dt" "def test_${1:long_name}(self):\n    $0" "deftest" nil
                        ("testing")
                        nil nil nil nil)
                       ("dec" "def ${1:decorator}(func):\n    $2\n    def _$1(*args, **kwargs):\n        $3\n        ret = func(*args, **kwargs)\n        $4\n        return ret\n\n    return _$1" "dec" nil
                        ("definitions")
                        nil nil nil nil)
                       ("cls" "class ${1:class}:\n      $0" "cls" nil
                        ("object oriented")
                        nil nil nil nil)
                       ("cm" "@classmethod\ndef ${1:meth}(cls, $0):\n    " "classmethod" nil
                        ("object oriented")
                        nil nil nil nil)
                       ("cdb" "from celery.contrib import rdb; rdb.set_trace()" "celery pdb" nil
                        ("debug")
                        nil nil nil nil)
                       ("an" "self.assertNotIn(${1:member}, ${2:container})" "assetNotIn" nil
                        ("testing")
                        nil nil nil nil)
                       ("at" "self.assertTrue($0)" "assertTrue" nil
                        ("testing")
                        nil nil nil nil)
                       ("ar" "with self.assertRaises(${1:Exception}):\n     $0\n" "assertRaises" nil nil nil nil nil nil)
                       ("ar" "self.assertRaises(${1:Exception}, ${2:fun})" "assertRaises" nil
                        ("testing")
                        nil nil nil nil)
                       ("ane" "self.assertNotEqual($1, $2)" "assertNotEqual" nil
                        ("testing")
                        nil nil nil nil)
                       ("ai" "self.assertIn(${1:member}, ${2:container})" "assertIn" nil
                        ("testing")
                        nil nil nil nil)
                       ("af" "self.assertFalse($0)" "assertFalse" nil
                        ("testing")
                        nil nil nil nil)
                       ("ae" "self.assertEqual($1, $2)" "assertEqual" nil
                        ("testing")
                        nil nil nil nil)
                       ("ass" "assert $0" "assert" nil
                        ("testing")
                        nil nil nil nil)
                       ("arg" "parser.add_argument('${1:varname}', $0)" "arg_positional" nil
                        ("argparser")
                        nil nil nil nil)
                       ("arg" "parser.add_argument('-$1', '--$2',\n                    $0)\n" "arg" nil
                        ("argparser")
                        nil nil nil nil)
                       ("a" "__all__ = [\n        $0\n]" "all" nil nil nil nil nil nil)
                       ("_yas-setup.elc" ";ELC   \n;;; Compiled by vlad@vlad-W530 on Sat Aug  9 13:16:13 2014\n;;; from file /home/vlad/.emacs.d/elpa/yasnippet-20140729.1240/snippets/python-mode/.yas-setup.el\n;;; in Emacs version 24.3.1\n;;; with all optimizations.\n\n;;; This file uses dynamic docstrings, first added in Emacs 19.29.\n\n;;; This file does not contain utf-8 non-ASCII characters,\n;;; and so can be loaded in Emacs versions earlier than 23.\n\n;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n\n\n#@64 Split a python argument string into ((name, default)..) tuples\n(defalias 'python-split-args #[(arg-string) \"\\301\\302\\303\\304\\305#\\\"\\207\" [arg-string mapcar #[(x) \"\\301\\302\\303#\\207\" [x split-string \"[[:blank:]]*=[[:blank:]]*\" t] 4] split-string \"[[:blank:]]*,[[:blank:]]*\" t] 6 (#$ . 554)])\n#@62 return docstring format for the python arguments in yas-text\n(defalias 'python-args-to-docstring #[nil \"\\305\\306i\\307\\\"P\\310	!\\211\\203 \\311\\312\\313\\314\\n\\\"\\\"\\202 \\315\\316\\317\\n#\\211\\320\\230?\\205/ \\316\\321\\322\\fD#,\\207\" [indent yas-text args max-len formatted-args \"\\n\" make-string 32 python-split-args apply max mapcar #[(x) \"@G\\207\" [x] 1] 0 mapconcat #[(x) \"@\\302	@GZ\\303\\\"\\304A@\\205 \\305A@\\306QR\\207\" [x max-len make-string 32 \" -- \" \"(default \" \")\"] 6] \"\" identity \"Keyword Arguments:\"] 6 (#$ . 853)])\n" "_yas-setup.elc" nil nil nil nil nil nil)
                       ("_yas-setup.el" "(defun python-split-args (arg-string)\n  \"Split a python argument string into ((name, default)..) tuples\"\n  (mapcar (lambda (x)\n             (split-string x \"[[:blank:]]*=[[:blank:]]*\" t))\n          (split-string arg-string \"[[:blank:]]*,[[:blank:]]*\" t)))\n\n(defun python-args-to-docstring ()\n  \"return docstring format for the python arguments in yas-text\"\n  (let* ((indent (concat \"\\n\" (make-string (current-column) 32)))\n         (args (python-split-args yas-text))\n         (max-len (if args (apply 'max (mapcar (lambda (x) (length (nth 0 x))) args)) 0))\n         (formatted-args (mapconcat\n                (lambda (x)\n                   (concat (nth 0 x) (make-string (- max-len (length (nth 0 x))) ? ) \" -- \"\n                           (if (nth 1 x) (concat \"\\(default \" (nth 1 x) \"\\)\"))))\n                args\n                indent)))\n    (unless (string= formatted-args \"\")\n      (mapconcat 'identity (list \"Keyword Arguments:\" formatted-args) indent))))\n" "_yas-setup.el" nil nil nil nil nil nil)
                       ("_yas-parents" "prog-mode\n" "_yas-parents" nil nil nil nil nil nil)
                       ("setit" "def __setitem__(self, ${1:key}, ${2:val}):\n    $0" "__setitem__" nil
                        ("dunder methods")
                        nil nil nil nil)
                       ("new" "def __new__(mcs, name, bases, dict):\n    $0\n    return type.__new__(mcs, name, bases, dict)\n" "__new__" nil
                        ("dunder methods")
                        nil nil nil nil)
                       ("len" "def __len__(self):\n    $0" "__len__" nil
                        ("dunder methods")
                        nil nil nil nil)
                       ("getit" "def __getitem__(self, ${1:key}):\n    $0" "__getitem__" nil
                        ("dunder methods")
                        nil nil nil nil)
                       ("ex" "def __exit__(self, type, value, traceback):\n    $0" "__exit__" nil
                        ("dunder methods")
                        nil nil nil nil)
                       ("ent" "def __enter__(self):\n    $0\n\n    return self" "__enter__" nil
                        ("dunder methods")
                        nil nil nil nil)
                       ("cont" "def __contains__(self, el):\n    $0" "__contains__" nil
                        ("dunder methods")
                        nil nil nil nil)))


;;; Do not edit! File generated at Tue Jun 13 15:07:06 2017
