(function( $ ){
	
	/* Create the Hibachi Object */
	Hibachi = function( cfg ) {
		
		// Define the global config
		var config = {
			dateFormat : 'MM/DD/YYYY',
			timeFormat : 'HH:MM',
			applicationURL : '/',
			applicationKey : 'Hibachi'
		}
		
		$.extend(config, cfg);
		
		// Define all of the methods for this class
		var methods = {
				
			setConfig : function( o, v ) {
				if(o != null && typeof o === 'object') {
					$.extend(config, options);
				} else if (o != null && v != null && typeof o === 'string') {
					config[o] = v;
				}
			},
			
			getEntity : function( entityName, entityID, cbs, cbf ) {
				
				var doasync = arguments.length > 2;
				var s = cbs || function(r) {result=r};
				var f = cbf || s;
				var result = {};
				
				$.ajax({
					url: config.applicationURL + 'api/' + entityName + '/' + entityID + '/',
					method: 'get',
					async: doasync,
					dataType: 'json',
					beforeSend: function (xhr) { xhr.setRequestHeader('X-Hibachi-AJAX', true) },
					success: s,
					error: f
				});
				
				return result;
			},
			
			saveEntity : function( entityName, entityID, cbs, cbf ) {
				
				
				
			},
			
			deleteEntity : function( entityName, entityID, cbs, cbf ) {
				
			},
			
			processEntity : function( entityName, entityID, cbs, cbf ) {
				
			},
			
			getList : function( entityName, cbs, cbf ) {
				
			},
			
			getSmartList : function( entityName, data, cbs, cbf ) {
				
			}
			
		}
		
		// Define Public API Methods
		this.setConfig = methods.setConfig;
		this.getEntity = methods.getEntity;
		this.getSmartList = methods.getSmartList;
		this.getSmartList = methods.getSmartList;
		this.onError = methods.onError;
	}
	
})( jQuery );
