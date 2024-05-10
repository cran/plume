## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval = FALSE-------------------------------------------------------------
#  library(googlesheets4)
#  
#  gs4_create(
#    name = "authors",
#    sheets = plm_template()
#  )

## ----eval = FALSE-------------------------------------------------------------
#  read_sheet(gs4_find("authors"))

## ----eval = FALSE-------------------------------------------------------------
#  library(googlesheets4)
#  library(plume)
#  
#  tbl_authors <- read_sheet(gs4_find("sheet_name"))
#  
#  aut <- PlumeQuarto$new(tbl_authors, file = "file.qmd")
#  aut$set_corresponding_authors(1)
#  aut$to_yaml()

