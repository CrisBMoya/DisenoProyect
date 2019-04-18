LoginModule.UI=function(id, label="LoginModuleUI"){
  ns=NS(id)
  
  tags$div(id="LoginUI",{
    fluidPage(
      tags$hr(),
      
      column(3),
      
      
      column(3,
             textInput(inputId="Usuario", label="Usuario", value=""),
             passwordInput(inputId="Clave", label="Clave", value=""),
             splitLayout(cellWidths=c("50%", "50%"),
               actionButton(inputId="LoginBtn", label="Login", icon=icon("sign-in-alt"), 
                            style="color: #fff;
                          background-color: #47a447; 
                          border-color: #398439;
                          display: inline-block;"),
               
               actionButton(inputId="RegBtn", label="Registrar", icon=icon("file-signature"),
                            style="color: #fff;
                   background-color: #428bca;
                   border-color: #357ebd;
                   display: inline-block;")
      ),
      
      textOutput(outputId="Msg")
    ),
    column(3)
  )
  })
}

