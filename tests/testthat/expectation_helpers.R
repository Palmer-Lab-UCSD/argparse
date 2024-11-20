# Expand the set of expectations

expect_true <- function(conditional_test) {
    expect_equal(conditional_test, TRUE)
}

expect_false <- function(conditional_test) {
    expect_equal(conditional_test, FALSE)
}

expect_null <- function(conditional_test) {
    expect_true(is.null(conditional_test))
}

expect_na <- function(conditional_test) {
    expect_true(is.na(conditional_test))
}
