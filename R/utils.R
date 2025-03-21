# MIT License
# 
# Copyright (c) 2024 Palmer Lab at UCSD
#
# General argument parsing for R scripts
#
#
# By: Robert Vogel
# Palmer Lab at UCSD
# Date: 2024-08-16
#
#
# The code is an update of that originally developed in the RATTACA
# R package, available at
#
# https://github.com/Palmer-Lab-UCSD/rattaca/blob/main/R/utils.R
#
# My intention was always to make it a stand alone tool, which is what
# I've done here.
#


is_argument_def <- function(a) {

    if (!is.list(a))
        return(FALSE)

    attributes <- names(a)

    if (!("ref" %in% attributes))
        return(FALSE)

    if (!("val" %in% attributes))
        return(FALSE)

    if (!("help" %in% attributes))
        return(FALSE)

    if (!("type" %in% attributes))
        return(FALSE)

    if (!("nargs" %in% attributes))
        return(FALSE)

    if (!("required" %in% attributes))
        return(FALSE)


    return(TRUE)
}


is_numeric_str <- function(s) {

    cond_a <- "[+-]?[0-9]*\\.?[0-9]+"
    cond_b <- "[+-]?[0-9]+\\.?[0-9]*"

    return(grepl(sprintf("^%s$", cond_a), s)
           || grepl(sprintf("^%s$", cond_b), s)
           || grepl(sprintf("^%s[eE]?%s$", cond_a, cond_a), s)
           || grepl(sprintf("^%s[eE]?%s$", cond_a, cond_b), s)
           || grepl(sprintf("^%s[eE]?%s$", cond_b, cond_a), s)
           || grepl(sprintf("^%s[eE]?%s$", cond_b, cond_b), s))
}


change_type <- function(x, type) {
    if (typeof(x) == type)
        return(x)

    if (!is_numeric_str(x) && (type == "double" || type == "integer"))
        stop(sprintf("Input %s isn't numeric.", x))

    storage.mode(x) <- type

    if (is.na(x) || typeof(x) != type)
        stop("Changing storage mode / type failed")

    return(x)
}


#' @title Retreive user specified options from Rscript command line options 
#'
#' @description Rscipt passes the command line options specified by the user
#' for the script / program and other to options the R language
#' executable.  This function finds the options for the desired
#' script / program.
#'
#' @details The command line arguments to an R program / script launched by
#' Rscript, e.g.
#'
#' Rscript <script_name.r> --arg1 value --arg2 value
#' for running the R language executable. This function finds the
#' `script_name.r` string and user defined key / val pairs.
#'
#' @param args character vector:
#'  command line arguments, i.e. returned by commandArgs,
#'  that Rscript uses to run a script
#' @return output list:
#'  The list contains 2 key value pairs:
#'  * program_name = the string that proceeds command line argument '--file='
#'  * args = the list of user defined arguments 
parse_r_lang_args <- function(args)
{
    if (typeof(args) != "character")
        stop("Input must be a character vector")

    output <- list(args = NA, program_name = NA)

    i <- 1
    while (i <= length(args) && (a = args[i]) != "--args")
    {
    
        if ((r <- regexpr("^--file=(?<value>[-_/\\w]*.(R|r))$", a, perl=TRUE)) > 0)
        {
            start_idx <- attr(r, "capture.start")[,"value"]
            end_idx <- start_idx + attr(r, "capture.length")[,"value"]
            output[["program_name"]] <- substring(a, start_idx, end_idx)
        }
    
        i <- i + 1
    }

    
    # if --args is not found or is the last entry, no input arguments
    if (i >= length(args))
        return(output)

    # Recall that args[i] == --args
    i <- i + 1
    output[["args"]] <- args[i:length(args)]

    return(output)
}


rm_opt_prefix <- function(key)
{
    return(gsub(sprintf("^[%s]+",CHAR_PREFIX), "", key))
}


#' @title Parse argument character vector for arg with definition arg_def
#'
#' @param arg_def list:
#'  output from arg_def
#' @param args character vector:
#'  The set of arguments to match against arg_def
#' @return NA | logical | vector :
#'  vector type depends are arg_def specified type
#'
process_option <- function(arg_def, args) {

    if (!is_argument_def(arg_def))
       return(NA) 

    # find index with option
    opt_idx <- 1
    while (opt_idx <= length(args) && args[opt_idx] != arg_def$ref)
        opt_idx <- opt_idx + 1

    # handle logical
    if (arg_def$type == "logical" && opt_idx <= length(args))
        return(TRUE)
    else if (arg_def$type == "logical")
        return(FALSE)


    if (opt_idx > length(args))
        return(NA)

    # number of args given
    if (is.numeric(arg_def$nargs)) {
        
        output <- vector(mode=arg_def$type, length=arg_def$nargs)

        for (j in seq(opt_idx+1, opt_idx + arg_def$nargs)) {

            # if the number of input options is greater than that given
            if (startsWith((tmp = args[j]), LONG_PREFIX))
                stop("Wrong number of inputs")

            storage.mode(tmp) <- arg_def$type

            output[j-opt_idx] <- tmp
        }

        return(output)
    }
    
    # arbitrary number of args
    if (arg_def$nargs == "+") {
        output <- vector(mode=arg_def$type)

        i <- opt_idx + 1
        while (i <= length(args) && !startsWith(args[i], OPT_TO_ARG_DELIM)) {
            tmp <- args[i]
            storage.mode(tmp) <- arg_def$type

            output <- c(output, tmp)
            i <- i+1
        }

        if (length(output) == 0)
            stop(sprintf("%s requires 1 or more inputs\n", arg_def$ref))

        return(output)
    }


    stop("Unknown narg value")
}
