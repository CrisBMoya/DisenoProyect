#Submodulo para generar tabla
TableSubmodule.UI=function(id, label="TableSubmoduleUI"){
  ns=NS(id)
  
  #Div Tabla
  tags$table(id="Table1",{
    
    lapply(1:(nrow(FormatDF())+1), function(x){
      #Generar filas
      tags$tr(id=paste0("Row",x),{
        
        lapply(1:ncol(FormatDF()), function(i){
          
          if(x==1){
            #Generar espacio de nombres de columnas en la primera fila
            uiOutput(outputId=paste0("Colnames",x,i), container=tags$th)
          } else {
            #Generar resto de filas normales
            uiOutput(outputId=paste0("Row",x,"Col",i), container=tags$td)
          }
        })
      })
    })
  })
  
}