<p>In Slatwall, the base object utilizes the <code>getFormattedValue()</code> method. This method formats different data types depending on the settings defined in the Advanced Global Settings of the admin.</p>
<p>For example, "sku.getFormattedValue('price');" returns the value based on the currency format settings in the Advanced settings tab.</p>
<p>The "getFormattedValue()" method utlizes the "getPropertyFormatType()" method of the base object to discover the proper formatType of a property. This feature may be overridden. For instance, order.getFormattedValue('openDateTime', 'date') will display only the date and not the entire datetime.</p>
<p>Valid formatTypes are:</p>
<ul>
	<li>none</li>
	<li>yesno</li>
	<li>truefalse</li>
	<li>currency</li>
	<li>datetime</li>
	<li>date</li>
	<li>time</li>
	<li>weight</li>
</ul>
<p>By default, the "getPropertyFormatType()" method will use ormtype, type, and naming conventions of the property. Formatting can also be explicitly defined by using a custom attribute called "formatType".</p>
<p>
<stong>Example</strong>
<pre class="prettyprint linenums language-js">
property name="price" ormtype="big_decimal" type="numeric" formatType="currency";
</pre>