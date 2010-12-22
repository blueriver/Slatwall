component extends="BaseController" output="false" {

	public void function setBrandService(required any brandService) {
		variables.brandService = arguments.brandService;
	}
	
	public void function before(required struct rc) {
		param name="rc.brandID" defualt="";
		
		rc.brand = variables.brandService.getByID(ID=rc.brandID);
		if(!isDefined("rc.brand")) {
			rc.brand = variables.brandService.getNewEntity();
		}
	}
	
	public void function list(required struct rc) {
		rc.brandSmartList = variablse.brandService.getSmartList(rc=arguments.rc);
	}

	public void function update(required struct rc) {
		rc.brand = variables.fw.populate(cfc=rc.brand, keys=rc.brand.getUpdateKeys(), trim=true);
		rc.brand = variables.brandService.save(entity=rc.brand);
		variables.fw.redirect(action="brand.detail", queryString="brandID=#rc.brand.getBrandID()#");
	}
}