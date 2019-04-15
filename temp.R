library(shiny)
library(shinyjs)

source(file="~/DisenoProyect/tempui.R")

ChoicesTemp=PasajesDF[PasajesDF$Usuario=="P1",]

#Habilitar javascript
useShinyjs()

# Define the UI
ui=fluidPage(
  
  #Incluir CSS
  includeCSS(path="~/DisenoProyect/Functions/TableCSS/TableCSS.css"),
  
  #Boton generar tabla
  actionButton(inputId="Btn", label="btn"),
  
  #UI Tabla
  uiOutput(outputId="TempUI")

)


# Define the server code
server <- function(input, output) {
  
  observeEvent(input$Btn,{
    
    #Generar tabla con CSS
    output$TempUI=renderUI({Temp.UI(id="tempUI")})
    
    
    
    #Iterar en Filas
    lapply(1:nrow(ChoicesTemp), function(x){
      #Iterar en Columnas
      lapply(1:ncol(ChoicesTemp), function(i){
        
        #Generar colnames
        if(x==1){
          output[[paste0("Colnames",x,i)]]=renderUI({
            as.character(colnames(ChoicesTemp)[i])
          })
        }
        
        #Si es la primera columna generar un boton
        if(i==1){
          output[[paste0("Row",x,"Col",i)]]=renderUI({
            actionButton(inputId=paste0("Btn",x,i), label="Generar QR")
            
          })
          
          #Si no es la primera columna poner informacion
        } else {
          output[[paste0("Row",x,"Col",i)]]=renderUI({
            as.character(ChoicesTemp[x,i])
          })
        }
        
      })
      
    })
  })
}




# Return a Shiny app object
shinyApp(ui = ui, server = server)
