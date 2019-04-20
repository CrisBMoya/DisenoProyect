#Modulo UI de QR
QRModule.UI=function(id, label="QRModuleUI"){
  ns=NS(id)
  
  
  
  tags$div(id="QRUI",{
    fluidPage(
      #Incluir CSS
      includeCSS(path="~/DisenoProyect/Functions/TableCSS/TableCSS.css"),
      
      tags$h1("Modulo QR"),
      tags$hr(),
      
      fluidRow(
        column(3),
        column(6,
               
               #UI Tabla
               uiOutput(outputId="Tabla"),
               
               #Display de Info
               uiOutput(outputId="QRList"),
               
               #Lista desplegable
               uiOutput(outputId="QRDropdown"),
               
               #Generar QR
               actionButton(inputId="SbmtBtn", label="Aceptar", icon=icon("arrow-right"), 
                            style="color: #fff;
                          background-color: #47a447; 
                          border-color: #398439;
                          display: inline-block;"),
               
               #Lugar para graficar QR
               uiOutput(outputId="QRUi")
               
               
        ),
        column(3,
               #Graficar QR
               uiOutput(outputId="DownloadBtnUI"),
               
               #Separador
               tags$div(style="padding:10px"),
               
               #Boton enviar mail
               uiOutput(outputId="MailBtn"),
               
               #Separador
               tags$div(style="padding:10px"),
               
               #Boton regresar
               uiOutput(outputId="VolverBtnUI")
        )
      )
    )
  })
}

