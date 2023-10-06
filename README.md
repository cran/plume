
<!-- README.md is generated from README.Rmd. Please edit that file -->

# plume

<!-- badges: start -->

[![R-CMD-check](https://github.com/arnaudgallou/plume/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/arnaudgallou/plume/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/arnaudgallou/plume/branch/main/graph/badge.svg)](https://app.codecov.io/gh/arnaudgallou/plume?branch=main)
<!-- badges: end -->

## Overview

plume provides tools for handling and generating author-related
information for scientific writing in R Markdown and Quarto. The package
implements two R6 classes:

- `PlumeQuarto`: class that allows you to push or update author metadata
  in the YAML header of Quarto files. The generated YAML complies with
  Quarto’s [author and affiliations
  schemas](https://quarto.org/docs/journals/authors.html). This is the
  class to use if you work with journal templates.

- `Plume`: class that generates author lists and other author-related
  information as character strings. This is an easy and convenient
  solution when you don’t need preformatted documents.

## Installation

Install plume from CRAN with:

``` r
install.packages("plume")
```

Alternatively, you can install the development version of plume from
GitHub with:

``` r
# install.packages("pak")
pak::pak("arnaudgallou/plume")
```

## Usage

The minimal required data to work with plume classes is a data set
containing given and family names but you would normally want to provide
more information such as email addresses, ORCIDs, affiliations, etc.

``` r
library(plume)

encyclopedists
#> # A tibble: 4 × 12
#>   given_name family_name email phone orcid role_n1 role_n2 role_v1 role_v2 note 
#>   <chr>      <chr>       <chr> <chr> <chr> <chr>   <chr>   <chr>   <chr>   <chr>
#> 1 Denis      Diderot     dide… 00 0… 0000… Writing Superv… contri… superv… born…
#> 2 Jean-Jacq… Rousseau    rous… <NA>  0000… Writing <NA>    contri… <NA>    <NA> 
#> 3 François-… Arouet      arou… <NA>  <NA>  Writing <NA>    contri… <NA>    also…
#> 4 Jean       Le Rond d'… alem… <NA>  0000… Writing Superv… contri… superv… born…
#> # ℹ 2 more variables: affiliation1 <chr>, affiliation2 <chr>

Plume$new(encyclopedists)
#> # A tibble: 4 × 11
#>      id given_name     family_name literal_name initials email phone orcid note 
#>   <int> <chr>          <chr>       <chr>        <chr>    <chr> <chr> <chr> <chr>
#> 1     1 Denis          Diderot     Denis Dider… DD       dide… 00 0… 0000… born…
#> 2     2 Jean-Jacques   Rousseau    Jean-Jacque… J-JR     rous… <NA>  0000… <NA> 
#> 3     3 François-Marie Arouet      François-Ma… F-MA     arou… <NA>  <NA>  also…
#> 4     4 Jean           Le Rond d'… Jean Le Ron… JLRd'A   alem… <NA>  0000… born…
#> # ℹ 2 more variables: affiliation <list>, role <list>
```

`PlumeQuarto` lets you push author metadata in the YAML header of any
`.qmd` file using the `to_yaml()` method.

Consider the following example:

    ---
    title: Encyclopédie
    ---

    Qui scribit bis legit

``` r
aut <- PlumeQuarto$new(
  encyclopedists,
  file = "file.qmd",
  names = c(role = "role_n")
)
aut$set_corresponding_authors(1, 4)
aut$to_yaml()
```

    ---
    title: Encyclopédie
    author:
      - id: aut1
        name:
          given: Denis
          family: Diderot
        email: diderot@encyclopediste.fr
        phone: 00 00 00 01
        orcid: 0000-0000-0000-0001
        note: born in 1713 in Langres
        attributes:
          corresponding: true
        roles:
          - writing
          - supervision
        affiliations:
          - ref: aff1
      - id: aut2
        name:
          given: Jean-Jacques
          family: Rousseau
        email: rousseau@encyclopediste.fr
        orcid: 0000-0000-0000-0002
        attributes:
          corresponding: false
        roles:
          - writing
        affiliations:
          - ref: aff2
      - id: aut3
        name:
          given: François-Marie
          family: Arouet
        email: arouet@encyclopediste.fr
        note: also known as Voltaire
        attributes:
          corresponding: false
        roles:
          - writing
        affiliations:
          - ref: aff2
      - id: aut4
        name:
          given: Jean
          family: Le Rond d'Alembert
        email: alembert@encyclopediste.fr
        orcid: 0000-0000-0000-0003
        note: born in 1717 in Paris
        attributes:
          corresponding: true
        roles:
          - writing
          - supervision
        affiliations:
          - ref: aff1
          - ref: aff3
    affiliations:
      - id: aff1
        name: Université de Paris
      - id: aff2
        name: Lycée Louis-le-Grand
      - id: aff3
        name: Collège des Quatre-Nations
    ---

    Qui scribit bis legit

Alternatively, you can generate author information as character strings
using `Plume`:

``` r
aut <- Plume$new(encyclopedists, names = c(role = "role_n"))
aut$set_corresponding_authors(diderot, by = "family_name")

aut$get_author_list(format = "^a,^cn") |> enumerate(last = ",\n")
#> Denis Diderot^1,^\*†, Jean-Jacques Rousseau^2^, François-Marie Arouet^2^‡,
#> Jean Le Rond d'Alembert^1,3^§

aut$get_contact_details()
#> diderot@encyclopediste.fr (Denis Diderot)

aut$get_affiliations()
#> ^1^Université de Paris
#> ^2^Lycée Louis-le-Grand
#> ^3^Collège des Quatre-Nations

aut$get_notes()
#> ^†^born in 1713 in Langres
#> ^‡^also known as Voltaire
#> ^§^born in 1717 in Paris

aut$get_contributions()
#> Writing: D.D., J.-J.R., F.-M.A. and J.L.R.d'A.
#> Supervision: D.D. and J.L.R.d'A.

aut_v <- Plume$new(
  encyclopedists,
  names = c(role = "role_v"),
  symbols = list(affiliation = letters)
)

aut_v$get_author_list(format = "^a^") |> enumerate(last = ",\n")
#> Denis Diderot^a^, Jean-Jacques Rousseau^b^, François-Marie Arouet^b^,
#> Jean Le Rond d'Alembert^a,c^

aut_v$get_contributions(roles_first = FALSE, divider = " ")
#> D.D., J.-J.R., F.-M.A. and J.L.R.d'A. contributed to the Encyclopédie
#> D.D. and J.L.R.d'A. supervised the project
```

## Acknowledgements

Thanks to:

- [Richard J. Telford](https://github.com/richardjtelford) for his
  advice that helped me conceive this package.

- [Maëlle Salmon](https://github.com/maelle) and [Gábor
  Csárdi](https://github.com/gaborcsardi) for their help when I was
  stuck with unit tests, roxygen2 or pkgdown.