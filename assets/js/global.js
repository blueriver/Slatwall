/**
 * @depends /jquery-1.7.1.min.js
 * @depends /jquery-ui-1.8.16.custom.min.js
 * @depends /jquery-ui-timepicker-addon.js
 * @depends /jquery-validate-1.9.0.min.js
 * @depends /bootstrap.min.js
 * 
 */

var ajaxlock = 0;

jQuery(function($){
	
	$('.datetimepicker').datetimepicker();
	$('.datepicker').datepicker();
	
	$('.modalload').click(function(e){
		$('#adminModal').html('');
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
		toggleTable( this );
	});
	
});


function toggleTable( toggleLink ) {
	if(ajaxlock == 0) {
		ajaxlock = 1;
		
		if( $(toggleLink).hasClass('open') ) {
			
			//$(toggleLink).removeClass('open');
			ajaxlock = 0;
		} else {
			
			var data = {};
			data[ 'slatAction' ] = $(toggleLink).data('expandaction');
			data[ 'F:' + $(toggleLink).data('parentidproperty') ] = $(toggleLink).data('parentid');
			data[ 'propertyIdentifiers' ] = $(toggleLink).data('propertyidentifiers');
			
			var parentID = $(toggleLink).data('parentid');
			var parentIDProperty  = $(toggleLink).data('parentidproperty');
			var idProperty = $(toggleLink).data('idproperty');
			var parentDepth = $(toggleLink).data('depth');
			var parentIcon = $(toggleLink).children('.icon-plus');
			
			$.ajax({
				url: '/plugins/Slatwall/',
				data: data,
				dataType: 'json',
				contentType: 'application/json',
				success: function(r) {
					$.each(r["RECORDS"], function(r, rv){
						
						var newRow = $('#' + parentID ).clone( true );
						$(newRow).attr('ID', rv[ idProperty ])
						
						$.each(rv, function(p, pv) {
							if($(newRow).children('.' + p).children('.table-expand').length) {
								
								var newIcon = $(newRow).children('.' + p).children('.table-expand').clone( true );
								
								$(newIcon).data('depth', parentDepth + 1);
								$(newIcon).data('parentid', rv[ idProperty ]);
								
								$(newIcon).removeClass('depth' + parentDepth);
								$(newIcon).addClass('depth' + (parentDepth + 1));
								
								$(newRow).children('.' + p).html( newIcon );
								$(newRow).children('.' + p).append( ' ' + pv );
							} else {
								$(newRow).children('.' + p).html(pv);	
							}
						});
						
						$.each($(newRow).children('.admin').children('a'), function(i, v) {
							$(v).attr('href', $(v).attr('href').replace(parentID, rv[idProperty]));
						});
						
						$('#' + parentID ).after(newRow);
					});
					
					$(toggleLink).addClass('open');
					$(parentIcon).removeClass('icon-plus');
					$(parentIcon).addClass('icon-minus');
					
					ajaxlock = 0;
				},
				error: function(r) {
					alert('Error Loading');
					
					ajaxlock = 0;
				}
			});
		}
	}
}
