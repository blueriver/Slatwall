/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
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
	   rc.brand = getBrandService().getByID(ID=rc.brandID);
	   if(!isNull(rc.Brand)) {	
			rc.itemTitle &= ": " & rc.brand.getBrandName();
		} else {
		  getFW().redirect("brand.list");
		}
	}
	 
    public void function list(required struct rc) {
		//param name="rc.orderby" default="brandName|A";
        //rc.brandSmartList = getBrandService().getSmartList(rc=arguments.rc);
		rc.brands = getBrandService().list(sortBy = "brandName ASC");
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
			rc.itemTitle = rc.brand.isNew() ? rc.$.Slatwall.rbKey("admin.brand.create") : rc.$.Slatwall.rbKey("admin.brand.edit") & ": #rc.brand.getBrandName()#";
	   		getFW().setView(action="admin:brand.edit");
		}
	}
	
	public void function delete(required struct rc) {
		var brand = getBrandService().getByID(rc.brandID);
		var deleteResponse = getBrandService().delete(brand);
		if(deleteResponse.getStatusCode()) {
			rc.message=deleteResponse.getMessage();
		} else {
			rc.message=deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype="error";
		}	   
		getFW().redirect(action="admin:brand.list",preserve="message,messagetype");
	}
}
