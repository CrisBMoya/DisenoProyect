ValidateModule.UI=function(id, label="ValidateModuleUI"){
  ns=NS(id)
  
  
  tags$div(id="ValidateUI",{
    fluidPage(
      tags$h1("ValidateQR Module"),
      tags$hr(),
      
      fluidRow(
        column(3,
               textOutput(outputId="Tx1"),
               textOutput(outputId="Tx2")
        ),
        column(6
        ),
        column(3)
        
        
        
      )
    )
  })
}

