/*

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/

var slatwallMenuShowing = false;
var slatwallSearchDelay = 0;

jQuery(document).ready(function(){
	
	jQuery('li#mainMenu a.logo').click(function(e){
		e.preventDefault();
		if(slatwallMenuShowing) {
			toggleToolbarMenu(false);	
		} else {
			toggleToolbarMenu(true);
		}
	});
	
	jQuery('li#mainMenu ul.menu li').hover(
		function(e){
			if (!jQuery(this).hasClass('selected') && jQuery('#SlatwallToolbarSearch').val().length == 0 && slatwallMenuShowing) {
				
				var subSelector = 'li#mainMenu div.subMenuWrapper div.' + jQuery(this).attr('class');
				
				jQuery('li#mainMenu ul.menu li').removeClass('selected');
				jQuery(this).addClass('selected');
				
				displaySubMenu(subSelector);
			}
		},function(){}
	);
	
	jQuery('#SlatwallToolbarSearch').keyup(function(e){
        clearTimeout(slatwallSearchDelay);
		if(jQuery(this).val().length > 0) {
			jQuery('li#mainMenu ul.menu').show();
			slatwallMenuShowing = true;	
			jQuery('li#mainMenu ul.menu li').removeClass('selected');
			jQuery('li#mainMenu ul.menu li.adminmain').addClass('selected');
			displaySubMenu('li#mainMenu div.subMenuWrapper div.searchresults');
			slatwallSearchDelay = setTimeout("runToolbarSearch()",200);
		} else {
			jQuery('li#mainMenu ul.menu li').removeClass('selected');
			jQuery('li#mainMenu div.subMenuWrapper div.subMenu').hide();
		}
	});
	
	jQuery(document).click(function(e){
		if(slatwallMenuShowing) {
			if(!jQuery(e.target).parents('div.svocommontoolbarmenu').length) {
				toggleToolbarMenu(false);
			}
		}
	});
	
	jQuery(document).keydown(function(e) {
		if (e.keyCode == 27) {
			e.preventDefault();
			if(slatwallMenuShowing) {
				toggleToolbarMenu(false);	
			}
		}
		if (e.keyCode == 77 && e.ctrlKey) {
			e.preventDefault();
			if (!slatwallMenuShowing) {
				toggleToolbarMenu(true);
			}
		}
	});
	
});

function toggleToolbarMenu(showing) {
	if(showing) {
		jQuery('li#search > input').focus();
		jQuery('li#mainMenu ul.menu').show('fast', function(e){slatwallMenuShowing = true;});
	} else {
		slatwallMenuShowing = false;
		jQuery('li#search > input').blur();
		jQuery('li#search > input').val('');
		jQuery('li#mainMenu ul.menu').hide('fast');
		jQuery('li#mainMenu div.subMenuWrapper').hide();
		jQuery('li#mainMenu ul.menu li').removeClass('selected');
	}
}

function displaySubMenu(subSelector) {
	
	jQuery('li#mainMenu div.subMenuWrapper div.subMenu').hide();
	jQuery(subSelector).show();
	
	jQuery('li#mainMenu div.subMenuWrapper').show();
	jQuery('li#mainMenu div.subMenuWrapper').height(jQuery('li#mainMenu ul.menu').height() + 100);
	jQuery('li#mainMenu div.subMenuWrapper').offset(jQuery('li#mainMenu ul.menu').offset());
}

function runToolbarSearch(){
	jQuery.ajax({
		type: 'get',
		url: '/plugins/Slatwall/api/index.cfm/display/toolbarSearchResults/',
		data: {apiKey: slatwallToolbarSearchKey, keywords: jQuery('#SlatwallToolbarSearch').val()},
		dataType: "json",
		context: document.body,
		success: function(r) {
			jQuery('div.searchResults').replaceWith(r);
		}
	});
}