#' Select the drug related genes
#'
#' @param DrugMeSHID the MeSH id of intersted drug
#'
#' @return dataframe
#'
#' @importFrom RSQLite dbConnect
#' @importFrom RSQLite SQLite
#'
#' @export
#' @examples
#' drug2gene("D016861")
#'
#'
drug2gene <- function(DrugMeSHID) {
  drug <- DrugMeSHID
  con <- loadDisease2drugDb(data_type="Drug")
  res <- RSQLite::dbSendQuery(con,
                     sprintf("SELECT * FROM drug2gene WHERE MESHID = %s%s%s",
                             "'", drug, "'"))
  return(as.data.frame(RSQLite::dbFetch(res)))
}

