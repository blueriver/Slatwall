<cfparam name="params.addressZone" type="any" />
<cfparam name="params.edit" type="boolean" />

<cfoutput>
	<div class="svoadminsettingajaxaddresszonelocation">
		<table id="addressZoneLocations" class="stripe">
			<thead>
				<tr>
					<th>#$.slatwall.rbKey('entity.address.countryCode')#</th>
					<th>#$.slatwall.rbKey('entity.address.streetAddress')#</th>
					<th>#$.slatwall.rbKey('entity.address.street2Address')#</th>
					<th>#$.slatwall.rbKey('entity.address.city')#</th>
					<th>#$.slatwall.rbKey('entity.address.stateCode')#</th>
					<th>#$.slatwall.rbKey('entity.address.postalCode')#</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#params.addressZone.getAddressZoneLocations()#" index="local.address" >
					<tr>
						<td>#local.address.getCountry().getCountryName()#</td>
						<td>#local.address.getStreetAddress()#</td>
						<td>#local.address.getStreet2Address()#</td>
						<td>#local.address.getCity()#</td>
						<td>#local.address.getStateCode()#</td>
						<td>#local.address.getPostalCode()#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		<cfif params.edit>
			<strong>Add Location To Zone</strong>
			<cf_SlatwallAddressDisplay address="#entityNew('SlatwallAddress')#" edit="true" showName="false" showCompany="false" />
			<a id="addAddressZoneLocation" class="button">Add Location</a>

			<script type="text/javascript">
				jQuery(document).ready(function(){
					$("##addAddressZoneLocation").click(function(){
						var addressData = {
							countryCode : jQuery('select[name="countryCode"]').val(),
							name : jQuery('input[name="name"]').val(),
							company : jQuery('input[name="company"]').val(),
							streetAddress : jQuery('input[name="streetAddress"]').val(),
							street2Address : jQuery('input[name="street2Address"]').val(),
							city : jQuery('input[name="city"]').val(),
							postalCode : jQuery('input[name="postalCode"]').val()
						};
						
						if(jQuery('select[name="stateCode"]').size()) {
							addressData["stateCode"] = jQuery('select[name="stateCode"]').val()
						} else {
							addressData["stateCode"] = jQuery('input[name="stateCode"]').val()
						}
						
						jQuery.ajax({
							type: 'post',
							url: '/plugins/Slatwall/api/index.cfm/addressZoneLocations/#params.addressZone.getAddressZoneID()#/',
							data: addressData,
							dataType: "json",
							context: document.body,
							success: function(r) {
								jQuery('div.svoadminsettingajaxaddresszonelocation').replaceWith(r);
								stripe('stripe');
							}
						});
					});
				});
					
			</script>
		</cfif>
	</div>
</cfoutput>