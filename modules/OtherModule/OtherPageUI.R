OtherPage.UI=function(id, label="OtherPageUI"){
  ns=NS(id)
  
  tags$div(id="OtherUIDiv",{
    fluidPage(
      tags$hr(),
      
      column(3),
      
      
      column(6,
            textInput(inputId="Some", label="Some Input", value="Test")
      ),
      column(3)
    )
  })
}

