; load path
; (add-to-list 'load-path "~/.emacs.d/elisp/3rd-party/")
; 日本語
(set-language-environment "Japanese")
; utf-8
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)


;;;;;; 表示周り
; (tool-bar-mode -1) ; ツールバーを非表示
(menu-bar-mode -1) ; メニューバーを非表示
(setq inhibit-startup-message t) ; 起動時の画面はいらない
(setq initial-scratch-message "") ; scratchバッファを開いたときに空にする
; (set-scroll-bar-mode nil) ; スクロールバー非表示
(global-font-lock-mode t) ; font-lockの設定
(transient-mark-mode 1) ; スクロール
(show-paren-mode 1) ; 括弧の対応
(line-number-mode t) ; 行番号
(column-number-mode t) ; 桁番号も
 (set-background-color "black") ;; background color
 (set-foreground-color "gray")   ;; font color
; タイトルバーにファイルのフルパス表示
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))
; 現在行のハイライト
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "dark slate gray"))
    (((class color)
      (background light))
     (:background  "#aaccbb"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(global-hl-line-mode)
; 空白・タブ表示
;; 全角space、tabを可視化する。
;; Emacs で全角スペース/タブ文字を可視化 | Weboo! Returns.
;; http://yamashita.dyndns.org/blog/emacs-shows-double-space-and-tab/
(setq whitespace-style
      '(tabs tab-mark spaces space-mark))
(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (tab-mark   ?\t   [?\xBB ?\t])
        ))
(require 'whitespace)
(global-whitespace-mode 1)
(set-face-foreground 'whitespace-space "LightSlateGray")
;(set-face-background 'whitespace-space "DarkSlateGray")
(set-face-foreground 'whitespace-tab "LightSlateGray")
;(set-face-background 'whitespace-tab "DarkSlateGray")
; 末尾の空白を表示
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "blue")
; フォントサイズ
; 一時的にメニューを表示させてOptions->Set Default Fontして、Save Optionsする。
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "gray" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 139 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))


;;;;;; 操作系
(define-key global-map "\C-\\" nil) ; \C-\の日本語入力の設定を無効にする
(setq completion-ignore-case t) ; file名の補完で大文字小文字を区別しない
(setq scroll-step 1) ; スクロールを一行ずつにする
;;;;;; バッファ操作
(iswitchb-mode t) ; 高機能なバッファのスイッチ
(add-hook 'iswitchb-define-mode-map-hook ; キーバインドの追加
          'iswitchb-my-keys)
(defun iswitchb-my-keys ()
  "Add my keybindings for iswitchb."
  (define-key iswitchb-mode-map [right] 'iswitchb-next-match)
  (define-key iswitchb-mode-map [left] 'iswitchb-prev-match)
  (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
  (define-key iswitchb-mode-map " " 'iswitchb-next-match)
  (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match)
  )
(defadvice iswitchb-exhibit ; バッファの選択中に内容を表示
  (after
   iswitchb-exhibit-with-display-buffer
   activate)
  (when (and
         (eq iswitchb-method iswitchb-default-method)
         iswitchb-matches)
    (select-window
     (get-buffer-window (cadr (buffer-list))))
    (let ((iswitchb-method 'samewindow))
      (iswitchb-visit-buffer
       (get-buffer (car iswitchb-matches))))
    (select-window (minibuffer-window))))
; バッファ名をユニークに
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")
; 普段は*...*を完全無視する
(add-to-list 'iswitchb-buffer-ignore "\\`\\*")
(setq iswitchb-buffer-ignore-asterisk-orig nil)
(defadvice iswitchb-exhibit (before iswitchb-exhibit-asterisk activate)
  "*が入力されている時は*で始まるものだけを出す"
  (if (equal (char-after (minibuffer-prompt-end)) ?*)
      (when (not iswitchb-buffer-ignore-asterisk-orig)
        (setq iswitchb-buffer-ignore-asterisk-orig iswitchb-buffer-ignore)
        (setq iswitchb-buffer-ignore '("^ "))
        (iswitchb-make-buflist iswitchb-default)
        (setq iswitchb-rescan t))
    (when iswitchb-buffer-ignore-asterisk-orig
      (setq iswitchb-buffer-ignore iswitchb-buffer-ignore-asterisk-orig)
      (setq iswitchb-buffer-ignore-asterisk-orig nil)
      (iswitchb-make-buflist iswitchb-default)
      (setq iswitchb-rescan t))))


;;;;;; 強化系
; インデントポリシー
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-default-style "stroustrup")
; ファイル末の改行がなければ追加
;;; (setq require-final-newline t) ; 意図しない編集を避けるため除外
; 行末の(タブ・半角スペース)を削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)
