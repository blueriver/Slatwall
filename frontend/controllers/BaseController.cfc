component persistent="false" accessors="true" output="false" extends="Slatwall.com.utility.BaseObject" {
	
	property name="fw" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		return this;
	}
	
	public void function subSystemBefore(required struct rc) {
		param name="rc.overrideContent" default="false";
		
		// Place any functionality that you would like applied on every request of this subsystem.
		rc.itemTitle = rc.$.Slatwall.rbKey("#request.subsystem#.#request.section#.#request.item#_title");
		if(right(rc.itemTitle, 8) == "_missing") {
			rc.itemTitle = rc.$.Slatwall.rbKey("#request.subsystem#.#request.section#.#request.item#");	
		}
		var eventAction = getFW().getSubsystem(rc.$.event("slatAction")) & ":" & getFW().getSectionAndItem(rc.$.event("slatAction"));
		if(rc.overrideContent == true && rc.slatAction == eventAction) {
			rc.$.content().setTitle(rc.itemTitle);
			rc.$.content().setHTMLTitle(rc.itemTitle);	
		}
	}
}