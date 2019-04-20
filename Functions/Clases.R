#Clase NuevoUsuario
NuevoUsuario=setClass(Class="NuevoUsuario", slots=list(
  ID="numeric",
  Nombre="character",
  Apellido="character",
  Usuario="character",
  Email="character",
  FechaNacimiento="Date",
  Password="character",
  TipoUsuario="numeric"
))

#Clase Pasaje
NuevoPasaje=setClass(Class="NuevoPasaje", slots=list(
  ID="numeric",
  Origen="character",
  Destino="character",
  Fecha="Date",
  Usuario="character",
  IDUsuario="numeric",
  Status="numeric"
))