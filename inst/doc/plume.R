## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
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

fetch <- plume:::list_fetch
.names <- plume:::.names
.names_quarto <- plume:::.names_quarto

make_table_vars <- function(category) {
  vars_plume <- fetch(.names, category)
  vars_plume_quarto <- fetch(.names_quarto, category)
  keys <- list_keys(vars_plume_quarto)
  tibble::tibble(
    name = keys,
    Plume = ifelse(unlist(vars_plume_quarto) %in% unlist(vars_plume), 1, 0),
    PlumeQuarto = 1
  ) |>
    gt() |>
    text_case_match(
      "1" ~ fontawesome::fa("check"),
      .default = "",
      .locations = cells_body(tidyselect::starts_with("Plume"))
    ) |>
    cols_label(name = "Name") |>
    cols_align(align = "center", columns = tidyselect::starts_with("Plume")) |>
    cols_width(name ~ pct(50)) |>
    opt_row_striping()
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
    initials = "initiales",
    role = "role_v"
  )
)

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
#    file = "file.qmd",
#    names = c(role = "role_n")
#  )
#  aut$to_yaml()

## ---- echo = FALSE, comment = ""----------------------------------------------
aut <- PlumeQuarto$new(
  dplyr::slice(encyclopedists, 1, 4),
  tmp_file,
  names = c(role = "role_n")
)
aut$to_yaml()
cat(read_file(tmp_file))

## ---- eval = FALSE------------------------------------------------------------
#  aut <- PlumeQuarto$new(
#    dplyr::slice(encyclopedists, 2),
#    file = "file.qmd",
#    names = c(role = "role_n")
#  )
#  aut$to_yaml()

## ---- echo = FALSE, comment = ""----------------------------------------------
aut <- PlumeQuarto$new(
  dplyr::slice(encyclopedists, 2),
  tmp_file,
  names = c(role = "role_n")
)
aut$to_yaml()
cat(read_file(tmp_file))

## -----------------------------------------------------------------------------
aut <- Plume$new(dplyr::select(encyclopedists, given_name, family_name))

aut$set_corresponding_authors(dd, "j-jr", by = "initials")
aut

## -----------------------------------------------------------------------------
aut$set_corresponding_authors(everyone())
aut

## -----------------------------------------------------------------------------
aut$set_corresponding_authors(everyone_but(jean), by = "given_name")
aut

## -----------------------------------------------------------------------------
aut <- Plume$new(encyclopedists)
aut$set_corresponding_authors(everyone())

aut$get_author_list(format = "ac") |> enumerate(last = ",\n")

aut$get_author_list(format = "ca") |> enumerate(last = ",\n")

## -----------------------------------------------------------------------------
aut$set_corresponding_authors(1, 4)

aut$get_author_list(format = "^a,^cn") |> enumerate(last = ",\n")

## -----------------------------------------------------------------------------
aut$get_author_list(format = NULL) |> enumerate()

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
aut <- Plume$new(encyclopedists, names = c(role = "role_n"))
aut$get_contributions()

aut$get_contributions(
  roles_first = FALSE,
  by_author = TRUE,
  literal_names = TRUE
)

aut_v <- Plume$new(encyclopedists, names = c(role = "role_v"))
aut_v$get_contributions(roles_first = FALSE, divider = " ")

## -----------------------------------------------------------------------------
aut$get_contributions(alphabetical_order = TRUE)

## ---- echo = FALSE------------------------------------------------------------
str(plume:::.symbols)

## -----------------------------------------------------------------------------
aut <- Plume$new(encyclopedists, symbols = list(affiliation = letters, note = NULL))

aut$get_author_list(format = "^a,n^") |> enumerate(last = ",\n")

## ---- eval = FALSE------------------------------------------------------------
#  Plume$new(
#    encyclopedists,
#    symbols = list(affiliation = sequential(letters))
#  )

