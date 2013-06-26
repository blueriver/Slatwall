<!---

    Slatwall - An Open Source eCommerce Platform
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
																			
	This is an email template designed to be used to customize the emails	
	that slatwall sends.  If you would like to customize this template, it	
	should first be coppied into the /custom/templates/ directory in the	
	same folder path naming convention that it currently resides inside.	
																			
	All email templates have 2 objects that are passed in (seen below):		
																			
	email: This is the actually email entity that will have things like a	
	to, from, ext... that will eventually be persisted to the database as	
	a log of this e-mail so long as the "Log Email" setting is set to true	
																			
	emailData: This is a structure used to set values that will get			
	populated into the email entity once this processing is complete.		
	Typically you will want to set emailData.htmlBody & emailData.textBody	
	however, you can also set any of the other properties as well.  If you	
	do not set emailData.htmlBody, then the output of this include will be 	
	used as the htmlBody, and no textBody will be set.						
	It will also be used as a final stringReplace() struct for any ${} keys	
	that have not already been relpaced.  Another key field that you can	
	set in the emailData is voidSend=true which will cancel the sending of	
	this e-mail.															
																			
	Lastly, the base object that is being used for this email should also	
	be injected into the template and paramed at the top.					
																			
--->
<cfparam name="email" type="any" />	
<cfparam name="emailData" type="struct" default="#structNew()#" />
<cfparam name="account" type="any" />

<cfsilent>
	<cfset resetLink = "http://" />
	<cfset resetLink &= CGI.HTTP_HOST /> <!--- This adds the current domain name --->
	<cfset resetLink &= CGI.SCRIPT_NAME /> <!--- This adds the script name which includes the sub-directories that a site is in --->
	<cfset resetLink &= CGI.PATH_INFO /> <!--- This adds the current path information, basically what page you are on --->
	<cfset resetLink &= "?swprid=#account.getPasswordResetID()#" /> <!--- This is what tells the page to execute a password reset --->
</cfsilent>

<cfsavecontent variable="emailData.emailBodyHTML">
	<cfoutput>
		<div id="container" style="width: 625px; font-family: arial; font-size: 12px;background:##fff;">
			<h1 style="font-size: 20px;">Password Reset</h1>
			<p>Please reset your password by clicking this link where you will be prompted to enter a new password:</p>
			<p><a href="#resetLink#">#resetLink#</a></p>	
		</div>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="emailData.emailBodyText">
	<cfoutput>
		Password Reset
		
		Please reset your password by navigating to the link below where you will be prompted to enter a new password:
		
		#resetLink#
	</cfoutput>
</cfsavecontent>