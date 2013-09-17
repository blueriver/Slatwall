(function($){
	gigya.services.socialize.addEventHandlers({
		onLogin:gigyaOnLogin
	   }
	);
})(jQuery)

function gigyaOnLogin( eventObj ) {
	
	console.log( eventObj );
	
	if(eventObj.user.isSiteUID) {

		// Authenticate the user
		//console.log( 1 );
	
	} else {

		// Redirect to the attach user page
		var redirectURL = $.slatwall.getConfig()['baseURL'];
		redirectURL += '/?slatAction=gigya:main.attachExistingUserAdminForm&UID=';
		redirectURL += encodeURIComponent(eventObj.UID);
		redirectURL += '&UIDSig=';
		redirectURL += encodeURIComponent(eventObj.UIDSig);
		redirectURL += '&UIDSignature=';
		redirectURL += encodeURIComponent(eventObj.UIDSignature);
		
		window.location.href = redirectURL;
		
	}	
	
	
	/*
	if (thisContent == "registrationForm") {
   		if (eventObj.user.firstName && eventObj.user.lastName) {
	   		$("#firstName").val(eventObj.user.firstName);
	   		$("#lastName").val(eventObj.user.lastName);
	   		$("#email").val(eventObj.user.email);
	   		$("#emailConfirm").val(eventObj.user.email);
	   		$("#regGUID").val(gUID);
	   		$("#regSig").val(gigyaSig);
	   		$("#regTimestamp").val(gigyaTimestamp);


	   		if (eventObj.user.thumbnailURL) {
	   			imgSrc = '<img src="'+eventObj.user.thumbnailURL+'" alt="'+eventObj.user.nickname+'" style="float:left; margin-right:10px;" class="gigyaThumbnail">';
	   		}
	   		$("#gigyaRegistration").html(imgSrc+'<h6 style="margin-top:10px;">Welcome, '+eventObj.user.nickname+'!</h6><p>You are almost done. Please complete the highlighted<span style="color:red">*</span> fields below to complete your registration.</p>');
	   		$(".gigyaHighlightedStar").show();
	   		if (!eventObj.user.email) {
	   			$(".gigyaHighlightedStarEmail").show();
	   		}
		}
	}
	else {
		if (!eventObj.user.isSiteUID) {
			$(".gServiceProvider").text(eventObj.user.loginProvider);
			$(".gFirstName").text(eventObj.user.firstName);
			$("#gigyaUID").val(gUID);
			$("#gigyaSig").val(gigyaSig);
			$("#gigyaTimestamp").val(gigyaTimestamp);
	   		if (eventObj.user.thumbnailURL) {
	   			$(".gigyaThumbnail").html('<img src="'+eventObj.user.thumbnailURL+'" alt="'+eventObj.user.nickname+'">');
	   		}
	   		$("#gLinkAccountsOverlay").show(100);
		}
		else {
			authenticateThroughGigya(eventObj);
		}
	}
	*/

}

/*
	function authenticateThroughGigya(eventObj) {

		if (eventObj.user.isSiteUID && eventObj.user.UID != ''	) {
			gUID = eventObj.user.UID;
			gigyaSig = eventObj.UIDSignature;
			gigyaTimestamp = eventObj.signatureTimestamp;
			var imgSrc = '';
			thisContent = '0';
			if (eventObj.context) {
				thisContent = eventObj.context;
			}

			gPostURL = '';
			gPostURLs = '';
			var thisHost = window.location.host;
			if (thisHost.search("blogs.scientificamerican.com") != '-1') {
				gPostURL = "http://www.scientificamerican.com";	
				gPostURLs = "http://blogs.scientificamerican.com/gigya.php?path=";	
			}
			logOutLink = '/logout';
			if (gPostURL != '') {
				logOutLink = 'http://www.scientificamerican.com/?logout=1'
			}
			$.post(gPostURLs+"/view/utils/overlays.cfc?method=gLogin", {gUID: gUID, gigyaSig: gigyaSig, gigyaTimestamp: gigyaTimestamp}, function(gLogin) {
				if (gLogin.ERROR) {

				} else {
					if (eventObj.user.thumbnailURL) {
			   			imgSrc = '<img src="'+eventObj.user.thumbnailURL+'" alt="'+gLogin.USERNAME+'" style="float:left; margin-right:5px; max-height:25px !important; margin-top:-5px !important; margin-bottom:-5px !important">';
			   		}
					$("#userLinks").html(imgSrc+'Hello, <a href="'+gPostURL+'/page.cfm?section=my-account" rel="nofollow">'+gLogin.USERNAME+'</a> (<a id="logOutGlobal" onclick="gigyaLogOut(this); return false;" href="'+logOutLink+'" style="font-weight:normal !important;" rel="nofollow">sign out</a>)');

					firstLoginFunction(eventObj);
				}

			}, "json");
		}


	}

	function firstLoginFunction(e) {
		thisContent = '0';
		if (e.context) {
			thisContent = e.context;
		}
		if (thisContent == "firstLogin") {
			if (gPostURL != "") {
				window.location = "http://www.scientificamerican.com/page.cfm?section=loginBlogs&UID="+gUID+"&sig="+gigyaSig+"&timestamp="+gigyaTimestamp;
			}
			else {
				window.location.reload();
			}
		}
		if (thisContent.indexOf("logInPage|") != '-1') {
			var refURL = thisContent.substring(10)
			window.location = refURL;
		}

	}
	function gigyaLogOut (e) {
		gigya.services.socialize.logout({callback:function test(response){window.location = e.href;}});
		return false;

	}
*/