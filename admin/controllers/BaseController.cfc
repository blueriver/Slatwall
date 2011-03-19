component persistent="false" accessors="true" output="false" extends="Slatwall.com.utility.BaseObject" {
	
	property name="fw" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		
		return this;
	}
	
	public void function subSystemBefore(required struct rc) {
		
		// If user is not logged in redirect to front end otherwise If the user does not have access to this, then display a page that shows "No Access"
		if (!structKeyExists(session, "mura") || !len($.currentUser().getMemberships())) {
			var loginURL = "#getFW().getSubsystemBaseURL('frontend')##$.siteConfig().getLoginURL()#";
			if(find("?",loginURL)) {
				loginURL &= "&returnURL=#URLEncodedFormat("#getFW().getSubsystemBaseURL('admin')#?slatAction=#rc.slatAction#")#";	
			} else {
				loginURL &= "?&returnURL=#URLEncodedFormat("#getFW().getSubsystemBaseURL('admin')#?slatAction=#rc.slatAction#")#";
			}
			location(url=loginURL, addtoken=false);
		} else if( getFW().secureDisplay(rc.slatAction) == false ) {
			getFW().setView("admin:main.noaccess");
		}
		
		// Set default section title and default item title 
		rc.sectionTitle = rc.$.Slatwall.rbKey("#request.subsystem#.#request.section#_title");
		if(right(rc.sectionTitle, 8) == "_missing") {
			rc.sectionTitle = rc.$.Slatwall.rbKey("#request.subsystem#.#request.section#");
		}
		rc.itemTitle = rc.$.Slatwall.rbKey("#request.subsystem#.#request.section#.#request.item#_title");
		if(right(rc.itemTitle, 8) == "_missing") {
			rc.itemTitle = rc.$.Slatwall.rbKey("#request.subsystem#.#request.section#.#request.item#");	
		}
	}
}