<p>Managing your inventory and ensuring that the quantities in Slatwall match the true quantities of the items in a physical location is an import aspect of any inventory based business.</p>
<p>In order to verify the quantities in the system, a businesse should conduct one or more counts of the actual items in a given location and update the system with any discrepencies.  This may seem like a daugnting task, but slatwall provides some tools to help you process physical counts without distrubting the business.</p>
<h4>Running Your First Physical</h4>
<h5>Getting Started</h5>
<ol>
	<li>In the admin, navigate to Warehouse > Physicals</li>
	<li>Select the "Create Physical" button</li>
	<li>The first you need to do is select the locations that you would like to count.</li>
	<li>Now you will be place on the physical detail screen.</li>
</ol>
<h5>Selecting What your Counting</h5>
<p>When doing a physical, it is important to tell the system not only what location you are in, but also what it is that you are counting.  You can do this by switching through the tabs on the physical detail page, and check off either the product types, products, brands or skus that will be counting.  If all sections are left blank the system will assume that you would like to count everything.  This is important because anything that you don't count will automatically be zero'd out by the system when the physical is commited</p>
<h5>Adding Counts</h5>
<p>Now a physical has been created, we are going to want to add one or more counts to it.  You can think of counts as being a session where you walk out into the warehouse with a scanner and scan a bunch of barcodes and then walk back in and update them. If you had 2 warehouses, one in San Diego and one in New York, someone from each office could log in and upload their respective count.</p>
<ol>
	<li>In the upper right corner on the action bar, select the action dropdown and then "Add Physical Count"</li>
	<li>First you need to specify the location of your count.  While a physical can be for multiple locations, each count can only be for 1 of those locations</li>
	<li>New you will select a count commit Date Time. Later when you view discrepencies or commit this physical, the Date Time you specify hear will be used so that any inventory moving in or out after the count commit date/time will be accounted for, and automatically adjusted accordingly.  In short you are saying... "This is how many there were in the location at this particular Date/Time".</li>
	<li>Last you will need to select a comma seperated text file from your computer.  The file should be formatted as: skuCode,quantity. Example: <code>100000929,3</code></li>
	<li>Click save, and you are finished!</li>
</ol>
<p>You will notice that on the physicals page your count now shows up with the date/time and location.</p>
<h5>Discrepencies & Committing</h5>
<p>Once all of the counts are complete, it's time to review the discrepencies and commit</p>
<ol>
	<li>Select the "Discrepencies" tab in Slatwall</li>
	<li>You will see a list of everything that is either going to be positivly or negativly adjusted.</li>
	<li>Always verify that everything looks OK, because after the next step you cannot "Undo"</li>
	<li>Go back up to the action bar and select "Commit Physical".  This will automatically create a stock adjustment & stock receiver for all discrepencies, and set the physical status to "closed"</li>
	<li>If you need to make additional changes you will need to start a new physical and add more physical counts to it.</li>
</ol>