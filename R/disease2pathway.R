#' Enriched the pathways for diseases
#'
#' @param DiseaseMeSHID the MeSH id of intersted disease
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
