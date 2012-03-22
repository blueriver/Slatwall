/**
 * @depends /jquery-1.7.1.min.js
 * @depends /jquery-ui-1.8.16.custom.min.js
 * @depends /jquery-validate-1.9.0.min.js
 * @depends /bootstrap.min.js
 * 
 */

jQuery(function($){
	
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
		
		var data = {};
		data[ 'slatAction' ] = $(this).data('expandaction');
		data[ 'F:' + $(this).data('parentidproperty') ] = $(this).data('parentid');
		data[ 'propertyIdentifiers' ] = $(this).data('propertyidentifiers');
		
		var parentID = $(this).data('parentid');
		var parentIDProperty  = $(this).data('parentidproperty');
		var idProperty = $(this).data('idproperty');
		var parentDepth = $(this).data('depth');
		var parentIcon = $(this).children('.icon-plus');
		
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
							$(newIcon).attr('data-depth', parentDepth + 1);
							$(newIcon).attr('data-parentid', rv[ idProperty ]);
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
				
				$(parentIcon).removeClass('icon-plus');
				$(parentIcon).addClass('icon-minus');
			},
			error: function(r) {
				alert('Error Loading');
			}
		});
		
	});
	
});