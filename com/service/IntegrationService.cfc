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
component extends="BaseService" persistent="false" accessors="true" output="false" {

	property name="DAO" type="any";
	
	variables.integrationCFCs = {};
	variables.dataIntegrationCFCs = {};
	variables.paymentIntegrationCFCs = {};
	variables.shippingIntegrationCFCs = {};
	
	public array function getActiveFW1Subsystems() {
		if( !structKeyExists(variables, "activeFW1Subsystems") ) {
			variables.activeFW1Subsystems = [];
			var integrations = this.listIntegration();
			for(var i=1; i<=arrayLen(integrations); i++) {
				if(integrations[i].getActiveFlag() && getIntegrationCFC(integrations[i]).isFW1Subsystem()) {
					arrayAppend(variables.activeFW1Subsystems, {subsystem=integrations[i].getIntegrationPackage(), name=integrations[i].getIntegrationName()});
				}
			}
		}
		return variables.activeFW1Subsystems;
	}

	public any function getIntegrationCFC(required any integration) {
		if(!structKeyExists(variables.integrationCFCs, arguments.integration.getIntegrationPackage())) {
			var integrationCFC = createObject("component", "Slatwall.integrationServices.#arguments.integration.getIntegrationPackage()#.Integration").init();
			//populateIntegrationCFCFromIntegration(integrationCFC, arguments.integration);
			variables.integrationCFCs[ arguments.integration.getIntegrationPackage() ] = integrationCFC;
		}
		return variables.integrationCFCs[ arguments.integration.getIntegrationPackage() ];
	}

	public any function getDataIntegrationCFC(required any integration) {
		if(!structKeyExists(variables.dataIntegrationCFCs, arguments.integration.getIntegrationPackage())) {
			var integrationCFC = createObject("component", "Slatwall.integrationServices.#arguments.integration.getIntegrationPackage()#.Data").init();
			populateIntegrationCFCFromIntegration(integrationCFC, arguments.integration);
			variables.dataIntegrationCFCs[ arguments.integration.getIntegrationPackage() ] = integrationCFC;
		}
		return variables.dataIntegrationCFCs[ arguments.integration.getIntegrationPackage() ];
	}
	
	public any function getPaymentIntegrationCFC(required any integration) {
		if(!structKeyExists(variables.paymentIntegrationCFCs, arguments.integration.getIntegrationPackage())) {
			var integrationCFC = createObject("component", "Slatwall.integrationServices.#arguments.integration.getIntegrationPackage()#.Payment").init();
			populateIntegrationCFCFromIntegration(integrationCFC, arguments.integration);
			variables.paymentIntegrationCFCs[ arguments.integration.getIntegrationPackage() ] = integrationCFC;
		}
		return variables.paymentIntegrationCFCs[ arguments.integration.getIntegrationPackage() ];
	}
	
	public any function getShippingIntegrationCFC(required any integration) {
		if(!structKeyExists(variables.shippingIntegrationCFCs, arguments.integration.getIntegrationPackage())) {
			var integrationCFC = createObject("component", "Slatwall.integrationServices.#arguments.integration.getIntegrationPackage()#.Shipping").init();
			populateIntegrationCFCFromIntegration(integrationCFC, arguments.integration);
			variables.shippingIntegrationCFCs[ arguments.integration.getIntegrationPackage() ] = integrationCFC;
		}
		return variables.shippingIntegrationCFCs[ arguments.integration.getIntegrationPackage() ];
	}
	
	public any function updateIntegrationsFromDirectory() {
		
		var dirList = directoryList( expandPath("/plugins/Slatwall/integrationServices") );
		var integrationList = this.listIntegration();
		var installedIntegrationList = "";
		
		// Turn off the installed and ready flags on any previously setup integration entities
		for(var i=1; i<=arrayLen(integrationList); i++) {
			integrationList[i].setInstalledFlag(0);
			integrationList[i].setDataReadyFlag(0);
			integrationList[i].setPaymentReadyFlag(0);
			integrationList[i].setShippingReadyFlag(0);
			integrationList[i].setCustomReadyFlag(0);
		}
		
		// Remove the activeFW1Subsystems setting so that it gets reloaded
		if(structKeyExists(variables, "activeFW1Subsystems")) {
			structDelete(variables, "activeFW1Subsystems");
		}
		
		// Loop over each integration in the integration directory
		for(var i=1; i<= arrayLen(dirList); i++) {
			
			var fileInfo = getFileInfo(dirList[i]);
			
			if(fileInfo.type == "directory" && fileExists("#fileInfo.path#/Integration.cfc") ) {
				
				var integrationPackage = listLast(dirList[i],"\/");
				var integrationCFC = createObject("component", "Slatwall.integrationServices.#integrationPackage#.Integration").init();
				var integrationMeta = getMetaData(integrationCFC);
				
				if(structKeyExists(integrationMeta, "Implements") && structKeyExists(integrationMeta.implements, "Slatwall.integrationServices.IntegrationInterface")) {
					
					var integration = this.getIntegrationByIntegrationPackage(integrationPackage, true);
					integration.setInstalledFlag(1);
					integration.setIntegrationPackage(integrationPackage);
					integration.setIntegrationName(integrationCFC.getDisplayName());
					
					var integrationTypes = integrationCFC.getIntegrationTypes();
					
					// Start: Get Integration Types
					for(var it=1; it<=listLen(integrationTypes); it++) {
						
						var thisType = listGetAt(integrationTypes, it);
						
						switch (thisType) {
							case "custom": {
								integration.setCustomReadyFlag(1);
								break;
							}
							case "data": {
								var dataCFC = createObject("component", "Slatwall.integrationServices.#integrationPackage#.Data").init();
								var dataMeta = getMetaData(dataCFC);
								if(structKeyExists(dataMeta, "Implements") && structKeyExists(dataMeta.implements, "Slatwall.integrationServices.DataInterface")) {
									integration.setDataReadyFlag(1);
								}
								break;
							}
							case "payment": {
								var paymentCFC = createObject("component", "Slatwall.integrationServices.#integrationPackage#.Payment").init();
								var paymentMeta = getMetaData(paymentCFC);
								if(structKeyExists(paymentMeta, "Implements") && structKeyExists(paymentMeta.implements, "Slatwall.integrationServices.PaymentInterface")) {
									integration.setPaymentReadyFlag(1);
								}
								break;
							}
							case "shipping": {
								var shippingCFC = createObject("component", "Slatwall.integrationServices.#integrationPackage#.Shipping").init();
								var shippingMeta = getMetaData(shippingCFC);
								if(structKeyExists(shippingMeta, "Implements") && structKeyExists(shippingMeta.implements, "Slatwall.integrationServices.ShippingInterface")) {
									integration.setShippingReadyFlag(1);
								}
								break;
							}
						}
					}
					
					// Call Entity Save so that any new integrations get persisted
					getDAO().save(integration);
					
				}
			}
		}
	}
	
	public any function injectDataIntegrationToColdspringXML(required any xml) {
		var dirLocation = ExpandPath("/plugins/Slatwall/integrationServices");
		var dirList = directoryList( dirLocation );
		for(var i=1; i<= arrayLen(dirList); i++) {
			var fileInfo = getFileInfo(dirList[i]);
			if(fileInfo.type == "directory" && directoryExists("#fileInfo.path#/dao") ) {
				var serviceName = Replace(listLast(dirList[i],"\/"),".cfc","");
				var service = createObject("component", "Slatwall.integrationServices.#serviceName#.Data").init();
				var serviceMeta = getMetaData(service);
				if(structKeyExists(serviceMeta, "Implements") && structKeyExists(serviceMeta.implements, "Slatwall.integrationServices.DataInterface")) {
					var DAOStruct = service.getDAOClasses(); 
					for(var i=1; i<=arrayLen(arguments.xml.beans.bean); i++) {
						if(structKeyExists(DAOStruct, arguments.xml.beans.bean[i].XmlAttributes.id)) {
							arguments.xml.beans.bean[i].XmlAttributes.class = DAOStruct[arguments.xml.beans.bean[i].XmlAttributes.id];
						}
					}
				}
				
			}
		}
		
		return arguments.xml;
	}
	
	public any function populateIntegrationCFCFromIntegration(required any integrationCFC, required any integration) {
		var integrationSettings = deserializeJSON(arguments.integration.getIntegrationSettings());
		var integrationProperties = getIntegrationCFCSettings(arguments.integrationCFC);
		
		for(var i=1; i<=arrayLen(integrationProperties); i++) {
			if(structKeyExists(integrationSettings, integrationProperties[i].name)) {
				evaluate("arguments.integrationCFC.set#integrationProperties[i].name#( integrationSettings[integrationProperties[i].name] )");
			}
		}
		
		return arguments.integrationCFC;
	}
	
	public any function getIntegrationCFCSettings(required any integrationCFC) {
		var meta = getMetaData(arguments.integrationCFC);
		if(structKeyExists(meta, "properties")) {
			return meta.properties;
		}
		return settings;
	}
	
	public any function saveIntegration(required any integration, struct data) {
		if(structKeyExists(arguments, "data") && structKeyExists(arguments.data, "structuredData")) {
			// Populate the Entity Itself
			arguments.integration.populate(arguments.data);
			
			// Populate Data Integration
			if(arguments.integration.getDataReadyFlag() && structKeyExists(arguments.data.structuredData, "dataIntegration")) {
				var newData = arguments.data.structuredData.dataIntegration;
				var settings = arguments.integration.getIntegrationCFCSettings('data');
				for(var i=1; i<=arrayLen(settings); i++) {
					if(structKeyExists(newData, settings[i].name)) {
						arguments.integration.setIntegrationSetting(settings[i].name, newData[settings[i].name]);
					}
				}
				if(structKeyExists(variables.dataIntegrationCFCs, arguments.integration.getIntegrationPackage())) {
					structDelete(variables.dataIntegrationCFCs, arguments.integration.getIntegrationPackage());
				}
			}
			// Populate Payment Integration
			if(arguments.integration.getPaymentReadyFlag() && structKeyExists(arguments.data.structuredData, "paymentIntegration")) {
				var newData = arguments.data.structuredData.paymentIntegration;
				var settings = arguments.integration.getIntegrationCFCSettings('payment');
				for(var i=1; i<=arrayLen(settings); i++) {
					if(structKeyExists(newData, settings[i].name)) {
						arguments.integration.setIntegrationSetting(settings[i].name, newData[settings[i].name]);
					}
				}
				if(structKeyExists(variables.paymentIntegrationCFCs, arguments.integration.getIntegrationPackage())) {
					structDelete(variables.paymentIntegrationCFCs, arguments.integration.getIntegrationPackage());
				}
			}
			// Populate Shipping Integration
			if(arguments.integration.getShippingReadyFlag() && structKeyExists(arguments.data.structuredData, "shippingIntegration")) {
				var newData = arguments.data.structuredData.shippingIntegration;
				var settings = arguments.integration.getIntegrationCFCSettings('shipping');
				for(var i=1; i<=arrayLen(settings); i++) {
					if(structKeyExists(newData, settings[i].name)) {
						arguments.integration.setIntegrationSetting(settings[i].name, newData[settings[i].name]);
					}
				}
				if(structKeyExists(variables.shippingIntegrationCFCs, arguments.integration.getIntegrationPackage())) {
					structDelete(variables.shippingIntegrationCFCs, arguments.integration.getIntegrationPackage());
				}
			}
			
			// Remove the activeFW1Subsystems setting so that it gets reloaded
			if(structKeyExists(variables, "activeFW1Subsystems")) {
				structDelete(variables, "activeFW1Subsystems");
			}
		}
		
		return getDAO().save(arguments.integration);
	}
	
	
}