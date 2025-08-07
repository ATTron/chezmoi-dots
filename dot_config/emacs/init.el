;;; init.el --- Emacs Configuration -*- lexical-binding: t -*-

;; === ELPACA BOOTSTRAP (Version 0.11) ===
(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo   (expand-file-name "elpaca/" elpaca-repos-directory))
       (build  (expand-file-name "elpaca/" elpaca-builds-directory))
       (order  (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; === USE-PACKAGE INTEGRATION ===
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

;; === CORE EMACS SETTINGS ===
(use-package emacs
  :ensure nil
  :init
  ;; Performance settings
  (setq gc-cons-threshold (* 100 1024 1024))  ; 100MB
  (setq read-process-output-max (* 4 1024 1024))  ; 4MB for LSP
  
  ;; Basic settings
  (setq user-full-name "Your Name"
        user-mail-address "your@email.com"
        ring-bell-function 'ignore
        use-short-answers t)
  
  ;; Modern defaults
  (fset 'yes-or-no-p 'y-or-n-p)
  (global-auto-revert-mode 1)
  (save-place-mode 1)
  (savehist-mode 1)
  (recentf-mode 1)
  
  :config
  ;; Font configuration
  (set-face-attribute 'default nil :font "Berkeley Mono-14")
  (set-face-attribute 'fixed-pitch nil :font "Berkeley Mono-14")
  
  ;; Custom file location
  (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
  (when (file-exists-p custom-file)
    (load custom-file)))

;; === EVIL MODE (VIM KEYBINDINGS) ===
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  
  ;; Set initial state for some modes
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

(use-package evil-commentary
  :ensure t
  :after evil
  :config
  (evil-commentary-mode))

(use-package evil-surround
  :ensure t
  :after evil
  :config
  (global-evil-surround-mode 1))

;; === GENERAL KEY BINDINGS (LEADER KEY) ===
(use-package general
  :ensure t
  :after evil
  :config
  (general-evil-setup)
  
  ;; Set up SPC as the leader key
  (general-create-definer my-leader-def
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  
  ;; File operations
  (my-leader-def
    ;; Files
    "f"  '(:ignore t :which-key "files")
    "ff" '(find-file :which-key "find file")
    "fr" '(recentf-open-files :which-key "recent files")
    "fs" '(save-buffer :which-key "save file")
    "fS" '(save-some-buffers :which-key "save all files")
    
    ;; Search
    "s"  '(:ignore t :which-key "search")
    "sf" '(project-find-file :which-key "search project files")
    "sF" '(find-file :which-key "search all files")
    "sg" '(project-find-regexp :which-key "grep in project")
    "sr" '(recentf-open-files :which-key "search recent files")
    "sb" '(switch-to-buffer :which-key "switch buffer")
    
    ;; Buffers
    "b"  '(:ignore t :which-key "buffers")
    "bb" '(switch-to-buffer :which-key "switch buffer")
    "bd" '(kill-current-buffer :which-key "delete buffer")
    "bn" '(next-buffer :which-key "next buffer")
    "bp" '(previous-buffer :which-key "previous buffer")
    "br" '(revert-buffer :which-key "revert buffer")
    
    ;; Project
    "p"  '(:ignore t :which-key "project")
    "pf" '(project-find-file :which-key "find file in project")
    "pp" '(project-switch-project :which-key "switch project")
    "pb" '(project-switch-to-buffer :which-key "switch to project buffer")
    "pg" '(project-find-regexp :which-key "grep in project")
    
    ;; Git
    "g"  '(:ignore t :which-key "git")
    "gg" '(magit-status :which-key "magit status")
    "gb" '(magit-blame :which-key "git blame")
    "gl" '(magit-log :which-key "git log")
    
    ;; Window management
    "w"  '(:ignore t :which-key "windows")
    "wv" '(split-window-right :which-key "split vertical")
    "ws" '(split-window-below :which-key "split horizontal")
    "wd" '(delete-window :which-key "delete window")
    "wh" '(evil-window-left :which-key "window left")
    "wj" '(evil-window-down :which-key "window down")
    "wk" '(evil-window-up :which-key "window up")
    "wl" '(evil-window-right :which-key "window right")
    
    ;; Help
    "h"  '(:ignore t :which-key "help")
    "hf" '(describe-function :which-key "describe function")
    "hv" '(describe-variable :which-key "describe variable")
    "hk" '(describe-key :which-key "describe key")
    "hm" '(describe-mode :which-key "describe mode")
    
    ;; Toggle
    "t"  '(:ignore t :which-key "toggle")
    "tn" '(display-line-numbers-mode :which-key "line numbers")
    "tw" '(whitespace-mode :which-key "whitespace")
    "tt" '(load-theme :which-key "choose theme")
    
    ;; Quit
    "q"  '(:ignore t :which-key "quit")
    "qq" '(save-buffers-kill-emacs :which-key "quit emacs")
    "qr" '(restart-emacs :which-key "restart emacs")))

;; === THEME ===
(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-medium t))

;; === ICONS ===
;; Compat is required for nerd-icons-completion
(use-package compat
  :ensure t
  :demand t)

(use-package nerd-icons
  :ensure t
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono")
  :config
  ;; Install fonts if needed
  (when (and (display-graphic-p)
             (not (font-installed-p nerd-icons-font-family)))
    (nerd-icons-install-fonts t)))

(use-package nerd-icons-dired
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
  :ensure t
  :after (marginalia compat)
  :config (nerd-icons-completion-mode))

;; === TREE-SITTER AUTOMATIC SETUP ===
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; === LSP MODE WITH AUTOMATIC LANGUAGE SERVER SETUP ===
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((python-ts-mode . lsp-deferred)
         (rust-mode . lsp-deferred)
         (go-mode . lsp-deferred)
         (typescript-ts-mode . lsp-deferred)
         (js-ts-mode . lsp-deferred)
         (c-ts-mode . lsp-deferred)
         (c++-ts-mode . lsp-deferred)
         (java-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred)
  :config
  ;; Performance optimizations
  (setq lsp-use-plists t                    ; Better performance
        lsp-log-io nil                      ; Disable logging
        lsp-idle-delay 0.500               ; Reduce update frequency
        lsp-completion-provider :none       ; Use external completion
        lsp-eldoc-render-all nil
        lsp-signature-render-documentation nil
        
        ;; File watching
        lsp-file-watch-threshold 2000
        lsp-file-watch-ignored-directories
        '("[/\\\\]\\.git\\'" "[/\\\\]\\.hg\\'" "[/\\\\]\\.bzr\\'"
          "[/\\\\]_darcs\\'" "[/\\\\]\\.svn\\'" "[/\\\\]_FOSSIL_\\'"
          "[/\\\\]\\.idea\\'" "[/\\\\]\\.ensime_cache\\'"
          "[/\\\\]\\.eunit\\'" "[/\\\\]node_modules"
          "[/\\\\]\\.fslckout\\'" "[/\\\\]\\.tox\\'"
          "[/\\\\]dist\\'" "[/\\\\]dist-newstyle\\'"
          "[/\\\\]\\.stack-work\\'" "[/\\\\]\\.bloop\\'"
          "[/\\\\]\\.metals\\'" "[/\\\\]target\\'"
          "[/\\\\]\\.ccls-cache\\'" "[/\\\\]\\.vscode\\'"
          "[/\\\\]\\.deps\\'" "[/\\\\]build-aux\\'"
          "[/\\\\]autom4te.cache\\'" "[/\\\\]\\.reference\\'")))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-flycheck-enable t)
  (lsp-ui-sideline-show-hover nil))

;; === ORG MODE WITH PRETTY ICONS AND BULLETS ===
(use-package org
  :ensure nil  ; Built-in
  :hook ((org-mode . org-indent-mode)
         (org-mode . visual-line-mode))
  :custom
  (org-hide-emphasis-markers t)
  (org-startup-indented t)
  (org-startup-with-inline-images t)
  :config
  ;; Better org defaults
  (setq org-ellipsis " ▾"
        org-log-done 'time
        org-log-into-drawer t))

(use-package org-superstar
  :ensure t
  :hook (org-mode . org-superstar-mode)
  :custom
  ;; Bullet styles
  (org-superstar-headline-bullets-list '("◉" "○" "▷" "▶" "◆" "▲" "■"))
  (org-superstar-item-bullet-alist '((?+ . ?➤) (?- . ?✦) (?* . ?◆)))
  
  ;; TODO bullets
  (org-superstar-special-todo-items t)
  (org-superstar-todo-bullet-alist '(("TODO" . ?⚡)
                                      ("NEXT" . ?⚡)  
                                      ("HOLD" . ?⚬)
                                      ("DONE" . ?✓)))
  
  ;; Clean leading stars
  (org-superstar-leading-bullet ?\s)
  (org-superstar-leading-fallback ?\s)
  
  :config
  ;; Performance for large files
  (setq inhibit-compacting-font-caches t))

;; === MAGIT FOR GIT INTEGRATION ===
;; Ensure transient is loaded with correct version first
(use-package transient
  :ensure (:wait t)
  :demand t)

(use-package magit
  :ensure (:wait t)
  :after transient
  :bind (("C-x g" . magit-status)
         ("C-x G" . magit-status))
  :custom
  (magit-diff-refine-hunk t)
  (magit-repository-directories '(("~/projects" . 2)))
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; === COMPLETION FRAMEWORK ===
(use-package vertico
  :ensure t
  :init (vertico-mode))

(use-package marginalia
  :ensure t
  :init (marginalia-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 2)
  :init
  (global-corfu-mode))

;; === HELPFUL UI PACKAGES ===
(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; === FINAL OPTIMIZATIONS ===
(add-hook 'elpaca-after-init-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))
            (message "Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time (time-subtract (current-time) before-init-time)))
                     gcs-done)))

;;; init.el ends here
