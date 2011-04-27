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
component displayname="Attribute" entityname="SlatwallAttribute" table="SlatwallAttribute" persistent="true" output="false" accessors="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="attributeID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="attributeName" ormtype="string" validateRequired;
	property name="attributeDescription" ormtype="string" length="4000" ;
	property name="attributeHint" ormtype="string";
	property name="defaultValue" ormtype="string";
	property name="requiredFlag" ormtype="boolean" default="false" ;
	property name="sortOrder" ormtype="integer";
	property name="validationMessage" ormtype="string";
	property name="validationRegex" ormtype="string";
	property name="activeFlag" ormtype="boolean";

	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
	
	// Related Object Properties
	property name="attributeType" cfc="Type" fieldtype="many-to-one" fkcolumn="attributeTypeID" validateRequired hint="This is used to define how the UI for the attribute looks example: text, radio, wysiwyg, checkbox";
	property name="attributeSet" cfc="AttributeSet" fieldtype="many-to-one" fkcolumn="attributeSetID";
	property name="attributeOptions" singularname="attributeOption" cfc="AttributeOption" fieldtype="one-to-many" fkcolumn="attributeID" inverse="true" cascade="all" orderby="sortOrder" ;
	property name="validationType" cfc="Type" fieldtype="many-to-one" fkcolumn="validationTypeID" hint="This is used to define validation for attribute example: Numeric, date, regex etc.";


	public Attribute function init(){
	   // set default collections for association management methods
	   if(isNull(variables.attributeOptions)) {
	       variables.attributeOptions = [];
	   }
	   return Super.init();
	}

	public array function getAttributeOptions(sortby, sortType="text", direction="asc") {
		if(!structKeyExists(arguments,"sortby")) {
			return variables.AttributeOptions;
		} else {
			return sortObjectArray(variables.AttributeOptions,arguments.sortby,arguments.sortType,arguments.direction);
		}
	}
	
	/******* Association management methods for bidirectional relationships **************/
	
	// Attribute Set (many-to-one)
	
	public void function setAttributeSet(required AttributeSet attributeSet) {
		variables.attributeSet = arguments.attributeSet;
		if(!arguments.AttributeSet.hasAttribute(this)) {
		   arrayAppend(arguments.AttributeSet.getAttributes(),this);
		}
	}
	
	public void function removeAttributeSet(required AttributeSet attributeSet) {
		var index = arrayFind(arguments.attributeSet.getAttributes(),this);
		if(index > 0) {
		   arrayDeleteAt(arguments.attributeSet.getAttributes(),index);
		}    
		structDelete(variables,"attributeSet");
    }
    
	// Attribute Options (one-to-many)
	
	public void function addAttributeOption(required any attributeOption) {
	   arguments.AttributeOption.setAttribute(this);
	}
	
	public void function removeAttributeOption(required any attributeOption) {
	   arguments.attributeOption.removeAttribute(this);
	}
	
	/************   END Association Management Methods   *******************/

    public array function getAttributeTypeOptions() {
		if(!structKeyExists(variables, "attributeTypeOptions")) {
			var smartList = new Slatwall.com.utility.SmartList(entityName="SlatwallType");
			smartList.addSelect(rawProperty="type", alias="name");
			smartList.addSelect(rawProperty="typeID", alias="id");
			smartList.addFilter(rawProperty="parentType_systemCode", value="attributeType"); 
			smartList.addOrder("type|ASC");
			variables.attributeTypeOptions = smartList.getRecords();
		}
		return variables.attributeTypeOptions;
    }
   
    public array function getValidationTypeOptions() {
		if(!structKeyExists(variables, "validationTypeOptions")) {
			var smartList = new Slatwall.com.utility.SmartList(entityName="SlatwallType");
			smartList.addSelect(rawProperty="type", alias="name");
			smartList.addSelect(rawProperty="typeID", alias="id");
			smartList.addFilter(rawProperty="parentType_systemCode", value="validationType"); 
			variables.validationTypeOptions = smartList.getRecords();
		}
		return variables.validationTypeOptions;
    }
}
