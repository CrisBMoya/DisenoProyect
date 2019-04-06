#UI Index Page
source(file="~/DisenoProyect/QR/modules/LoginModule/LoginModule.UI.R")
source(file="~/DisenoProyect/QR/modules/QRModule/QRModule.UI.R")

shinyUI(fluidPage(
  
  #Login UI -- Landing Page
  LoginModule.UI(id="LoginModuleUI"),
  
  #Pagina QR
  uiOutput(outputId="QRModuleUI")
  
))