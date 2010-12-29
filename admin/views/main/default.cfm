<cfoutput>
<div class="svoadminmaindefault">
	Welcome To Slatwall Dashboard.<br />
	<br />
	This is the future home of customizable widgits<br />
	<hr />
	<h2>Sandbox</h2>
	<form name="TestForm" method="post" onSubmit="return slatFormSubmit(this);">
		<input type="hidden" name="action" value="admin:main.default" />
		Ajax Test Form Input One <input type="text" name="TestFormOne" /><br />
		Ajax Test Form Input Two <input type="text" name="TestFormTwo" /><br />
		<button type="submit">Submit</button>
	</form>
	<br />
	<cfif isDefined('rc.TestFormOne')>
		<strong>Test Form Result One:</strong> #rc.TestFormOne#<br />
	</cfif>
	<cfif isDefined('rc.TestFormTwo')>
		<strong>Test Form Result Two:</strong> #rc.TestFormTwo# 
	</cfif>
	<br />
	<br />
</div>
</cfoutput>
