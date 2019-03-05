;;; init.el --- Beatrix Klebe's Emacs init file

;;; Commentary:
;;; This config borrows liberally from bbatsov's Emacs Prelude (https://github.com/bbatsov/prelude).

;;; Code:

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

;;; This must be called first to setup use-package
(require 'package-config)

(require 'ui)
(require 'backup)
(when (eq system-type 'darwin) (require 'macos-config))
(when (eq system-type 'windows-nt) (require 'windows-config))


(require 'company-config)
(require 'flycheck-config)
(require 'editor)

(require 'development)

(require 'org-mode-config)

(provide 'init)
;;; init.el ends here
