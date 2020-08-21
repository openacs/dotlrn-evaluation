ad_library {

        Automated tests for the dotlrn-evaluation package.

        @author Héctor Romojaro <hector.romojaro@gmail.com>
        @creation-date 2019-09-10

}

aa_register_case \
    -cats {api smoke production_safe} \
    -procs {
        dotlrn_evaluation::package_key
        dotlrn_evaluation::my_package_key
        dotlrn_evaluation::applet_key
    } \
    dotlrn_evaluation__keys {

        Simple test for the various dotlrn_evaluation::..._key procs.

        @author Héctor Romojaro <hector.romojaro@gmail.com>
        @creation-date 2019-09-10
} {
    aa_equals "Package key" "[dotlrn_evaluation::package_key]" "evaluation"
    aa_equals "My Package key" "[dotlrn_evaluation::my_package_key]" "dotlrn-evaluation"
    aa_equals "Applet key" "[dotlrn_evaluation::applet_key]" "dotlrn_evaluation"
}

aa_register_case -procs {
        dotlrn_evaluation::get_pretty_name
    } -cats {
        api
        production_safe
    } dotlrn_evaluation_names {
        Test diverse name procs.
} {
    aa_equals "dotlrn-evaluation pretty name" "[dotlrn_evaluation::get_pretty_name]" "[_ dotlrn-evaluation.Evaluation_]"
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
