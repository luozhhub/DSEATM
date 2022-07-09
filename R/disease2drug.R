#' Select the disease related drugs
#'
#' @param DiseaseMeSHID The MeSH id of intersted disease, only Main heading diseases are allowed here.
#' @param Repository one of the values in c("ALL", "DSEATM").
#' "ALL" means all MeSH terms in "D" category will be obtained in the disease-drug association.
#' In this condition, all the terms are chemical and drugs.
#' "DSEATM" means only MeSH terms below "ChemicalActionsandUses", "OrganicChemicals" and "Compounds,Heterocyclic"
#'
#' The default is "DSEATM"
#'
#' @return dataframe It contained all drugs associated to a specific diseases.
#'
#' @importFrom RSQLite dbConnect
#' @importFrom RSQLite SQLite
#' @importFrom ensurer ensure_that
#'
#' @export
#' @examples
#' #here, we only give out the drug ID in the table,
#' #detail information for each drug can be retrived by pyMeSHSim
#' #get disease-drug association in DSEATM repository
#' df = disease2drug("D015179")
#' # when using ALL repository,
#' # the disease-drug associations are in indeed disease-chemical associations
#' # Users can filter the drugs by their own principles in this data set.
#' df = disease2drug("D015179", Repository="ALL")
#'
#' #get CMap drugs associated to a disease
#' df = disease2drug("D015179", Repository="ALL")
#' df_cmap = df[df$Drug %in% DSEATM::cmap_drug$meshID,]
#'
#'
#'
disease2drug <- function(DiseaseMeSHID, Repository="DSEATM") {
  dis <- DiseaseMeSHID
  ### adding checks for disease name
  dis <- ensurer::ensure_that(dis, !is.null(.) && is.character(.) && startsWith(., "D"), err_desc = "Please enter correct MeSH terms.")

  ### adding checks for drug repository
  drugs_options = c("DSEATM", "ALL")
  Repository = ensurer::ensure_that(Repository, !is.null(.) && is.character(.) && . %in% drugs_options, err_desc = "Please enter correct drug repository.")


  con <- loadDisease2drugDb(data_type="Disease", Repository=Repository)
  res <- RSQLite::dbSendQuery(con,
                     sprintf("SELECT * FROM disease2drug WHERE Disease = %s%s%s",
                             "'", dis, "'"))
  return(as.data.frame(RSQLite::dbFetch(res)))

}
