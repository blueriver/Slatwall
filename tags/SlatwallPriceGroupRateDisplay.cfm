<!---

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

--->
<cfparam name="attributes.priceGroupRate" type="any" />
<cfparam name="attributes.edit" type="boolean" default="true" />
<cfparam name="attributes.fieldNamePrefix" type="string" default="" />


<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div class="priceGroupRateDisplay">
			<cfif attributes.edit>
				<dl>
					<cf_SlatwallPropertyDisplay object="#attributes.priceGroupRate#" fieldName="#attributes.fieldNamePrefix#globalFlag" property="globalFlag" edit="true"  fieldType="yesno" />
					
					<!--- The dynamic percentageOff,AmountOff,Amount inputs --->
					<select name="priceGroupRateType" id="priceGroupRateType">
						<option value="percentageOff" <cfif attributes.priceGroupRate.getType() EQ "percentageOff"> selected="selected" </cfif>>#request.context.$.slatwall.rbKey('entity.priceGroupRate.priceGroupRateType.percentageOff')#</option>
						<option value="amountOff" <cfif attributes.priceGroupRate.getType() EQ "amountOff"> selected="selected" </cfif>>#request.context.$.slatwall.rbKey('entity.priceGroupRate.priceGroupRateType.amountOff')#</option>						
						<option value="amount" <cfif attributes.priceGroupRate.getType() EQ "amount"> selected="selected" </cfif>>#request.context.$.slatwall.rbKey('entity.priceGroupRate.priceGroupRateType.amount')#</option>
					</select>
		
					<input type="text" id="priceGroupRateValue" name="priceGroupRateValue" value="<cfif !isNull(attributes.priceGroupRate.getValue())>#attributes.priceGroupRate.getValue()#</cfif>" />
					
					<div id="priceGroupRate_globalOffInputs">
						<cf_SlatwallPropertyDisplay object="#attributes.priceGroupRate#" fieldName="#attributes.fieldNamePrefix#ProductIds" property="products" edit="true"  fieldType="multiselect" value=""  />
					</div>
					
					<input type="hidden" name="#attributes.fieldNamePrefix#priceGroupRateId" value="#attributes.priceGroupRate.getPriceGroupRateID()#" />
				</dl>
				
				
			<cfelse>

			</cfif>
		</div>
	</cfoutput>
</cfif>