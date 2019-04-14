DecodeString <- function(text, code) {
    textSplit <- unlist(strsplit(text, ""))
    textAsCode <- code[names(code) %in% textSplit]
    paste(textAsCode[match(textSplit, names(textAsCode))], collapse = "")
}