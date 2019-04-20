#Library
library(qrcode)
library(ggplot2)
library(reshape2)
library(shinyjs)
library(shinyalert)
library(RMySQL)
library(DBI)
library(optparse)
library(mailR)

#UI Index Page
source(file="~/DisenoProyect/QR/modules/LoginModule/LoginModule.UI.R")
source(file="~/DisenoProyect/QR/modules/QRModule/QRModule.UI.R")
source(file="~/DisenoProyect/QR/modules/ValidateModule/ValidateModule.UI.R")


shinyUI(fluidPage(
  #Permitir que ShinyAlert sea utilizado en este UI
  useShinyalert(),
  #Habilitar javascript
  useShinyjs(),
  
  #Login UI -- Landing Page
  LoginModule.UI(id="LoginModuleUI"),
  
  #Pagina QR
  uiOutput(outputId="QRModuleUI"),
  
  #Validacion QR
  uiOutput(outputId="ValidateModuleUI")
  
))
