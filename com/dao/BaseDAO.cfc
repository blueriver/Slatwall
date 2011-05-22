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
component output="false" {
	
	public any function init() {
		return this;
	}
	
	// @hint checks whether another entity has the same value for the given property
	public boolean function isDuplicateProperty( required string propertyName, required any entity ) {
		var entityName = arguments.entity.getClassName();
		var idValue = evaluate("arguments.entity.get#replaceNoCase(entityName,'Slatwall','','one')#ID()");
		var propertyValue = evaluate("arguments.entity.get#arguments.propertyName#()");
		return arrayLen(ormExecuteQuery("from #entityName# e where e.#arguments.propertyName# = :propValue and e.id != :entityID", {propValue=propertyValue, entityID=idValue}));
	}

	public any function getSmartList(required string entityName, struct data={}){
		var smartList = new Slatwall.com.utility.SmartList(entityName=arguments.entityName, data=arguments.data);
	
		return smartList;
	}
	
	/**
	 * Provides dynamic methods, by convention, on missing method:
	 *
	 *   newXXX()
	 *
	 *   saveXXX( required any xxxEntity )
	 *
	 *   deleteXXX( required any xxxEntity )
	 *
	 *   getXXX( required any ID, boolean isReturnNewOnNotFound = false )
	 *
	 *   getXXXByYYY( required any yyyFilterValue, boolean isReturnNewOnNotFound = false )
	 *
	 *   listXXX( struct filterCriteria, string sortOrder, struct options )
	 *
	 *   listXXXFilterByYYY( required any yyyFilterValue, string sortOrder, struct options )
	 *
	 *   listXXXOrderByZZZ( struct filterCriteria, struct options )
	 *
	 *   listXXXFilterByYYYOrderByZZZ( required any yyyFilterValue, struct options )
	 *
	 * ...in which XXX is an ORM entity name, and YYY and ZZZ are entity property names.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	function onMissingMethod( required string missingMethodName, required struct missingMethodArguments ) {
		var lCaseMissingMethodName = lCase( missingMethodName );

		writeDump(var=missingMethodArguments, label="missingMethodDAO");
		
		if ( lCaseMissingMethodName.startsWith( 'get' ) ) {
			return onMissingGetMethod( missingMethodName, missingMethodArguments );
		} else if ( lCaseMissingMethodName.startsWith( 'new' ) ) {
			return onMissingNewMethod( missingMethodName, missingMethodArguments );
		} else if ( lCaseMissingMethodName.startsWith( 'list' ) ) {
			return onMissingListMethod( missingMethodName, missingMethodArguments );
		} else if ( lCaseMissingMethodName.startsWith( 'save' ) ) {
			return onMissingSaveMethod( missingMethodName, missingMethodArguments );
		} else if ( lCaseMissingMethodName.startsWith( 'delete' ) )	{
			return onMissingDeleteMethod( missingMethodName, missingMethodArguments );
		}

		throw( 'No matching method for #missingMethodName#().' );
	}
	
	
	
	function delete(required target) {
		if(isArray(target)) {
			for(var object in target) {
				delete(object);
			}
		}
		entityDelete(target);
	}


	function get( required string entityName, required any idOrFilter, boolean isReturnNewOnNotFound = false ) {
		// Add Slatwall Prefix If Needed
		if(left(arguments.entityName,8) != "Slatwall") {
			arguments.entityName = "Slatwall" & arguments.entityName;
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


	function list( required string entityName, struct filterCriteria = {}, string sortOrder = '', struct options = {} ) {
		// Add Slatwall Prefix If Needed
		if(left(arguments.entityName,8) != "Slatwall") {
			arguments.entityName = "Slatwall" & arguments.entityName;
		}
		
		return entityLoad( entityName, filterCriteria, sortOrder, options );
	}


	function new( required string entityName ) {
		// Add Slatwall Prefix If Needed
		if(left(arguments.entityName,8) != "Slatwall") {
			arguments.entityName = "Slatwall" & arguments.entityName;
		}
		
		return entityNew( entityName );
	}


	function save( required target ) {
		if ( isArray( target ) ) {
			for ( var object in target ) {
				save( object );
			}
		}

		entitySave( target );
		
		return target;
	}


	/********** PRIVATE ************************************************************/


	private function onMissingDeleteMethod( required string missingMethodName, required struct missingMethodArguments ) {
		return delete( missingMethodArguments[ 1 ] );
	}


	/**
	 * Provides dynamic get methods, by convention, on missing method:
	 *
	 *   getXXX( required any ID, boolean isReturnNewOnNotFound = false )
	 *
	 *   getXXXByYYY( required any yyyFilterValue, boolean isReturnNewOnNotFound = false )
	 *
	 * ...in which XXX is an ORM entity name, and YYY is an entity property name.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	private function onMissingGetMethod( required string missingMethodName, required struct missingMethodArguments ){
		var isReturnNewOnNotFound = structKeyExists( missingMethodArguments, '2' ) ? missingMethodArguments[ 2 ] : false;

		var entityName = missingMethodName.substring( 3 );

		writeDump(entityName);
		writeDump(arguments);
		writeDump(isReturnNewOnNotFound);
		abort;

		if ( entityName.matches( '(?i).+by.+' ) ) {
			var tokens = entityName.split( '(?i)by', 2 );
			entityName = tokens[ 1 ];
			var filter = { '#tokens[ 2 ]#' = missingMethodArguments[ 1 ] };
			return get( entityName, filter, isReturnNewOnNotFound );
		} else {
			var id = missingMethodArguments[ 1 ];
			return get( entityName, id, isReturnNewOnNotFound );
		}
	}


	/**
	 * Provides dynamic list methods, by convention, on missing method:
	 *
	 *   listXXX( struct filterCriteria, string sortOrder, struct options )
	 *
	 *   listXXXFilterByYYY( required any yyyFilterValue, string sortOrder, struct options )
	 *
	 *   listXXXOrderByZZZ( struct filterCriteria, struct options )
	 *
	 *   listXXXFilterByYYYOrderByZZZ( required any yyyFilterValue, struct options )
	 *
	 * ...in which XXX is an ORM entity name, and YYY and ZZZ are entity property names.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	private function onMissingListMethod( required string missingMethodName, required struct missingMethodArguments ){
		var listMethodForm = 'listXXX';

		if ( findNoCase( 'FilterBy', missingMethodName ) ) {
			listMethodForm &= 'FilterByYYY';
		}

		if ( findNoCase( 'OrderBy', missingMethodName ) ) {
			listMethodForm &= 'OrderByZZZ';
		}

		switch( listMethodForm ) {
			case 'listXXX':
				return onMissingListXXXMethod( missingMethodName, missingMethodArguments );

			case 'listXXXFilterByYYY':
				return onMissingListXXXFilterByYYYMethod( missingMethodName, missingMethodArguments );

			case 'listXXXOrderByZZZ':
				return onMissingListXXXOrderByZZZMethod( missingMethodName, missingMethodArguments );

			case 'listXXXFilterByYYYOrderByZZZ':
				return onMissingListXXXFilterByYYYOrderByZZZMethod( missingMethodName, missingMethodArguments );
		}
	}


	/**
	 * Provides dynamic list method, by convention, on missing method:
	 *
	 *   listXXX( struct filterCriteria, string sortOrder, struct options )
	 *
	 * ...in which XXX is an ORM entity name.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	private function onMissingListXXXMethod( required string missingMethodName, required struct missingMethodArguments ) {
		var listArgs = {};

		listArgs.entityName = missingMethodName.substring( 4 );

		if ( structKeyExists( missingMethodArguments, '1' ) ) {
			listArgs.filterCriteria = missingMethodArguments[ '1' ];

			if ( structKeyExists( missingMethodArguments, '2' ) ) {
				listArgs.sortOrder = missingMethodArguments[ '2' ];

				if ( structKeyExists( missingMethodArguments, '3' ) ) {
					listArgs.options = missingMethodArguments[ '3' ];
				}
			}
		}

		return list( argumentCollection = listArgs );
	}


	/**
	 * Provides dynamic list method, by convention, on missing method:
	 *
	 *   listXXXFilterByYYY( required any yyyFilterValue, string sortOrder, struct options )
	 *
	 * ...in which XXX is an ORM entity name, and YYY is an entity property name.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	private function onMissingListXXXFilterByYYYMethod( required string missingMethodName, required struct missingMethodArguments )
	{
		var listArgs = {};

		var temp = missingMethodName.substring( 4 );

		var tokens = temp.split( '(?i)FilterBy', 2 );

		listArgs.entityName = tokens[ 1 ];

		listArgs.filterCriteria = { '#tokens[ 2 ]#' = missingMethodArguments[ 1 ] };

		if ( structKeyExists( missingMethodArguments, '2' ) )
		{
			listArgs.sortOrder = missingMethodArguments[ '2' ];

			if ( structKeyExists( missingMethodArguments, '3' ) )
			{
				listArgs.options = missingMethodArguments[ '3' ];
			}
		}

		return list( argumentCollection = listArgs );
	}


	/**
	 * Provides dynamic list method, by convention, on missing method:
	 *
	 *   listXXXFilterByYYYOrderByZZZ( required any yyyFilterValue, struct options )
	 *
	 * ...in which XXX is an ORM entity name, and YYY and ZZZ are entity property names.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	private function onMissingListXXXFilterByYYYOrderByZZZMethod( required string missingMethodName, required struct missingMethodArguments )
	{
		var listArgs = {};

		var temp = missingMethodName.substring( 4 );

		var tokens = temp.split( '(?i)FilterBy', 2 );

		listArgs.entityName = tokens[ 1 ];

		tokens = tokens[ 2 ].split( '(?i)OrderBy', 2 );

		listArgs.filterCriteria = { '#tokens[ 1 ]#' = missingMethodArguments[ 1 ] };

		listArgs.sortOrder = tokens[ 2 ];

		if ( structKeyExists( missingMethodArguments, '2' ) )
		{
			listArgs.options = missingMethodArguments[ '2' ];
		}

		return list( argumentCollection = listArgs );
	}


	/**
	 * Provides dynamic list method, by convention, on missing method:
	 *
	 *   listXXXOrderByZZZ( struct filterCriteria, struct options )
	 *
	 * ...in which XXX is an ORM entity name, and ZZZ is an entity property name.
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	private function onMissingListXXXOrderByZZZMethod( required string missingMethodName, required struct missingMethodArguments )
	{
		var listArgs = {};

		var temp = missingMethodName.substring( 4 );

		var tokens = temp.split( '(?i)OrderBy', 2 );

		listArgs.entityName = tokens[ 1 ];

		listArgs.sortOrder = tokens[ 2 ];

		if ( structKeyExists( missingMethodArguments, '1' ) )
		{
			listArgs.filterCriteria = missingMethodArguments[ '1' ];

			if ( structKeyExists( missingMethodArguments, '2' ) )
			{
				listArgs.options = missingMethodArguments[ '2' ];
			}
		}

		return list( argumentCollection = listArgs );
	}


	private function onMissingNewMethod( required string missingMethodName, required struct missingMethodArguments )
	{
		var entityName = missingMethodName.substring( 3 );

		return new( entityName );
	}


	private function onMissingSaveMethod( required string missingMethodName, required struct missingMethodArguments )
	{
		return save( missingMethodArguments[ 1 ] );
	}
	
	
	/*
	public any function read(required string ID, required string entityName) {
		return entityLoad(arguments.entityName, arguments.ID, true);
	}
	
	public any function readByFilename(required string filename, required string entityName){
		return ormExecuteQuery(" from #arguments.entityName# where filename = :filename", {filename=arguments.filename}, true);
	}
	
	public any function readByRemoteID(required string remoteID, required string entityName){
		return ormExecuteQuery(" from #arguments.entityName# where remoteID = :remoteID", {remoteID=arguments.remoteID}, true);
	}
	
	public array function list(required string entityName,struct filterCriteria=structNew(),string sortBy="") {
		if(structIsEmpty(arguments.filterCriteria) and !len("arguments.sortby")) {
			return entityLoad(arguments.entityName);
		} else {
			return entityLoad(arguments.entityName,arguments.filterCriteria,arguments.sortby);
		}
	}
	
	public void function delete(required any entity) {
		EntityDelete(arguments.entity);
	}
	
	public any function save(required any entity) {
		EntitySave(arguments.entity);
		return arguments.entity;
	}
	
	*/
	
}
