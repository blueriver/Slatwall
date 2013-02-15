<p>Now that you have Slatwall installed via the Mura connector Plugin in Mura, it is important to understand how the two tools interact with each other. Mura is an extremely flexible and robust Content Management System.  With that in mind we have set it up to leverage all of the great functionality Mura has to offer.<p>
<h4>Account Management</h4>
<p>We talked about this a little bit in the install process but there are a number of ways that accounts can be managed and synced (or not synced) between Slatwall & Mura.  If you like the two systems can have totally seperate users, however we find that most companies would like their Mura system users to sync with Slatwall, but that the customer accounts in Slatwall not get setup as Site Users in mura.  Our thought process is that if you don't have a need for the users to be in mura, there is no reason to keep two copies of all those customer accounts in the database.  The authentication works just like a "Login with Google" or "Login with Facebook", but in this situation it is "Login with Mura".</p>
<table class="table table-strip ">
	<thead>
		<tr>
			<th>Setting Name</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Account Sync Type</td>
			<td></td>
		</tr>
		<tr>
			<td>Account Sync Type</td>
			<td></td>
		</tr>
	</tbody>
</table>
<small>It is important to note that while these settings get defined by the connector plugin when you login, if you need to change those settings it is best to do it from inside the Mura integration by going to Integrations > Integrations, and selecting mura from the list.</small>
<br />
<h4>Automatically Created Mura Pages</h4>

When Slatwall is installed, it automatically creates a handful of basic 'default' pages.  Slatwall relies on these pages to display different front-end functionality that you would expect from an eCommerce site. It is important to note that every aspect of these pages, except for the 'filename' property, can be changed. Slatwall relies on the 'filename' property for several features. If you do change the filename of one of these pages, a new version will be created the next time the application loads. Here is a list of the pages that are installed and their intended purpose.

Page Name	Page Explaination
My Account	Requires a user to be logged in first. Shows the details of a user's account including: orders, profile information, address book, etc.
Shopping Cart	Displays the current user's cart information.  An SSL requirement is recommended for this page.
Checkout	The main template for displaying the checkout process.  An SSL requirement is recommended for this page.
Order Confirmation	Displays orders immediatly after placement.  This page is used to setup things like an after order survey, marketing ads, tracking codes, etc.
Order Status	Slighly different than the Order Confirmation page, the Order Status page displays the details of a customer's order.  This page can be accessed via the "My Account" menu or by unregistered users by entering their previous order's information.
Product Templates/Default	At launch, only one template is listed, "Default". However, every page added to "Product Templates" can be assigned to a Product, a Product Type, or Globally.