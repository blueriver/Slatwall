<cfcomponent accessors="true" output="false" extends="Slatwall.org.Hibachi.HibachiDAO">
	<cfscript>
		private string function createSlatwallUUID() {
			return createHibachiUUID();
		}
	</cfscript>
</cfcomponent>