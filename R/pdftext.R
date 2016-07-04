#' pdftext: A package to extract text from PDFs
#'
#' pdftext provides tools to extract text from PDFs, whether they have an
#' embedded text layer and can be extracted with, e.g.,
#' \link[pdftools]{pdf_text}; or are purely image-based PDFs that require
#' optical character recognition (OCR).
#'
#' The main function of pdftext, \code{\link{pdf_to_txt}}, gets the text either
#' by extracting from the text layer (if available) or by OCR (if image-based)
#' and writes the text to a file. The helper function \code{\link{load_text}}
#' will read one of those text files and return a list, with each element of the
#' list a single page (as done with \code{\link[pdftools]{pdf_text}}). The
#' "workhorse" functions for generating images for OCR and doing the OCR, are
#' exposed so they can be used easily in other contexts.
#'
#' \emph{SYSTEM DEPENDENCIES}
#'
#' pdftext depends on three applications that must be installed and on the
#' user's $PATH:
#'
#' \itemize{
#' \item{\code{tesseract}, which is used for OCR, can be installed following
#'   the directions at \url{https://github.com/tesseract-ocr/tesseract/wiki}}
#' \item{\code{convert}, which is used to convert PDFs to images, is part of
#'   \href{http://www.imagemagick.org/script/binary-releases.php}{ImageMagick}}
#' \item{\code{unpaper}, which is needed to automate pre-OCR cleanup (e.g.,
#'   rotation), from \href{http://brew.sh}{Homebrew}, another package manager, or
#'   \href{https://github.com/Flameeyes/unpaper}{source on GitHub}.
#'   }
#' }
#'
#' Install these two applications and you're one step away from having a working
#' package.
#'
#' @docType package
#' @name pdftext
NULL
