component accessors="true" output="false" displayname="Full Circle" extends="Slatwall.integrationServices.BaseIntegration" implements="Slatwall.integrationServices.IntegrationInterface" {
	
	public any function init() {
		return this;
	}
	
	public string function getIntegrationTypes() {
		return "fw1";
	}
	
	public string function getDisplayName() {
		return "Full Circle";
	}
	
	public struct function getSettings() {
		return {
			companyCode = {fieldType="text"},
			fcFTPAddress = {fieldType="text"},
			fcFTPDirecotry = {fieldType="text"},
			fcFTPUsername = {fieldType="text"},
			fcFTPPassword = {fieldType="password"},
			fcFTPPort = {fieldType="text"},
			fcFTPUseSecure = {fieldType="yesno"},
			localTransferDirctory = {fieldType="text"},
			localTransferURLPath = {fieldType="text"},
			localTransferURLUsername = {fieldType="text"},
			localTransferURLPassword = {fieldType="password"}
		};
	}
	
}