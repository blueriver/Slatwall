component extends="mxunit.framework.TestCase" output="false" {

	// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		variables.slatwallFW1Application = createObject("component", "Slatwall.Application");
		variables.slatwallFW1Application.setupRequest();
	}
	
	// @hint put things in here that you want to run after EACH test
	public void function tearDown() {
		//variables.slatwallFW1Application.endSlatwallLifecycle();
	}
	
	
}