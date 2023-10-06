## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(plume)

## ---- echo = FALSE------------------------------------------------------------
tbl_credit <- encyclopedists |>
  dplyr::select(given_name, family_name) |>
  dplyr::mutate(
    conceptualization = c(1, NA, NA, NA),
    analysis = rep(1, 4),
    supervision = c(1, NA, NA, 1),
    writing = rep(1, 4)
  )

tbl_credit

## -----------------------------------------------------------------------------
aut <- Plume$new(tbl_credit, credit_roles = TRUE)
aut$get_contributions()

