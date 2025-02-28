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
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode t) ; I use a Mac and it looks odd if there is no menu

(use-package evil
  :ensure t
  :init (evil-mode 1))

(global-set-key (kbd "C-c t") 'ef-themes-toggle)       ; toggle theme 
(global-set-key (kbd "C-c g") 'magit-status)           ; magit status
(global-set-key (kbd "C-c p") 'projectile-command-map) ; projectile command map

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

(use-package all-the-icons-ibuffer
  :ensure t
  :defer
  :custom
  (all-the-icons-ibuffer-formats
   '((mark modified read-only locked vc-status-mini
           " " ,(if all-the-icons-ibuffer-icon
                    '(icon 2 2 :left :elide)
                  "")
           ,(if all-the-icons-ibuffer-icon
                (propertize " " 'display `(space :align-to 8))
              "")
           (name 18 18 :left :elide)
           " " (size-h 9 -1 :right)
           " " (mode+ 16 16 :left :elide)
           " " (vc-status 16 16 :left)
           " " vc-relative-file)
     (mark "" (name 16 -1) " " filename)))
   :hook (ibuffer-mode . all-the-icons-ibuffer-mode))

(use-package ibuffer-vc
  :ensure t
  :hook (ibuffer . (lambda ()
                     (ibuffer-vc-set-filter-groups-by-vc-root)
                     (unless (eq ibuffer-sorting-mode 'alphabetic)
                       (ibuffer-do-sort-by-vc-status)
                       )
                     )))

(use-package magit
  :ensure t)

(use-package org
  :ensure t)

(use-package org-tempo
  :config
  (add-to-list 'org-structure-template-alist
	       '("el" . "src emacs-lisp")))
