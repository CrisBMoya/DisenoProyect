source(file="~/DisenoProyect/Functions/DecodeString.R")

#Habilitar javascript
useShinyjs()

#Cargar codigo
CodeNames=readLines(con="~/DisenoProyect/CodeNames.txt")
Code=c(letters,"_","-", 0:9)
names(Code)=CodeNames

#Si se ingreso a la pagina via link desde QR existiran datos en la URL
if(nchar(commandArgs()$Rest)>10){
  #Tomar nombre de usuario desde fuente del source
  DataURL=commandArgs()$Rest
  
  #Tomar informacion de URL y decodificar
  QRTextManualReac=reactive({
    TxtQR=DataURL
    #Remover simbolo "?"
    TxtQR=gsub(pattern="\\?", replacement="", x=TxtQR)
    #Decodificar informacion de campo de texto
    TxtQR=DecodeString(text=TxtQR, code=Code)
    
  })
  
  #Hacer match con base de datos -- ESTE CODIGO SE REPITE CON OTRO MAS ABAJO
  
  #Desconectar DB en caso de que tenga conexion abierta
  try(expr=dbDisconnect(conn=DB), silent=TRUE)
  
  #Abrir conexion a database
  DB=dbConnect(MySQL(), user='root', password='ABCD123456', dbname='qrdb', host='127.0.0.1')
  
  #Extraer info de tabla de pasajes
  PasajesDF=dbReadTable(conn=DB, name="pasajes")
  
  
  #Extraer informacion de la string
  InfoPasaje=strsplit(x=QRTextManualReac(), split="_")
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
      observeEvent(input$PasajeCorrecto, {
        #Generar query de update
        QuerySQL=paste0("UPDATE pasajes SET Status='1' WHERE ID=", PasajeMatch$ID)
        
        #Enviar update a la base de datos
        dbSendQuery(conn=DB, statement=QuerySQL)
        
        #Desconectar DB en caso de que tenga conexion abierta
        try(expr=dbDisconnect(conn=DB), silent=TRUE)
        
      })
      
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
  ###################EL CODIGO DE ABAJO SE REPITE
  
  #Si la url viene sin datos, utilizar informacion rellenada en el campo de texto
} else if(nchar(commandArgs()$Rest)<10){
  #Tomar informacion de campo de texto
  QRTextManualReac=reactive({
    TxtQR=input$ManualQRTx
    #Remover simbolo
    TxtQR=gsub(pattern="\\?", replacement="", x=TxtQR)
    #Decodificar informacion de campo de texto
    TxtQR=DecodeString(text=TxtQR, code=Code)
    
  })
  
  #Comparar datos al apretar boton
  observeEvent(input$ManualQRBtn,{
    
    #Desconectar DB en caso de que tenga conexion abierta
    try(expr=dbDisconnect(conn=DB), silent=TRUE)
    
    #Abrir conexion a database
    DB=dbConnect(MySQL(), user='root', password='ABCD123456', dbname='qrdb', host='127.0.0.1')
    
    #Extraer info de tabla de pasajes
    PasajesDF=dbReadTable(conn=DB, name="pasajes")
    
    
    #Extraer informacion de la string
    InfoPasaje=strsplit(x=QRTextManualReac(), split="_")
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
        observeEvent(input$PasajeCorrecto, {
          #Generar query de update
          QuerySQL=paste0("UPDATE pasajes SET Status='1' WHERE ID=", PasajeMatch$ID)
          
          #Enviar update a la base de datos
          dbSendQuery(conn=DB, statement=QuerySQL)
          
          #Desconectar DB en caso de que tenga conexion abierta
          try(expr=dbDisconnect(conn=DB), silent=TRUE)
          
        })
        
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
    
  })
  
}
#



