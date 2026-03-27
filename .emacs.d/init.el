;;; -*- lexical-binding: t -*-

;;;; * Autoupdate and enable third party packages from melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))


;;;; * Emacs own thing
;;  '(custom-enabled-themes '(leuven-dark))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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
   '(auctex corfu dape dashboard docker doom-modeline doom-themes
	    dotenv-mode eglot-java emmet-mode gitignore-templates
	    golden-ratio js2-mode ligature magit marginalia
	    markdown-mode multiple-cursors nerd-icons orderless
	    plantuml-mode pyvenv smartparens somafm vertico web-mode
	    yaml-mode yasnippet-snippets)))


;;;; * Apparence
;;;; ** Theme and colors
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-tokyo-night t) ;; <- Configure theme here (https://melpa.org/#/doom-themes)
  (doom-themes-visual-bell-config)
  (doom-themes-treemacs-config))

(require 'ansi-color)

(defun color-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region compilation-filter-start (point))))

(add-hook 'compilation-filter-hook 'color-compilation-buffer)


;;;; ** Minibuffer ++
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 35)
  (doom-modeline-bar-width 4)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-buffer-modification-icon t))

(use-package vertico
  :ensure t
  :init
  (vertico-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))


;;;; ** Startup screen
(use-package dashboard
  :ensure t
  :init
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
  (setq dashboard-startup-banner 'official)
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-footer nil))

(setq inhibit-startup-screen t)


;;;; ** Fonts
;;;; *** Font and size
 (defvar mi-font " Fira Code")
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fira Code            ;; By tonsky		   ;;
;; SF Mono              ;; Apple (no liga support) ;;
;; JetBrains Mono NL    ;; JetBrains		   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (find-font (font-spec :name mi-font))
  (set-face-attribute 'default nil :font mi-font :height 120))


;;;; *** Ligatures
(use-package ligature									           
  :ensure t											   
  :config											   
  (global-ligature-mode t)									   
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"   ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="  "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"  "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"  "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"  "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~=" "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"  "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"  ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"  "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"  "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"  "?=" "?." "??" ";;;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)" "\\\\" "://" ";;" "<---" "<----" "<-----" "<------" "<-------" "<--------" "<---------" "<----------" "<-----------" "<------------" "<-------------" "<--------------")))


;;;; *** Icons
(use-package nerd-icons
  :ensure t
  :config
  (unless (member "Symbols Nerd Font Mono" (font-family-list))
    (nerd-icons-install-fonts t)))


;;;; ** User Interface
(add-to-list 'default-frame-alist '(internal-border-width . 10)) ;; Inner margin
;;(fido-mode 1) ;; Autocompletion for minibuffer
(scroll-bar-mode -1) ;; Remove scrollbars
(column-number-mode) ;; Relative numbers on column
(tool-bar-mode -1) ;; Hide GTK menu
(menu-bar-mode -1)
(global-display-line-numbers-mode)
(setq compilation-scroll-output t)
(defalias 'yes-or-no-p 'y-or-n-p)


;;;; * Temporal files (cache, backups)
(defvar mi-temporal-backup-dir (expand-file-name "backups/" user-emacs-directory))
(defvar mi-temporal-auto-save-dir (expand-file-name "auto-saves/" user-emacs-directory))
(defvar mi-temporal-cache-dir (expand-file-name "cache/" user-emacs-directory))

(unless (file-exists-p mi-temporal-backup-dir)
  (make-directory mi-temporal-backup-dir t))

(unless (file-exists-p mi-temporal-auto-save-dir)
  (make-directory mi-temporal-auto-save-dir t))

(unless (file-exists-p mi-temporal-cache-dir)
  (make-directory mi-temporal-cache-dir t))

(setq backup-directory-alist `(("." . ,mi-temporal-backup-dir)))
(setq auto-save-file-name-transforms `((".*" ,mi-temporal-auto-save-dir t)))

(setq make-backup-files t)
(setq create-lockfiles nil)
(setq backup-by-copying t)
(setq delete-old-versions t)
(setq kept-new-versions 6)
(setq kept-old-versions 2)
(setq version-control t)


;;;; * General window and editor agnostics settings 
;;;; ** Save cmd and search history
(use-package savehist
  :ensure nil
  :init
  (savehist-mode))


;;;; ** General spacing
(setq-default c-basic-offset 4)


;;;; ** Window navigation
(windmove-default-keybindings) ;; Enable using S-<arrow> to move between windows 

(use-package golden-ratio ;; Automatic window resize 
  :ensure t
  :init
  (golden-ratio-mode 1)
  :config
  (add-to-list 'golden-ratio-extra-commands 'windmove-left)
  (add-to-list 'golden-ratio-extra-commands 'windmove-right)
  (add-to-list 'golden-ratio-extra-commands 'windmove-up)
  (add-to-list 'golden-ratio-extra-commands 'windmove-down)
  (setq golden-ratio-exclude-modes '(ediff-mode "")))


;;;; ** Multicursors 
(use-package multiple-cursors
  :ensure t
  :bind (
	 ("C->"   . mc/mark-next-like-this)
	 ("C-<"   . mc/mark-previous-like-this)
	 ("C-c a" . mc/mark-all-like-this)
	 ("C-."   . mc/skip-to-next-like-this)
	 ("C-,"   . mc/skip-to-previous-like-this)
	 ("C-c l" . mc/edit-lines)))


;;;; ** Snippets
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t)


;;;; ** Documentation
(use-package eldoc
  :init
  (global-eldoc-mode)
  :config
  (setq eldoc-echo-area-use-multiline-p nil) 
  (setq eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly))


;;;; ** Convient shortcuts
(global-set-key (kbd "C-c s") 'shell)
(global-set-key (kbd "<f5>") 'recompile)
(global-set-key (kbd "C-c SPC") 'completion-at-point)
(global-set-key (kbd "C-j") 'duplicate-line)


;;;; ** Cheat sheet
(use-package which-key
  :ensure t
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 1.5)
  (setq which-key-side-window-location 'bottom
        which-key-sort-order 'which-key-key-order-alpha
        which-key-add-column-padding 1))


;;;; ** Autoclosing pairs and smart manager
(use-package smartparens
  :ensure t
  :hook ((prog-mode text-mode) . smartparens-mode)
  :config
  (require 'smartparens-config))


;;;; * SVN
;;;; ** Git
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package gitignore-templates
  :ensure t)


;;;; * Services
;;;; ** Containers
;;;; *** Docker
(use-package docker
  :ensure t
  :bind ("C-c d" . docker))


;;;; ** Music
;;;; *** Radio somafm
(use-package somafm
  :ensure t
  :config
  (setq somafm-player-command "mpv"
        somafm-player-parameters '("--no-video")))


;;;; * Debugger
;;;; ** gdb
(setq gdb-many-windows t)


;;;; ** Dape (Debugger adapter)
(use-package dape
  :ensure t
  :bind (("C-x C-a b" . dape-breakpoint-toggle) ; [B]reakpoint
         ("C-x C-a r" . dape-continue)          ; [R]un / Continue
         ("C-x C-a n" . dape-next)              ; [N]ext (Step over)
         ("C-x C-a s" . dape-step-in)           ; [S]tep into
         ("C-x C-a f" . dape-step-out)          ; [F]inish (Step out)
         ("C-x C-a q" . dape-quit))             ; [Q]uit
  :config
  (setq dape-inlay-hints t)
  (add-hook 'dape-on-start-hooks 'dape-info)
  (add-hook 'dape-on-stopped-hooks 'dape-info-buffer-cleanup))


;;;; * Custom time macros
(defun mi-time-ins-now ()
  "Inserts date with time like `03/24/26 06:05`"
  (interactive)
  (insert (format-time-string "%D %H:%M")))

(defun mi-time-ins-today ()
  "Inserts date like `martes, marzo 24 2026`"
  (interactive)
  (insert (format-time-string "%A, %B %e %Y")))

(defun mi-time-ins-hoy ()
  "Inserts date in Spanish format like `24/03/2026`"
  (interactive)
  (insert (format-time-string "%d/%m/%Y")))


;;;; * Completion
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


;;;; * Languges
;;;; ** Enviroment files (.env)
(use-package dotenv-mode
  :ensure t
  :mode ("\\.env\\..*\\'" . dotenv-mode)
  :mode ("\\.env\\'" . dotenv-mode))


;;;; ** YAML
(use-package yaml-mode
  :ensure t
  :mode ("\\.ya?ml\\'" . yaml-mode))


;;;; ** PlantUML
(use-package plantuml-mode
  :ensure t
  :mode ("\\.puml\\'" . plantuml-mode)
  :mode ("\\.plantuml\\'" . plantuml-mode)
  :mode ("\\.iuml\\'" . plantuml-mode)
  :config

  ;; using local package ('executable), to use server ('server)
  (setq plantuml-default-exec-mode 'executable)
  (setq plantuml-indent-level 2))


;;;; ** Markdown
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode) ;; enable github style readme here
  :init
  (setq markdown-command "markdown")
  :config
  (setq markdown-fontify-code-blocks-natively t)
  (setq markdown-header-scaling t)
  (add-hook 'markdown-mode-hook 'visual-line-mode))


;;;; ** Python
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


;;;; ** Latex (tex latex lualatex pdftex *tex xelatex)
(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . LaTeX-mode)
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)  
  (setq TeX-PDF-mode t)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode))


;;;; ** Java
;;;; *** Custom macros
(defun mi-java-mvn-save-compile-test () 
  "Custom function for Java programming that saves buffer contents, compiles tests and displays the results using maven test"
  (interactive)
  (save-some-buffers t)
  (if-let ((proj (project-current)))
      (let ((default-directory (project-root proj)))
        (message "Maven started building...")
        
        (let ((exit-code (shell-command "mvn clean test")))
          (if (= exit-code 0)
              (progn
                (message "Maven succeed!")
                (call-interactively 'eglot-java-run-test))
            (message "Maven failled! Check out *Shell Command Output*."))))
    (error "Are you trolling me? No pom.xml found nor git.")))

(defun mi-java-mvn-save-debug-test ()
  "Custom function for Java programming that saves buffer contents, compiles tests and starts debugger for `mvn test`. Note that the debugger window appears once the timer has elapsed. Consider increasing the timer if tests take a while to compile (sync system)."
  (interactive)
  (save-some-buffers t)
  (if-let ((proj (project-current)))
      (let ((default-directory (project-root proj))
            (java-buf (current-buffer)))
        (when (get-buffer "*compilation*")
          (let ((proc (get-buffer-process "*compilation*")))
            (when proc (delete-process proc))))
        (message "Maven started building and serving debug server...")
        (compilation-start "mvn test -Dmaven.surefire.debug" 'compilation-mode)
        (run-with-timer 5 nil
                        (lambda ()
                          (with-current-buffer java-buf
                            (message "Attaching debugger at port 5005...")
                            (let* ((base (alist-get 'jdtls dape-configs))
                                   (config
                                    (list 'modes  (plist-get base 'modes)
                                          'ensure (plist-get base 'ensure)
                                          'fn     (plist-get base 'fn)
                                          :request  "attach"
                                          :hostName "localhost"
                                          :port     5005
                                          :filePath (buffer-file-name java-buf))))
                              (dape config))))))
    (error "Are you trolling me? No pom.xml found nor git.")))


;;;; *** Completion and shortcuts
(use-package eglot-java
  :ensure t
  :hook (java-mode . eglot-java-mode)
  :init (require 'cc-mode)
  :bind (:map java-mode-map
              ("<f4>" . mi-java-mvn-save-compile-test)
              ("<f5>" . mi-java-mvn-save-debug-test)))


;;;; *** Maven multi-module & Project integration
(with-eval-after-load 'project
  (add-to-list 'project-vc-extra-root-markers "pom.xml"))

;;;; *** Debug integration (dape)
(defvar mi-java-debug-plugin-dir (expand-file-name "java-debug/" user-emacs-directory))
(defvar mi-java-debug-plugin-xml "https://repo1.maven.org/maven2/com/microsoft/java/com.microsoft.java.debug.plugin/maven-metadata.xml")
(defvar mi-java-debug-plugin-url-fmt "https://repo1.maven.org/maven2/com/microsoft/java/com.microsoft.java.debug.plugin/%s/%s")
(defvar mi-java-debug-plugin-jar-fmt "com.microsoft.java.debug.plugin-%s.jar")

(defun mi-java-update-debugger ()
  "Fetch && downloads automatically latest version of the debugger from Maven Central."
  (interactive)
  (unless (file-exists-p mi-java-debug-plugin-dir)
    (make-directory mi-java-debug-plugin-dir t))
  
  (message "Fetching debugger plugin from Maven Central...")
  (let* ((metadata-url mi-java-debug-plugin-xml) 
         (buffer (url-retrieve-synchronously metadata-url))
         version)
    (with-current-buffer buffer
      (goto-char (point-min))
      (when (re-search-forward "<release>\\(.*?\\)</release>" nil t)
        (setq version (match-string 1)))
      (kill-buffer))
    
    (if version
        (let* ((jar-name (format  mi-java-debug-plugin-jar-fmt version))
               (jar-url (format mi-java-debug-plugin-url-fmt version jar-name))
               (jar-dest (expand-file-name jar-name mi-java-debug-plugin-dir)))
          
          (if (file-exists-p jar-dest)
              (message "Debugger plugin (%s) installed." version)
	    
            (dolist (f (directory-files mi-java-debug-plugin-dir t "\\.jar$"))
              (delete-file f))
            (message "Downloading version %s..." version)
            (url-copy-file jar-url jar-dest t)
            (message "Debugger plugin (%s) installed." version)))
      (error "Unable to retrive from Maven Central."))))

(defun mi-java-debug-plugin-setup (server eglot-java-eclipse-jdt)
  "Inyecta el .jar del depurador en JDTLS leyendo la carpeta local."
  (let ((jars (when (file-exists-p mi-java-debug-plugin-dir)
                (directory-files mi-java-debug-plugin-dir t "\\.jar$"))))
    (if jars
        `(:bundles [,(car jars)])
      (message "No debugger found. Run M-x mi-java-update-debugger")
      nil)))

(setq eglot-java-user-init-opts-fn 'mi-java-debug-plugin-setup)


;;;; *** Format and style
(defun mi-java-config-jdtls ()
  (setq c-basic-offset 4)
  (setq java-ts-mode-indent-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'java-mode-hook 'mi-java-config-jdtls)
(add-hook 'java-ts-mode-hook 'mi-java-config-jdtls)


;;;; * lsp eglotters
(use-package eglot
  :hook ((c-mode c++-mode python-mode dockerfile-mode yaml-mode LaTeX-mode) . eglot-ensure)
  :bind
  ("C-c r" . eglot-rename)
  ("C-c c" . eglot-code-actions)
  :config


  ;;;; ** Languages
  ;;;; *** C/C++
  (add-to-list 'eglot-server-programs
	       '((c++-mode c-mode)
		 . ("clangd"
		    "--background-index"
		    "--clang-tidy"
		    "--header-insertion=iwyu"
		    "--completion-style=detailed"
		    "--function-arg-placeholders=0"
		    "--fallback-style=GNU")))

  
  ;;;; *** Python 
  (add-to-list 'eglot-server-programs
               '((python-mode) . ("pyright-langserver" "--stdio")))

  
  ;;;; *** Tex 
  (add-to-list 'eglot-server-programs
               '((latex-mode LaTeX-mode tex-mode) . ("texlab")))

  
  ;;;; ** Format on save 
  (add-hook 'before-save-hook
	    (lambda ()
	      (when (and (eglot-managed-p) 
			 (derived-mode-p 'c++-mode 'c-mode 'python-mode 'java-mode))
		(eglot-format-buffer)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
