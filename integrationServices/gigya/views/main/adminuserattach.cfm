<cfparam name="url.UID" default="" />
<cfparam name="url.UIDSig" default="" />
<cfparam name="url.UIDSignature" default="" />

<cfoutput>
	<form method="post" action="?s=1">
		<input type="hidden" name="slatAction" value="gigya:main.userattach" />
		<input type="hidden" name="UID" value="#url.UID#" />
		<input type="hidden" name="UIDSig" value="#url.UIDSig#" />
		<input type="hidden" name="UIDSignature" value="#url.UIDSignature#" />
		
		Email: <input type="text" name="emailAddress" value="" /><br />
		
		Password: <input type="password" name="password" value="" />
		
		<button type="submit">Attach Gigya Account</button>
	</form>
</cfoutput>