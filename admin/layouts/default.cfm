<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfoutput>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>#rc.$.slatwall.rbKey(replace(rc.slatAction,":",".","all"))# &##124; Slatwall</title>
		
		<link rel="icon" href="#$.slatwall.getSlatwallRootPath()#/assets/images/favicon.png" type="image/png" />
		<link rel="shortcut icon" href="#$.slatwall.getSlatwallRootPath()#/assets/images/favicon.png" type="image/png" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link href="#$.slatwall.getSlatwallRootPath()#/org/bootstrap/css/bootstrap.css" rel="stylesheet">
	</head>
	<body>
		<div class="navbar navbar-fixed-top">
			<div class="navbar-inner">
				<div class="container-fluid">
					<ul class="nav">
						<a href="#buildURL(action='admin:main.default')#" class="brand"><img src="#$.slatwall.getSlatwallRootPath()#/assets/images/admin.logo.png" title="Slatwall" /></a>
					</ul>
				</div>
			</div>
		</div>
		<div class="container-fluid">
			<div class="row-fluid" style="margin-top:60px;">
				#body#
			</div>
		</div>
		<div class="navbar navbar-fixed-bottom">
			<div class="navbar-inner">
				<div class="container-fluid">
					<ul class="nav">
						<cf_SlatwallActionCaller action="admin:main" type="list" icon="home icon-white" iconOnly=true>
						<form class="navbar-form pull-left">
  							<input type="text" class="span2">
						</form>
						<cf_SlatwallActionCaller action="admin:product" type="list" icon="pencil icon-white">
						<cf_SlatwallActionCaller action="admin:pricing" type="list" icon="tags icon-white">
						<cf_SlatwallActionCaller action="admin:order" type="list" icon="inbox icon-white">
						<cf_SlatwallActionCaller action="admin:account" type="list" icon="user icon-white">
						<cf_SlatwallActionCaller action="admin:vendor" type="list" icon="list-alt icon-white">
						<cf_SlatwallActionCaller action="admin:warehouse" type="list" icon="barcode icon-white">
						<cf_SlatwallActionCaller action="admin:integration" type="list" icon="random icon-white">
						<cf_SlatwallActionCaller action="admin:report" type="list" icon="th-list icon-white">
						<cf_SlatwallActionCaller action="admin:setting" type="list" icon="user icon-white">
						<cf_SlatwallActionCaller action="admin:help" type="list" icon="user icon-white">
					</ul>
				</div>
			</div>
		</div>
		<script src="#$.slatwall.getSlatwallRootPath()#/staticAssets/js/tools/jquery/jquery-1.7.1.js"></script>
    	<script src="#$.slatwall.getSlatwallRootPath()#/org/bootstrap/js/bootstrap.js"></script>
	</body>
</html>
</cfoutput>


<!---
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-US">
<head>
    <title>#rc.sectionTitle# - #rc.itemTitle# &##124; Slatwall</title>
	<link rel="icon" href="#$.slatwall.getSlatwallRootPath()#/staticAssets/images/favicon.png" type="image/png" />
	<link rel="shortcut icon" href="#$.slatwall.getSlatwallRootPath()#/staticAssets/images/favicon.png" type="image/png" />
	<script type="text/javascript">
		var dtLocale = "#session.dtLocale#";
	</script>
</head>
<body>
	<!---#application.pluginManager.renderAdminToolbar(jsLib="jquery", jsLibLoaded=true)#--->
	#view("admin:toolbar/menu")#
	<div id="header">
		<a href="#buildURL('admin:main')#"><img class="slatwallLogo" src="#$.slatwall.getSlatwallRootPath()#/staticAssets/images/admin.default.slatwall_logo.png" height="16" width="100" alt="Slatwall Ecommerce" /></a>
		<p id="currentSite"><cf_SlatwallActionCaller text="#rc.sectionTitle#" action="#request.subsystem#:#request.section#" type="link"> &rarr; #rc.itemTitle#</p>
	</div>
	
	<div id="admincontainer">
		#view("admin:includes/message")#
		#body#
		<br class="clear" />
		<br class="clear" />
	</div>
	
	<div id="alertDialog" title="Alert" style="display:none">
	    <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span><span id="alertDialogMessage"></span></p>
	</div>
	<script type="text/javascript" src="#$.slatwall.getSlatwallRootPath()#/org/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="#$.slatwall.getSlatwallRootPath()#/org/ckeditor/adapters/jquery.js"></script>
</body>
</html>
--->