# `argparse` a tool for defining and parsing command line arguments

🚧  **Note: A work in progress**

To my knowledge, `R` does not provide a useful command line argument parsing
tool in its standard library.  Such a tool is useful for specifying the properties
of script options and arguments.  The minimal features for such a tool include:

* keyword referencing of user options and arguments within a script,
* type specification,
* specification of default values,
* logical flag that toggles `TRUE` and `FALSE`,
* specifying the exact number of expected option input values,
* specifying that one or more option input values are expected

This `argparse` tool provides two functions that aim to satisfy these
criteria.  In what follows I provide an example script that demonstrates
the use of `argparse` and description of function arguments.

## Example

Suppose I have an R script that contains the following code:

```R
library(argparse)


main <- function(parsed_args) {
    # my awesome program
}


parser <- argparse::argument_parser(
    argparse::argument_def(                             # Position argument
        ref = "pi",
        type="double",
        default=3.14,
        help="An arbitrary number")
    argparse::argument_def(
        ref="--option_1",                               # Optional argument with 3 required values
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
    main(args)
}
```

Here mandatory position based arguments are distinguished by the `--` option reference prefix.
It is possible to force an option to be required by setting `required=TRUE`.

