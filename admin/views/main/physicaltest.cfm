PHYSICAL<br />
<cfset p = entityNew("SlatwallPhysical") />
BEFORE: <cfdump var="#p.getPhysicalID()#" /><br />
<cfset entitySave( p ) />
AFTER: <cfdump var="#p.getPhysicalID()#" /><br />
<br />
<br />
PHYSICAL COUNT<br />
<cfset pc = entityNew("SlatwallPhysicalCount") />
BEFORE: <cfdump var="#pc.getPhysicalCountID()#" /><br />
<cfset entitySave( pc ) />
AFTER: <cfdump var="#pc.getPhysicalCountID()#" /><br />
<br />
<br />
TERM<br />
<cfset t = entityNew("SlatwallTerm") />
BEFORE: <cfdump var="#t.getTermID()#" /><br />
<cfset entitySave( t ) />
AFTER: <cfdump var="#t.getTermID()#" /><br />
<cfabort />