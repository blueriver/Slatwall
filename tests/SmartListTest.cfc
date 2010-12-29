component extends="mxunit.framework.TestCase" output="false" {

	public void function convert_order_columns_to_array() {
		var rc = structNew();
		rc.OrderBy = "PRODUCTName|A^productcode|D^productYEAR|A";
		var SmartList = new Slatwall.com.entity.SmartList(rc=rc, entityName="SlatwallProduct");
		var expected = arrayNew(1);
		expected[1] = "productName|A";
		expected[2] = "productCode|D";
		expected[3] = "productYear|A";
		assertEquals(expected, SmartList.getOrders());
	}
	
	public void function convert_order_columns_to_array_with_keyword() {
		var rc = structNew();
		rc.OrderBy = "PRODUCTName|A^productcode|D^productYEAR|A";
		rc.Keyword = "This Is My Test Keyword";
		var SmartList = new Slatwall.com.entity.SmartList(rc=rc, entityName="SlatwallProduct");
		var expected = arrayNew(1);
		expected[1] = "searchScore|D";
		expected[2] = "productName|A";
		expected[3] = "productCode|D";
		expected[4] = "productYear|A";
		assertEquals(expected, SmartList.getOrders());
	}
	
	public void function add_order_column_into_a_higer_index_then_arrayLen() {
		var rc = structNew();
		rc.OrderBy = "PRODUCTName|A^productcode|D^productYEAR|A";
		var smartList = new Slatwall.com.entity.SmartList(rc=rc, entityName="SlatwallProduct");
		smartList.addOrder(propertyOrder="productName|D", position=8);
		var expected = 1;
		var actual = arrayLen(smartList.getOrders());
		
		assertEquals(4, arrayLen(SmartList.getOrders()));
	}
	
	public void function all_orders_need_pipeA_or_pipeD_as_2nd_to_last_char() {
		var rc = structNew();
		rc.OrderBy = "PRODUCTName^produ|ctcode|D^productYEAR";
		rc.Keyword = "Gregs | Test";
		var smartList = new Slatwall.com.entity.SmartList(rc=rc, entityName="SlatwallProduct");
		var orders = smartList.getOrders();
		for(var i=1; i <= arrayLen(orders); i++) {
			assert(Find("|", orders[i]) == Len(orders[i])-1, "Only One Pipe Exists");
			assert("|a" == Right(orders[i], 2) || "|d" == Right(orders[i], 2), "Works");
		}
	}
	
}
