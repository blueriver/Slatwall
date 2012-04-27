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

<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.fieldType" type="string" />
	<cfparam name="attributes.fieldName" type="string" />
	<cfparam name="attributes.fieldClass" type="string" default="" />
	<cfparam name="attributes.value" type="any" default="" />
	<cfparam name="attributes.valueOptions" type="array" default="#arrayNew(1)#" />
	<cfparam name="attributes.valueOptionsSmartList" type="any" default="" />
		
	<!---
		attributes.fieldType have the following options:
		
		checkbox			|	As a single checkbox this doesn't require any options, but it will create a hidden field for you so that the key gets submitted even when not checked.  The value of the checkbox will be 1
		checkboxgroup		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		date				|	This is still just a textbox, but it adds the jQuery date picker
		dateTime			|	This is still just a textbox, but it adds the jQuery date & time picker
		file				|	No value can be passed in
		multiselect			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		password			|	No Value can be passed in
		radiogroup			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		select      		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		text				|	Simple Text Field
		textarea			|	Simple Textarea
		time				|	This is still just a textbox, but it adds the jQuery time picker
		wysiwyg				|	Value needs to be a string
		yesno				|	This is used by booleans and flags to create a radio group of Yes and No
		
	--->
	
	<cfparam name="request.context.tabindex" default="0" >
	<cfset request.context.tabindex++ />
	
	<cfswitch expression="#attributes.fieldType#">
		<cfcase value="checkbox">
			<cfoutput>
				<input type="hidden" name="#attributes.fieldName#" value="" />
				<input tabindex="#request.context.tabindex#" type="checkbox" name="#attributes.fieldName#" value="1" class="#attributes.fieldClass#" <cfif attributes.value EQ "1"> checked="checked"</cfif> />
			</cfoutput>
		</cfcase>
		<cfcase value="checkboxgroup">
			<cfoutput>
				<input type="hidden" name="#attributes.fieldName#" value="" />
				<cfloop array="#attributes.valueOptions#" index="option">
					<cfset thisOptionValue = isSimpleValue(option)?option:structFind(option, 'value') />
					<cfset thisOptionName = isSimpleValue(option)?option:structFind(option, 'name') />
					<input tabindex="#request.context.tabindex#" type="checkbox" name="#attributes.fieldName#" value="#thisOptionValue#" class="#attributes.fieldClass#" <cfif listFindNoCase(attributes.value, thisOptionValue)> checked="checked"</cfif> /><span class="#attributes.fieldClass#">#thisOptionName#</span>
					<cfset request.context.tabindex++ />
				</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="date">
			<cfoutput>
				<input tabindex="#request.context.tabindex#" type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# datepicker" />
			</cfoutput>
		</cfcase>
		<cfcase value="dateTime">
			<cfoutput>
				<input tabindex="#request.context.tabindex#" type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# datetimepicker" />
			</cfoutput>
		</cfcase>
		<cfcase value="file">
			<cfoutput>
				<input tabindex="#request.context.tabindex#" type="file" name="#attributes.fieldName#" class="#attributes.fieldClass#" />
			</cfoutput>
		</cfcase>
		<cfcase value="listingMultiselect">
			<cf_SlatwallListingDisplay smartList="#attributes.valueOptionsSmartList#" multiselectFieldName="#attributes.fieldName#" multiselectFieldClass="#attributes.fieldClass#" multiselectvalues="#attributes.value#" edit="true"></cf_SlatwallListingDisplay>
		</cfcase>
		<cfcase value="multiselect">
			<cfoutput>
				<input name="#attributes.fieldName#" type="hidden" value="" />
				<select tabindex="#request.context.tabindex#" name="#attributes.fieldName#" class="#attributes.fieldClass# multiselect" multiple="multiple">
					<cfloop array="#attributes.valueOptions#" index="option">
						<cfset thisOptionValue = isSimpleValue(option)?option:structFind(option, 'value') />
						<cfset thisOptionName = isSimpleValue(option)?option:structFind(option, 'name') />
						<option value="#thisOptionValue#" <cfif listFindNoCase(attributes.value, thisOptionValue)> selected="selected"</cfif>>#thisOptionName#</option>
					</cfloop>
				</select>
			</cfoutput>
		</cfcase>
		<cfcase value="password">
			<cfoutput>
				<input tabindex="#request.context.tabindex#" type="password" name="#attributes.fieldName#" class="#attributes.fieldClass#" autocomplete="off" />
			</cfoutput>
		</cfcase>
		<cfcase value="radiogroup">
			<cfoutput>
				<!--- <input type="hidden" name="#attributes.fieldName#" value="" /> --->
				<cfloop array="#attributes.valueOptions#" index="option">
					<cfset thisOptionValue = isSimpleValue(option)?option:structFind(option, 'value') />
					<cfset thisOptionName = isSimpleValue(option)?option:structFind(option, 'name') />
					<input tabindex="#request.context.tabindex#" type="radio" name="#attributes.fieldName#" value="#thisOptionValue#" class="#attributes.fieldClass#" <cfif attributes.value EQ thisOptionValue> checked="checked"</cfif> /><span class="#attributes.fieldClass#">#thisOptionName#</span>
					<cfset request.context.tabindex++ />
				</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="select">
			<cfoutput>
				<select tabindex="#request.context.tabindex#" name="#attributes.fieldName#" class="#attributes.fieldClass#">
					<cfloop array="#attributes.valueOptions#" index="option">
						<cfset thisOptionValue = isSimpleValue(option) ? option : structFind(option, 'value') />
						<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
						<option value="#thisOptionValue#" <cfif attributes.value EQ thisOptionValue> selected="selected"</cfif>>#thisOptionName#</option>
					</cfloop>
				</select>
			</cfoutput>
		</cfcase>
		<cfcase value="text">
			<cfoutput>
				<input tabindex="#request.context.tabindex#" type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass#" />
			</cfoutput>
		</cfcase>
		<cfcase value="textarea">
			<cfoutput>
				<textarea tabindex="#request.context.tabindex#" name="#attributes.fieldName#" class="#attributes.fieldClass#">#attributes.value#</textarea>
			</cfoutput>
		</cfcase>
		<cfcase value="time">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# timepicker" />
			</cfoutput>
		</cfcase>
		<cfcase value="wysiwyg">
			<cfoutput>
				<textarea tabindex="#request.context.tabindex#" name="#attributes.fieldName#" class="#attributes.fieldClass# wysiwyg">#attributes.value#</textarea>
			</cfoutput>
		</cfcase>
		<cfcase value="yesno">
			<cfoutput>
				<label class="radio inline"><input tabindex="#request.context.tabindex#" type="radio" name="#attributes.fieldName#" class="#attributes.fieldClass# yes" value="1" <cfif isBoolean(attributes.value) && attributes.value>checked="checked"</cfif> />#yesNoFormat(1)#</label>
				<cfset request.context.tabindex++ />
				<label class="radio inline"><input tabindex="#request.context.tabindex#" type="radio" name="#attributes.fieldName#" class="#attributes.fieldClass# yes" value="0" <cfif (isboolean(attributes.value) && not attributes.value) || not isBoolean(attributes.value)>checked="checked"</cfif> />#yesNoFormat(0)#</label>
			</cfoutput>
		</cfcase>
	</cfswitch>
	
</cfif>