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
component displayname="Base Service" persistent="false" accessors="true" output="false" extends="Slatwall.com.utility.BaseObject" hint="This is a base service that all services will extend" {

	property name="DAO" type="any";
	property name="requestCacheService" type="any";
	
	public any function init() {
		return super.init();
	}
	
	public any function get(required string entityName, required any idOrFilter, boolean isReturnNewOnNotFound = false ) {
		return getDAO().get(argumentcollection=arguments);
	}

	public any function list(required string entityName, struct filterCriteria = {}, string sortOrder = '', struct options = {} ) {
		return getDAO().list(argumentcollection=arguments);
	}

	public any function new(required string entityName ) {
		return getDAO().new(argumentcollection=arguments);
	}

	public any function getSmartList(string entityName, struct data={}){
		return getDAO().getSmartList(argumentcollection=arguments);
	}
	
	public boolean function delete(required any entity, string context="delete"){
		
		// Validate that this entity can be deleted
		arguments.entity.validate(context=arguments.entity.getValidationContext( arguments.context ));
		
		// If the entity Passes validation
		if(!arguments.entity.hasErrors()) {
			
			// Call delete in the DAO
			getDAO().delete(target=arguments.entity);
			
			// Return that the delete was sucessful
			return true;
			
		}
			
		// Setup ormHasErrors because it didn't pass validation
		getService("requestCacheService").setValue("ormHasErrors", true);

		return false;
	}
	
	// @hint the default save method will populate, validate, and if not errors delegate to the DAO where entitySave() is called.
    public any function save(required any entity, struct data, string context="save") {
    	// Run the save in a Try/Catch block to handle issues with incorrect objects being passed in
    	try{
    		// If data was passed in to this method then populate it with the new data
	        if(structKeyExists(arguments,"data")){
	        	
	        	// Populate this object
				arguments.entity.populate(argumentCollection=arguments);
				
			    // Validate this object now that it has been populated
			    arguments.entity.validate(context=arguments.entity.getValidationContext( arguments.context ));    
	        }
	        
	        // If the object passed validation then call save in the DAO, otherwise set the errors flag
	        if(!arguments.entity.hasErrors()) {
	            arguments.entity = getDAO().save(target=arguments.entity);
	        } else {
	            getService("requestCacheService").setValue("ormHasErrors", true);
	        }

	        // Return the entity
	        return arguments.entity;
		} catch (any e) {
			throw("The entity being passed to this service is not a persistent entity. Make sure that you aren't calling the oMM method with named arguments. Also, make sure to check the spelling of your 'fieldname' attributes.");
		}
    }
    
    
 	/**
	 * Generic ORM CRUD methods and dynamic methods by convention via onMissingMethod.
	 *
	 * See all onMissing* method comments and other method signatures for usage.
	 *
	 * CREDIT:
	 *   Heavily influenced by ColdSpring 2.0-pre-alpha's coldspring.orm.hibernate.AbstractGateway.
 	 *   So, thank you Mark Mandel and Bob Silverberg :)
	 *
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
	public any function onMissingMethod( required string missingMethodName, required struct missingMethodArguments ) {
		var lCaseMissingMethodName = lCase( missingMethodName );

		if ( lCaseMissingMethodName.startsWith( 'get' ) ) {
			if(right(lCaseMissingMethodName,9) == "smartlist") {
				return onMissingGetSmartListMethod( missingMethodName, missingMethodArguments );
			} else {
				return onMissingGetMethod( missingMethodName, missingMethodArguments );
			}
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
	 * Provides dynamic getSmarList method, by convention, on missing method:
	 *
	 *   getXXXSmartList( struct data )
	 *
	 * ...in which XXX is an ORM entity name
	 *
	 * NOTE: Ordered arguments only--named arguments not supported.
	 */
	 
	private function onMissingGetSmartListMethod( required string missingMethodName, required struct missingMethodArguments ){
		var smartListArgs = {};
		var entityNameLength = len(arguments.missingMethodName) - 12;
		
		var entityName = missingMethodName.substring( 3,entityNameLength + 3 );
		var data = {};
		if( structCount(missingMethodArguments) && !isNull(missingMethodArguments[ 1 ]) && isStruct(missingMethodArguments[ 1 ]) ) {
			data = missingMethodArguments[ 1 ];
		}
		
		return getSmartList(entityName=entityName, data=data);
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


	private function onMissingSaveMethod( required string missingMethodName, required struct missingMethodArguments ) {
		if ( structKeyExists( missingMethodArguments, '2' ) ) {
			return save( entity=missingMethodArguments[1], data=missingMethodArguments[2]);
		} else {
			return save( entity=missingMethodArguments[1] );
		}
	}
}
