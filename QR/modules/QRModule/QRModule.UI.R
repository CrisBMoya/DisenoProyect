

QRModule.UI=function(id, label="QRModuleUI"){
  ns=NS(id)
  
  
  
  tags$div(id="QRUI",{
    fluidPage(
      #Incluir CSS
      includeCSS(path="~/DisenoProyect/Functions/TableCSS/TableCSS.css"),
      
      tags$h1("QR Module"),
      tags$hr(),
      
      fluidRow(
        column(3,
               
               #UI Tabla
               uiOutput(outputId="Tabla"),
               
               #Display de Info
               uiOutput(outputId="QRList"),
               
               #Generar QR
               actionButton(inputId="SbmtBtn", label="Aceptar")
               
        ),
        column(6,
               textOutput(outputId="ALL"),
               uiOutput(outputId="QRUi"),
               uiOutput(outputId="PlotSpace"),
               uiOutput(outputId="VolverSpace")
        ),
        column(3)
      )
    )
  })
}

