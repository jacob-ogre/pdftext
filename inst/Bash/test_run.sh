#!/bin/bash
#SBATCH -J test_OCR
#SBATCH -o outputs/test_OCR.out
#SBATCH -e outputs/test_OCR.err
#SBATCH -n 2
#SBATCH -p development
#SBATCH -t 00:15:00
#SBATCH -A TG-BIO160020

# BASE=$HOME/Google\ Drive/Defenders/ESA_docs/five_year_review/
# SCRIPT=$HOME/Repos/Defenders/tools/pdftext/tests/simple_test.R
# echo $BASE
# cd "$BASE"

BASE=$WORK/data/NLP/five_year_review/
SCRIPT=$WORK/Repos/

Rscript $SCRIPT "$BASE"
