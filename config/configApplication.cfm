<cfset this.name = "slatwall" & hash(getCurrentTemplatePath()) />
<cfset this.sessionManagement = true />
<cfset this.datasource = {} />
<cfset this.datasource.name = "Slatwall" />