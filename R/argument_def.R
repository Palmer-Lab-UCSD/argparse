# 
# 
# By: Robert Vogel
# Palmer Lab at UCSD

#' @title Specify command line argument
#'
#' @description
#'      Specifies which command line options the script / program is able
#'      to accept and the expected properties of each option value.
#'
#' @export
#' @param ref character:
#'      command line option (prefix '--') or position (no prefix) argument name
#' @param default_val (NA | double | integer | logical | character)
#'  (default NA)
#' @param required logical: 
#'  whether the argument is required input (default FALSE)
#' @param type character:
#'  Type include: character | integer | double | logical, (default character)
#' @param nargs character | numeric :
#'  * integer: required number of space separated values
#'  * "+": at least one argument
#'  * default 1 
#' @param help character:
#'  documentation to be printed with --help (default NA)
#' @return list
#'  with correct key value pairs for parsing
argument_def <- function(ref,
                        default_val=NA,
                        required=FALSE,
                        type="character",
                        nargs=1,
                        help=NA)
{

    # Note the defaults above are that required for parsing an option
    # with a single corresponding value

    if (is.null(ref) || is.na(ref))
        stop("ref must be a valid string")

    if (grepl("\\s", ref))
        stop("ref cannot have any whitespaces")

    if (!is.logical(required))
        stop("requirement keyword only takes logicals, (TRUE | FALSE)")

    if (!is.na(help) && !is.character(help))
        stop("Specified help is required to be (NA | character)")

    # Enforce that types must be one of the SUPPORTED_TYPES
    if (!(type %in% SUPPORTED_TYPES))
        stop(sprintf("Specified type must be one of (%s)\n",
                     paste(SUPPORTED_TYPES, sep=", ")))

    # general validation nargs
    if (nargs != "+" && !is.numeric(nargs))
        stop("Number of arguments must be + or an integer")
    else if (is.numeric(nargs) && (nargs < 0 || floor(nargs) != nargs))
        stop("nargs must be '+' or an integer >= 0")

    if (startsWith(ref, LONG_PREFIX)) {

        if (type == "logical") {
            # default and requirements for logical option
            nargs <- 0

            if (required)
                stop("Logical options can not be required")
            required <- FALSE

            if (!is.na(default_val) && default_val)
                warning("Default value of logical option is FALSE, setting to FALSE")
            default_val <- FALSE
        }
    } else if (!startsWith(ref, LONG_PREFIX)) {
        # default and requirements for position argument
        nargs <- 0
        required = TRUE

        if (type == "logical")
            stop("Position arguments can't be type 'logical'")
    } else
        stop("Unknown input")


    if (is.na(default_val) || storage.mode(default_val) == type)
        return(list(ref=ref, val=default_val,
                    help=help, nargs=nargs,
                    type=type, required=required))
    else
        stop("Default value doesn't match specified type")

    stop("Unanticipated error")
}
