## extract compilation criteria from arguments if necessary
## overwrites options above
args <- commandArgs(TRUE)
if(length(args) == 0) {
    stop("No arguments to script")
}
print(args)

## load library
library(rmarkdown)

## compile script
render(args[1], params = list(
    show_ans = args[2],
    show_mark = args[3]
))
