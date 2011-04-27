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
	property name="attributeService" type="any";

	public void function dashboard(required struct rc) {
		getFW().redirect(action="admin:attribute.list");
	}
	
	public void function create(required struct rc) {
		rc.attributeSet = getAttributeService().getByID(rc.attributeSetID,"SlatwallAttributeSet");
		if(!isNull(rc.attributeSet)) {
			rc.newAttribute = getAttributeService().getNewEntity();
			rc.create = true;
			rc.itemTitle &= ": " & rc.attributeSet.getAttributeSetName();
			getFW().setView("attribute.edit");
		} else {
			getFW().redirect("attribute.list");
		}
	}

	public void function edit(required struct rc) {
		rc.attributeSet = getAttributeService().getByID(rc.attributeSetID,"SlatwallAttributeSet");
		if(!isNull(rc.attributeSet)) {
			rc.itemTitle &= ": " & rc.attributeSet.getAttributeSetName();
		} else {
			getFW().redirect("attribute.list");
		}
	}
	
	public void function detail(required struct rc) {
		if(len(rc.attribute.getAttributeName())) {
			rc.itemTitle &= ": #rc.attribute.getAttributeName()#";
		} else {
			getFW().redirect("admin:attribute.list");
		}
	}
	
    
    public void function list(required struct rc) {
        rc.attributeSets = getAttributeService().list(entityName="SlatwallAttributeSet",sortby="attributeSetName Asc");
    }
    
/*   public void function save() {
    	rc.optionsArray = getService("formUtilities").buildFormCollections(rc);
    }*/
	
	public void function save(required struct rc) {
		if(structKeyExists(rc,"attributeID")) {
			rc.attribute = getAttributeService().getByID(rc.attributeID);
		} else {
			rc.attribute = getAttributeService().getNewEntity();
		}
		
		rc.optionsArray = getService("formUtilities").buildFormCollections(rc).options;			
		rc.attribute = getAttributeService().saveAttribute(rc.attribute,rc);
		
		if(!rc.attribute.hasErrors()) {
			// go to the 'manage attribute set' form to add/edit more attributes
			rc.message=rc.$.Slatwall.rbKey("admin.attribute.save_success");
			getFW().redirect(action="admin:attribute.create",querystring="attributeSetID=#rc.attributeSetID#",preserve="message");
		} else {
			//put attributeSet in rc for form
			rc.attributeSet = getAttributeService().getByID(rc.attributeSetID,"SlatwallAttributeSet");
			rc.itemTitle = rc.$.Slatwall.rbKey("admin.attribute.create") & ": #rc.attributeSet.getAttributeSetName()#";
			if(rc.attribute.isNew()) {
				rc.newAttribute = rc.attribute;
				rc.create = true;
				rc.newAttributeFormOpen=true;
				getFW().setView("admin:attribute.edit");
			} else {
				rc.activeAttribute = rc.attribute;
				getFW().setView("admin:attribute.edit");
			}		
		}
	}
	
	public void function saveAttributeSort(required struct rc) {
		getAttributeService().saveAttributeSort(rc.attributeID);
		getFW().redirect("admin:attribute.list");
	}
	
	public void function delete(required struct rc) {
		var attribute = getAttributeService().getByID(rc.attributeID);
		var attributeSetID = attribute.getAttributeSet().getAttributeSetID();
		var deleteResponse = getAttributeService().delete(attribute);
		if(deleteResponse.getStatusCode()) {
			rc.message=deleteResponse.getMessage();
		} else {
			rc.message=deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype="error";
		}
		getFW().redirect(action="admin:attribute.edit", querystring="attributeSetID=#attributeSetID#",preserve="message,messagetype");
	}
	
	public void function createAttributeSet(required struct rc) {
	   rc.edit=true;
	   rc.attributeSet = getAttributeService().getNewEntity("SlatwallAttributeSet");
	   getFW().setView("admin:attribute.detailAttributeSet");
	}
	
	public void function detailAttributeSet(required struct rc) {
		rc.attributeSet = getAttributeService().getByID(rc.attributeSetID,"SlatwallAttributeSet");
		if(!isNull(rc.attributeSet) and !rc.attributeSet.isNew()) {
			rc.itemTitle &= ": #rc.attributeSet.getAttributeSetName()#";
		} else {
			getFW().redirect("admin:attribute.list");
		}
	}
	
	public void function editAttributeSet(required struct rc) {
		rc.edit=true;
		rc.attributeSet = getAttributeService().getByID(rc.attributeSetID,"SlatwallAttributeSet");
		if(!isNull(rc.attributeSet)) {
			if( len(rc.attributeSet.getAttributeSetName()) ) {
				rc.itemTitle &= ": #rc.attributeSet.getAttributeSetName()#";
			}
			getFW().setView("admin:attribute.detailAttributeSet");
		} else
		  getFW().redirect("admin:attribute.list");
	}

	public void function saveAttributeSet(required struct rc) {
		if(len(trim(rc.attributeSetID))) {
			rc.attributeSet = getAttributeService().getByID(rc.attributeSetID,"SlatwallAttributeSet");
		} else {
			rc.attributeSet = getAttributeService().getNewEntity("SlatwallAttributeSet");
		}
		
		rc.attributeSet = getAttributeService().save(rc.attributeSet,rc);
		
		if(!rc.attributeSet.hasErrors()) {
			// go to the 'manage attribute set' form to add attributes
			rc.message=rc.$.Slatwall.rbKey("admin.attribute.saveAttributeSet_success");
			getFW().redirect(action="admin:attribute.create",querystring="attributeSetID=#rc.attributeSet.getAttributeSetID()#",preserve="message");
		} else {
			rc.edit = true;
			rc.itemTitle = rc.AttributeSet.isNew() ? rc.$.Slatwall.rbKey("admin.attribute.createAttributeSet") : rc.$.Slatwall.rbKey("admin.attribute.editAttributeSet") & ": #rc.attributeSet.getAttributeSetName()#";
			getFW().setView(action="admin:attribute.detailAttributeSet");
		}
	}

	public void function saveAttributeSetSort(required struct rc) {
		getAttributeService().saveAttributeSetSort(rc.attributeSetID);
		getFW().redirect("admin:attribute.list");
	}
	
	public void function deleteAttributeSet(required struct rc) {
		var attributeSet = getAttributeService().getByID(rc.attributeSetID,"SlatwallAttributeSet");
		var deleteResponse = getAttributeService().deleteAttributeSet(attributeSet);
		if(deleteResponse.getStatusCode()) {
			rc.message = deleteResponse.getMessage();
		} else {
			rc.message = deleteResponse.getData().getErrorBean().getError("delete");
			rc.messagetype = "error";
		}
		getFW().redirect(action="admin:attribute.list",preserve="message,messagetype");
	}
	
	public void function deleteAttributeOption(required struct rc) {
		param name="rc.asynch" default="false";
		var attributeOption = getAttributeService().getByID(rc.attributeOptionID,"SlatwallAttributeOption");
		if(!isNull(attributeOption)) {
			var deleteResponse = getAttributeService().delete(attributeOption);
			if( deleteResponse.getStatusCode() ) {
				rc.success=1;
				rc.message=deleteResponse.getMessage();
			} else {
				rc.success=0;
				rc.message=deleteResponse.getData().getErrorBean().getError("delete");
			}
		}
	}
	
}
