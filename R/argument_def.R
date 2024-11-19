# 
# 
# By: Robert Vogel
# Palmer Lab at UCSD

#' @title 
#'      Specify command line argument
#'
#' @description
#'      Specifies which command line options the script / program is able
#'      to accept and the expected properties of each option value.
#'
#' @export
#' @param ref (character)
#'      command line option (prefix '--') or position (no prefix) argument name
#' @param default_val (NULL | double | integer | logical | character)
#'      (default NULL)
#' @param required (logical) 
#'      (default FALSE) whether the argument is required input
#' @param type (character)
#'      (default "character") can take values (character | integer | double | logical)
#' @param nargs (character | numeric | NULL)
#'      (default NULL, a single option value) If:
#'            - integer: required number of space separated values
#'            - "+": at least one argument
#' @param help (character)
#'      (default NULL) documentation to be printed with --help
#'
#' @return (list) with correct key value pairs for parsing
#
argument_def <- function(ref,
                        default_val=NULL,
                        required=FALSE,
                        type="character",
                        nargs=NULL,
                        help=NULL)
{

    if (!is.logical(required))
        stop("requirement keyword only takes logicals, (TRUE | FALSE)")

    if (!is.null(help) && !is.character(help))
        stop("Specified help is required to be (NULL | character)")

    # validate types
    if (!(type %in% SUPPORTED_TYPES))
        stop(sprintf("Specified type must be one of (%s)\n",
                     paste(SUPPORTED_TYPES, sep=", ")))

    if (type != "logical")
        nargs <- 1

    if (type == "logical") {
        nargs <- 0
        default_val <- FALSE
    }

    # validate nargs
    if (nargs != "+" && !is.numeric(nargs))
        stop("Number of arguments must be + or an integer")

    if (is.numeric(nargs) && (floor(nargs) != nargs || nargs < 0))
        stop("Number of arguments (nargs) must be 0 or a positive integer.")


    # position arguments do not have any proceeding values
    if (!startsWith(ref, LONG_PREFIX))
        nargs <- 0


    if (is.null(default_val) || storage.mode(default_val) == type)
        return(list(ref=ref, val=default_val, help=help, nargs=nargs,
                    type=type, required=required))

    stop("Default value doesn't match specified type")
}
