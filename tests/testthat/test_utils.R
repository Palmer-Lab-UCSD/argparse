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

test_that("rm_opt_prefix", {
    expect_equal(rm_opt_prefix("--option"), "option")
    expect_equal(rm_opt_prefix("-option"), "option")
    expect_equal(rm_opt_prefix("option"), "option")
    expect_equal(rm_opt_prefix("opt-ion"), "opt-ion")
})


