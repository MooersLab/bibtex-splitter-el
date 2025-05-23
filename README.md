![Version](https://img.shields.io/static/v1?label=matplotlib-voice-in&message=0.0&color=brightcolor)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
# bibtex-splitter-el

Here's an Elisp script that will parse a large BibTeX file into smaller chunks of 700 entries each:

* BibTeX File Splitter for Claude Upload

** Usage Instructions

*** Basic Usage
To split your BibTeX file, load the script and run:
```elisp
(load "path/to/bibtex-splitter.el")
(bibtex-split-for-claude "path/to/your-bibliography.bib")
```

Or interactively:
- `M-x bibtex-split-for-claude`  and provide the file path

*** Key Functions

**** `bibtex-split-for-claude`
The main interactive function that splits your BibTeX file into 700-entry chunks, creating files named =your-file-part-1.bib=, =your-file-part-2.bib=, etc.

**** `bibtex-splitter-count-entries`
Counts entries in your BibTeX file before splitting:


```elisp
(bibtex-splitter-count-entries "bibliography.bib")
```

**** `bibtex-splitter-validate-file`
Validates BibTeX structure and reports any parsing errors:
```elisp
(bibtex-splitter-validate-file "bibliography.bib")
```

** Features

*** Robust Parsing
- Uses Emacs' built-in =bibtex-mode= functions for reliable entry detection
- Handles malformed entries gracefully with error reporting
- Preserves complete entry structure including formatting

*** Customizable Chunk Size
If you need different chunk sizes, modify =bibtex-splitter-entries-per-file= or call the underlying function directly:
```elisp
(bibtex-splitter-split-file "bibliography.bib" 500)  ; 500 entries per file
```

*** Error Handling
The validation function helps identify problematic entries before splitting, so you can clean up your BibTeX file if needed.

** Installation in Your Emacs Config

Add to your =init.el= or create a separate file in your Emacs configuration:
```elisp
;; Add to load-path if needed
(add-to-list 'load-path "~/path/to/your/elisp/")
(require 'bibtex-splitter)
```

This script leverages Emacs' native BibTeX parsing capabilities, making it reliable for handling various BibTeX formatting styles while ensuring each output file contains valid, complete entries.


## Update history
|Version      | Changes                                                                                                                                                                         | Date                 |
|:-----------|:------------------------------------------------------------------------------------------------------------------------------------------|:--------------------|
| Version 0.1 |   Added badges, funding, and update table.  Initial commit.                                                                                                                | 05/22/2025  |
## Sources of funding
- NIH: R01 CA242845
- NIH: R01 AI088011
- NIH: P30 CA225520 (PI: R. Mannel)
- NIH: P20 GM103640 and P30 GM145423 (PI: A. West)
