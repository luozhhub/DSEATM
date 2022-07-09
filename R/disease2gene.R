#' Select the disease related genes by drugs
#'
#' @param DiseaseMeSHID the MeSH id of intersted disease
#' @param Repository one of the values in c("ALL", "DSEATM").
#' "ALL" means all MeSH terms in "D" category will be obtained in the disease-drug association.
#' In this condition, all the terms are chemical and drugs.
#' "DSEATM" means only MeSH terms below "ChemicalActionsandUses", "OrganicChemicals" and "Compounds,Heterocyclic"
#'
#' The default is "DSEATM"
#'
#' @return dataframe It containing MeSHID, GENEID and group.
#' MESHID is MeSH drug and chemical terms ID.
#' GENEID is Entrez gene ID.
#' group is the drug-gene relation source. fisher_test means relations extracted from publication abstracts,
#' meshr means relations extracted from MeSH.Hsg.eg.db
#'
#'
#' @importFrom RSQLite dbConnect
#' @importFrom RSQLite SQLite
#'
#' @export
#' @examples
#' disease2gene("D015179")
#'
#'
disease2gene <- function(DiseaseMeSHID, Repository="DSEATM") {
  dis <- DiseaseMeSHID
  con <- loadDisease2drugDb(data_type="Disease", Repository=Repository)
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

  d_con <- loadDisease2drugDb(data_type="Drug", Repository=Repository)
  df_drugGenes = RSQLite::dbReadTable(d_con, "drug2gene")
  RSQLite::dbDisconnect(d_con)

  genes_df = df_drugGenes[df_drugGenes$MESHID %in% drug_list,]
  return(genes_df)
}
