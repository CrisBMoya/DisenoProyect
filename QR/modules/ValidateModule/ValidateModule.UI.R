ValidateModule.UI=function(id, label="ValidateModuleUI"){
  ns=NS(id)
  
  
  tags$div(id="ValidateUI",{
    
    fluidPage(
      #Permitir que ShinyAlert sea utilizado en este UI
      useShinyalert(),
      
      tags$h1("ValidateQR Module"),
      tags$hr(),
      
      fluidRow(
        column(3
        ),
        column(6,
               textOutput(outputId="Tx1"),
               textOutput(outputId="Tx2"),
               textInput(inputId="ManualQRTx", label="Ingrese Codigo:"),
               actionButton(inputId="ManualQRBtn", label="Validar")
               
        ),
        column(3)
        
        
        
      )
    )
  })
}


