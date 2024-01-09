## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(plume)

## -----------------------------------------------------------------------------
PlumeFr <- R6::R6Class(
  classname = "PlumeFr",
  inherit = Plume,
  private = list(
    plume_names = set_default_names(
      initials = "initiales",
      literal_name = "nom_complet",
      corresponding = "correspondant",
      given_name = "prénom",
      family_name = "nom",
      email = "courriel",
      phone = "téléphone"
    )
  )
)

## -----------------------------------------------------------------------------
PlumeFr$new(encyclopedists_fr)

## -----------------------------------------------------------------------------
PlumeFr$set("public", "get_contributions", function(
  roles_first = TRUE,
  by_author = FALSE,
  alphabetical_order = FALSE,
  dotted_initials = TRUE,
  literal_names = FALSE,
  divider = " : ",
  sep = ", ",
  sep_last = " et "
) {
  super$get_contributions(
    roles_first, by_author, alphabetical_order, dotted_initials,
    literal_names, divider, sep, sep_last
  )
})

## -----------------------------------------------------------------------------
aut <- PlumeFr$new(
  encyclopedists_fr,
  roles = c(supervision = "Supervision", rédaction = "Rédaction")
)
aut$get_contributions()

