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

<ul id="navTask">
    <cf_SlatwallActionCaller action="admin:vendor.createvendor" type="list">
</ul>	
	
<div class="svoVendorList">
	<h3 class="tableheader">Vendors</h3>
	<table class="listtable">
		<tr>
			<th class="varWidth">Vendor Name</th>
			<th>Account Number</th>
			<th>Website</th>
			<th>&nbsp;</th>
		</tr>
		<cfloop array="#rc.vendorSmartList.getPageRecords()#" index="Local.Vendor">
			<tr>
				<td class="varWidth"><a href="#BuildURL(action='vendor.detailvendor', querystring='VendorID=#local.Vendor.getVendorID()#')#">#local.Vendor.getVendorName()#</a></td>
				<td>#Local.Vendor.getAccountNumber()#</td>
				<td><a href="#<!---getExternalSiteLink(--->local.Vendor.getVendorWebsite()<!---)--->#">#local.Vendor.getVendorWebsite()#</a></td>
				
				<td class="administration">
		          <ul class="three">
                      <cf_SlatwallActionCaller action="admin:vendor.editvendor" querystring="vendorID=#local.vendor.getVendorID()#" class="edit" type="list">            
					  <cf_SlatwallActionCaller action="admin:vendor.detailvendor" querystring="vendorID=#local.vendor.getVendorID()#" class="detail" type="list">
					  <cf_SlatwallActionCaller action="admin:vendor.deletevendor" querystring="vendorID=#local.vendor.getVendorID()#" class="delete" type="list" disabled="#NOT local.vendor.isDeletable()#" confirmrequired="true">
		          </ul>     						
				</td>
			</tr>
			
		</cfloop>
	</table>
</div>
</cfoutput>
<!---
<cfif isDefined('args.Brand')>
	<cfset local.VendorsIterator = args.Brand.getVendorsIterator() />
<cfelse>
	<cfset local.VendorOrganizer = application.slatwall.vendorManager.getQueryOrganizer() />
	<cfset local.VendorOrganizer.setFromCollection(url) />
	<cfset local.VendorsIterator = application.slatwall.vendorManager.getVendorIterator(local.VendorOrganizer.organizeQuery(application.Slatwall.vendorManager.getAllVendorsQuery())) />
</cfif>

<cfoutput>
<div class="svoVendorList">
	<h3 class="tableheader">Vendors</h3>
	<table class="listtable">
		<tr>
			<th>Company</th>
			<th>Primary Phone</th>
			<th>Primary EMail</th>
			<th>Website</th>
		</tr>
		<cfloop condition="#local.vendorsIterator.hasNext()#">
			<cfset local.Vendor = local.vendorsIterator.Next() />
			
			<tr>
				 <td><a href="#BuildURL(action='vendor.detail', querystring='VendorID=#local.Vendor.getVendorID()#')#">#local.Vendor.getCompany()#</a></td>
				<td>#local.Vendor.getPrimaryPhone()#</td>
				<td>#local.Vendor.getPrimaryEMail()#</td>
				<td><a href="#getExternalSiteLink(local.Vendor.getVendorWebsite())#">#local.Vendor.getVendorWebsite()#</a></td>
			</tr>
			
		</cfloop>
	</table>
</div>
</cfoutput>
--->
