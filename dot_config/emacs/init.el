;;; init.el --- Basic Emacs configuration with Evil mode and straight.el

;;; Commentary:
;; A minimal Emacs configuration using straight.el for package management
;; and Evil mode for Vim keybindings

;;; Code:

;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Configure straight.el to use use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; Use built-in org-mode to avoid installation issues
(setq straight-built-in-pseudo-packages '(org))

;; Basic Emacs settings
(setq inhibit-startup-message t)        ; Disable startup screen

;; Disable GUI elements (with guards for terminal/minimal builds)
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))                 ; Disable visible scrollbar
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))                   ; Disable the toolbar
(when (fboundp 'tooltip-mode)
  (tooltip-mode -1))                    ; Disable tooltips
(when (fboundp 'set-fringe-mode)
  (set-fringe-mode 10))                 ; Give some breathing room
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))                   ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

;; Line numbers
(column-number-mode)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Font configuration (only in GUI mode)
(when (display-graphic-p)
  (set-face-attribute 'default nil :font "Berkeley Mono" :height 120))

;; Evil mode - Vim keybindings
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

;; Evil collection - Evil bindings for other modes
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Which-key - Shows available keybindings
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

;; Ivy - Completion framework
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; Counsel - Enhanced commands using Ivy
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

;; Ivy-rich - Better descriptions in Ivy
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; Helpful - Better help buffers
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; General - Better keybinding management
(use-package general
  :config
  (general-create-definer my/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (my/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "tn" '(display-line-numbers-mode :which-key "toggle line numbers")
    "f"  '(:ignore t :which-key "files")
    "ff" '(counsel-find-file :which-key "find file")
    "fr" '(counsel-recentf :which-key "recent files")
    "b"  '(:ignore t :which-key "buffers")
    "bb" '(counsel-ibuffer :which-key "switch buffer")
    "bd" '(kill-current-buffer :which-key "kill buffer")
    "o"  '(:ignore t :which-key "org")
    "oa" '(org-agenda :which-key "agenda")
    "oc" '(org-capture :which-key "capture")
    "ol" '(org-store-link :which-key "store link")
    "ot" '(org-todo :which-key "cycle todo")
    "ox" '(org-toggle-checkbox :which-key "toggle checkbox")
    "os" '(org-schedule :which-key "schedule")
    "od" '(org-deadline :which-key "deadline")
    "h"  '(:ignore t :which-key "help")
    "hf" '(counsel-describe-function :which-key "describe function")
    "hv" '(counsel-describe-variable :which-key "describe variable")
    "hk" '(helpful-key :which-key "describe key")))

;; Doom themes - Nice looking themes
(use-package doom-themes
  :init (load-theme 'doom-gruvbox-light t))

;; Doom modeline - Better modeline (alternative: comment out if issues persist)
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom 
  ((doom-modeline-height 15)
   (doom-modeline-icon nil)           ; Disable all icons
   (doom-modeline-major-mode-icon nil) ; Disable major mode icons
   (doom-modeline-buffer-state-icon nil))) ; Disable buffer state icons

;; Alternative simple modeline (uncomment if doom-modeline still has issues)
;; (setq-default mode-line-format
;;               '("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position
;;                 (vc-mode vc-mode)
;;                 "  " mode-line-modes mode-line-misc-info mode-line-end-spaces))

;; All-the-icons - Icon fonts for doom-modeline
(use-package all-the-icons
  :if (display-graphic-p))

;; Rainbow delimiters - Colorful parentheses
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Projectile - Project management
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/projects")
    (setq projectile-project-search-path '("~/projects")))
  (setq projectile-switch-project-action #'projectile-dired))

;; Counsel-projectile - Ivy integration for Projectile
(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; Magit - Git interface
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Company - Code completion
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

;; Company-box - Better company UI
(use-package company-box
  :hook (company-mode . company-box-mode))

;; LSP Mode - Language Server Protocol
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

;; LSP UI - Better LSP interface
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

;; LSP Treemacs - File explorer integration
(use-package lsp-treemacs
  :after lsp)

;; LSP Ivy - Ivy integration for LSP
(use-package lsp-ivy)

;; Org Mode configuration
(use-package org
  :straight nil  ; Use built-in org-mode
  :hook (org-mode . org-indent-mode)
  :config
  (setq org-ellipsis " ▾")
  
  ;; Org agenda files
  (setq org-agenda-files
        '("~/org/tasks.org"
          "~/org/habits.org"
          "~/org/birthdays.org"))
  
  ;; TODO keywords
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  
  ;; Org capture templates
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/org/tasks.org" "Tasks")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
          ("j" "Journal" entry (file+datetree "~/org/journal.org")
           "* %?\nEntered on %U\n  %i\n  %a")))
  
  ;; Org babel languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)))
  
  ;; Don't prompt before evaluating code blocks
  (setq org-confirm-babel-evaluate nil)
  
  ;; Hide emphasis markers (like *bold* and /italic/)
  (setq org-hide-emphasis-markers t)
  
  ;; Better list bullets
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  
  ;; Archive location
  (setq org-archive-location "~/org/archive.org::datetree/"))

;; Org modern - Better looking org mode with icons
(use-package org-modern
  :after org
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :custom
  (org-modern-keyword nil)
  (org-modern-checkbox nil)
  (org-modern-table nil))

;; Evil-org - Better Evil integration with org-mode
(use-package evil-org
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)
  
  ;; Add custom keybindings for org-mode
  (evil-define-key 'normal org-mode-map
    (kbd "RET") (lambda () 
                  (interactive)
                  (cond 
                   ;; Check if we're on a line with checkbox syntax (anywhere on the line)
                   ((save-excursion 
                      (beginning-of-line)
                      (re-search-forward "\\[[ X]\\]" (line-end-position) t))
                    (org-toggle-checkbox))
                   ;; If on a heading with TODO keyword, cycle TODO
                   ((and (org-at-heading-p) (org-get-todo-state))
                    (org-todo))
                   ;; Default behavior
                   (t (org-return))))
    (kbd "TAB") 'org-cycle ; Tab for folding
    (kbd "S-TAB") 'org-shifttab) ; Shift-Tab for global cycling
  
  ;; Make sure evil-org knows about these keys
  (add-to-list 'evil-org-key-theme 'todo))

;; Org-roam - Zettelkasten note-taking (optional)
;; Uncomment if you want to use org-roam for linked notes
;; (use-package org-roam
;;   :custom
;;   (org-roam-directory (file-truename "~/org-roam/"))
;;   :bind (("C-c n l" . org-roam-buffer-toggle)
;;          ("C-c n f" . org-roam-node-find)
;;          ("C-c n g" . org-roam-graph)
;;          ("C-c n i" . org-roam-node-insert)
;;          ("C-c n c" . org-roam-capture))
;;   :config
;;   (org-roam-db-autosync-mode))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Basic editing improvements
(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)
(setq-default indent-tabs-mode nil)

;; Backup files
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))

;; Auto-save
(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))

;; Create directories if they don't exist
(make-directory (expand-file-name "tmp/auto-saves/" user-emacs-directory) t)
(make-directory (expand-file-name "tmp/backups/" user-emacs-directory) t)

;;; init.el ends here
