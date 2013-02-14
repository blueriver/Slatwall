<p>If you are currently running Slawtall version 2.3 or something newer as a plugin to mura, please follow these steps to migrate to the latest version.</p>
<ol>
	<li>Make a backup of Site Files & Database</li>
	<li>In Mura Administrator, update the core mura files to the latest version of Mura</li>
	<li>In the Mura administrator, delete the slatwall plugin (don't worry this will not delete your data)</li>
	<li>Download the new Mura Integration plugin from either <a href="http://www.getslatwall.com/" target="_blank">www.getslatwall.com</a>, or directly from it's github repository: <a href="https://github.com/ten24/slatwall-mura">github.com/ten24/slatwall-mura</a></li>
	<li>Install the plugin that you have downloaded into your Mura Application.</li>
</ol>
<p>When this new mura integration plugin gets installed, it will automatically download and Install the latest stable release of slatwall directly in your Mura root.  The new connector plugin serves as a go-between from Mura to Slatwall and is required now that Slatwall is a standalone application and not itself a plugin for Mura.</p>