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
component displayname="Base Service" persistent="false" accessors="true" output="false" hint="This is a base service that all services will extend" {

	property name="entityName" type="string";
	property name="DAO" type="any";
	property name="Validator" table="Slatwall.com.utility.Validator";
	property name="fileService" type="any";
	
	public any function init() {
		return this;
	}
	
	public any function getByID(required string ID, string entityName) {
		if(isDefined("arguments.entityName")) {
			return getDAO().read(ID=arguments.ID, entityName=arguments.entityName);
		} else {
			return getDAO().read(ID=arguments.ID, entityName=getEntityName());
		}
	}
	
	public any function getByFilename(required string filename, string entityName) {
		if(isDefined("arguments.entityName")) {
			return getDAO().readByFilename(filename=arguments.filename, entityName=arguments.entityName);
		} else {
			return getDAO().readByFilename(filename=arguments.filename, entityName=getEntityName());	
		}
	}
	
	public any function getNewEntity(string entityName) {
		if(isDefined("arguments.entityName")) {
			var entity = entityNew(arguments.entityName);
			structDelete(arguments, "entityName");
		} else {
			var entity = entityNew(getEntityName());
		}
		entity.init(argumentcollection=arguments);
		return entity;
	}
	
	public any function list(string entityName) {
		if(!isDefined("arguments.entityName")) {
			arguments.entityName = getEntityName();
		}
		return getDAO().list(argumentCollection=arguments);
	}
	
	public any function getSmartList(required struct rc, string entityName){
		if(isDefined("arguments.entityName")) {
			return getDAO().getSmartList(rc=arguments.rc, entityName=arguments.entityName);
		} else {
			return getDAO().getSmartList(rc=arguments.rc, entityName=getEntityName());
		}
	}
	
	public boolean function delete(required any entity){
		var deleted = false;
		if(!arguments.entity.hasErrors()) {
			getDAO().delete(entity=arguments.entity);
			deleted = true;
		} else {
			transactionRollback();
		}
		return deleted;
	}
	
	public any function save(required any entity, struct data) {
		if(structKeyExists(arguments,"data")){
			arguments.entity.populate(arguments.data);
		}
        getValidator().validateObject(entity=arguments.entity);
		
		if(!arguments.entity.hasErrors()) {
			arguments.entity = getDAO().save(entity=arguments.entity);
		} else {
			transactionRollback();
			//trace( text="rolled back save within base service");
		}
		return arguments.entity;
	}	

}
