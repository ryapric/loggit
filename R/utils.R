# Helper function to append rows 
bind_rows_loggit <- function(df1, df2) {
  stopifnot('data.frame' %in% class(df1))
  stopifnot('data.frame' %in% class(df2))
  
  headers1 <- colnames(df1)
  headers2 <- colnames(df2)
  headers <- union(headers1, headers2)
  
  for (header in headers) {
    if (!(header %in% headers1)) {
      df1[, header] <- NA
    }
    if (!(header %in% headers2)) {
      df2[, header] <- NA
    }
  }
  
  rbind(df1, df2)
}
