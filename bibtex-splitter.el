;;; bibtex-splitter.el --- Split large BibTeX files into smaller chunks

;;; Commentary:
;; This script splits a large BibTeX file into smaller files containing
;; a maximum of 700 entries each, suitable for uploading to Claude.

;;; Code:

(require 'bibtex)

(defvar bibtex-splitter-entries-per-file 700
  "Number of BibTeX entries per output file.")

(defun bibtex-splitter-split-file (input-file &optional entries-per-file)
  "Split INPUT-FILE into smaller BibTeX files.
Each output file will contain at most ENTRIES-PER-FILE entries (default 700).
Output files are named INPUT-FILE-part-N.bib where N is the part number."
  (interactive "fBibTeX file to split: ")
  (let* ((entries-per-file (or entries-per-file bibtex-splitter-entries-per-file))
         (input-basename (file-name-sans-extension input-file))
         (current-part 1)
         (current-count 0)
         (output-buffer nil)
         (output-file nil))
    
    ;; Create first output file
    (setq output-file (format "%s-part-%d.bib" input-basename current-part))
    (setq output-buffer (create-file-buffer output-file))
    
    (with-temp-buffer
      (insert-file-contents input-file)
      (goto-char (point-min))
      
      ;; Parse and process each BibTeX entry
      (while (bibtex-skip-to-valid-entry)
        (let ((entry-start (point))
              (entry-end nil))
          
          ;; Find the end of current entry
          (bibtex-end-of-entry)
          (setq entry-end (point))
          
          ;; Extract the complete entry
          (let ((entry-text (buffer-substring-no-properties entry-start entry-end)))
            
            ;; Write to current output buffer
            (with-current-buffer output-buffer
              (insert entry-text)
              (insert "\n\n"))
            
            (setq current-count (1+ current-count))
            
            ;; Check if we need to start a new file
            (when (>= current-count entries-per-file)
              ;; Save current buffer
              (with-current-buffer output-buffer
                (write-file output-file))
              (kill-buffer output-buffer)
              
              ;; Start new file
              (setq current-part (1+ current-part))
              (setq current-count 0)
              (setq output-file (format "%s-part-%d.bib" input-basename current-part))
              (setq output-buffer (create-file-buffer output-file)))
            
            ;; Move to next entry
            (goto-char entry-end)))))
    
    ;; Save the last buffer if it has content
    (when (and output-buffer (> current-count 0))
      (with-current-buffer output-buffer
        (write-file output-file))
      (kill-buffer output-buffer))
    
    (message "Split complete: %d parts created" current-part)))

(defun bibtex-splitter-count-entries (file)
  "Count the number of BibTeX entries in FILE."
  (interactive "fBibTeX file: ")
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (let ((count 0))
      (while (bibtex-skip-to-valid-entry)
        (setq count (1+ count))
        (bibtex-end-of-entry))
      (message "File contains %d BibTeX entries" count)
      count)))

(defun bibtex-splitter-validate-file (file)
  "Basic validation of BibTeX FILE structure."
  (interactive "fBibTeX file to validate: ")
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (let ((valid-entries 0)
          (invalid-entries 0)
          (errors '()))
      
      (while (not (eobp))
        (condition-case err
            (if (bibtex-skip-to-valid-entry)
                (progn
                  (setq valid-entries (1+ valid-entries))
                  (bibtex-end-of-entry))
              ;; No more valid entries, skip to end
              (goto-char (point-max)))
          (error
           (setq invalid-entries (1+ invalid-entries))
           (push (format "Line %d: %s" (line-number-at-pos) (error-message-string err)) errors)
           (forward-line 1))))
      
      (message "Validation complete: %d valid, %d invalid entries" valid-entries invalid-entries)
      (when errors
        (message "Errors found:\n%s" (mapconcat 'identity (reverse errors) "\n")))
      
      (list valid-entries invalid-entries errors))))

;; Interactive wrapper functions
(defun bibtex-split-for-claude (file)
  "Split BibTeX FILE into 700-entry chunks for Claude upload.
This is an interactive wrapper around `bibtex-splitter-split-file'."
  (interactive "fBibTeX file to split for Claude: ")
  (bibtex-splitter-split-file file 700))

(provide 'bibtex-splitter)

;;; bibtex-splitter.el ends here