source('R/argparse.R')

parser <- argument_parser(
    argument_def(
        "pi",
        type="double",
        default=3.14,
        help="An arbitrary number"),
   argument_def(
        ref="--opt",
        type="character",
        help="The first option that we specify"),
   argument_def(
        ref="--logical",
        type="logical",
        help="If logical option flag used"),
   argument_def(
        ref="--nums",
        type="integer",
        nargs=3,
        help="test"),
   argument_def(
        ref="--words",
        type="character",
        nargs="+",
        help="another test")
)

if (!interactive())
{
    print(parser(commandArgs()))
}
