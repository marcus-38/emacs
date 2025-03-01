;;; init.el -*- lexical-binding: t; -*-

;;; Commentary:
;; This is my personal Emacs configuration. The file is tangled from a
;; literate org document where I try to document what each piece is for.
;; If you found my configurations you are free to use as you please, but
;; please read the whole thing before you do. I regulary commit my
;; configuration even though it is not working. Yes, I know, you shouldn't
;; do that but you have been warned.

;; Here be dragons

;; Code:

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			 ("gnu" . "https://elpa.gnu.org/packgages/")))
(setq package-user-dir (expand-file-name "~/.emacs.d/packages"))
(require 'package)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)
(require 'use-package)

(when (memq window-system '(mac ns))
  (use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize)))

(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta
        mac-command-modifier 'super
        mac-right-option-modifier 'none)
  (global-set-key (kbd "s-c") 'kill-ring-save)
  (global-set-key (kbd "s-v") 'yank)
  (global-set-key (kbd "s-x") 'kill-region)
  (global-set-key (kbd "s-a") 'mark-whole-buffer)
  (global-set-key (kbd "s-z") 'undo)
  (global-set-key (kbd "s-f") 'isearch-forward)
  (global-set-key (kbd "s-g") 'isearch-repeat-forward)
  (global-set-key (kbd "s-o") 'find-file)
  (global-set-key (kbd "s-n") 'find-file)
  (global-set-key (kbd "s-s") 'save-buffer)
  ;(global-set-key (kbd "s-p") 'mac-preview)
  (global-set-key (kbd "s-w") 'kill-buffer)
  (global-set-key (kbd "s-m") 'iconify-frame)
  (global-set-key (kbd "s-q") 'save-buffers-kill-emacs)
  (global-set-key (kbd "s-.") 'keyboard-quit)
  (global-set-key (kbd "s-l") 'goto-line)
  (global-set-key (kbd "s-k") 'kill-buffer)
  (global-set-key (kbd "s-<up>") 'beginning-of-buffer)
  (global-set-key (kbd "s-<down>") 'end-of-buffer)
  (global-set-key (kbd "s-<left>") 'beginning-of-line)
  (global-set-key (kbd "s-<right>") 'end-of-line)
  (global-set-key [(meta down)] 'forward-paragraph)
  (global-set-key [(meta up)] 'backward-paragraph)
  )

(setq-default c-basic-offset 4
	      c-default-style "linux"
	      indent-tabs-mode nil
	      fill-column 80
	      tab-width 4)

(tool-bar-mode -1)                 ; Disable the tool-bar.
(scroll-bar-mode -1)               ; Specify whether to have vertical scroll bars, and on which side.
(menu-bar-mode t)                  ; I use a Mac and it looks odd if there is no menu

(setq load-prefer-newer t)         ; Non-nil means load prefers the newest version of a file.
(setq tab-always-indent 'complete) ; Controls the operation of the TAB key.

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-vsplit-window-right t
        evil-split-window-below t
        evil-undo-system 'undo-redo)
  (evil-mode 1))
(use-package evil-collection
  :ensure t
  :after evil
  :config
  (add-to-list 'evil-collection-mode-list 'help)
  (evil-collection-init))
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))
(setq org-return-follows-link t)

(global-set-key (kbd "C-c t") 'ef-themes-toggle)       ; toggle theme 
(global-set-key (kbd "C-c g") 'magit-status)           ; magit status
(global-set-key (kbd "C-c p") 'projectile-command-map) ; projectile command map
(global-set-key (kbd "C-+") 'text-scale-increase)      ; increase text size
(global-set-key (kbd "C--") 'text-scale-decrease)      ; decrease text size
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(use-package counsel
  :ensure t
  :after ivy
  :diminish
  :config
  (counsel-mode)
  (setq ivy-initial-inputs-alist nil))

(use-package ivy
  :ensure t
  :bind
  (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window))
  :diminish
  :custom
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "
        enable-recursive-minibuffers t)
  :config
  (ivy-mode))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :ensure t
  :after ivy
  :init (ivy-rich-mode 1)
  :custom (ivy-virtual-abbreviate 'full
                                  ivy-rich-switch-buffer-align-virtual-buffer t
                                  ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))

(use-package general
  :ensure t
  :config
  (general-evil-setup)
  ;; set up "SPC" as the global leader key
  (general-create-definer my/leader-keys
                          :states '(normal insert visual emacs)
                          :keymaps 'override
                          :prefix "SPC"
                          :global-prefix "M-SPC") ; access leader key in insert mode
  (my/leader-keys
   "SPC" '(counsel-M-x :wk "Counsel M-x")
   "." '(find-file :wk "Find file")
   "TAB TAB" '(comment-line :wk "Comment lines")
   "u" '(universal-argument :wk "Universal argument")
   )

  (my/leader-keys
    "b" '(:ignore t :wk "Bookmarks/Buffers")
    "b b" '(switch-to-buffer :wk "Switch to buffer")
    "b c" '(clone-indirect-buffer :wk "Create indirect buffer copy in a split")
    "b C" '(clone-indirect-buffer-other-window :wk "Clone indirect buffer in new window")
    "b d" '(bookmark-delete :wk "Delete bookmark")
    "b i" '(ibuffer :wk "Ibuffer")
    "b k" '(kill-current-buffer :wk "Kill current buffer")
    "b l" '(list-bookmarks :wk "List bookmarks")
    "b m" '(bookmark-set :wk "Set bookmark")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Previous buffer")
    "b r" '(revert-buffer :wk "Reload buffer")
    "b R" '(rename-buffer :wk "Rename buffer")
    "b s" '(basic-save-buffer :wk "Save buffer")
    "b S" '(save-some-buffers :wk "Save multiple buffers")
    "b w" '(bookmark-save :wk "Save current bookmarks to bookmark file")
    )

  (my/leader-keys
    "d" '(:ignore t :wk "Dired")
    "d d" '(dired :wk "Open dired")
    "d j" '(dired-jump :wk "Dired jump to current")
    )

  (my/leader-keys
    "e" '(:ignore t :wk "Eshell/Evaluate")
    "e b" '(eval-buffer :wk "Evaluate elisp in buffer")
    "e d" '(eval-defun :wk "Evaluate defun containing or after point")
    "e e" '(eval-expression :wk "Evaluate and elisp expression")
    "e h" '(counsel-ssh-history :wk "Eshell history")
    "e l" '(eval-last-sexp :wk "Evaluate elisp expression before point")
    "e r" '(eval-region :wk "Evaluate elisp in region")
    "e R" '(eww-reload :wk "Reload current page in EWW")
    "e s" '(eshell :wk "Eshell")
    "e w" '(eww :wk "EWW emacs web browser")
    )

  (my/leader-keys
    "f" '(:ignore t :wk "Files")
    "f c" '((lambda () (interactive) (find-file "~/.emacs.d/README.org")) :wk "Open emacs configuration file")
    "f e" '((lambda () (interactive) (dired "~/.emacs.d/")) :wk "Open user-emacs-directory in dired")
    "f g" '(counsel-grep-or-swiper :wk "Search for string current file")
    "f j" '(counsel-file-jump :wk "Jump to a file below current directory")
    "f l" '(counsel-locate :wk "Locate a file")
    "f r" '(counsel-recentf :wk "Find recent files")
    )

  (my/leader-keys
    "g" '(:ignore t :wk "Git")
    "g d" '(magit-dispatch :wk "Magit dispatch")
    "g ." '(magit-file-dispatch :wk "Magit file dispatch")
    "g b" '(magit-branch-checkout :wk "Switch branch")
    "g c" '(:ignore t :wk "Create")
    "g c b" '(magit-branch-and-checkout :wk "Create branch and checkout")
    "g c c" '(magit-commit-create :wk "Create commit")
    "g c f" '(magit-commit-fixup :wk "Create fixup commit")
    "g C" '(magit-clone :wk "Clone repo")
    "g f" '(:ignore t :wk "Find")
    "g f c" '(magit-show-commit :wk "Magit show commit")
    "g f f" '(magit-find-file :wk "Magit find file")
    "g f g" '(magit-find-git-config-file :wk "Find gitconfig file")
    "g F" '(magit-fetch :wk "Git fetch")
    "g g" '(magit-status :wk "Magit status")
    "g i" '(magit-init :wk "Initialize git repo")
    "g l" '(magit-log-buffer-file :wk "Magit buffer log")
    "g r" '(vc-revert :wk "Git revert file")
    "g s" '(magit-stage-file :wk "Git stage file")
    "g u" '(magit-unstage-file :wk "Git unstage file")
    )
  )

(use-package helpful
  :ensure t
  :commands (helpful-at-point
	     helpful-callable
	     helpful-command
	     helpful-function
	     helpful-key
	     helpful-macro
	     helpful-variable)
  :bind
  ([remap display-local-help] . helpful-at-point)
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-key] . helpful-key)
  ([remap describe-command] . helpful-command))

(use-package move-text
  :ensure t
  :defer
  :init (move-text-default-bindings))

(use-package which-key
  :ensure t
  :delight
  :custom (which-key-idle-delay 0.5)
  :config (which-key-mode))

(use-package vertico
  :ensure t
  :init (vertico-mode)
  :bind (:map vertico-map
	      ("C-<backspace>" . vertico-directory-up))
  :config
  (keymap-set vertico-map "?" #'minibuffer-completion-help)
  (keymap-set vertico-map "M-RET" #'minibuffer-force-complete-and-exit)
  (keymap-set vertico-map "M-TAB" #'minibuffer-complete))

(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :ensure t
  :after vertico
  :init (marginalia-mode)
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil)))

(use-package orderless
  :ensure t
  :custom
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles . (partial-completion)))))
  (completion-styles '(orderless)))

(use-package emacs
  :custom
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(add-to-list 'load-path "~/.emacs.d/manual-packages/ef-themes")
    (require 'ef-themes)
    (setq ef-themes-to-toggle '(ef-arbutus ef-elea-dark))
    (setq ef-themes-headings
    	'((0 variable-pitch light 1.9)
    	  (1 variable-pitch light 1.8)
    	  (2 variable-pitch regular 1.7)
    	  (3 variable-pitch regular 1.6)
    	  (4 variable-pitch regular 1.5)
    	  (5 variable-pitch 1.4) ; absence of weight means 'bold'
    	  (6 variable-pitch 1.3)
    	  (7 variable-pitch 1.2)
    	  (t variable-pitch 1.1)))
  (setq ef-themes-mixed-fonts t
        ef-themes-variable-pitch-ui t)
(mapc #'disable-theme custom-enabled-themes) ; disable all other themes to avoid awkward blending
(load-theme 'ef-arbutus :no-confirm)

(use-package doom-themes
  :ensure t)

(use-package doom-modeline
  :ensure t
  :config
  (setq
   doom-modeline-support-imenu t
   doom-modeline-icon t
   doom-modeline-major-mode-icon t
   doom-modeline-buffer-state-icon t
   doom-modeline-buffer-modification-icon t
   doom-modeline-column-zero-based t
   doom-modeline-highlight-modified-buffer-name nil
   doom-modeline-percent-position '(-3 "%p")
   doom-modeline-position-column-line-format '("%l:%c")
   doom-modeline-total-line-number t
   doom-modeline-modal t
   doom-modeline-modal-modern-icon t
   doom-modeline-time t
   )
  (setq doom-modeline-height 25)
  (if (facep 'mode-line-active)
      (set-face-attribute 'mode-line-active nil :family "Noto Sans" :height 140)
    (set-face-attribute 'mode-line nil :family "Noto Sans" :height 140)
    (set-face-attribute 'mode-line-inactive nil :family "Noto Sans" :height 140))
  :init
  (doom-modeline-mode 1))

(set-face-attribute 'default nil
                    :font "Iosevka Fixed"
                    :height 160
                    :weight 'medium)
(set-face-attribute 'variable-pitch nil
                    :font "Iosevka"
                    :height 150
                    :weight 'medium)
(set-face-attribute 'fixed-pitch nil
                    :font "Iosevka Fixed"
                    :height 160
                    :weight 'medium)
(set-face-attribute 'font-lock-comment-face nil
                    :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
                    :slant 'italic)

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-completion
  :ensure t
  :defer
  :hook (marginalia-mode . #'all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

(use-package nerd-icons
  :ensure t)

(use-package window
  :ensure nil
  :bind (("C-x 2" . vsplit-last-buffer)
         ("C-x 3" . hsplit-last-buffer)
         ([remap kill-buffer] . kill-this-buffer))
  :preface
  (defun hsplit-last-buffer ()
    "Focus to the last created horizontal window."
    (interactive)
    (split-window-horizontally)
    (other-window 1))
  (defun vsplit-last-buffer ()
    "Focus to the last created vertical window."
    (interactive)
    (split-window-vertically)
    (other-window 1)))

(use-package switch-window
  :ensure t
  :bind (("C-x o" . switch-window)
         ("C-x w" . switch-window-then-swap-buffer)))

(use-package winner
  :ensure nil
  :config (winner-mode))

(global-set-key (kbd "C-x C-b") 'ibuffer) ; instead of buffer-list
(setq ibuffer-expert t)                   ; stop yes no prompt on delete
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("dired" (mode . dired-mode))
               ("org" (mode . org-mode))
               ("magit" (name . "^magit"))
               ("planner" (or
                           (name . "^\\*Calendar\\*$")
                           (name . "^\\*Org Agenda\\*$")))
               ("emacs" (or
                         (name . "^\\*scratch\\*$")
                         (name . "^\\*Messages\\*$")))
               ))))
(add-hook 'ibuffer-mode-hook (lambda ()
                               (ibuffer-switch-to-saved-filter-groups "default")))

(use-package dashboard
  :ensure t
  :config
  (setq dashboard-banner-logo-text "Emacs, what else?"
        dashboard-startup-banner 'official
        dashboard-center-content t
        dashboard-vertically-center-content t
        dashboard-show-shortcuts t)
  (setq dashboard-items '((recents . 10)
                          (bookmarks . 10)
                          (projects . 10)
                          (agenda . 10)
                          (registers . 10)))
  (setq dashboard-item-shortcuts '((recents . "r")
                                   (bookmarks . "b")
                                   (projects . "p")
                                   (agenda . "a")
                                   (registers . "e")))
  (setq dashboard-navigation-cycle t
        dashboard-display-icons-p t)
        ;dashboard-icon-type 'nerd-icons
        ;dashboard-set-heading-icons t
        ;dashboard-set-file-icons t
        ;dashboard-icon-file-height 1.75
        ;dashboard-icon-file-v-adjust -0.125
        ;dashboard-heading-icon-height 1.75
        ;dashboard-heading-icon-v-adjust -0.125)
  :init
  (dashboard-setup-startup-hook))

(use-package magit
  :ensure t)

(use-package org
  :ensure t)

(use-package org-make-toc
  :ensure t)

(use-package org-tempo
  :config
  (add-to-list 'org-structure-template-alist
	       '("el" . "src emacs-lisp")))

(use-package browse-url
  :ensure nil
  :custom
  (browse-url-chrome-program "/Application/Google Chrome.app/Contents/MacOS/Google Chrome")
  (browse-url-browser-function 'eww-browse-url)
  :config
  (put 'browse-url-handlers 'safe-local-variable (lambda (x) t))
  (put 'browse-url-browser-function 'safe-local-variable (lambda (x) t)))

(use-package elfeed
  :ensure t
  :config
  (setq elfeed-search-feed-face ":foreground #ffffff :weight bold"
        elfeed-feeds (quote
                      (("https://www.reddit.com/r/emacs.rss" reddit emacs)
                       ("https://sachachua.com/blog/category/emacs-news/feed" sacha emacs)
                       ))))
