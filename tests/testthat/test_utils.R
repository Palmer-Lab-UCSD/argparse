# MIT License
# 
# Copyright (c) 2024 Palmer Lab at UCSD
#
# unit tests for R/utils.R
#
#
# By: Robert Vogel
# Palmer Lab at UCSD
# Date: 2024-11-17
#

expect_true <- function(conditional_test) {
    expect_equal(conditional_test, TRUE)
}

expect_false <- function(conditional_test) {
    expect_equal(conditional_test, FALSE)
}


test_that("rm_opt_prefix", {
    expect_equal(rm_opt_prefix("--option"), "option")
    expect_equal(rm_opt_prefix("-option"), "option")
    expect_equal(rm_opt_prefix("option"), "option")
    expect_equal(rm_opt_prefix("opt-ion"), "opt-ion")
    expect_equal(rm_opt_prefix("option-"), "option-")
    expect_equal(rm_opt_prefix("option--"), "option--")
})

test_that("parse_r_lang_args: validate input", {
    expect_error(parse_r_lang_args(NULL))
    expect_error(parse_r_lang_args(NA))
    expect_error(parse_r_lang_args(c(4.2, 5)))
})


test_that("parse_r_lang_args: find_prog_name", {
    rscript_args <- c("arbitrary", "--file=my_program.R", "--args",
                       "--user_option", "val")

    expect_equal(parse_r_lang_args(rscript_args)[["program_name"]],
                 "my_program.R")


    # when --file is also a user option
    rscript_args <- c(rscript_args, "--file", "incorrect_val")
    expect_equal(parse_r_lang_args(rscript_args)[["program_name"]],
                 "my_program.R")


    rscript_args <-  c("arbitrary", "--file=my_program.r", "--args",
                       "--user_option", "val")
    # when lower case R for program extension
    expect_equal(parse_r_lang_args(rscript_args)[["program_name"]],
                 "my_program.r")
})


test_that("parse_r_lang_args: no args", {
    tmp <- parse_r_lang_args(c("arbitrary"))
    expect_equal(tmp[["args"]], NA)
    expect_equal(tmp[["program_name"]], NA)

    tmp <- parse_r_lang_args(c("arbitrary", "--file=my_program.R", "arg"))

    expect_equal(tmp[["args"]], NA)
    expect_equal(tmp[["program_name"]], "my_program.R")


})


test_that("process_option: no matches", {
    tmp_def <- argument_def("not_in_vector_of_args")
    tmp_args <- c("--opt1", "a", "--logical", "position_arg")

    expect_true(is.na(process_option(tmp_def, tmp_args)))

})


test_that("process_option: logical", {
    tmp_def <- argument_def("--log_opt", type="logical")
    tmp_args <- c("--file=my_prog.R")
    expect_false(process_option(tmp_def, tmp_args))

    tmp_args <- c(tmp_args, "--log_opt")
    expect_true(process_option(tmp_def, tmp_args))

    tmp_args <- c(tmp_args, "posit_input1", "posit_input2")
    expect_true(process_option(tmp_def, tmp_args))
})


test_that("is_argument_def: true", {
    expect_true(is_argument_def(argument_def("--my_opt")))
    expect_true(is_argument_def(argument_def("test")))

    expect_error(is_argument_def(argument_def(NULL)))

    expect_true(is_argument_def(argument_def("--test", type="logical", required=TRUE)))
})


test_that("is_numeric_str: all cases", {
    expect_true(is_numeric_str("5334"))
    expect_true(is_numeric_str("53.34"))
    expect_true(is_numeric_str("+53.34"))
    expect_true(is_numeric_str("-53.34"))
    expect_true(is_numeric_str("-.34"))
    expect_true(is_numeric_str("1."))

    expect_true(is_numeric_str("1.E2.345"))
    expect_true(is_numeric_str("1.E+2.345"))
    expect_true(is_numeric_str("-1.E+2.345"))
    expect_true(is_numeric_str("-1.E-2.345"))
    expect_true(is_numeric_str("-1.0E-2"))
    expect_true(is_numeric_str("-1.0E-02"))

    expect_false(is_numeric_str("1.a"))
    expect_false(is_numeric_str("a"))
    expect_false(is_numeric_str("a5"))
    expect_false(is_numeric_str("qera.5"))
})


test_that("change_type: all cases", {
    expect_equal(typeof(change_type("value", "character")), "character")
    expect_equal(typeof(change_type("3.254", "double")), "double")
    expect_equal(typeof(change_type("3", "double")), "double")
    expect_equal(typeof(change_type("-3.24", "double")), "double")
    expect_equal(typeof(change_type("1", "integer")), "integer")

    expect_error(typeof(change_type("1a", "double")))
})
