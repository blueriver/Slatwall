component persistent="false" accessors="true" output="false" extends="BaseController" {
	
	property name="productService" type="any";
	property name="accountService" type="any";
	property name="sessionService" type="any";
	
	public void function before(required any rc) {
		// Because these are all just mura events we set the view to Blank;
		param name="request.gregstest" default="";
		request.gregstest &= "#request.gregstest#,#rc.action#";
		variables.fw.setView("frontend:event.blank");
	}
	
	public void function onsiterequeststart(required any rc) {
		// Check if the page requested is a porduct page
		if(left(rc.path,len(request.siteid) + 5) == '/#request.siteid#/sp/') {
			
			// Get Product Filename from path
			var productFilename = Right(rc.path, len(rc.path)-(len(request.siteid) + 5));
			productFilename = Left(productFilename, len(productFilename)-1);
			
			// Setup Product in Slatwall Scope
			request.slatwallScope.setCurrentProduct(variables.productService.getByFilename(productFilename));
		}
	}
	
	public void function onrenderstart(required any rc) {
		if(rc.$.Slatwall.getCurrentProduct().isNew() == false) {
			// Force Product Information into the contentBean
			request.contentBean.setTitle(request.slatwallScope.getCurrentProduct().getProductName());
			request.contentBean.setBody(request.slatwallScope.getCurrentProduct().getProductDescription());
			
			// Override crumbdata with the last page that was loaded
			request.crumbdata = getSessionService().getCurrent().getLastCrumbData();
			request.contentrenderer.crumbdata = getSessionService().getCurrent().getLastCrumbData();
			
			// Set template based on Product Template
			request.contentBean.setIsNew(0);
			if(request.slatwallScope.getCurrentProduct().getTemplate() != "") {
				request.contentBean.setTemplate(request.slatwallScope.getCurrentProduct().getTemplate());
			}
		} else {
			getSessionService().getCurrent().setLastCrumbData(duplicate(request.crumbdata));
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