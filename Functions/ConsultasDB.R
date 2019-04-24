#Function para abrir conexion, consultar y cerrar conexion
ConsultaDB=function(DBName, Element){
  
  #Desconectar DB en caso de que tenga conexion abierta
  try(expr=dbDisconnect(conn=DB), silent=TRUE)
  
  #Abrir conexion a database
  DB=dbConnect(MySQL(), user='root', password='ABCD123456', dbname=DBName, host='127.0.0.1')
  
  #Extraer info de tabla de pasajes
  TempDB=dbReadTable(conn=DB, name=Element)
  
  #Desconectar DB en caso de que tenga conexion abierta
  try(expr=dbDisconnect(conn=DB), silent=TRUE)
  
  #Devolver respuesta
  return(TempDB)
}
