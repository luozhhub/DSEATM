#' Select the disease related genes by drugs
#'
#' @param DiseaseMeSHID the MeSH id of intersted disease
#'
#' @return vactor it containing Entrez gene IDs related to the diseases.
#'
#' @importFrom RSQLite dbConnect
#' @importFrom RSQLite SQLite
#'
#' @export
#' @examples
#' disease2gene("D015179")
#'
#'
disease2gene <- function(DiseaseMeSHID) {
  dis <- DiseaseMeSHID
  con <- loadDisease2drugDb(data_type="Disease")
  res <- RSQLite::dbSendQuery(con,
                     sprintf("SELECT * FROM disease2drug WHERE Disease = %s%s%s",
                             "'", dis, "'"))
  df_diseaseDrugs = as.data.frame(RSQLite::dbFetch(res))
  RSQLite::dbClearResult(res)
  RSQLite::dbDisconnect(con)

  drug_list = df_diseaseDrugs$Drug
  #remove the top level terms
  rm_drug <- c("D018926","D000890","D000893","D019440","D000970",
               "D018501","D002317","D002491","D003879","D005765",
               "D006401","D057847","D019999","D011838","D012076",
               "D012102","D019141","D000077444","D018758","D064804")
  drug_list = drug_list[!drug_list %in% rm_drug]

  d_con <- loadDisease2drugDb(data_type="Drug")
  df_drugGenes = RSQLite::dbReadTable(d_con, "drug2gene")
  RSQLite::dbDisconnect(d_con)

  genes = df_drugGenes[df_drugGenes$MESHID %in% drug_list,]$GENEID
  return(unique(genes))
}
