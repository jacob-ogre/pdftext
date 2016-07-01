# BSD_2_clause

#' Create main directories expected by \code{pdftext}
#'
#' OCR'ing from PDFs requires creating one or more image files to be processed
#' by \code{tesseract}. Page-by-page OCR is often needed, e.g., documents that
#' contain a mix of pages with and without an embedded text layer. This function
#' creates the top-level directories expected by the \link{pdftext} package.
#'
#' @param verbose Whether to print message with dirs created
#' @seealso if any see alsos
#' @export
#' @examples
#' # make_main_dirs(verbose = TRUE)
make_main_dirs <- function(verbose = FALSE) {
  tmp <- options()$pdftext.wkdir
  dir <- list()
  dir$imgs <- suppressWarnings(normalizePath(paste(tmp, "IMGs", sep = "/")))
  dir$pages <- suppressWarnings(normalizePath(paste(tmp, "PAGEs", sep = "/")))
  dir$txts <- suppressWarnings(normalizePath(paste(tmp, "TXTs", sep = "/")))
  dir$errs <- suppressWarnings(normalizePath(paste(tmp, "ERRs", sep = "/")))

  created <- c()
  if(!dir.exists(dir$imgs)) {
    dir.create(dir$imgs)
    created <- c(created, dir$imgs)
  }
  if(!dir.exists(dir$pages)) {
    dir.create(dir$pages)
    created <- c(created, dir$pages)
  }
  if(!dir.exists(dir$txts)) {
    dir.create(dir$txts)
    created <- c(created, dir$txts)
  }
  if(!dir.exists(dir$errs)) {
    dir.create(dir$errs)
    created <- c(created, dir$errs)
  }

  dirs <- paste(created, collapse = "\n\t")
  msg <- paste("Created temp directories:", dirs,
               sep = "\n\t")
  if(verbose) message(msg)
}

#' Save the images directory from options()$pdftext.wkdir
#'
#' PDFs are split into individual pages for OCR and images from each PDF are
#' saved to a subdirectory of pdftext.wkdir/IMGs/. This is a helper to copy the
#' subdirectories and files to a permanent location.
#'
#' @param dest The path to which the images directory will be saved
#' @return TRUE if copy succeeds, else FALSE
#' @seealso \link{save_pages} \link{save_txts}
#' @export
#' @examples
#' # save_imgs("~/cur_proj/")
save_imgs <- function(dest) {
  file.copy(paste0(options()$pdftext.wkdir, "/IMGs/"),
            dest,
            recursive = TRUE)
}

#' Save the pages directory from tempdir
#'
#' PDFs are split into individual pages for OCR and text files from each PDF are
#' saved to a subdirectory of tempdir()/PAGEs/. This is a helper to copy the
#' subdirectories and files to a permanent location.
#'
#' @param dest The path to which the images directory will be saved
#' @return TRUE if copy succeeds, else FALSE
#' @seealso \link{save_pages} \link{save_txts}
#' @export
#' @examples
#' # save_imgs("~/cur_proj/")
save_pages <- function(dest) {
  file.copy(paste0(options()$pdftext.wkdir, "/PAGEs/"),
            dest,
            recursive = TRUE)
}

#' Save the text directory from tempdir
#'
#' PDFs are split into individual pages for OCR and text files from each PDF are
#' concatenated to a single file at tempdir()/TXTs/. This is a helper to copy
#' the TXTs directory (and files) to the user's preferred location.
#'
#' @param dest The path to which the images directory will be saved
#' @return TRUE if copy succeeds, else FALSE
#' @seealso \link{save_pages} \link{save_txts}
#' @export
#' @examples
#' # save_txts("~/cur_proj/")
save_txts <- function(dest) {
  file.copy(paste0(options()$pdftext.wkdir, "/TXTs/"),
            dest,
            recursive = TRUE)
}
