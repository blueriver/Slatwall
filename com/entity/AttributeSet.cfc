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
component displayname="AttributeSet" entityname="SlatwallAttributeSet" table="SlatwallAttributeSet" persistent="true" output="false" accessors="true" extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="attributeSetID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="attributeSetName" ormtype="string";
	property name="attributeSetDescription" ormtype="string" length="2000" ;
	property name="globalFlag" ormtype="boolean" default="false" ;
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID" constrained="false";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID" constrained="false";
	
	// Related Object Properties
	property name="attributeSetType" cfc="Type" fieldtype="many-to-one" fkcolumn="attributeSetTypeID" hint="This is used to define if this attribute is applied to a profile, account, product, ext";
	property name="attributes" singularname="attribute" cfc="Attribute" fieldtype="one-to-many" fkcolumn="attributeSetID" inverse="true" cascade="all";
	property name="attributeSetAssignments" singularname="attributeSetAssignment" cfc="AttributeSetAssignment" fieldtype="one-to-many" fkcolumn="attributeSetID" inverse="true" cascade="all";
	
	
    /******* Association management methods for bidirectional relationships **************/
	
	// Attribute (one-to-many)
	
	public void function addAttribute(required Attribute attribute) {
	   arguments.attribute.setAttributeSet(this);
	}
	
	public void function removeAttribute(required Attribute attribute) {
	   arguments.attribute.removeAttributeSet(this);
	}
	
	// Attribute Set Assignment (one-to-many)
	
	public void function addAttributeSetAssignment(required AttributeSetAssignment attributeSetAssignment) {
	   arguments.attributeSetAssignment.setAttributeSet(this);
	}
	
	public void function removeAttributeSetAssignment(required AttributeSetAssignment attributeSetAssignment) {
	   arguments.attributeSetAssignment.removeAttributeSet(this);
	}
	
    /************   END Association Management Methods   *******************/
    
    public array function getAttributeSetTypeOptions() {
		if(!structKeyExists(variables, "attributeSetTypeOptions")) {
			var smartList = new Slatwall.com.utility.SmartList(entityName="SlatwallType");
			smartList.addSelect(rawProperty="type", alias="name");
			smartList.addSelect(rawProperty="typeID", alias="id");
			// TODO: fix this filter bug in smartlist
			smartList.addFilter(rawProperty="parentType_systemCode", value="attributeSetType", entity="Type");
			smartList.addOrder("type|ASC");
			
			variables.attributeSetTypeOptions = smartList.getRecords();
		}
		return variables.attributeSetTypeOptions;
    }

}
