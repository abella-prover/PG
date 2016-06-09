(defconst abella-pg-home
  (or (getenv "ABELLAPG_HOME") default-directory)
  "The location of the Abella PG files")

(defconst proof-site-file
  (expand-file-name (concat abella-pg-home "/../generic/proof-site.el")))

(defconst lprolog-file
  (expand-file-name (concat abella-pg-home "/lprolog.el")))

(if (file-exists-p proof-site-file)
    (progn
      (setq proof-splash-enable nil)
      (setq proof-three-window-enable nil)
      (setq proof-three-window-mode-policy 'horizontal)
      (setq proof-output-tooltips nil)
      (load-file proof-site-file))
  (message "Cannot find PG startup file: %s" proof-site-file))

(if (file-exists-p lprolog-file)
    (progn
      (autoload 'lprolog-mode lprolog-file "Major mode for Lambda Prolog" t)
      (add-to-list 'auto-mode-alist '("\\.mod\\'" . lprolog-mode))
      (add-to-list 'auto-mode-alist '("\\.sig\\'" . lprolog-mode)))
  (message "Cannot find Lambda Prolog mode: %s" lprolog-file))
