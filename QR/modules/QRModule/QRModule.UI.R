#Modulo UI de QR
QRModule.UI=function(id, label="QRModuleUI"){
  ns=NS(id)
  
  
  
  tags$div(id="QRUI",{
    fluidPage(
      #Incluir CSS
      includeCSS(path="~/DisenoProyect/Functions/TableCSS/TableCSS.css"),
      
      tags$h1("Generador de código GoBus"),
      tags$hr(),
      
      fluidRow(
        column(6,
               
               #Titulo Tabla
               tags$b(id="RevisaTitulo",
                      "Revisa tus pasajes:"),
               
               #Titulo QR
               tags$b(id="QRTitulo", style="display:none;",
                      "Descarga o imprime este QR:"),
               
               #UI Tabla
               uiOutput(outputId="Tabla"),
               
               #Display de Info
               uiOutput(outputId="QRList"),
               
               #Lista desplegable
               uiOutput(outputId="QRDropdown"),
               
               #Generar QR
               actionButton(inputId="SbmtBtn", label="Generar QR", icon=icon("arrow-right"), 
                            style="color: #fff;
                          background-color: #47a447; 
                          border-color: #398439;
                          display: inline-block;"),
               verticalLayout(
                 #Lugar para graficar QR
                 uiOutput(outputId="QRUi"),
                 
                 splitLayout(
                   #Graficar QR
                   uiOutput(outputId="DownloadBtnUI"),

                   #Boton enviar mail
                   uiOutput(outputId="MailBtn"),

                   #Boton regresar
                   uiOutput(outputId="VolverBtnUI")
                 )
               )
        ),
        column(3),
        column(3)
      )
    )
  })
}
100-50

