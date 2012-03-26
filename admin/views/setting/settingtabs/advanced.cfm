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
<cfsilent>
	<cfset local.yesNoValueOptions = [{name=$.slatwall.rbKey('define.yes'), value=1},{name=$.slatwall.rbKey('define.no'), value=0}] />
</cfsilent>

<cfoutput>
	<table class="table table-striped table-bordered">
		<tr>
			<th class="primary">#rc.$.Slatwall.rbKey('setting')#</th>
			<th>#rc.$.Slatwall.rbKey('setting.value')#</th>	
		</tr>
		<tr class="spdadvanced_logmessages">
			<td class="title primary">#rc.$.slatwall.rbKey('setting.advanced.logmessages')#</td>
			<cfif rc.edit>
				<td class="value">
					<select name="advanced_logmessages">
						<option value="None" <cfif rc.allSettings.advanced_logmessages.getSettingValue() eq "none">selected="selected"</cfif>>#$.slatwall.rbKey("define.none")#</option>
						<option value="General" <cfif rc.allSettings.advanced_logmessages.getSettingValue() eq "general">selected="selected"</cfif>>#$.slatwall.rbKey("define.general")#</option>
						<option value="Detail" <cfif rc.allSettings.advanced_logmessages.getSettingValue() eq "detail">selected="selected"</cfif>>#$.slatwall.rbKey("define.detail")#</option>
					</select>
				</td>
			<cfelse>
				<td class="value">#rc.allSettings.advanced_logMessages.getSettingValue()#</td>
			</cfif>
		</tr>
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.advanced_showRemoteIDFields#" title="#rc.$.Slatwall.rbKey('setting.advanced.showRemoteIDFields')#" fieldName="advanced_showRemoteIDFields" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.advanced_editRemoteIDFields#" title="#rc.$.Slatwall.rbKey('setting.advanced.editRemoteIDFields')#" fieldName="advanced_editRemoteIDFields" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.advanced_encryptionKeySize#" title="#rc.$.Slatwall.rbKey('setting.advanced.encryptionKeySize')#" fieldName="advanced_encryptionKeySize">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.advanced_encryptionKeyLocation#" title="#rc.$.Slatwall.rbKey('setting.advanced.encryptionKeyLocation')#" fieldName="advanced_encryptionKeyLocation">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.advanced_useProductCacheFlag#" title="#rc.$.Slatwall.rbKey('setting.advanced.useProductCacheFlag')#" fieldName="advanced_useProductCacheFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
		<cf_SlatwallPropertyDisplay property="settingValue" edit="#rc.edit#" displaytype="table" titleClass="varWidth" object="#rc.allSettings.advanced_useSkuCacheFlag#" title="#rc.$.Slatwall.rbKey('setting.advanced.useSkuCacheFlag')#" fieldName="advanced_useSkuCacheFlag" fieldType="radiogroup" valueOptions="#local.yesNoValueOptions#" valueFormatType="yesno">
	</table>
</cfoutput>