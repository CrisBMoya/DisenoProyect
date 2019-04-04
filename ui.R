

library(qrcode)
library(ggplot2)
library(reshape2)


shinyUI(fluidPage(
  tags$h1("QR Module"),
  tags$hr(),
  
  fluidRow(
    column(3,
           
           textInput(inputId="Txt1", label="Nombre completo:"),
           dateInput(inputId="Date1", label="Fecha de nacimiento:"),
           actionButton(inputId="SbmtBtn", label="Aceptar")
           
    ),
    column(6,
           uiOutput(outputId="QRUi"),
           uiOutput(outputId="PlotSpace")
    ),
    column(3)
    
    
    
  )
))
