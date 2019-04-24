#Library
library(qrcode)
library(ggplot2)
library(reshape2)
library(shinyjs)
library(shinyalert)
library(RMySQL)
library(DBI)


#QR Server Index Page
source(file="~/DisenoProyect/QR/modules/LoginModule/LoginModule.Server.R")

#Invocar clases
source(file="~/DisenoProyect/Functions/Clases.R")

#S4 a tabla
source(file="~/DisenoProyect/Functions/S4Tabla.R")

#Extraer info DB
source(file="~/DisenoProyect/Functions/ConsultasDB.R")

#Server
shinyServer(function(input, output, session){
  
  #Desactivar boton de registro
  shinyjs::disable(id="RegBtn")
  
  #Informacion reactiva
  UserReactive=reactive({input$Usuario})
  ClaveReactive=reactive({input$Clave})
  
  #Observar Boton de Login
  observeEvent(input$LoginBtn, {
    ServerResponse=callModule(module=LoginModule.Server, id="", 
                              Usuario=UserReactive(), Clave=ClaveReactive())
    
    #Si la clave ingresada es correcta se remueve la UI de login y se ingresa la de la pagina siguiente
    if(unlist(ServerResponse)=="1"){
      #Popup de login exitoso
      shinyalert(
        inputId="ClaveOKNormal",
        title = "Correcto:",
        text = "Login exitoso!",
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
        animation = TRUE)
      
    } else if(unlist(ServerResponse)=="0"){
      #Si la clave es incorrecta enviar error
      shinyalert(
        inputId="ErrorClave",
        title = "Error:",
        text = "Clave o usuario incorrectos!",
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
    } else if(unlist(ServerResponse)=="2"){
      
      #Clave correcta y administrador
      #Popup de login exitoso
      shinyalert(
        inputId="ClaveOKAdmin",
        title = "Correcto:",
        text = "Login exitoso! - Adm",
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
      
    }
  })
  
  #Si el login es exitoso se lleva al usuario al modulo de QR
  observeEvent(input$ClaveOKNormal,{
    
    #Remover UI de Login en base al selector del div
    removeUI(selector="#LoginUI")
    
    #Pasa nombre de usuario como argumento
    commandArgs=function(...){
      list("User"=UserReactive(),
           "Rest"=session$clientData$url_search)
    }
    
    #Generar UI de la pagina siguiente
    source(file="~/DisenoProyect/QR/modules/QRModule/QRModule.Server.R", local=TRUE)
    output$QRModuleUI=renderUI({QRModule.UI(id="QRModuleUI")})
    
  })
  
  #Si el login es exitoso se lleva al usuario al modulo de QR
  observeEvent(input$ClaveOKAdmin,{
    
    #Remover UI de Login en base al selector del div
    removeUI(selector="#LoginUI")
    
    #Pasa nombre de usuario como argumento
    commandArgs=function(...){
      list("User"=UserReactive(),
           "Rest"=session$clientData$url_search)
    }
    
    #Generar UI de la pagina siguiente
    source(file="~/DisenoProyect/QR/modules/ValidateModule/ValidateModule.Server.R", local=TRUE)
    output$ValidateModuleUI=renderUI({ValidateModule.UI(id="ValidateModuleUI")})
    
  })
  
})