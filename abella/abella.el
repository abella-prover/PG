;;; abella.el --- Proof General instance for Abella -*- lexical-binding: t -*-

;; This file is part of Proof General.

;; Copyright (C) 2011-2024 INRIA

;; Authors: Clement Houtmann <Clement.Houtmann@inria.fr>
;;          Kaustuv Chaudhuri <kaustuv@chaudhuri.info>

;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:

;; Proof General support for the Abella theorem prover.  See
;; https://abella-prover.org/ for more information.

;;; Code:

(require 'proof)
(require 'proof-easy-config)
(require 'abella-syntax)

(defcustom abella-prog-name "abella"
  "Name or path of the Abella executable."
  :type 'file
  :group 'abella)

(defun abella-find-and-forget (span)
  "Return the commands needed to forget back to SPAN.
Abella has no command for forgetting a declaration, so undo the
processed commands one at a time."
  (let (commands)
    (while span
      (unless (memq (span-property span 'type) '(comment proverproc))
        (push "#back." commands))
      (setq span (next-span span 'type)))
    commands))

(defun abella-shell-handle-output (_cmd output)
  "Clear the goals buffer when OUTPUT reports a finished proof."
  (when (string-match "Proof \\(?:completed\\|ABORTED\\)\\b" output)
    (proof-clean-buffer proof-goals-buffer)))

(proof-easy-config 'abella "Abella"
  proof-prog-name abella-prog-name
  proof-terminal-string "."
  proof-script-command-end-regexp "[^.]\\.\\([ \t\n]\\|%\\|/\\*\\|$\\)"
  proof-script-comment-start "%"
  proof-script-comment-end ""
  proof-script-comment-start-regexp "%\\|/\\*"
  proof-script-comment-end-regexp "\\*/\\|\n"
  proof-script-fly-past-comments t
  proof-script-syntax-table-entries abella-syntax-table-entries
  proof-shell-syntax-table-entries abella-syntax-table-entries
  proof-script-font-lock-keywords abella-font-lock-keywords
  proof-shell-font-lock-keywords abella-font-lock-keywords
  proof-goals-font-lock-keywords abella-goals-font-lock-keywords
  proof-response-font-lock-keywords abella-response-font-lock-keywords
  proof-goal-command-regexp proof-no-regexp
  proof-save-command-regexp proof-no-regexp
  proof-find-and-forget-fn #'abella-find-and-forget
  proof-shell-annotated-prompt-regexp "^.* < $"
  ;; Match a whole sequent (context through the rule line) in one go.
  ;; Other subgoals start with "Subgoal N is:" and have no rule line.
  proof-shell-start-goals-regexp
  "^\\(?:Variables:\\|Subgoal [^ \n]*:\\|[^ \t\n]+ : \\)\\(?:[^\n]*\n\\)*=+$\\|^=+$"
  proof-shell-end-goals-regexp "^Proof \\(?:completed\\|ABORTED\\)\\b"
  proof-shell-proof-completed-regexp "Proof \\(?:completed\\|ABORTED\\)\\b"
  proof-shell-error-regexp
  "^\\(?:Error:\\|Parse error\\|Syntax error\\|Typing error\\|Unification error\\|Unknown error\\|Module parameter .* cannot be instantiated\\|Proof NOT Completed\\.\\)"
  proof-shell-handle-output-system-specific #'abella-shell-handle-output
  proof-shell-quit-cmd "Quit."
  proof-shell-restart-cmd "#reset."
  proof-shell-strip-crs-from-input nil
  proof-shell-unicode t
  proof-assistant-home-page "https://abella-prover.org")

(defun abella-mode-setup ()
  "Set buffer-local defaults for `abella-mode'."
  (setq-local indent-line-function #'indent-relative))

(add-hook 'abella-mode-hook #'abella-mode-setup)

(provide 'abella)

;;; abella.el ends here
