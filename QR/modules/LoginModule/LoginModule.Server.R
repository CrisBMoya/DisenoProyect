#Disconnect
try(expr=dbDisconnect(conn=DB), silent=TRUE)

LoginModule.Server=function(input, output, session,
                            Usuario, Clave){

  #Extraer info de tabla
  UsersDF=ConsultaDB(DBName="qrdb", Element="users")
  UsersDF=S4DF(S4Objetc=NuevoUsuario(ID=UsersDF$ID,
                                     Nombre=UsersDF$Nombre,
                                     Apellido=UsersDF$Apellido,
                                     Usuario=UsersDF$Usuario,
                                     Email=UsersDF$Email,
                                     FechaNacimiento=as.Date(UsersDF$FechaNacimiento),
                                     Password=UsersDF$Password,
                                     TipoUsuario=UsersDF$TipoUsuario
                                       ), 
               ClassName="NuevoUsuario")
  
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
