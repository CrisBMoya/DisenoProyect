#Library
library(qrcode)
library(ggplot2)
library(reshape2)
library(shinyjs)
library(shinyalert)

#Function para codificar
source(file="~/DisenoProyect/Functions/CodeString.R")

#Cargar codigo
CodeNames=readLines(con="~/DisenoProyect/CodeNames.txt")
Code=c(letters,"_","-", 0:9)
names(Code)=CodeNames

#Habilitar javascript
useShinyjs()

#Desconectar DB en caso de que tenga conexion abierta
try(expr=dbDisconnect(conn=DB), silent=TRUE)

#Abrir conexion a database
DB=dbConnect(MySQL(), user='root', password='ABCD123456', dbname='qrdb', host='127.0.0.1')

#Extraer info de tabla de pasajes
PasajesDF=dbReadTable(conn=DB, name="pasajes")

#Desconectar DB en caso de que tenga conexion abierta
try(expr=dbDisconnect(conn=DB), silent=TRUE)

#Tomar nombre de usuario desde fuente del source
User=commandArgs()$User

#Match entre usuario logeado y usuarios en DB de pasajes
PasajeInfo=reactive({PasajesDF[PasajesDF$Usuario %in% User,]})

#Generar lista de opciones de RadioButtons
ListaOpciones=as.list(1:nrow(PasajeInfo()))
names(ListaOpciones)=paste0(PasajeInfo()$Origen, " ",
                            PasajeInfo()$Destino, " ",
                            PasajeInfo()$Fecha)

#RadioButtons para elegir el pasaje a generar QR
output$QRList=renderUI({
  radioButtons(inputId="QRSel", label="QRList", 
               choices=ListaOpciones)
})

#Reactive de informacion en QR en base a seleccion de RadioButtons
##Actual string
InfoQRReac=reactive({paste0("http://35.196.145.170:3838/DisenoProject?",
                            CodeString(text=paste0(PasajeInfo()[as.numeric(input$QRSel),], collapse="_"), 
                                       code=Code))})

#Al apretar boton submit:
##Borrar parte de la UI
##Graficar QR
##Generar boton de descarga
observeEvent(input$SbmtBtn, {
  #Eliminar UI
  
  # removeUI(selector="#QRSel")
  # removeUI(selector="#SbmtBtn")
  shinyjs::toggleElement(id="QRSel")
  shinyjs::toggleElement(id="SbmtBtn")
  
  
  #Generar UI para plotear el QR y graficar
  output$QRUi=renderUI({
    #Renderizar QR
    output$QRPlot=renderPlot({
      qrcode_gen(dataString=InfoQRReac(), plotQRcode=TRUE)
    })
    #Graficar QR
    plotOutput(outputId="QRPlot") 
  })
  
  #Generar boton de descarga
  output$PlotSpace=renderUI({
    downloadButton(outputId="DownloadQR", label="Descargar")
  })
  
  #Generar boton para volver
  output$VolverSpace=renderUI({
    actionButton(inputId="Volver", label="Volver")
  })
  
})

#Graficar al presionar boton
output$DownloadQR=downloadHandler(
  filename="QR.pdf",
  content=function(file){
    pdf(file, width=10, height=10)
    print(qrcode_gen(dataString=InfoQRReac()))
    dev.off()
  }
)


#Pasa nombre de usuario como argumento
commandArgs=function(...){
  UserReactive()
}

#Volver
observeEvent(input$Volver,{
  shinyjs::toggleElement(id="QRSel")
  shinyjs::toggleElement(id="SbmtBtn")
  
  shinyjs::toggleElement(id="QRPlot")
  shinyjs::toggleElement(id="DownloadQR")
  shinyjs::toggleElement(id="Volver")
})



