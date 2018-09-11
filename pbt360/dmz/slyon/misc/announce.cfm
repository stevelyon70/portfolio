<!---pull the announcements if any and display--->
<!---9/13/12 by DS modify announcement to put in banner with tracking variables--->


<CFSET date = #CREATEODBCDATE(NOW())#>
<cfquery name="pull_ann" datasource="paintsquare">
select headline, message
from bidtracker_announcements 
where active_date <= #date# and expire_date >= #date#
and type = 2 
</cfquery>


<cfif pull_ann.recordcount gt 0>
<cfoutput>
<tr>
	<td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: ##FFFFFF; padding-top:7px; padding-bottom:18px; padding-right:10px; padding-left:10px; margin-top:7px; margin-bottom: 14px;">
    <p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px; margin:0px;"><span style="font-weight:bold; font-style:italic;"><cfif pull_ann.headline is not "">#pull_ann.headline#</cfif></span><br />
    #pull_ann.message#
    </p>
    <hr size="1" color="C0C0C0">
    </td>
</tr>
</cfoutput>
</cfif>