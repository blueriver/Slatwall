/*

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

*/
component accessors="true" extends="Slatwall.org.Hibachi.HibachiRBService" {

	property name="integrationService" type="any";

	// Override the getResourceBundle method so that we can look in other places as well
	public struct function getResourceBundle(required string locale="en_us") {
		if(!structKeyExists(variables.resourceBundles, arguments.locale)) {
			
			// Call the super, and at this point the structKeyExists, so there is a potential chance that one request might not get all the RB keys in a race condition type of setting.
			var thisRB = super.getResourceBundle(argumentcollection=arguments);
			var javaRB = new Slatwall.org.Hibachi.JavaRB.JavaRB();
			
			// Loop over the integrations to look for a resource bundle there
			var dirList = directoryList( expandPath("/Slatwall/integrationServices") );
			
			// Loop over each integration in the integration directory
			for(var i=1; i<= arrayLen(dirList); i++) {
				try {
					structAppend(thisRB, javaRB.getResourceBundle(expandPath("/#getApplicationValue('applicationKey')#/integrationServices/#listLast(dirList[i],'/\')#/config/resourceBundles/#arguments.locale#.properties")), true);
				} catch (any e) {
					// No RB File Found
				}
			}
				
			variables.resourceBundles[ arguments.locale ] = thisRB;
		}
		return variables.resourceBundles[ arguments.locale ];
	}
}