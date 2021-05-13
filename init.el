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
                    :family "mononoki Nerd Font"
                    :height 110)

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
(global-set-key (kbd "C-c '") 'vterm-open-split)

(defun vterm-open-split ()
  "Open vterm in a horizontal split below."
  (interactive)
  (select-window (split-window-below -20))
  (vterm)
  (switch-to-buffer "*vterm*"))

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
  (setq exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-initialize))

;; Terminal
(use-package vterm)

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

;; EditorConfig
(use-package editorconfig
  :config
  (editorconfig-mode 1))

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

;; Project tree view
(use-package neotree
  :bind ("C-c o t" . neotree-toggle)
  :config
  (setq neo-theme 'icons
        neo-window-width 40
        neo-mode-line-type 'none))

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

(use-package git-gutter+
  :hook (prog-mode . git-gutter+-mode))

;; Project management
(use-package projectile
  :bind
  (("C-c p" . projectile-command-map))
  :init
  (projectile-mode 1))

(use-package counsel-projectile
  :init
  (counsel-projectile-mode))

;; LSP
(use-package lsp-mode
  :config
  (setq lsp-headerline-breadcrumb-enable nil))

(use-package lsp-ui
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable nil
        lsp-ui-doc-enable nil
        evil-lookup-func 'lsp-ui-doc-glance))

(use-package lsp-treemacs)

(use-package rbenv
  :hook (after-init . global-rbenv-mode)
  :init (setq rbenv-show-active-ruby-in-modeline nil
              rbenv-executable "rbenv"))

(use-package yaml-mode)

(use-package inf-ruby
  :config
  (setq ruby-insert-encoding-magic-comment nil)
  :bind (:map ruby-mode-map
              ("C-c '" . vterm-open-split))
  :hook ((ruby-mode . inf-ruby-minor-mode)
         (ruby-mode . lsp)
         (compilation-filter . inf-ruby-auto-enter)))

(use-package yard-mode
  :hook (ruby-mode . yard-mode))

(use-package projectile-rails
  :hook (projectile-mode . projectile-rails-global-mode))

;; C
(add-hook 'c-mode-hook 'lsp)

;; JS/TS
(use-package js2-mode
  :hook (js-mode . js2-minor-mode)
  :config (setq js-chain-indent t
                js2-basic-offset 2
                js2-mode-show-parse-errors nil
                js2-mode-show-strict-warnings nil
                js2-strict-trailing-comma-warning nil
                js2-strict-missing-semi-warning nil))

(use-package tide
  :hook ((js-mode typescript-mode) . tide-setup))

(use-package typescript-mode
  :bind (:map typescript-mode-map
              ("C-c '" . eshell-open-split)))

(use-package json-mode)

;; HTML
(use-package web-mode)

;; Slim
(use-package slim-mode)

;; Elixir
(use-package elixir-mode
  :hook (elixir-mode-local-vars . lsp))

(use-package flycheck-credo
  :config (flycheck-credo-setup))

(use-package alchemist
  :hook (elixir-mode . alchemist-mode))
