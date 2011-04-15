
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

$.use('/admin/js/jquery/jquery-ui.js');
$.use('/admin/js/jquery/jquery-ui-i18n.js');
$.use('/admin/js/admin.js');

var search_delay = 0;
var search_form = 0;
var svo_request_id = 0;
var ajax_request_id = 0;

$(document).ready(function(){
	$('li.LogoSearch img').click(function(e){
		$('ul.MainMenu').show('fast');
		e.stopPropagation();
	});
	
	$("ul.MainMenu").click(function(e){
    	e.stopPropagation();
	});
	
	$("input.AdminSearch").val("");

});

function toolbarSearchKeyup(form){
	clearTimeout(search_delay);
	search_form = form;
	if($("input.AdminSearch").val() != ''){
		search_delay = setTimeout("adminSearch()",280);
	}
}

function adminSearch(){
	slatwallAjaxFormSubmit(search_form);
}

function btnConfirmDialog(message,btn){
    
    jQuery("#alertDialogMessage").html(message);
    jQuery("#alertDialog").dialog({
            resizable: false,
            modal: true,
            buttons: {
                'YES': function() {
                    jQuery(this).dialog('close');
                    btn.form.submit();        
                    },
                'NO': function() {
                    jQuery(this).dialog('close');
                }
            }
        });

    return false;   
}

$(document).click(function(e){
	$('ul.MainMenu').hide('fast');
});