

library(qrcode)
library(ggplot2)
library(reshape2)


shinyUI(fluidPage(
  
  hr(),
  fluidRow(
    column(1),
    column(10,
           
           navbarPage(title="Page", id="Nav1",
                      tabPanel(title="Datos", value="Tab1",
                               textInput(inputId="Txt1", label="Nombre completo:"),
                               dateInput(inputId="Date1", label="Fecha de nacimiento:"),
                               actionButton(inputId="SbmtBtn", label="Aceptar")
                      ),
                      tabPanel(title="QR", value="Tab2",
                               plotOutput(outputId="QRPlot")
                      )
           )
    )
  )
))
