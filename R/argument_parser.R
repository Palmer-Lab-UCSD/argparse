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
# TODO add type checking of argument inputs

#' @title Parse command line arguments
#'
#' @export
#' @param ... :
#'  Each element of the list is the output of the argument_def function
#' @param description character | NULL
#'  Description for --help (default NULL)
#' @return closure 
#'  * param character vector
#'      A vector of command line arguments, i.e. that returned by 
#'      commandArgs function, to be used by script. 
#'  * return list
#'      List contains default or input values for each option and argument 
#'      input to the closures parent function. 
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
        fid <- file("VERSION", "r")
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
        if ("--help" %in% args) {
            print_help(program_name, description,
                       position_defs, option_defs, version)
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
                arg_out[[rm_opt_prefix(opt_key)]] = process_option(curr_opt_def, args)
            else if(!curr_opt_def$required)
                arg_out[[rm_opt_prefix(opt_key)]] <- curr_opt_def$val
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

        if (length(position_defs) == 1 && start_pos_idx == length(args))
            arg_out[[position_defs[[1]]$ref]] <- change_type(args[start_pos_idx],
                                                             position_defs[[1]]$type)
        else if (length(position_defs) == length(args) - start_pos_idx + 1
            && start_pos_idx < length(args)) {

            posit_args <- args[start_pos_idx:length(args)]

            for (i in seq(length(posit_args)))
                arg_out[[position_defs[[i]]$ref]] <- change_type(posit_args[i], position_defs[[i]]$type)
        }


        return(arg_out)
    }

    return(parse_arguments)
}
# TODO add type checking of argument inputs
