## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval = FALSE-------------------------------------------------------------
# googlesheets4::gs4_create(
#   name = "authors",
#   sheets = plm_template()
# )

## ----eval = FALSE-------------------------------------------------------------
# googlesheets4::read_sheet("sheet_id")

## ----eval = FALSE-------------------------------------------------------------
# library(plume)
# 
# tbl_authors <- googlesheets4::read_sheet("sheet_id")
# 
# aut <- PlumeQuarto$new(tbl_authors, file = "file.qmd")
# aut$set_corresponding_authors(1)
# aut$to_yaml()

