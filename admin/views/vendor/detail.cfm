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
<div class="svoVendorDetail">
	<div class="TCLeftTThird">	
		<div class="ItemDetailMain">
			<dl class="HeaderItem">
				<dt>Vendor</dt>
				<dd>#rc.Vendor.getVendorName()#</dd>
			</dl>
			<dl>
				<dt>Account Number</dt>
				<dd>#rc.Vendor.getAccountNumber()#</dd>
			</dl>
			<!---
			<dl>
				<dt>Primary Phone</dt>
				<dd>#rc.Vendor.getPhoneNumbers().getDefaultPhone()#</dd>
			</dl>
			--->
			<!---
			<dl>
				<dt>Primary E-Mail</dt>
				<dd><a href="mailto:#rc.Vendor.getPrimaryEmail()#">#rc.Vendor.getPrimaryEmail()#</a></dd>
			</dl>
			--->
			<dl>
				<dt>Vendor Website</dt>
				<dd><a href="#getExternalSiteLink('#rc.Vendor.getVendorWebsite()#')#">#rc.Vendor.getVendorWebsite()#</a></dd>
			</dl>
			<!---
			<dl>
				<dt>Address</dt>
				<dd>
					#rc.Vendor.getStreetAddress()#<br />
					<cfif len(rc.Vendor.getStreet2Address())>#rc.Vendor.getStreet2Address()#<br /></cfif>
					#rc.Vendor.getCity()#, #rc.Vendor.getState()# #rc.Vendor.getPostalCode()#<br />
				</dd>
			</dl>
			--->
		</div>
		<div class="ItemDetailBar">
			<dl>
				<dt>Items On Order</dt>
				<dd>##</dd>
			</dl>
		</div>
		<!---
		<cfset local.args = structNew() />
		<cfset args.Vendor = rc.Vendor />
		
		<cfif rc.Vendor.getBrandsQuery().recordcount>
			<cfset args.HiddenColumns = "DateLastReceived" />
			#view('product/list', args)#
			#view('brand/list', args)#
		</cfif>
		--->
	</div>
	<div class="TCRightThird">
		<!--- #view('directory/cards', args)# --->
	</div>
	<cfdump var="#rc.Vendor.getEmailAddresses()#" />
</div>
</cfoutput>
