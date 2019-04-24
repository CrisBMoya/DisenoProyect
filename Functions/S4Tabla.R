#Pasar clase S4 a Tabla
S4DF=function(S4Objetc, ClassName){
  SlotNames=slotNames(x=paste0(ClassName))
  SlotList=vector(mode="list", length=length(SlotNames))
  names(SlotList)=SlotNames
  for(i in SlotNames){
    SlotList[[i]]=slot(object=S4Objetc, name=i)
  }
  return(data.frame(SlotList, stringsAsFactors=FALSE))
}