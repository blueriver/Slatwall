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
		search_delay = setTimeout("adminSearch()",200);
	}
}

function adminSearch(){
	slatwallAjaxFormSubmit(search_form);
}

$(document).click(function(e){
	$('ul.MainMenu').hide('fast');
});