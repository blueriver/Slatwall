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
<cfparam name="rc.brand" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<ul id="navTask">
		<cfif not rc.edit>
	    	<cf_SlatwallActionCaller action="admin:brand.edit" querystring="brandID=#rc.brand.getbrandID()#" type="list">
	    </cfif>
	    <cf_SlatwallActionCaller action="admin:brand.list" type="list">
	</ul>

	<div class="svoadminbranddetail">
		<cfif rc.edit>
			
			#$.slatwall.getValidateThis().getValidationScript(theObject=rc.brand, formName="brandDetail")#
			
			<form name="brandDetail" id="brandDetail" method="post">
				<input type="hidden" name="slatAction" value="admin:brand.save" />
				<input type="hidden" name="BrandID" value="#rc.Brand.getBrandID()#" />
		</cfif>
		
				<dl class="oneColumn">
					<cf_SlatwallPropertyDisplay object="#rc.Brand#" property="brandName" edit="#rc.edit#" class="first">
					<cf_SlatwallPropertyDisplay object="#rc.Brand#" property="brandWebsite" edit="#rc.edit#">
				</dl>
		
		<cfif rc.edit>
				<div id="actionButtons" class="clearfix">
					<cf_SlatwallActionCaller action="admin:brand.list" class="button" text="#rc.$.Slatwall.rbKey('sitemanager.cancel')#">
					<cfif !rc.brand.isNew() and !rc.brand.hasProduct()>
					<cf_SlatwallActionCaller action="admin:brand.delete" querystring="brandid=#rc.brand.getBrandID()#" class="button" type="link" confirmrequired="true">
					</cfif>
					<cf_SlatwallActionCaller action="admin:brand.save" type="submit" class="button">
				</div>
			</form>
		</cfif>
	</div>
</cfoutput>
