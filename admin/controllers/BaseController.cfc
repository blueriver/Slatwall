component persistent="false" accessors="true" output="false" extends="Slatwall.com.utility.BaseObject" {
	
	property name="fw" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		
		return this;
	}
	
	public void function subSystemBefore() {
		// Place any functionality that you would like applied on every request of this subsystem.
		rc.sectionTitle = rc.$w.rbKey("#request.subsystem#.#request.section#_title");
		if(right(rc.sectionTitle, 8) == "_missing") {
			rc.sectionTitle = rc.$w.rbKey("#request.subsystem#.#request.section#");
		}
		rc.itemTitle = rc.$w.rbKey("#request.subsystem#.#request.section#.#request.item#_title");
		if(right(rc.itemTitle, 8) == "_missing") {
			rc.itemTitle = rc.$w.rbKey("#request.subsystem#.#request.section#.#request.item#");	
		}
	}
	
}