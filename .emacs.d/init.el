;;; -*- lexical-binding: t -*-

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(leuven-dark))
 '(custom-safe-themes
   '("d80952c58cf1b06d936b1392c38230b74ae1a2a6729594770762dc0779ac66b7"
     default))
 '(display-line-numbers-type 'relative)
 '(face-font-family-alternatives
   '(("Monospace Serif" "Courier 10 Pitch" "Consolas" "Courier Std"
      "FreeMono" "Nimbus Mono L" "courier" "fixed")
     ("courier" "CMU Typewriter Text" "fixed")
     ("Sans Serif" "helv" "helvetica" "arial" "fixed")
     ("helv" "helvetica" "Inter" "arial" "fixed")))
 '(package-selected-packages
   '(activities auctex company corfu docker docker
		dockerfile-mode emmet-mode gruvbox-theme html5-schema
		js2-mode magit multiple-cursors pdf-tools php-mode plz
		posframe pyvenv rainbow-mode web-mode webdriver
		websocket)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'default-frame-alist '(font . "JetBrains Mono NL 11"))

(fido-mode 1)
(column-number-mode)
(tool-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode)
;; (desktop-save-mode 1)
(windmove-default-keybindings)
(setq compilation-scroll-output t)
(setq gdb-many-windows t)
(defalias 'yes-or-no-p 'y-or-n-p)

;; (use-package vertico
;;    :ensure t
;;    :init
;;    (vertico-mode))

;; completion
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-quit-no-match 'separator)
  (corfu-cycle t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.1)
  :init
  (global-corfu-mode)
  :config
  (setq tab-always-indent 'complete)
  (setq completion-show-inline-help nil)
  (add-to-list 'display-buffer-alist
               '("\\*Completions\\*"
                 (display-buffer-no-window)
                 (allow-no-window . t))))
  
(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay 0.5))

;; temporal files
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory))))

(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t)))

(setq backup-by-copying t)
(setq delete-old-versions t)
(setq kept-new-versions 6)
(setq kept-old-versions 2)
(setq version-control t)

;; Custom theme
(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-hard t))

;; multicursors
(use-package multiple-cursors
  :ensure t
  :bind (
	 ("C->"   . mc/mark-next-like-this)
	 ("C-<"   . mc/mark-previous-like-this)
	 ("C-c a" . mc/mark-all-like-this)
	 ("C-."   . mc/skip-to-next-like-this)
	 ("C-,"   . mc/skip-to-previous-like-this)
	 ("C-c l" . mc/edit-lines)))

;; Python
(use-package pyvenv
  :ensure t
  :config
  (setq pyvenv-mode-line-indicator '(pyvenv-virtual-env-name ("[venv:" pyvenv-virtual-env-name "] ")))
  (pyvenv-mode 1))

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python3" . python-mode)
  :config
  (setq python-shell-interpreter "python3"))

(use-package docker
  :ensure t
  :bind ("C-c d" . docker))

(use-package eglot
  :hook ((c-mode c++-mode python-mode dockerfile-mode yaml-mode) . eglot-ensure)
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

  ;; python 
  (add-to-list 'eglot-server-programs
               '((python-mode) . ("pyright-langserver" "--stdio")))
  
  ;; php
  (add-to-list 'eglot-server-programs
               '((php-mode) . ("intelephense" "--stdio")))

  ;; css
  (add-to-list 'eglot-server-programs
               '((css-mode) . ("vscode-css-language-server" "--stdio")))

  ;; Format on save for c/c++
  (add-hook 'before-save-hook
	    (lambda ()
	      (when (derived-mode-p 'c++-mode 'c-mode 'python-mode)
		(eglot-format-buffer)))))

;; company
;; (use-package company
;;   :ensure t
;;   :init
;;   (global-company-mode)
;;   :config
;;   (setq company-idle-delay 0.1)
;;   (setq company-minimum-prefix-length 2)
;;   (setq company-show-numbers t)
;;   (setq company-dabbrev-downcase nil)
;;   (setq company-dabbrev-ignore-case nil)
;;   (setq company-dabbrev-code-ignore-case nil))

(setq-default c-basic-offset 4)

(use-package eldoc
  :init
  (global-eldoc-mode)
  :config
  (setq eldoc-echo-area-use-multiline-p nil) 
  (setq eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly))

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

;(use-package yasnippet
;  :config
;  (yas-global-mode 1))
;
;(use-package yasnippet-snippets)

;; keys
(global-set-key (kbd "C-c s") 'shell)
(global-set-key (kbd "<f5>") 'recompile)
(global-set-key (kbd "C-c SPC") 'completion-at-point)
(global-set-key (kbd "C-j") 'duplicate-line)

;; Wayland & system clipboard
(setq select-enable-clipboard t)
(setq select-enable-primary t)

(cond
 ((getenv "WAYLAND_DISPLAY")
  (if (executable-find "wl-copy")
      (progn
	(setq interprogram-cut-function
	      (lambda (text)
		(unless (bound-and-true-p multiple-cursors-mode)
		 (start-process "wl-copy" nil "wl-copy" text))))
	(setq interprogram-paste-function
	      (lambda ()
		(unless (bound-and-true-p multiple-cursors-mode)
		  (shell-command-to-string "wl-paste -n | tr -d \r")))))
    (message "WARNING: You are on Wayland and wl-clipboard utilities are not installed on this system. "))))
