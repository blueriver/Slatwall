<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-US">
<head>
	<cfinclude template="inc/html_head.cfm" />
	<link rel="stylesheet" type="text/css" href="css/slatwall_admin.css" media="all" />
</head>
<body>
<cfoutput>
	#view('utility/toolbar')#
	<div style="padding: 20px 0px 60px 0px">
		#body#
	</div>
</cfoutput>
</body>
</html>