<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfif isDefined('args.Vendor')>
	<cfset local.DirectoryIteratory = args.Vendor.getDirectoryIterator() />
<cfelse>
	<cfset local.DirectoryIteratory = application.Slatwall.directoryManager.getDirectoryIterator(request.slatwall.queryOrganizer.organizeQuery(application.Slatwall.directoryManager.getEntireDirectoryQuery())) />
</cfif>
<cfoutput>
<div class="svoDirectoryCards">
	<cfloop condition="#local.DirectoryIteratory.hasNext()#">
		<cfset local.Directory = local.DirectoryIteratory.Next() />
		<dl class="DirectoryCard">
			<dt>#local.Directory.getFirstName()# #local.Directory.getLastName()#</dt>
			<dd>#local.Directory.getContactType()#</dd>
			<dd>#local.Directory.getCompany()#</dd>
			<dd>#local.Directory.getPrimaryPhone()#</dd>
			<dd><a href="mailto:#local.Directory.getPrimaryEmail()#">#local.Directory.getPrimaryEmail()#</a></dd>
		</dl>
	</cfloop>
</div>
</cfoutput>
