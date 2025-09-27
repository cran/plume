## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  warning = FALSE,
  collapse = TRUE,
  comment = "#>"
)
options(str = strOptions(vec.len = 9))
library(plume)
library(readr)
library(gt)

## -----------------------------------------------------------------------------
encyclopedists

## -----------------------------------------------------------------------------
Plume$new(encyclopedists)

## ----echo = FALSE-------------------------------------------------------------
plume:::plm_table_vars("primaries")

## ----echo = FALSE-------------------------------------------------------------
plume:::plm_table_vars("secondaries")

## ----echo = FALSE-------------------------------------------------------------
plume:::plm_table_vars("nestables")

## ----echo = FALSE-------------------------------------------------------------
plume:::plm_table_vars("internals")

## -----------------------------------------------------------------------------
Plume$new(
  encyclopedists_fr,
  names = c(
    given_name = "prénom",
    family_name = "nom",
    literal_name = "nom_complet",
    email = "courriel",
    initials = "initiales"
  )
)

## ----echo = FALSE-------------------------------------------------------------
tibble::tibble(
  given_name = c("Denis", "Jean-Jacques", "François-Marie", "Jean"),
  family_name = c("Diderot", "Rousseau", "Arouet", "Le Rond d'Alembert"),
  supervision = c(1, NA, NA, 1),
  writing = 1,
)

## ----eval = FALSE-------------------------------------------------------------
# Plume$new(
#   data,
#   roles = c(
#     supervision = "supervised the project",
#     writing = "contributed to the writing"
#   )
# )

## ----echo = FALSE-------------------------------------------------------------
status_methods <- tibble::tibble(
  Name = c(
    "set_corresponding_authors()",
    "set_main_contributors()",
    "set_cofirst_authors()",
    "set_deceased()"
  ),
  Plume = as.logical(c(1, 1, 0, 0)),
  PlumeQuarto = as.logical(c(1, 0, 1, 1)),
)

## ----echo = FALSE-------------------------------------------------------------
plume:::plm_table(status_methods)

## -----------------------------------------------------------------------------
aut <- Plume$new(dplyr::select(encyclopedists, given_name, family_name))

aut$set_corresponding_authors(dd, "j-jr", .by = "initials")
aut

## -----------------------------------------------------------------------------
aut$set_corresponding_authors(everyone())
aut

## ----include = FALSE----------------------------------------------------------
tmp_file <- withr::local_tempfile(
  lines = "title: Encyclopédie",
  fileext = ".yml"
)

## ----echo = FALSE, comment = ""-----------------------------------------------
cat(read_file(tmp_file))

## ----eval = FALSE-------------------------------------------------------------
# aut <- PlumeQuarto$new(
#   dplyr::slice(encyclopedists, 1, 4),
#   file = "example.yml"
# )
# aut$to_yaml()

## ----echo = FALSE, comment = ""-----------------------------------------------
aut <- PlumeQuarto$new(
  dplyr::slice(encyclopedists, 1, 4),
  tmp_file
)
aut$to_yaml()
cat(read_file(tmp_file))

## ----eval = FALSE-------------------------------------------------------------
# aut <- PlumeQuarto$new(
#   dplyr::slice(encyclopedists, 2),
#   file = "example.yml"
# )
# aut$to_yaml()

## ----echo = FALSE, comment = ""-----------------------------------------------
aut <- PlumeQuarto$new(
  dplyr::slice(encyclopedists, 2),
  tmp_file
)
aut$to_yaml()
cat(read_file(tmp_file))

## -----------------------------------------------------------------------------
aut <- Plume$new(encyclopedists)
aut$set_corresponding_authors(everyone())

aut$get_author_list(suffix = "ac")

aut$get_author_list(suffix = "ca")

## -----------------------------------------------------------------------------
aut$set_corresponding_authors(1, 4)

aut$get_author_list("^a,^cn")

## -----------------------------------------------------------------------------
aut$get_author_list(suffix = NULL)

## -----------------------------------------------------------------------------
aut$get_affiliations()

aut$get_notes(sep = ": ", superscript = FALSE)

## -----------------------------------------------------------------------------
aut$get_orcids(icon = FALSE, sep = " ")

## -----------------------------------------------------------------------------
aut$get_contact_details()

aut$get_contact_details(phone = TRUE)

aut$get_contact_details(template = "{name}: {details}")

## -----------------------------------------------------------------------------
aut$get_contributions()

aut$get_contributions(
  roles_first = FALSE,
  by_author = TRUE,
  literal_names = TRUE
)

aut2 <- Plume$new(
  encyclopedists,
  roles = c(
    supervision = "supervised the project",
    writing = "contributed to the Encyclopédie"
  )
)
aut2$get_contributions(roles_first = FALSE, divider = " ")

## -----------------------------------------------------------------------------
aut$get_contributions(alphabetical_order = TRUE)

## -----------------------------------------------------------------------------
aut$set_main_contributors(supervision = 4, writing = c(3, 2))
aut$get_contributions()

## -----------------------------------------------------------------------------
aut$set_main_contributors(jean, .roles = aut$roles(), .by = "given_name")
aut$get_contributions()

## -----------------------------------------------------------------------------
aut$get_contributions(alphabetical_order = TRUE)

## ----eval = FALSE-------------------------------------------------------------
# aut$set_main_contributors(4, 3, supervision = 1, .roles = aut$roles())

## ----echo = FALSE-------------------------------------------------------------
str(unclass(plm_symbols()))

## -----------------------------------------------------------------------------
aut <- Plume$new(
  encyclopedists,
  symbols = plm_symbols(affiliation = letters, note = NULL)
)

aut$get_author_list("^a,n^")

## ----eval = FALSE-------------------------------------------------------------
# Plume$new(
#   encyclopedists,
#   symbols = plm_symbols(affiliation = sequential(letters))
# )

