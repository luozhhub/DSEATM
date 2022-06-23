#' Enriched the pathways for diseases
#' @description The disease2pathway function is used to calculate the enrichment
#' of disease genes. Given an input gene set,
#' it invokes the clusterProfiler to realize the enrichment function.
#' The gene set can be retived by a disease name.
#' DSEATM used a diseases associated drugs to get associated genes,
#' @author Zhi-Hui Luo, Ya-Min Wang
#'
#' @param DiseaseMeSHID the MeSH id of intersted disease, only MeSH main headings are allowed here.
#'
#' @importFrom clusterProfiler enricher
#' @importFrom org.Hs.eg.db org.Hs.eg.db
#' @importFrom AnnotationDbi mapIds
#'
#' @return dataframe it containing the pathways enriched
#' @export
#' @examples
#' disease2pathway("D015179")
#'
#'
disease2pathway <- function(DiseaseMeSHID) {
  dis <- DiseaseMeSHID

  ### adding checks for disease name
  dis <- ensurer::ensure_that(dis, !is.null(.) && is.character(.) && startsWith(., "D"), err_desc = "Please enter correct MeSH terms.")

  genes = disease2gene(dis)
  genes_symbol = AnnotationDbi::mapIds(x = org.Hs.eg.db,
                keys = as.character(genes),
                keytype = "ENTREZID",
                column = "SYMBOL")

  DSEATM_result = clusterProfiler::enricher(genes_symbol,
                           pAdjustMethod = "BH",
                           TERM2GENE=DSEATM::pathway_gene_df)
  DSEATM_pathways = DSEATM_result@result
  return(DSEATM_pathways)
}
