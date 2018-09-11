<!---pull the announcements if any and display--->
<!---9/13/12 by DS modify announcement to put in banner with tracking variables--->
<!---1/21/13 by DS to remove banner put in old system--->


<CFSET date = #CREATEODBCDATE(NOW())#>
<cfquery name="pull_ann" datasource="paintsquare_master">
select headline, message
from bidtracker_announcements 
where active_date <= #date# and expire_date >= #date#
and type = 2 
</cfquery>


<cfif todaydate eq effective_date>
<tr>
<td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: ##FFFFFF; padding-top:7px; padding-bottom:18px; padding-right:10px; padding-left:10px; margin-top:7px; margin-bottom: 14px;">
<font size="2" face="Arial" color="000000">Welcome to Paint BidTracker!<br><br>This is the first of the daily emails you will receive detailing new bids that have been posted. The bids contained in your daily email will be broken down into five
general categories depending on the packages available for your account: Industrial Painting Project Bids, Commercial Painting Project Bids, General Construction/Maintenance Bids, Commercial Abatement Bids, and Subcontracting Opportunities.
<br><br>
You can access the details for each bid by simply clicking on the bid title in this email, or by logging into the Paint BidTracker user interface
at: http://www.paintsquare.com/bidtracker/
<br><br>
When you arrive at this screen, you will need to input your username and password.
<br><br>
The Paint BidTracker user interface offers a multitude of functionality that is not available via an email. You will be able to sort
bids in a number of different ways, in ascending or descending order. When the table of bids for the selected category appears, simply click on the column
name, i.e. Project Name, Agency, Submittal Date, to sort on that column. You will also have access to a powerful search function as well. 
<br><br>
Should you have any questions using Paint BidTracker, please feel free to contact Josiah Lockley jlockley@paintsquare.com, telephone number 1-800-837-8303. 
They will be more than happy to assist you. <br><br>
We look forward to providing you with an outstanding resource for getting new business!
<br><br>

Kind regards,<br>
Howard Booker<br>
PaintBidtracker.com
</font></p>
 <hr size="1" color="C0C0C0">
  </td>
</tr>
</cfif>
<!---cfoutput>
<tr>
	<td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: ##FFFFFF; padding-top:7px; padding-bottom:18px; padding-right:10px; padding-left:10px; margin-top:7px; margin-bottom: 14px;">
 <a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=1&nl_versionid=#nl_versionid#&redirectid=714&#addt_variables#"><img border="0" src="http://www.paintbidtracker.com/images/dd_conference_banner_pbt.jpg" ></a>
    </td>
</tr>
</cfoutput--->
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