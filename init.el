;;; init.el --- Beatrix Klebe's Emacs init file -*- lexical-binding: t; -*-

;;; Commentary:
;;; This config borrows liberally from bbatsov's Emacs Prelude (https://github.com/bbatsov/prelude).

;;; Code:

(require 'cl)
(require 'package)

(defvar file-name-handler-alist-cache file-name-handler-alist)
(setq file-name-handler-alist nil)

(defvar root-dir (file-name-directory load-file-name)
  "The root of the current Emacs configuration.")

(defvar lisp-dir (expand-file-name "lisp" root-dir)
  "Location of my custom Lisp modules.")

(defvar autogen-dir (expand-file-name "autogen" lisp-dir)
  "Location for all automatically generated Lisp files.")

(defvar custom-storage-file (expand-file-name "custom.el" autogen-dir)
  "Where autogenerated custom.el settings go.")

(setq custom-file custom-storage-file)

(add-to-list 'load-path lisp-dir)

;; Cribs liberally from bbatsov/prelude/core/prelude-packages.el

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)

(defvar bootstrap-packages '(use-package delight))

(defun bootstrap-packages-installed-p ()
  "Check if all packages in 'bootstrap-packages' are installed."
  (every #'package-installed-p bootstrap-packages))

(defun install-package (package)
  (unless (package-installed-p package)
    (package-install package)))

(defun install-packages (packages)
  (mapc #'install-package packages))

(defun install-bootstrap-packages ()
  "Install all packages required to bootstrap our setup."
  (unless (bootstrap-packages-installed-p)
    (package-refresh-contents)
    (install-packages bootstrap-packages)))

(install-bootstrap-packages)

(eval-when-compile (require 'use-package))
(require 'bind-key)

(setq use-package-always-ensure t)

(use-package delight)

(use-package auto-package-update :demand
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(use-package counsel :demand
  :bind (("C-s" . swiper-isearch)
         ("C-x b" . ivy-switch-buffer)
         ("C-c v" . ivy-push-view)
         ("C-c V" . ivy-pop-view)
         ("C-c C-r" . ivy-resume)
         ("C-c c" . counsel-compile)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c L" . counsel-git-log)
         ("C-c k" . counsel-rg)
         ("C-c m" . counsel-linux-app)
         ("C-c n" . counsel-fzf)
         ("C-x l" . counsel-locate)
         ("C-c J" . counsel-file-jump)
         ("C-S-o" . counsel-rhythmbox)
         ("C-c w" . counsel-wmctrl))
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (counsel-mode 1))

(require 'ui)
(require 'backup)
(when (eq system-type 'darwin) (require 'macos-config))
(when (eq system-type 'windows-nt) (require 'windows-config))
(when (eq system-type 'gnu/linux)
  (add-to-list 'default-frame-alist '(font . "Operator Mono SSm Book-14")))

;; always prefer fresh bytecode
(setq load-prefer-newer t)

;; Reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB).
(setq gc-cons-threshold 50000000)

(require 'editor)

(require 'development)

(use-package git-commit)

(use-package server
  :config (or (server-running-p) (server-mode)))

(use-package elixir-mode
  :init
  (add-hook 'elixir-mode-hook
            (lambda () (add-hook 'before-save-hook 'elixir-format nil t))))

(use-package web-mode
  :mode
  "\\.html?\\'"
  "\\.eex\\'"
  "\\.[jt]sx?\\'"
  "\\.s?css\\'"
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(use-package dash-at-point)

(use-package dockerfile-mode)

(global-git-commit-mode t)

(require 'org-mode-config)

(provide 'init)
;;; init.el ends here
