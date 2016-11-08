# BSD_2_clause

.onLoad <- function(libname, pkgname) {
  # set some options
  op <- options()
  op.pdftext <- list(
    pdftext.tess_conf = "",
    pdftext.wkdir = "~/"
  )
  toset <- !(names(op.pdftext) %in% names(op))
  if(any(toset)) options(op.pdftext[toset])

  gs_cmd <- "which gs"
  conv_cmd <- "which convert"
  pdftk_cmd <- "which pdftk"
  tess_cmd <- "which tesseract"
  checks <- c(gs_cmd, conv_cmd, pdftk_cmd, tess_cmd)
  for(i in checks) {
    i_test <- system(i, intern = FALSE)
    if(i_test != 0) {
      cmd <- gsub(i, pattern = "which ", replacement = "")
      warning(paste(cmd, "is not installed or is not on your $PATH;",
                 "please check and try to load again"))
    }
  }

  invisible()
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "\npdftext is attached. To set the working directory (e.g., where\n",
    "the directory with PDFs resides) where OCR and TXT files will be\n",
    "written, run\n\n",
    "    set_wkdir('path/to/wkdir')\n\n",
    "To use a custom config file for tesseract, run\n\n",
    "    set_tess_conf('name_of_conf')\n\n",
    "where 'name_of_conf' is a file located in $TESS_DATA/configs. See\n",
    "https://goo.gl/QGDFP2 for more information. An example config can\n",
    "be seen with data(asciimostly).\n"
  )
}

