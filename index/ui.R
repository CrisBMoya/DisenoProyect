#UI Index Page
source(file="~/DisenoProyect/modules/LoginModule/LoginModule.UI.R")

shinyUI(fluidPage(
  
  #Login UI -- Landing Page
  LoginModule.UI(id="LoginModuleUI"),
  
  #Siguiente pagina UI
  uiOutput(outputId="Other")
  
))