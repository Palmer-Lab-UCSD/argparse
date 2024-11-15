\name{parse_r_lang_args}
\alias{parse_r_lang_args}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
parse_r_lang_args(args)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{args}{
%%     ~~Describe \code{args} here~~
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
function (args) 
{
    output <- list(args = NA, program_name = NA)
    i <- 1
    a <- args[i]
    while (a != "--args") {
        i <- i + 1
        if ((r <- regexpr("^--file=(?<value>\\w*.(R|r))$", a, 
            perl = TRUE)) > 0) {
            start_idx <- attr(r, "capture.start")[, "value"]
            end_idx <- start_idx + attr(r, "capture.length")[, 
                "value"]
            output[["program_name"]] <- substring(a, start_idx, 
                end_idx)
        }
        a <- args[i]
    }
    if (i == length(args) && a != "--args") 
        return(output)
    i <- i + 1
    if (i == length(args)) 
        output[["args"]] <- args[i]
    else output[["args"]] <- args[i:length(args)]
    return(output)
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
