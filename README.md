# `argparse` a tool for defining and parsing command line arguments


## Example


```R
require(argparse)


parser <- argparse::argument_parser(
    argparse::argument_def(                             # Position argument
        "pi",
        required=TRUE,
        type=numeric,
        default=3.14,
        help="An arbitrary number")
    argparse::argument_def(
        ref="--option_1",                               # Optional argument with 3 required values
        required=FALSE,
        type="character",
        nargs=3,
        help="The first option that we specify"),
    argparse::argument_def(
        ref="--logical_option",                         # Logical flag, default false, evaluates to true
        type="logical",
        help="If logical option flag used")
)


if (!interactive())
{
    args <- parser(commandArgs())
}
```

