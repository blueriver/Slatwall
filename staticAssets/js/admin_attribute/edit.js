/**
 * 
 * @depends /admin/core.js
 */
 

$(document).ready(function(){
	
	// make sure attribute options form is displayed only for the right type of attributes
	$("select.attributeType").each(function(){
		var $selectedOption = $(this).find('option:selected').html();
		if(["Select Box","Radio Group","Check Box"].indexOf($selectedOption) > -1) {
			$(this).parents('form').find('.attributeOptions').show();
		}
	});
	
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

        // can't remove more options than were originally present
        if($('tr[id^="new"]').length == 0) {
            $('a.remOption').attr('style','display:none;');
        }
		return false;
    });

	$('select.attributeType').change(function(){
		//var id = $(this).attr("id");
		var $selectedOption = $(this).find('option:selected').html();
		if(["Select Box","Radio Group","Check Box"].indexOf($selectedOption) > -1) {
			$(this).parents('form').find('.attributeOptions').show();
		} else {
			$(this).parents('form').find('.attributeOptions').hide();
		}
	});	

});

function btnConfirmAttributeOptionDelete(message,link) {
    var attribOptionID = $(link).attr("id");
	$("#alertDialogMessage").html(message);
    $("#alertDialog").dialog({
            resizable: false,
            modal: true,
            buttons: {
                'YES': function() {
                    $(this).dialog('close');
                    deleteAttributeOption(attribOptionID);        
                    },
                'NO': function() {
                    $(this).dialog('close');
                }
            }
        });

    return false;   
}

function deleteAttributeOption(id){
	var params = {attributeOptionID: id, asynch: 'true', cacheID: Math.random()};
	
	$.post("index.cfm?slatAction=admin:attribute.deleteAttributeOption",params, function(data){
		if (data.SUCCESS) {
			$('tr#' + id).fadeOut('normal', function(){
				$(this).remove();
			});
		}
		else {
			$("#message" + id).html(data.MESSAGE).show("fast");
		}
	}, "json");
}	
	
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
