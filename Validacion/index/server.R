library(RMySQL)
library(DBI)

#Disconnect
try(expr=dbDisconnect(conn=DB), silent=TRUE)

shinyServer(function(input, output, session){
  
  #Disconnect
  try(expr=dbDisconnect(conn=DB), silent=TRUE)
  
  #Abrir conexion a database
  #DB=dbConnect(MySQL(), user='root', password='', dbname='qrdbventa', host='localhost')
  
  #Extraer info de tabla de Ventas
  #VentasDF=dbReadTable(conn=DB, name="ventas")
  
  output$URLText=renderText({
    session$clientData$url_search
    })
  
})
