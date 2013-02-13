$(document).ready(function(e){
	
	$('.priarynav a').click(function(event) {
		if($(this).attr('href').charAt(0) === '#') {
			event.preventDefault();
		    $($(this).attr('href'))[0].scrollIntoView();
		    scrollBy(0, -40);
		}
	});
	
	$('.bs-docs-sidenav a').click(function(event) {
		if($(this).attr('href').charAt(0) === '#') {
		    event.preventDefault();
		    $($(this).attr('href'))[0].scrollIntoView();
		    scrollBy(0, -60);
		}
	});
	
	var offsetPlus = 0;
	if ($(window).width() <= 979) {
		var offsetPlus = 29;
	}
	$('[data-spy="affix"]').each(function () {
		var thisOffsetTop = ($($(this).closest('.row')).offset().top - 40) + offsetPlus;
		var thisOffsetBot = $(document).height() - $($(this).closest('.row')).height() - $($(this).closest('.row')).offset().top;
		$(this).data('offset-top', thisOffsetTop);
		$(this).data('offset-bottom', thisOffsetBot);
	});
});