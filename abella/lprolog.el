;;; lprolog.el --- Major mode for Lambda Prolog module files -*- lexical-binding: t -*-

;; This file is part of Proof General.

;; Copyright (C) 2011-2024 INRIA

;; Authors: Clement Houtmann <Clement.Houtmann@inria.fr>
;;          Kaustuv Chaudhuri <kaustuv@chaudhuri.info>

;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:

;; Editing support for Lambda Prolog signature and module files, as
;; used by Abella specifications.  This is not a Proof General script
;; mode; it only provides syntax highlighting and comment handling.

;;; Code:

(require 'prog-mode)
;; `lprolog-mode' may be autoloaded before Proof General has put the
;; Abella directory on `load-path', so load the sibling file directly.
(eval-and-compile
  (let ((dir (file-name-directory (or load-file-name
                                      buffer-file-name
                                      byte-compile-current-file))))
    (if dir
        (require 'abella-syntax (expand-file-name "abella-syntax" dir))
      (require 'abella-syntax))))

(defgroup lprolog nil
  "Editing support for Lambda Prolog module files."
  :group 'languages)

(defconst lprolog-font-lock-keywords
  (list
   (cons (regexp-opt abella-operator-keywords) 'font-lock-builtin-face)
   (cons (abella--keyword-regexp '("true" "false"))
         '(1 font-lock-constant-face))
   (cons (abella--keyword-regexp '("pi" "sigma"))
         '(1 font-lock-keyword-face))
   (cons (abella--keyword-regexp
          (append abella-signature-keywords abella-lprolog-keywords))
         '(1 font-lock-keyword-face))
   (cons (abella--keyword-regexp abella-term-keywords)
         '(1 font-lock-keyword-face))
   (cons "\\<[A-Z][A-Za-z0-9'/]*" 'font-lock-variable-name-face))
  "Font-lock keywords for Lambda Prolog module files.")

;;;###autoload
(define-derived-mode lprolog-mode prog-mode "Lambda Prolog"
  "Major mode for editing Lambda Prolog module files."
  (let ((entries abella-syntax-table-entries))
    (while entries
      (modify-syntax-entry (car entries) (cadr entries))
      (setq entries (cddr entries))))
  (setq-local font-lock-defaults '(lprolog-font-lock-keywords))
  (setq-local comment-start "%")
  (setq-local comment-end "")
  (setq-local comment-start-skip "%+\\s-*"))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.mod\\'" . lprolog-mode))
;;;###autoload
(add-to-list 'auto-mode-alist '("\\.sig\\'" . lprolog-mode))

(provide 'lprolog)

;;; lprolog.el ends here
