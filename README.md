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


## Defining options and arguments

In this section I show the default values for the input types supported by
`argparse::argument_def`.  

### Default position argument

Suppose that one is interested in setting a single position argument using the
default values set by `argparse::argument_def`, that is

```R
> arg_def <- argument_def("my_value")
> print(arg_def)
$ref
[1] "my_value"

$val
NULL

$help
NULL

$nargs
[1] 0

$type
[1] "character"

$required
[1] TRUE
```

Here we see that position requirements are always required, that the number
of proceeding arguments will always be 0, and by default is of type
character.  The default value is NULL, but in this context, i.e. the position
argument is required, is meaningless.


### Default option

Suppose that one only specifies the required argument `ref` with prefix `--`,
this is interpreted as an option with defaults

```R
> arg_def <- argument_def("--my_value")
> print(arg_def)
$ref
[1] "--my_value"

$val
NULL

$help
NULL

$nargs
[1] 1

$type
[1] "character"

$required
[1] FALSE
```

The default are similar to that of a position argument with two important
distinctions.  First, by default `required` is `FALSE`, which is as expected
for an *option*.  Second, by default `nargs` is `1`, options are expected by
be (key, value) pairs, and by default we expect only a single value.


### Default for logical types

Logical options or position arguments are set by specified by setting `type="logical"`, e.g.

```R
> arg_def <- argument_def("--my_logical_value", type = "logical")
> print(arg_def)
$ref
[1] "--my_logical_value"

$val
[1] FALSE

$help
NULL

$nargs
[1] 0

$type
[1] "logical"

$required
[1] FALSE
```

notice here that the default value is set to `FALSE`, meaning that the absence of
of the option `--my_logical_value` at the command line defaults to `FALSE`.  The
inclusion of this option at the command line toggles the value to `TRUE`.  As 
such, setting the required field to `TRUE` does not make sense, as always including
this option will always evaluate to `TRUE`.  Setting `required = TRUE` will result
in an exception being thrown.

