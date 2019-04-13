library(RMySQL)
library(DBI)
library(shinyalert)

#Disconnect
try(expr=dbDisconnect(conn=DB), silent=TRUE)

LoginModule.Server=function(input, output, session,
                            Usuario, Clave){
  
  #Disconnect
  try(expr=dbDisconnect(conn=DB), silent=TRUE)
  
  #Abrir conexion a database
  DB=dbConnect(MySQL(), user='root', password='ABCD123456', dbname='qrdb', host='127.0.0.1')
  
  #Extraer info de tabla
  UsersDF=dbReadTable(conn=DB, name="users")
  
  #Extraer Pass
  PassDB=UsersDF[match(x=Usuario, table=UsersDF$Usuario),]$Password
  
  #Disconnect
  try(expr=dbDisconnect(conn=DB), silent=TRUE)
  
  #Verificar
  if(is.na(PassDB)){
    
    #Error en autenticacion
    list("0")
  } else {
    if(Clave==PassDB){
      
      #Detectar si es perfil administrador o usuario normal
      TipoUsuario=UsersDF[match(x=Usuario, table=UsersDF$Usuario),]$TipoUsuario
      if(TipoUsuario=="1"){
        #Ir a pagina validadora
        list("2")
        
      }else if(TipoUsuario=="0"){
        #Ir a pagina qr
        list("1")
      }
    } else {
      
      #Error en autenticacion
      list("0")
    }
  }
  
}
