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
<cfparam name="args.ProductID" default="" />
<cfparam name="args.CurrentLocation" default="00000000000000000000000000000000001" />

<cfset local.currentLocationArray = listToArray(args.CurrentLocation) />
<cfset local.productCategories = application.slatwall.productManager.getContentByProductID(ProductID=args.ProductID) />

<cfoutput>
	<div class="svoproductcontentassignment">
		<form action="index.cfm?action=product.contentassignment" name="ContentAssignment" method="post">
			<input type="hidden" name="ProductID" value="#args.ProductID#">
			
			<cfset local.index = "" />
			<cfset local.lastDepth = "" />
			<cfset local.loopCounter = 1 />
			<cfloop from="1" to="#arraylen(local.currentLocationArray)#" index="local.index">
				<cfset local.lastDepth = "#local.lastDepth##local.currentLocationArray[local.index]#," />
				<cfset local.DropDownQuery = "" />
				<cfquery name="local.DropDownQuery" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		  			select distinct contentid, title from tcontent where parentid = '#local.currentLocationArray[local.index]#' order by title asc
				</cfquery>
				<cfif local.DropDownQuery.recordcount gt 0>
				<select name="Select#local.index#" onChange="ContentSelectionChange('#local.lastDepth#', $('select[name=Select#local.index#] :selected').val())">
					<cfloop query="local.DropDownQuery">
						<cfset local.selected = "" />
						<cfif local.index neq arraylen(local.currentLocationArray)>
							<cfif local.DropDownQuery.contentid eq local.currentLocationArray[local.index+1]>
								<cfset local.selected = "selected=selected" />
							</cfif>
						</cfif>
						<option value="#local.DropDownQuery.contentid#" #local.selected#>#local.DropDownQuery.title#</option>
					</cfloop>
				</select>
				<br />
				<cfelse>
					<button type="submit" name="NewContentAssignmentID" value="#local.currentLocationArray[local.index]#" class="slatButton btnSmallAdd">Add</button>
				</cfif>
			</cfloop>
		</form>
	
		<script type="text/javascript">
			function ContentSelectionChange(lastDepth, currentSelection){
				var curLocation = lastDepth + currentSelection;
				var DisplaySettingsJSON = {
					"ProductID":"#args.ProductID#",
					"CurrentLocation":curLocation
				};
				getSVO("product/contentassignment", DisplaySettingsJSON);
			}
		</script>
		
		<form name="AssociationRemoval" method="Post" action="index.cfm?action=product.contentassignment">
			<input type="hidden" name="ProductID" value="#args.ProductID#">
			<table>
				<tbody>
					<tr>
						<th class="varWidth">Currently Located</th>
						<th class="administration">&nbsp;</th>
					</tr>
				</tbody>
				
				<cfloop query="local.productCategories">
					<cfset local.ThisContent = application.contentManager.getActiveContent(contentID=local.ProductCategories.ContentID, siteID=session.siteid) />
					<tr>
						<td class="varWidth">
						<cfset local.CrumbArray = local.ThisContent.getCrumbArray() />
						<cfloop to="1" from="#arrayLen(local.CrumbArray)#" step="-1" index="I">
							#local.CrumbArray[I].MenuTitle#<cfif I neq 1>&nbsp;&nbsp;>&nbsp;&nbsp;</cfif>
						</cfloop>
						</td>
						<td class="administration">
							<a href="http://#application.settingsManager.getSite(session.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(session.siteid,local.CrumbArray[1].filename)#" title="Preview" target="Preview">Preview</a>
							<button name="RemoveContentID" type="submit" Value="#local.ProductCategories.ContentID#">Remove</button>
						</td>
					</tr>
				</cfloop>
			</table>
		</form>
	</div>
</cfoutput>
