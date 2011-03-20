component extends="BaseController" persistent="false" accessors="true" output="false" {

	// fw1 Auto-Injected Service Properties
	property name="brandService" type="any";
	
	public void function dashboard(required struct rc) {
		getFW().redirect("admin:brand.list");
	}

    public void function create(required struct rc) {
	   rc.brand = getBrandService().getNewEntity();
       getFW().setView("brand.edit");
    }

	public void function detail(required struct rc) {
	   rc.brand = getBrandService().getByID(ID=rc.brandID);
	   if(!isNull(rc.brand) and !rc.brand.isNew()) {
	       rc.itemTitle &= ": " & rc.brand.getBrandName();
	   } else {
	       getFW().redirect("brand.list");
	   }
	}

	public void function edit(required struct rc) {
		if(!structKeyExists(rc,"brand") or !isObject(rc.brand)) {
			rc.brand = getBrandService().getByID(ID=rc.brandID);
		}
	   if(!isNull(rc.Brand)) {	
			rc.itemTitle &= ": " & rc.brand.getBrandName();
		} else {
		  getFW().redirect("brand.list");
		}
	}
	 
    public void function list(required struct rc) {
		//param name="rc.orderby" default="brandName|A";
        //rc.brandSmartList = getBrandService().getSmartList(rc=arguments.rc);
		rc.brands = getBrandService().list(sortOrder = "brandName ASC");
    }

	public void function save(required struct rc) {
	   rc.brand = getBrandService().getByID(rc.brandID);
	   if(isNull(rc.brand)) {
	       rc.brand = getBrandService().getNewEntity();
	   }
	   rc.brand = getBrandService().save(rc.brand,rc);
	   if(!rc.brand.hasErrors()) {
	   		getFW().redirect(action="admin:brand.list",querystring="message=admin.brand.save_success");
		} else {
	   		getFW().redirect(action="admin:brand.edit", preserve="brand");
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
		getFW().redirect(action="admin:brand.list",preserve="message,messagetype");
	}
}