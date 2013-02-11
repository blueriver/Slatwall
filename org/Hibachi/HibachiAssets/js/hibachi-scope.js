/*

$.slatwall('getEntity','entityName','entityID');
$.slatwall('getEntity','entityName','entityID');
$.slatwall('getEntity','entityName','entityID');
$.slatwall('getEntity','entityName','entityID');


*/

(function( $ ){
	var methods = {
		init : function( config ) {
			return this.each(function(){
				
				var $this = $(this),
					data = $this.data('slatwall');
				
				// If the plugin hasn't been initialized yet
				if ( ! data ) {
					$(this).data('slatwall', {
						target : $this
					});
				}
			});
		},
		destroy : function( ) {
			return this.each(function(){
				var $this = $(this),
				data = $this.data('tooltip');

				// Namespacing FTW
				data.slatwall.remove();
				$this.removeData('tooltip');
			})

		},
		reposition : function(  ) { },
		show : function( ) { console.log('got here'); },
		hide : function( ) { },
		update : function( content ) { }
	};

	$.fn.slatwall = function( method ) {
    	if ( methods[method] ) {
    		return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if ( typeof method === 'object' || ! method ) {
			return methods.init.apply( this, arguments );
		} else {
			$.error( 'Method ' +  method + ' does not exist on jQuery.tooltip' );
		}
	};

})( jQuery );
