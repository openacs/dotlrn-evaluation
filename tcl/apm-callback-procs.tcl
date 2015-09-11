ad_library {
    Procedures for registering implementations for the
    dotlrn evaluation package. 
    
    @creation-date May 2003
    @author jopez@galileo.edu
    @cvs-id $Id$
}

namespace eval dotlrn_evaluation {}

ad_proc -public dotlrn_evaluation::install {} {
    dotLRN Evaluation package install proc
} {
    register_portal_datasource_impl
}

ad_proc -public dotlrn_evaluation::uninstall {} {
    dotLRN Evaluation package uninstall proc
} {
    unregister_portal_datasource_impl
}

ad_proc -public dotlrn_evaluation::register_portal_datasource_impl {} {
    Register the service contract implementation for the dotlrn_applet service contract
} {
    set spec {
        name "dotlrn_evaluation"
	contract_name "dotlrn_applet"
	owner "dotlrn-evaluation"
        aliases {
	    GetPrettyName dotlrn_evaluation::get_pretty_name
	    AddApplet dotlrn_evaluation::add_applet
	    RemoveApplet dotlrn_evaluation::remove_applet
	    AddAppletToCommunity dotlrn_evaluation::add_applet_to_community
	    RemoveAppletFromCommunity dotlrn_evaluation::remove_applet_from_community
	    AddUser dotlrn_evaluation::add_user
	    RemoveUser dotlrn_evaluation::remove_user
	    AddUserToCommunity dotlrn_evaluation::add_user_to_community
	    RemoveUserFromCommunity dotlrn_evaluation::remove_user_from_community
	    AddPortlet dotlrn_evaluation::add_portlet
	    RemovePortlet dotlrn_evaluation::remove_portlet
	    Clone dotlrn_evaluation::clone
	    ChangeEventHandler dotlrn_evaluation::change_event_handler
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -public dotlrn_evaluation::unregister_portal_datasource_impl {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "dotlrn_applet" \
        -impl_name "dotlrn_evaluation"
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
