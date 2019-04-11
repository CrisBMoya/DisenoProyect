#Tomar nombre de usuario desde fuente del source
DataURL=commandArgs()$Rest

output$Tx1=renderText({
  as.character(DataURL)
})
