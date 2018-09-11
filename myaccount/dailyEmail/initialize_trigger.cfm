<!---<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!---main initialize action by DS 6/29/09--->
<CFSET todaydate = #CREATEODBCDATE(NOW())#>
<cfset day=dayofweek(todaydate)>
<cfset d =#dayofweekasstring(day)#>
<!---cfset todaydate = dateadd("d",1,todaydate)--->
<CFSET CDATE = #CREATEODBCDATE(NOW())#>
<cfset day_of_week = DayofWeekAsString(DayOfWeek(CDate))>
<!---cfif day_of_week is "Friday">
	<cfset CDATE = dateadd("d",3,cdate)>					
<cfelse>
	<cfset CDATE = dateadd("d",1,cdate)>				
</cfif--->
<cfset cdate = dateformat(cdate, "mm/dd/yyy")><!---abort if day is weekend--->
<!---cfset cdate = "11/30/2009"---><!---temp override for holiday--->
<Cfif d is "Saturday" or d is "Sunday"><cfabort showerror="Weekend"></cfif>
<!---run holiday check--->
<cfquery name="check_holiday" datasource="paintsquare_master">
select nl_holidayid
from nl_holiday
where target_date = #todaydate# and (content_type = 'all' or content_type = 'pbt')
</cfquery>
<Cfif check_holiday.recordcount gt 0><cfabort showerror="holiday"></cfif>
<!---run check to confirm no newsletter pertaining to this date in queue--->

<cfquery name="check_existing" datasource="paintsquare_master">
select nl_versionid
from nl_main
where target_date = '#cdate#' and newsletter_id = 35
</cfquery>
<cfif check_existing.recordcount gt 0 ><cfabort showerror="Newsletter Already Existing"></cfif>
--->
<cftransaction action="begin">
<!---trigger main insert step 1--->
<cfinclude template="main_initialize.cfm">

<!---trigger headlines step 2--->
<cfinclude template="ads_initialize.cfm">

<cfquery name="get_lastid" datasource="paintsquare_master"><!---get the last inserted id--->
 SELECT MAX(sentID) AS ArbitraryVariableName
FROM nl_sentto
</cfquery>
<cfset sendid = get_lastid.ArbitraryVariableName>

<cfset trackid = sendid>
</cftransaction>


