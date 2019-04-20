#Function para codificar
source(file="~/DisenoProyect/Functions/CodeString.R")
source(file="~/DisenoProyect/QR/modules/QRModule/QRTableSubModule.R", local=TRUE)

#Cargar codigo
CodeNames=readLines(con="~/DisenoProyect/CodeNames.txt")
Code=c(letters,"_","-"," ", 0:10)
names(Code)=CodeNames

#Tema de grafico
TemaQR=theme(axis.text=element_blank(),
             legend.position="none",
             axis.title.y=element_blank(),
             axis.ticks=element_blank(),
             panel.grid=element_blank(),
             panel.background=element_blank())

#Habilitar javascript
useShinyjs()

#Desconectar DB en caso de que tenga conexion abierta
try(expr=dbDisconnect(conn=DB), silent=TRUE)

#Abrir conexion a database
DB=dbConnect(MySQL(), user='root', password='ABCD123456', dbname='qrdb', host='127.0.0.1')

#Extraer info de tabla de pasajes
PasajesDF=dbReadTable(conn=DB, name="pasajes")

#Extraer info de tabla de usuario
UsuariosDF=dbReadTable(conn=DB, name="users")

#Desconectar DB en caso de que tenga conexion abierta
try(expr=dbDisconnect(conn=DB), silent=TRUE)

#Tomar nombre de usuario desde fuente del source
User=commandArgs()$User

#Match entre usuario logeado y usuarios en DB de pasajes
PasajeInfo=reactive({PasajesDF[PasajesDF$Usuario %in% User,]})

#Extraer Mail del usuario
MailInfo=reactive({UsuariosDF[match(x=UsuariosDF$ID, table=PasajeInfo()$IDUsuario[1]),]$Email[1]})

#Subset Info de tabla
FormatDF=reactive({PasajeInfo()[,grep(pattern="Origen|Destino|Fecha", x=colnames(PasajeInfo()))]})

#Generar tabla vacia
output$Tabla=renderUI({TableSubmodule.UI(id="TableSubmoduleUI")})

#Agregar datos a la tabla vacia
#Iterar en Filas
lapply(1:(nrow(PasajeInfo())+1), function(x){
  #Iterar en Columnas
  lapply(1:ncol(FormatDF()), function(i){
    #Generar colnames cuando la fila es igual a 1
    if(x==1){
      output[[paste0("Colnames",x,i)]]=renderUI({
        as.character(colnames(FormatDF())[i])
      })
    } else {
      #Popular tabla cuando la fila no es igual a 1. Se usa x-1 pues cuando x es 1 es colnames
      #Y por lo tanto se estaria saltando la primera fila de la tabla original
      output[[paste0("Row",x,"Col",i)]]=renderUI({
        as.character(FormatDF()[(x-1),i])
      })
    }
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
CodeStringReac=reactive({CodeString(text=paste0(PasajeInfo()[as.numeric(input$QRSelect),], collapse="_"), 
                                    code=Code)})
InfoQRReac=reactive({paste0("http://34.74.41.56:3838/DisenoProject?",
                            CodeStringReac())})

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
      dataQR=qrcode_gen(dataString=InfoQRReac(), dataOutput=TRUE, plotQRcode=FALSE)
      dataQR=melt(data=dataQR)
      ggplot(data=dataQR, aes(x=Var1, y=Var2, fill=factor(value))) + geom_raster() +
        scale_fill_manual(values=c("white", "black")) + coord_fixed() + xlab(label=CodeStringReac()) +
        TemaQR
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
  
  #Generar boton para enviar por mail
  output$MailBtn=renderUI({
    actionButton(inputId="EnviarMail", label="Enviar por Mail", icon=icon("envelope"), 
                 style="color: #fff;
                          background-color: #47a447; 
                          border-color: #398439;
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
    dataQR=qrcode_gen(dataString=InfoQRReac(), dataOutput=TRUE, plotQRcode=FALSE)
    dataQR=melt(data=dataQR)
    PlotQR=ggplot(data=dataQR, aes(x=Var1, y=Var2, fill=factor(value))) + geom_raster() +
      scale_fill_manual(values=c("white", "black")) + coord_fixed() + xlab(label=CodeStringReac()) +
      TemaQR
    
    pdf(file, width=10, height=10)
    print(PlotQR)
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
  shinyjs::toggleElement(id="EnviarMail")
  shinyjs::toggleElement(id="Volver")
})


#Enviar mail
observeEvent(input$EnviarMail,{
  
  #Imprimir QR en archivo temporal
  pdf(file=paste0(getwd(),"/",CodeStringReac(),".pdf"), width=10, height=10)
  print(qrcode_gen(dataString=InfoQRReac()))
  dev.off()
  
  #Definir parametros
  Receptor=MailInfo()
  
  #Receptor="PruebaEmailQR@yopmail.com"
  Tema=paste0("\"","Codigo QR pasaje ", paste0(PasajeInfo()[as.numeric(input$QRSelect),c("Origen","Destino")],
                                               collapse=" "), "\"")
  #Tema=paste0("\"","asd"," asdasd","\"")
  Cuerpo='"En el presente email se adjunta el codigo QR necesario para validar su pasaje al momento de abordar el bus.\n
  Usted puede imprimir este pasaje o llevar una copia digital en su telefono celular o tablet y mostrar el codigo al auxiliar."'
  RutaPlotQR=paste0(getwd(),"/",CodeStringReac(),".pdf")
  
  #Ruta Script -- absoluta
  ScriptMail=gsub(pattern="/QR/index", replacement="/Functions/SendMail.R", x=getwd())
  
  #Debug
  # print(Receptor)
  # print(Tema)
  # print(RutaPlotQR)
  
  #Ejecutar envio de email
  system(paste0("Rscript ", ScriptMail,
                " --Receptor ", Receptor,
                " --Tema ", Tema,
                " --Cuerpo ", Cuerpo,
                " --RutaPlotQR ", RutaPlotQR), wait=FALSE#, intern=TRUE
  )
  
  
})

# ggplot(data=dataQR, aes(x=Var1, y=Var2, fill=factor(value))) + geom_raster() +
#   scale_fill_manual(values=c("white", "black")) + coord_fixed() + xlab(label=CodeStringReac) +
#   theme(axis.text=element_blank(),
#         legend.position="none",
#         axis.title.y=element_blank(),
#         axis.ticks=element_blank(),
#         panel.grid=element_blank(),
#         panel.background=element_blank())

