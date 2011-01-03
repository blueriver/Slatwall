import Slatwall.com.entity.SmartList;
component extends="mxunit.framework.TestCase" output="false" {

	public void function the_only_required_attribute_to_use_getEntitiesArray_is_entityName() {
		var smartList = new SmartList(entityName="SlatwallProduct");
		var expected = arrayNew(1);
		var actual = smartList.getEntityArray();
		assertEquals(expected, actual);
	}

	public void function passing_a_number_in_rc_with_e_start_should_set_entityStart() {
		var smartList = new SmartList(entityName="SlatwallProduct", rc={e_start=7});
		var expected = 7;
		var actual = smartList.getEntityStart();
		assertEquals(expected, actual);
	} 
	
	public void function passing_a_number_in_rc_with_e_show_should_set_entityShow() {
		var smartList = new SmartList(entityName="SlatwallProduct", rc={e_show=12});
		var expected = 12;
		var actual = smartList.getEntityShow();
		assertEquals(expected, actual);
	}
	
	public void function if_entityShow_is_larger_than_record_array_entityEnd_should_be_set_to_arrayLen() {
		var smartList = new SmartList(entityName="SlatwallProduct", rc={e_show=12});
		var expected = 0;
		var actual = smartList.getEntityEnd();
		assertEquals(expected, actual);
	}
	
	public void function the_start_entity_must_be_numeric_otherwise_the_default_of_1_will_be_used() {
		var smartList = new SmartList(entityName="SlatwallProduct", rc={e_start="A"});
		var expected = 1;
		var actual = smartList.getEntityStart();
		assertEquals(expected, actual);
	}
	
	public void function the_end_entity_cant_be_larger_than_the_records_array() {
		var smartList = new SmartList(entityName="SlatwallProduct", rc={e_show="A"});
		var expected = 1;
		var actual = smartList.getEntityStart();
		assertEquals(expected, actual);
	}
	
}
