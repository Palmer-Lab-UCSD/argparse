\name{argument_parser}
\alias{argument_parser}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
argument_parser(..., description = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
  \item{description}{
%%     ~~Describe \code{description} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (..., description = NULL) 
{
    arg_defs <- list(...)
    if (file.exists("VERSION")) {
        fid <- fopen("VERSION", "r")
        version = readLines(fid)
        close(fid)
    }
    else {
        version = NULL
    }
    parse_arguments <- function(args) {
        parsed_input <- parse_r_lang_args(args)
        args <- parsed_input[["args"]]
        program_name <- parsed_input[["program_name"]]
        rm(parsed_input)
        if (length(args) == 1 && is.na(args)) 
            stop("Missing R language arguments")
        if (is.na(program_name)) 
            stop("R script missing from command line inputs")
        if ("--help" \%in\% args) {
            if (is.null(version)) 
                cat(sprintf("\n\%s\n\n", program_name))
            else cat(sprintf("\n\%s, Version \%s\n\n", program_name, 
                version))
            if (!is.null(description)) 
                cat(sprintf("\%s\n\n", description))
            cat(sprintf("\%s\n", "Arguments"))
            for (a in names(arg_defs)) cat(sprintf("\%s\t\%s\n", 
                a, arg_defs[[a]]$help))
            return(NULL)
        }
        arg_out <- list()
        for (arg_key in names(arg_defs)) {
            if (arg_defs[[arg_key]]$required && !(arg_key \%in\% 
                args)) 
                stop(sprintf("arg, \%s, must be specified.", arg_key))
            argout_key <- rm_key_prefix(arg_key)
            if (!arg_defs[[arg_key]]$required && !(arg_key \%in\% 
                args)) {
                arg_out[[argout_key]] <- arg_defs[[arg_key]]$val
                next
            }
            arg_idx <- which(args == arg_key)
            if (length(arg_idx) > 1) {
                printf("Warning: more than one matches to arg \%s", 
                  arg_key)
                arg_idx <- arg_idx[1]
            }
            arg_out[[argout_key]] <- args[arg_idx + 1]
            storage.mode(arg_out[[argout_key]]) <- arg_defs[[arg_key]]$type
        }
        return(arg_out)
    }
    return(parse_arguments)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
