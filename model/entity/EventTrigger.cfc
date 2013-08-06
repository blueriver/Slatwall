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
component entityname="SlatwallEventTrigger" table="SlatwallEventTrigger" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="eventTriggerService" hb_permission="this" {
	
	// Persistent Properties
	property name="eventTriggerID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="eventTriggerName" ormtype="string";
	property name="eventTriggerType" ormtype="string" hb_formFieldType="select";
	property name="eventTriggerObject" ormtype="string" hb_formFieldType="select";
	property name="eventName" ormtype="string" hb_formFieldType="select";
	
	// Related Object Properties (many-to-one)
	property name="emailTemplate" cfc="EmailTemplate" fieldtype="many-to-one" fkcolumn="emailTemplateID" hb_optionsNullRBKey="define.select";
	property name="printTemplate" cfc="PrintTemplate" fieldtype="many-to-one" fkcolumn="printTemplateID" hb_optionsNullRBKey="define.select";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="eventNameOptions" persistent="false";
	property name="eventTriggerObjectTypeOptions" persistent="false";
	property name="eventTriggerTypeOptions" persistent="false";
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getEventNameOptions() {
		if(!structKeyExists(variables, "eventNameOptions")) {
			var eno = getService("hibachiEventService").getEventNameOptions();
			variables.eventNameOptions = [{name=getHibachiScope().rbKey('define.select'), value=''}];
			for(var i=1; i<=arrayLen(eno); i++){
				if(isNull(getEventTriggerObject()) || (structKeyExists(eno[i], 'entityName') && eno[i].entityName eq getEventTriggerObject())) {
					arrayAppend(variables.eventNameOptions, eno[i]);	
				}
			}
		}
		return variables.eventNameOptions;
	}
	
	public array function getEventTriggerObjectOptions() {
		if(!structKeyExists(variables, "eventTriggerObjectOptions")) {
			var emd = getService("hibachiService").getEntitiesMetaData();
			var enArr = listToArray(structKeyList(emd));
			arraySort(enArr,"text");
			variables.eventTriggerObjectOptions = [{name=getHibachiScope().rbKey('define.select'), value=''}];
			for(var i=1; i<=arrayLen(enArr); i++) {
				arrayAppend(variables.eventTriggerObjectOptions, {name=rbKey('entity.#enArr[i]#'), value=enArr[i]});
			}
		}
		return variables.eventTriggerObjectOptions;
	}
	
	public array function getEventTriggerTypeOptions() {
		return [
			{name=getHibachiScope().rbKey('define.select'), value=''},
			{name=getHibachiScope().rbKey('define.email'), value='email'},
			{name=getHibachiScope().rbKey('define.print'), value='print'}
		];
	}
	
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}