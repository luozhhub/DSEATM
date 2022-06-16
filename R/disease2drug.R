#' Select the disease related drugs
#'
#' @param DiseaseMeSHID the MeSH id of intersted disease, only Main heading diseases were allowed
#'
#' @return dataframe
#'
#' @importFrom RSQLite dbConnect
#' @importFrom RSQLite SQLite
#'
#' @export
#' @examples
#' disease2drug("D015179")
#'
#'
disease2drug <- function(DiseaseMeSHID) {
  dis <- DiseaseMeSHID
  con <- loadDisease2drugDb(data_type="Disease")
  res <- RSQLite::dbSendQuery(con,
                     sprintf("SELECT * FROM disease2drug WHERE Disease = %s%s%s",
                             "'", dis, "'"))
  return(as.data.frame(RSQLite::dbFetch(res)))

}

