component persistent="false" accessors="true" output="false" extends="BaseController" {
	
	property name="productService" type="any";
	property name="accountService" type="any";
	property name="sessionService" type="any";
	
	public void function before(required any rc) {
		variables.fw.setView("frontend:event.blank");
	}
	
	public void function onsiterequeststart(required any rc) {

	}
	
	public void function onrenderstart(required any rc) {
		// This enables SEO friendly product URL's
		if( listLen(rc.path, "/") >= 3) {
			if( listGetAt(rc.path, 2, "/") == setting('product_urlKey') ) {
				if(rc.$.event('slatAction') == "") {
					
					url.filename = listGetAt(rc.path, 3, "/");
					rc.$.event('slatAction', 'frontend:product.detail');
					rc.$.content().setIsNew(0);
					rc.$.event('overrideContent', 1);
				}
			}
		}
	}
	
	public void function onrenderend(required any rc) {
		// Add necessary html to the header
		savecontent variable="html_head" {
			include "/plugins/#application.Slatwall.pluginConfig.getDirectory()#/frontend/layouts/inc/html_head.cfm";
		}
		var oldContent = rc.$.getEvent().getValue( "__MuraResponse__" );
		var newContent = Replace(oldContent, "</head>", "#html_head#</head>");
		rc.$.getEvent().setValue( "__MuraResponse__", newContent);
	}
	
	public void function ongloballoginsuccess(required any rc) {
		getAccountService().loginMuraUser(muraUser = arguments.rc.$.currentUser().getUserBean());
	}
	
}