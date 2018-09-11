<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">


<CFSET BASEDATE = #CREATEODBCDATE(NOW())#>
<!---zipcode filter to search by zipcode ranges--->
<cfquery name="checkuser_ZIPS" datasource="#application.datasource#">
select distinct bid_subscription_log.packageid,bid_subscription_log.zipcode
from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
where bid_users.userid =  <cfqueryPARAM value = "#session.auth.userid#" CFSQLType = "CF_SQL_INTEGER"> and bid_subscription_log.packageid in (#zip_packageid#)  and bid_subscription_log.effective_date <= #basedate# and bid_subscription_log.expiration_date >= #basedate# and bid_subscription_log.active = 1
</cfquery> 
    <cfif checkuser_ZIPS.recordcount is not 0>
	
	<cfquery name="zip" datasource="#application.datasource#">
	select distinct bid_user_zipcodes.zipcode 
	from bid_user_zipcodes
	inner join bid_user_zipcode_log on bid_user_zipcode_log.bzid = bid_user_zipcodes.bzid
	where bid_user_zipcodes.userid = #session.auth.userid# and bid_user_zipcodes.active = 1 and bid_user_zipcode_log.packageid in (#zip_packageid#,66)
	<cfif isdefined("state") and state is not "66">and bid_user_zipcodes.stateid in (#state#)</cfif>
	</cfquery>
	<cfif zip.recordcount is not 0>
		<!---cfif zip.recordcount gt 500>
		<cfquery name="zip1" datasource="paintsquare" maxrows="500">
		select distinct bid_user_zipcodes.zipcode,bid_user_zipcodes.bzid
		from bid_user_zipcodes
		inner join bid_user_zipcode_log on bid_user_zipcode_log.bzid = bid_user_zipcodes.bzid
		where bid_user_zipcodes.userid = #userid# and bid_user_zipcodes.active = 1 and bid_user_zipcode_log.packageid in (#zip_packageid#,66)
		<cfif isdefined("state") and state is not "66">and bid_user_zipcodes.stateid in (#state#)</cfif>
		order by bid_user_zipcodes.bzid
		</cfquery>
		<cfquery name="zip15" dbtype="query" maxrows=1>
		select distinct bzid as maxzip
		from zip1
		order by bzid desc
		
		</cfquery>
		
		<cfquery name="zip2" datasource="paintsquare" >
		select distinct bid_user_zipcodes.zipcode 
		from bid_user_zipcodes
		inner join bid_user_zipcode_log on bid_user_zipcode_log.bzid = bid_user_zipcodes.bzid
		where bid_user_zipcodes.userid = #userid# and bid_user_zipcodes.active = 1 and bid_user_zipcode_log.packageid in (#zip_packageid#,66)
		<cfif isdefined("state") and state is not "66">and bid_user_zipcodes.stateid in (#state#)</cfif>
		and bid_user_zipcodes.bzid > #zip15.maxzip#
		
		</cfquery>
		<cfset ziplist = valuelist(zip1.zipcode)>
		<cfset ziplist2 = valuelist(zip2.zipcode)>
		<cfelse>
		
		<cfset ziplist = valuelist(zip.zipcode)>
		</cfif--->
			<cfset ziplist = valuelist(zip.zipcode)>
	</cfif>
	</cfif>

