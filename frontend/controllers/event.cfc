component persistent="false" accessors="true" output="false" extends="BaseController" {
	
	property name="productService" type="any";
	property name="accountService" type="any";
	
	public void function onrenderstart(required any rc) {
		
		// Check if the page requested is a porduct page
		if(left(rc.path,len(request.siteid) + 5) == '/#request.siteid#/sp/') {
			
			// Get Product Filename from path
			rc.Filename = Right(rc.path, len(rc.path)-(len(request.siteid) + 5));
			rc.Filename = Left(rc.Filename, len(rc.Filename)-1);
			
			// Setup Product in Request Scope
			request.muraScope.slatwall.Product = variables.productService.getByFilename(rc.Filename);
			
			// Force Product Information into the contentBean
			request.contentBean.setTitle(request.muraScope.slatwall.Product.getProductName());
			request.contentBean.setBody(request.muraScope.slatwall.Product.getProductDescription());
			
			// Override crumbdata with the last page that was loaded
			if(isDefined("session.slat.crumData")) {
				request.crumbdata = duplicate(session.slat.crumbdata);
				request.contentrenderer.crumbdata = duplicate(session.slat.crumbdata);
			}
			
			// Set template based on Product Template
			request.contentBean.setIsNew(0);
			if(request.muraScope.slatwall.Product.getTemplate() != "") {
				request.contentBean.setTemplate(request.muraScope.slatwall.Product.getTemplate());
			}
		} else {
			session.slat.crumbdata = duplicate(request.crumbdata);
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
}