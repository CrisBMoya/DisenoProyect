QRModule.UI=function(id, label="QRModuleUI"){
  ns=NS(id)

  tags$div(id="QRUI",{
    fluidPage(
      tags$h1("QR Module"),
      tags$hr(),
      
      fluidRow(
        column(3,
               #Display de Info
               uiOutput(outputId="QRList"),
               
               #Generar QR
               actionButton(inputId="SbmtBtn", label="Aceptar")
               
        ),
        column(6,
               uiOutput(outputId="QRUi"),
               uiOutput(outputId="PlotSpace"),
               uiOutput(outputId="VolverSpace"),
               textOutput(outputId="Debug")
        ),
        column(3)
        
        
        
      )
    )
  })
}

