library(shiny)

options(shiny.port = 7775)
shiny::runApp(appDir = "~/DisenoProyect/index", port = getOption("shiny.port"),
       launch.browser = getOption("shiny.launch.browser", interactive()),
       host = getOption("shiny.host", "127.0.0.1"), workerId = "",
       quiet = FALSE, display.mode = c("auto", "normal", "showcase"))


