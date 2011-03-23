component displayname="Session" entityname="SlatwallSession" table="SlatwallSession" persistent=true output=false accessors=true extends="slatwall.com.entity.BaseEntity" {
	
	// Persistant Properties
	property name="sessionID" ormtype="string" lenth="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="createdDateTime" ormtype="date";
	property name="lastUpdatedDateTime"	ormtype="date";
	
	// Related Object Properties
	property name="cart" cfc="Cart" fieldtype="many-to-one" fkcolumn="cartID" cascade="all" inverse="true";
	
	// Non-Related & Non-Persistent entities
	property name="account" type="any" persistent="false";  
	
	public any function getAccount() {
		if(!structKeyExists(variables, "account")) {
			if($.currentUser().isLoggedIn()) {
				variables.account = getService("AccountService").getAccountByMuraUser($.currentUser().getUserBean());
			} else {
				variables.account = getService("AccountService").getNewEntity();	
			}
		}
		return variables.account;
	}
	
	public any function getCart() {
		if(!structKeyExists(variables, "cart")) {
			variables.cart = getService("CartService").getNewEntity();
		}
		return variables.cart;
	}
}