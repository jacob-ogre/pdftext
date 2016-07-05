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
    text <- paste(readLines(file), collapse = "\n")
    pages <- stringr::str_split(text, "\n\f")
    pages <- lapply(pages, stringr::str_split, "\n")
    pages <- unlist(pages, recursive = FALSE)
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

#' Set the option for the working directory
#'
#' \code{pdftext} needs a place to put various files during OCR, e.g., PNGs and
#' pages from running \code{tesseract}
#'
#' @param wkdir Absolute path to the working directory (where PDFs/ lives)
#' @return Nothing
#' @export
#' @examples
#' set_wkdir("/datadrive/data")
set_wkdir <- function(wkdir) {
  options("pdftext.wkdir" = wkdir)
}

#' Check if text embed is not from OCR
#'
#' Some PDFs have an embedded text layer that is derived from OCR by the scanner
#' or other equipment that produced the PDF. Such documents are more likely to
#' have fundamental errors, e.g., mis-OCR'd columnar text, that can be solved
#' by using OCR rather than extracting the text layer.
#'
#' @param file Path to a PDF to check for embedding source
#' @return Logical: TRUE if good embed, FALSE if from OCR
#' @seealso \code{pdftools::pdf_info}
#' @export
#' @examples
#' \dontrun{
#' # res <- summarize_gold("test.pdf", text)
#' }
check_embed <- function(file) {
  temp <- pdftools::pdf_info(file)
  if(length(temp) > 1) {
    info <- list(temp)
  } else {
    info <- temp
  }
  if(!is.atomic(info[[1]][1]) & !is.na(info[[1]][1])) {
    if(!is.null(info[[1]]$keys)) {
      if(!is.null(info[[1]]$keys$Producer)) {
        if(grepl(info[[1]]$keys$Producer,
                 pattern = "Distiller|Word|Library|Ghost|Acrobat Pro|Adobe Acrobat")) {
          return(TRUE)
        }
      }
    }
  }
  return(FALSE)
}

#' Check if file is a PDF
#'
#' Some <file>.pdf aren't actually PDFs and should be ignored
#'
#' @param file Path to a PDF to check for embedding source
#' @return Logical: TRUE if a PDF, FALSE if not
#' @seealso \code{pdftools::pdf_info}
#' @export
#' @examples
#' \dontrun{
#' res <- check_pdf("test.pdf")
#' }
check_pdf <- function(file) {
  cmd <- paste0("pdftotext '", file, "'")
  res <- system(cmd, ignore.stderr = TRUE)
  if(res != 0) return(FALSE)
  return(TRUE)
}
