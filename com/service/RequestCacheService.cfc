/*

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

*/

component output="false" {

	public void function setValue(required string key, required any value) {
		verifyInitiation();
		logCacheAction(method="setValue", key=arguments.key);
		request.slatwallCache[ arguments.key ] = arguments.value;
	}
	
	public any function getValue(required string key) {
		verifyInitiation();
		logCacheAction(method="getValue", key=arguments.key);
		if(structKeyExists(request.slatwallCache, arguments.key)) {
			return request.slatwallCache[ arguments.key ];
		} else {
			throw("The value that you are requesting is not setup in the request cache");
		}
	}
	
	public boolean function keyExists(required string key) {
		verifyInitiation();
		if( structKeyExists(request.slatwallCache, arguments.key) ) {
			return true;
		} else {
			return false;
		}
	}
	
	public boolean function hasValue(required string key) {
		return keyExists(argumentcollection=arguments);
	}
	
	public void function clearCache(string keys) {
		verifyInitiation();
		logCacheAction(method="clearCache", key=arguments.keys);
		if(structKeyExists(arguments, "keys")) {
			for(var i=1; i<=listLen(arguments.keys); i++) {
				if( structKeyExists(request.slatwallCache, listGetAt(arguments.keys, i)) && listGetAt(arguments.keys, i) != "cacheInitiated" && listGetAt(arguments.keys, i) != "cacheLog") {
					structDelete(request.slatwallCache, listGetAt(arguments.keys, i));
				}
			}
		} else {
			initiate();
		}
	}
	
	private void function verifyInitiation() {
		if( !isInitiated() ) {
			initiate();
		}
	}
	
	private boolean function isInitiated() {
		if( !structKeyExists(request,"slatwallCache") || !structKeyExists(request.slatwallCache, "cacheInitiated") || !request.slatwallCache.cacheInitiated ) {
			return false;
		} else {
			return true;
		}
	}
	
	private void function initiate() {
		request.slatwallCache = {};
		request.slatwallCache.cacheInitiated = true;
		request.slatwallCache.cacheLog = arrayNew(1);
		logCacheAction(method="initiate");
	}
	
	private void function logCacheAction(required string method, string key="") {
		arrayAppend(request.slatwallCache.cacheLog, "#now()# :: #arguments.method# :: #arguments.key#");
	}
	
}