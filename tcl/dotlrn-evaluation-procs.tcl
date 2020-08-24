ad_library {

    Procs to set up the dotLRN evaluation applet

    @author jopez@galileo.edu
    @cvs-id $Id$
}

namespace eval dotlrn_evaluation {}

ad_proc -public dotlrn_evaluation::applet_key {} {
    What's my applet key?
} {
    return dotlrn_evaluation
}

ad_proc -public dotlrn_evaluation::package_key {} {
    What package do I deal with?
} {
    return "evaluation"
}

ad_proc -public dotlrn_evaluation::my_package_key {} {
    What package do I deal with?
} {
    return "dotlrn-evaluation"
}

ad_proc -public dotlrn_evaluation::get_pretty_name {} {
    returns the pretty name
} {
    return "[_ dotlrn-evaluation.Evaluation_]"
}

ad_proc -public dotlrn_evaluation::add_applet {} {
    One time init - must be repeatable!
} {
    dotlrn_applet::add_applet_to_dotlrn -applet_key [applet_key] -package_key [my_package_key]
}

ad_proc -public dotlrn_evaluation::remove_applet {} {
    One time destroy.
} {
    set applet_id [dotlrn_applet::get_applet_id_from_key [my_package_key]]
    db_exec_plsql delete_applet_from_communities { *SQL* }
    db_exec_plsql delete_applet { *SQL* }
#    dotlrn_applet::remove_applet_from_dotlrn -applet_key [applet_key]
}

ad_proc -public dotlrn_evaluation::add_applet_to_community {
    community_id
} {
    Add the evaluation applet to a specific dotlrn community
} {
    set portal_id [dotlrn_community::get_portal_id -community_id $community_id]

    # create the evaluation package instance
    set package_id [dotlrn::instantiate_and_mount $community_id [package_key]]

    # set up the admin portal
    set admin_portal_id [dotlrn_community::get_admin_portal_id \
                             -community_id $community_id
                        ]

    evaluation_admin_portlet::add_self_to_page \
        -portal_id $admin_portal_id \
        -package_id $package_id

    set args [ns_set create]
    ns_set put $args package_id $package_id
    add_portlet_helper $portal_id $args

    return $package_id
}

ad_proc -public dotlrn_evaluation::remove_applet_from_community {
    community_id
} {
    remove the applet from the community
} {
    ad_return_complaint 1 "[applet_key] remove_applet_from_community not implemented!"
}

ad_proc -private dotlrn_evaluation::add_user {
    user_id
} {
    one time user-specifuc init
} {
    # noop
}

ad_proc -private dotlrn_evaluation::remove_user {
    user_id
} {
} {
    # noop
}

ad_proc -private dotlrn_evaluation::add_user_to_community {
    community_id
    user_id
} {
    Add a user to a specific dotlrn community
} {
#     set package_id [dotlrn_community::get_applet_package_id -community_id $community_id -applet_key [applet_key]]
#     set portal_id [dotlrn::get_portal_id -user_id $user_id]

#     # use "append" here since we want to aggregate
#     set args [ns_set create]
#     ns_set put $args package_id $package_id
#     ns_set put $args param_action append
#     add_portlet_helper $portal_id $args
}

ad_proc -public dotlrn_evaluation::remove_user_from_community {
    community_id
    user_id
} {
    Remove a user from a community
} {
    set package_id [dotlrn_community::get_applet_package_id -community_id $community_id -applet_key [applet_key]]
    set portal_id [dotlrn::get_portal_id -user_id $user_id]

    set args [ns_set create]
    ns_set put $args package_id $package_id

    remove_portlet $portal_id $args
}

ad_proc -public dotlrn_evaluation::add_portlet {
    portal_id
} {
    A helper proc to add the underlying portlet to the given portal.

    @param portal_id
} {
    # simple, no type specific stuff, just set some dummy values

    set args [ns_set create]
    ns_set put $args package_id 0
    ns_set put $args param_action overwrite
    add_portlet_helper $portal_id $args
}

ad_proc -public dotlrn_evaluation::add_portlet_helper {
    portal_id
    args
} {
    A helper proc to add the underlying portlet to the given portal.

    @param portal_id
    @param args an ns_set
} {
    evaluation_assignments_portlet::add_self_to_page \
        -portal_id $portal_id \
        -package_id [ns_set get $args package_id] \
        -param_action [ns_set get $args param_action] \
        -force_region [parameter::get -parameter AssignmentsPortletRegion -package_id [ns_set get $args package_id]] \
        -page_name [parameter::get -parameter EvaluationPageName -package_id [ns_set get $args package_id]]

    evaluation_evaluations_portlet::add_self_to_page \
        -portal_id $portal_id \
        -package_id [ns_set get $args package_id] \
        -param_action [ns_set get $args param_action] \
        -force_region [parameter::get -parameter EvaluationsPortletRegion -package_id [ns_set get $args package_id]] \
        -page_name [parameter::get -parameter EvaluationPageName -package_id [ns_set get $args package_id]]
}

ad_proc -public dotlrn_evaluation::remove_portlet {
    portal_id
    args
} {
    A helper proc to remove the underlying portlet from the given portal.

    @param portal_id
    @param args A list of key-value pairs (possibly user_id, community_id, and more)
} {
    evaluation_assignments_portlet::remove_self_from_page \
        -portal_id $portal_id \
        -package_id [ns_set get $args package_id]

    evaluation_evaluations_portlet::remove_self_from_page \
        -portal_id $portal_id \
        -package_id [ns_set get $args package_id]
}

ad_proc -public dotlrn_evaluation::clone {
    old_community_id
    new_community_id
} {
    Clone this applet's content from the old community to the new one
} {
    ns_log notice "Cloning: [applet_key]"
    set new_package_id [add_applet_to_community $new_community_id]
    set old_package_id [dotlrn_community::get_applet_package_id \
                            -community_id $old_community_id \
                            -applet_key [applet_key]
                       ]

    set grades [db_list_of_lists get_grades {}]

    db_dml delete_grades {}

    foreach grade $grades {
        set grade_id [db_nextval acs_object_id_seq]
        set revision_id [evaluation::new_grade -new_item_p t -item_id $grade_id -content_type evaluation_grades -content_table evaluation_grades -content_id grade_id -name [lindex $grade 0] -plural_name [lindex $grade 1] -description [lindex $grade 2] -weight [lindex $grade 3] -package_id $new_package_id]
        content::item::set_live_revision -revision_id $revision_id

        set grade_item_id [lindex $grade 4]
        set tasks [db_list_of_lists get_tasks {}]


        foreach task $tasks {
            set forums_related_p [lindex $task 12]
            set points [lindex $task 13]
            set relative_weight [lindex $task 14]
            set perfect_score [lindex $task 15]
            set task_id [db_nextval acs_object_id_seq]
            set task_revision_id [evaluation::new_task -new_item_p t -item_id $task_id \
                          -content_type evaluation_tasks \
                          -content_table evaluation_tasks \
                          -content_id task_id \
                          -name [lindex $task 0] \
                          -description [lindex $task 1] \
                          -weight [lindex $task 2] \
                          -grade_item_id $grade_id \
                          -number_of_members [lindex $task 3] \
                          -online_p [lindex $task 4] \
                          -storage_type [lindex $task 5] \
                          -due_date [lindex $task 6] \
                          -late_submit_p [lindex $task 7] \
                          -requires_grade_p [lindex $task 8] \
                          -title [lindex $task 9] \
                          -mime_type [lindex $task 10] \
                          -estimated_time [lindex $task 11] \
                          -package_id $new_package_id]

            content::item::set_live_revision -revision_id $task_revision_id

            # by the moment, since I'm having a date problem with oracle10g, I have to do this in order
            # to store the entire date

            db_dml update_tasks {}
        }
    }

    return $new_package_id
}

ad_proc -private dotlrn_evaluation::change_event_handler {
    community_id
    event
    old_value
    new_value
} {
    listens for the following events:
} {
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
