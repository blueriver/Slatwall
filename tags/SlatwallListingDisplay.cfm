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
<cfif thisTag.executionMode eq "end">
	<!--- Required --->
	<cfparam name="attributes.smartList" type="any" />
	<cfparam name="attributes.edit" type="boolean" default="false" />
	
	<!--- Admin Actions --->
	<cfparam name="attributes.recordEditAction" type="string" default="" />
	<cfparam name="attributes.recordEditQueryString" type="string" default="" />
	<cfparam name="attributes.recordEditModal" type="boolean" default="false" />
	<cfparam name="attributes.recordDetailAction" type="string" default="" />
	<cfparam name="attributes.recordDetailQueryString" type="string" default="" />
	<cfparam name="attributes.recordDeleteAction" type="string" default="" />
	<cfparam name="attributes.recordDeleteQueryString" type="string" default="" />
	
	<!--- Hierarchy Expandable --->
	<cfparam name="attributes.parentPropertyName" type="string" default="" />  <!--- Setting this value will turn on Expanable --->
	<cfparam name="attributes.expandAction" type="string" default="#request.context.slatAction#" />  
	
	<!--- Sorting --->
	<cfparam name="attributes.sortProperty" type="string" default="" />  <!--- Setting this value will turn on Sorting --->
	
	<!--- Single Select --->
	<cfparam name="attributes.selectFieldName" type="string" default="" />			<!--- Setting this value will turn on single Select --->
	<cfparam name="attributes.selectValue" type="string" default="" />
	
	<!--- Multiselect --->
	<cfparam name="attributes.multiselectFieldName" type="string" default="" />		<!--- Setting this value will turn on Multiselect --->
	<cfparam name="attributes.multiselectValues" type="string" default="" />
	
	<!--- Helper / Additional / Custom --->
	<cfparam name="attributes.tableattributes" type="string" default="" />  <!--- Pass in additional html attributes for the table --->
	<cfparam name="attributes.tableclass" type="string" default="" />  <!--- Pass in additional classes for the table --->	
	
	<!--- ThisTag Variables used just inside --->
	<cfparam name="thistag.columns" type="array" default="#arrayNew(1)#" />
	<cfparam name="thistag.allpropertyidentifiers" type="string" default="" />
	<cfparam name="thistag.selectable" type="string" default="false" />
	<cfparam name="thistag.multiselectable" type="string" default="false" />
	<cfparam name="thistag.expandable" type="string" default="false" />
	<cfparam name="thistag.sortable" type="string" default="false" />
	<cfparam name="thistag.exampleEntity" type="string" default="" />

	<cfsilent>
		<cfif isSimpleValue(attributes.smartList)>
			<cfset attributes.smartList = request.context.$.Slatwall.getService("utilityORMService").getServiceByEntityName( attributes.smartList ).invokeMethod("get#attributes.smartList#SmartList") />
		</cfif>
		
		<!--- Setup the example entity --->
		<cfset thistag.exampleEntity = createObject("component", "Slatwall.com.entity.#replace(attributes.smartList.getBaseEntityName(), 'Slatwall', '')#") />
		
		<!--- Setup the default table class --->
		<cfset attributes.tableclass = listPrepend(attributes.tableclass, 'table table-striped table-bordered', ' ') />
		
		<!--- Setup the list of all property identifiers to be used later --->
		<cfloop array="#thistag.columns#" index="column">
			<cfset thistag.allpropertyidentifiers = listAppend(thistag.allpropertyidentifiers, column.propertyIdentifier) />
		</cfloop>
		
		<!--- Setup Select --->
		<cfif len(attributes.selectFieldName)>
			<cfset thistag.selectable = true />
			
			<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-select', ' ') />
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-selectfield="#attributes.selectFieldName#"', " ") />
		</cfif>
		
		<!--- Setup Multiselect --->
		<cfif len(attributes.multiselectFieldName)>
			<cfset thistag.multiselectable = true />
			
			<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-multiselect', ' ') />
			<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-condensed', ' ') />
			
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-multiselectfield="#attributes.multiselectFieldName#"', " ") />
		</cfif>
		
		<!--- Setup Hierarchy Expandable --->
		<cfif len(attributes.parentPropertyName)>
			<cfset thistag.expandable = true />
			
			<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-expandable', ' ') />
			
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-expandaction="#attributes.expandAction#"', " ") />
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-propertyIdentifiers="#thistag.exampleEntity.getPrimaryIDPropertyName()#,#thistag.allpropertyidentifiers#"', " ") />
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-parentidproperty="#attributes.parentPropertyName#.#thistag.exampleEntity.getPrimaryIDPropertyName()#"', " ") />
			<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-idproperty="#thistag.exampleEntity.getPrimaryIDPropertyName()#"', " ") />
		</cfif>
		
		<!--- Setup Sortability --->
		<cfif len(attributes.sortProperty)>
			<cfif not arrayLen(attributes.smartList.getOrders())>
				<cfset thistag.sortable = true />
				
				<cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-sortable', ' ') />
				<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-tablename="#attributes.smartList.getBaseEntityName()#"', " ") />
				<cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-idproperty="#thistag.exampleEntity.getPrimaryIDPropertyName()#"', " ") />
				
				<cfset attributes.smartList.addOrder("#attributes.sortProperty#|ASC") />
			</cfif>
		</cfif>
		
		<!--- Setup the count for the number of admin icons --->
		<cfset attributes.administativeCount = 0 />
		<cfif len(attributes.recordEditAction)>
			<cfset attributes.administativeCount++ />
		</cfif>
		<cfif len(attributes.recordDetailAction)>
			<cfset attributes.administativeCount++ />
		</cfif>
		<cfif len(attributes.recordDeleteAction)>
			<cfset attributes.administativeCount++ />
		</cfif>
		
		<!--- Setup the primary representation column if no columns were passed in --->
		<cfif not arrayLen(thistag.columns)>
			<cfset arrayAppend(thistag.columns, {
				propertyIdentifier = thistag.exampleentity.getSimpleRepresentationPropertyName(),
				title = "",
				tdClass="primary",
				filter = false,
				sort = false
			}) />
		</cfif>
	</cfsilent>
	<cfoutput>
		<cfif arrayLen(attributes.smartList.getPageRecords())>
			<cfif thistag.selectable>
				<input type="hidden" name="#attributes.selectFieldName#" value="#attributes.selectValue#" />
			</cfif>
			<cfif thistag.multiselectable>
				<input type="hidden" name="#attributes.multiselectFieldName#" value="#attributes.multiselectValues#" />
			</cfif>
			<table class="#attributes.tableclass#" #attributes.tableattributes#>
				<thead>
					<tr>
						<!--- Selectable --->
						<cfif thistag.selectable>
							<td>&nbsp;</td>
						</cfif>
						<!--- Multiselectable --->
						<cfif thistag.multiselectable>
							<td>&nbsp;</td>
						</cfif>
						<!--- Sortable --->
						<cfif thistag.sortable>
							<td>&nbsp;</td>
						</cfif>
						<cfloop array="#thistag.columns#" index="column">
							<cfsilent>
								<cfif not len(column.title)>
									<cfset column.title = attributes.smartList.getPageRecords()[1].getTitleByPropertyIdentifier(column.propertyIdentifier) />
								</cfif>
							</cfsilent>
							<th>
								<div class="dropdown">
									<a href="##" class="dropdown-toggle" data-toggle="dropdown">#column.title# <span class="caret"></span> </a>
									<ul class="dropdown-menu nav">
										<li class="nav-header">Sort</li>
										<li><a href="#attributes.smartList.buildURL('orderBy=#column.propertyIdentifier#|ASC')#"><i class="icon-arrow-down"></i> Sort Ascending</a></li>
										<li><a href="#attributes.smartList.buildURL('orderBy=#column.propertyIdentifier#|DESC')#"><i class="icon-arrow-up"></i> Sort Decending</a></li>
										<li class="divider"></li>
										<cfif column.filter>
											<li class="nav-header">Filter</li>
											<cfset filterOptions = attributes.smartList.getFilterOptions(valuePropertyIdentifier=column.propertyIdentifier, namePropertyIdentifier=column.propertyIdentifier) />
											<cfloop array="#filterOptions#" index="filter">
												<li><a href="#attributes.smartList.buildURL( 'F:#column.propertyIdentifier#=#filter["value"]#' )#">#filter['value']#</a></li>
											</cfloop>
										</cfif>
									</ul>
								</div>
							</th>
						</cfloop>
						<cfif attributes.administativeCount>
							<th class="admin#attributes.administativeCount#">&nbsp;</th>
						</cfif>
					</tr>
				</thead>
				<tbody <cfif thistag.sortable>class="sortable"</cfif>>
					<cfloop array="#attributes.smartList.getPageRecords()#" index="record">
						<tr id="#record.getPrimaryIDValue()#">
							<!--- Selectable --->
							<cfif thistag.selectable>
								<td><a href="##" class="table-action-select" data-idvalue="#record.getPrimaryIDValue()#"><cfif record.getPrimaryIDValue() eq attributes.selectValue><i class="slatwall-ui-raido-checked"></i><cfelse><i class="slatwall-ui-raido"></i></cfif></a></td>
							</cfif>
							<!--- Multiselectable --->
							<cfif thistag.multiselectable>
								<td><a href="##" class="table-action-multiselect" data-idvalue="#record.getPrimaryIDValue()#"><cfif listFindNoCase(attributes.multiselectValues, record.getPrimaryIDValue())><i class="slatwall-ui-checkbox-checked"></i><cfelse><i class="slatwall-ui-checkbox"></i></cfif></a></td>
							</cfif>
							<!--- Sortable --->
							<cfif thistag.sortable>
								<td><a href="##" class="table-action-sort" data-idvalue="#record.getPrimaryIDValue()#" data-sortPropertyValue="#record.getValueByPropertyIdentifier( attributes.sortProperty )#"><i class="icon-move"></i></a></td>
							</cfif>
							<cfset firstColumn = true>
							<cfset firstColumnIcon = "" />
							<cfloop array="#thistag.columns#" index="column">
								<cfsilent>
									<!--- Expandable --->
									<cfif firstColumn>
										<cfif thistag.expandable>
											<cfset firstColumnIcon='<a href="##" class="table-action-expand depth0" data-depth="0"  data-parentid="#record.getPrimaryIDValue()#"><i class="icon-plus"></i></a> ' />
										</cfif>
										<cfset firstColumn = false />
									</cfif>
								</cfsilent>
								<td class="#column.tdclass# #replace(column.propertyIdentifier, '.', '-', 'all')#">#firstColumnIcon##record.getValueByPropertyIdentifier( propertyIdentifier=column.propertyIdentifier, formatValue=true )#</td>
							</cfloop>
							<cfif attributes.administativeCount>
								<td class="admin admin#attributes.administativeCount#">
									<cfif attributes.recordEditAction neq "">
										<cf_SlatwallActionCaller action="#attributes.recordEditAction#" queryString="#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#&#attributes.recordEditQueryString#" class="btn btn-mini" icon="pencil" iconOnly="true" modal="#attributes.recordEditModal#" />
									</cfif>
									<cfif attributes.recordDetailAction neq "">
										<cf_SlatwallActionCaller action="#attributes.recordDetailAction#" queryString="#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#&#attributes.recordDetailQueryString#" class="btn btn-mini" icon="eye-open" iconOnly="true" />
									</cfif>
									<cfif attributes.recordDeleteAction neq "">
										<cf_SlatwallActionCaller action="#attributes.recordDeleteAction#" queryString="#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#&#attributes.recordDeleteQueryString#" class="btn btn-mini" icon="trash" iconOnly="true" disabled="#record.isNotDeletable()#" confirm="true" />
									</cfif>
								</td>
							</cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
			<cf_SlatwallSmartListPager smartList="#attributes.smartList#" />
		<cfelse>
			<p><em>#replace(request.context.$.Slatwall.rbKey("entity.define.norecords"), "${entityNamePlural}", request.context.$.Slatwall.rbKey("entity.#replace(attributes.smartList.getBaseEntityName(), 'Slatwall', '', 'all')#_plural"))#</em></p>
		</cfif>
	</cfoutput>
</cfif>
