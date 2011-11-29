/**
 * 
 * @depends /admin/core.js
 */

$(document).ready(function() {
	$('a.lightbox').colorbox();
	if($("a.preview").size()) {
	    $("a.preview").imgPreview({
	        imgCSS: {
	            width: '150px'
	        }
	    });		
	}
});