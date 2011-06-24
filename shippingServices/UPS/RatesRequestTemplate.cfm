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
<cfoutput>
	<?xml version="1.0"?>
	<AccessRequest>
		<AccessLicenseNumber>#variables.apiKey#</AccessLicenseNumber>
		<UserId>#variables.username#</UserId>
		<Password>#variables.password#</Password>
	</AccessRequest>
	<?xml version="1.0"?>
	<RatingServiceSelectionRequest xml:lang="en-US">
		<Request>
			<TransactionReference>
				<CustomerContext>CFUPS Package</CustomerContext>
				<XpciVersion>1.0001</XpciVersion>
			</TransactionReference>
			<RequestAction>Rate</RequestAction>
		</Request>
		<Shipment>
			<Shipper>
				<ShipperNumber>#variables.shipperNumber#</ShipperNumber>
				<Address>
					<City>#variables.shipFromCity#</City>
					<StateProvinceCode>#variables.shipFromStateCode#</StateProvinceCode>
					<PostalCode>#variables.shipFromPostalCode#</PostalCode>
					<CountryCode>#variables.shipFromCountryCode#</CountryCode>
				</Address>
			</Shipper>
			<ShipTo>
				<Address>
					<City>#arguments.requestBean.getShipToCity()#</City>
					<StateProvinceCode>#arguments.requestBean.getShipToStateCode()#</StateProvinceCode>
					<PostalCode>#arguments.requestBean.getShipToPostalCode()#</PostalCode>
					<CountryCode>#arguments.requestBean.getShipToCountryCode()#</CountryCode>
				</Address>
			</ShipTo>
			<ShipFrom>
				<Address>
					<City>#variables.shipFromCity#</City>
					<StateProvinceCode>#variables.shipFromStateCode#</StateProvinceCode>
					<PostalCode>#variables.shipFromPostalCode#</PostalCode>
					<CountryCode>#variables.shipFromCountryCode#</CountryCode>
				</Address>
			</ShipFrom>
			<ShipmentWeight>
				<Weight>#totalItemsWeight#</Weight>
			</ShipmentWeight>
			
			<Package>
				<PackagingType>
					<Code>Package</Code>
				</PackagingType>
				<PackageWeight>
					<Weight>#totalItemsWeight#</Weight>
				</PackageWeight>
				<PackageServiceOptions>
					<InsuredValue>
						<MonetaryValue>#totalItemsValue#</MonetaryValue>
					</InsuredValue>
				</PackageServiceOptions>
			</Package>
	
			<ShipmentServiceOptions>
				<OnCallAir>
					<Schedule>
						<PickupDay>01</PickupDay>
						<Method>01</Method>
					</Schedule>
				</OnCallAir>
			</ShipmentServiceOptions>
	
			<HandlingCharge>
				<FlatRate>0</FlatRate>
			</HandlingCharge>
	
			<!--- TODO, rateinfo/negotiated --->
	        <!--- Added By Aaron S. Passing an empty NegotiatedRatesIndicator tells the API to validate the shipper number and return discounted rates. Test server returns a 1% Discount --->
	        <RateInformation>
	        	<NegotiatedRatesIndicator></NegotiatedRatesIndicator>
	        </RateInformation>
		</Shipment>
	</RatingServiceSelectionRequest>
</cfoutput>