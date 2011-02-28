component persistent="false" accessors="true" output="false" extends="mura.cfobject" {
	
	property name="fw" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		return this;
	}
	
	public void function subSystemBefore(required struct rc) {
		// Place any functionality that you would like applied on every request of this subsystem.
		
		if(rc.isContent) {
			rc.itemTitle = rc.$.Slatwall.rbKey("#request.subsystem#.#request.section#.#request.item#_title");
			if(right(rc.itemTitle, 8) == "_missing") {
				rc.itemTitle = rc.$.Slatwall.rbKey("#request.subsystem#.#request.section#.#request.item#");	
			}
			rc.$.content("title", rc.itemTitle);
		}

	}
}