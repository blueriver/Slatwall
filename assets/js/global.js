/**
 * @depends /jquery-1.7.1.min.js
 * @depends /jquery-ui-1.8.16.custom.min.js
 * @depends /jquery-validate-1.9.0.min.js
 * @depends /bootstrap.min.js
 * 
 */

jQuery(document).ready(function(e){
	jQuery('.modalload').click(function(e){
		var modalLink = jQuery(this).attr( 'href' );
		if( modalLink.indexOf("?") != -1) {
			modalLink = modalLink + '&modal=1';
		} else {
			modalLink = modalLink + '?modal=1';
		}
		jQuery('#adminModal').load( modalLink );
	});
});