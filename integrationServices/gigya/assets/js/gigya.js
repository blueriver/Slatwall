(function($){
	gigya.services.socialize.addEventHandlers({
		onLogin:gigyaOnLogin
	   }
	);
})( jQuery )

function gigyaAdminUnregisteredUser( eventObj ) {
	jQuery('#' + eventObj.context.accountLoginFormID ).prepend( '<p class="alert alert-info">We were unable to location an account that matches your social login, please login with your standard Slatwal username & password and your <strong>' + eventObj.provider + '</strong> profile will get attached to your account.</p>' );
}


function gigyaOnLogin( eventObj ) {
	
	if( eventObj.user.isSiteUID ) {
		
		
	} else {
		
		// Create the gigya inputs to add to the form
		var gigyaInputs = '<input type="hidden" name="gigyaUID" value="' + encodeURIComponent(eventObj.UID) + '" /><input type="hidden" name="gigyaUIDSignature" value="' + encodeURIComponent(eventObj.UIDSignature) + '" /><input type="hidden" name="gigyaSignatureTimestamp" value="' + encodeURIComponent(eventObj.signatureTimestamp) + '" />';
		
		// Add the gigya inputs to the login form if it exists
		if( 'context' in eventObj && 'accountLoginFormID' in eventObj.context ) {
			jQuery('#' + eventObj.context.accountLoginFormID).prepend( gigyaInputs );
		}
		
		// Add the gigya input to the create form if it exists
		if( 'context' in eventObj && 'accountCreateFormID' in eventObj.context ) {
			jQuery('#' + eventObj.context.accountCreateFormID).prepend( gigyaInputs );
		}
		
		if( 'context' in eventObj && 'unregisterdUserCallback' in eventObj.context ) {
			window[ eventObj.context.unregisterdUserCallback ]( eventObj );
		}
		
	}	
	
}