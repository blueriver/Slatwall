component output="false" accessors="true" extends="HibachiService" {
	
	// @hint this method allows you to properly format a value against a formatType
	public any function formatValue( required string value, required string formatType ) {
		
		//	Valid formatType Strings are:	none	yesno	truefalse	currency	datetime	date	time	weight
		
		// Do a switch on the seperate formatTypes and return a formatted value
		switch(arguments.formatType) {
			case "none": {
				return arguments.value;
			}
			case "yesno": {
				if(isBoolean(arguments.value) && arguments.value) {
					return rbKey('define.yes');
				} else {
					return rbKey('define.no');
				}
			}
			case "truefalse": {
				if(isBoolean(arguments.value) && arguments.value) {
					return rbKey('define.true');
				} else {
					return rbKey('define.false');
				}
			}
			case "currency": {
				/*
				// Check to see if this object has a currencyCode
				if( this.hasProperty("currencyCode") && !isNull(getCurrencyCode()) && len(getCurrencyCode()) eq 3 ) {
					
					var currency = getService("currencyService").getCurrency( getCurrencyCode() );
					
					return currency.getCurrencySymbol() & LSNumberFormat(arguments.value, ',.__');
				}
				*/
				// Otherwsie use the global currencyLocal
				return LSCurrencyFormat(arguments.value, getService("settingService").getSettingValue("globalCurrencyType"), getService("settingService").getSettingValue("globalCurrencyLocale"));
			}
			case "datetime": {
				return dateFormat(arguments.value, getService("settingService").getSettingValue("globalDateFormat")) & " " & TimeFormat(value, getService("settingService").getSettingValue("globalTimeFormat"));
			}
			case "date": {
				return dateFormat(arguments.value, getService("settingService").getSettingValue("globalDateFormat"));
			}
			case "time": {
				return timeFormat(arguments.value, getService("settingService").getSettingValue("globalTimeFormat"));
			}
			case "weight": {
				return arguments.value & " " & getService("settingService").getSettingValue("globalWeightUnitCode");
			}
			case "pixels": {
				return arguments.value & "px";
			}
			case "percentage" : {
				return arguments.value & "%";
			}
			case "url": {
				return '<a href="#arguments.value#" target="_blank">' & arguments.value & '</a>';
			}
			/*
			case "email": {
				return '<a href="mailto:#arguments.value#" target="_blank">' & arguments.value & '</a>';
			}
			*/
		}
		
		return arguments.value;
	}
	
	
}