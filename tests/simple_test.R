library(doParallel)
library(foreach)
library(pdftext)

args <- commandArgs(trailingOnly = TRUE)
pwd <- args[1]
print(pwd)

setwd(pwd)
pdfs <- paste0("PDFs/", list.files("PDFs", pattern = "pdf"))
test_set <- sample(pdfs, 5)

cl <- makeCluster(2)
registerDoParallel(cl)
res <- foreach(i = test_set, 
               .packages = "pdftext",
               .errorhandling = "pass",
               .verbose = TRUE) %dopar% {
       newf <- gsub(i, patt = ".pdf", repl = ".txt", fixed = TRUE)
       newf <- gsub(newf, patt = "PDFs", repl = "TXTs")
       extract_text(i, newf, "cmd_test_errors.err")
}

print(test_set)
length(res)

# setwd("~/Google Drive/Defenders/ESA_docs/five_year_review")
# pdfs <- paste0("PDFs/", list.files("PDFs", pattern = "pdf"))
# head(pdfs)

# one <- extract_text(pdfs[1], 
#                     gsub(pdfs[1], patt = ".pdf", repl = ".txt", fixed = TRUE),
#                     "one_errors.err")

# res <- list()
# for(i in pdfs[c(2,42,73,159,654)]) {
#   res <- c(res, extract_text(i,
#                              gsub(i, patt="pdf", repl=".txt", fixed=TRUE),
#                              "two_errors.err"))
# }
# length(res)

# cl <- makeCluster(2)
# registerDoParallel(cl)
# res <- foreach(i = pdfs[c(73,159,654)], .packages = "pdftext") %dopar% {
#        newf <- gsub(i, patt = ".pdf", repl = ".txt", fixed = TRUE)
#        newf <- gsub(newf, patt = "PDFs", repl = "TXTs")
#        extract_text(i, newf, "two_errors.err")
# }

# length(res)
