<cfcomponent output="false" accessors="true" extends="Hibachi.HibachiObject">
	
	<cfscript>
		public any function get( required string entityName, required any idOrFilter, boolean isReturnNewOnNotFound = false ) {
			// Adds the Slatwall Prefix to the entityName when needed.
			if(left(arguments.entityName,8) != "Slatwall") {
				arguments.entityName = "Slatwall#arguments.entityName#";
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
			// Adds the Slatwall Prefix to the entityName when needed.
			if(left(arguments.entityName,8) != "Slatwall") {
				arguments.entityName = "Slatwall#arguments.entityName#";
			}
			
			return entityLoad( entityName, filterCriteria, sortOrder, options );
		}
	
	
		public any function new( required string entityName ) {
			// Adds the Slatwall Prefix to the entityName when needed.
			if(left(arguments.entityName,8) != "Slatwall") {
				arguments.entityName = "Slatwall#arguments.entityName#";
			}
			
			return entityNew( entityName );
		}
	
	
		public any function save( required target ) {
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
		
		public any function count(required any entityName) {
			// Adds the Slatwall Prefix to the entityName when needed.
			if(left(arguments.entityName,8) != "Slatwall") {
				arguments.entityName = "Slatwall#arguments.entityName#";
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
			// Adds the Slatwall Prefix to the entityName when needed.
			if(left(arguments.entityName,8) != "Slatwall") {
				arguments.entityName = "Slatwall#arguments.entityName#";
			}
			
			var smartList = new Slatwall.model.transient.SmartList(argumentCollection=arguments);
	
			return smartList;
		}
		
		public any function getExportQuery(required string entityName) {
			var qry = new query();
			qry.setName("exportQry");
			var result = qry.execute(sql="SELECT * FROM Slatwall#arguments.entityName#"); 
	    	exportQry = result.getResult(); 
			return exportQry;
		}
		
		
		
		// ===================== START: Private Helper Methods ===========================
		
		// =====================  END: Private Helper Methods ============================
		
	</cfscript>
</cfcomponent>