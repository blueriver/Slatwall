<table class="table table-bordered table-striped">
<tr>
<th>Folder & File</th>
<th>Description</th>
</tr>
<tr>
<td>admin/<br />&nbsp;&nbsp;controllers/<br />&nbsp;&nbsp;layouts/<br />&nbsp;&nbsp;views/</td>
<td>Holds the primary administrative web application.  This directory consists of 3 sub-directories; controllers, layouts & views.  The majority of the admin application runs through the /views/entity directory so if you are interested in learning about how we layout our administrative views, this would be a good place to start.<br /><br />It's important to note that this directory is a FW/1 subsystem, and for more information on how FW/1 subsystems work please visit the wiki here: <a href="https://github.com/seancorfield/fw1/wiki">FW/1 Wiki</a></td>
</tr>
<tr>
<td>assets/</td>
<td>The assets directory holds some of the core CSS & Images for the application</td>
</tr>
<tr>
<td>config/<br />&nbsp;&nbsp;dbdata/<br />&nbsp;&nbsp;resourceBundles/<br />&nbsp;&nbsp;scripts/<br />&nbsp;&nbsp;configApplication.cfm<br />&nbsp;&nbsp;configApplication.cfm<br />&nbsp;&nbsp;configCustomTags.cfm<br />&nbsp;&nbsp;configFramework.cfm<br />&nbsp;&nbsp;configORM.cfm<br />&nbsp;&nbsp;lastFullUpdate.txt.cfm</td>
<td>The config folder holds all of the data, and setup that Slatwall uses to set itself up.  This folder should never be modified, if you would like to make instance level configuration changes they should be done in the /custom/config direcotry.<br /><br />
<ul>
<li>dbdata/ - contains XML documents with the default data that gets inserted into the DB on install</li>
<li>resourceBundles/ - contains internationlization files for using slatwall in multiple languages</li>
<li>scrips/ - contains files that run during full updates to manipulate the database if needed.</li>
<li>configxxx.cfm - These files define the Hibachi setup information.</li>
<li>lastFullUpdate.txt.cfm - This file is written to every time an update reload is done.  If your application is having issues you can delete this file so that the next request forces a reload.</li>
</ul>
</td>
</tr>
<tr>
<td class="text-success">custom/<br />&nbsp;&nbsp;config/<br />&nbsp;&nbsp;&nbsp;&nbsp;resourceBundles/<br />&nbsp;&nbsp;model/<br />&nbsp;&nbsp;&nbsp;&nbsp;dao/<br />&nbsp;&nbsp;&nbsp;&nbsp;service/<br />&nbsp;&nbsp;&nbsp;&nbsp;validation/</td>
<td>Any customizations to how the applications functions can be defined in this directory without fear over being overridden when the application is updated.  You will notice that the folder structure mirrors the the same folder structure from the root.</td>
</tr>
<tr>
<td class="text-error">frontend/</td>
<td>The frontend directory was previously used as the primary subsytem used by public facing websites in versions 2.3 and previous.  This folder is deprecated so please use the 'public' subsystem for all new development.</td>
</tr>
<tr>
<td class="text-success">integrationServices/</td>
<td>This directory is the primary place where you can extend the Slatwall application to fit your businesse needs.  It contains a handful of integrations that we provide, and in addition you can add new directorys to this folder in order to extend / customize the application.</td>
</tr>
<tr>
<td class="text-info">meta/</td>
<td>Contains a lot of meta information about the application, including these docs.  It also has our Test suites, and some tools like snipits and dictionaries that can be used in your IDE or Text Editor</td>
</tr>
<tr>
<td>model/<br />&nbsp;&nbsp;dao/<br />&nbsp;&nbsp;entity/<br />&nbsp;&nbsp;process/<br />&nbsp;&nbsp;service/<br />&nbsp;&nbsp;transient/<br />&nbsp;&nbsp;validation/</td>
<td>
This is the beating heart of Slatwall, and contains all of the businesse logic that makes up Slatwall (with the exception of the /org/Hibachi directory).  It is strongly suggested that you explore these sub-directories and especially the /entity directory as it maps out the entire database structure.
<ul>
<li>dao/ - Used by the services as the go-between from service to database.</li>
<li>entity/ - All of the persistent data entities are stored here.</li>
<li>process/ - Contains transient objects used by the "Process" service methods.  Typically these objects are used to validate non-persistent data before it gets used in the application</li>
<li>service/ - The services in this directory control how the entities are managed.</li>
<li>transient/ - Contains objects that only exist for a single request, and pass data around the application.</li>
<li>validation/ - Contains all validation json files for all entities & process objects that get used both server-side & client-side.</li>
</ul>
</td>
</tr>
<tr>
<td>org/<br />&nbsp;&nbsp;Hibachi/</td>
<td>The org directory is where we store all libaries, frameworks, ect. that are independintly managed.  The primary external library is /Hibachi which is a framework developed by ten24 that sits on top of FW/1 to provide abstract ORM features for Rapid Application Development.</td>
</tr>
<tr>
<td>tags/</td>
<td>This directory holds some CF Custom tags that are used by Slatwall specifically in the admin and integrationServices</td>
</tr>
</table>
<small class="text-success">* Folder is save to make changes within, without fear of being overwritten during update.</small><br />
<small class="text-info">* Folder is not needed, but recommended</small><br />
<small class="text-error">* Folder is deprecated.</small>
