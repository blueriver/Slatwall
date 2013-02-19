<p>Now that you have Slatwall installed via the Mura connector plugin, it is important to understand how the two tools interact with each other. Mura is an extremely flexible and robust Content Management System, and with that in mind we have set up the integration to leverage all of the great functionality Mura has to offer.<p>
<br />
<br />
<h4>Account Management</h4>
<p>We talked about this a little bit in the install process but there are a number of ways that accounts can be managed and synced (or not synced).  The two systems can have totally seperate users, however we find that most companies would like their Mura system users to sync with Slatwall, but that the customer accounts in Slatwall not get setup as Site Users in mura.  Our thought process is that if you don't have a need for the users to be in mura, there is no reason to keep two copies of all those customer accounts in the database.  The authentication works just like a "Login with Google" or "Login with Facebook", but in this situation it is "Login with Mura".</p>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th>Setting Name</th>
			<th>Default</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Account Sync Type</td>
			<td>Mura System Users Only</td>
			<td>
				<ul>
					<li>Mura System Users Only: Selecting this option will automatically sync system user accounts from Mura into slatwall accounts, it will also auto-login and logout that account from slatwall if they are logged in / our of mura and vice versa.</li>
					<li>Mura Site Members Only: This is very similar to the option above, but the oppisite where it only syncs member accounts and no admin account</li>
					<li>All: Syncs accounts and login management for both types</li>
					<li>None: Mura users and Slatwall Accounts have nothing in common.</li>
				</ul>
			</td>
		</tr>
		<tr>
			<td>Add Mura Super Users to Slatwall Super User Group</td>
			<td>Yes</td>
			<td>If this is selected in conjuction with either the "Mura System Users Only" option or the "All" option above, then any super users in Mura will be super users in Slatwall.</td>
		</tr>
	</tbody>
</table>
<small>It is important to note that while these settings get defined by the connector plugin when you login, if you need to change those settings it is best to do it from inside the Mura integration by going to Integrations > Integrations, and selecting mura from the list.</small>
<br />
<br />
<h4>Automatically Created Mura Pages</h4>
<p>There is a third setting during the install "Create Default Pages and Templates".  When this is set to yes (which is recommended especially for first time users), then Slatwall will automatically create a handful of standard shopping-cart type pages in the Mura Site Manager so that you can get started.  It also copies over some custom templates into your sites theme directory that are designed to work with Slatwall.  You are free to modify those templates as you see fit.</p>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th>Page Name</th>
			<th>Page Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>My Account</td>
			<td>Requires a user to be logged in first. Shows the details of a user's account including: orders, profile information, address book, etc.</td>
		</tr>
		<tr>
			<td>Shopping Cart</td>
			<td>Displays the current user's cart information.  An SSL requirement is recommended for this page.</td>
		</tr>
		<tr>
			<td>Checkout</td>
			<td>The main template for displaying the checkout process.  An SSL requirement is recommended for this page.</td>
		</tr>
		<tr>
			<td>Order Confirmation</td>
			<td>Displays orders immediatly after placement.  This page is used to setup things like an after order survey, marketing ads, tracking codes, etc.</td>
		</tr>
		<tr>
			<td>Order Status</td>
			<td>Slighly different than the Order Confirmation page, the Order Status page displays the details of a customer's order.  This page can be accessed via the "My Account" menu or by unregistered users by entering their previous order's information.</td>
		</tr>
		<tr>
			<td>Product Template</td>
			<td>This is a special type of page that is used as a template for Slatwall.  In the Slatwall administrator for any given product you can select which page you would like to use as the template for that product.  You can create more product templates in the site manager, by creating a new page, going to the slatwall tab, and setting the "Template Type" to "Product".  In fact if you look at this page in the site administrator you will notice that has already been done on install.</td>
		</tr>
		<tr>
			<td>Product Type Template</td>
			<td>Same as Product Template, but these types of pages get assigned to product types.  If you edit this page in the site manager you will notice that it's "Template Type" is set to "Product Type"</td>
		</tr>
		<tr>
			<td>Brand Template</td>
			<td>Same as Product Template, but these types of pages get assigned to brands.  If you edit this page in the site manager you will notice that it's "Template Type" is set to "Brand"</td>
		</tr>
	</tbody>
</table>