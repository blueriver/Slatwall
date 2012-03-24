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

<cfparam name="attributes.object" type="any" />
<cfparam name="attributes.propertyName" type="string" />
<cfparam name="attributes.fieldName" type="string" default="#attributes.propertyName#" />

<cfparam name="attributes.selectedValues" type="string" default="" />
<cfparam name="attributes.optionsSmartList" type="string" default="" />
<cfparam name="attributes.selectedSmartList" type="string" default="" />

<cfif thisTag.executionMode eq "end">
	
	<cfif not isObject(attributes.optionsSmartList)>
		<cfset attributes.optionsSmartList = attributes.object.getPropertyOptionsSmartList( attributes.propertyName ) />
	</cfif>
	<cfif not isObject(attributes.selectedSmartList)>
		<cfset attributes.selectedSmartList = attributes.object.getPropertySmartList( attributes.propertyName ) />
	</cfif>
	<cfset allValues = evaluate( "attributes.object.get#attributes.propertyName#()") />
	<cfloop array="#allValues#" index="thisValue">
		<cfset attributes.selectedValues = listAppend(attributes.selectedValues, thisValue.getPrimaryIDValue()) />
	</cfloop>
	
	<cfif arrayLen(attributes.optionsSmartList.getPageRecords())>
		<cfset nameProperty = attributes.optionsSmartList.getPageRecords()[1].getSimpleRepresentationPropertyName() />

		<cfoutput>
			<div class="multiselector row-fluid">
				<div class="span6">
					<h4>Select</h4>
					<cf_SlatwallListingDisplay smartList="#attributes.optionsSmartList#" selectFieldName="#attributes.fieldName#" selector=true>
						<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="#nameProperty#" />
					</cf_SlatwallListingDisplay>
				</div>
				<div class="span6">
					<h4>Selected</h4>
					<cf_SlatwallListingDisplay smartList="#attributes.selectedSmartList#" removeFieldName="#attributes.fieldName#">
						<cf_SlatwallListingColumn tdclass="primary" propertyIdentifier="#nameProperty#" />
					</cf_SlatwallListingDisplay>
				</div>
				<input type="hidden" name="#attributes.propertyName#" value="#attributes.selectedValues#" />
			</div>
		</cfoutput>
	</cfif>
</cfif>