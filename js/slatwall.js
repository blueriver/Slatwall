var search_delay = 0;
var svo_request_id = 0;
var ajax_request_id = 0;
var slat_pluginid = 2;

$(document).ready(function(){
	$('li.LogoSearch img').click(function(e){
		$('ul.MainMenu').show('fast');
		e.stopPropagation();
	});
	
	$("ul.MainMenu").click(function(e){
    	e.stopPropagation();
	});
	
	$("input.AdminSearch").val("");
	
	$("input.AdminSearch").keyup(function(){
		clearTimeout(search_delay);
		if($(this).val() != ''){
			search_delay = setTimeout("adminSearch()",200);
			$("div.svoutilitytoolbarsearch").css('display', 'block');
		}else{
			$("div.svoutilitytoolbarsearch").css('display', 'none');
		}
		
	});
});

$(document).click(function(e){
	$('ul.MainMenu').hide('fast');
});