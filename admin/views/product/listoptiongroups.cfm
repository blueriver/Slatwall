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
<cfparam name="rc.optionGroupSmartList" type="any" />

<cfoutput>
	
	<ul id="navTask">
		<cf_SlatwallActionCaller action="admin:option.createoptiongroup" type="list">
	</ul>
	
	<div class="svoadminoptionlistoptiongroups">
		<cfif arrayLen(rc.optionGroupSmartList.getPageRecords()) gt 0>
			<cfif arrayLen(rc.optionGroupSmartList.getPageRecords()) gt 0>	
				<div class="buttons">
					<a class="button" href="##" style="display:none;" id="saveOptionGroupSort">#rc.$.Slatwall.rbKey("admin.option.saveorder")#</a>
					<a class="button" href="##" id="showOptionGroupSort">#rc.$.Slatwall.rbKey('admin.optionGroup.reorder')#</a>	
				</div>
			</cfif>
			
			<table class="listing-grid stripe" id="OptionGroups">
				<thead>
					<tr>
						<th class="handle" style="display:none;"></th>
						<th class="varWidth">#rc.$.Slatwall.rbKey("entity.optiongroup.optiongroupname")#</th>
						<th>#rc.$.Slatwall.rbKey("entity.optiongroup.optionGroupCode")#</th>
						<th>#rc.$.Slatwall.rbKey("entity.optiongroup.options")#</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody id="OptionGroupList">
					<cfloop array="#rc.optionGroupSmartList.getPageRecords()#" index="local.thisOptionGroup">
						<tr class="OptionGroup" id="#local.thisOptionGroup.getOptionGroupID()#">
							<td class="handle" style="display:none;"><img src="#$.slatwall.getSlatwallRootPath()#/staticAssets/images/admin.ui.drag_handle.png" height="14" width="15" alt="#rc.$.Slatwall.rbKey('admin.optionGroup.reorder')#" /></td>
							<td class="varWidth">#local.thisOptionGroup.getOptionGroupName()#</td>
							<td>#local.thisOptionGroup.getOptionGroupCode()#</td>
							<td>#local.thisOptionGroup.getOptionsCount()#</td>
							<td class="administration">
							  <ul class="three">
							  	  <cf_SlatwallActionCaller action="admin:option.editoptiongroup" querystring="optiongroupid=#local.thisOptionGroup.getOptionGroupID()#" class="edit" type="list">
					              <cf_SlatwallActionCaller action="admin:option.detailoptiongroup" querystring="optiongroupid=#local.thisOptionGroup.getOptionGroupID()#" class="detail" type="list">
								  <cf_SlatwallActionCaller action="admin:option.deleteoptiongroup" querystring="optiongroupid=#local.thisOptionGroup.getOptionGroupID()#" class="delete" type="list" disabled="#local.thisOptionGroup.isNotDeletable()#" confirmrequired="true">
							  </ul>		
							</td>
						</tr>
					</cfloop>
			    </tbody>
			</table>
			<cf_SlatwallSmartListPager smartList="#rc.optionGroupSmartList#">
		<cfelse>
			<p><em>#rc.$.Slatwall.rbKey("admin.option.listoptiongroups.noOptionGroups")#</em></p>
		</cfif>
	</div>
</cfoutput>