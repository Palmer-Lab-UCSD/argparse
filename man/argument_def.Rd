\name{argument_def}
\alias{argument_def}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
argument_def(default_val = NULL, required = FALSE, type = "character", help = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{default_val}{
%%     ~~Describe \code{default_val} here~~
}
  \item{required}{
%%     ~~Describe \code{required} here~~
}
  \item{type}{
%%     ~~Describe \code{type} here~~
}
  \item{help}{
%%     ~~Describe \code{help} here~~
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
function (default_val = NULL, required = FALSE, type = "character", 
    help = NULL) 
{
    if (!is.logical(required)) 
        stop("requirement keyword only takes logicals, (TRUE | FALSE)")
    if (!is.null(help) && !is.character(help)) 
        stop("Specified help is required to be (NULL | character)")
    if (!(type \%in\% SUPPORTED_TYPES)) 
        stop("Specified type must be one of (character | integer | double)")
    if (is.null(default_val) || storage.mode(default_val) == 
        type) 
        return(list(val = default_val, help = help, type = type, 
            required = required))
    stop("Default value doesn't match specified type")
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
