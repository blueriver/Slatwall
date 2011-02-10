<cfoutput>

<cfif arrayLen(rc.options) GT 0>
There are options.
<cfelse>
<p>#rc.rbFactory.getKeyValue(session.rb,"option.nooptionsdefined")#</p>
<ul id="navTask">
    <li><a href="#buildURL(action='admin:option.optiongroupform')#">#rc.rbFactory.getKeyValue(session.rb,"option.addoptiongroup")#</a></li>
</ul>
</cfif>

</cfoutput>