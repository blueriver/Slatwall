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
component displayname="Integration" entityname="SlatwallIntegration" table="SlatwallIntegration" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="integrationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="integrationPackage" ormtype="string";
	property name="integrationName" ormtype="string";
	property name="integrationSettings" ormtype="string" length="4000";
	
	property name="installedFlag" ormtype="boolean";
	
	property name="customReadyFlag" ormtype="boolean";
	property name="customActiveFlag" ormtype="boolean";
	property name="dataReadyFlag" ormtype="boolean";
	property name="dataActiveFlag" ormtype="boolean";
	property name="paymentReadyFlag" ormtype="boolean";
	property name="paymentActiveFlag" ormtype="boolean";
	property name="shippingReadyFlag" ormtype="boolean";
	property name="shippingActiveFlag" ormtype="boolean";
	
	// Non-Persistent properties
	property name="activeFlag" type="boolean" persistent="false";
	
	public any function init() {
		if(isNull(variables.customReadyFlag)) {
			variables.customReadyFlag = 0;
		}
		if(isNull(variables.customActiveFlag)) {
			variables.customActiveFlag = 0;
		}
		if(isNull(variables.dataReadyFlag)) {
			variables.dataReadyFlag = 0;
		}
		if(isNull(variables.dataActiveFlag)) {
			variables.dataActiveFlag = 0;
		}
		if(isNull(variables.paymentReadyFlag)) {
			variables.paymentReadyFlag = 0;
		}
		if(isNull(variables.paymentActiveFlag)) {
			variables.paymentActiveFlag = 0;
		}
		if(isNull(variables.shippingReadyFlag)) {
			variables.shippingReadyFlag = 0;
		}
		if(isNull(variables.shippingActiveFlag)) {
			variables.shippingActiveFlag = 0;
		}
		if(isNull(variable.installedFlag)) {
			variable.installedFlag = 0;
		}
		if(isNull(variables.integrationSettings)) {
			variables.integrationSettings = serializeJSON(structNew());
		}
		
		return super.init();
	}
	
	public boolean function getActiveFlag() {
		if(getDataActiveFlag() || getPaymentActiveFlag() || getShippingActiveFlag() || getCustomActiveFlag()) {
			return true;
		}
		return false;
	}
	
	public any function getIntegrationSetting(required string settingName) {
		var allSettings = deserializeJSON(getIntegrationSettings());
		if(structKeyExists(allSettings, arguments.settingName)) {
			return allSettings[ arguments.settingName ];
		} else {
			return "";
		}
	}
	
	public any function setIntegrationSetting(required string settingName, required any settingValue) {
		var allSettings = deserializeJSON(getIntegrationSettings());
		allSettings[arguments.settingName] = arguments.settingValue;
		setIntegrationSettings(serializeJSON(allSettings));
	}
	
	public any function getIntegrationCFC( string integrationType) {
		switch (arguments.integrationType) {
			case "data" : {
				return getService("integrationService").getDataIntegrationCFC(this);
				break;
			}
			case "payment" : {
				return getService("integrationService").getPaymentIntegrationCFC(this);
				break;
			}
			case "shipping" : {
				return getService("integrationService").getShippingIntegrationCFC(this);
				break;
			}
			default : {
				getService("integrationService").getIntegrationCFC(this);
			}
		}
	}
	
	public any function getIntegrationCFCSettings(required string integrationType) {
		return getService("integrationService").getIntegrationCFCSettings(getIntegrationCFC(arguments.integrationType));
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
