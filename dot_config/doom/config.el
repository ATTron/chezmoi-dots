;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Berkeley Mono" :size 16 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Berkeley Mono" :size 16))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(after! evil
  (require 'navigate))

(setq evil-normal-state-cursor 'box
      evil-insert-state-cursor 'box
      evil-visual-state-cursor 'box
      evil-emacs-state-cursor 'box
      evil-replace-state-cursor 'box
      evil-operator-state-cursor 'box
      evil-motion-state-cursor 'box)

(add-to-list 'default-frame-alist '(alpha-background . 98))
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(fennel-mode . ("fennel-ls"))))

;; custom functions
(defun +my/compile (arg)
  (interactive "P")
  (if (and (bound-and-true-p compilation-in-progress)
           (buffer-live-p compilation-last-buffer))
      (recompile)
    (let ((default-directory (if (and (not arg) (doom-project-p))
                                 (doom-project-root)
                               default-directory)))
      (call-interactively #'compile))))

(defun +my/next-diag ()
  (interactive)
  (condition-case _
      (flycheck-next-error)
    (user-error (flycheck-first-error))))

(defun +my/prev-diag ()
  (interactive)
  (condition-case _
      (flycheck-previous-error)
    (user-error
     (goto-char (point-max))
     (flycheck-previous-error))))

;; keymaps
(map! :n "-" #'dired-jump)
(map! :after dired
      :map dired-mode-map
      :n "%" #'dired-create-empty-file)
(map! :leader
      (:prefix "c"
       :desc "Compile" "c" #'+my/compile))
(map! :leader
      (:prefix "o"
       :desc "web browser" "w" #'xwidget-webkit-browse-url))
(map! :n "]d" #'+my/next-diag)
(map! :n "[d" #'+my/prev-diag)
(map! :leader
      (:prefix "t"
       :desc "terminal" "t" #'ghostel))

(after! tramp
  (connection-local-set-profile-variables
   'ghostel-tramp-direct-async
   '((tramp-direct-async-process . t)))
  (dolist (method '("ssh" "scp" "rsync"))
    (connection-local-set-profiles
     `(:application tramp :protocol ,method)
     'ghostel-tramp-direct-async)))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
