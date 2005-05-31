<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="dotlrn_evaluation::clone.get_grades">
  <querytext>	
	select eg.grade_name, eg.grade_plural_name, eg.comments, eg.weight, eg.grade_item_id	
        from acs_objects o, evaluation_grades eg,cr_items ci,cr_revisions cr	
        where o.object_id = ci.item_id
        and cr.revision_id=eg.grade_id 
	and ci.item_id=cr.item_id
	and cr.revision_id=ci.live_revision
        and o.context_id =:old_package_id
  </querytext>
</fullquery>
<fullquery name="dotlrn_evaluation::clone.get_tasks">
  <querytext>
	select et.task_name,cr.description,et.weight, et.number_of_members, et.online_p, ci.storage_type, et.due_date, et.late_submit_p, et.requires_grade_p, cr.title, cr.mime_type, et.estimated_time, et.forums_related_p,et.points, et.relative_weight, et.perfect_score,(ci.live_revision = cr.revision_id) as live_p from evaluation_tasks et,cr_revisions cr,cr_items ci, acs_objects o where grade_item_id = :grade_item_id and cr.revision_id=task_id and cr.item_id=ci.item_id and object_id=ci.item_id order by task_item_id
	
  </querytext>
</fullquery>

<fullquery name="dotlrn_evaluation::clone.update_tasks">
  <querytext>
	update evaluation_tasks set points=:points, relative_weight=:relative_weight, perfect_score= :perfect_score,forums_related_p=:forums_related_p  where task_id=:task_revision_id;
  </querytext>
</fullquery>

<fullquery name="dotlrn_evaluation::clone.delete_grades">
  <querytext>
		    delete from evaluation_grades where grade_id in (select eg.grade_id from acs_objects o, evaluation_grades eg,cr_items ci,cr_revisions cr  where o.object_id = ci.item_id and cr.revision_id=eg.grade_id  and ci.item_id=cr.item_id  and cr.revision_id=ci.live_revision and o.context_id = :new_package_id);

  </querytext>
</fullquery>


<fullquery name="dotlrn_evaluation::remove_applet.delete_applet_from_communities">
  <querytext>

	delete from dotlrn_community_applets where applet_id = :applet_id
    
  </querytext>
</fullquery>

<fullquery name="dotlrn_evaluation::remove_applet.delete_applet">
  <querytext>

	delete from dotlrn_applets where applet_id = :applet_id
    
  </querytext>
</fullquery>

</queryset>
