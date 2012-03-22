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
<cfparam name="rc.product" type="any" />
<cfset local.valueOptions = [{value="",name=rc.$.Slatwall.rbKey('setting.inherit')},{value="1",name=rc.$.Slatwall.rbKey('define.yes')},{value="0",name=rc.$.Slatwall.rbKey('define.no')}] />

<cf_SlatwallPropertyList>
	<cf_SlatwallPropertyDisplay object="#rc.product#" property="urlTitle" edit="#rc.edit#">
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="manufactureDiscontinuedFlag" edit="#rc.edit#">
	<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.product.getInheritedSetting('allowBackorderFlag'))# )" />
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="allowBackorderFlag" edit="#rc.edit#" fieldType="select" valueOptions="#local.valueOptions#">
	<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.product.getInheritedSetting('allowDropShipFlag'))# )" />
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="allowDropShipFlag" edit="#rc.edit#" fieldType="select" valueOptions="#local.valueOptions#">
	<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.product.getInheritedSetting('allowShippingFlag'))# )" />
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="allowShippingFlag" edit="#rc.edit#" fieldType="select" valueOptions="#local.valueOptions#">
	<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.product.getInheritedSetting('allowPreorderFlag'))# )" />
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="allowPreorderFlag" edit="#rc.edit#" fieldType="select" valueOptions="#local.valueOptions#">
	<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# ( #yesNoFormat(rc.product.getInheritedSetting('callToOrderFlag'))# )" />
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="callToOrderFlag" edit="#rc.edit#" fieldType="select" valueOptions="#local.valueOptions#">
	<cf_SlatwallPropertyDisplay object="#rc.product#" property="productDisplayTemplate" edit="true" fieldType="select" valueOptions="#rc.product.getProductDisplayTemplateOptions()#">
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="quantityHeldBack" edit="#rc.edit#" fieldType="text" value="#rc.Product.getSetting("quantityHeldBack")#">
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="quantityMinimum" edit="#rc.edit#" fieldType="text" value="#rc.Product.getSetting("quantityMinimum")#">
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="quantityMaximum" edit="#rc.edit#" fieldType="text" value="#rc.Product.getSetting("quantityMaximum")#">
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="quantityOrderMinimum" edit="#rc.edit#" fieldType="text" value="#rc.Product.getSetting("quantityOrderMinimum")#">
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="quantityOrderMaximum" edit="#rc.edit#" fieldType="text"value="#rc.Product.getSetting("quantityOrderMaximum")#">
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="shippingWeight" edit="#rc.edit#" fieldType="text"value="#rc.Product.getSetting("shippingWeight")#">
	<cf_SlatwallPropertyDisplay object="#rc.product#" property="shippingWeightUnitCode" edit="true" fieldType="select" valueOptions="#rc.product.getShippingWeightUnitCodeOptions()#">
	<cfset local.valueOptions[1].name = "#rc.$.Slatwall.rbKey('setting.inherit')# (#yesNoFormat(rc.product.getInheritedSetting('trackInventoryFlag'))#)" />
	<cf_SlatwallPropertyDisplay object="#rc.Product#" property="trackInventoryFlag" edit="#rc.edit#" fieldType="select" valueOptions="#local.valueOptions#">
</cf_SlatwallPropertyList>
