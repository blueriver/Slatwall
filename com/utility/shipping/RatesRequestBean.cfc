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

component accessors="true" output="false" extends="Slatwall.com.utility.RequestBean" {

	property name="shipToName" type="string";
	property name="shipToCompany" type="string";
	property name="shipToStreetAddress" type="string";
	property name="shipToStreet2Address" type="string";
	property name="shipToLocality" type="string";
	property name="shipToCity" type="string";
	property name="shipToState" type="string";
	property name="shipToPostalCode" type="string";
	
	property name="shipFromName" type="string";
	property name="shipFromCompany" type="string";
	property name="shipFromStreetAddress" type="string";
	property name="shipFromStreet2Address" type="string";
	property name="shipFromLocality" type="string";
	property name="shipFromCity" type="string";
	property name="shipFromState" type="string";
	property name="shipFromPostalCode" type="string";
	
	property name="shippingItemRequestBeans" type="array";
	
	public any function addShippingItem(struct data={}) {
		return arrayAppend(getShippingItemRequestBeans(), new ShippingItemRequestBean(argument.data));
	}
	
}