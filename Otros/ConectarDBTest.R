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
  Password="character",
  TipoUsuario="numeric"
))

#Clase Pasaje
NuevoPasaje=setClass(Class="NuevoPasaje", slots=list(
  ID="numeric",
  Origen="character",
  Destino="character",
  Fecha="Date",
  Usuario="character",
  IDUsuario="numeric"
))

#Pasar clase S4 a Tabla
S4DF=function(S4Objetc, ClassName){
  SlotNames=slotNames(x=paste0(ClassName))
  SlotList=vector(mode="list", length=length(SlotNames))
  names(SlotList)=SlotNames
  for(i in SlotNames){
    SlotList[[i]]=slot(object=S4Objetc, name=i)
  }
  return(as.data.frame(SlotList))
}

#Crear usuarios
Usuarios=S4DF(S4Objetc=NuevoUsuario(ID=c(1,2), 
                                    Nombre=c("Prueba","Prueba2"), 
                                    Apellido=c("Prueba","Prueba"),
                                    Usuario=c("P1","P2"),
                                    Email=c("qrdbtest@yopmail.com","otromailrandom@yopmail.com"),
                                    FechaNacimiento=c(as.Date("2010/01/01"), as.Date("1992/01/01")),
                                    Password=c("ABC123456","BCD123456"), 
                                    TipoUsuario=c(0,1)),
              ClassName="NuevoUsuario")

#Crear Pasajes
Pasajes=S4DF(S4Objetc=NuevoPasaje(ID=c(1:10), 
                                  Origen=c(rep(x="Stgo", 10)), 
                                  Destino=c("Conc","Vin","Vin","Ser","Ser","Iqu","Conc","Conc","Iqu","Vin"),
                                  Fecha=as.Date(c(rep(Sys.Date(), 10))), 
                                  Usuario=c("P1","P2","P1","P2","P1","P1","P1","P1","P1","P1"), 
                                  IDUsuario=c(1,2,1,2,1,1,1,1,1,1)), 
             ClassName="NuevoPasaje")

#########








#Abrir conexion a database
DB=dbConnect(MySQL(), user='root', password='ABCD123456', dbname='qrdb', host='127.0.0.1')

#Exportar tabla a la BD
dbWriteTable(conn=DB, name="pasajes", value=Pasajes, overwrite=TRUE)

#Desconectar
dbDisconnect(conn=DB)

####################
####################

#Abrir conexion a database
DB=dbConnect(MySQL(), user='root', password='ABCD123456', dbname='qrdb', host='127.0.0.1')

#Listar tablas en la DB
dbListTables(DB)

#Listar campos en la tabla
dbListFields(conn=DB, name='users')

#Extraer info de tabla
UsersDF=dbReadTable(conn=DB, name="users")

#Exportar tabla a la BD
dbWriteTable(conn=DB, name="users", value=tempDF, overwrite=TRUE)



