<cfparam name="rc.cart" type="any" />

<cfoutput>
	<div class="svofrontendcartdetail">
		<cfif not arrayLen(rc.cart.getCartItems())>
			<p class="noitems">#$.slatwall.rbKey('frontend.cart.detail.noitems')#</p>
		<cfelse>
			<cfloop array="#rc.cart.getCartItems()#" index="local.cartItem">
				<dl class="cartItem">
					<dt class="image">#local.cartItem.getSku().getImage(size="small")#</dt>
					<dt class="title">#local.cartItem.getSku().getProduct().getTitle()#</dt>
					<dd class="options">#local.cartItem.getSku().displayOptions()#</dd>
					<dd class="quantity">#local.cartItem.getQuantity()#</dd>
				</dl>
			</cfloop>
		</cfif>
	</div>
</cfoutput>