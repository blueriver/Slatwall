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
component output="false" accessors="true" {

	property name="framework" type="any";
	property name="jsVariables" type="any" default="[]";
	property name="jsAssets" type="any" default="[]";
	property name="cssAssets" type="any" default="[]";

	include "assetConfig.cfm";

	public void function init(required any framework) {
		setFramework(arguments.framework);
		setJSVariables([]);
		setJSAssets([]);
		setCSSAssets([]);
		rewritePathsOfDependencies();
	}
	
	public string function getAllAssets() {
		var allAssets = "";
		
		allAssets &= '#chr(10)#<!-- Asset Wire Automatic Wiring Start -->#chr(10)##chr(10)#';
		
		// Add all Javascript Variables
		if( arrayLen(variables.jsVariables) ) {
			allAssets &= '  <script type="text/javascript">#chr(10)#';
			for(var i=1; i<=arrayLen(variables.jsVariables); i++){
				allAssets &= '    var #structKeyList(variables.jsVariables[i])# = #variables.jsVariables[i][structKeyList(variables.jsVariables[i])]#;#chr(10)#';
			}
			allAssets &= '  </script>#chr(10)#';
			allAssets &= '#chr(10)#';
		}
		
		// Add all Scripts
		for(var i=1; i<=arrayLen(variables.jsAssets); i++){
			allAssets &= '  <script src="#variables.jsAssets[i]#" type="text/javascript"></script>#chr(10)#';
		}
		allAssets &= '#chr(10)#';
		
		
		
		// Add all CSS			
		for(var i=1; i<=arrayLen(variables.cssAssets); i++){
			allAssets &= '  <link rel="stylesheet" href="#variables.cssAssets[i]#" type="text/css" />#chr(10)#';	
		}
		allAssets &= '#chr(10)#<!-- Asset Wire Automatic Wiring End -->#chr(10)#';
		
		return allAssets;
	}
	
	public void function addViewToAssets(required string view) {
		var frameworkConfig = variables.framework.getConfig();
		
		if(frameworkConfig.usingsubsystems) {
			// Subsystem Related
			includeAsset("js/#listGetAt(arguments.view,listLen(arguments.view,'/')-3,'/')#.js");
			includeAsset("css/#listGetAt(arguments.view,listLen(arguments.view,'/')-3,'/')#.css");
			
			// Section Related
			includeAsset("js/#listGetAt(arguments.view,listLen(arguments.view,'/')-3,'/')#-#listGetAt(arguments.view,listLen(arguments.view,'/')-1,'/')#.js");
			includeAsset("css/#listGetAt(arguments.view,listLen(arguments.view,'/')-3,'/')#-#listGetAt(arguments.view,listLen(arguments.view,'/')-1,'/')#.css");
			
			// Item Related
			includeAsset("js/#listGetAt(arguments.view,listLen(arguments.view,'/')-3,'/')#-#listGetAt(arguments.view,listLen(arguments.view,'/')-1,'/')#.#Replace(listLast(arguments.view,'/'),'.cfm','.js')#");
			includeAsset("css/#listGetAt(arguments.view,listLen(arguments.view,'/')-3,'/')#-#listGetAt(arguments.view,listLen(arguments.view,'/')-1,'/')#.#Replace(listLast(arguments.view,'/'),'.cfm','.css')#");
		} else {
			// Section Related
			includeAsset("js/#listGetAt(arguments.view,listLen(arguments.view,'/')-1,'/')#.js");
			includeAsset("css/#listGetAt(arguments.view,listLen(arguments.view,'/')-1,'/')#.css");
			
			// Item Related
			includeAsset("js/#listGetAt(arguments.view,listLen(arguments.view,'/')-1,'/')#.#Replace(listLast(arguments.view,'/'),'.cfm','.js')#");
			includeAsset("css/#listGetAt(arguments.view,listLen(arguments.view,'/')-1,'/')#.#Replace(listLast(arguments.view,'/'),'.cfm','.css')#");
		}
	}
	
	public void function addJSVariable(required string name, required any value){
		if(isStruct(arguments.value) || isArray(arguments.value)) {
			arrayAppend(variables.jsVariables, {"#arguments.name#" = serializeJSON(arguments.value)});
		} else if (isNumeric(arguments.value)) {
			arrayAppend(variables.jsVariables, {"#arguments.name#" = arguments.value});
		} else if (isSimpleValue(arguments.value)) {
			arrayAppend(variables.jsVariables, {"#arguments.name#" = "'#arguments.value#'"});
		}
	}
	
	public void function includeAsset(required string asset){
		
		var assetType = listLast(arguments.asset,".");
		var fullAssetPath = getFullAssetPath(arguments.asset);

		if( fileExists(expandPath(fullAssetPath)) ) {

			includeAssetDependencies(fullAssetPath);
			
			if(assetType eq "js") {
				if(!arrayContains(variables.jsAssets, fullAssetPath)) {
					arrayAppend(variables.jsAssets, fullAssetPath);
				}
			} else if(assetType eq "css") {
				if(!arrayContains(variables.cssAssets, fullAssetPath)) {
					arrayAppend(variables.cssAssets, fullAssetPath);
				}
			}
		}
	}
		
	private void function includeAssetDependencies(required string asset) {
		
		if( structKeyExists(variables.assetDependencies, getFullAssetPath(arguments.asset)) ) {
			
			var dependencies = variables.assetDependencies[ getFullAssetPath(arguments.asset) ];
			
			for(var i=1; i <= arrayLen(dependencies); i++){
				if(getFullAssetPath(arguments.asset) == dependencies[i]) {
					throw("An Asset Cannot Be Dependent on Itself")	
				}
				includeAsset(getFullAssetPath(dependencies[i]));
			}
		}
	}
	
	private string function getFullAssetPath(required string asset) {
		if(left(arguments.asset, 1) neq "/") {
			arguments.asset = "#variables.assetConfig.baseAssetPath##arguments.asset#";
		}
		return arguments.asset;
	}
	
	private void function rewritePathsOfDependencies() {
		for(var i in variables.assetDependencies) {
			var oldKey = i;
			var newKey = getFullAssetPath(i);
			if(oldKey != newKey) {
				variables.assetDependencies[ newKey ] = variables.assetDependencies[ oldKey ];
				structDelete(variables.assetDependencies, oldKey);
			}
		}
	}
}