## pdftext

An R package to extract text from PDFs

pdftext provides tools to extract text from PDFs, whether they have an embedded text layer and can be extracted with, e.g., `pdftools::pdf_text`; or are purely image-based PDFs that require optical character recognition (OCR).

The main function of pdftext, `pdf_to_txt`, gets the text either by extracting from the text layer (if available) or by OCR (if image-based) and writes the text to a file. The helper function `load_text` will read one of those text files and return a list, with each element of the list a single page (as done with `pdftools::pdf_text`). The "workhorse" functions for generating images for OCR and doing the OCR, are exposed so they can be used easily in other contexts.

#### SYSTEM DEPENDENCIES

pdftext depends on three applications that must be installed and on the
user's $PATH:

- tesseract, which is used for OCR, can be installed following the directions [here](https://github.com/tesseract-ocr/tesseract/wiki); 
- convert, which is used to convert PDFs to images, is part of [ImageMagick](http://www.imagemagick.org/script/binary-releases.php); and
- unpaper, which is used to prep page images for OCR, can be installed with a package manager like `apt` (Linux Debian distros) or `homebrew` (OS X), or by forking the [repo](https://github.com/Flameeyes/unpaper) and compiling.

Install these two applications and you're one step away from having a working package.

### Questions? 

[Contact us!](mailto:esa@defenders.org)

