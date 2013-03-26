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
	
	<cfparam name="attributes.action" type="any" />
	<cfparam name="attributes.entity" type="any" />
	<cfparam name="attributes.processContext" type="string" />
	
	<cfparam name="attributes.type" type="string" default="link">
	<cfparam name="attributes.querystring" type="string" default="" />
	<cfparam name="attributes.text" type="string" default="">
	<cfparam name="attributes.title" type="string" default="">
	<cfparam name="attributes.class" type="string" default="">
	<cfparam name="attributes.icon" type="string" default="">
	<cfparam name="attributes.iconOnly" type="boolean" default="false">
	<cfparam name="attributes.submit" type="boolean" default="false">
	<cfparam name="attributes.confirm" type="boolean" default="false" />
	<cfparam name="attributes.disabled" type="boolean" default="false" />
	<cfparam name="attributes.modal" type="boolean" default="false" />
	
	<cfset local.entityName = "" />
	
	<!--- Add the process context to the query string --->
	<cfset attributes.queryString = listAppend(attributes.queryString, "processContext=#attributes.processContext#", "&") />
	
	<!--- If just an entityName was passed in, then use that as the local.entityName --->
	<cfif isSimpleValue(attributes.entity) && len(attributes.entity)>
		<cfset local.entityName = attributes.entity />	
	
	<!--- If an object was passed in then append its primaryID stuff, and also set the entityName based on the class name --->
	<cfelseif isObject(attributes.entity)>
		<cfset local.entityName = attributes.entity.getClassName() />
		
		<cfset attributes.queryString = listAppend(attributes.queryString, "#attributes.entity.getPrimaryIDPropertyName()#=#attributes.entity.getPrimaryIDValue()#", "&") />
	</cfif>
	
	<!--- If the text wasn't defined, then add it --->
	<cfif !len(attributes.text)>
		<cfset attributes.text = attributes.hibachiScope.rbKey('entity.#local.entityName#.process.#attributes.processContext#') />
	</cfif>
	
	<!--- If either no entity object was passed in, or if the entity object that was passed in is in fact processable, then deligate to the action caller for the actual info --->
	<cfif !isObject(attributes.entity) || (isObject(attributes.entity) && attributes.entity.isProcessable(attributes.processContext))>
		<cf_HibachiActionCaller attributecollection="#attributes#" />	
	</cfif>
</cfif>