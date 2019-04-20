source(file="~/DisenoProyect/Functions/DecodeString.R")
source(file="~/DisenoProyect/Functions/ValidarQR.R")

#Habilitar javascript
useShinyjs()

#Cargar codigo
CodeNames=readLines(con="~/DisenoProyect/CodeNames.txt")
Code=c(letters,"_","-"," ", 0:10)
names(Code)=CodeNames

#Si se ingreso a la pagina via link desde QR existiran datos en la URL
#Validar automaticamente.
if(nchar(commandArgs()$Rest)>10){
  #Tomar nombre de usuario desde fuente del source
  DataURL=commandArgs()$Rest
  
  #Tomar informacion de URL y decodificar
  QRTextURLReac=reactive({
    DecodedQR=DataURL
    #Remover simbolo "?"
    DecodedQR=gsub(pattern="\\?", replacement="", x=DecodedQR)
    #Decodificar informacion de campo de texto
    DecodedQR=DecodeString(text=DecodedQR, code=Code)
  })
  
  #Hacer match con base de datos
  ValidarQR(TxtQR=QRTextURLReac())
  
}

#Si la url viene sin datos, utilizar informacion rellenada en el campo de texto
#Tomar informacion de campo de texto
QRTextManualReac=reactive({
  DecodedQR=input$ManualQRTx
  #Remover simbolo
  DecodedQR=gsub(pattern="\\?", replacement="", x=DecodedQR)
  #Decodificar informacion de campo de texto
  DecodedQR=DecodeString(text=DecodedQR, code=Code)
  
})

#Comparar datos al apretar boton
observeEvent(input$ManualQRBtn,{
  #Hacer match con base de datos
  ValidarQR(TxtQR=QRTextManualReac())
})
