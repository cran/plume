## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval = FALSE-------------------------------------------------------------
#  library(googlesheets4)
#  
#  gs4_create(
#    name = "encyclopédie",
#    sheets = plm_template()
#  )

## ----eval = FALSE-------------------------------------------------------------
#  read_sheet(gs4_find("encyclopédie"))

## ---- eval = FALSE------------------------------------------------------------
#  library(googlesheets4)
#  library(plume)
#  
#  tbl_authors <- gs4_find("sheet_name") |> read_sheet()
#  
#  PlumeQuarto$new(tbl_authors, file = "file.qmd")$
#    set_corresponding_authors(1)$
#    to_yaml()

