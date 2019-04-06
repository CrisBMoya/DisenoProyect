LoginModule.UI=function(id, label="LoginModuleUI"){
  ns=NS(id)
  
  tags$div(id="LoginUI",{
    fluidPage(
      tags$hr(),
      
      column(3),
      
      
      column(6,
             textInput(inputId="Usuario", label="Usuario", value=""),
             passwordInput(inputId="Clave", label="Clave", value=""),
             actionButton(inputId="LoginBtn", label="Login"),
             textOutput(outputId="Msg")
      ),
      column(3)
    )
  })
}

