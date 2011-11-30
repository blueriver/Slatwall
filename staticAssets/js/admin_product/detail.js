/**
 * 
 * @depends /admin/core.js
 * 
 */

jQuery(document).ready(function() {
	
	jQuery('a.lightbox').colorbox();
	
	if(jQuery("a.preview").size()) {
	    jQuery("a.preview").imgPreview({
	        imgCSS: {
	            width: '150px'
	        }
	    });		
	}
	
});