# BSD_2_clause

#' Load text extracted from a pdf to a list
#'
#' \link{pdf_to_txt} writes PDF contents to .txt files rather than loading
#' them directly. This helper function loads both types of files to a list,
#' such as one returned by \link[pdftools]{pdf_text}.
#'
#' @param file Path to the file to be loaded
#' @return A list of one element per page, with a vector of lines per element
#' @importFrom stringr str_detect str_split
#' @export
#' @examples
#' # load_text("doc1234.rda")
#' # load_text("doc1234.txt")
load_text <- function(file) {
  if(stringr::str_detect(file, "rda$")) {
    return(load(file))
  } else if (stringr::str_detect(file, "txt$")) {
    text <- readLines(file)
    pages <- stringr::str_split(text, "\n\f")
    pages <- lapply(pages[[1]], stringr::str_split, "\n")
    pages <- lapply(pages, as.vector)
    return(pages)
  } else {
    stop("Unhandled file type; see `?load_text`.")
  }
}

#' Set a custom \code{tesseract} config for OCR
#'
#' \code{tesseract} can be called with custom configs to improve OCR. Adding
#' such a config automatically is infeasible, but if you want to specify your
#' own config, such as is found in data(asciimostly), then use this function
#' to set the option.
#'
#' @param conf A string specifying the config file name
#' @return Nothing
#' @export
#' @examples
#' set_tess_conf("asciimostly")
set_tess_conf <- function(conf) {
  options("pdftext.tess_conf" = conf)
}
