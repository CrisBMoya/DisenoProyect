
library(mailR)

##
send.mail(from = "proyectodisenosoftware@gmail.com",
          to = "PruebaEmailQR@yopmail.com",
          subject = "Subject of the email",
          body = "Body of the email",
          smtp = list(host.name = "smtp.gmail.com",
                      user.name = "proyectodisenosoftware", passwd = "B737528A0F0F", ssl = TRUE),
          authenticate = TRUE,
          send = TRUE, attach.files="C:/Users/Tobal/Desktop/ENVIAR.png")
##
?send.mail
