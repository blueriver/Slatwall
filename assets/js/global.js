/**
 * @depends /jquery-1.7.1.min.js
 * @depends /jquery-ui-1.8.16.custom.min.js
 * @depends /jquery-ui-timepicker-0.2.1.js
 * @depends /jquery-validate-1.9.0.min.js
 * @depends /bootstrap.min.js
 * 
 */

var ajaxlock = 0;

jQuery(function($){
	
	$('.datetimepicker').datepicker({
		dateFormat: convertCFMLDateFormat( slatwall.dateFormat ),
		duration: '',  
        showTime: true,  
        constrainInput: false,
        stepMinutes: 1, 
        stepHours: 1,
        altTimeField: '',  
        time24h: false
	});
	
	$('.datepicker').datepicker();
	
	$('.modalload').click(function(e){
		$('#adminModal').html('');
		var modalLink = $(this).attr( 'href' );
		if( modalLink.indexOf("?") != -1) {
			modalLink = modalLink + '&modal=1';
		} else {
			modalLink = modalLink + '?modal=1';
		}
		$('#adminModal').load( modalLink, function(){bindFormValidation();} );
	});
	
	bindAlerts();
	bindFormValidation();
	bindTableClasses();
});

function bindFormValidation() {
	$.each($('form'), function(index, value) {
		$(value).validate();
	});
}

function bindTableClasses() {
	$('.table-action-expand').click(function(e){
		e.preventDefault();
		toggleTable( this );
	});
}

function bindAlerts() {
	$('.alert-confirm').click(function(e){
		e.preventDefault();
		$('#adminConfirm > .modal-body').html( $(this).data('confirm') );
		$('#adminConfirm .btn-primary').attr( 'href', $(this).attr('href') );
		$('#adminConfirm').modal();
	});
	$('.alert-disabled').click(function(e){
		e.preventDefault();
		$('#adminDisabled > .modal-body').html( $(this).data('disabled') );
		$('#adminDisabled').modal();
	});
}

function toggleTable( toggleLink ) {
	if(ajaxlock == 0) {
		ajaxlock = 1;
		
		if( $(toggleLink).hasClass('open') ) {
			
			//$(toggleLink).removeClass('open');
			ajaxlock = 0;
		} else {
			
			var idProperty = $(toggleLink).closest('table').data('idproperty');
			var parentIDProperty = $(toggleLink).closest('table').data('parentidproperty');
			var propertyIdentifiers = $(toggleLink).closest('table').data('propertyidentifiers');
			var expandAction = $(toggleLink).closest('table').data('expandaction');
			
			var parentID = $(toggleLink).data('parentid');
			var depth = $(toggleLink).data('depth');
			var icon = $(toggleLink).children('.icon-plus');
			
			var data = {};
			data[ 'slatAction' ] = expandAction;
			data[ 'F:' + parentIDProperty ] = parentID;
			data[ 'propertyIdentifiers' ] = propertyIdentifiers;
			
			
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
							
							if($(newRow).children('.' + p).children('.table-action-expand').length) {
								
								var newIcon = $(newRow).children('.' + p).children('.table-action-expand').clone( true );
								
								$(newIcon).data('depth', depth + 1);
								$(newIcon).data('parentid', rv[ idProperty ]);
								
								$(newIcon).removeClass('depth' + depth);
								$(newIcon).addClass('depth' + (depth + 1));
								
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
					
					$(icon).removeClass('icon-plus');
					$(icon).addClass('icon-minus');
					
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

function convertCFMLDateFormat( dateFormat ) {
	dateFormat = dateFormat.replace('mmm', 'M');
	dateFormat = dateFormat.replace('yyyy', 'yy');
	return dateFormat;
}
