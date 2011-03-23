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
<cfparam name="rc.es" default="http://www.google.com/" />
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-US">
<head>
	<script type="text/javascript" src="/default/includes/themes/nytro/js/jquery-1.3.1.min.js"></script>
	<script type="text/javascript" src="js/slatwall.js"></script>
	<link rel="stylesheet" type="text/css" href="css/slatwall_admin.css" media="all" />
	<link rel="stylesheet" type="text/css" href="css/slatwall_toolbar.css" media="all" />
	<script type="text/javascript">
		$(document).ready(function(){
			$('#ExternalSite').height($('body').height()-27); 
		});
	</script>
	<style type="text/css">
		body, html {height:100%;}
	</style>
</head>
<body>
<cfif left(rc.es,4) neq "http">
	<cfset rc.es = "http://#rc.es#" />
</cfif>
<cfoutput>
	<iframe name="ExternalSite" id="ExternalSite" style="border:none; width:100%;" src="#rc.es#" ></iframe>
	#view('utility/toolbar')#
</cfoutput>
</body>
</html>
