# BSD_2_clause

#' Test if a PDF has embedded text.
#'
#' @param pdf Path to the PDF from which text will be extracted
#' @return A data.frame of summary info about PDF, incl. whether text is embedded
#' @export
#' @examples
#' # res <- test_embed("test.pdf")
test_embed <- function(pdf) {
  err <- try(text <- pdftools::pdf_text(pdf))
  if(class(err) != "try-error") {
    n_page <- length(text)
    ratio <- sum(text == "") / length(text) 
    if(ratio > 0.2) {
      embed <- FALSE
    } else {
      embed <- TRUE
    }
    res <- data.frame(file = pdf, n_pages = n_page, 
                      ratio = ratio, embed = embed)
    return(res)
  } else {
    res <- data.frame(file = pdf, n_pages = NA, ratio = NA, embed = NA)
    return(res)
  }
}


