/**
 * @depends /jquery-1.7.1.min.js
 * @depends /jquery-ui-1.8.16.custom.min.js
 * @depends /jquery-ui-timepicker-0.2.1.js
 * @depends /jquery-validate-1.9.0.min.js
 * @depends /bootstrap.min.js
 * 
 */

var ajaxlock = 0;

jQuery(document).ready(function() {
	
	if( window.location.hash ) {
		var hash = window.location.hash.substring(1);
		jQuery('a[href=#' + hash + ']').tab('show');
	}
	
	jQuery('a[data-toggle="tab"]').on('shown', function (e) {
		window.location.hash = jQuery(this).attr('href');
	})
	
	jQuery('.modalload').click(function(e){
		jQuery('#adminModal').html('');
		var modalLink = jQuery(this).attr( 'href' );
		if( modalLink.indexOf("?") != -1) {
			modalLink = modalLink + '&modal=1&tabIndex=' + slatwall.tabIndex;
		} else {
			modalLink = modalLink + '?modal=1&tabIndex=' + slatwall.tabIndex;
		}
		jQuery('#adminModal').load( modalLink, function(){bindFormValidation();bindTableClasses();bindUIElements();} );
	});
	
	bindUIElements();
	bindAlerts();
	bindFormValidation();
	bindTableClasses();
	bindTooltips();
});

function bindTooltips(){
	jQuery('.hint').tooltip();
	jQuery('.hint').click(function(e){
		e.preventDefault();
	});
}

function bindUIElements() {
	jQuery('.datetimepicker').datepicker({
		dateFormat: convertCFMLDateFormat( slatwall.dateFormat ),
		duration: '',  
        showTime: true,  
        constrainInput: false,
        stepMinutes: 1, 
        stepHours: 1,
        altTimeField: '',  
        time24h: false
	});
	
	jQuery('.datepicker').datepicker();
}

function bindFormValidation() {
	jQuery.each(jQuery('form'), function(index, value) {
		jQuery(value).validate();
	});
}

function bindAlerts() {
	jQuery('.alert-confirm').click(function(e){
		e.preventDefault();
		jQuery('#adminConfirm > .modal-body').html( jQuery(this).data('confirm') );
		jQuery('#adminConfirm .btn-primary').attr( 'href', jQuery(this).attr('href') );
		jQuery('#adminConfirm').modal();
	});
	jQuery('.alert-disabled').click(function(e){
		e.preventDefault();
		jQuery('#adminDisabled > .modal-body').html( jQuery(this).data('disabled') );
		jQuery('#adminDisabled').modal();
	});
}

function bindTableClasses() {
	jQuery('.table-action-expand').click(function(e){
		e.preventDefault();
		tableExpandClick( this );
	});
	jQuery('.table-action-multiselect').click(function(e){
		e.preventDefault();
		tableMultiselectClick( this );
	});
	jQuery('.table-action-sort').click(function(e){
		e.preventDefault();
	});
	jQuery('.table-sortable .sortable').sortable({
		update: function(event, ui) {
			tableApplySort(event, ui);
		}
	});
}

function tableApplySort(event, ui) {
	
	var recordID = jQuery(ui.item).attr('ID');
	var tableName = jQuery(ui.item).closest('table').data('tablename');
	var idProperty = jQuery(ui.item).closest('table').data('idproperty');
	var newSortOrder = 0;
	
	var allOriginalSortOrders = jQuery(ui.item).parent().find('.table-action-sort').map( function(){ return jQuery(this).data("sortpropertyvalue");}).get();
	var minSortOrder = Math.min.apply( Math, allOriginalSortOrders );
	
	jQuery.each(jQuery(ui.item).parent().children(), function(index, value) {
		jQuery(value).find('.table-action-sort').data('sortpropertyvalue', index + minSortOrder);
		jQuery(value).find('.table-action-sort').attr('data-sortpropertyvalue', index + minSortOrder);
		if(jQuery(value).attr('ID') == recordID) {
			newSortOrder = index + minSortOrder;
		}
	});
	
	var data = {
		slatAction : 'admin:main.updateSortOrder',
		recordIDColumn : idProperty,
		recordID : recordID,
		tableName : tableName,
		newSortOrder : newSortOrder
	};
		
	jQuery.ajax({
		url: '/plugins/Slatwall/',
		async: false,
		data: data,
		dataType: 'json',
		contentType: 'application/json',
		success: function(r) {
			
		},
		error: function(r) {
			alert('Error Loading');
		}
	});
}

function tableMultiselectClick( toggleLink ) {
	
	var field = jQuery( 'input[name=' + jQuery(toggleLink).closest('table').data('multiselectfield') + ']' );
	var currentValues = jQuery(field).val().split(',');
	
	var blankIndex = currentValues.indexOf('');
	if(blankIndex > -1) {
		currentValues.splice(blankIndex, 1);	
	}
	
	if( jQuery(toggleLink).children('.slatwall-ui-checkbox-checked').length ) {
		
		var icon = jQuery(toggleLink).children('.slatwall-ui-checkbox-checked');
		
		jQuery(icon).removeClass('slatwall-ui-checkbox-checked');
		jQuery(icon).addClass('slatwall-ui-checkbox');
		
		var valueIndex = currentValues.indexOf( jQuery(toggleLink).data('idvalue') );
		
		currentValues.splice(valueIndex, 1);
		
	} else {
		
		var icon = jQuery(toggleLink).children('.slatwall-ui-checkbox');
		
		jQuery(icon).removeClass('slatwall-ui-checkbox');
		jQuery(icon).addClass('slatwall-ui-checkbox-checked');
		
		currentValues.push( jQuery(toggleLink).data('idvalue') );
	}
	
	jQuery(field).val(currentValues.join(','));
}

function tableExpandClick( toggleLink ) {
	if(ajaxlock == 0) {
		ajaxlock = 1;
		
		if( jQuery(toggleLink).hasClass('open') ) {
			
			//jQuery(toggleLink).removeClass('open');
			ajaxlock = 0;
		} else {
			
			var idProperty = jQuery(toggleLink).closest('table').data('idproperty');
			var parentIDProperty = jQuery(toggleLink).closest('table').data('parentidproperty');
			var propertyIdentifiers = jQuery(toggleLink).closest('table').data('propertyidentifiers');
			var expandAction = jQuery(toggleLink).closest('table').data('expandaction');
			
			var parentID = jQuery(toggleLink).data('parentid');
			var depth = jQuery(toggleLink).data('depth');
			var icon = jQuery(toggleLink).children('.icon-plus');
			
			var data = {};
			data[ 'slatAction' ] = expandAction;
			data[ 'F:' + parentIDProperty ] = parentID;
			data[ 'propertyIdentifiers' ] = propertyIdentifiers;
			
			
			jQuery.ajax({
				url: '/plugins/Slatwall/',
				data: data,
				dataType: 'json',
				contentType: 'application/json',
				success: function(r) {
					jQuery.each(r["RECORDS"], function(r, rv){
						
						var newRow = jQuery('#' + parentID ).clone( true );
						jQuery(newRow).attr('ID', rv[ idProperty ])
						
						jQuery.each(rv, function(p, pv) {
							
							if(jQuery(newRow).children('.' + p).children('.table-action-expand').length) {
								
								var newIcon = jQuery(newRow).children('.' + p).children('.table-action-expand').clone( true );
								
								jQuery(newIcon).data('depth', depth + 1);
								jQuery(newIcon).data('parentid', rv[ idProperty ]);
								
								jQuery(newIcon).removeClass('depth' + depth);
								jQuery(newIcon).addClass('depth' + (depth + 1));
								
								jQuery(newRow).children('.' + p).html( newIcon );
								jQuery(newRow).children('.' + p).append( ' ' + pv );
							} else {
								
								jQuery(newRow).children('.' + p).html(pv);	
							}
						});
						
						jQuery.each(jQuery(newRow).children('.admin').children('a'), function(i, v) {
							jQuery(v).attr('href', jQuery(v).attr('href').replace(parentID, rv[idProperty]));
						});
						
						jQuery('#' + parentID ).after(newRow);
					});
					
					jQuery(toggleLink).addClass('open');
					
					jQuery(icon).removeClass('icon-plus');
					jQuery(icon).addClass('icon-minus');
					
					ajaxlock = 0;
				},
				error: function(r) {
					console.log(r);
					
					alert('Error Loading, check console for results.');
					
					ajaxlock = 0;
				}
			});
		}
	}
}

function showOnPropertyValue(value,targetValue,targetElement) {
	if( value == targetValue ) {
		targetElement.show();
	} else {
		targetElement.hide().find('input').val('');
	}
}

function convertCFMLDateFormat( dateFormat ) {
	dateFormat = dateFormat.replace('mmm', 'M');
	dateFormat = dateFormat.replace('yyyy', 'yy');
	return dateFormat;
}
