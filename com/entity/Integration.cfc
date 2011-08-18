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
	property name="dataReadyFlag" ormtype="boolean";
	property name="dataActiveFlag" ormtype="boolean";
	property name="paymentReadyFlag" ormtype="boolean";
	property name="paymentActiveFlag" ormtype="boolean";
	property name="shippingReadyFlag" ormtype="boolean";
	property name="shippingActiveFlag" ormtype="boolean";
	
	public any function init() {
		if(isNull(getDataReadyFlag())) {
			setDataReadyFlag(0);
		}
		if(isNull(getDataActiveFlag())) {
			setDataActiveFlag(0);
		}
		if(isNull(getPaymentReadyFlag())) {
			setPaymentReadyFlag(0);
		}
		if(isNull(getPaymentActiveFlag())) {
			setPaymentActiveFlag(0);
		}
		if(isNull(getShippingReadyFlag())) {
			setShippingReadyFlag(0);
		}
		if(isNull(getShippingActiveFlag())) {
			setShippingActiveFlag(0);
		}
		if(isNull(getInstalledFlag())) {
			setInstalledFlag(0);
		}
		if(isNull(getIntegrationSettings())) {
			setIntegrationSettings(serializeJSON(structNew()));
		}
		
		return super.init();
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
	
}
