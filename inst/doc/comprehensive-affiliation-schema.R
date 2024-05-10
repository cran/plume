## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(plume)

## -----------------------------------------------------------------------------
author <- tibble::tibble(
  given_name = "René",
  family_name = "Descartes",
  affiliation1 = "Collège royal Henri-le-Grand",
  affiliation2 = "
  city=Poitiers
  name=Université de Poitiers
  address=15 Rue de l'Hôtel Dieu
  country=Kingdom of France
  ",
  affiliation3 = "name=Academia Franekerensis country=The Netherlands city=Franeker"
)

## ----include = FALSE----------------------------------------------------------
tmp_file <- withr::local_tempfile(
  lines = "---\ntitle: Cogito ergo sum\n---",
  fileext = ".qmd"
)
aut <- PlumeQuarto$new(author, tmp_file)

## ----eval = FALSE-------------------------------------------------------------
#  aut <- PlumeQuarto$new(author, file = "file.qmd")
#  aut$to_yaml()

## ----echo = FALSE, comment = ""-----------------------------------------------
aut$to_yaml()
cat(readr::read_file(tmp_file))

