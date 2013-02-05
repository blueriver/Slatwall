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

<cfinterface>
	
	<cffunction name="init" access="public" returntype="any">
		
	</cffunction>
	
	<cffunction name="getDisplayName" access="public" returntype="string">
		<!---
			This method should return a String with the display name
			that you would like for the integration to have
		--->
	</cffunction>
	
	<cffunction name="getIntegrationTypes" access="public" returntype="string">
		<!---
			This method should return a comma seperated list of the integration types
			that it supports.  Here are the possible integration types:
			
			shipping		|		When set this integration will be able to be used by shipping methods / rates
			payment			|		When set this integration will be able to be used by payment methods
			fw1				|		When set then this integration can have custom views, ect.
			custom			|		This is defined when all you want to do is hook into events, but no views or anything else.
		--->
	</cffunction>
	
	<cffunction name="getSettings" access="public" returntype="struct">
		<!---
			This method should return true only if there is a /views/main/default.cfm file
			inside of the integration service
		--->
	</cffunction>
	
	<cffunction name="getEventHandlers" returntype="array">
		<!---
			This method should return a valid coldspring xml that overrides the default xml
		--->
		
	</cffunction> 

</cfinterface>