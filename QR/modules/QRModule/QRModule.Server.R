#Library
library(qrcode)
library(ggplot2)
library(reshape2)
library(shinyjs)
library(shinyalert)

#Function para codificar
source(file="~/DisenoProyect/Functions/CodeString.R")
source(file="~/DisenoProyect/QR/modules/QRModule/QRTableSubModule.R", local=TRUE)

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

#Subset Info de tabla
FormatDF=reactive({PasajeInfo()[,grep(pattern="Origen|Destino|Fecha", x=colnames(PasajeInfo()))]})

#Generar tabla vacia
output$Tabla=renderUI({TableSubmodule.UI(id="TableSubmoduleUI")})

#Agregar datos a la tabla vacia
#Iterar en Filas
lapply(1:nrow(PasajeInfo()), function(x){
  #Iterar en Columnas
  lapply(1:ncol(FormatDF()), function(i){
    #Generar colnames
    if(x==1){
      output[[paste0("Colnames",x,i)]]=renderUI({
        as.character(colnames(FormatDF())[i])
      })
    }
    
    #Popular tabla
    output[[paste0("Row",x,"Col",i)]]=renderUI({
      as.character(FormatDF()[x,i])
    })
    
  })
})

#Generar lista de opciones de RadioButtons
ListaOpciones=as.list(1:nrow(PasajeInfo()))
names(ListaOpciones)=paste0(PasajeInfo()$Origen, " ",
                            PasajeInfo()$Destino, " ",
                            PasajeInfo()$Fecha)

#Dropdown menu para elegir el pasaje a imprimir
output$QRDropdown=renderUI({
  selectInput(inputId="QRSelect", label="Seleccionar Pasaje:",
              choices=ListaOpciones)
})

#Reactive de informacion en QR en base a seleccion de RadioButtons
##Actual string
InfoQRReac=reactive({paste0("http://35.196.145.170:3838/DisenoProject?",
                            CodeString(text=paste0(PasajeInfo()[as.numeric(input$QRSelect),], collapse="_"), 
                                       code=Code))})

#Al apretar boton submit:
##Borrar parte de la UI
##Graficar QR
##Generar boton de descarga
observeEvent(input$SbmtBtn, {
  #Eliminar UI
  shinyjs::toggleElement(id="QRSelect")
  shinyjs::toggleElement(id="SbmtBtn")
  shinyjs::toggleElement(id="Tabla")
  
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
  output$DownloadBtnUI=renderUI({
    downloadButton(outputId="DownloadQR", label="Descargar", icon=icon("download"),
                   style="color: #fff;
                   background-color: #428bca;
                   border-color: #357ebd;
                   display: inline-block;")
  })
  
  #Generar boton para volver
  output$VolverBtnUI=renderUI({
    actionButton(inputId="Volver", label="Volver", icon=icon("arrow-left"), 
                 style="color: #fff; 
                        background-color: #d2322d;
                        border-color: #ac2925;
                        display: inline-block;")
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
  shinyjs::toggleElement(id="QRSelect")
  shinyjs::toggleElement(id="SbmtBtn")
  shinyjs::toggleElement(id="Tabla")
  
  shinyjs::toggleElement(id="QRPlot")
  shinyjs::toggleElement(id="DownloadQR")
  shinyjs::toggleElement(id="Volver")
})



