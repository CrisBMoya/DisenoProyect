source(file="~/DisenoProyect/Functions/DecodeString.R")

#Cargar codigo
CodeNames=readLines(con="~/DisenoProyect/CodeNames.txt")
Code=c(letters,"_","-", 0:9)
names(Code)=CodeNames

#Tomar nombre de usuario desde fuente del source
DataURL=commandArgs()$Rest

output$Tx1=renderText({
  
  DecodeString(text=substr(x=DataURL, start=2, stop=nchar(DataURL)), code=Code)

})


