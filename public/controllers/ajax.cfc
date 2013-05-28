component output="false" accessors="true" {

	property name="fw" type="any";
	
	property name="addressService" type="any";

	public void function init( required any fw ) {
		setFW( arguments.fw );
	}
	
	public void function before() {
		getFW().setView("public:main.blank");
	}

	public void function country( required struct rc ) {
		param name="rc.countryCode" type="string" default="";
		
		var country = getAddressService().getCountry(rc.countryCode);
		
		if(!isNull(country)) {
			rc.ajaxResponse["country"] = serializeJSON(country);	
		}
	}
	
}