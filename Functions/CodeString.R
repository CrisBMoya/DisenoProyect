CodeString <- function(text, code){
	text=tolower(text)
    textSplit <- unlist(strsplit(text, ""))
    codeAsText <- code[code %in% textSplit]
    paste(names(codeAsText[match(textSplit, codeAsText)]), collapse = "")
}  
