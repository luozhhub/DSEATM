#' the CMap drug MesH ID
#'
#' A dataset containing the cmap drug name and MeSH term ID
#' there are 1309 drugs in CMap, 1129 of them can be assigned MeSH ID
#' cmap_drug
#'
#' @format A data frame with 1129 rows and 4 variables:
#' \describe{
#'   \item{cmap_name}{drug names, this is the drug orignal names}
#'   \item{CID}{drug pubchem ID}
#'   \item{meshterm}{drug MeSH name, parsed by pyMeSHSim}
#'   \item{meshID}{drug MeSH ID, the drug MeSH ID}
#'   ...
#' }
"cmap_drug"
