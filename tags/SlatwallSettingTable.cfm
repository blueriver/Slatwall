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
<cfif thisTag.executionMode is "end">
	<cfparam name="attributes.object" type="any" />
	<cfparam name="attributes.edit" type="boolean" default="false" />
	<cfparam name="attributes.hasInheritance" type="boolean" default="true" />
	<cfparam name="thistag.settings" type="array" default="#arrayNew(1)#" />
	
	<cfoutput>
		<table class="table table-striped table-bordered">
			<tr>
				<th class="varWidth">#request.context.$.Slatwall.rbKey('entity.setting.settingName')#</th>
				<th>#request.context.$.Slatwall.rbKey('entity.setting.settingValue')#</th>
				<cfif attributes.hasInheritance><th>#request.context.$.Slatwall.rbKey('admin.productType.settingDefinedIn')#</th></cfif>
			</tr>
			<cfloop array="#thistag.settings#" index="thisSetting">
				<tr>
					<td>
						#request.context.$.Slatwall.rbKey("setting.product.#thisSetting.settingName#")#
					</td>
					<td>
						<cf_SlatwallPropertyDisplay object="#request.context.productType#" property="#thisSetting.settingName#" edit="#attributes.edit#" displayType="plain">
					</td>
					<cfif attributes.hasInheritance>
						<cfset local.thisSettingSourequest.contexte = request.context.ProductType.getWhereSettingDefined("#thisSetting.settingName#") />
						<td>
							<cfif local.thisSettingSource.type eq "Global">
								<a href="#buildURL(action='admin:setting.detail')#">#request.context.$.Slatwall.rbKey('entity.setting.global')#</a>
							<cfelseif local.thisSettingSource.type eq "Product Type" and local.thisSettingSource.id neq request.context.ProductType.getProductTypeID()>
								<a href="#buildURL(action='admin:product.detailProductType',queryString='productTypeID=#local.thisSettingSource.id#')#">#local.thisSettingSource.name#</a>
							<cfelse>
								#local.thisSettingSource.name#
							</cfif>
						</td>
					</cfif>
				</tr>
			</cfloop>
		</table>
	</cfoutput>
</cfif>