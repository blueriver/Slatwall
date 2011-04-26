/* This file is part of Mura CMS. 

	Mura CMS is free software: you can redistribute it and/or modify 
	it under the terms of the GNU General Public License as published by 
	the Free Software Foundation, Version 2 of the License. 

	Mura CMS is distributed in the hope that it will be useful, 
	but WITHOUT ANY WARRANTY; without even the implied warranty of 
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
	GNU General Public License for more details. 

	You should have received a copy of the GNU General Public License 
	along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. 

	However, as a special exception, the copyright holders of Mura CMS grant you permission 
	to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1. 

	In addition, as a special exception,  the copyright holders of Mura CMS grant you permission 
	to combine Mura CMS  with independent software modules that communicate with Mura CMS solely 
	through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API, 
	provided that these modules (a) may only modify the  /trunk/www/plugins/ directory through the Mura CMS 
	plugin installation API, (b) must not alter any default objects in the Mura CMS database 
	and (c) must not alter any files in the following directories except in cases where the code contains 
	a separately distributed license.

	/trunk/www/admin/ 
	/trunk/www/tasks/ 
	/trunk/www/config/ 
	/trunk/www/requirements/mura/ 

	You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include  
	the source code of that other code when and as the GNU GPL requires distribution of source code. 

	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception 
	for your modified version; it is your choice whether to do so, or to make such modified version available under 
	the GNU General Public License version 2  without this exception.  You may, if you choose, apply this exception 
	to your own modified versions of Mura CMS. */

$(document).ready(function(){
	var optionsCount = $('tr[id^="option"]').length;
	$("#showSort").click(function(){
		$("#attributeList").sortable().disableSelection();
		$('#showSort').hide();
		$('#saveSort').show();
		
		$(".handle").each(
			function(index) {
				$(this).show();
			}
		);
		return false;
	});
	
	$("#saveSort").click(function(){
		var attArray=new Array();
		
		$("#attributeList > li").each(
			function(index) {
				attArray.push( $(this).attr("id") );
			}
		);
		
		var url = "index.cfm";
		var pars = 'slatAction=admin:attribute.saveattributesort&attributeID=' + attArray.toString() + '&cacheID=' + Math.random();	
		
		$.post(url + "?" + pars); 
		showSort();
	});
	
    $('a.addOption').click(function() {
		var attribID = $(this).attr("attribID");
		var current = $('tr.' + attribID).length;
        current++;
        var $newOption= $( "#tableTemplate tbody>tr:last" ).clone(true);
        $newOption.children("td").children("input").each(function(i) {
            var $currentElem= $(this);
            $currentElem.attr("name", "options[" + current + "]." + $currentElem.attr("name"));
        });
        $('a[class=remOption][attribID=' +attribID+ ']').attr('style','');
        $('#attrib' + attribID + ' > tbody:last').append($newOption);
        $newOption.attr("class",attribID).attr("id","new" + current + attribID);
		return false;
    });
	
    $('a.remOption').click(function() {
		var attribID = $(this).attr("attribID");
        var num = $('tr.' + attribID).length;
		$("#attrib" + attribID + " tbody>tr:last").remove();
		//alert(num);
        //$('#option' + num).remove();
        // can't remove more options than were originally present
        if($('tr[id^="new"]').length == 0) {
            $('a.remOption').attr('style','display:none;');
        }
		return false;
    });
});
	
function showSort(id){
	$('#showSort').show();
	$('#saveSort').hide();
	
	$(".handle").each(
		function(index) {
			$(this).hide();
		}
	);
	$("#attributeList").sortable('destroy').enableSelection();
}
