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
component displayname="Base Entity" accessors="true" extends="Slatwall.com.utility.BaseObject" {
	
	// @hint global constructor arguments.  All Extended entities should call super.init() so that this gets called
	public any function init() {
		// Place reference to mura scope in entity
		if(!structKeyExists(request, "muraScope")) {
			request.muraScope = new mura.MuraScope('default');
		}
		variables.$ = request.muraScope;
		
		return super.init();
	}
	
	// @hint public method that returns if this entity has persisted to the database yet or not.
	public boolean function isNew() {
		if(getPrimaryIDValue() == "") {
			return false;
		}
		return true;
	}
		
	// @hint public method that returns the value from the primary ID of this entity
	public string function getPrimaryIDValue() {
		return this.invokeMethod("get#getPrimaryIDPropertyName()#");
	}
	
	// @hint public method that returns the primary identifier column.  If there is no primary identifier column it throws an error
	public string function getPrimaryIDPropertyName() {
		return getService("utilityORMService").getPrimaryIDPropertyNameByEntityName( getEntityName() );
	}
	
	// @hint public method that returns and array of ID columns
	public any function getIdentifierColumnNames() {
		return getService("utilityORMService").getIdentifierColumnNamesByEntityName( getEntityName() );
	}
	
	// @hint public method that return the ID of the
	public any function getIdentifierValue() {
		var identifierColumns = getIdentifierColumnNames();
		var idValue = "";
		for(var i=1; i <= arrayLen(identifierColumns); i++){
			if(structKeyExists(variables, identifierColumns[i])) {
				idValue &= variables[identifierColumns[i]];
			}
		}
		return idValue;
	}
	
	// @hint public method that returns the full entityName as "Slatwallxxx"
	public string function getEntityName(){
		return getMetaData(this).entityname;
	}
	
	// @hint public method that overrides the standard getter so that null values won't be an issue
	public any function getCreatedDateTime() {
		if(isNull(variables.createdDateTime)) {
			return "";
		}
		return variables.createdDateTime;
	}
	
	// @hint public method that overrides the standard getter so that null values won't be an issue
	public any function getModifiedDateTime() {
		if(isNull(variables.modifiedDateTime)) {
			return "";
		}
		return variables.modifiedDateTime;
	}
	
	// Start: ORM EventHandler Methods
	public void function preInsert(){
		var timestamp = now();
		
		if(structKeyExists(this,"setCreatedDateTime")){
			this.setCreatedDateTime(timestamp);
		}
		if(structKeyExists(this,"setCreatedByAccount")){
			setCreatedByAccount(getService("SessionService").getCurrentAccount());
		}
		
		if(structKeyExists(this,"setModifiedDateTime")){
			this.setModifiedDateTime(timestamp);
		}
		if(structKeyExists(this,"setModifiedByAccount")){
			setModifiedByAccount(getService("SessionService").getCurrentAccount());
		}
		
	}
	
	public void function preUpdate(Struct oldData){
		var timestamp = now();
		
		if(structKeyExists(this,"setModifiedDateTime")){
			this.setModifiedDateTime(timestamp);
		}
		if(structKeyExists(this,"setModifiedByAccount")){
			setModifiedByAccount(getService("SessionService").getCurrentAccount());
		}
	}
	
	public void function preDelete(any entity){

	}
	
	public void function preLoad(any entity){

	}
	
	public void function postInsert(any entity){

	}
	
	public void function postUpdate(any entity){

	}
	
	public void function postDelete(any entity){

	}
	
	public void function postLoad(any entity){

	}
	// End: ORM EventHandler Methods
	
}
