<cfcomponent output="false" name="dspCart" hint="">
	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getCartOrderSummary" access="public" returntype="string" output="false">
		
		<cfset var returnHTML = "" />
		<cfset var TotalDiscounts = 0 />
		
		<cfsavecontent variable="returnHTML">
			<cfoutput>
				<div class="sdoCartOrderSummary">
					<h3 class="title">Order Summary</h3>
					<dl class="CartItemTotal">
						<dt>Item Total:</dt>
						<dd>
							#DollarFormat(Application.Slat.cartManager.getCartItemsTotal())#
						</dd>
					</dl>
					<dl class="CartTaxTotal">
						<dt>Tax:</dt>
						<dd>
							<cfif Session.Slat.Cart.ShippingAddresses[1].City neq "">
								#DollarFormat(Application.Slat.cartManager.getCartTaxTotal())#
							<cfelse>
								TBD						
							</cfif>
						</dd>
					</dl>
					<dl class="CartShippingTotal">
						<dt>Shipping:</dt>
						<dd>
							<cfif Session.Slat.Cart.ShippingMethods[1].Method neq "">
								#DollarFormat(Application.Slat.cartManager.getCartShippingTotal())#
							<cfelse>
								TBD						
							</cfif>
						</dd>
					</dl>
					<cfset TotalDiscounts = Application.Slat.cartManager.getCartDiscountsTotal() />
					<cfif TotalDiscounts gt 0>
						<dl class="CartDiscountsTotal">
							<dt>Discounts:</dt>
							<dd>#DollarFormat(TotalDiscounts)#</dd>
						</dl>
					</cfif>
					<dl class="CartTotal">
						<dt>Total:</dt>
						<dd>#DollarFormat(Application.Slat.cartManager.getCartTotal())#</dd>
					</dl>
				</div>
			</cfoutput>
		</cfsavecontent>
		<cfreturn returnHTML />
	</cffunction>
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>
