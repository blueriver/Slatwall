component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="brandService" type="any";
	
	public void function before(required struct rc) {
		param name="rc.brandID" default="";
		
		rc.sectionTitle = rc.$w.rbKey("admin.brand");
		rc.brand = getBrandService().getByID(ID=rc.brandID);
		if(!isDefined("rc.brand")) {
			rc.brand = getBrandService().getNewEntity();
		}
	}

    public void function add(required struct rc) {
       variables.fw.setView("admin:brand.edit");
    }
	 
    public void function list(required struct rc) {
        rc.brandSmartList = getBrandService().getSmartList(rc=arguments.rc);
    }
	
	public void function detail(required struct rc) {
		if(len(rc.brand.getBrandName()))
			rc.itemTitle &= ": " & rc.brand.getBrandName();
		else
			variables.fw.redirect("brand.list");
	}
	
	public void function edit(required struct rc) {
		if(len(rc.brand.getBrandName()))
			rc.itemTitle &= ": " & rc.brand.getBrandName();
		else
		  variables.fw.redirect("admin:brand.add");
	}

	public void function update(required struct rc) {
		rc.brand = variables.fw.populate(cfc=rc.brand, keys=rc.brand.getUpdateKeys(), trim=true);
		rc.brand = getBrandService().save(entity=rc.brand);
		variables.fw.redirect(action="admin:brand.detail", queryString="brandID=#rc.brand.getBrandID()#");
	}
	
	public void function delete(required struct rc) {
		getBrandService().delete(entity=rc.brand);
		variables.fw.redirect(action="admin:brand.list");
	}
}
