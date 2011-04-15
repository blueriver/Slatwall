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
<cfparam name="rc.section" default="Slatwall" />
<cfparam name="rc.activeTab" default=0 />
<cfparam name="rc.activePanel" default=0 />
<cfoutput>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-US">
<head>
    <title>#rc.sectionTitle# - #rc.itemTitle# &##124; Slatwall</title>
	<link rel="icon" href="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/images/icons/favicon.png" type="image/png" />
	<link rel="shortcut icon" href="#application.configBean.getContext()#/plugins/#getPluginConfig().getDirectory()#/images/icons/favicon.png" type="image/png" />
	
	[[assetWire]]
	
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckeditor/adapters/jquery.js"></script>
	<script type="text/javascript" src="#application.configBean.getContext()#/tasks/widgets/ckfinder/ckfinder.js"></script>
	
	
	#session.dateKey#
	<script type="text/javascript">
		jQuery(document).ready(function(){setDatePickers(".datepicker",dtLocale);setTabs(".tabs",#rc.activeTab#);setHTMLEditors();setAccordions(".accordion",#rc.activePanel#)});
	</script>
	
</head>
<body>
	<div id="header">
		<h1>Mura CMS</h1>
		#view("utility/header")#
		<p id="currentSite"><cf_ActionCaller text="#rc.sectionTitle#" action="#request.subsystem#:#request.section#" type="link"> &rarr; #rc.itemTitle#</p>
	</div>
	#view('utility/toolbar')#
	<div class="admincontainer">
		#view("utility/messageBox")#
		#body#
	</div>
<div id="alertDialog" title="Alert" style="display:none">
    <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span><span id="alertDialogMessage"></span></p>
</div>
<script type="text/javascript" language="javascript">
stripe('stripe');
</script>
</body>
</html>
</cfoutput>
