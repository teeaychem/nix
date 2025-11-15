;; -*- lexical-binding: t; -*-

;;; Code:

(setenv "LIBRARY_PATH"
	(mapconcat 'identity
	           '(
                     "/opt/homebrew/opt/gcc/lib/gcc/current"
                     "/opt/homebrew/opt/libgccjit/lib/gcc/current"
                     "/opt/homebrew/opt/gcc/lib/gcc/current/gcc/aarch64-apple-darwin24/15")
                   ":"))


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
(when (file-exists-p custom-file)
  (load custom-file))

(package-initialize)

(when (not (file-directory-p (expand-file-name "elpa" user-emacs-directory)))
  (package-refresh-contents)
  (package-install-selected-packages))

(setq use-package-verbose t)
(setq use-package-always-ensure t)

(setq vc-follow-symlinks t) ;; always open the file a symlink points to


;; load a fresh tangle of config.org
(if (file-exists-p (expand-file-name "config.el" user-emacs-directory))
    (delete-file (expand-file-name "config.el" user-emacs-directory)))
(org-babel-load-file (expand-file-name "config.org" user-emacs-directory))

(require 'server)
(unless (server-running-p) (server-start)) ; start emacs in server mode so skim can talk to it

;;; init.el ends here
