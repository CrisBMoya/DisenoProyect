#Recrear DB para implementacion en nuevos ambientes
library(RMySQL)
library(DBI)
library(tidyverse)
library(openxlsx)

#Invocar Cases
source(file="~/DisenoProyect/Functions/Clases.R")


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
Usuarios=openxlsx::read.xlsx(xlsxFile="~/DisenoProyect/Otros/DB.xlsx", sheet=1, detectDates=TRUE)
Usuarios=S4DF(S4Objetc=NuevoUsuario(ID=Usuarios$ID,
                           Nombre=Usuarios$Nombre,
                           Apellido=Usuarios$Apellido,
                           Usuario=Usuarios$Usuario, 
                           Email=Usuarios$Email,
                           FechaNacimiento=as.Date(Usuarios$FechaNaciemiento),
                           Password=as.character(Usuarios$Password),
                           TipoUsuario=Usuarios$TipoUsuario), ClassName="NuevoUsuario")

#Crear Pasajes
Pasajes=openxlsx::read.xlsx(xlsxFile="~/DisenoProyect/Otros/DB.xlsx", sheet=2, detectDates=TRUE)
Pasajes=S4DF(S4Objetc=NuevoPasaje(ID=Pasajes$ID,
                          Origen=Pasajes$Origen,
                          Destino=Pasajes$Destino,
                          Fecha=as.Date(Pasajes$Fecha),
                          Usuario=Pasajes$Usuario,
                          IDUsuario=Pasajes$IDUsuario,
                          Status=Pasajes$Status), ClassName="NuevoPasaje")

#Abrir conexion a database
DB=dbConnect(MySQL(), user='root', password='ABCD123456', host='127.0.0.1')

#Recrear DB - habra un error si ya existe, el cual sera ignorado
try(expr=dbSendQuery(conn=DB, statement="CREATE DATABASE qrdb;"), silent=TRUE)

#Desconectar
dbDisconnect(conn=DB)

#Abrir conexion a database considerando la nueva DB
DB=dbConnect(MySQL(), user='root', password='ABCD123456', dbname='qrdb', host='127.0.0.1')

#Exportar tabla a la BD
dbWriteTable(conn=DB, name="pasajes", value=Pasajes, overwrite=TRUE)
dbWriteTable(conn=DB, name="users", value=Usuarios, overwrite=TRUE)

#Desconectar
dbDisconnect(conn=DB)
