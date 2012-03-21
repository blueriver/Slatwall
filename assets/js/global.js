/**
 * @depends /jquery-1.7.1.min.js
 * @depends /jquery-ui-1.8.16.custom.min.js
 * @depends /jquery-validate-1.9.0.min.js
 * @depends /bootstrap.min.js
 * 
 */

jQuery(function($){
	
	$('.modalload').click(function(e){
		var modalLink = $(this).attr( 'href' );
		if( modalLink.indexOf("?") != -1) {
			modalLink = modalLink + '&modal=1';
		} else {
			modalLink = modalLink + '?modal=1';
		}
		$('#adminModal').load( modalLink );
	});
	
	$('.table-expand').click(function(e){
		e.preventDefault();
		
		console.log($(this).data());
		
		var data = {};
		data[ 'slatAction' ] = $(this).data('expandaction');
		data[ 'F:' + $(this).data('parentproperty') ] = $(this).data('parentid');
		data[ 'propertyIdentifiers' ] = $(this).data('propertyidentifiers');
		
		console.log(data);
		
		$.ajax({
			url: '/plugins/Slatwall/',
			data: data,
			dataType: 'json',
			contentType: 'application/json',
			success: function(r) {
				console.log(r);
			},
			error: function(r) {
				console.log(r);
			}
		});
	});
	
});