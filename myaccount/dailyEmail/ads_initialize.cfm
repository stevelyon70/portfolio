<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!---ads_initialize page to pull ads for daily newsletter created by DS on 6/30--->

<!---CFSET TDATE1 = #CREATEODBCDATE(NOW())#>
<cfset day_of_week = DayofWeekAsString(DayOfWeek(TDate1))>
<cfif day_of_week is "Friday">
	<cfset TDATE = dateadd("d",3,tdate1)>					
<cfelse>
	<cfset TDATE = dateadd("d",1,tdate1)>				
</cfif--->

<!---set the day variable --->

<cfset day_of_week = DayOfWeek(tDate)>
<!---set the week day part to identify the week range--->
<cfset weekday = DatePart("d", tDate)>
<cfif weekday gte 1 and weekday lte 7>
<cfset weeknumber = 1>
<cfelseif weekday gte 8 and weekday lte 14>
<cfset weeknumber = 2>
<cfelseif weekday gte 15 and weekday lte 23>
<cfset weeknumber = 3>
<cfelseif weekday gte 24 and weekday lte 31>
<cfset weeknumber = 4>
</cfif>
<cfquery name="pull_ads" datasource="paintsquare_master">
select a.nl_sponsorID,a.nl_adID,a.nl_skedID
from nl_sponsors_schedule a 
where start_date <= '#tdate#' and end_date >= '#tdate#' and (dayofweek = #day_of_week# or dayofweek is null)
and (week_number = #weeknumber# or week_number is null) and nl_positionID = 49 and newsletterID = 35
</cfquery>



<!--- make sure there are records available --->
<cfif pull_ads.recordCount gt 0>
  <!---Set max rows for short, default list--->
 <!--- make a list --->
 <cfset itemListFC = "">
 <cfloop from="1" to="#pull_ads.recordCount#" index="i">
   <cfset itemListFC = ListAppend(itemListFC, i)>
 </cfloop>
 <!--- randomize the list --->
 <cfset randomItemsCoat = "">
 <cfset itemCount = ListLen(itemListFC)>
 <cfloop from="1" to="#itemCount#" index="i">
   <cfset random = ListGetAt(itemListFC, RandRange(1, itemCount))>
   <cfset randomItemsCoat = ListAppend(randomItemsCoat, random)>
   <cfset itemListFC = ListDeleteAt(itemListFC, ListFind(itemListFC, random))>
   <cfset itemCount = ListLen(itemListFC)>
 </cfloop>
</cfif>
<!---insert the randomized ads into db--->
<cfloop from="1" to="#pull_ads.recordCount#" index="i">
<cfquery name="insert_ads" datasource="paintsquare_master">
insert into nl_sponsors_versions
(nl_sponsorID,nl_versionID,nl_adID,sponsor_sort,nl_skedID)
values(#pull_ads.nl_sponsorID[ListGetAt(randomItemsCoat, i)]#,#nl_versionID#,#pull_ads.nl_adID[ListGetAt(randomItemsCoat, i)]#,#i#,#pull_ads.nl_skedID[ListGetAt(randomItemsCoat, i)]#)
</cfquery>
</cfloop>