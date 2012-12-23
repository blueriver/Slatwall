<slatwall:form action="?s=1" slatAction="frontend:account.createAccount" context="frontend.account.createAccount">
	
	<!--- Header --->
	<h1>Create Account</h1>
	
	<!--- All Errors --->
	<slatwall:validationDisplay errorStruct="#$.slatwall.context('account').getErrors()#" />
	
	<!--- UL Example using fields & property displays --->
	<ul>
		<slatwall:propertyDisplay object="#$.slatwall.context('account')#" property="firstName" displayType="li" />
		
		<li>
			<label>Last Name</label>
			<slatwall:formfield formFieldName="lastName" formFieldType="text" value="" />
			<slatwall:validationDisplay errorName="lastName" errorStruct="#$.slatwall.context('account').getErrors()#" />
		</li>
	<ul>
	
	<!--- DL Example using fields or propertyDisplays ---> 
	<dl>
		<!--- First Name using Property Display --->
		<slatwall:propertyDisplay object="#$.slatwall.context('account')#" property="firstName" displayType="dl" />
		
		<!--- Last Name explicitly defining --->
		<dt>Last Name</dt>
		<dd>
			<slatwall:formfield formFieldName="lastName" formFieldType="text" value="" />
			<slatwall:validationDisplay errorName="lastName" errorStruct="#$.slatwall.context('account').getErrors()#" />
		</dd>
		<dt>Phone Number</dt>
		<dd>
			<slatwall:formfield formFieldName="phoneNumber" formFieldType="text" value="" />
			<slatwall:validationDisplay errorName="phoneNumber" errorStruct="#$.slatwall.context('account').getErrors()#" />
		</dd>
		<dt>Email Address</dt>
		<dd>
			<slatwall:formfield formFieldName="emailAddress" formFieldType="email" value="" />
			<slatwall:validationDisplay errorName="emailAddress" errorStruct="#$.slatwall.context('account').getErrors()#" />
		</dd>
		<dt>Confirm Email Address</dt>
		<dd>
			<slatwall:formfield formFieldName="confirmEmailAddress" formFieldType="email" value="" />
			<slatwall:validationDisplay errorName="confirmEmailAddress" errorStruct="#$.slatwall.context('account').getErrors()#" />
		</dd>
	</dl>
	
	
		
	</dl>
	
	<slatwall:attributeSetInput attributeSetCode="accountDetails" displayType="dl" />
	
	<button type="submit">submit</button>
	
</slatwall:form>
