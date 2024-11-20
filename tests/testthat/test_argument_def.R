# Unit tests for argument_def
#
# By: Robert Vogel
# Palmer Lab at UCSD
#

source("expectation_helpers.R")


test_that("argument_def: default position argument", {
    arg_def <- argument_def("arbitrary_arg")

    expect_equal(arg_def[["ref"]], "arbitrary_arg")
    expect_na(arg_def[["val"]])

    expect_true(arg_def[["required"]])
    expect_equal(arg_def[["nargs"]], 0)
    expect_na(arg_def[["help"]])


    expect_error(argument_def(3))
    expect_error(argument_def("arbitrary_arg", type="logical"))
})



test_that("argument_def: default option", {
    arg_def <- argument_def("--arbitrary_option")

    expect_equal(arg_def[["ref"]], "--arbitrary_option")
    expect_na(arg_def[["val"]])

    expect_false(arg_def[["required"]])
    expect_equal(arg_def[["nargs"]], 1)
    expect_na(arg_def[["help"]])


    expect_error(argument_def(3))
})


test_that("argument_def: logical, true", {
    arg_def <- argument_def("--mk_true",
                           type="logical")

    expect_equal(arg_def[["ref"]], "--mk_true")
    expect_false(arg_def[["val"]])
    expect_false(arg_def[["required"]])

    expect_equal(arg_def[["nargs"]], 0)
    expect_na(arg_def[["help"]])


    expect_error(argument_def(3), type="logical")
})


test_that("argument_def: logical errors and warnings", {
    expect_error(argument_def("--mk_true",
                            type="logical",
                            required=TRUE))

    expect_warning(argument_def("--mk_false", default_val=TRUE, type="logical"))
})



# TODO
test_that("argument_def: integer", {
    arg_def <- argument_def("--my_integer", type="integer")


})

