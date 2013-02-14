$(document).ready(function(e){
	
	$(window).on('load', function() {
		var hashArray = window.location.hash.split('#');
		if(hashArray.length > 1) {
			subArray = hashArray[1].split('-');
			if(subArray.length > 1) {
				scrollBy(0, -60);
			} else {
				scrollBy(0, -40);
			}
		}
	});
	
	$(window).on('hashchange', function() {
		var hashArray = window.location.hash.split('#');
		if(hashArray.length > 1) {
			subArray = hashArray[1].split('-');
			if(subArray.length > 1) {
				scrollBy(0, -60);
			} else {
				scrollBy(0, -40);
			}
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