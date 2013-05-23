<!---

    Slatwall - An Open Source eCommerce Platform
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
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	
	<cfparam name="attributes.settingName" type="string" />
	<cfparam name="attributes.settingObject" type="any" default="" />
	<cfparam name="attributes.settingFilterEntities" type="array" default="#arrayNew(1)#" />
	<cfparam name="attributes.settingDetails" type="any" default="" />
	<cfparam name="attributes.settingDisplayName" type="string" default="" />
	<cfparam name="attributes.settingHint" type="string" default="" >
	<cfparam name="attributes.settingFilterEntitiesName" type="string" default="" >
	<cfparam name="attributes.settingFilterEntitiesURL" type="string" default="" >
	
	<cfif isObject(attributes.settingObject)>
		<cfset attributes.settingDetails = attributes.settingObject.getSettingDetails(settingName=attributes.settingName, filterEntities=attributes.settingFilterEntities) />
	<cfelse>
		<cfset attributes.settingDetails = attributes.hibachiScope.getService("settingService").getSettingDetails(settingName=attributes.settingName, filterEntities=attributes.settingFilterEntities) />
	</cfif>
	
	<cfset attributes.settingDisplayName = attributes.hibachiScope.rbKey("setting.#attributes.settingName#") />
	<cfset attributes.settingHint = attributes.hibachiScope.rbKey("setting.#attributes.settingName#_hint") />
	<cfif right(attributes.settingHint, 8) eq "_missing">
		<cfset attributes.settingHint = "" />
	</cfif>
	
	<cfloop array="#attributes.settingFilterEntities#" index="fe">
		<cfset attributes.settingFilterEntitiesName = listAppend(attributes.settingFilterEntitiesName, "#attributes.hibachiScope.rbKey('entity.#fe.getClassName()#')#: #fe.getSimpleRepresentation()#") />
		<cfset attributes.settingFilterEntitiesURL = listAppend(attributes.settingFilterEntitiesURL, "#fe.getPrimaryIDPropertyName()#=#fe.getPrimaryIDValue()#", "&") />
	</cfloop>
	
	<cfassociate basetag="cf_SlatwallSettingTable" datacollection="settings">
</cfif>