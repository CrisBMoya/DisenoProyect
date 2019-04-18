Tabla.UI=function(id, label="TablaUI"){
  ns=NS(id)
  
  tags$table(id="Table1",{
    
    lapply(1:(nrow(ChoicesTemp)+1), function(x){
      tags$tr(id=paste0("Row",x),{
        
        
        lapply(1:ncol(ChoicesTemp), function(i){
          
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