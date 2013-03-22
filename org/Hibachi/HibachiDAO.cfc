<cfcomponent output="false" accessors="true" extends="HibachiObject">
	
	<cfproperty name="applicationKey" type="string" />
	
	<cfscript>
		public any function get( required string entityName, required any idOrFilter, boolean isReturnNewOnNotFound = false ) {
			// Adds the Applicatoin Prefix to the entityName when needed.
			if(left(arguments.entityName, len(getApplicationKey()) ) != getApplicationKey()) {
				arguments.entityName = "#getApplicationKey()##arguments.entityName#";
			}
			
			if ( isSimpleValue( idOrFilter ) && len( idOrFilter ) ) {
				var entity = entityLoadByPK( entityName, idOrFilter );
			} else if ( isStruct( idOrFilter ) ){
				var entity = entityLoad( entityName, idOrFilter, true );
			}
			
			if ( !isNull( entity ) ) {
				entity.updateCalculatedProperties();
				return entity;
			}
	
			if ( isReturnNewOnNotFound ) {
				return new( entityName );
			}
		}
	
		public any function list( string entityName, struct filterCriteria = {}, string sortOrder = '', struct options = {} ) {
			// Adds the Applicatoin Prefix to the entityName when needed.
			if(left(arguments.entityName, len(getApplicationKey()) ) != getApplicationKey()) {
				arguments.entityName = "#getApplicationKey()##arguments.entityName#";
			}
			
			return entityLoad( entityName, filterCriteria, sortOrder, options );
		}
	
	
		public any function new( required string entityName ) {
			// Adds the Applicatoin Prefix to the entityName when needed.
			if(left(arguments.entityName, len(getApplicationKey()) ) != getApplicationKey()) {
				arguments.entityName = "#getApplicationKey()##arguments.entityName#";
			}
			
			return entityNew( entityName );
		}
	
	
		public any function save( required target ) {
			
			// Save this entity
			entitySave( target );
			
			// Digg Deeper into any populatedSubProperties and save those as well.
			if(!isNull(target.getPopulatedSubProperties())) {
				for(var p in target.getPopulatedSubProperties()) {
            		if(isArray(target.getPopulatedSubProperties()[p])) {
            			for(var e=1; e<=arrayLen(target.getPopulatedSubProperties()[p]); e++) {
            				this.save(target=target.getPopulatedSubProperties()[p][e]);	
            			}
            		} else {
            			this.save(target=target.getPopulatedSubProperties()[p]);
            		}
            	}
            }
			
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
		
		public any function count(required any entityName) {
			// Adds the Applicatoin Prefix to the entityName when needed.
			if(left(arguments.entityName, len(getApplicationKey()) ) != getApplicationKey()) {
				arguments.entityName = "#getApplicationKey()##arguments.entityName#";
			}
			
			return ormExecuteQuery("SELECT count(*) FROM #arguments.entityName#",true);
		}
		
		public void function reloadEntity(required any entity) {
	    	entityReload(arguments.entity);
	    }
	    
	    public void function flushORMSession() {
	    	ormFlush();
	    	// flush again to persist any changes done during ORM Event handler
			ormFlush();
	    }
	    
	    public void function clearORMSession() {
	    	ormClearSession();
	    }
	    
	    public any function getSmartList(required string entityName, struct data={}){
			// Adds the Applicatoin Prefix to the entityName when needed.
			if(left(arguments.entityName, len(getApplicationKey()) ) != getApplicationKey()) {
				arguments.entityName = "#getApplicationKey()##arguments.entityName#";
			}
			
			var smartList = getTransient("hibachiSmartList").setup(argumentCollection=arguments);
	
			return smartList;
		}
		
		public any function getExportQuery(required string entityName) {
			// Adds the Applicatoin Prefix to the entityName when needed.
			if(left(arguments.entityName, len(getApplicationKey()) ) != getApplicationKey()) {
				arguments.entityName = "#getApplicationKey()##arguments.entityName#";
			}
			
			var qry = new query();
			qry.setName("exportQry");
			var result = qry.execute(sql="SELECT * FROM #arguments.entityName#"); 
	    	exportQry = result.getResult(); 
			return exportQry;
		}
		
		
		
		// ===================== START: Private Helper Methods ===========================
		
		// =====================  END: Private Helper Methods ============================
		
	</cfscript>
	
	<!--- hint: This method is for doing validation checks to make sure a property value isn't already in use --->
	<cffunction name="isUniqueProperty">
		<cfargument name="propertyName" required="true" />
		<cfargument name="entity" required="true" />
		
		<cfset var property = arguments.entity.getPropertyMetaData( arguments.propertyName ).name />  
		<cfset var entityName = arguments.entity.getEntityName() />
		<cfset var entityID = arguments.entity.getPrimaryIDValue() />
		<cfset var entityIDproperty = arguments.entity.getPrimaryIDPropertyName() />
		<cfset var propertyValue = arguments.entity.getValueByPropertyIdentifier( arguments.propertyName ) />
		
		<cfset var results = ormExecuteQuery(" from #entityName# e where e.#property# = :propertyValue and e.#entityIDproperty# != :entityID", {propertyValue=propertyValue, entityID=entityID}) />
		
		<cfif arrayLen(results)>
			<cfreturn false />
		</cfif>
		
		<cfreturn true />		
	</cffunction>
</cfcomponent>