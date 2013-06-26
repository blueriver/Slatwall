component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {
	
	// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		super.setup();
		
		variables.hibachiReport = request.slatwallScope.getTransient( "HibachiReport" ).init();
	}
	
	public any function instantiation_test() {
		var c = ormGetSession().createCriteria('SlatwallOrder', 'order');
		var p = createObject("java","org.hibernate.criterion.Projections");
		var pList = p.projectionList();
		
		c.createAlias("order.orderOrigin", "orderorigin", c.LEFT_JOIN); // inner join by default
		
		pList.add( p.rowCount() );
        pList.add( p.avg("calculatedTotal") );
        pList.add( p.sqlGroupProjection("DATEPART") );
        //pList.add( p.groupProperty("orderorigin.orderOriginName") );
		c.setProjection( pList );
		
		debug(var=c.list());
		debug(var=p);
		debug(var=c);
		
		
		//debug(var=c.list(), top=1);
	}
	
	
}