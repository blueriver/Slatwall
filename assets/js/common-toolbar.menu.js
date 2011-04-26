$(document).ready(function(){
	$('li#mainMenu > a').click(function(e){
		toggleToolbarMenu(true);
	});
});

$(document).bind('keydown', 'Alt+s', function(e){
	e.preventDefault();
	toggleToolbarMenu(true);
});

$(document).bind('keydown', 'esc', function(e){
	e.preventDefault();
	toggleToolbarMenu(false);
});

function toggleToolbarMenu(toggle) {
	if(toggle) {
		$('li#search > input').focus();
		$('li#mainMenu > ul').show('fast');	
	} else {
		$('li#search > input').blur();
		$('li#search > input').val('');
		$('li#mainMenu > ul').hide('fast');	
	}
}