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
		<title>#rc.pageTitle# &##124; Slatwall</title>
		
		<link rel="icon" href="#$.slatwall.getSlatwallRootPath()#/assets/images/favicon.png" type="image/png" />
		<link rel="shortcut icon" href="#$.slatwall.getSlatwallRootPath()#/assets/images/favicon.png" type="image/png" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		#$.slatwall.getCFStatic().renderIncludes("css")#
		<script type="text/javascript">
			var slatwall = {
				dateFormat : '#$.slatwall.setting("advanced_dateFormat")#',
				timeFormat : '#$.slatwall.setting("advanced_timeFormat")#'
			};
		</script>
	</head>
	<body>
		<div class="navbar navbar-fixed-top">
			<div class="navbar-inner">
				<div class="container-fluid">
					<ul class="nav">
						<a href="#buildURL(action='admin:main.default')#" class="brand"><img src="#$.slatwall.getSlatwallRootPath()#/assets/images/admin.logo.png" title="Slatwall" /></a>
						<li class="dropdown">
							<a href="##" class="dropdown-toggle"	data-toggle="dropdown">Reload<b class="caret"></b></a>
							<ul class="dropdown-menu">
								<li><a href="#$.slatwall.getSlatwallRootPath()#/?reload=true" />Slatwall</a></li>
								<li><a href="/admin/index.cfm?appreload&reload=appreload" />Mura</a></li>
							</ul>
						</li>
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
		<div id="adminModal" class="modal fade"></div>
		<div id="adminDisabled" class="modal">
			<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>#$.slatwall.rbKey('define.disabled')#</h3></div>
			<div class="modal-body"></div>
			<div class="modal-footer">
				<a href="##" class="btn btn-inverse" data-dismiss="modal"><i class="icon-ok icon-white"></i> #$.slatwall.rbKey('define.ok')#</a>
			</div>
		</div>
		<div id="adminConfirm" class="modal">
			<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>#$.slatwall.rbKey('define.confirm')#</h3></div>
			<div class="modal-body"></div>
			<div class="modal-footer">
				<a href="##" class="btn btn-inverse" data-dismiss="modal"><i class="icon-remove icon-white"></i> #$.slatwall.rbKey('define.no')#</a>
				<a href="##" class="btn btn-primary"><i class="icon-ok icon-white"></i> #$.slatwall.rbKey('define.yes')#</a>
			</div>
		</div>
		#$.slatwall.getCFStatic().renderIncludes("js")#
		<script type="text/javascript" src="#$.slatwall.getSlatwallRootPath()#/org/ckeditor/ckeditor.js"></script>
		<script type="text/javascript" src="#$.slatwall.getSlatwallRootPath()#/org/ckeditor/adapters/jquery.js"></script>
	</body>
</html>
</cfoutput>