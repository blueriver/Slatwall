<cfcomponent output="false" name="dspAccount" hint="">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>

	<cffunction name="getAccountLoginForm" access="public" returntype="string">
		<cfargument name="CustomClass" default="Account_Signin" />
		<cfargument name="onSuccess" default="" />
		<cfargument name="onError" default="" />
		<cfargument name="SigninText" default="Account Sign-In" />
		<cfargument name="GuestCheckoutOn" default=0 />
		<cfargument name="NoLabels" default=0 />
		<cfargument name="SmallButtons" default=0 />
		
		<cfset var returnHTML = "" />
		
		<cfif isDefined("url.returnURL")>
			<cfset arguments.onSuccess = url.returnURL />
		</cfif>
		
		<cfsavecontent variable="returnHTML">
			<cfoutput>
				<div class="sdoAccountLoginForm #arguments.CustomClass#">
					<form action="" name="LoginUser" method="post">
						<input type="hidden" name="slatProcess" value="LoginUser" />
						<cfif arguments.onSuccess neq ""><input type="hidden" name="onSuccess" value="#arguments.onSuccess#" /></cfif>
						<cfif arguments.onError neq ""><input type="hidden" name="onError" value="#arguments.onError#" /></cfif>
						<h2>#Arguments.SigninText#</h2>
						<div class="Sign-In">
							<h3>Registed Users Sign-In:</h3>
							#application.slat.messageManager.dspMessage(FormName='LoginUser')#
							<cfif NoLabels>
								<input type="text" autocomplete="off" name="LoginUsername" onfocus="$(this).removeClass('BackgroundEmail');" required="email" message="You Must Enter A Valid E-Mail Address" class="BackgroundEmail"  />
								<input type="password" autocomplete="off" name="LoginPassword" onfocus="$(this).removeClass('BackgroundPassword');" required="true" message="Please Enter Your Password" class="BackgroundPassword"  />
							<cfelse>
								<label>E-Mail Address:</label>
								<input type="text" class="textbox" name="LoginUsername" required="true" message="You Must Enter A Valid E-Mail Address" />
								<label>Password:</label>
								<input type="password" class="textbox" required="true" message="Please Enter Your Password" name="LoginPassword"  />
							</cfif>
							<button class="slatButton <cfif SmallButtons>btnLoginSmall<cfelse>btnLogin</cfif>" type="submit">Login</button>
						</div>
					</form>
					<div class="New-Account">
						<cfif arguments.GuestCheckoutOn>
							<form action="" method="post">
								<cfif arguments.onSuccess neq ""><input type="hidden" name="onSuccess" value="#arguments.onSuccess#" /></cfif>
								<cfif arguments.onError neq ""><input type="hidden" name="onError" value="#arguments.onError#" /></cfif>
								<h3>No Account? Use Guest Checkout</h3>
								<p class="CreateLater">Proceed to checkout, and you will have a chance to create an Nytro ID at the end.</p>
								<input type="hidden" name="slatProcess" value="GuestCheckout" />
								<button class="slatButton <cfif SmallButtons>btnGuestCheckoutSmall<cfelse>btnGuestCheckout</cfif>" type="submit">Guest Checkout</button>
							</form>
						<cfelse>
							<h3>Not Registered Yet?</h3>
							<p class="CreateAccount">Register now to use all our convenient site features and check out quickly.</p>
							<button class="slatButton <cfif SmallButtons>btnCreateAccountSmall<cfelse>btnCreateAccount</cfif>" onClick="window.location='/index.cfm/create-account/'">Create Account</button>
						</cfif>
					</div>
				</div>
			</cfoutput>
		</cfsavecontent> 
		
		<cfreturn returnHTML />
	</cffunction>
	
	<cffunction name="getAccountCreateForm" access="public" returntype="string">
		<cfargument name="CustomClass" default="Create_Account" />
		<cfargument name="onSuccess" default="" />
		
		<cfset var returnHTML = "" />
		
		<cfsavecontent variable="returnHTML">
			<cfoutput>
				<div class="sdoAccountCreateForm #arguments.CustomClass#">
					<h2>Create Account</h2>
					#application.slat.messageManager.dspMessage(FormName='CreateAccount')#
					<form action="?nocache=1" method="post" onsubmit="return PowerValidate(this);">
						<input type="hidden" name="slatProcess" value="CreateAccount" />
						<input type="hidden" name="OnSuccess" value="#arguments.onSuccess#" />
						<label>First Name</label>
						<input type="text" name="NewUserFirstName" required="true" message="Plase enter your First Name" />
						<label>Last Name</label>
						<input type="text" name="NewUserLastName" required="true" message="Plase enter your Last Name" />
						<label>E-Mail Address</label>
						<input type="text" name="NewUserEmail" required="email" message="Plase enter a Valid E-Mail Address" />
						<label>Confirm E-Mail Address</label>
						<input type="text" name="NewUserConfirmEmail" required="match" matchinput="Email" message="The Second E-mail Address you entered doesn't Match" />
						<label>Password</label>
						<input type="password" name="NewUserPassword" required="true" message="Plase enter a Password" />
						<label>Confim Password</label>
						<input type="password" name="NewUserConfirmPassword" required="match" matchinput="Password" message="The Second Password you entered doesn't Match" />
						<button class="slatButton btnCreateAccount" type="submit">Create Account</button>
					</form>
				</div>
			</cfoutput>
		</cfsavecontent> 
		
		<cfreturn returnHTML />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>