

get_command_args <- function(...) {

    # Remember that when using Rscript my_script.R, the R
    # language prepends its the users options and arguments with
    # system information.
    args <- c("Arbitrary_R_arg", "arb_R_arg", "--file=my_script.R", "--args")
    user_args <- list(...)

    for (i in seq(length(user_args)))
        args <- c(args, user_args[[i]])

    return(args)
}


test_that("argument_parser: correct output", {
    parser <- argument_parser(argument_def("arbitrary_position_arg"),
                              argument_def("--logical", type="logical"))

    args <- parser(get_command_args("--logical", "arbitrary_value"))

})
