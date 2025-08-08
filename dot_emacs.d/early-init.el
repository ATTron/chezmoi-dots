;;; early-init.el --- Early Init File -*- lexical-binding: t; no-byte-compile: t -*-

;; Disable package.el to prevent conflicts with Elpaca
(setq package-enable-at-startup nil)

;; Performance optimizations
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5
      read-process-output-max (* 1024 1024))

;; Disable startup screen/dashboard
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-buffer-menu t
      initial-scratch-message nil)

;; Disable gui elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
