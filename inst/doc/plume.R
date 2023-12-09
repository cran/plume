## ---- include = FALSE---------------------------------------------------------
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

## ---- echo = FALSE------------------------------------------------------------
list_keys <- function(x) {
  nms <- names(x)
  out <- vector("list", length(x))
  for (i in seq_along(x)) {
    x_i <- x[[i]]
    if (is.list(x_i)) {
      out[[i]] <- list_keys(x_i)
    } else {
      out[[i]] <- nms[i]
    }
  }
  unlist(out)
}

build_table <- function(data) {
  gt(data) |>
  text_case_match(
    "TRUE" ~ fontawesome::fa("check"),
    .default = "",
    .locations = cells_body(tidyselect::starts_with("Plume"))
  ) |>
  cols_label(name = "Name") |>
  cols_align(align = "center", columns = tidyselect::starts_with("Plume")) |>
  cols_width(name ~ pct(50)) |>
  opt_row_striping()
}

fetch <- plume:::list_fetch
.names_plume <- plume:::.names_plume
.names_quarto <- plume:::.names_quarto
.names_all <- purrr::list_modify(.names_plume, !!!.names_quarto)

are_within <- function(x, y) {
  unlist(y) %in% unlist(x)
}

make_table_vars <- function(category) {
  vars_plume <- fetch(.names_plume, category)
  vars_plume_quarto <- fetch(.names_quarto, category)
  vars <- fetch(.names_all, category)
  build_table(tibble::tibble(
    name = list_keys(vars),
    Plume = are_within(vars_plume, vars),
    PlumeQuarto = are_within(vars_plume_quarto, vars),
  ))
}

## ---- echo = FALSE------------------------------------------------------------
make_table_vars("primaries")

## ---- echo = FALSE------------------------------------------------------------
make_table_vars("secondaries")

## ---- echo = FALSE------------------------------------------------------------
make_table_vars("nestables")

## ---- echo = FALSE------------------------------------------------------------
make_table_vars("protected")

## ---- echo = FALSE------------------------------------------------------------
make_table_vars("internals")

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

## ---- echo = FALSE------------------------------------------------------------
tibble::tibble(
  given_name = c("Denis", "Jean-Jacques", "François-Marie", "Jean"),
  family_name = c("Diderot", "Rousseau", "Arouet", "Le Rond d'Alembert"),
  supervision = c(1, NA, NA, 1),
  writing = 1,
)

## ---- eval = FALSE------------------------------------------------------------
#  Plume$new(data, roles = c(
#    supervision = "supervised the project",
#    writing = "contributed to the writing"
#  ))

## ---- echo = FALSE------------------------------------------------------------
 status_methods <- tibble::tibble(
   name = c(
     "set_corresponding_authors()",
     "set_main_contributors()",
     "set_cofirst_authors()",
     "set_deceased()"
   ),
   Plume = as.logical(c(1, 1, 0, 0)),
   PlumeQuarto = as.logical(c(1, 0, 1, 1)),
 )

## ---- echo = FALSE------------------------------------------------------------
build_table(status_methods)

## -----------------------------------------------------------------------------
aut <- Plume$new(dplyr::select(encyclopedists, given_name, family_name))

aut$set_corresponding_authors(dd, "j-jr", .by = "initials")
aut

## -----------------------------------------------------------------------------
aut$set_corresponding_authors(everyone())
aut

## ---- include = FALSE---------------------------------------------------------
tmp_file <- withr::local_tempfile(
  lines = "---\ntitle: Encyclopédie\n---\n\nQui scribit bis legit",
  fileext = ".qmd"
)

## ---- echo = FALSE, comment = ""----------------------------------------------
cat(read_file(tmp_file))

## ---- eval = FALSE------------------------------------------------------------
#  aut <- PlumeQuarto$new(
#    dplyr::slice(encyclopedists, 1, 4),
#    file = "file.qmd"
#  )
#  aut$to_yaml()

## ---- echo = FALSE, comment = ""----------------------------------------------
aut <- PlumeQuarto$new(dplyr::slice(encyclopedists, 1, 4), tmp_file)
aut$to_yaml()
cat(read_file(tmp_file))

## ---- eval = FALSE------------------------------------------------------------
#  aut <- PlumeQuarto$new(
#    dplyr::slice(encyclopedists, 2),
#    file = "file.qmd"
#  )
#  aut$to_yaml()

## ---- echo = FALSE, comment = ""----------------------------------------------
aut <- PlumeQuarto$new(dplyr::slice(encyclopedists, 2), tmp_file)
aut$to_yaml()
cat(read_file(tmp_file))

## -----------------------------------------------------------------------------
aut <- Plume$new(encyclopedists)
aut$set_corresponding_authors(everyone())

aut$get_author_list(suffix = "ac") |> enumerate(last = ",\n")

aut$get_author_list(suffix = "ca") |> enumerate(last = ",\n")

## -----------------------------------------------------------------------------
aut$set_corresponding_authors(1, 4)

aut$get_author_list("^a,^cn") |> enumerate(last = ",\n")

## -----------------------------------------------------------------------------
aut$get_author_list(suffix = NULL) |> enumerate()

## -----------------------------------------------------------------------------
aut$get_affiliations()

aut$get_notes(sep = ": ", superscript = FALSE)

## -----------------------------------------------------------------------------
aut$get_orcids(compact = FALSE, icon = FALSE, sep = " ")

## -----------------------------------------------------------------------------
aut$get_contact_details()

aut$get_contact_details(phone = TRUE)

aut$get_contact_details(format = "{name}: {details}")

## -----------------------------------------------------------------------------
aut$get_contributions()

aut$get_contributions(
  roles_first = FALSE,
  by_author = TRUE,
  literal_names = TRUE
)

aut2 <- Plume$new(encyclopedists, roles = c(
  supervision = "supervised the project",
  writing = "contributed to the Encyclopédie"
))
aut2$get_contributions(roles_first = FALSE, divider = " ")

## -----------------------------------------------------------------------------
aut$get_contributions(alphabetical_order = TRUE)

## -----------------------------------------------------------------------------
aut$set_main_contributors(supervision = 4, writing = c(3, 2))
aut$get_contributions()

## -----------------------------------------------------------------------------
aut$set_main_contributors(jean, .roles = aut$get_roles(), .by = "given_name")
aut$get_contributions()

## -----------------------------------------------------------------------------
aut$get_contributions(alphabetical_order = TRUE)

## ---- echo = FALSE------------------------------------------------------------
str(plume:::.symbols)

## -----------------------------------------------------------------------------
aut <- Plume$new(encyclopedists, symbols = list(affiliation = letters, note = NULL))

aut$get_author_list("^a,n^") |> enumerate(last = ",\n")

## ---- eval = FALSE------------------------------------------------------------
#  Plume$new(
#    encyclopedists,
#    symbols = list(affiliation = sequential(letters))
#  )

