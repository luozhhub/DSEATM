#' Enriched the pathways for diseases
#' @description The disease2pathway function is used to calculate the enrichment
#' of disease genes. Given an input gene set,
#' it invokes the clusterProfiler to realize the enrichment function.
#' The gene set can be retived by a disease name.
#' DSEATM used a diseases associated drugs to get associated genes,
#' @author Zhi-Hui Luo, Ya-Min Wang
#'
#' @param DiseaseMeSHID the MeSH id of intersted disease, only MeSH main headings are allowed here.
#' @param Repository one of the values in c("ALL", "DSEATM").
#' "ALL" means all MeSH terms in "D" category will be obtained in the disease-drug association.
#' In this condition, all the terms are chemical and drugs.
#' "DSEATM" means only MeSH terms below "ChemicalActionsandUses", "OrganicChemicals" and "Compounds,Heterocyclic"
#'
#' The default is "DSEATM"
#'
#' @param data_source It denotes the drug-gene relation source used in enrichment, one of the values in c("ALL", "mineR", "meshr")
#' "ALL" means all drug-gene relations are used to extract drug-gene association.
#' "mineR" means only drug-gene relations extracted by pubmed.mineR from publication abstracts were used.
#' "meshr" means only drug-gene relations extracted from MeSH.Hsg.eg.db were used.
#'
#' The default is "ALL"
#'
#' @param gene_freq An integer describing the frequence thresould of genes used in enrichment.
#' A higher gene_freq means genes associated with more MeSH drug and chemical iterms are used.
#'
#' The default is 1
#'
#' @importFrom clusterProfiler enricher
#' @importFrom org.Hs.eg.db org.Hs.eg.db
#' @importFrom AnnotationDbi mapIds
#'
#' @return dataframe It containing the pathways enriched
#' @export
#' @examples
#' # get pathways enriched for breast cancer
#' disease2pathway("D001943")
#' disease2pathway("D001943", data_source="ALL", gene_freq=2)
#'
disease2pathway <- function(DiseaseMeSHID, Repository="DSEATM", data_source="ALL", gene_freq=1) {
  dis <- DiseaseMeSHID

  ### adding checks for disease name
  dis <- ensurer::ensure_that(dis, !is.null(.) && is.character(.) && startsWith(., "D"), err_desc = "Please enter correct MeSH terms.")
  ### adding checks for drug-gene relation data_source
  data_source_options = c("ALL", "mineR", "meshr")
  data_source <- ensurer::ensure_that(data_source, !is.null(.) && is.character(.) && . %in% data_source_options, err_desc = "Please enter correct data_source parameter.")
  ### adding checks for gene frequency
  gene_freq <- ensurer::ensure_that(gene_freq, !is.null(.) && is.numeric(.) && . >= 1, err_desc = "Please enter correct gene_freq parameter. it should be an integer >= 1.")

  ###extract genes from drugs
  genes_df = disease2gene(dis, Repository=Repository)
  #data_source
  if (data_source == "ALL"){
    genes_df = genes_df
  }
  if (data_source == "mineR"){
    genes_df = genes_df[genes_df$group == "fisher_test",]
  }
  if (data_source == "meshr"){
    genes_df = genes_df[genes_df$group == "meshr",]
  }
  #gene_freq
  genes_freq_df = as.data.frame(table(genes_df$GENEID))
  colnames(genes_freq_df) = c("GENEID", "Freq")
  genes_freq_df = genes_freq_df[genes_freq_df$Freq >= gene_freq,]
  genes_vector = unique(genes_freq_df$GENEID)


  ### convert Entrez gene ID to Gene Symbol
  genes_symbol = AnnotationDbi::mapIds(x = org.Hs.eg.db,
                keys = as.character(genes_vector),
                keytype = "ENTREZID",
                column = "SYMBOL")

  if (length(genes_symbol) <10) {
    stop("The number of genes associated to a disease is fewer than 10. check for the parameters",
         call. = FALSE)
  }
  ### enrichment
  DSEATM_result = clusterProfiler::enricher(genes_symbol,
                           pAdjustMethod = "BH",
                           TERM2GENE=DSEATM::pathway_gene_df)
  DSEATM_pathways = DSEATM_result@result

  ### return
  return(DSEATM_pathways)
}
