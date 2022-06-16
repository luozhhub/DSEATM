#' This is for load disease2drug.db
#'
#' @param data_type get disease2drug table or drug2gene table, the value is "Disease" or "Drug"
#'
#' @importFrom RSQLite dbConnect
#' @importFrom RSQLite SQLite
#'
#' @export
#'
#'
disease2drugDb <- function(data_type) {
  ## connection
  if (data_type == "Disease"){
  db <- RSQLite::dbConnect(RSQLite::SQLite(),
                           paste0(
                             system.file("extdata", package = "DSEATM"),
                             paste0("/", "disease2drug.db")
                           ))
  return(db)
  }

  if (data_type == "Drug"){
  db <- RSQLite::dbConnect(RSQLite::SQLite(),
                          paste0(
                          system.file("extdata", package = "DSEATM"),
                          paste0("/", "drug2gene.db")
                          ))
  return(db)
  }
}

## load disease2drug.db
loadDisease2drugDb <- function (data_type) {
  obj <- disease2drugDb(data_type)
  return(obj)
}
