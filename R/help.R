# Print command line help
#
# By: Robert Vogel
# Palmer Lab at UCSD

help_cat <- function(s){
    cat(s, fill=TRUE)
}

print_help <- function(program_name, description,
                       position_defs, option_defs, version){
    
    if (is.null(version))
        help_cat(sprintf("\n%s\n\n", program_name))
    else
        help_cat(sprintf("\n%s, Version %s\n\n", program_name, version))
    
    if (!is.null(description))
        help_cat(sprintf("%s\n\n", description))
    
    # TODO: need a better strategy for formatting
    # argument help entries
    help_cat(sprintf("%s\n", "ARGUMENTS"))
    
    for (a in position_defs)
        help_cat(sprintf("%s\t%s\n", a$ref, a$help))
    
    
    help_cat(sprintf("\n%s\n", "OPTIONS"))
    for (a in option_defs)
        help_cat(sprintf("%s\t%s\n", a$ref, a$help))
}
