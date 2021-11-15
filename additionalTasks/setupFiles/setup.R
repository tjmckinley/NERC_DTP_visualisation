library(knitr)
library(xtable)

## set asis chunk for answers
knit_engines$set(asis = function(options) {
    if(options$echo && options$eval) {
        x <- knit_child(text = options$code)
        if(length(options$colour) > 0) {
            x <- paste0("\\color{", options$colour, "}", x, "\n\\color{black}\n")
        } else {
            x <- paste(x)
        }
        x <- paste("\\bss\n", x, "\n\\ess")
        # x <- gsub("\\ess\n\\bss", "", x)
        return(x)
    }
})
