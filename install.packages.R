
if(!requireNamespace("devtools", quietly = TRUE)){
  install.packages("devtools")
}
if(!requireNamespace("qrcode", quietly = TRUE)){
  install.packages("qrcode")
}
if(!requireNamespace("reshape2", quietly = TRUE)){
  install.packages("reshape2")
}

if(!requireNamespace("shinyjs", quietly = TRUE)){
  install.packages("shinyjs")
}

if(!requireNamespace("shinyalert", quietly = TRUE)){
  devtools::install_github("daattali/shinyalert", upgrade="never", quiet=TRUE)
}

if(!requireNamespace("RMySQL", quietly = TRUE)){
  install.packages("RMySQL")
}
if(!requireNamespace("DBI", quietly = TRUE)){
  install.packages("DBI")
}

