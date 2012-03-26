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
<cfparam name="attributes.smartList" type="any" />
<cfparam name="attributes.recordEditAction" type="string" default="" />
<cfparam name="attributes.recordEditQueryString" type="string" default="" />
<cfparam name="attributes.recordEditModal" type="boolean" default="false" />
<cfparam name="attributes.recordDetailAction" type="string" default="" />
<cfparam name="attributes.recordDetailQueryString" type="string" default="" />
<cfparam name="attributes.recordDeleteAction" type="string" default="" />
<cfparam name="attributes.recordDeleteQueryString" type="string" default="" />
<cfparam name="attributes.parentPropertyName" type="string" default="" />
<cfparam name="attributes.childPropertyName" type="string" default="" />
<cfparam name="attributes.expandAction" type="string" default="#request.context.slatAction#" />
<cfparam name="attributes.selectFieldName" type="string" default="" />
<cfparam name="attributes.removeFieldName" type="string" default="" />

<cfparam name="attributes.administativeCount" type="numeric" default=0 />
<cfparam name="attributes.expandable" type="boolean" default=false />
<cfparam name="attributes.allpropertyidentifiers" type="string" default="" />

<cfif thisTag.executionMode eq "end">
	<cfsilent>
		<!--- Setup Top Level of Hierarchy if needed --->
		<cfif len(attributes.parentPropertyName)>
			<cfset attributes.expandable = true />
			<!---
			<cfset attributes.smartList.joinRelatedProperty( attributes.smartList.getBaseEntityName() , attributes.parentPropertyName, "LEFT") />
			<cfset attributes.smartList.addFilter("#attributes.parentPropertyName#", "NULL") />
			--->
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
		<cfif len(attributes.selectFieldName) or len(attributes.removeFieldName)>
			<cfset attributes.administativeCount++ />
		</cfif>
		
		<!--- Setup the list of all property identifiers --->
		<cfloop array="#thistag.columns#" index="column">
			<cfset attributes.allpropertyidentifiers = listAppend(attributes.allpropertyidentifiers, column.propertyIdentifier) />
		</cfloop>
	</cfsilent>
	<cfoutput>
		<cfif arrayLen(attributes.smartList.getPageRecords())>
			<cfif len(attributes.selectFieldName)>
				<table class="table table-striped table-bordered multiselector-optiontable" data-selectfield="#attributes.selectFieldName#">
			<cfelseif len(attributes.removeFieldName)>
				<table class="table table-striped table-bordered multiselector-selectedtable" data-removefield="#attributes.removeFieldName#">
			<cfelse>
				<table class="table table-striped table-bordered">
			</cfif>
				<thead>
					<tr>
						<cfloop array="#thistag.columns#" index="column">
							<th>
								<div class="dropdown">
									<a href="##" class="dropdown-toggle" data-toggle="dropdown">#attributes.smartList.getPageRecords()[1].getTitleByPropertyIdentifier(column.propertyIdentifier)# <span class="caret"></span> </a>
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
				<tbody>
					<cfloop array="#attributes.smartList.getPageRecords()#" index="record">
						<tr id="#record.getPrimaryIDValue()#">
							<cfset firstColumn = true>
							<cfset firstColumnIcon = "" />
							<cfloop array="#thistag.columns#" index="column">
								<cfsilent>
									<cfif firstColumn>
										<cfif attributes.expandable>
											<cfset firstColumnIcon='<a href="##" class="table-expand depth0" data-depth="0" data-expandaction="#attributes.expandAction#" data-idproperty="#record.getPrimaryIDPropertyName()#" data-parentidproperty="#attributes.parentPropertyName#.#record.getPrimaryIDPropertyName()#" data-parentid="#record.getPrimaryIDValue()#" data-propertyIdentifiers="#record.getPrimaryIDPropertyName()#,#attributes.allpropertyidentifiers#"><i class="icon-plus"></i></a> ' />
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
									<cfif attributes.selectFieldName neq "">
										<button class="btn btn-primary multiselector-select" data-fieldname="#attributes.selectFieldName#" data-fieldvalue="#record.getPrimaryIDValue()#">Select</button>
									</cfif>
									<cfif attributes.removeFieldName neq "">
										<button class="btn btn-primary multiselector-remove" data-fieldname="#attributes.removeFieldName#" data-fieldvalue="#record.getPrimaryIDValue()#">Remove</button>
									</cfif>
								</td>
							</cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
			<cf_SlatwallSmartListPager smartList="#attributes.smartList#" />
		<cfelse>
			<em>#replace(request.context.$.Slatwall.rbKey("entity.define.norecords"), "${entityNamePlural}", request.context.$.Slatwall.rbKey("entity.#replace(attributes.smartList.getBaseEntityName(), 'Slatwall', '', 'all')#_plural"))#</em>
		</cfif>
	</cfoutput>
</cfif>
