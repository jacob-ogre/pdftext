# BSD_2_clause

#' Extract text from a pdf and write to a txt file
#'
#' Extract text from a pdf, which may have a text layer that can be extracted
#' with \link[pdftools]{pdf_text}; or which may be image-based and needs
#' to be OCR'd with Tesseract. Both routes end with the extracted text written
#' to a .txt file with form-feed (\code{\\f}) metacharacters separating pages.
#'
#' Some PDFs include a mix of pages with and without an embedded text layer.
#' Getting text from the text layer is preferable to OCR (most of the time), and
#' to determine which approach to use,
#'
#' @param file Path to the PDF from which text will be extracted
#' @param thres Threshold number of blank pages to be considered mixed [0.2]
#' @param verbose Whether to print processing messages [TRUE]
#' @return Nothing
#' @seealso \link[pdftools]{pdf_text} \code{\link{load_text}}
#' @export
#' @examples
#' \dontrun{
#' res <- pdf_to_txt("test.pdf")
#' }
pdf_to_txt <- function(file, thres = 0.2, verbose = TRUE) {
  out <- suppressWarnings(
           normalizePath(
             paste0(options()$pdftext.wkdir, "/TXTs/", basename(file), ".txt")
           )
  )
  message(paste("Out = ", out))
  if(!file.exists(out) | file.info(out)$size == 0) {
    if(verbose) message(paste("Extracting text from file", file))
    text <- pdftools::pdf_text(file)
    ratio <- sum(text == "") / length(text)
    if(ratio > thres) {
      ocr_pdf(file, verbose)
    } else {
      text <- paste(text, collapse = "\n\f")
      write(text, file = out)
    }
  } else {
    if(verbose) {
      message(paste("File", out, "already exists; skipping extraction"))
    }
  }
}

#' Perform optical character recognition on a PDF
#'
#' Uses Imagemagick and Tesseract (which must be installed and on the $PATH) to
#' perform optical character recognition (OCR) on a PDF.
#'
#' @param file Path to the PDF from which text will be extracted
#' @param verbose Print messages if TRUE; silent if FALSE
#' @seealso \code{\link{pdf_to_txt}}
#' @export
#' @examples
#' \dontrun{
#' res <- ocr_pdf("test.pdf")
#' }
ocr_pdf <- function(file, verbose = TRUE) {
  img_dir <- convert_to_imgs(file)
  img_ls <- get_sorted_files(img_dir, "png")
  txt_dir <- ocr_pages(img_ls)
  message("Waiting a few seconds...")
  Sys.sleep(3)
  outfile <- cat_pages(txt_dir)
}

#' Convert a file (PDF) to per-page images (PNG)
#'
#' Tesseract requires images for OCR. Many analyses benefit from being able to
#' access pages independently.
#'
#' @param file Path to a PDF to be converted to per-page images
#' @param verbose Whether to print processing messages [TRUE]
#' @return Directory to which the per-page images are saved
#' @export
#' @examples
#' \dontrun{
#' convert_to_imgs("test.pdf")
#' }
convert_to_imgs <- function(file, verbose = TRUE) {
  out <- suppressWarnings(normalizePath(
           paste0(options()$pdftext.wkdir, "/IMGs/",
                  stringr::str_replace(basename(file), "\\.[a-z]{3}$", ""),
                  "/", basename(file), ".png")
         ))
  if(!dir.exists(dirname(out))) {
    dir.create(dirname(out))
  }
  test_file <- stringr::str_replace(out, "\\.png", "-0\\.png")
  if(!file.exists(test_file)) {
    if(verbose) message(paste("Making PNGs of file", file))
    cmd <- paste0("convert -density 600 -quality 90 ", file, " ", out)
    system(cmd, wait = TRUE)
  }
  return(dirname(out))
}

#' Return a list of correctly sorted imgs for Tesseract OCR
#'
#' We need the list of PNGs to be sorted correctly, but \code{list.files}
#' returns a naively sorted list. This means that a document with 10 pages would
#' return as 'file-0.png file-1.png file-10.png...'; when concatenating
#' the TXTs, the pages would be concatenated out-of-order. This function returns
#' the files in the correct order for OCR, and that order is then used for
#' concatenating the OCR'd pages.
#'
#' @param path Path to the directory containing TXT files from Tesseract
#' @param ext The extension of the files (e.g., png) to match
#' @return The (correctly) sorted vector of TXT files
#' @export
#' @examples
#' \dontrun{
#' get_sorted_files("OCR_tmp/doc1/", "png")
#'
#' # Returns a vector of files such as c(doc1-0.png, doc1-1.png, doc1-2.png,
#' # ..., doc1-10.png) rather than c(doc1-0.png, doc1-1.png, doc1-10.png,
#' # doc1-2.png, ...)
#' }
get_sorted_files <- function(path, ext) {
  files <- list.files(path)
  nums <- stringr::str_match(files, "[0-9]+\\.[a-z]{3}$")
  nums <- sort(as.numeric(gsub(nums, pattern = "\\.[a-z]{3}$", replacement = "")))
  prefix <- stringr::str_split(files[1], "-[0-9]")[[1]][1]
  sort_file <- paste0(prefix, "-", nums, ".", ext)
  return(sort_file)
}

#' Perform optical character recognition on PNGs.
#'
#' Uses Tesseract (which must be installed and on the $PATH) to perform optical
#' character recognition (OCR) on a pdf. Uses options()$pdftext.tess_conf to
#' specify a custom config for tesseract, which can be set with
#' \link{set_tess_conf}.
#'
#' @param pngs A listing of the temp PNG directory for a PDF
#' @param verbose Whether to print processing messages [TRUE]
#' @return The path to the OCR'd text file
#' @seealso \code{\link{pdf_to_txt}}
#' @importFrom stringr str_split
#' @export
#' @examples
#' \dontrun{
#' res <- ocr_pages("test.pdf")
#' }
ocr_pages <- function(pngs, verbose = TRUE) {
  res <- list()
  file_dir <- stringr::str_split(pngs[1], "\\.")[[1]][1]
  pngs <- suppressWarnings(
            normalizePath(
              paste0(options()$pdftext.wkdir, "/IMGs/", file_dir, "/", pngs)
            )
  )
  for(i in pngs) {
    txt_base <- gsub(i, pattern = ".png", replacement = "", fixed = TRUE)
    out_file <- gsub(txt_base, pattern = "IMGs", replacement = "PAGEs")
    err_file <- gsub(txt_base, pattern = "IMGs", replacement = "ERRs")
    if(!dir.exists(dirname(out_file))) dir.create(dirname(out_file))
    if(!dir.exists(dirname(err_file))) dir.create(dirname(err_file))
    if(!file.exists(paste0(out_file, ".txt"))) {
      cmd <- paste0("tesseract ", i, " ", out_file,
                    " -l eng ", options()$pdftext.tess_conf,
                    " &> ", err_file)
      if(verbose) message(paste("OCR-ing", i))
      system(cmd, wait = TRUE)
    }
    res <- c(res, out_file)
  }
  return(paste0(unlist(res), ".txt"))
}

#' Concatenate OCR'd pages to a single file
#'
#' Uses \code{readLines} to build a list so that the form-feed metacharacter
#' (\code{\\f}) can be used to separate pages in concatenated file. This allows
#' both text from \link[pdftools]{pdf_text} and from OCR-ing to be handled in
#' the same way.
#'
#' @param files A vector of TXT files to be concatenated
#' @return The path to the single, concatenated file
#' @importFrom stringr str_replace str_split
#' @seealso \link{load_text}
#' @export
#' @examples
#' # cat_pages(fil_list)
cat_pages <- function(files) {
  out_dir <- dirname(dirname(files[1]))
  out_dir <- stringr::str_replace(out_dir, "PAGEs", "TXTs")
  base_name <- paste0(stringr::str_split(basename(files[1]),
                                         pattern = "\\.")[[1]][1], ".txt")
  out_file <- suppressWarnings(
                normalizePath(
                  paste0(out_dir, "/", base_name)
                )
  )
  text <- lapply(files, readLines)
  text <- lapply(text, paste, collapse = "\n")
  text <- paste(text, collapse = "\n\f")
  write(text, file = out_file)
  return(out_file)
}

