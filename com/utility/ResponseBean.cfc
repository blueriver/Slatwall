component accessors="true" displayname="ResponseBean" hint="bean to encapsulate response from service layer" {
	property name="data" type="any";
	property name="message" type="any";
	property name="errorBean" type="any";       
	property name="statusCode" type="numeric";
	
	public any function init() {
		this.setData("");
		this.setMessage("");
		this.setErrorBean(new com.utility.ErrorBean());
		this.setStatusCode(0);
		return this;
	}    

} 