component extends="baseController" output="false" {
	
	public void function setVendorService(required any vendorService) {
		variables.vendorService = arguments.vendorService;
	}
	
	public void function before(required struct rc) {
		param name="rc.vendorID" default="";
	}
	
	public void function detail(required struct rc) {
		rc.vendor = variables.vendorService.getByID(ID=rc.vendorID);
	}
	
	public void function list(required struct rc) {
		rc.vendorSmartList = variables.vendorService.getSmartList(rc=arguments.rc);
	}
	
}