component persistent="false" accessors="true" output="false" extends="Slatwall.com.utility.BaseObject" {
	
	property name="fw" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		
		return this;
	}
	
	public void function subSystemBefore(required struct rc) {
		
		// If user is not logged in redirect to front end otherwise If the user does not have access to this, then display a page that shows "No Access"
		if (getUserRoles() == "") {
			// TODO: Set this location as something more dynamic
			location("http://#cgi.http_host#/#session.siteid#/index.cfm?display=login&returnURL=http://#cgi.http_host#/plugins/Slatwall/?slatAction=#rc.slatAction#", false);
		} else if( getFW().secureDisplay(rc.slatAction) == false ) {
			getFW().setView("admin:main.noaccess");
		}
		
		// Place any functionality that you would like applied on every request of this subsystem.
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