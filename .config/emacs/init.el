;;; Initialize packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("gnu-devel" . "https://elpa.gnu.org/devel/") t)
(unless package-archive-contents
  (package-refresh-contents))
(package-initialize)

;;; Use org file like init file
(require 'org)
(org-babel-load-file
 (expand-file-name "emacs-config.org" user-emacs-directory))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(custom-safe-themes
   '("31c13005ad57fe22db3ce994cba08d694a1a564e7a46477236972b0864680043" "13790a7700ea9f9b8866f7a1095f3680642f0a9d943ec7a06eaa114d819c5f3f" "37c85d8b68ebf8da5c346765a5865f1157e62fa8301baebc07d87df675ca7a8b" "8b0aa06b75f4fd999e194715791eceac153b33e8fec47f791a7ac1a66e176ed2" "f708f7097dcb256759f135e50928d51daec58f77eb8c11afa83409cf6981beb2" "b13c28251e61a0fddb15f9d9b73935f03bde182d3fcaf90108b293bc833d5ee3" "57ed696ac77e5a8e5d04c943078316641cec92ff4a2688b45fe20b00c16b460a" "19e6ced0bbb981c96399a6a8a51d8b5e4fdee784c9e2dc9c49f384ac9a3c51f0" "abc488ffedb2dfe55bdd89f1f4176d6d1b8c22ae5197fa9fa9fd9c1d26786264" "e27c9668d7eddf75373fa6b07475ae2d6892185f07ebed037eedf783318761d7" default))
 '(package-selected-packages
   '(auctex fish-mode ivy-prescient typescript-mode webkit move-dup glsl-mode telephone-line multiple-cursors mindre-theme magit ivy-rich helpful counsel)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
