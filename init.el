;; Interface cleanup
(setq initial-scratch-message ""
      inhibit-splash-screen t
      use-dialog-box nil)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)

;; Default font
(set-face-attribute 'default nil
                    :family "FantasqueSansMono Nerd Font"
                    :height 120)

(setq-default line-spacing 0.4)

;; Enable builtin modes
(show-paren-mode 1)
(column-number-mode 1)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Set only one confirmation prompt
(fset 'yes-or-no-p 'y-or-n-p)

;; Disable backups and lockfiles
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

;; Indent with spaces
(setq-default indent-tabs-mode nil
              tab-width 2)

;; Smooth scrolling
(setq scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

;; Open a terminal split
(global-set-key (kbd "C-c '") 'eshell-open-split)

(defun eshell-open-split ()
  "Open eshell in a horizontal split below."
  (interactive)
  (select-window (split-window-below -20))
  (eshell)
  (switch-to-buffer "*eshell*"))


;; Kill all buffers
(global-set-key (kbd "C-x K") (lambda ()
                                (interactive)
                                (mapc 'kill-buffer (buffer-list))
                                (delete-other-windows)))

;; Setup package.el
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Setup use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; Load shell environment variables
(use-package exec-path-from-shell
  :init
  (exec-path-from-shell-initialize))

;; Evil mode
(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode))

(use-package evil-collection
  :after evil
  :custom (evil-collection-setup-minibuffer t)
  :init
  (evil-collection-init))

;; Smart tab
(use-package smart-tab
  :init
  (global-smart-tab-mode))

;; Doom themes and modeline
(use-package doom-themes
  :config
  (setq doom-themes-enable-italic t)
  (load-theme 'doom-solarized-dark t)
  :init
  (doom-themes-org-config)
  (doom-themes-neotree-config))

(use-package doom-modeline
  :init
  (doom-modeline-mode))

;; Auto completion
(use-package company
  :hook (company-mode . evil-normalize-keymaps)
  :config
  (setq company-minimum-prefix-length 2
        company-idle-delay 0.25)
  :init
  (global-company-mode))

(use-package ivy
  :config
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t)
  :init
  (ivy-mode))

(use-package counsel
  :init
  (counsel-mode))

;; Syntax checking
(use-package flycheck
  :init
  (global-flycheck-mode))

(use-package flycheck-popup-tip
  :hook (flycheck-mode . flycheck-popup-tip-mode))

;; Display keybindings
(use-package which-key
  :init
  (which-key-mode))

;; Multiple cursors
(use-package evil-multiedit
  :init
  (require 'evil-multiedit)
  (evil-multiedit-default-keybinds))

;; Trim whitespace
(use-package ws-butler
  :hook (prog-mode . ws-butler-mode))

;; Auto insert pairs
(use-package autopair
  :init
  (autopair-global-mode))

;; Git integration
(use-package magit
  :bind
  (("C-c g" . magit-status)))

(use-package evil-magit)

(use-package git-gutter+
  :hook (prog-mode . git-gutter+-mode))

;; Project management
(use-package projectile
  :bind
  (("C-c p" . projectile-command-map)))

(use-package counsel-projectile
  :init
  (counsel-projectile-mode))

;; LSP support
(use-package lsp-mode)

(use-package lsp-ui
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable nil
        lsp-ui-doc-enable nil
        evil-lookup-func 'lsp-ui-doc-glance))

(use-package company-lsp
  :commands company-lsp
  :config
  (push 'company-lsp company-backends)
  (setq company-lsp-async t
        company-lsp-enable-recompletion t))

;; Parinfer for lispy languages
(use-package parinfer
  :hook ((emacs-lisp-mode
          clojure-mode
          scheme-mode
          lisp-mode
          racket-mode) . parinfer-mode)
  :config
  (setq parinfer-extensions '(defaults evil smart-tab)))

;; Scheme support
(use-package geiser)

(use-package flycheck-guile
  :after geiser)

;; Haskell support
(use-package haskell-mode
  :hook (haskell-mode . interactive-haskell-mode))

(use-package dante
  :hook (haskell-mode . dante-mode)
  :config
  (setq dante-load-flags '("+c"
                           "-Wwarn=missing-home-modules"
                           "-fno-diagnostics-show-caret"
                           "-Wall"
                           "-fdefer-typed-holes"
                           "-fdefer-type-errors"))
  (flycheck-add-next-checker 'haskell-dante '(info . haskell-hlint)))

;; Nix support
(use-package nix-mode
  :mode "\\.nix\\'")

;; Elm Support
(use-package elm-mode
  :hook (elm-mode . lsp))

(use-package robe
  :hook (ruby-mode . robe-mode)
  :config
  (push 'company-robe company-backends))
