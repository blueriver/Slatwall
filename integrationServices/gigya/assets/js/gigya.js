(function($){
	gigya.services.socialize.addEventHandlers({
		onLogin:gigyaOnLogin
	   }
	);
})( jQuery )

function gigyaOnLogin( eventObj ) {
	
	console.log( eventObj );
	
	/*
	if(eventObj.user.isSiteUID) {
		
		// Post to the gigya:main.loginGigyaUser
		
		// If the response is successful, look for a sRedirectURL
		
		// If the response is failure, look for a fRedirectURL
		
		// Redirect to the attach user page
		var redirectURL = $.slatwall.getConfig()['baseURL'];
		redirectURL += '/?slatAction=gigya:main.loginGigyaUser&UID=';
		redirectURL += encodeURIComponent(eventObj.UID);
		redirectURL += '&UIDSig=';
		redirectURL += encodeURIComponent(eventObj.UIDSig);
		redirectURL += '&UIDSignature=';
		redirectURL += encodeURIComponent(eventObj.UIDSignature);
		
		window.location.href = redirectURL;
	
	} else {

		// Redirect to the attach user / create user page
		var redirectURL = $.slatwall.getConfig()['baseURL'];
		redirectURL += '/?slatAction=gigya:main.attachExistingUserAdminForm&UID=';
		redirectURL += encodeURIComponent(eventObj.UID);
		redirectURL += '&UIDSig=';
		redirectURL += encodeURIComponent(eventObj.UIDSig);
		redirectURL += '&UIDSignature=';
		redirectURL += encodeURIComponent(eventObj.UIDSignature);
		
		window.location.href = redirectURL;
		
	}	
	*/
	
}