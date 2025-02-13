(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("gnu" . "https://elpa.gnu.org/packages/")))
(setq package-user-dir (expand-file-name "~/.emacs.d/packages"))
(require 'package)
(package-initialize)

(when (eq system-type 'darwin)
  (setq mac-option-key-is-meta nil
  mac-command-key-is-meta t
  mac-command-modifier 'meta
  mac-option-modifier nil)
  )

(setq-default c-basic-offset 4
	c-default-style "linux"
	indent-tabs-mode nil
	fill-column 120
	tab-width 4)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode t)

(use-package modus-themes
  :ensure t
  :config
  (setq modus-themes-italic-constructs t
	modus-themes-bold-constructs nil)
  (define-key global-map (kbd "<f5>") #'modus-themes-toggle))
(setq modus-themes-to-toggle '(modus-operandi-tinted modus-vivendi-tinted))
(load-theme 'modus-operandi-tinted t t)
(load-theme 'modus-vivendi-tinted t t)
(enable-theme 'modus-operandi-tinted)

(use-package pulsar
  :ensure t
  :config
  (setq pulsar-pulse t
	pulsar-delay 0.055
	pulsar-iterations 20
	pulsar-face 'pulsar-magenta
	pulsar-highlight-face 'pulsar-yellow)
  :init
  (pulsar-global-mode 1))
(let ((map global-map))
  (define-key map (kbd "C-c h p") #'pulsar-pulse-line)
  (define-key map (kbd "C-c h h") #'pulsar-highlight-line))

(defun my/apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'tango t))
    ('dark (load-theme 'tango-dark t))))
(add-hook 'ns-system-appearance-change-functions #'my/apply-theme)

(use-package consult
  :ensure t
  :bind (("C-c M-x" . consult-mode-command)
	 ("C-c h" . consult-history)
	 ("C-c m" . consult-man)
	 ("C-c i" . consult-info)
	 )
  )

(use-package org-tempo
  :config
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp")))
