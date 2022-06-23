utils::globalVariables(c("."))
#' This is for load loadDisease2drugDb
#' @description The disease-drug and drug-gene associations are the core data of DSEATM.
#' We have generated two kind of relations for disease-drug, and drug-gene associations.
#' The one is "ALL" data, the other is "DSEATM" data.
#'
#' "ALL" means all MeSH terms in D category were used.
#' "DSEATM" means only part of MeSH terms in "ChemicalActionsandUses", "OrganicChemicals" and "Compounds,Heterocyclic" were used.
#'
#' @param data_type One of the values in c("Disease", "Drug").
#' This parameter is used to get disease2drug table or drug2gene table.
#' table disease2drug is in Disease type database.
#' Five columns in disease2drug: Drug, Disease, CoFre, oddratio, pvalue
#' Disease is the MeSH disease term ID
#' Drug is the MeSH Drug term ID
#' CoFree is the co-occurance of one disease-drug pair,
#' oddratio is the fisher test of the co-occurance
#' pvalue is the significance of the fisher test
#'
#' table drug2gene is in Drug type database.
#' Three columns in disease2drug: MESHID, GENEID, group
#' MESHID is the MeSH drugs,
#' GENEID is the Entrez gene ID
#' group is the source of the drug-gene association
#' all drug-gene association in this table are significant relations.
#'
#' @param Repository one of the values in c("ALL", "DSEATM").
#' "ALL" means all MeSH terms in "D" category will be obtained in the disease-drug association.
#' In this condition, all the terms are chemical and drugs.
#' "DSEATM" means only MeSH terms below "ChemicalActionsandUses", "OrganicChemicals" and "Compounds,Heterocyclic"
#'
#' The default is "DSEATM"
#'
#' @importFrom RSQLite dbConnect
#' @importFrom RSQLite SQLite
#' @importFrom ensurer ensure_that
#'
#' @export
#' @examples
#' dis <- "D015179"
#' con <- loadDisease2drugDb(data_type="Disease")
#' res <- RSQLite::dbSendQuery(con,
#'        sprintf("SELECT * FROM disease2drug WHERE Disease = %s%s%s", "'", dis, "'"))
#' df = as.data.frame(RSQLite::dbFetch(res))
#'
loadDisease2drugDb <- function(data_type, Repository="DSEATM") {
  ## adding checks for disease name
  data_type_vector = c("Disease", "Drug")
  data_type <- ensurer::ensure_that(data_type, !is.null(.) && is.character(.) && . %in% data_type_vector, err_desc = "Please enter correct data_type.")

  ## adding checks for drug repository
  drugs_options = c("DSEATM", "ALL")
  Repository = ensurer::ensure_that(Repository, !is.null(.) && is.character(.) && . %in% drugs_options, err_desc = "Please enter correct drug repository.")

  ##connecting the database
  if (Repository=="DSEATM"){
      ## connection
      ##disease-drug association
      if (data_type == "Disease"){
      db <- RSQLite::dbConnect(RSQLite::SQLite(),
                               paste0(
                                 system.file("extdata", package = "DSEATM"),
                                 paste0("/", "disease2drug.db")
                               ))
      return(db)
      }

      ##drug-gene association
      if (data_type == "Drug"){
      db <- RSQLite::dbConnect(RSQLite::SQLite(),
                              paste0(
                              system.file("extdata", package = "DSEATM"),
                              paste0("/", "drug2gene.db")
                              ))
      return(db)
      }
  }

  if (Repository=="ALL"){
    ## connection
    ##disease-drug association
    if (data_type == "Disease"){
      db <- RSQLite::dbConnect(RSQLite::SQLite(),
                               paste0(
                                 system.file("extdata", package = "DSEATM"),
                                 paste0("/", "disease2drug_all.db")
                               ))
      return(db)
    }

    ##drug-gene association
    if (data_type == "Drug"){
      db <- RSQLite::dbConnect(RSQLite::SQLite(),
                               paste0(
                                 system.file("extdata", package = "DSEATM"),
                                 paste0("/", "drug2gene_all.db")
                               ))
      return(db)
    }
  }

}

