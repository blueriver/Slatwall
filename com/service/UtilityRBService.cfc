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
component extends="BaseService" accessors="true" {

	variables.resourceBundles = {};
	variables.instantiaded = now();
	
	public string function getRBKey(required string key, string locale="en_us", string checkedKeys="", string originalKey) {
		// Check the exact bundle file
		var bundle = getResourceBundle( arguments.locale );
		if(structKeyExists(bundle, arguments.key)) {
			return bundle[ arguments.key ];
		}
		
		// Check the broader bundle file
		if(listLen(arguments.locale, "_") == 2) {
			bundle = getResourceBundle( listFirst(arguments.locale, "_") );
			if(structKeyExists(bundle, arguments.key)) {
				return bundle[ arguments.key ];
			}
		}
		
		// Because the value was not found, we can add this to the checkedKeys, and setup the original Kye
		arguments.checkedKeys = listAppend(arguments.checkedKeys, arguments.key & "_" & arguments.locale & "_missing");
		if(!structKeyExists(arguments, "originalKey")) {
			arguments.originalKey = arguments.key;
		}
		
		if(listLen(arguments.key, ".") >= 3 && listGetAt(arguments.key, 2, ".") neq "define") {
			return getRBKey(replace(arguments.key, ".#listGetAt(arguments.key, 2, ".")#.", ".define.", "one"), arguments.locale, arguments.checkedKeys, arguments.originalKey);
		}
		
		if(listLen(arguments.key, ".") >= 2 && listGetAt(arguments.key, 1, ".") neq "define") {
			return getRBKey("define.#listLast(arguments.key)#", arguments.locale, arguments.checkedKeys, arguments.originalKey);
		}
		
		if(listFirst(arguments.locale, "_") neq "en") {
			return getRBKey(arguments.originalKey, "en", arguments.checkedKeys);
		}
		
		return arguments.checkedKeys;
	}
	
	public struct function getResourceBundle(required string locale="en_us") {
		if(!structKeyExists(variables.resourceBundles, arguments.locale)) {
			var javaRB = new Slatwall.org.javaRB.javaRB();
			
			variables.resourceBundles[ arguments.locale ] = {};
			
			try {
				variables.resourceBundles[ arguments.locale ] = javaRB.getResourceBundle(expandPath("/Slatwall/config/resourceBundles/#arguments.locale#.properties"));
			} catch (any e) {
				// No RB File Found
			}
			
			try {
				structAppend(variables.resourceBundles[ arguments.locale ], javaRB.getResourceBundle(expandPath("/Slatwall/config/custom/resourceBundles/#arguments.locale#.properties")), true);
			} catch (any e) {
				// No RB File Found
			}
		}
		
		return variables.resourceBundles[ arguments.locale ];
	}
	
	
}