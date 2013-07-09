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
<cfcomponent extends="HibachiService" persistent="false" accessors="true" output="false">
	
	<cfproperty name="templateService" />
	
	<!--- ===================== START: Logical Methods =========================== --->
	
	<!--- =====================  END: Logical Methods ============================ --->
	<!--- ===================== START: DAO Passthrough =========================== --->
	
	<!--- =====================  END: DAO Passthrough  =========================== --->
	<!--- ===================== START: Process Methods =========================== --->
		
	<cfscript>
	
	public any function processPrint_addToQueue(required any print, required struct data) {
		// Populate the email with any data that came in
		arguments.print.populate( arguments.data );
		
		if(structKeyExists(arguments.data, "printTemplateID")) {
			var printTemplate = getTemplateService().getPrintTemplate( arguments.data.printTemplateID );
			
			if(!isNull(printTemplate)) {
				var templateObjectIDProperty = getPrimaryIDPropertyNameByEntityName(printTemplate.getPrintTemplateObject());
						
				if(structKeyExists(arguments.data, templateObjectIDProperty)) {
					
					var templateObject = getServiceByEntityName( printTemplate.getPrintTemplateObject() ).invokeMethod("get#printTemplate.getPrintTemplateObject()#", {1=arguments.data[ templateObjectIDProperty ]});
					
					if(!isNull(templateObject)) {
						
						// Setup the print content
						if(!isNull(printTemplate.getPrintContent())) {
							arguments.print.setPrintContent( templateObject.stringReplace( printTemplate.getPrintContent() ) );	
						}
						
						var templateFileResponse = "";
						var templatePath = getTemplateService().getTemplateFileIncludePath(templateType="print", objectName=printTemplate.getPrintTemplateObject(), fileName=printTemplate.getPrintTemplateFile());
						
						local.print = arguments.print;
						local.printData = {};
						local[ printTemplate.getPrintTemplateObject() ] = templateObject;
						
						if(len(templatePath)) {
							savecontent variable="templateFileResponse" {
								include '#templatePath#';
							}
						}
						
						if(len(templateFileResponse) && !structKeyExists(local.printData, "printContent")) {
							local.printData.printContent = templateFileResponse;
						}
						
						arguments.print.populate( local.printData );
						
						// Append the email to the email queue
						arrayAppend(getHibachiScope().getPrintQueue(), arguments.print);
					}
				}
			}
		}
		
		return arguments.print;
	}
		
	</cfscript>
	
	<!--- =====================  END: Process Methods ============================ --->
	<!--- ====================== START: Save Overrides =========================== --->
	
	<!--- ======================  END: Save Overrides ============================ --->
	<!--- ==================== START: Smart List Overrides ======================= --->
	
	<!--- ====================  END: Smart List Overrides ======================== --->
	<!--- ====================== START: Get Overrides ============================ --->
	
	<!--- ======================  END: Get Overrides ============================= --->
	
</cfcomponent>