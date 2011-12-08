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
	<cfif arrayLen(rc.optionGroup.getOptions()) GT 0>
		<cfif arrayLen(rc.optionGroup.getOptions()) GT 1>
			<div class="buttons">
				<a class="button" href="##" style="display:none;" id="saveOptionSort">#rc.$.Slatwall.rbKey("admin.option.saveorder")#</a>
				<a class="button" href="##" id="showOptionSort">#rc.$.Slatwall.rbKey('admin.option.reorder')#</a>	
			</div>
		</cfif>
		<table class="listing-grid stripe" id="Options">
			<thead>
				<tr>
					<th class="handle" style="display:none;"></th>
					<th>#rc.$.Slatwall.rbKey("entity.option.optioncode")#</th>
					<th class="varWidth">#rc.$.Slatwall.rbKey("entity.option.optionname")#</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody id="OptionList">
				<cfloop array="#rc.optionGroup.getOptions()#" index="local.thisOption">
					<cfif not local.thisOption.hasErrors()>
						<tr class="Option" id="#local.thisOption.getOptionID()#">
							<td class="handle" style="display:none;"><img src="#$.slatwall.getSlatwallRootPath()#/staticAssets/images/admin.ui.drag_handle.png" height="14" width="15" alt="#rc.$.Slatwall.rbKey('admin.option.reorder')#" /></td>
							<td>#local.thisOption.getOptionCode()#</td>
							<td class="varWidth">#local.thisOption.getOptionName()#</td>
							<td class="administration">
								<ul class="two">
									<cf_SlatwallActionCaller action="admin:option.editOptionGroup" querystring="optiongroupid=#local.thisOption.getOptionGroup().getOptionGroupID()#&optionID=#local.thisOption.getOptionID()#" class="edit" type="list">
									<cf_SlatwallActionCaller action="admin:option.deleteOption" querystring="optionid=#local.thisOption.getOptionID()#" class="delete" type="list" disabled="#local.thisOption.isNotDeletable()#" confirmrequired="true">
								</ul>
							</td>
						</tr>
					</cfif>
				</cfloop>
			</tbody>
		</table>
	<cfelse>
		<p><em>#rc.$.Slatwall.rbKey("admin.option.nooptionsdefined")#</em></p>
		<br /><br />
	</cfif>
	<cfif rc.edit>
		<!--- If the Option is new, then that means that we are just editing the PriceGroup --->
		<cfif rc.option.isNew() && not rc.option.hasErrors()>
			<button type="button" id="addOptionButton" value="true">#rc.$.Slatwall.rbKey("admin.option.detailOptionGroup.addOption")#</button>
		</cfif>
		
		<div id="optionInputs" <cfif rc.option.isNew() && not rc.option.hasErrors()>class="ui-helper-hidden"</cfif> >
			<strong>#rc.$.Slatwall.rbKey("admin.option.detailOptionGroup.addOption")#</strong>
			<dl class="twoColumn">
				<cf_SlatwallPropertyDisplay object="#rc.option#" property="optionName" fieldName="options[1].optionName" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.option#" property="optionCode" fieldName="options[1].optionCode" edit="true" />
				<cf_SlatwallPropertyDisplay object="#rc.option#" property="optionImage" fieldName="options[1].optionImage" edit="true" fieldType="file" />
			</dl>
			<cf_SlatwallPropertyDisplay object="#rc.option#" property="optionDescription" edit="true" fieldType="wysiwyg" />
			<input type="hidden" name="options[1].optionID" value="#rc.option.getOptionId()#"/>
			<cfif rc.option.isNew() && not rc.option.hasErrors()>
				<input type="hidden" name="populateSubProperties" id="addOptionHidden" value="false"/>
			<cfelse>
				<input type="hidden" name="populateSubProperties" id="addOptionHidden" value="true"/>
			</cfif>
		</div>
		
		<br /><br />
	</cfif>
</cfoutput>


