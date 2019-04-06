
library(RMySQL)
library(DBI)
library(tidyverse)

#Clase NuevoUsuario
NuevoUsuario=setClass(Class="NuevoUsuario", slots=list(
  ID="numeric",
  Nombre="character",
  Apellido="character",
  Usuario="character",
  Email="character",
  FechaNacimiento="Date",
  Password="character"
))

#Pasar clase NuevoUsuario a Tabla
S4DF=function(DF){
  DF=tibble("ID"=DF@ID,
            "Nombre"=DF@Nombre,
            "Apellido"=DF@Apellido,
            "Usuario"=DF@Usuario,
            "Email"=DF@Email,
            "FechaNacimiento"=DF@FechaNacimiento,
            "Password"=DF@Password)
  rownames(DF)=NULL
  return(DF)
}

#Crear usuarios
Temp=S4DF(DF=NuevoUsuario(ID=c(1,2), Nombre=c("Prueba","Prueba2"), Apellido=c("Prueba","Prueba"),
                          Usuario=c("P1","P2"),
                          Email=c("qrdbtest@yopmail.com","otromailrandom@yopmail.com"),
                          FechaNacimiento=c(as.Date("2010/01/01"), as.Date("1992/01/01")),
                          Password=c("ABC123456","BCD123456")))

#Abrir conexion a database
DB=dbConnect(MySQL(), user='root', password='', dbname='qrdb', host='localhost')

#Exportar tabla a la BD
dbWriteTable(conn=DB, name="users", value=Temp, overwrite=TRUE)

#Desconectar
dbDisconnect(conn=DB)

####################
####################

#Abrir conexion a database
DB=dbConnect(MySQL(), user='root', password='', dbname='qrdb', host='localhost')

#Listar tablas en la DB
dbListTables(DB)

#Listar campos en la tabla
dbListFields(conn=DB, name='users')

#Extraer info de tabla
UsersDF=dbReadTable(conn=DB, name="users")

#Exportar tabla a la BD
dbWriteTable(conn=DB, name="users", value=tempDF, overwrite=TRUE)



