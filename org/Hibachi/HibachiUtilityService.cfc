<cfcomponent output="false" accessors="true" extends="HibachiService">
	<cfscript>
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
			}
			
			return arguments.value;
		}
	</cfscript>
	<cffunction name="logException" returntype="void" access="public">
		<cfargument name="exception" required="true" />
		
		<!--- All logic in this method is inside of a cftry so that it doesnt cause an exception ---> 
		<cftry>
			<cflog file="Slatwall" text="START EXCEPTION" />
			<cfif structKeyExists(arguments.exception, "detail") and isSimpleValue(arguments.exception.detail)>
				<cflog file="Slatwall" text="#arguments.exception.detail#" />
			</cfif>
			<cfif structKeyExists(arguments.exception, "errNumber") and isSimpleValue(arguments.exception.errNumber)>
				<cflog file="Slatwall" text="#arguments.exception.errNumber#" />
			</cfif>
			<cfif structKeyExists(arguments.exception, "message") and isSimpleValue(arguments.exception.message)>
				<cflog file="Slatwall" text="#arguments.exception.message#" />
			</cfif>
			<cfif structKeyExists(arguments.exception, "stackTrace") and isSimpleValue(arguments.exception.stackTrace)>
				<cflog file="Slatwall" text="#arguments.exception.stackTrace#" />
			</cfif>
			<cflog file="Slatwall" text="END EXCEPTION" />
			<cfcatch>
				<cflog file="Slatwall" text="Log Exception Error" />
			</cfcatch>
		</cftry>   
	</cffunction>
	
	<cffunction name="logMessage" returntype="void" access="public">
		<cfargument name="message" default="" />
		<cfargument name="messageType" default="" />
		<cfargument name="messageCode" default="" />
		<cfargument name="templatePath" default="" />
		<cfargument name="logType" default="Information" /><!--- Information  |  Error  |  Fatal  |  Warning  --->
		<cfargument name="generalLog" type="boolean" default="false" />
		
		<cfif getHibachiScope().setting("globalLogMessages") neq "none" and (getHibachiScope().setting("globalLogMessages") eq "detail" or arguments.generalLog)>
			<cfif generalLog>
				<cfset var logText = "General Log" />
			<cfelse>
				<cfset var logText = "Detail Log" />
			</cfif>
			
			<cfif arguments.messageType neq "" and isSimpleValue(arguments.messageType)>
				<cfset logText &= " - #arguments.messageType#" />
			</cfif>
			<cfif arguments.messageCode neq "" and isSimpleValue(arguments.messageCode)>
				<cfset logText &= " - #arguments.messageCode#" />
			</cfif>
			<cfif arguments.templatePath neq "" and isSimpleValue(arguments.templatePath)>
				<cfset logText &= " - #arguments.templatePath#" />
			</cfif>
			<cfif arguments.message neq "" and isSimpleValue(arguments.message)>
				<cfset logText &= " - #arguments.message#" />
			</cfif>
			
			<!--- Verify that the log type was correct --->
			<cfif not ListFind("Information,Error,Fatal,Warning", arguments.logType)>
				<cfset logMessage(messageType="Internal Error", messageCode = "500", message="The Log type that was attempted was not valid", logType="Warning") />
				<cfset arguments.logType = "Information" />
			</cfif>
			
			<cflog file="Slatwall" text="#logText#" type="#arguments.logType#" />
		</cfif>
		
	</cffunction>
</cfcomponent>