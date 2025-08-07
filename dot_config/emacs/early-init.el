;;; early-init.el --- Early Init File -*- lexical-binding: t; no-byte-compile: t -*-

;; Disable package.el in favor of Elpaca
(setq package-enable-at-startup nil)

;; Performance optimizations during startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Optimize file name handler
(defvar minimal-emacs--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Disable GUI elements early
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq inhibit-startup-screen t
      inhibit-startup-message t)

;; Font configuration (Berkeley Mono)
(add-to-list 'default-frame-alist '(font . "Berkeley Mono"))

;; Restore after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist minimal-emacs--file-name-handler-alist)
            (setq gc-cons-threshold (* 16 1024 1024))))

