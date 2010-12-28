<cfcomponent extends="mxunit.framework.TestCase" output="false">
	<cffunction name="setUp" access="public">
	</cffunction>
	
	<cffunction name="Test_Me" access="public">
		<cfset assertEquals(1, 1) />
	</cffunction>
</cfcomponent>
