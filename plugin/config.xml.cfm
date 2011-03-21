<plugin>
<name>Slatwall</name>
<package>Slatwall</package>
<directoryFormat>packageOnly</directoryFormat>
<version>0.4</version>
<provider>Slatwall</provider>
<providerURL>http://www.getslatwall.com/</providerURL>
<category>Application</category>
<settings>
	<setting>
		<name>Integration</name>  
		<label>Integration Type</label>  
		<hint>If you would like Slatwall to Integrate with another System, select it here</hint>  
		<type>select</type>
		<required>true</required>
		<validation></validation>  
		<regex></regex>
		<message></message>
		<defaultvalue></defaultvalue>  
		<optionlist>Internal^Custom^Quickbooks</optionlist>  
		<optionlabellist>None (Internal)^Custom^Quickbooks</optionlabellist>  
	</setting>
	<setting>  
		<name>IntegrationDSN</name>  
		<label>Integration Datasource</label>  
		<hint>Datasource of your integration type</hint>  
		<type>text</type>
		<required>false</required>
		<validation></validation>  
		<regex></regex>
		<message></message>
		<defaultvalue></defaultvalue>  
		<optionlist></optionlist>  
		<optionlabellist></optionlabellist>  
	</setting>
	<setting>  
		<name>IntegrationDBUsername</name>  
		<label>Integration DB Username</label>  
		<hint>Username for the Integration Datasource</hint>  
		<type>text</type>
		<required>false</required>
		<validation></validation>  
		<regex></regex>
		<message></message>
		<defaultvalue></defaultvalue>  
		<optionlist></optionlist>  
		<optionlabellist></optionlabellist>  
	</setting>
	<setting>  
		<name>IntegrationDBPassword</name>  
		<label>Integration DB Password</label>  
		<hint>Password for the Integration Datasource</hint>  
		<type>text</type>
		<required>false</required>
		<validation></validation>  
		<regex></regex>
		<message></message>
		<defaultvalue></defaultvalue>  
		<optionlist></optionlist>  
		<optionlabellist></optionlabellist>  
	</setting>
	<setting>  
		<name>ORMpreference</name>  
		<label>Automatically Install ORM Setting?</label>  
		<hint>Allow Slatwall to automatically install ORM settings for you?</hint>  
		<type>select</type>
		<required>true</required>
		<validation></validation>  
		<regex></regex>
		<message></message>
		<defaultvalue></defaultvalue>  
		<optionlist>true^false</optionlist>  
		<optionlabellist>Yes^No</optionlabellist>  
	</setting>
</settings>

<eventHandlers>
	<eventHandler event="onApplicationLoad" component="fw1EventAdapter" persist="false"/>
	<eventHandler event="onGlobalSessionStart" component="fw1EventAdapter" persist="false"/>
	<eventHandler event="onGlobalLoginSuccess" component="fw1EventAdapter" persist="false"/>
	<eventHandler event="onSiteLoginSuccess" component="fw1EventAdapter" persist="false"/>
	<eventHandler event="onSiteRequestStart" component="fw1EventAdapter" persist="false"/>
	<eventHandler event="onRenderStart" component="fw1EventAdapter" persist="false"/>	
	<eventHandler event="onRenderEnd" component="fw1EventAdapter" persist="false"/>	
</eventHandlers>
<displayobjects location="global">
	<displayobject name="Content Product List" displaymethod="product_listcontentproducts" component="fw1DisplayAdapter" persist="false"/>
	<displayobject name="Account" displaymethod="account_detail" component="fw1DisplayAdapter" persist="false"/>
</displayobjects>
</plugin>