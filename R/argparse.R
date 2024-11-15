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
#

SUPPORTED_TYPES <- c("character", "integer", "double", "logical")
LONG_PREFIX = "--"
CHAR_PREFIX = "-"
OPT_TO_ARG_DELIM = CHAR_PREFIX
EXTENSION_DELIM = "."


#' Specify command line argument values
#'
#' Specifies which command line options the script / program is able
#' to accept and the expected properties of each option value.
#'
#' @export
#' @param ref (character)
#'      option or position argument name, options have prefex '--'
#' @param default_val (NULL | double | integer | logical | character)
#'      (default NULL)
#' @param required (logical) 
#'      (default FALSE) whether the argument is required input
#' @param type (character)
#'      (default character) can take values (character | integer | double | logical)
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

    if (!(type %in% SUPPORTED_TYPES))
        stop(sprintf("Specified type must be one of (%s)\n",
                     paste(SUPPORTED_TYPES, sep=", ")))

    if (type != "logical" && is.null(nargs))
        nargs <- 1

    if (type == "logical") {
        nargs <- 0
        default_val <- FALSE
    }

    if (!startsWith(ref, LONG_PREFIX))
        nargs <- 0

    if (nargs != "+" && !is.numeric(nargs))
        stop("Number of arguments must be + or an integer")

    if (is.null(default_val) || storage.mode(default_val) == type)
        return(list(ref=ref, val=default_val, help=help, nargs=nargs,
                    type=type, required=required))

    stop("Default value doesn't match specified type")
}


#' Retreive user specified options from Rscript command line options 
#'
#' @description
#' Rscipt passes the command line options specified by the user
#' for the script / program and other to options the R language
#' executable.  This function finds the options for the desired
#' script / program.
#'
#' @details
#' The command line arguments to an R program / script launched by
#' Rscript, e.g.
#'
#' Rscript <script_name.r> --arg1 value --arg2 value
#' for running the R language executable. This function finds the
#' `script_name.r` string and user defined key / val pairs.
#'
#' @param args (vector (character)
#'      command line arguments that Rscript uses to run a script
#'
#' @return output (list)
#'      The list contains 2 key value pairs, 
#'          1. programe_name = the string that proceeds command line
#'                  argument '--file='                
#'          2. args = the list of user defined arguments defined by
#'                  the programe specified by key 'program_name'.
parse_r_lang_args <- function(args)
{
    output <- list(args = NA, program_name = NA)

    i <- 1
    a <- args[i]
    while (i <= length(args) && a != "--args")
    {
    
        if ((r <- regexpr("^--file=(?<value>\\w*.(R|r))$", a, perl=TRUE)) > 0)
        {
            start_idx <- attr(r, "capture.start")[,"value"]
            end_idx <- start_idx + attr(r, "capture.length")[,"value"]
            output[["program_name"]] <- substring(a, start_idx, end_idx)
        }
    
        a <- args[i]
        i <- i + 1
    }

    
    # if --args is not found
    if (i == length(args) && a != "--args")
        return(output)


    # Remove none script arguments from args vector
    if (i == length(args))
        output[["args"]] <- args[i]
    else
        output[["args"]] <- args[i:length(args)]

    return(output)
}


rm_key_prefix <- function(key)
{
    return(gsub(CHAR_PREFIX, "", key))
}


process_option <- function(arg_def, args) {



    # find index with option
    opt_idx <- 1

    while (opt_idx <= length(args) && args[opt_idx] != arg_def$ref)
        opt_idx <- opt_idx + 1

    # handle logical
    if (arg_def$type == "logical" && args[opt_idx] == arg_def$ref)
        return(TRUE)
    else if (arg_def$type == "logical")
        return(FALSE)


    if (opt_idx == length(args) && args[opt_idx] != arg_def$ref)
        stop("Invalid option")


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



# TODO add type checking of argument inputs
# TODO add required specification

#' Parse command line arguments
#'
#' @export
#'
#' @param ... ((character) key = (list) value) pairs where
#'      keys are command line options (including -- prefix) in
#'      quotes, and value is a list generated by argument
#' @param description (character)
#'
#' @return (closure) 
#'      closure param (vector (character))
#'          vector of command line arguments to be used by
#'          script or program. 
#'
#'      clsure return (list)
#'      option defaults of specified values from the command
#'      line
#'
#
argument_parser <- function(..., description=NULL)
{

    # Recall that an ellipsis function parameter indicates that
    # arbitrary number of arguments may be given as input.  To
    # access these simply use the idiom, as done below, list(...)
    arg_defs <- list(...)
    option_defs <- list()
    position_defs <- list()

    i <- 1
    for (arg_def in arg_defs) {
        if (startsWith(arg_def[["ref"]], LONG_PREFIX))
            option_defs[[arg_def[["ref"]]]] <- arg_def
        else {
            position_defs[[i]] <- arg_def
            i <- i + 1
        }
    }

    if (file.exists("VERSION"))
    {
        fid <- fopen("VERSION", "r")
        version = readLines(fid)
        close(fid)
    } else {
        version=NULL
    }

    parse_arguments <- function(args)
    {

        # Recall, that the command line inputs in R consists of
        # R language arguments, followed by the --args flag.  Each
        # command line argument after --args is one given by the user
        # to the script/program implemented in R. This bit of code,
        # finds the R script name and the index in which
        # arg[idx] == '--args'
        
        parsed_input <- parse_r_lang_args(args)
        args <- parsed_input[["args"]]
        program_name <- parsed_input[["program_name"]]
        rm(parsed_input)

        # TODO do these assumptions only hold true when using Rscript?
        # to launch program
        if (length(args) == 1 && is.na(args))
            stop("Missing R language arguments")
        
        if (is.na(program_name))
            stop("R script missing from command line inputs")

        # Should we print help?
        if ("--help" %in% args)
        {

            if (is.null(version))
                cat(sprintf("\n%s\n\n", program_name))
            else
                cat(sprintf("\n%s, Version %s\n\n", program_name, version))

            if (!is.null(description))
                cat(sprintf("%s\n\n", description))
            
            # TODO: need a better strategy for formatting
            # argument help entries
            cat(sprintf("%s\n", "ARGUMENTS"))

            for (a in position_defs)
                cat(sprintf("%s\t%s\n", a$ref, a$help))


            cat(sprintf("\n%s\n", "OPTIONS"))
            for (a in option_defs)
                cat(sprintf("%s\t%s\n", a$ref, a$help))
            quit()
        }


        arg_out <- list()

        # TODO detect key collisions

        # parser input arguments vector
        # recall that the first element is the command
        for(opt_key in names(option_defs))
        {

            curr_opt_def <- option_defs[[opt_key]]


            if (sum(opt_key == args) > 1)
                stop(sprintf("Option, %s, specified more than once", opt_key))

            if (opt_key %in% args)
                arg_out[[rm_key_prefix(opt_key)]] = process_option(curr_opt_def, args)
            else if(!curr_opt_def$required)
                arg_out[[rm_key_prefix(opt_key)]] <- curr_opt_def$val
            else 
                stop(sprintf("arg, %s, must be specified.", opt_key))

        }

        # find index of positional arguments
        curr_arg_def <- list(nargs=0)
        start_pos_idx <- 1
        for (i in seq(length(args))) {

            if (args[i] == OPT_TO_ARG_DELIM) {
                start_pos_idx <- i + 1
                break
            }

            if (startsWith(args[i], LONG_PREFIX) 
                && is.numeric(option_defs[[args[i]]]$nargs)) {
                curr_arg_def <- option_defs[[args[i]]]
                start_pos_idx <- i + curr_arg_def$nargs + 1
                next
            }

            if (i >= start_pos_idx && curr_arg_def$nargs == "+")
                start_pos_idx <- i + 1
        }

        if (start_pos_idx > length(args))
            stop("No position arguments detected")

        if (length(position_defs) == 1 && start_pos_idx == length(args)) {

            tmp <- args[start_pos_idx]
            storage.mode(tmp) <- position_defs[[1]]$type

            arg_out[[position_defs[[1]]$ref]] <- tmp

        } else if (length(position_defs) == length(args) - start_pos_idx + 1
            && start_pos_idx < length(args)) {

            posit_args <- args[start_pos_idx:length(args)]

            for (i in seq(length(posit_args))) {
                posit_def <- position_defs[[i]]
                tmp <- posit_args[i]
                storage.mode(tmp) <- posit_def$type
                arg_out[[posit_def$ref]] <- tmp
            }
        }


        return(arg_out)
    }

    return(parse_arguments)
}
