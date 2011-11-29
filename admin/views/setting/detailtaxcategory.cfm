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
<cfparam name="rc.taxCategory" type="any" />
<cfparam name="rc.blankTaxCategoryRate" type="any" />
<cfparam name="rc.edit" type="boolean" /> 

<cfoutput>
	<div class="svoadminsettingdetailtaxcategory">
		<ul id="navTask">
	    	<cf_SlatwallActionCaller action="admin:setting.listtaxcategories" type="list">
			<cfif not rc.edit>
				<cf_SlatwallActionCaller action="admin:setting.edittaxcategory" queryString="taxCategoryID=#rc.taxCategory.getTaxCategoryID()#" type="list">
			</cfif>
		</ul>
		
		<cfif rc.edit>
			<form name="taxCategory" action="#buildURL(action='admin:setting.savetaxcategory')#" method="post">
			<input type="hidden" name="taxCategoryID" value="#rc.taxCategory.getTaxCategoryID()#" />
		</cfif>
		
		<dl class="twoColumn">
			<cf_SlatwallPropertyDisplay object="#rc.taxCategory#" property="taxCategoryName" edit="#rc.edit#" first="true">
		</dl>
		
		<table class="listing-grid stripe">
			<tr>
				<th class="varWidth">Address Zone</th>
				<th>Rate</th>
				<th class="administration">&nbsp;</th>
			</tr>
			<cfloop array="#rc.taxCategory.getTaxCategoryRates()#" index="local.tcr">
				<tr>
					<td class="varWidth">#local.tcr.getAddressZone().getAddressZoneName()#</td>
					<td>#local.tcr.getTaxRate()#</td>
					<td class="administration">
						<ul class="one">
							<cf_SlatwallActionCaller action="admin:setting.deletetaxcategoryrate" querystring="taxcategoryrateid=#local.tcr.getTaxCategoryRateID()#" class="delete" type="list">
						</ul>
					</td>
				</tr>
			</cfloop>
		</table>
		
		<cfif rc.edit>
			<hr />
			<strong>Add Rate</strong>
			<cf_SlatwallPropertyDisplay object="#rc.blankTaxCategoryRate#" property="addressZone" fieldName="addressZoneID" edit="#rc.edit#" first="true">	
			<cf_SlatwallPropertyDisplay object="#rc.blankTaxCategoryRate#" property="taxRate" edit="#rc.edit#" first="true">
			<button type="submit" name="addRate" value="true">Add Rate</button>
			<br /><br />	
			<cf_SlatwallActionCaller action="admin:setting.listtaxcategories" type="link" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
			<cf_SlatwallActionCaller action="admin:setting.savetaxcategory" type="submit" class="button">
			</form>
		</cfif>
		
	</div>
</cfoutput>