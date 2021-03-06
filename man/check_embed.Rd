% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{check_embed}
\alias{check_embed}
\title{Check if text embed is not from OCR}
\usage{
check_embed(file)
}
\arguments{
\item{file}{Path to a PDF to check for embedding source}
}
\value{
Logical: TRUE if good embed, FALSE if from OCR
}
\description{
Some PDFs have an embedded text layer that is derived from OCR by the scanner
or other equipment that produced the PDF. Such documents are more likely to
have fundamental errors, e.g., mis-OCR'd columnar text, that can be solved
by using OCR rather than extracting the text layer.
}
\examples{
\dontrun{
# res <- summarize_gold("test.pdf", text)
}
}
\seealso{
\code{pdftools::pdf_info}
}

