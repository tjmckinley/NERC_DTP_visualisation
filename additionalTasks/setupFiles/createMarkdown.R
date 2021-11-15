## R script to create basic Markdown answer sheet

args <- commandArgs(TRUE)
if(length(args) > 0) {
    stopifnot(length(args) == 1)
    sheetno <- args[1]
} else {
    stop("No arguments")
}

## read in code
tempcode <- readLines(paste0(sheetno, "/", sheetno, ".Rmd"))

## remove header stuff
tempcode <- tempcode[-c(1:grep("# Questions", tempcode))]

## extract intro
intro <- tempcode[1:(grep("benum", tempcode)[1] - 1)]
tempcode <- tempcode[-c(1:(grep("benum", tempcode)[1] - 1))]

## remove outer enumerate call
tempcode <- tempcode[-c(1:(grep("item", tempcode)[1] - 1))]
tempcode <- tempcode[-c(rev(grep("eenum", tempcode))[1]:length(tempcode))]

## group inner enumerate calls
enum_inds <- grep("benum", tempcode)
if(length(enum_inds) > 0) {
    while(length(enum_inds) > 0) {
        i <- enum_inds[1]
        j <- grep("eenum", tempcode)[1]
        temp <- tempcode[(i + 1):(j - 1)]
        item_inds <- grep("item", temp)
        temp <- lapply(item_inds, function(i, tempcode) {
            if(i > 1) {
                temp <- tempcode[-c(1:(i - 1))]
            } else {
                temp <- tempcode
            }
            temp[1:grep("marks]\\*\\*", temp)[1]]
        }, tempcode = temp)
        temp <- lapply(1:length(temp), function(i, x) {
            gsub("\\item", paste0("\\ITEM(", letters[i], "). "), x[[i]])
        }, x = temp)
        tempcode <- c(rev(rev(tempcode[1:i])[-1]), do.call("c", temp), tempcode[j:length(tempcode)][-1])
        enum_inds <- grep("benum", tempcode)
    }
}

## group between item calls
item_inds <- c(grep("item", tempcode), length(tempcode) + 1)
tempcode <- lapply(1:(length(item_inds) - 1), function(i, item_inds, tempcode) {
    tempcode <- tempcode[item_inds[i]:(item_inds[i + 1] - 1)]
    temp <- tempcode[1:min(c(grep("ITEM", tempcode), grep("marks]\\*\\*", tempcode)))]
    tempcode <- tempcode[grep("ITEM", tempcode)]
    tempcode <- gsub("\\\\ITEM", i, tempcode)
    temp <- gsub("\\\\item", paste0(i, ". "), temp)
    c(temp, tempcode)
}, item_inds = item_inds, tempcode = tempcode)

## collapse to vector
tempcode <- do.call("c", tempcode)
tempcode <- tempcode[-grep("ITEM", tempcode)]
tempcode <- c(intro, tempcode)

## read in Markdown
temp <- readLines("setupFiles/templateMarkdown.Rmd")
temp <- c(temp, tempcode)

## write output
writeLines(temp, paste0(sheetno, "/AnswerSheet.Rmd"))

