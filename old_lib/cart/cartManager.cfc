<cfcomponent output="false" name="cartManager" hint="">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="createNewCartSession" access="public" output="false">
		
		<cfset Session.Slat.Cart = #structNew()# />
		<cfset Session.Slat.Cart.BillingAddresses = arrayNew(1) />
		<cfset Session.Slat.Cart.PaymentMethods = arrayNew(1) />
		<cfset Session.Slat.Cart.ShippingAddresses = arrayNew(1) />
		<cfset Session.Slat.Cart.ShippingMethods = arrayNew(1) />
		<cfset Session.Slat.Cart.Items = arrayNew(1) />
		<cfset Session.Slat.Cart.Coupons = arrayNew(1) />
		<cfset Session.Slat.Cart.GuestCheckout = 0 />
		
		<cfif not ArrayLen(Session.Slat.Cart.BillingAddresses)>
			<cfset BillingAddress = structNew() />
			<cfset BillingAddress.FirstName = "" />
			<cfset BillingAddress.LastName = "" />
			<cfset BillingAddress.PhoneNumber = "" />
			<cfset BillingAddress.Email = "" />
			<cfset BillingAddress.Country = "US" />
			<cfset BillingAddress.StreetAddress = "" />
			<cfset BillingAddress.Street2Address = "" />
			<cfset BillingAddress.City = "" />
			<cfset BillingAddress.State = "" />
			<cfset BillingAddress.Locality = "" />
			<cfset BillingAddress.PostalCode = "" />
			<cfset Session.Slat.Cart.BillingAddresses[1] = BillingAddress />
		</cfif>
		<cfif not ArrayLen(Session.Slat.Cart.ShippingAddresses)>
			<cfset ShippingAddress = structNew() />
			<cfset ShippingAddress.FirstName = "" />
			<cfset ShippingAddress.LastName = "" />
			<cfset ShippingAddress.PhoneNumber = "" />
			<cfset ShippingAddress.Email = "" />
			<cfset ShippingAddress.Country = "US" />
			<cfset ShippingAddress.StreetAddress = "" />
			<cfset ShippingAddress.Street2Address = "" />
			<cfset ShippingAddress.City = "" />
			<cfset ShippingAddress.State = "" />
			<cfset ShippingAddress.Locality = "" />
			<cfset ShippingAddress.PostalCode = "" />
			<cfset Session.Slat.Cart.ShippingAddresses[1] = ShippingAddress />
		</cfif>
		<cfif not ArrayLen(Session.Slat.Cart.ShippingMethods)>
			<cfset CartShippingMethod = structNew() />
			<cfset CartShippingMethod.Carrier = "" />
			<cfset CartShippingMethod.Method = "" />
			<cfset CartShippingMethod.Cost = 0 />
			<cfset CartShippingMethod.DeliveryTime = "" />
			<cfset Session.Slat.Cart.ShippingMethods[1] = CartShippingMethod />
		</cfif>
	</cffunction>

	<cffunction name="addCartItem" access="public" returntype="string" output="false">
		<cfargument name="SkuID" type="string" required="true" />
		<cfargument name="ProductID" type="string" required="true" />
		<cfargument name="Quantity" type="numeric" required="true" />
		<cfargument name="BillingID" type="numeric" required="true" />
		<cfargument name="ShippingID" type="numeric" required="true" />
		<cfargument name="isTaxable" type="numeric" required="true" />
		<cfargument name="ExpectedShipDate" type="string" default="" />
		<cfargument name="Notes" type="string" default="" />
		<cfargument name="ParentSkuID" type="string" default="" />
		<cfargument name="ParentPriceIncrease" type="numeric" default=0 />
		<cfargument name="isPackage" type="numeric" default=0 />
		
		<cfset var Item = structNew() />
		<cfset var AlreadyInCart = 0>
		<cfset var I = 0>
		
		<cfset Item.SkuID = arguments.SkuID />
		<cfset Item.ProductID = arguments.ProductID />
		<cfset Item.Quantity = arguments.Quantity />
		<cfset Item.BillingID = arguments.BillingID />
		<cfset Item.ShippingID = arguments.ShippingID />
		<cfset Item.isTaxable = arguments.isTaxable />
		<cfset Item.ExpectedShipDate = arguments.ExpectedShipDate />
		<cfset Item.Notes = arguments.Notes />
		<cfset Item.ParentSkuID = arguments.ParentID />
		<cfset Item.ParentPriceIncrease = arguments.ParentPriceIncrease />
		<cfset Item.IsPackage = arguments.IsPackage />
		
		<cfloop from="1" to="#arrayLen(session.Slat.cart.items)#" index="i">
			<cfif session.Slat.cart.items[i].SkuID eq Item.SkuID and session.Slat.cart.items[i].ParentSkuID eq Item.ParentSkuID>
				<cfset AlreadyInCart = 1 />
				<cfset session.Slat.cart.items[i].Quantity = session.Slat.cart.items[i].Quantity + Item.Quantity />
				<cfset session.Slat.cart.items[i].ExpectedShipDate = Item.ExpectedShipDate />
			</cfif>
		</cfloop>
		
		<cfif not AlreadyInCart>
			<cfset ArrayAppend(Session.Slat.Cart.Items, Item) />
		</cfif>
	</cffunction>
	
	<cffunction name="updateCartQuantity" access="public" returntype="string" output="false">
		<cfargument name="SkuID" type="string" required="true" />
		<cfargument name="Quantity" type="string" required="true" />
		
		<cfset var I = 0>
		
		<cfloop from="1" to="#arrayLen(session.Slat.cart.items)#" index="i">
			<cfif session.Slat.cart.items[i].SkuID eq arguments.SkuID or session.Slat.cart.items[i].ParentSkuID eq arguments.SkuID>
				<cfset session.Slat.cart.items[I].Quantity = arguments.Quantity />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="removeCartItem" access="public" returntype="string" output="false">
		<cfargument name="SkuID" type="string" required="true" />
		
		<cfset var I = 0>
		<cfset var RI = 0>
		<cfset var deleteIndex = 0>
		<cfset var finishedRemoving = 0>
		<cfset var Payment = structNew() />
		

		<cfloop condition="#finishedRemoving# eq 0">
			<cfset finishedRemoving = 1>
			<cfloop from="1" to="#arrayLen(session.Slat.cart.items)#" index="i">
				<cfif session.Slat.cart.items[i].SkuID eq arguments.SkuID or session.Slat.cart.items[i].ParentSkuID eq arguments.SkuID>
					<cfset finishedRemoving = 0>
					<cfset arrayDeleteAt(session.Slat.cart.items, I) />
					<cfbreak />

				</cfif>
			</cfloop>
		</cfloop>
		
		<!---
		<cfloop from="1" to="#arrayLen(session.Slat.cart.items)#" index="i">
			<cfif session.Slat.cart.items[i].SkuID eq arguments.SkuID or session.Slat.cart.items[i].ParentSkuID eq arguments.SkuID>
				<cfset deleteIndex = i />
			</cfif>
		</cfloop>
		
		<cfset arrayDeleteAt(session.Slat.cart.items, deleteIndex) />
		--->
	</cffunction>
	
	<cffunction name="clearCart" access="public" returntype="string">
		<cfset arrayClear(Session.Slat.Cart.Items) />
	</cffunction>

	<cffunction name="updateCartShippingAddress" access="public" output="false">
		<cfargument name="CartShippingAddressID" required="true" />
		<cfargument name="FirstName" default="" />
		<cfargument name="LastName" default="" />
		<cfargument name="EMail" default="" />
		<cfargument name="PhoneNumber" default="" />
		<cfargument name="Country" default="" />
		<cfargument name="StreetAddress" default="" />
		<cfargument name="Street2Address" default="" />
		<cfargument name="City" default="" />
		<cfargument name="State" default="" />
		<cfargument name="Locality" default="" />
		<cfargument name="PostalCode" default="" />
		
		<cfset Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].FirstName = arguments.FirstName />
		<cfset Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].LastName = arguments.LastName />
		<cfset Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].EMail = arguments.EMail />
		<cfset Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].PhoneNumber = arguments.PhoneNumber />
		<cfset Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].Country = arguments.Country />
		<cfset Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].StreetAddress = arguments.StreetAddress />
		<cfset Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].Street2Address = arguments.Street2Address />
		<cfset Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].City = arguments.City />
		<cfset Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].State = arguments.State />
		<cfset Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].Locality = arguments.Locality />
		<cfset Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID].PostalCode = arguments.PostalCode />
	</cffunction>
	
	<cffunction name="updateCartShippingMethod" access="public">
		<cfargument name="CartShippingAddressID" default="1" />
		<cfargument name="Carrier" default="Custom" />
		<cfargument name="Method" default="" />
		<cfargument name="Cost" default=0 />
		<cfargument name="DeliveryTime" default="" />
		
		<cfset Session.Slat.Cart.ShippingMethods[arguments.CartShippingAddressID].Carrier = arguments.Carrier />
		<cfset Session.Slat.Cart.ShippingMethods[arguments.CartShippingAddressID].Method = arguments.Method />
		<cfset Session.Slat.Cart.ShippingMethods[arguments.CartShippingAddressID].Cost = JavaCast("float", arguments.Cost) />
		<cfset Session.Slat.Cart.ShippingMethods[arguments.CartShippingAddressID].DeliveryTime = arguments.DeliveryTime />
	</cffunction>

	<cffunction name="updateCartBillingAddress" access="public" output="false">
		<cfargument name="CartBillingAddressID" required="true" />
		<cfargument name="FirstName" required="true" />
		<cfargument name="LastName" required="true" />
		<cfargument name="EMail" required="true" />
		<cfargument name="PhoneNumber" required="true" />
		<cfargument name="Country" required="true" />
		<cfargument name="StreetAddress" required="true" />
		<cfargument name="Street2Address" required="true" />
		<cfargument name="City" required="true" />
		<cfargument name="State" required="true" />
		<cfargument name="Locality" required="true" />
		<cfargument name="PostalCode" required="true" />
		
		<cfset Session.Slat.Cart.BillingAddresses[arguments.CartBillingAddressID].FirstName = arguments.FirstName />
		<cfset Session.Slat.Cart.BillingAddresses[arguments.CartBillingAddressID].LastName = arguments.LastName />
		<cfset Session.Slat.Cart.BillingAddresses[arguments.CartBillingAddressID].EMail = arguments.EMail />
		<cfset Session.Slat.Cart.BillingAddresses[arguments.CartBillingAddressID].PhoneNumber = arguments.PhoneNumber />
		<cfset Session.Slat.Cart.BillingAddresses[arguments.CartBillingAddressID].Country = arguments.Country />
		<cfset Session.Slat.Cart.BillingAddresses[arguments.CartBillingAddressID].StreetAddress = arguments.StreetAddress />
		<cfset Session.Slat.Cart.BillingAddresses[arguments.CartBillingAddressID].Street2Address = arguments.Street2Address />
		<cfset Session.Slat.Cart.BillingAddresses[arguments.CartBillingAddressID].City = arguments.City />
		<cfset Session.Slat.Cart.BillingAddresses[arguments.CartBillingAddressID].State = arguments.State />
		<cfset Session.Slat.Cart.BillingAddresses[arguments.CartBillingAddressID].Locality = arguments.Locality />
		<cfset Session.Slat.Cart.BillingAddresses[arguments.CartBillingAddressID].PostalCode = arguments.PostalCode />
	</cffunction>
	
	<cffunction name="addCartPaymentMethod" access="public" returntype="string" output="false">
		<cfargument name="Amount" required="true" />
		<cfargument name="Type" required="true" />						<!--- AMEX, Visa, MasterCard, Discover --->
		<cfargument name="CardHolderName" default="" />
		<cfargument name="CardNumber" default="" />
		<cfargument name="SecurityCode" default="" />
		<cfargument name="ExpirationMonth" default="" />
		<cfargument name="ExpirationYear" default="" />
		<cfargument name="PreAuthorizedAmount" default=0 />
		<cfargument name="PreAuthorizationCode" default="" />
		<cfargument name="ChargedAmount" default=0 />
		<cfargument name="ChargedTransactionCode" default="" />
		<cfargument name="ReferenceNumber" default="" />
		
		<cfset Payment = structNew() />
		
		<cfset Payment.Amount = arguments.Amount />
		<cfset Payment.CardHolderName = arguments.CardHolderName />
		<cfset Payment.CardNumber = arguments.CardNumber />
		<cfset Payment.SecurityCode = arguments.SecurityCode />
		<cfset Payment.ExpirationMonth = arguments.ExpirationMonth />
		<cfset Payment.ExpirationYear = arguments.ExpirationYear />
		<cfset Payment.Type = arguments.Type />
		<cfset Payment.PreAuthorizedAmount = arguments.PreAuthorizedAmount />
		<cfset Payment.PreAuthorizationCode = arguments.PreAuthorizationCode />
		<cfset Payment.ChargedAmount = arguments.ChargedAmount />
		<cfset Payment.ChargedTransactionCode = arguments.ChargedTransactionCode />
		<cfset Payment.ReferenceNumber = arguments.ReferenceNumber />
				
		<cfset ArrayAppend(Session.Slat.Cart.PaymentMethods, Payment) />
		
	</cffunction>
	
	<cffunction name="removeCartPaymentMethod" access="public" output="false">
		<cfargument name="CartPaymentID" required="true" />
		
		<cfset ArrayDeleteAt(Session.Slat.Cart.PaymentMethods, arguments.CartPaymentID) />
	</cffunction>
	
	<cffunction name="updateCartPaymentMethod" access="public" returntype="string" output="false">
		<cfargument name="CartPaymentID" required="true" />
		<cfargument name="Amount" required="true" />
		<cfargument name="CardHolderName" required="true" />
		<cfargument name="CardNumber" required="true" />
		<cfargument name="SecurityCode"	required="true" />
		<cfargument name="ExpirationMonth" required="true" />
		<cfargument name="ExpirationYear" required="true" />
		<cfargument name="Type" required="true" />							<!--- AMEX, Visa, MasterCard, Discover --->
		<cfargument name="PreAuthorizedAmount" required="true" />
		<cfargument name="PreAuthorizationCode" required="true" />
		<cfargument name="ChargedAmount" required="true" />
		<cfargument name="ChargedTransactionCode" required="true" />
		<cfargument name="ReferenceNumber" required="true" />
		
		<cfset Session.Slat.Cart.PaymentMethods[#arguments.CartPaymentID#].Amount = arguments.Amount />
		<cfset Session.Slat.Cart.PaymentMethods[#arguments.CartPaymentID#].CardHolderName = arguments.CardHolderName />
		<cfset Session.Slat.Cart.PaymentMethods[#arguments.CartPaymentID#].CardNumber = arguments.CardNumber />
		<cfset Session.Slat.Cart.PaymentMethods[#arguments.CartPaymentID#].SecurityCode = arguments.SecurityCode />
		<cfset Session.Slat.Cart.PaymentMethods[#arguments.CartPaymentID#].ExpirationMonth = arguments.ExpirationMonth />
		<cfset Session.Slat.Cart.PaymentMethods[#arguments.CartPaymentID#].ExpirationYear = arguments.ExpirationYear />
		<cfset Session.Slat.Cart.PaymentMethods[#arguments.CartPaymentID#].Type = arguments.Type />
		<cfset Session.Slat.Cart.PaymentMethods[#arguments.CartPaymentID#].PreAuthorizedAmount = arguments.PreAuthorizedAmount />
		<cfset Session.Slat.Cart.PaymentMethods[#arguments.CartPaymentID#].PreAuthorizationCode = arguments.PreAuthorizationCode />
		<cfset Session.Slat.Cart.PaymentMethods[#arguments.CartPaymentID#].ChargedAmount = arguments.ChargedAmount />
		<cfset Session.Slat.Cart.PaymentMethods[#arguments.CartPaymentID#].ChargedTransactionCode = arguments.ChargedTransactionCode />
		<cfset Session.Slat.Cart.PaymentMethods[#arguments.CartPaymentID#].ReferenceNumber = arguments.ReferenceNumber />
	</cffunction>
	
	<cffunction name="addCartCoupon" access="public" returntype="string">
		<cfargument name="CouponID" type="string" required="true" />
		<cfargument name="CouponCode" type="string" required="true" />
		
		<cfset var AddCoupon = structNew() />
		
		<cfset AddCoupon.CouponID = arguments.CouponID />
		<cfset AddCoupon.CouponCode = arguments.CouponCode />

		<cfset ArrayAppend(Session.Slat.Cart.Coupons, AddCoupon) />
	</cffunction>
	
	<cffunction name="removeCartCoupon" access="public" returntype="string">
		<cfargument name="CouponID" type="string" />
		
		<cfset var I = 0>
		<cfset var deleteIndex = 0>
		
		<cfloop from="1" to="#arrayLen(session.Slat.cart.coupons)#" index="I">
			<cfif session.Slat.cart.coupons[I].CouponID eq arguments.CouponID>
				<cfset deleteIndex = I />
			</cfif>
		</cfloop>
		
		<cfset ArrayDeleteAt(Session.Slat.Cart.Coupons, deleteIndex) />
	</cffunction>
	
	<cffunction name="convertCartToOrder" access="public" returntype="struct" output="false">
		<cfargument name="CartBillingAddressID" required="true">
		<cfargument name="CartShippingAddressID" required="true">
		<cfargument name="CustomerID" default="">
		<cfargument name="TerminalID" default="">
		<cfargument name="WarehouseID" default="">
		<cfargument name="RemoteOrderID" default="">
		<cfargument name="OrderType" default="">
		
		<cfset var Order = structNew() />
		<cfset var TaxTypeTotalState = structNew() />
		<cfset var TaxTypeTotalLocal = structNew() />
		<cfset var ThisItemID = 0 />
		<cfset var newIndex=0 />
		<cfset var Payment=structnew() />
		<cfset var TaxStruct = structnew() />
		<cfset var Item = structNew() />
		<cfset var Tax = structnew() />
		
		<cfset Order.CustomerID = arguments.CustomerID />
		<cfset Order.GuestCheckout = Session.Slat.Cart.GuestCheckout />
		<cfset Order.TerminalID = arguments.TerminalID />
		<cfset Order.WarehouseID = arguments.WarehouseID />
		<cfset Order.RemoteOrderID = arguments.RemoteOrderID />
		<cfset Order.OrderType = arguments.OrderType />
		<cfset Order.BillingAddress = StructCopy(Session.Slat.Cart.BillingAddresses[arguments.CartBillingAddressID]) />
		<cfset Order.ShippingAddress = StructCopy(Session.Slat.Cart.ShippingAddresses[arguments.CartShippingAddressID]) />
		<cfset Order.ShippingMethod = StructCopy(Session.Slat.Cart.ShippingMethods[arguments.CartShippingAddressID]) />
		
		<cfset Order.TotalTaxByType = arraynew(1) />
		
		<cfset TaxTypeTotalState.Type = "State" />
		<cfset TaxTypeTotalState.Amount = 0 />
		<cfset arrayAppend(Order.TotalTaxByType, TaxTypeTotalState) />
		
		<cfset TaxTypeTotalLocal.Type = "Local" />
		<cfset TaxTypeTotalLocal.Amount = 0 />
		<cfset arrayAppend(Order.TotalTaxByType, TaxTypeTotalLocal) />
		
		<cfset Order.OrderItems = arraynew(1) />
		<cfloop from="1" to="#arraylen(Session.Slat.Cart.Items)#" index="ThisItemID">
			<cfset Item = structNew() />
			<cfset Item = Session.Slat.Cart.Items[ThisItemID] />
			
			<cfset Item.Price = getCartItemPrice(ThisItemID) />
			<cfset Item.PriceDetail = getCartItemPriceDetail(ThisItemID) />
			<cfset Item.PriceExtended = getCartItemPriceExtended(ThisItemID) />
			<cfset Item.Taxes = arraynew(1) />
			<cfset Item.TotalTaxes = 0 />
			<cfset Item.TotalTaxRate = 0 />
			
			<cfloop from="1" to="#arraylen(Order.TotalTaxByType)#" index="newIndex">
				<cfset TaxStruct = getCartItemTax(ThisItemID, Order.TotalTaxByType[newIndex].Type) />
				
				<cfset Tax = structnew() />
				<cfset Tax.TaxType = TaxStruct.Type />
				<cfset Tax.Amount = TaxStruct.Amount />
				<cfset Tax.Rate = TaxStruct.Rate />
				<cfset arrayAppend(Item.Taxes, Tax) />
				
				<cfset Item.TotalTaxes = Item.TotalTaxes + TaxStruct.Amount  />
				<cfset Item.TotalTaxRate = Item.TotalTaxRate + TaxStruct.Rate />
				
				<cfset Order.TotalTaxByType[newIndex].Amount = Order.TotalTaxByType[newIndex].Amount + TaxStruct.Amount  />
			</cfloop>
			<cfset ArrayAppend(Order.OrderItems, Item) />
		</cfloop>


		<cfset Order.TotalPaymentAmount = 0>
		<cfset Order.TotalPaymentPreAuthorizedAmount = 0>
		<cfset Order.TotalPaymentChargedAmount = 0>
		
		<cfset Order.PaymentMethods = arraynew(1) />
		<cfloop from="1" to="#arraylen(Session.Slat.Cart.PaymentMethods)#" index="newIndex">
			<cfset Payment = Session.Slat.Cart.PaymentMethods[newIndex] />
			<cfset ArrayAppend(Order.PaymentMethods, Payment) />
			<cfset Order.TotalPaymentAmount = Order.TotalPaymentAmount + Payment.Amount />
			<cfset Order.TotalPaymentPreAuthorizedAmount = Order.TotalPaymentPreAuthorizedAmount + Payment.PreAuthorizedAmount />
			<cfset Order.TotalPaymentChargedAmount = Order.TotalPaymentChargedAmount + Payment.ChargedAmount />
		</cfloop>
		
		<cfset Order.TotalItems = getCartItemsTotal() />
		<cfset Order.TotalItemDiscounts = getCartItemsDiscountTotal() />
		<cfset Order.TotalShipping = getCartShippingTotal() />
		<cfset Order.TotalShippingDiscounts = getShippingDiscountTotal() />
		<cfset Order.TotalShippingWeight = getCartTotalShipmentWeight(arguments.CartShippingAddressID) />
		<cfset Order.TotalDiscounts = getCartDiscountsTotal() />
		<cfset Order.TotalTax = getCartTaxTotal() />
		<cfset Order.Total = getCartTotal() />
		
		<cfreturn Order>
	</cffunction>
	
	<!--- CALCULATION FUNCTIONS --->
	
	<cffunction name="getCartItemPrice" access="public" returntype="numeric" output="false">
		<cfargument name="CartItemID" required="true" />
		
		<cfset var PriceDetail = getCartItemPriceDetail(arguments.CartItemID) />
		<cfreturn PriceDetail.Price />
	</cffunction>
	
	
	<cffunction name="getCartItemPriceDetail" access="public" returntype="struct" output="false">
		<cfargument name="CartItemID" required="true" />
		
		<cfset var CartItem = structnew() />
		<cfset var Sku = "" />
		<cfset var PriceDetail = structnew() />
		<cfset var ParentPrice = 0 />
		<cfset var StartingPriceDetail = structnew() />
		<cfset var ReturnPriceDetail = structnew() />
		<cfset var PriceOptions = arrayNew(1) />
		<cfset var BestPriceID = 1 />
		<cfset var PriceOptionID = 1 />
		<Cfset var CartCouponID = 0 />
		
		<cfset CartItem = session.Slat.cart.items[arguments.CartItemID] />
		<cfset Sku = application.Slat.skuManager.read(Skuid=CartItem.SkuID) />
		
		<cfif CartItem.isPackage and CartItem.ParentSkuID eq "">
			<!--- Look For Package Increases --->
			<cfset PriceDetail = structnew() />
			<cfset PriceDetail.OriginalPrice = Sku.getOriginalPrice() />
			<cfset PriceDetail.LivePrice = Sku.getLivePrice() />
			<cfloop array="#session.Slat.cart.items#" index="I">
				<cfset ParentPrice = PriceDetail.LivePrice /> 
				<cfif I.ParentSkuID eq CartItem.SkuID and I.ParentPriceIncrease neq 0>
					<cfset ParentPrice = ParentPrice + I.ParentPriceIncreas>
				</cfif>
			</cfloop>
			<cfset PriceDetail.Price = ParentPrice />
			<cfset PriceDetail.AdjustmentType = "PackageParent" />
			<cfset PriceDetail.AdjustmentDetail = "" />
			<cfset arrayAppend(PriceOptions, #PriceDetail#) />	
		<cfelseif CartItem.ParentSkuID neq "" and CartItem.ParentSkuID neq 0>
			<!--- Child Items Get 0 Price --->
			<cfset PriceDetail = structnew() />
			<cfset PriceDetail.OriginalPrice = Sku.getOriginalPrice() />
			<cfset PriceDetail.LivePrice = Sku.getLivePrice() />
			<cfset PriceDetail.Price = 0 />
			<cfset PriceDetail.AdjustmentType = "Package" />
			<cfset PriceDetail.AdjustmentDetail = "#CartItem.ParentSkuID#" />
			<cfset arrayAppend(PriceOptions, #PriceDetail#) />
		<cfelse>
			<!--- All Other Items Start With Live Price As Base  --->
			<cfset PriceDetail = structnew() />
			<cfset PriceDetail.OriginalPrice = Sku.getOriginalPrice() />
			<cfset PriceDetail.LivePrice = Sku.getLivePrice() />
			<cfset PriceDetail.Price = Sku.getLivePrice() />
			<cfset PriceDetail.AdjustmentType = "" />
			<cfset PriceDetail.AdjustmentDetail = "" />
			<cfif PriceDetail.OriginalPrice gt PriceDetail.LivePrice>
				<cfset PriceDetail.AdjustmentType = "Sale" />
				<cfset PriceDetail.AdjustmentDetail = "" />				<!---- Add Sale ID --->
			</cfif>
			<cfset arrayAppend(PriceOptions, #PriceDetail#) />
		</cfif>
		
		<cfset StartingPriceDetail = PriceDetail />
		
		<!--- Search For Cart Coupons --->
		<cfloop from="1" to="#arraylen(Session.Slat.Cart.Coupons)#" index="CartCouponID">
			
			<cfset Coupon = application.slat.couponManager.read(Session.Slat.Cart.Coupons[CartCouponID].CouponID) />
			
			<cfset ApplyToProduct = 1>
			<cfif coupon.getSelectedProductsOnly()>
				<!--- Check Product List --->
				<cfset ApplyToProduct = 0>
			<cfelseif not Sku.getisDiscountable()>
				<cfset ApplyToProduct = 0>
			<cfelseif getCartItemsQuantityTotalForCoupons() lt Coupon.getMinimumCartItemsQuantity()>
				<cfset ApplyToProduct = 0>
			<cfelseif Coupon.getMinimumCartItemsValue() gt 1>
				<cfif getCartItemsLivePriceTotalForCoupons() lt Coupon.getMinimumCartItemsValue()>
					<cfset ApplyToProduct = 0>
				</cfif>
			</cfif>
			
			<cfif ApplyToProduct>
				
				<cfif Coupon.getCouponTypeID() eq 1>
					<cfset PriceDetail = structnew() />
					<cfset PriceDetail.OriginalPrice = Sku.getOriginalPrice() />
					<cfset PriceDetail.LivePrice = Sku.getLivePrice() />
					<cfset PriceDetail.Price = Sku.getOriginalPrice() - (Sku.getOriginalPrice()*(Coupon.getAmount()/100)) />
					<cfset PriceDetail.Price = round(PriceDetail.Price*100)/100 />
					<cfset PriceDetail.AdjustmentType = "Coupon" />
					<cfset PriceDetail.AdjustmentDetail = "#Coupon.getCouponCode()#" />
				<cfelseif Coupon.getCouponTypeID() eq 2>
					<cfset PriceDetail = structnew() />
					<cfset PriceDetail.OriginalPrice = Sku.getOriginalPrice() />
					<cfset PriceDetail.LivePrice = Sku.getLivePrice() />
					<cfset PriceDetail.Price = Sku.getOriginalPrice() - Coupon.getAmount() />
					<cfset PriceDetail.AdjustmentType = "Coupon" />
					<cfset PriceDetail.AdjustmentDetail = "#Coupon.getCouponCode()#" />
				</cfif>
				<cfset ArrayAppend(PriceOptions, #PriceDetail#) />
			</cfif>
		</cfloop>
		
		
		<cfloop from="1" to="#arraylen(PriceOptions)#" index="PriceOptionID">
			<cfif PriceOptions[PriceOptionID].Price lt PriceOptions[BestPriceID].Price>
				<cfset BestPriceID = PriceOptionID />
			</cfif>
		</cfloop>
		
		<cfset ReturnPriceDetail = PriceOptions[BestPriceID] />
		
		<cfreturn ReturnPriceDetail />
	</cffunction>
	
	<cffunction name="getCartItemPriceExtended" access="public" returntype="numeric" output="false">
		<cfargument name="CartItemID" required="true" />
		
		<cfreturn getCartItemPrice(arguments.CartItemID) * session.Slat.cart.items[#arguments.CartItemID#].Quantity />
	</cffunction>
	
	<cffunction name="getCartItemTax" access="private" returntype="struct" output="false">
		<cfargument name="CartItemID" required="true" />
		<cfargument name="TaxType" required="true" />
		
		<cfset var CartItemTax = 0 />
		<cfset var CartItemTaxRate = 0 />
		<cfset var CartItem = session.Slat.cart.items[arguments.CartItemID] />
		<cfset var Taxes = querynew('empty') />
		<cfset var LoopOK = 1>
		<cfset var ReturnTax = structNew() />
		<cfset var ShippingAddress = structnew() />
		<cfset var TaxApplies = 1>
		
		<cfif CartItem.isTaxable>
			<cfset ShippingAddress = session.Slat.cart.ShippingAddresses[CartItem.ShippingID] />
			<cfif ShippingAddress.Country neq "" or ShippingAddress.Locality neq "" or ShippingAddress.State neq "" or ShippingAddress.City neq "" or ShippingAddress.PostalCode neq "">
				<cfquery name="Taxes" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
					Select
						Country,
						Locality,
						State,
						City,
						PostalCode,
						TaxRate
					From
						tslattaxes
					Where
						TaxType = '#arguments.TaxType#'
				</cfquery>
				<cfset LoopOK = 1>
				<cfloop query="Taxes">
					<cfif LoopOK>
						<cfset TaxApplies = 1>
						<cfif Taxes.Country neq ShippingAddress.Country and Taxes.Country neq "">
							<cfset TaxApplies = 0>
						<cfelseif Taxes.Locality neq ShippingAddress.Locality and Taxes.Locality neq "">
							<cfset TaxApplies = 0>
						<cfelseif Taxes.State neq ShippingAddress.State and Taxes.State neq "">
							<cfset TaxApplies = 0>
						<cfelseif Taxes.City neq ShippingAddress.City and Taxes.City neq "">
							<cfset TaxApplies = 0>
						<cfelseif Taxes.PostalCode neq ShippingAddress.PostalCode and Taxes.PostalCode neq "">
							<cfset TaxApplies = 0>
						</cfif>
						<cfif TaxApplies>
							<cfset CartItemTaxRate = Taxes.TaxRate />
							<cfset CartItemTax = getCartItemPriceExtended(arguments.CartItemID)*Taxes.TaxRate />
							<cfset LoopOK = 0 />
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		
		<cfset ReturnTax.Amount = CartItemTax />
		<cfset ReturnTax.Rate = CartItemTaxRate />
		<cfset ReturnTax.Type = arguments.TaxType />
		
		<cfreturn ReturnTax />
	</cffunction>
	
	<cffunction name="getCartItemsTotal" access="public" returntype="numeric" output="false">
		<cfset var CartItemsTotal = 0 />
		<cfset var I = 0 />
		
		<cfloop index="I" from="1" to="#arrayLen(Session.Slat.Cart.Items)#">
			<cfset CartItemsTotal = CartItemsTotal + getCartItemPriceExtended(#I#) />
		</cfloop>
		<cfreturn CartItemsTotal />
	</cffunction>
	
	<cffunction name="getCartItemsQuantityTotalForCoupons" access="public" returntype="numeric" output="false">
		<cfset CartItemsQuantityTotalForCoupons = 0 />
		<cfloop index="I" from="1" to="#arrayLen(Session.Slat.Cart.Items)#">
			<cfset CartItemsQuantityTotalForCoupons = CartItemsQuantityTotalForCoupons + session.Slat.cart.items[i].Quantity />
		</cfloop>
		<cfreturn CartItemsQuantityTotalForCoupons />
	</cffunction>
	
	<cffunction name="getCartItemsLivePriceTotalForCoupons" access="public" returntype="numeric" output="false">
		<cfset CartItemsLivePriceTotalForCoupons = 0 />
		<cfloop index="I" from="1" to="#arrayLen(Session.Slat.Cart.Items)#">
			<cfset Sku = application.Slat.skuManager.read(skuid = Session.Slat.Cart.Items[I].SkuID) />
			<cfset CartItemsLivePriceTotalForCoupons = CartItemsLivePriceTotalForCoupons + Sku.getLivePrice() />
		</cfloop>
		<cfreturn CartItemsLivePriceTotalForCoupons />
	</cffunction>
	
	<cffunction name="getCartShippingTotal" access="public" returntype="numeric" output="false">
		<cfset var CartShippingTotal = 0 />
		<cfset var I = 0 />
		
		<cfloop array="#Session.Slat.Cart.ShippingMethods#" index="I">
			<cfset CartShippingTotal = CartShippingTotal + I.Cost />
		</cfloop>
		
		<cfreturn CartShippingTotal>
	</cffunction>
	
	<cffunction name="getCartTaxTotal" access="public" returntype="numeric" output="false">
		<cfset var CartTaxTotal = 0 />
		
		<cfset CartTaxTotal = CartTaxTotal + getTaxTotalByType('State') />
		<cfset CartTaxTotal = CartTaxTotal + getTaxTotalByType('Local') />
		
		<cfreturn CartTaxTotal>
	</cffunction>
	
	<cffunction name="getTaxTotalByType" access="public" returntype="numeric" output="false">
		<cfargument name="TaxType" required="true" />
		<cfset var TaxTotal = 0 />
		<cfset var TaxStruct = structnew() />
		<cfset var I = 0 />
		
		<cfloop index="I" from="1" to="#arrayLen(Session.Slat.Cart.Items)#">
			<cfset TaxStruct = getCartItemTax(I,arguments.TaxType) />
			<cfset TaxTotal = TaxTotal + TaxStruct.Amount />
		</cfloop>
		
		<cfreturn TaxTotal>
	</cffunction>
	
	<cffunction name="getCartTotal" access="public" returntype="numeric" output="false">
		<cfset var CartTotal = 0 />
		<cfset CartTotal = CartTotal + getCartItemsTotal() />
		<cfset CartTotal = CartTotal + getCartShippingTotal() />
		<cfset CartTotal = CartTotal + getCartTaxTotal() />
		<cfreturn CartTotal>
	</cffunction>
	
	<cffunction name="getCartAmountDueTotal" access="public" returntype="numeric" output="false">
		<cfreturn Evaluate(Round(getCartTotal()*100)/100)-getCartPaidTotal() />
	</cffunction>
	
	<cffunction name="getCartPaidTotal" access="public" returntype="numeric" output="false">
		<cfset TotalPaid = 0>
		<cfloop array="#session.slat.cart.paymentmethods#" index="PaymentMethod">
			<cfset TotalPaid = TotalPaid + PaymentMethod.Amount />
		</cfloop>
		<cfreturn TotalPaid>
	</cffunction>
	
	<cffunction name="getCartItemsDiscountTotal" access="public" returntype="numeric" output="true">
		<cfset var CartItemsDiscountTotal = 0>
		<cfset var newIndex = 0>
		<cfset var Sku = "" />
		<cfset var OriginalPrice = 0 />
		
		<cfloop index="newIndex" from="1" to="#arrayLen(Session.Slat.Cart.Items)#">
			<cfset Sku = application.Slat.skuManager.read(skuid = Session.Slat.Cart.Items[newIndex].SkuID) />
			<cfset OriginalPrice = Sku.getOriginalPrice() />
			
			<cfset CartItemsDiscountTotal = CartItemsDiscountTotal + ((OriginalPrice*Session.Slat.Cart.Items[newIndex].Quantity)-getCartItemPriceExtended(newIndex)) />
		</cfloop>
		
		<cfreturn CartItemsDiscountTotal>
	</cffunction>
	
	<cffunction name="getShippingDiscountTotal" access="public" returntype="numeric" output="false">
		<cfset var ShippingDiscountTotal = 0>
		<cfreturn ShippingDiscountTotal>
	</cffunction>
	
	<cffunction name="getCartDiscountsTotal" access="public" returntype="numeric" output="false">
		<cfreturn getCartItemsDiscountTotal()+getShippingDiscountTotal() >
	</cffunction>
	
	<cffunction name="getCartTotalShipmentWeight" access="public" returntype="numeric" output="false">
		<cfargument name="CartShippingAddressID" default="1">
		
		<cfset var TotalShipmentWeight = 0 />
		<cfset var I = 0 />
		<cfset var Product = "" /> 
		
		<cfloop array="#Session.Slat.Cart.Items#" index="I">
			<cfif I.ShippingID eq arguments.CartShippingAddressID>
				<cfset Product = application.Slat.productManager.read('#I.ProductID#') />
				<cfset TotalShipmentWeight = TotalShipmentWeight + Product.getWeight() />
			</cfif>
		</cfloop>
		
		<cfif TotalShipmentWeight lt 1>
			<cfset TotalShipmentWeight = 1>
		</cfif>
		
		<cfreturn TotalShipmentWeight />
	</cffunction>
	
	<!--- HELPER FUNCTIONS --->
	
	<cffunction name="getDebug" returnType="any" output="false">
		<cfreturn variables />
	</cffunction>
</cfcomponent>