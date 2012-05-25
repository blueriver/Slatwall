/**
 * @depends /jquery-1.7.1.min.js
 * @depends /jquery-ui-1.8.20.custom.min.js
 * @depends /jquery-ui-timepicker-addon-0.9.9.js
 * @depends /jquery-validate-1.9.0.min.js
 * @depends /jquery-typewatch-2.0.js
 * @depends /jquery-hashchange-1.3.min.js
 * @depends /bootstrap.min.js
 * 
 */

var ajaxlock = 0;

jQuery(document).ready(function() {
	
	setupEventHandlers();
	
	initUIElements( 'body' );

	// Looks for a tab to show
	$(window).hashchange();
	/*
	if( window.location.hash ) {
		var hash = window.location.hash.substring(1);
		jQuery('a[href=#' + hash + ']').tab('show');
	}
	*/
	
	// Focus on the first tab index
	if(jQuery('.firstfocus').length) {
		jQuery('.firstfocus').focus();	
	} else {
		if(!jQuery('input[tabindex=1]').hasClass('noautofocus')) {
			jQuery('input[tabindex=1]').focus();
		}
	}
	
	if(jQuery('#global-search').val() != '') {
		jQuery('#global-search').keyup(); 
	}
	
	jQuery("#global-search").typeWatch( {
	    callback:function(){ updateGlobalSearchResults(); },
	    wait:450,
	    highlight: false,
	    captureLength:2
	} );
	
});

function initUIElements( scopeSelector ) {
	
	// Datetime Picker
	jQuery( scopeSelector ).find(jQuery('.datetimepicker')).datetimepicker({
		dateFormat: convertCFMLDateFormat( slatwall.dateFormat ),
		timeFormat: convertCFMLTimeFormat( slatwall.timeFormat ),
		ampm: true
	});
	
	// Date Picker
	jQuery( scopeSelector ).find(jQuery('.datepicker')).datepicker({
		dateFormat: convertCFMLDateFormat( slatwall.dateFormat )
	});
	
	// Time Picker
	jQuery( scopeSelector ).find(jQuery('.timepicker')).timepicker({});
	
	// Wysiwyg
	jQuery.each(jQuery( '.wysiwyg' ), function(i, v){
		var editor = CKEDITOR.replace( v );
		CKFinder.setupCKEditor( editor, 'org/ckfinder/' ) ;
	});
	
	// Tooltips
	jQuery( scopeSelector ).find(jQuery('.hint')).tooltip();
	
	// Empty Values
	jQuery.each(jQuery( scopeSelector ).find(jQuery('input[data-emptyvalue]')), function(index, value) {
		jQuery(this).blur();
	});
	
	// Form Empty value clear (IMPORTANT!!! KEEP THIS ABOVE THE VALIDATION ASIGNMENT)
	jQuery.each(jQuery( scopeSelector ).find(jQuery('form')), function(index, value) {
		jQuery(value).on('submit', function(e){
			jQuery.each(jQuery( this ).find(jQuery('input[data-emptyvalue]')), function(i, v) {
				if(jQuery(v).val() == jQuery(v).data('emptyvalue')) {
					jQuery(v).val('');
				}
			});
		});
	});
	
	// Validation
	jQuery.each(jQuery( scopeSelector ).find(jQuery('form')), function(index, value) {
		jQuery(value).validate({
			invalidHandler: function() {
				console.log(jQuery(value).find('input[data-emptyvalue]').blur());
			}
		});
	});
	
	// Table Sortable
	jQuery( scopeSelector ).find(jQuery('.table-sortable .sortable')).sortable({
		update: function(event, ui) {
			tableApplySort(event, ui);
		}
	});
	
	// Table Multiselect
	jQuery.each(jQuery( scopeSelector ).find(jQuery('.table-multiselect')), function(ti, tv){
		updateMultiselectTableUI( jQuery(tv).data('multiselectfield') );
	});
}

function setupEventHandlers() {
	
	// Global Search
	jQuery('body').on('keyup', '#global-search', function(e){
		if(jQuery(this).val() != "") {
			if(jQuery("body").scrollTop() > 0) {
				jQuery("body").animate({scrollTop:0}, 300, function(){
					jQuery('#search-results').animate({'margin-top': '0px'}, 150);
				});
			} else {
				jQuery('#search-results').animate({'margin-top': '0px'}, 150);
			}
		} else {
			jQuery('#search-results').animate({
				'margin-top': '-500px'
			}, 150);
			jQuery('#search-results .result-bucket .nav').html('');
		}
	});
	jQuery('body').on('click', '.search-close', function(e){
		jQuery('#global-search').val('');
		jQuery('#global-search').keyup();
	});
	
	// Bind Hash Change Event
	jQuery(window).hashchange( function(){
		jQuery('a[href=' + location.hash + ']').tab('show');
	});
	
	// Hints
	jQuery('body').on('click', '.hint', function(e){
		e.preventDefault();
	});
	
	// Tab Selecting
	jQuery('body').on('shown', 'a[data-toggle="tab"]', function (e) {
		window.location.hash = jQuery(this).attr('href');
	});
	
	// Empty Value
	jQuery('body').on('focus', 'input[data-emptyvalue]', function (e) {
		jQuery(this).removeClass('emptyvalue');
		if(jQuery(this).val() == jQuery(this).data('emptyvalue')) {
			jQuery(this).val('');
		}
	});
	jQuery('body').on('blur', 'input[data-emptyvalue]', function (e) {
		if(jQuery(this).val() == '') {
			jQuery(this).val(jQuery(this).data('emptyvalue'));
			jQuery(this).addClass('emptyvalue');
		}
	});
	
	// Alerts
	jQuery('body').on('click', '.alert-confirm', function(e){
		e.preventDefault();
		jQuery('#adminConfirm > .modal-body').html( jQuery(this).data('confirm') );
		jQuery('#adminConfirm .btn-primary').attr( 'href', jQuery(this).attr('href') );
		jQuery('#adminConfirm').modal();
	});
	jQuery('body').on('click', '.alert-disabled', function(e){
		e.preventDefault();
		jQuery('#adminDisabled > .modal-body').html( jQuery(this).data('disabled') );
		jQuery('#adminDisabled').modal();
	});
	
	// Disabled Secure Display Buttons
	jQuery('body').on('click', '.disabled', function(e){
		e.preventDefault();
	});
	
	
	// Modal Loading
	jQuery('body').on('click', '.modalload', function(e){
		jQuery('#adminModal').html('');
		var modalLink = jQuery(this).attr( 'href' );
		if( modalLink.indexOf("?") != -1) {
			modalLink = modalLink + '&modal=1&tabIndex=' + slatwall.tabIndex;
		} else {
			modalLink = modalLink + '?modal=1&tabIndex=' + slatwall.tabIndex;
		}
		jQuery('#adminModal').load( modalLink, function(){
			initUIElements('#adminModal');
			jQuery('#adminModal').css({
				width: 'auto',
		        'margin-left': function () {
		            return -(jQuery('#adminModal').width() / 2);
		        }
			});
		});
	});
	
	// Listing Page - Searching
	jQuery('body').on('submit', '.action-bar-search', function(e){
		e.preventDefault();
	});
	jQuery('body').on('keyup', '.action-bar-search input', function(e){
		var data = {};
		data[ 'keywords' ] = jQuery(this).val();
		
		listingDisplayUpdate( jQuery(this).data('tableid'), data );
	});
	
	// Listing Display - Paging
	jQuery('body').on('click', '.listing-pager', function(e){
		e.preventDefault();
		
		var data = {};
		data[ 'P:Current' ] = jQuery(this).data('page');
		
		listingDisplayUpdate( jQuery(this).closest('.pagination').data('tableid'), data );
	});
	
	// Listing Display - Sorting
	jQuery('body').on('click', '.listing-sort', function(e){
		e.preventDefault();
		var data = {};
		data[ 'OrderBy' ] = jQuery(this).closest('th').data('propertyidentifier') + '|' + jQuery(this).data('sortdirection');
		listingDisplayUpdate( jQuery(this).closest('.table').attr('id'), data);
	});
	
	// Listing Display - Filtering
	jQuery('body').on('click', '.listing-filter', function(e){
		e.preventDefault();
		e.stopPropagation();
		
		var value = jQuery('input[name="F:' + jQuery(this).closest('th').data('propertyidentifier') + '"]').val();
		var valueArray = [];
		if(value != '') {
			valueArray = value.split(',');
		}
		var i = jQuery.inArray(jQuery(this).data('filtervalue'), valueArray);
		if( i > -1 ) {
			valueArray.splice(i, 1);
			jQuery(this).children('.slatwall-ui-checkbox-checked').addClass('slatwall-ui-checkbox').removeClass('slatwall-ui-checkbox-checked');
		} else {
			valueArray.push(jQuery(this).data('filtervalue'));
			jQuery(this).children('.slatwall-ui-checkbox').addClass('slatwall-ui-checkbox-checked').removeClass('slatwall-ui-checkbox');
		}
		jQuery('input[name="F:' + jQuery(this).closest('th').data('propertyidentifier') + '"]').val(valueArray.join(","));
		
		var data = {};
		if(jQuery('input[name="F:' + jQuery(this).closest('th').data('propertyidentifier') + '"]').val() != '') {
			data[ 'F:' + jQuery(this).closest('th').data('propertyidentifier') ] = jQuery('input[name="F:' + jQuery(this).closest('th').data('propertyidentifier') + '"]').val();
		} else {
			data[ 'FR:' + jQuery(this).closest('th').data('propertyidentifier') ] = 1;	
		}
		listingDisplayUpdate( jQuery(this).closest('.table').attr('id'), data);
	});
	
	// Listing Display - Searching
	jQuery('body').on('click', '.dropdown input', function(e){
		e.stopPropagation();
	});
	jQuery('body').on('click', 'table .dropdown-toggle', function(e){
		jQuery(this).parent().find('.listing-search').focus();
	});
	jQuery('body').on('keyup', '.listing-search', function(e){
		var data = {};
		
		if(jQuery(this).val() != '') {
			data[ jQuery(this).attr('name') ] = jQuery(this).val();	
		} else {
			data[ 'FKR:' + jQuery(this).attr('name').split(':')[1] ] = 1;
		}
		listingDisplayUpdate( jQuery(this).closest('.table').attr('id'), data);
	});
	
	// Listing Display - Expanding
	jQuery('body').on('click', '.table-action-expand', function(e){
		e.preventDefault();
		tableExpandClick( this );
	});
	
	// Listing Display - Sort Applying
	jQuery('body').on('click', '.table-action-sort', function(e){
		e.preventDefault();
	});
	
	// Listing Display - Select
	
	// Listing Display - Multiselect
	jQuery('body').on('click', '.table-action-multiselect', function(e){
		e.preventDefault();
		if(!jQuery(this).hasClass('disabled')){
			tableMultiselectClick( this );
		}
	});
}

function updateMultiselectTableUI( multiselectField ) {
	var inputValue = jQuery('input[name=' + multiselectField + ']').val();
	
	if(inputValue != "") {
		jQuery.each(inputValue.split(','), function(vi, vv){
			jQuery(jQuery('table[data-multiselectfield=' + multiselectField  + ']').find('tr[id=' + vv + '] .slatwall-ui-checkbox').addClass('slatwall-ui-checkbox-checked')).removeClass('slatwall-ui-checkbox');
		});
	}
}

function listingDisplayUpdate( tableID, data ) {
	
	data[ 'slatAction' ] = 'admin:ajax.updateListingDisplay';
	data[ 'propertyIdentifiers' ] = jQuery('#' + tableID).data('propertyidentifiers');
	data[ 'savedStateID' ] = jQuery('#' + tableID).data('savedstateid');
	data[ 'entityName' ] = jQuery('#' + tableID).data('entityname');
	
	var idProperty = jQuery('#' + tableID).data('idproperty');
	
	jQuery.ajax({
		url: '/plugins/Slatwall/',
		method: 'post',
		data: data,
		dataType: 'json',
		contentType: 'application/json',
		error: function(result) {
			console.log(r);
			alert('Error Loading');
		},
		success: function(r) {
			// Setup Selectors
			var tableBodySelector = '#' + tableID + ' tbody';
			var tableHeadRowSelector = '#' + tableID + ' thead tr';
			
			// Clear out the old Body
			jQuery(tableBodySelector).html('');
			
			// Loop over each of the records in the response
			jQuery.each( r["pageRecords"], function(ri, rv){
			
				var rowSelector = jQuery('<tr></tr>');
				jQuery(rowSelector).attr('id', rv[ idProperty ]);
				
				// Create a new row
				//jQuery(tableBodySelector).append('<tr id="' + rv[ idProperty ] + '">');
				
				// Loop over each column of the header to pull the data out of the response and populate new td's
				jQuery.each(jQuery(tableHeadRowSelector).children(), function(ci, cv){
					var newtd = '';
					var link = '';
					
					if( jQuery(cv).hasClass('data') ) {
						
						if( rv[jQuery(cv).data('propertyidentifier')] == true) {
							newtd += '<td class="' + jQuery(cv).attr('class') + '">Yes</td>';
						} else if ( rv[jQuery(cv).data('propertyidentifier')] == false ) {
							newtd += '<td class="' + jQuery(cv).attr('class') + '">No</td>';
						} else {
							newtd += '<td class="' + jQuery(cv).attr('class') + '">' + rv[jQuery(cv).data('propertyidentifier')] + '</td>';
						}
						
					
					} else if( jQuery(cv).hasClass('multiselect') ) {
						
						newtd += '<td><a href="#" class="table-action-multiselect" data-idvalue="' + rv[ idProperty ] + '"><i class="slatwall-ui-checkbox"></i></a>';
							
					} else if ( jQuery(cv).hasClass('admin') ){
						
						newtd += '<td>';
						
						if( jQuery(cv).data('editaction') != undefined ) {
							link = '?slatAction=' + jQuery(cv).data('editaction') + '&' + idProperty + '=' + rv[ idProperty ];
							if( jQuery(cv).data('editquerystring') != undefined ) {
								link += '&' + jQuery(cv).data('editquerystring');
							}
							if( jQuery(cv).data('editmodal') ) {
								newtd += '<a class="btn btn-mini modalload" href="' + link + '" data-toggle="modal" data-target="#adminModal"><i class="icon-pencil"></i></a> ';
							} else {
								newtd += '<a class="btn btn-mini" href="' + link + '"><i class="icon-pencil"></i></a> ';	
							}
						}
						
						if( jQuery(cv).data('detailaction') != undefined ) {
							link = '?slatAction=' + jQuery(cv).data('detailaction') + '&' + idProperty + '=' + rv[ idProperty ];
							if( jQuery(cv).data('detailquerystring') != undefined ) {
								link += '&' + jQuery(cv).data('detailquerystring');
							}
							if( jQuery(cv).data('detailmodal') ) {
								newtd += '<a class="btn btn-mini modalload" href="' + link + '" data-toggle="modal" data-target="#adminModal"><i class="icon-eye-open"></i></a> ';
							} else {
								newtd += '<a class="btn btn-mini" href="' + link + '"><i class="icon-eye-open"></i></a> ';	
							}
						}
						
						if( jQuery(cv).data('deleteaction') != undefined ) {
							link = '?slatAction=' + jQuery(cv).data('deleteaction') + '&' + idProperty + '=' + rv[ idProperty ];
							if( jQuery(cv).data('deletequerystring') != undefined ) {
								link += '&' + jQuery(cv).data('deletequerystring');
							}
							newtd += '<a class="btn btn-mini" href="' + link + '"><i class="icon-trash"></i></a> ';
						}
						
						if( jQuery(cv).data('processaction') != undefined ) {
							link = '?slatAction=' + jQuery(cv).data('processaction') + '&' + idProperty + '=' + rv[ idProperty ];
							if( jQuery(cv).data('processquerystring') != undefined ) {
								link += '&' + jQuery(cv).data('processquerystring');
							}
							if( jQuery(cv).data('processmodal') ) {
								newtd += '<a class="btn btn-mini modalload" href="' + link + '" data-toggle="modal" data-target="#adminModal"><i class="icon-cog"></i> Process</a> ';
							} else {
								newtd += '<a class="btn btn-mini" href="' + link + '"><i class="icon-cog"></i> Process</a> ';	
							}
						}
						
						newtd += '</td>';
						
					}
					
					jQuery(rowSelector).append(newtd);
				});
				
				jQuery(tableBodySelector).append(jQuery(rowSelector));
			});
			
			// Update the paging nav
			jQuery('div[class="pagination"][data-tableid="' + tableID + '"]').html(buildPagingNav(r["currentPage"], r["totalPages"]));
			
			// Update the saved state ID of the table
			jQuery('#' + tableID).data('savedstateid', r["savedStateID"]);
			jQuery('#' + tableID).attr('data-savedstateid', r["savedStateID"]);
			
			updateMultiselectTableUI( '#' + tableID );
		}
		
	});
}

function buildPagingNav(currentPage, totalPages) {
	var nav = '';
	
	currentPage = parseInt(currentPage);
	totalPages = parseInt(totalPages);
	
	if(totalPages > 1){
		nav = '<ul>';
	
		var pageStart = 1;
		var pageCount = 5;
		
		if(totalPages > 6) {
			if (currentPage > 3 && currentPage < totalPages - 3) {
				pageStart = currentPage - 1;
				pageCount = 3;
			} else if (currentPage >= totalPages - 4) {
				pageStart = totalPages - 4;
			}
		} else {
			pageCount = totalPages;
		}
		
		if(currentPage > 1) {
			nav += '<li><a href="#" class="listing-pager prev" data-page="' + (currentPage - 1) + '">&laquo;</a></li>';
		} else {
			nav += '<li class="disabled prev"><a href="#">&laquo;</a></li>';
		}
		
		if(currentPage > 3 && totalPages > 6) {
			nav += '<li><a href="#" class="listing-pager" data-page="1">1</a></li>';
			nav += '<li class="disabled"><a href="#">...</a></li>';
		}
	
		for(var i=pageStart; i<pageStart + pageCount; i++){
			
			if(currentPage == i) {
				nav += '<li class="active"><a href="#" class="listing-pager" data-page="' + i + '">' + i + '</a></li>';
			} else {
				nav += '<li><a href="#" class="listing-pager" data-page="' + i + '">' + i + '</a></li>';
			}
		}
		
		if(currentPage < totalPages - 3 && totalPages > 6) {
			nav += '<li class="disabled"><a href="#">...</a></li>';
			nav += '<li><a href="#" class="listing-pager" data-page="' + totalPages + '">' + totalPages + '</a></li>';
		}
		
		if(currentPage < totalPages) {
			nav += '<li><a href="#" class="listing-pager next" data-page="' + (currentPage + 1) + '">&raquo;</a></li>';
		} else {
			nav += '<li class="disabled next"><a href="#">&raquo;</a></li>';
		}
		
		nav += '</ul>';
	}
	
	return nav;
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

function updateGlobalSearchResults() {
	
	var data = {
		slatAction: 'admin:ajax.updateGlobalSearchResults',
		keywords: jQuery('#global-search').val()
	};
	
	jQuery.ajax({
		url: '/plugins/Slatwall/',
		method: 'post',
		data: data,
		dataType: 'json',
		contentType: 'application/json',
		error: function(result) {
			console.log(r);
			alert('Error Loading Global Search');
		},
		success: function(result) {
			
			var buckets = {
				product: {primaryIDProperty:'productID', listAction:'admin:product.listproduct', detailAction:'admin:product.detailproduct'},
				productType: {primaryIDProperty:'productTypeID', listAction:'admin:product.listproducttype', detailAction:'admin:product.detailproducttype'},
				brand: {primaryIDProperty:'brandID', listAction:'admin:product.listbrand', detailAction:'admin:product.detailbrand'},
				promotion: {primaryIDProperty:'promotionID', listAction:'admin:pricing.listpromotion', detailAction:'admin:pricing.detailpromotion'},
				order: {primaryIDProperty:'orderID', listAction:'admin:order.listorder', detailAction:'admin:order.detailorder'},
				account: {primaryIDProperty:'accountID', listAction:'admin:account.listaccount', detailAction:'admin:account.detailaccount'},
				vendorOrder: {primaryIDProperty:'vendorOrderID', listAction:'admin:order.listvendororder', detailAction:'admin:order.detailvendororder'},
				vendor: {primaryIDProperty:'vendorID', listAction:'admin:vendor.listvendor', detailAction:'admin:vendor.detailvendor'}
			};
			for (var key in buckets) {
				jQuery('#golbalsr-' + key).html('');
				var records = result[key]['records'];
			    for(var r=0; r < records.length; r++) {
			    	jQuery('#golbalsr-' + key).append('<li><a href="/plugins/Slatwall/?slatAction=' + buckets[key]['detailAction'] + '&' + buckets[key]['primaryIDProperty'] + '=' + records[r]['value'] + '">' + records[r]['name'] + '</a></li>');
			    }
			    if(result[key]['recordCount'] > 10) {
			    	jQuery('#golbalsr-' + key).append('<li><a href="/plugins/Slatwall/?slatAction=' + buckets[key]['listAction'] + '&keywords=' + jQuery('#global-search').val() + '">...</a></li>');
			    } else if (result[key]['recordCount'] == 0) {
			    	jQuery('#golbalsr-' + key).append('<li><em>none</em></li>');
			    }
			}
		}
		
	});
	

}


// ========================= START: HELPER METHODS ================================

function convertCFMLDateFormat( dateFormat ) {
	dateFormat = dateFormat.replace('mmm', 'M');
	dateFormat = dateFormat.replace('yyyy', 'yy');
	return dateFormat;
}

function convertCFMLTimeFormat( timeFormat ) {
	timeFormat = timeFormat.replace('tt', 'TT');
	return timeFormat;
}

// =========================  END: HELPER METHODS =================================
