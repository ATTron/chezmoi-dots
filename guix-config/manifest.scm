;;; SINGLE source of truth for Guix packages. Dotfiles/shell are managed by
;;; chezmoi (cross-platform), NOT guix home. Use `guix package -m` only —
;;; do NOT use `guix upgrade` (it's the imperative path and will fight this).

(specifications->manifest
 (list
  ;; search / navigate / view
  "ripgrep"          ; rg
  "fd"               ; Debian: fd-find
  "fzf"
  "nnn"
  "bat"
  "du-dust"
  "tree-sitter"
  "tree-sitter-cli"
  ;; dotfiles
  "chezmoi"
  ;; data
  "jq"
  "duckdb"
  ;; monitors
  "btop"
  "htop"
  ;; shell / multiplexer
  "tmux"
  "zsh"
  ;; dev helpers
  "just"
  "cloc"
  ;; mail — aerc (Guix 0.21 vs Debian trixie 0.20); built with notmuch support.
  ;; msmtp is the outbound path for BOTH aerc and `git send-email`: aerc has no
  ;; TLS-pinning option and Proton Bridge presents a self-signed CA cert, so
  ;; msmtp's tls_trust_file pins it without polluting the system trust store.
  "aerc"
  "msmtp"
  ;; net / media
  "yt-dlp"
  ;; secrets / backup
  "password-store"   ; Debian: pass
  "borg"             ; Debian: borgbackup
  ;; tooling
  "cmake"

  ;; --- OPTIONAL: these SHADOW the system (apt) version via PATH. Uncomment only
  ;; --- if you specifically want the newer Guix build to win for your user shell.
  ;; "git"
  ;; "curl"
  ;; "gh"
  ;; "neovim"
  ))
