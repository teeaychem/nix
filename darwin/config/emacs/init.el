;; -*- lexical-binding: t; -*-

;;; Code:

;; (setenv "LIBRARY_PATH"
;; 	(mapconcat 'identity
;; 	           '(
;;                      "/opt/homebrew/opt/gcc/lib/gcc/current"
;;                      "/opt/homebrew/opt/libgccjit/lib/gcc/current"
;;                      "/opt/homebrew/opt/gcc/lib/gcc/current/gcc/aarch64-apple-darwin24/15")
;;                    ":"))


(require 'package)
(require 'use-package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu-devel" . "https://elpa.gnu.org/devel/") t)

(setq package-archive-priorities
      '(
        ("melpa" . 1)
        ("melpa-stable" . 0)
        ("gnu-devel" . -1)))

;; save custom things to separate file, and also load before doing anything else with packages as it contains a useful list
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

(package-initialize)

(when (not (file-directory-p (expand-file-name "elpa" user-emacs-directory)))
  (package-refresh-contents)
  (package-install-selected-packages))

(setq use-package-verbose nil)
(setq use-package-always-ensure t)

(setq vc-follow-symlinks t)

;; ensure lexical binding in tangled files
;; https://emacs.stackexchange.com/questions/81540/lexical-binding-in-a-tangled-init-el-file

(defun my-ensure-lexical-binding-cookie()
  (goto-char(point-min)) ;; beginning of tangled code
  (insert ";; -*- coding: utf-8; lexical-binding: t -*-")
  (newline)
  (newline)
  (let ((inhibit-message t)) ;; Don't show messages from these functions
    (basic-save-buffer)
    (kill-buffer) nil))

(add-hook 'org-babel-post-tangle-hook #'my-ensure-lexical-binding-cookie)


;; load a fresh tangle of config.org
(if (file-exists-p (expand-file-name "config.el" user-emacs-directory))
    (delete-file (expand-file-name "config.el" user-emacs-directory)))
(org-babel-load-file (expand-file-name "config.org" user-emacs-directory))


;; emacs-lsp-booster
;; https://github.com/blahgeek/emacs-lsp-booster

(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'Json-Parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
            (setcar orig-result command-from-exec-path))
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)


;; start emacs in server mode for communcation between skim, etc.

(require 'server)
(unless (server-running-p) (server-start))

;;; init.el ends here
