
GenerarTabla=function(DatosTabla){
  tags$table(id="Table1",{
    
    lapply(1:(nrow(PasajeInfo())+1), function(x){
      tags$tr(id=paste0("Row",x),{
        
        
        lapply(1:ncol(PasajeInfo()), function(i){
          
          if(x==1){
            uiOutput(outputId=paste0("Colnames",x,i), container=tags$th)
          } else {
            uiOutput(outputId=paste0("Row",x,"Col",i), container=tags$td)
          }
        })
      })
    })
  })
}