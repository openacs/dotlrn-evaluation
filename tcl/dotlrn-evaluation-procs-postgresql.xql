<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="dotlrn_news-aggregator::clone.call_evaluation_clone">
  <querytext>
    select evaluation__clone ( 
        :old_package_id,
        :new_package_id
      );
  </querytext>
</fullquery>


</queryset>
