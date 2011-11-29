/**
 * 
 * @depends /admin/core.js
 * @depends /tools/colorbox/jquery.colorbox-min.js
 * @depends /tools/imgpreview/imgPreview-min.js
 * 
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