
library(RMySQL)
library(DBI)


#Abrir conexion a database
DB = dbConnect(MySQL(), user='root', password='', dbname='test', host='localhost')

#Listar tablas en la DB
dbListTables(DB)

#Listar campos en la tabla
dbListFields(conn=DB, name='infogestion')

#Extraer info de tabla
tempDF=dbReadTable(conn=DB, name="users")
tempDF

#Exportar tabla a la BD
tempDF=rbind(tempDF, data.frame("uid"=3, "username"="Normal", 
                         "password"="123456", 
                         "email"="mail@mail.cl", 
                         "name"="UsuarioTest", 
                         "profile_pic"="notengo"))

dbWriteTable(conn=DB, name="users", value=tempDF, overwrite=TRUE)
