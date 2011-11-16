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

<cfparam name="attributes.fieldType" type="string" />
<cfparam name="attributes.fieldName" type="string" />
<cfparam name="attributes.fieldClass" type="string" />
<cfparam name="attributes.value" type="any" default="" />
<cfparam name="attributes.valueOptions" type="array" default="#arrayNew(1)#" />

<!---
	attributes.fieldType have the following options:
	
	checkbox			|	As a single checkbox this doesn't require any options, but it will create a hidden field for you so that the key gets submitted even when not checked.  The value of the checkbox will be 1
	checkboxgroup		|	Requires the valueOptions to be an array of structs with the format of {value="", name=""}
	date				|	This is still just a textbox, but it adds the jQuery date picker
	dateTime			|	This is still just a textbox, but it adds the jQuery date & time picker
	file				|	No value can be passed in
	password			|	No Value can be passed in
	radiogroup			|	Requires the valueOptions to be an array of structs with the format of {value="", name=""}
	select      		|	Requires the valueOptions to be an array of structs with the format of {value="", name=""}
	text				|	Simple Text Field
	textarea			|	Simple Textarea
	time				|	This is still just a textbox, but it adds the jQuery time picker
	wysiwyg				|	Value needs to be a string
	yesno				|	This is used by booleans and flags to create a radio group of Yes and No
	
--->

<cfif thisTag.executionMode is "start">
	<cfswitch expression="#attributes.fieldType#">
		<cfcase value="checkbox">
			<cfoutput>
				<input type="hidden" name="#attributes.fieldName#" value="" />
				<input type="checkbox" name="#attributes.fieldName#" value="1" class="#attributes.fieldClass#" <cfif attributes.value> checked="checked"</cfif> />
			</cfoutput>
		</cfcase>
		<cfcase value="checkboxgroup">
			<cfoutput>
				<input type="hidden" name="#attributes.fieldName#" value="" />
				<cfloop array="#attributes.valueOptions#" index="option">
					<input type="checkbox" name="#attributes.fieldName#" value="#structFind(option, 'value')#" class="#attributes.fieldClass#" <cfif listFindNoCase(attributes.value, structFind(option, 'value'))> checked="checked"</cfif> /><span class="#attributes.fieldClass#">#structFind(option, 'value')#</span>	
				</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="date">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# hasDatepicker" />
			</cfoutput>
		</cfcase>
		<cfcase value="dateTime">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# hasDatepicker" />
			</cfoutput>
		</cfcase>
		<cfcase value="file">
			<cfoutput>
				<input type="file" name="#attributes.fieldName#" class="#attributes.fieldClass#" />
			</cfoutput>
		</cfcase>
		<cfcase value="password">
			<cfoutput>
				<input type="password" name="#attributes.fieldName#" class="#attributes.fieldClass#" autocomplete="false" />
			</cfoutput>
		</cfcase>
		<cfcase value="radiogroup">
			<cfoutput>
				<input type="hidden" name="#attributes.fieldName#" value="" />
				<cfloop array="#attributes.valueOptions#" index="option">
					<input type="radio" name="#attributes.fieldName#" value="#structFind(option, 'value')#" class="#attributes.fieldClass#" <cfif attributes.value eq structFind(option, 'value')> checked="checked"</cfif> /><span class="#attributes.fieldClass#">#structFind(option, 'name')#</span>
				</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="select">
			<cfoutput>
				<select name="#attributes.fieldName#" class="#attributes.fieldClass#" />
					<cfloop array="#attributes.valueOptions#" index="option">
						<option value="#structFind(option, 'value')#" <cfif attributes.value eq structFind(option, 'value')> selected="selected"</cfif>>#structFind(option, 'name')#</option>--->	
					</cfloop>
				</select>
			</cfoutput>
		</cfcase>
		<cfcase value="text">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass#" />
			</cfoutput>
		</cfcase>
		<cfcase value="textarea">
			<cfoutput>
				<textarea name="#attributes.fieldName#" class="#attributes.fieldClass#">#attributes.value#</textarea>
			</cfoutput>
		</cfcase>
		<cfcase value="time">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# hasDatepicker" />
			</cfoutput>
		</cfcase>
		<cfcase value="wysiwyg">
			<cfoutput>
				<textarea name="#attributes.fieldName#" class="#attributes.fieldClass# wysiwyg">#attributes.value#</textarea>
			</cfoutput>
		</cfcase>
		<cfcase value="yesno">
			<cfoutput>
				<input type="radio" name="#attributes.fieldName#" value="1" /><span class="#attributes.fieldClass# yes">#yesNoFormat(1)#</span><input type="radio" name="#attributes.fieldName#" value="0" /><span class="#attributes.fieldClass# no">#yesNoFormat(0)#</span>
			</cfoutput>
		</cfcase>
	</cfswitch>
</cfif>