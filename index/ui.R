#UI Index Page
source(file="~/DisenoProyect/modules/LoginModule/LoginModule.UI.R")

shinyUI(fluidPage(
  
  #Login UI -- Landing Page
  LoginModule.UI(id="LoginModuleUI"),
  
  #Pagina QR
  uiOutput(outputId="QRModuleUI"),
  
  #Siguiente pagina UI
  uiOutput(outputId="Other")
  
))