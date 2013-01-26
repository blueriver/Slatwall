<cfcomponent output="false" accessors="true" extends="HibachiService">
	
	<cfproperty name="hibachiTagService" type="any" />
	
	<cfscript>
		// @hint this method allows you to properly format a value against a formatType
		public any function formatValue( required string value, required string formatType, struct formatDetails={} ) {
			if(arguments.formatType eq "none") {
				return arguments.value;
			}
			return this.invokeMethod("formatValue_#arguments.formatType#", {value=arguments.value, formatDetails=arguments.formatDetails});
		}
		
		private any function formatValue_yesno( required string value, struct formatDetails={} ) {
			if(isBoolean(arguments.value) && arguments.value) {
				return rbKey('define.yes');
			} else {
				return rbKey('define.no');
			}
		}
		
		private any function formatValue_truefalse( required string value, struct formatDetails={} ) {
			if(isBoolean(arguments.value) && arguments.value) {
				return rbKey('define.true');
			} else {
				return rbKey('define.false');
			}
		}
		
		private any function formatValue_currency( required string value, struct formatDetails={} ) {
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
		
		private any function formatValue_datetime( required string value, struct formatDetails={} ) {
			return dateFormat(arguments.value, getService("settingService").getSettingValue("globalDateFormat")) & " " & TimeFormat(value, getService("settingService").getSettingValue("globalTimeFormat"));
		}
		
		private any function formatValue_date( required string value, struct formatDetails={} ) {
			return dateFormat(arguments.value, getService("settingService").getSettingValue("globalDateFormat"));
		}
		
		private any function formatValue_time( required string value, struct formatDetails={} ) {
			return timeFormat(arguments.value, getService("settingService").getSettingValue("globalTimeFormat"));
		}
		
		private any function formatValue_weight( required string value, struct formatDetails={} ) {
			return arguments.value & " " & getService("settingService").getSettingValue("globalWeightUnitCode");
		}
		
		private any function formatValue_pixels( required string value, struct formatDetails={} ) {
			return arguments.value & "px";
		}
		
		private any function formatValue_percentage( required string value, struct formatDetails={} ) {
			return arguments.value & "%";
		}
		
		private any function formatValue_url( required string value, struct formatDetails={} ) {
			return '<a href="#arguments.value#" target="_blank">' & arguments.value & '</a>';
		}
		
		public string function replaceStringTemplate(required string template, required any object, boolean formatValues=false) {
			var templateKeys = reMatchNoCase("\${[^}]+}",arguments.template);
			var replacementArray = [];
			var returnString = arguments.template;
			
			for(var i=1; i<=arrayLen(templateKeys); i++) {
				var replaceDetails = {};
				replaceDetails.key = templateKeys[i];
				try {
					replaceDetails.value = arguments.object.getValueByPropertyIdentifier(replace(replace(templateKeys[i], "${", ""),"}",""), arguments.formatValues);	
				} catch(any e) {
					writeDump(templateKeys[i]);
					writeDump(e);
					abort;
				}
				
				arrayAppend(replacementArray, replaceDetails);
			}
			
			for(var i=1; i<=arrayLen(replacementArray); i++) {
				returnString = replace(returnString, replacementArray[i].key, replacementArray[i].value, "all");
			}
			
			return returnString;
		}
		
		/**
			* Concatenates two arrays.
			*
			* @param a1      The first array.
			* @param a2      The second array.
			* @return Returns an array.
			* @author Craig Fisher (craig@altainetractive.com)
			* @version 1, September 13, 2001
			* Modified by Tony Garcia 18Oct09 to deal with metadata arrays, which don't act like normal arrays
			*/
		public array function arrayConcat(required array a1, required array a2) {
			var newArr = [];
		    var i=1;
		    if ((!isArray(a1)) || (!isArray(a2))) {
		        writeoutput("Error in <Code>ArrayConcat()</code>! Correct usage: ArrayConcat(<I>Array1</I>, <I>Array2</I>) -- Concatenates Array2 to the end of Array1");
		        return arrayNew(1);
		    }
		    /*we have to copy the array elements to a new array because the properties array in ColdFusion 
		      is a "read only" array (see http://www.bennadel.com/blog/760-Converting-A-Java-Array-To-A-ColdFusion-Array.htm)*/
		    for (i=1;i <= ArrayLen(a1);i++) {
		        newArr[i] = a1[i];
		    }
		    for (i=1;i <= ArrayLen(a2);i++) {
		        newArr[arrayLen(a1)+i] = a2[i];
		    }
		    return newArr;
		}
		
		public string function filterFilename(required string filename) {
			// Lower Case The Filename
			arguments.filename = lcase(trim(arguments.filename));
			
			// Remove anything that isn't alphanumeric
			arguments.filename = reReplace(arguments.filename, "[^a-z|0-9| ]", "", "all");
			
			// Remove any spaces that are multiples to a single spaces
			arguments.filename = reReplace(arguments.filename, "[ ]{1,} ", " ", "all");
			
			// Replace any spaces with a dash
			arguments.filename = replace(arguments.filename, " ", "-", "all");
			
			return arguments.filename;
		}
	
		public void function duplicateDirectory(required string source, required string destination, boolean overwrite=false, boolean recurse=true, string copyContentExclusionList='', boolean deleteDestinationContent=false, string deleteDestinationContentExclusionList="" ){
			arguments.source = replace(arguments.source,"\","/","all");
			arguments.destination = replace(arguments.destination,"\","/","all");
			
			// set baseSourceDir so it's persisted through recursion
			if(isNull(arguments.baseSourceDir)){
				arguments.baseSourceDir = arguments.source;
			}
			
			// set baseDestinationDir so it's persisted through recursion, baseDestinationDir is passed in recursion so, this will run only once
			if(isNull(arguments.baseDestinationDir)){
				arguments.baseDestinationDir = arguments.destination;
				// Loop through destination and delete the files and folder if needed
				if(arguments.deleteDestinationContent){
					var destinationDirList = directoryList(arguments.destination,false,"query");
					for(var i = 1; i <= destinationDirList.recordCount; i++){
						if(destinationDirList.type[i] == "Dir"){
							// get the current directory without the base path
							var currentDir = replacenocase(replacenocase(destinationDirList.directory[i],'\','/','all'),arguments.baseDestinationDir,'') & "/" & destinationDirList.name[i];
							// if the directory exists and not part of exclusion the delete
							if(directoryExists("#arguments.destination##currentDir#") && findNoCase(currentDir,arguments.deleteDestinationContentExclusionList) EQ 0){
								try {
									directoryDelete("#arguments.destination##currentDir#",true);	
								} catch(any e) {
									writeLog(file="Slatwall", text="Could not delete the directory: #arguments.destination##currentDir# most likely because it is in use by the file system");
								}
							}
						} else if(destinationDirList.type[i] == "File") {
							// get the current file path without the base path
							var currentFile = replacenocase(replacenocase(destinationDirList.directory[i],'\','/','all'),arguments.baseDestinationDir,'') & "/" & destinationDirList.name[i];
							// if the file exists and not part of exclusion the delete
							if(fileExists("#arguments.destination##currentFile#") && findNoCase(currentFile,arguments.deleteDestinationContentExclusionList) EQ 0){
								try {
									fileDelete("#arguments.destination##currentFile#");	
								} catch(any e) {
									writeLog(file="Slatwall", text="Could not delete file: #arguments.destination##currentFile# most likely because it is in use by the file system");
								}
							}
						}
					}
				}
			}
			
			var dirList = directoryList(arguments.source,false,"query");
			for(var i = 1; i <= dirList.recordCount; i++){
				if(dirList.type[i] == "File" && !listFindNoCase(arguments.copyContentExclusionList,dirList.name[i])){
					var copyFrom = "#replace(dirList.directory[i],'\','/','all')#/#dirList.name[i]#";
					var copyTo = "#arguments.destination##replacenocase(replacenocase(dirList.directory[i],'\','/','all'),arguments.baseSourceDir,'')#/#dirList.name[i]#";
					copyFile(copyFrom,copyTo,arguments.overwrite);
				} else if(dirList.type[i] == "Dir" && arguments.recurse && !listFindNoCase(arguments.copyContentExclusionList,dirList.name[i])){
					duplicateDirectory(source="#dirList.directory[i]#/#dirList.name[i]#", destination=arguments.destination, overwrite=arguments.overwrite, recurse=arguments.recurse, copyContentExclusionList=arguments.copyContentExclusionList, deleteDestinationContent=arguments.deleteDestinationContent, deleteDestinationContentExclusionList=arguments.deleteDestinationContentExclusionList, baseSourceDir=arguments.baseSourceDir, baseDestinationDir=arguments.baseDestinationDir);
				}
			}
			
			// set the file permission in linux
			if(!findNoCase(server.os.name,"Windows")){
				fileSetAccessMode(arguments.destination, "775");
			}
		}
		
		private void function copyFile(required string source, required string destination, boolean overwrite=false){
			var destinationDir = getdirectoryFromPath(arguments.destination);
			//create directory
			if(!directoryExists(destinationDir)){
				directoryCreate(destinationDir);
			}
			//copy file if it doens't exist in destination
			if(arguments.overwrite || !fileExists(arguments.destination)) {
				fileCopy(arguments.source,arguments.destination);
			}
		}
		
		// helper method for downloading a file
		public void function downloadFile(required string fileName, required string filePath, string contentType = 'application/unknown', boolean deleteFile = false) {
			getHibachiTagService().cfheader(name="Content-Disposition", value="inline; filename=#arguments.fileName#"); 
			getHibachiTagService().cfcontent(type="#arguments.contentType#", file="#arguments.filePath#", deletefile="#arguments.deleteFile#");
		}
		
		public string function encryptValue(required string value) {
			return encrypt(arguments.value, getEncryptionKey(), setting("globalEncryptionAlgorithm"), setting("globalEncryptionEncoding"));
		}
	
		public string function decryptValue(required string value) {
			try {
				return decrypt(arguments.value, getEncryptionKey(), setting("globalEncryptionAlgorithm"), setting("globalEncryptionEncoding"));	
			} catch (any e) {
				logHibachi("There was an error decrypting a value from the database.  This is usually because Slatwall cannot find the Encryption key used to encrypt the data.  Verify that you have a key file in the location specified in the advanced settings of the admin.", true);
				return "";
			}
		}
		
		public string function createEncryptionKey() {
			var	theKey = generateSecretKey(setting("globalEncryptionAlgorithm"), setting("globalEncryptionKeySize"));
			storeEncryptionKey(theKey);
			return theKey;
		}
		
		public string function getEncryptionKey() {
			if(!encryptionKeyExists()){
				createEncryptionKey();
			}
			var encryptionFileData = fileRead(getEncryptionKeyFilePath());
			var encryptionInfoXML = xmlParse(encryptionFileData);
			return encryptionInfoXML.crypt.key.xmlText;
		}
		
		private string function getEncryptionKeyFilePath() {
			return getEncryptionKeyLocation() & getEncryptionKeyFileName();
		}
		
		private string function getEncryptionKeyLocation() {
			return setting("globalEncryptionKeyLocation") NEQ "" ? setting("globalEncryptionKeyLocation") : expandPath('/Slatwall/config/custom/');
		}
		
		private string function getEncryptionKeyFileName() {
			return "key.xml.cfm";
		}
		
		private boolean function encryptionKeyExists() {
			return fileExists(getEncryptionKeyFilePath());
		}
		
		private void function storeEncryptionKey(required string key) {
			var theKey = "<crypt><key>#arguments.key#</key></crypt>";
			fileWrite(getEncryptionKeyFilePath(),theKey);
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