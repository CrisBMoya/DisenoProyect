#Dummy
library(qrcode)
library(ggplot2)
library(reshape2)


shinyServer(function(input, output, session){
  
  #Hide
  hideTab(inputId="Nav1", target="Tab2")
  
  #Data
  Nombre=reactive({input$Txt1})
  Fecha=reactive({input$Date1})
  
  #When one of the analysis is chosen
  observeEvent(input$SbmtBtn, {
    #Hide landing Tab
    hideTab(inputId="Nav1", target="Tab1")
    #Show first Tab1
    showTab(inputId="Nav1", target="Tab2")
    #Then go to Tab1
    updateTabsetPanel(session, "Nav1", selected = "Tab2")
    
    #Plot
    TxtString=paste0(Nombre(), Fecha())
    output$QRPlot=renderPlot(
      qrcode_gen(dataString=TxtString)
    )
    
  })
})


