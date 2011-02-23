component persistent="false" accessors="true" output="false" extends="Slatwall.com.utility.BaseObject" {
	
	property name="fw" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		
		return this;
	}
	
	public void function subSystemBefore(required struct rc) {
		// If the user does not have access to this, then display a page that shows "No Access"
		
		if( getFW().secureDisplay(rc.action) == false ) {
			getFW().setView("admin:main.noaccess");
		} else if ( listLen(getUserRoles()) == 0) {
			location("http://#cgi.http_host#/?display=login", false);
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