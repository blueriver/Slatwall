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
This view include displays messages (errors, confirmations, etc) if they are placed in the request collection
Text must be in rc.message -- this can either be a resource bundle key or just text (usually the value of a key)
Message type is in rc.messagetype, which styles the message appropriately. Currently the possible values are "info", "error", or "warning" (defaults to "info")

--->

<cfoutput>
<cfif structKeyExists(rc,"message") && structKeyExists(rc,"messageType") && len(trim(rc.message)) gt 0>
	<cfset local.message = rc.$.Slatwall.rbKey(rc.message) />
	<cfif right(local.message,8) eq "_missing">
		<cfset local.message = rc.message />
	</cfif>
</cfif>
<!--- display messages --->
<cfif structKeyExists(local,"message")>
	<p class="messagebox #rc.messagetype#_message">
		#htmlEditFormat(local.message)#
	</p>
</cfif>

<!---  display any errors --->
<cfif structKeyExists(rc,"errorBean")>
	<cfset local.errors = rc.errorBean.getErrors() />
	<ul class="errors">
	<cfloop collection="#local.errors#" item="local.thisError">
		<li>#local.errors[local.thisError]#</li>
	</cfloop>
	</ul>
</cfif>

</cfoutput>