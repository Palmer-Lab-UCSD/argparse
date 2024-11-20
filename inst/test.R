library('argparse')

parser <- argument_parser(
    argument_def(
        "pi",
        type="double",
        default_val=3.14,
        help="An arbitrary number"),
   argument_def(
        "--opt",
        type="character",
        help="The first option that we specify"),
   argument_def(
        "--logical",
        type="logical",
        help="If logical option flag used"),
   argument_def(
        "--nums",
        type="integer",
        nargs=3,
        help="test"),
   argument_def(
        "--words",
        type="character",
        nargs="+",
        help="another test")
)

if (!interactive())
{
    print(parser(commandArgs()))
}
