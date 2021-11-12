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
render(args[1], output_format = args[2], params = list(handout = args[3]))
