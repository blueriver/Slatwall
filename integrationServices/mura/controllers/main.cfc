component extends="Slatwall.org.Hibachi.HibachiController" output="false" accessors="true"  {

	property name="hibachiUtilityService" type="any";

	this.secureMethods="default,updateviews";
	
	public void function updateViews() {
		var baseSlatwallPath = getDirectoryFromPath(expandPath("/muraWRM/plugins/Slatwall/frontend/views/")); 
		var baseSitePath = getDirectoryFromPath(expandPath("/muraWRM/#rc.siteid#/includes/display_objects/custom/slatwall/"));

		gethibachiUtilityService().duplicateDirectory(baseSlatwallPath,baseSitePath,true,true,".svn");
		getFW().redirect(action="admin:main");
	}
	
}