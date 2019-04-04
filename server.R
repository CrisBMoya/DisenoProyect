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
  TxtString=reactive({paste0(Nombre(), Fecha())})
  
  #When one of the analysis is chosen
  observeEvent(input$SbmtBtn, {
    #Delete Nav1
    removeUI(selector="body > div > div > div:nth-child(1)")
    
    #Generate UI for QR Plot
    output$QRUi=renderUI({
      
      output$QRPlot=renderPlot({
        qrcode_gen(dataString=TxtString(), plotQRcode=TRUE)
      })
      
      plotOutput(outputId="QRPlot") 
      
    })
    
    #Generate Download Button
    output$PlotSpace=renderUI({
      downloadButton(outputId="DownloadQR", label="Descargar")
    })
    
  })
  
  output$DownloadQR=downloadHandler(
    filename="QR.pdf",
    content=function(file){
      pdf(file, width=10, height=10)
      print(qrcode_gen(dataString=TxtString()))
      dev.off()
    }
  )
})


