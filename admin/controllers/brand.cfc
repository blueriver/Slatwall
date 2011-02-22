component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="brandService" type="any";
	
	public void function dashboard(required struct rc) {
		variables.fw.redirect("admin:brand.list");
	}

    public void function create(required struct rc) {
	   rc.brand = getBrandService().getNewEntity();
       variables.fw.setView("brand.edit");
    }

	public void function detail(required struct rc) {
	   rc.brand = getBrandService().getByID(ID=rc.brandID);
	   if(!isNull(rc.brand) and !rc.brand.isNew()) {
	       rc.itemTitle &= ": " & rc.brand.getBrandName();
	   } else {
	       variables.fw.redirect("brand.list");
	   }
	}

	public void function edit(required struct rc) {
		if(!structKeyExists(rc,"brand") or !isObject(rc.brand)) {
			rc.brand = getBrandService().getByID(ID=rc.brandID);
		}
	   if(!isNull(rc.Brand)) {	
			rc.itemTitle &= ": " & rc.brand.getBrandName();
		} else {
		  variables.fw.redirect("brand.list");
		}
	}
	 
    public void function list(required struct rc) {
		param name="rc.orderby" default="brandName|A";
        rc.brandSmartList = getBrandService().getSmartList(rc=arguments.rc);
    }

	public void function save(required struct rc) {
	   var brand = getBrandService().getByID(rc.brandID);
	   if(isNull(brand)) {
	       var brand = getBrandService().getNewEntity();
	   }
	   rc.brand = variables.fw.populate(cfc=brand, keys=brand.getUpdateKeys(), trim=true);
	   rc.brand = getBrandService().save(entity=brand);
	   if(!rc.brand.hasErrors()) {
	   		variables.fw.redirect(action="admin:brand.list",querystring="message=admin.brand.save_success");
		} else {
	   		variables.fw.redirect(action="admin:brand.edit", preserve="brand");
		}
	}
	
	public void function delete(required struct rc) {
		var brand = getBrandService().getByID(rc.brandID);
		if(!brand.getIsAssigned()) {
			getBrandService().delete(brand);
			rc.message="admin.brand.delete_success";
		} else {
			rc.message="admin.brand.delete_isassigned";
			rc.messagetype="warning";
		}	   
		variables.fw.redirect(action="admin:brand.list",preserve="message,messagetype");
	}
}