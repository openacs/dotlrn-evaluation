?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="dotlrn_evaluation::clone.call_evaluation_clone">
  <querytext>
    select evaluation.clone ( 
        :old_package_id,
        :new_package_id
      );
  </querytext>
</fullquery>

</queryset>
