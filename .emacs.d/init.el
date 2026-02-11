;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(leuven-dark))
 '(face-font-family-alternatives
   '(("JetBrains Mono NL" "courier" "fixed")
     ("Monospace Serif" "Courier 10 Pitch" "Consolas" "Courier Std"
      "FreeMono" "Nimbus Mono L" "courier" "fixed")
     ("courier" "CMU Typewriter Text" "fixed")
     ("Sans Serif" "helv" "helvetica" "arial" "fixed")
     ("helv" "helvetica" "arial" "fixed")))
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode)
(desktop-save-mode 1)
(windmove-default-keybindings)
(setq compilation-scroll-output t)
(setq gdb-many-windows t)
(defalias 'yes-or-no-p 'y-or-n-p)

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-quit-no-match 'separator)
  (corfu-cycle t)
  :init
  (global-corfu-mode))

(use-package eglot
  :hook ((c-mode c++-mode) . eglot-ensure)
  :bind ("C-c r" . eglot-rename)
  :config
  ;; c/c++
  (add-to-list 'eglot-server-programs
	       '((c++-mode c-mode)
		 . ("clangd"
		    "--background-index"
		    "--clang-tidy"
		    "--header-insertion=iwyu"
		    "--completion-style=detailed"
		    "--function-arg-placeholders=0"
		    "--fallback-style=GNU")))

  ;; php
  (add-to-list 'eglot-server-programs
               '((php-mode) . ("intelephense" "--stdio")))

  ;; css
  (add-to-list 'eglot-server-programs
               '((css-mode) . ("vscode-css-language-server" "--stdio")))
  
  ;; format on save for c/c++
  (add-hook 'before-save-hook
	    (lambda ()
	      (when (derived-mode-p 'c++-mode 'c-mode)
		(eglot-format-buffer)))))

(setq-default c-basic-offset 4)

(use-package eldoc
  :init
  (global-eldoc-mode))

;; php
(use-package php-mode
  :mode "\\.php\\'"
  :config
  (setq php-mode-coding-style 'psr2))

;; css
(use-package css-mode
  :ensure nil
  :config
  (setq css-indent-offset 2))

;; web
(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.blade\\.php\\'" . web-mode)
         ("\\.js\\'" . web-mode))
  :config
  ;; blade php
  (setq web-mode-engines-alist '(("blade" . "\\.blade\\.php\\'")))
  
  ;; css, html
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-css-colorization t))

;; emmet
(use-package emmet-mode
  :hook (web-mode css-mode sgml-mode)
  :config
  (setq emmet-indentation 2))


(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets)

;; keys
(global-set-key (kbd "<f5>") 'recompile)
(global-set-key (kbd "C-c SPC") 'completion-at-point)

;; artisan php
(defun artisan (cmd)
  "Run artisan on root directory."
  (interactive "sArtisan command: ")
  (let ((default-directory (project-root (project-current t))))
    (async-shell-command (concat "php artisan " cmd))))
(global-set-key (kbd "C-c a") 'artisan)

;; Wayland & system clipboard
(setq select-enable-clipboard t)
(setq select-enable-primary t)

(cond
 ((getenv "WAYLAND_DISPLAY")
  (if (executable-find "wl-copy")
      (progn
	(setq interprogram-cut-function
	      (lambda (text)
		(start-process "wl-copy" nil "wl-copy" text)))
	(setq interprogram-paste-function
	      (lambda ()
		(shell-command-to-string "wl-paste -n | tr -d \r"))))
    (message "WARNING: You are on Wayland and wl-clipboard utilities are not installed on this system. "))))

