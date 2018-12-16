;;; macOS specific settings
(when (eq system-type 'darwin)
  (use-package exec-path-from-shell
     :config
     (exec-path-from-shell-initialize))

   ;; There's no point in hiding the menu bar on macOS, so let's not do it
   (menu-bar-mode +1)

   ;; Enable emoji, and stop the UI from freezing when trying to display them.
   (when (fboundp 'set-fontset-font)
     (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))
   (add-to-list 'default-frame-alist '(font . "Operator Mono SSm-14")))

(provide 'macos-config)
