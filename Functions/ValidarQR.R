ValidarQR=function(TxtQR){
  #Desconectar DB en caso de que tenga conexion abierta
  try(expr=dbDisconnect(conn=DB), silent=TRUE)
  
  #Abrir conexion a database
  DB=dbConnect(MySQL(), user='root', password='ABCD123456', dbname='qrdb', host='127.0.0.1')
  
  #Extraer info de tabla de pasajes
  PasajesDF=dbReadTable(conn=DB, name="pasajes")  
  
  #Extraer informacion de la string
  InfoPasaje=strsplit(x=TxtQR, split="_")
  InfoPasaje=unlist(lapply(X=InfoPasaje, FUN=function(x){
    x[!x==""]
  }))
  
  #Largo de la informacion del pasaje no es la correcta
  if(length(InfoPasaje)!=7){
    
    shinyalert(
      title = "Error:",
      text = "Revise los datos!",
      closeOnEsc = TRUE,
      closeOnClickOutside = FALSE,
      html = FALSE,
      type = "error",
      showConfirmButton = TRUE,
      showCancelButton = FALSE,
      confirmButtonText = "OK",
      confirmButtonCol = "#AEDEF4",
      timer = 0,
      imageUrl = "",
      animation = TRUE
    )
    
    #Desconectar DB en caso de que tenga conexion abierta
    try(expr=dbDisconnect(conn=DB), silent=TRUE)
    
  } else {
    
    #Match contra la base de datos
    PasajeMatch=PasajesDF[match(x=InfoPasaje[1], table=PasajesDF$ID),]
    
    #Si el pasaje no ha sido usado, cambiar valor de estatus a 1
    if(nrow(PasajeMatch)!=0 & PasajeMatch$Status==0){
      #Popup de validacion exitosa
      shinyalert(
        inputId="PasajeCorrecto",
        title = "Pasaje Valido!",
        closeOnEsc = TRUE,
        closeOnClickOutside = FALSE,
        html = FALSE,
        type = "success",
        showConfirmButton = TRUE,
        showCancelButton = FALSE,
        confirmButtonText = "OK",
        confirmButtonCol = "#AEDEF4",
        timer = 0,
        imageUrl = "",
        animation=TRUE)
      
      #Marcar el pasaje como usado
      #Generar query de update
      QuerySQL=paste0("UPDATE pasajes SET Status='1' WHERE ID=", PasajeMatch$ID)
      
      #Enviar update a la base de datos
      dbSendQuery(conn=DB, statement=QuerySQL)
      
      #Desconectar DB en caso de que tenga conexion abierta
      try(expr=dbDisconnect(conn=DB), silent=TRUE)
      
      #Si el pasaje ha sido usado, enviar error
    } else if(nrow(PasajeMatch)!=0 & PasajeMatch$Status==1){
      #Si el pasaje tiene Status=1 enviar mensaje de error
      shinyalert(
        title = "Error:",
        text = "El pasaje ya fue utilizado!",
        closeOnEsc = TRUE,
        closeOnClickOutside = FALSE,
        html = FALSE,
        type = "error",
        showConfirmButton = TRUE,
        showCancelButton = FALSE,
        confirmButtonText = "OK",
        confirmButtonCol = "#AEDEF4",
        timer = 0,
        imageUrl = "",
        animation = TRUE)
      
      #Desconectar DB en caso de que tenga conexion abierta
      try(expr=dbDisconnect(conn=DB), silent=TRUE)
      
    }
  }
}