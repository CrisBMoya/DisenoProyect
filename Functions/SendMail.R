#!/usr/bin/env Rscript
#Load parser library, install if not present
if (!requireNamespace("optparse", quietly = TRUE)){
  install.packages("optparse")
}
library(optparse)
library(mailR)

#Arguments
optionList=list(
  make_option(c("--Receptor"), type="character", default=NULL, 
              metavar="character"),
  make_option(c("--Tema"), type="character", default=NULL, 
              metavar="character"),
  make_option(c("--Cuerpo"), type="character", default=NULL, 
              metavar="character"),
  make_option(c("--RutaPlotQR"), type="character", default=NULL, 
            metavar="character")
)

#Parse Arguments
ParserArg=OptionParser(option_list=optionList)
ArgumentsList=parse_args(ParserArg)

Receptor=ArgumentsList$Receptor
Tema=ArgumentsList$Tema
Cuerpo=ArgumentsList$Cuerpo
RutaPlotQR=ArgumentsList$RutaPlotQR

send.mail(from = "proyectodisenosoftware@gmail.com",
            to = Receptor,
            subject = Tema,
            body = Cuerpo,
            smtp = list(host.name = "smtp.gmail.com",
                        user.name = "proyectodisenosoftware", 
                        passwd = "B737528A0F0F", ssl = TRUE),
            authenticate = TRUE,
            send = TRUE, attach.files=RutaPlotQR)
