library(RMySQL)
library(DBI)
#Disconnect
try(expr=dbDisconnect(conn=DB), silent=TRUE)

LoginModule.Server=function(input, output, session,
                            Usuario, Clave){
  
  #Disconnect
  try(expr=dbDisconnect(conn=DB), silent=TRUE)
  
  #Abrir conexion a database
  DB=dbConnect(MySQL(), user='root', password='', dbname='qrdb', host='localhost')
  #Extraer info de tabla
  UsersDF=dbReadTable(conn=DB, name="users")
  
  #Extraer Pass
  PassDB=UsersDF[match(x=Usuario, UsersDF$Usuario),]$Password
  
  #Disconnect
  try(expr=dbDisconnect(conn=DB), silent=TRUE)
  
  #Verificar
  if(is.na(PassDB)){
    list("Usuario o Password incorrectos!")
  } else {
    if(Clave==PassDB){
      list("OK")
    } else {
      list("Usuario o Password incorrectos!")
    }
  }
  
}
