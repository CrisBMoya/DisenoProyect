#Function para codificar
source(file="~/DisenoProyect/Functions/CodeString.R")
source(file="~/DisenoProyect/QR/modules/QRModule/QRTableSubModule.R", local=TRUE)

###################################################################################
#Arreglos previos:                                                                #
#En esta seccion se carga funcion para codificar y el Codigo que esto utiliza.    #
#Tambien el tema de ggplot para el grafico de QR                                  #
###################################################################################

#Cargar codigo
CodeNames=readLines(con="~/DisenoProyect/Otros/CodeNames.txt")
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

###########################################################################
#Conectarse a la DB y extraer datos de interes y luego cerrar la conexion #
###########################################################################

#Extraer info de tabla de pasajes
PasajesDF=ConsultaDB(DBName="qrdb", Element="pasajes")
PasajesDF=S4DF(S4Objetc=NuevoPasaje(ID=PasajesDF$ID, Origen=PasajesDF$Origen, Destino=PasajesDF$Destino, 
                                    Fecha=as.Date(PasajesDF$Fecha),
                                    Usuario=PasajesDF$Usuario, IDUsuario=PasajesDF$IDUsuario, 
                                    Status=PasajesDF$Status), ClassName="NuevoPasaje")

#Extraer info de tabla de usuario
UsuariosDF=ConsultaDB(DBName="qrdb", Element="users")
UsuariosDF=S4DF(S4Objetc=NuevoUsuario(ID=UsuariosDF$ID, Nombre=UsuariosDF$Nombre, 
                                      Apellido=UsuariosDF$Apellido,
                                      Usuario=UsuariosDF$Usuario, 
                                      Email=UsuariosDF$Email, 
                                      FechaNacimiento=as.Date(UsuariosDF$FechaNacimiento),
                                      Password=UsuariosDF$Password, 
                                      TipoUsuario=UsuariosDF$TipoUsuario), ClassName="NuevoUsuario")

###################################################################################
#Generar clases usuario, pasaje y QR en base a datos sacados de la base de datos  #
###################################################################################

#Tomar nombre de usuario desde fuente del source
User=commandArgs()$User

#Match entre usuario logeado y usuarios en DB de pasajes
PasajeInfo=reactive({
  DFPasaje=PasajesDF[PasajesDF$Usuario %in% User,]
  DFPasaje=DFPasaje[order(DFPasaje$Fecha, decreasing=FALSE),]
  })

#Extraer Mail del usuario
MailInfo=reactive({UsuariosDF[match(x=PasajeInfo()$IDUsuario[1], table=UsuariosDF$ID),]$Email[1]})

#Subset Info de tabla
FormatDF=reactive({
  DFPasaje=PasajeInfo()[,grep(pattern="Origen|Destino|Fecha", x=colnames(PasajeInfo()))]
  DFPasaje$Fecha=format(x=DFPasaje$Fecha, "%d %m %Y")
  DFPasaje
})

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
ListaOpciones=as.list(1:nrow(FormatDF()))
names(ListaOpciones)=paste0(FormatDF()$Origen, " ",
                            FormatDF()$Destino, " ",
                            FormatDF()$Fecha)

#Dropdown menu para elegir el pasaje a imprimir
output$QRDropdown=renderUI({
  selectInput(inputId="QRSelect", label="Selecciona tu pasaje:",
              choices=ListaOpciones)
})

#Reactive de informacion en QR en base a seleccion de RadioButtons
##Actual string
CodeStringReac=reactive({CodeString(text=paste0(PasajeInfo()[as.numeric(input$QRSelect),], collapse="_"), 
                                    code=Code)})

InfoQRReac=reactive({paste0("http://35.198.52.105:3838/DisenoProject?",
                            CodeStringReac())})

#Generar datos para graficar
PlotQRData=reactive({
  dataQR=qrcode_gen(dataString=InfoQRReac(), dataOutput=TRUE, plotQRcode=FALSE)
  dataQR=melt(data=dataQR)
})
#Al apretar boton submit:
##Borrar parte de la UI
##Graficar QR
##Generar boton de descarga
observeEvent(input$SbmtBtn, {
  #Eliminar UI
  shinyjs::toggleElement(id="QRSelect")
  shinyjs::toggleElement(id="SbmtBtn")
  shinyjs::toggleElement(id="Tabla")
  shinyjs::toggleElement(id="RevisaTitulo")
  shinyjs::toggleElement(id="QRTitulo")
  
  #Generar UI para plotear el QR y graficar
  output$QRUi=renderUI({
    #Renderizar QR
    output$QRPlot=renderPlot({
      ggplot(data=PlotQRData(), aes(x=Var1, y=Var2, fill=factor(value))) + geom_raster() +
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

#Cambiar nombre de pdf acorde a opcion seleccionada
NumericSelecReactive=reactive({
  paste0(paste0(PasajeInfo()[as.numeric(input$QRSelect),
                             grep(pattern="Origen|Destino|Fecha", x=colnames(PasajeInfo()))], collapse="_"),
         ".pdf")
  })

#Graficar al presionar boton
output$DownloadQR=downloadHandler(
  filename=function(x){
    return(paste0(NumericSelecReactive()))
    },
  content=function(file){
    pdf(file, width=10, height=10)
    print(ggplot(data=PlotQRData(), aes(x=Var1, y=Var2, fill=factor(value))) + geom_raster() +
            scale_fill_manual(values=c("white", "black")) + coord_fixed() + xlab(label=CodeStringReac()) +
            TemaQR)
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
  
  shinyjs::toggleElement(id="RevisaTitulo")
  
  shinyjs::toggleElement(id="QRTitulo")
})


#Enviar mail
observeEvent(input$EnviarMail,{
  #Avisar de mail enviado
  shinyalert(title = "Código GoBus enviado!",
             text="Porfavor revisa tu mail!",
             closeOnEsc = TRUE,
             closeOnClickOutside = FALSE,
             html = FALSE,
             type = "success",
             showConfirmButton = TRUE,
             showCancelButton = FALSE,
             confirmButtonText = "OK",
             confirmButtonCol = "#AEDEF4",
             timer = 0,
             imageUrl = "",
             animation = TRUE)
  
  #Imprimir QR en archivo temporal
  pdf(file=paste0(getwd(),"/",CodeStringReac(),".pdf"), width=10, height=10)
  print(ggplot(data=PlotQRData(), aes(x=Var1, y=Var2, fill=factor(value))) + geom_raster() +
          scale_fill_manual(values=c("white", "black")) + coord_fixed() + xlab(label=CodeStringReac()) +
          TemaQR)
  dev.off()
  
  #Definir parametros
  Receptor=MailInfo()
  
  #Receptor="PruebaEmailQR@yopmail.com"
  Tema=paste0("\"","Codigo QR pasaje ", 
              paste0(PasajeInfo()[as.numeric(input$QRSelect),]$Origen," ",
                     PasajeInfo()[as.numeric(input$QRSelect),]$Destino,
                     collapse=" "), "\"")
  
  
  Cuerpo='"En el presente email se adjunta el codigo QR necesario para validar su pasaje al momento de abordar el bus.\n
  Usted puede imprimir este pasaje o llevar una copia digital en su telefono celular o tablet y mostrar el codigo al auxiliar."'
  RutaPlotQR=paste0(getwd(),"/",CodeStringReac(),".pdf")
  
  #Ruta Script -- absoluta
  ScriptMail=gsub(pattern="/QR/index", replacement="/Functions/SendMail.R", x=getwd())
  
  #Ejecutar envio de email
  system(paste0("Rscript ", ScriptMail,
                " --Receptor ", Receptor,
                " --Tema ", Tema,
                " --Cuerpo ", Cuerpo,
                " --RutaPlotQR ", RutaPlotQR), wait=FALSE#, intern=TRUE
  )
  
  
})
