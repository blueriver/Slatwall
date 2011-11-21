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
component output="false" accessors="true" extends="Slatwall.com.utility.BaseObject" {
	
	public any function init() {
		return this;
	}
	
	public any function get( required string entityName, required any idOrFilter, boolean isReturnNewOnNotFound = false ) {
		// Adds the Slatwall Prefix to the entityName when needed.
		if(left(arguments.entityName,8) != "Slatwall") {
			arguments.entityName = "Slatwall#arguments.entityName#";
		}
		
		if ( isSimpleValue( idOrFilter ) && len( idOrFilter ) && idOrFilter != 0 ) {
			var entity = entityLoadByPK( entityName, idOrFilter );
		} else if ( isStruct( idOrFilter ) ){
			var entity = entityLoad( entityName, idOrFilter, true );
		}
		
		if ( !isNull( entity ) ) {
			return entity;
		}

		if ( isReturnNewOnNotFound ) {
			return new( entityName );
		}
	}

	function list( string entityName, struct filterCriteria = {}, string sortOrder = '', struct options = {} ) {
		// Adds the Slatwall Prefix to the entityName when needed.
		if(left(arguments.entityName,8) != "Slatwall") {
			arguments.entityName = "Slatwall#arguments.entityName#";
		}
		
		return entityLoad( entityName, filterCriteria, sortOrder, options );
	}


	function new( required string entityName ) {
		// Adds the Slatwall Prefix to the entityName when needed.
		if(left(arguments.entityName,8) != "Slatwall") {
			arguments.entityName = "Slatwall#arguments.entityName#";
		}
		
		return entityNew( entityName );
	}


	function save( required target ) {
		entitySave( target );
		return target;
	}
	
	public void function delete(required target) {
		if(isArray(target)) {
			for(var object in target) {
				delete(object);
			}
		} else {
			entityDelete(target);	
		}
	}
	
	public void function reloadEntity(required any entity) {
    	entityReload(arguments.entity);
    }
    
    public void function flushORMSession() {
    	ormFlush();
    }
	
	public any function getSmartList(required string entityName, struct data={}){
		// Adds the Slatwall Prefix to the entityName when needed.
		if(left(arguments.entityName,8) != "Slatwall") {
			arguments.entityName = "Slatwall#arguments.entityName#";
		}
		
		var smartList = new Slatwall.org.entitySmartList.SmartList(argumentCollection=arguments);
	
		return smartList;
	}
	
	// @hint checks whether another entity has the same value for the given property
	public boolean function isDuplicateProperty( required string propertyName, required any entity ) {
		var entityName = arguments.entity.getEntityName();
		var idValue = evaluate("arguments.entity.get#replaceNoCase(entityName,'Slatwall','','one')#ID()");
		var propertyValue = evaluate("arguments.entity.get#arguments.propertyName#()");
		return arrayLen(ormExecuteQuery("from #entityName# e where e.#arguments.propertyName# = :propValue and e.id != :entityID", {propValue=propertyValue, entityID=idValue}));
	}
	
	
}
