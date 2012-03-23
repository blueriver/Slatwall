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
<cfparam name="rc.currentVersion" type="string" />
<cfparam name="rc.currentBranch" type="string" />
<cfparam name="rc.availableDevelopVersion" type="string" />
<cfparam name="rc.availableMasterVersion" type="string" />

<cfset local.updateOptions = [{name="Stable", value="master"},{name="Bleeding Edge", value="develop"}] />
<cfoutput>
	<div class="svoadminsettingdetailslatwallupdate">
		<ul id="navTask">
			
		</ul>
		<h2>Update Slatwall</h2>
		<dl class="twoColumn">
			<dt>Current Version</dt>
			<dd>#rc.currentVersion#</dd>
			<dt>Current Release Type</dt>
			<cfif rc.currentBranch eq "master">
				<dd>Stable</dd>
			<cfelse>
				<dd>Bleeding Edge</dd>
			</cfif>
			<dt>Available Stable Version</dt>
			<dd>#rc.availableMasterVersion#</dd>
			<dt>Available Bleeding Edge Version</dt>
			<dd>#rc.availableDevelopVersion#</dd>
		</dl>
		<hr class="clear" />
		<form method="post">
			<input type="hidden" name="slatAction" value="admin:setting.updateSlatwall" />
			<select name="updateBranch">
				<cfloop array="#local.updateOptions#" index="local.updateOption" >
					<option value="#local.updateOption.value#" <cfif rc.currentBranch eq local.updateOption.value>selected="selected"</cfif>>#local.updateOption.name#</option>
				</cfloop>
			</select>
			<cf_SlatwallActionCaller action="admin:setting.updateSlatwall" class="btn btn-primary" confirmRequired="true">
		</form>
	</div>
</cfoutput>