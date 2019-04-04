#Server Index Page
source(file="~/DisenoProyect/modules/LoginModule/LoginModule.Server.R")
source(file="~/DisenoProyect/modules/OtherModule/OtherPageUI.R")

shinyServer(function(input, output, session){
  
  #Informacion reactiva
  UserReactive=reactive({input$Usuario})
  ClaveReactive=reactive({input$Clave})
  
  #Observar Boton de Login
  observeEvent(input$LoginBtn, {
    ServerResponse=callModule(module=LoginModule.Server, id="", Usuario=UserReactive(), Clave=ClaveReactive())
    
    #Si la clave ingresada es correcta se remueve la UI de login y se ingresa la de la pagina siguiente
    if(unlist(ServerResponse)=="OK"){
      
      #Remover UI de Login en base al selector del div
      removeUI(selector="#LoginUI")
      
      #Generar UI de la pagina siguiente
      output$Other=renderUI({OtherPage.UI(id="OtherPageUI")})
      
    }else{
      
      #Si la clave es incorrecta enviar error
      output$Msg=renderText({unlist(ServerResponse)})
      
    }
  })
  
  
})