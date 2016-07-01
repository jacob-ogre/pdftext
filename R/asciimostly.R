# BSD_2_clause

#' An example tesseract config file
#'
#' Tesseract will use (all of? a lot of?) the UTF-8 char set for OCR, and a
#' significant number of errors will occur, at least with plain ol' English.
#' This config file whitelists the ASCII characters and a subset of UTF-8
#' characters that I've found to be useful. More information about tesseract
#' config files can be found at https://goo.gl/QGDFP2. Note that R escapes the
#' 'magical' characters, so the string has to be cleaned up, rather than copy-
#' and-pasted directly, to use `asciimostly[1]` as a config. Alternatively, you
#' can `cat(asciimostly)` to get a correct string.
#'
#' @format A string.
"asciimostly"
