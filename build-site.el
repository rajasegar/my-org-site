;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      )

(defun read-template (filename)
  "Read template contents from FILENAME."
  (with-temp-buffer
    (insert-file-contents filename)
    (buffer-string)))

(setq head-extra-template (read-template "templates/html_header.html"))
;; (setq header-template (read-template "templates/html_sub_header.html"))
(setq header-nav (read-template "templates/nav.html"))
(setq footer-template (read-template "templates/html_footer.html"))


;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "org-site:main"
             :recursive t
             :base-directory "./content"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./public"
             :with-author t           ;; Don't include author name
             :with-creator t            ;; Include Emacs and Org versions in footer
             :with-toc t                ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil
             :html-head-include-default-style t
             :html-head-include-scripts t
             :html-divs '((preamble "header" "")
                          (content "div" "main")
                          (postamble "footer" ""))
             :html-head-extra head-extra-template
             :html-preamble header-nav
             :html-postamble footer-template
             )))    ;; Don't include time stamp in file

;; Generate the site output
(org-publish-all t)

(message "Build complete!")

