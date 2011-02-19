component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="brandService" type="any";

    public void function add(required struct rc) {
	   rc.brand = getBrandService().getNewEntity();
       variables.fw.setView("brand.edit");
    }
	 
    public void function list(required struct rc) {
        rc.brandSmartList = getBrandService().getSmartList(rc=arguments.rc);
    }
	
	public void function detail(required struct rc) {
	   rc.brand = getBrandService().getByID(ID=rc.brandID);
	   if(!isNull(rc.brand)) {
	       rc.itemTitle &= ": " & rc.brand.getBrandName();
	   } else {
	       variables.fw.redirect("brand.list");
	   }
	}
	
	public void function edit(required struct rc) {
	   rc.brand = getBrandService().getByID(ID=rc.brandID);
	   if(!isNull(rc.Brand)){	
			rc.itemTitle &= ": " & rc.brand.getBrandName();
		} else {
		  variables.fw.redirect("brand.list");
		}
	}

	public void function save(required struct rc) {
	   var brand = getBrandService().getByID(rc.brandID);
	   if(isNull(brand)) {
	       var brand = getBrandService().getNewEntity();
	   }
	   rc.brand = variables.fw.populate(cfc=brand, keys=brand.getUpdateKeys(), trim=true);
	   rc.brand = getBrandService().save(entity=brand);
	   variables.fw.redirect(action="admin:brand.detail", queryString="brandID=#rc.brand.getBrandID()#");
	}
	
	public void function delete(required struct rc) {
	   var brand = getBrandService().getByID(rc.brandID);
	   getBrandService().delete(brand);
	   variables.fw.redirect(action="admin:brand.list");
	}
}
