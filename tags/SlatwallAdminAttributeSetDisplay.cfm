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
	<cfparam name="attributes.attributeSet" type="any" />
	<cfparam name="attributes.edit" type="boolean" default="false" />
	<cfparam name="attributes.fieldNamePrefix" type="string" default="" />
	<cfparam name="attributes.entity" type="any" default="" />
	
	<cfset thisTag.attributeSmartList = attributes.attributeSet.getAttributesSmartList() />
	<cfset thisTag.attributeSmartList.addFilter('activeFlag', 1) />
	<cfset thisTag.attributeSmartList.addOrder("sortOrder|ASC") />
	
	<cfloop array="#thisTag.attributeSmartList.getRecords()#" index="attribute">
		<cfset thisAttributeValue = "" />
		<cfif isObject(attributes.entity)>
			<cfset thisAttributeValue = attributes.entity.getAttributeValue(attribute.getAttributeID()) />
		<cfelseif !isNull(attribute.getDefaultValue())>
			<cfset thisAttributeValue = attribute.getDefaultValue() />  
		</cfif>
		
		<cfset thisValueOptions = [] />
		<cfloop array="#attribute.getAttributeOptions()#" index="option">
			<cfset arrayAppend(thisValueOptions, {name=option.getAttributeOptionLabel(), value=option.getAttributeOptionValue()}) />
		</cfloop>
		
		<cfset thisTag.fieldClass = "" />
		<cfif attribute.getRequiredFlag()>
			<cfset thisTag.fieldClass = listAppend(thisTag.fieldClass, "required", " ") />
		</cfif>
		
		<cf_HibachiFieldDisplay title="#attribute.getAttributeName()#" hint="#attribute.getAttributeHint()#" edit="#attributes.edit#" fieldname="#attributes.fieldNamePrefix##attribute.getAttributeCode()#" fieldType="#right(attribute.getAttributeType().getSystemCode(), len(attribute.getAttributeType().getSystemCode())-2)#" fieldClass="#thisTag.fieldClass#" value="#thisAttributeValue#" valueOptions="#thisValueOptions#" />
	</cfloop>
</cfif>