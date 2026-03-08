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
 '(package-selected-packages nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'default-frame-alist '(font . "JetBrains Mono NL 11"))

(fido-mode 1)
(scroll-bar-mode -1)
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

;; git
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; noob thing to get now and today
; Source - https://stackoverflow.com/a/619525
; Posted by Michael Paulukonis
; Retrieved 2026-03-08, License - CC BY-SA 2.5
(defun now ()
  "Insert string for the current time formatted like '2:34 PM'."
  (interactive)
  (insert (format-time-string "%D %H:%M")))

(defun today ()
  "Insert string for today's date nicely formatted in American style,
e.g. Sunday, September 17, 2000."
  (interactive)
  (format-time-string "%A, %B %e, %Y"))

;; icons
(use-package nerd-icons
  :ensure t
  :config
  (unless (member "Symbols Nerd Font Mono" (font-family-list))
    (nerd-icons-install-fonts t)))

;; Startup screen
(use-package dashboard
  :ensure t

  :init
  (require 'ansi-color)
  (setq dashboard-display-icons-p t)     
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-items '((recents   . 4)
                          (projects  . 4)
                          (bookmarks . 4)
			  (agenda    . 4)
			  (registers . 4)))
  
  (setq dashboard-banner-logo-title
	(string-join
	 (list "Добро пожаловать! Сегодня "
	       (format-time-string "%A, %B %e."))))
  ; (setq dashboard-startup-banner 'official)
  (setq dashboard-startup-banner 'official)
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-footer nil))

(setq inhibit-startup-screen t)

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

;; golden-ratio
(use-package golden-ratio
  :ensure t
  :init
  (golden-ratio-mode 1)
  :config
  (add-to-list 'golden-ratio-extra-commands 'windmove-left)
  (add-to-list 'golden-ratio-extra-commands 'windmove-right)
  (add-to-list 'golden-ratio-extra-commands 'windmove-up)
  (add-to-list 'golden-ratio-extra-commands 'windmove-down)
  (setq golden-ratio-exclude-modes
        '(ediff-mode
          "calendar-mode"
          "calc-mode"
          "dired-mode")))

;; yaml
(use-package yaml-mode
  :ensure t
  :mode ("\\.ya?ml\\'" . yaml-mode))

;; plantuml
(use-package plantuml-mode
  :ensure t
  :mode ("\\.puml\\'" . plantuml-mode)
  :mode ("\\.plantuml\\'" . plantuml-mode)
  :mode ("\\.iuml\\'" . plantuml-mode)
  :config
  ;; using local package ('executable), to use server ('server)
  (setq plantuml-default-exec-mode 'executable)
  (setq plantuml-indent-level 2))

;; markdown
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init
  (setq markdown-command "markdown")
  :config
  (setq markdown-fontify-code-blocks-natively t)
  (setq markdown-header-scaling t)
  (add-hook 'markdown-mode-hook 'visual-line-mode))

;; .env
(use-package dotenv-mode
  :ensure t
  :mode ("\\.env\\..*\\'" . dotenv-mode)
  :mode ("\\.env\\'" . dotenv-mode))

;; temporal files
(defvar my-backup-dir (expand-file-name "backups/" user-emacs-directory))
(defvar my-auto-save-dir (expand-file-name "auto-saves/" user-emacs-directory))

(unless (file-exists-p my-backup-dir)
  (make-directory my-backup-dir t))

(unless (file-exists-p my-auto-save-dir)
  (make-directory my-auto-save-dir t))

(setq backup-directory-alist `(("." . ,my-backup-dir)))
(setq auto-save-file-name-transforms `((".*" ,my-auto-save-dir t)))

(setq create-lockfiles nil)
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

;; docker
(use-package docker
  :ensure t
  :bind ("C-c d" . docker))

;; web (html, css, js, blade.php, jsx)
;; npm install -g vscode-langservers-extracted typescript typescript-language-server
(use-package emmet-mode
  :ensure t
  :hook ((web-mode css-mode js2-mode) . emmet-mode)
  :config
  (setq emmet-indentation 2))

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.jsx?\\'"  . web-mode)
         ("\\.blade\\.php\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-css-colorization t))

(use-package js2-mode ;; pure js
  :ensure t
  :mode "\\.js\\'"
  :config
  (setq js2-basic-offset 2)
  (setq js-indent-level 2))

;; egloters
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

  ;; js
  (add-to-list 'eglot-server-programs
               '((js2-mode js-mode) . ("typescript-language-server" "--stdio")))

  ;; web
  (add-to-list 'eglot-server-programs
               '(web-mode . ("vscode-html-language-server" "--stdio")))

  ;; css
  (add-to-list 'eglot-server-programs
               '(css-mode . ("vscode-css-language-server" "--stdio")))
  
  ;; Format on save for c/c++
  (add-hook 'before-save-hook
	    (lambda ()
	      (when (derived-mode-p 'c++-mode 'c-mode 'python-mode)
		(eglot-format-buffer)))))

(add-hook 'js2-mode-hook 'eglot-ensure)
(add-hook 'web-mode-hook 'eglot-ensure)
(add-hook 'css-mode-hook 'eglot-ensure)

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
