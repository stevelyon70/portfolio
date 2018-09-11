<!---Transition process to collect user-entered info and turn around form submission to Authorize.net--->

<!---Calculated cost and description--->
<cfif page is "post_job" and isdefined("jobID")>
	<cfset date=#createodbcdatetime(now())#>
	<cfquery name="check_ad" datasource="#the_dsn#">
		select reg_userID, featured_job
		from job_master
		where jobID = #jobID#
	</cfquery>
	<cfquery name="job_pricing" datasource="#the_dsn#">
		select basic, enhanced, basic_duration, enhanced_duration
		from classified_pricing
		where class_type='jobs' and purchase_type='single'
	</cfquery>
	<cfif check_ad.featured_job is 'y'>
		<cfset cost1 = job_pricing.basic + job_pricing.enhanced>
		<cfset description1 = "Job Posting with Featured Listing in the Paint BidTracker Classifieds">
	<cfelse>
		<cfset cost1 = job_pricing.basic>
		<cfset description1 = "Job Posting in the Paint BidTracker Classifieds">
	</cfif>
	<cfquery name="check_free" datasource="#the_dsn#">
		select * from freeposter
		where ID in (select freeposterID from freeposter_log where siteID=3)
		and (expiration > '#dateformat(date-1, 'm/d/yyyy')#'  or (totalpost is not null and totalpost > 0))
		and (supplierID in (select supplierID from reg_users where reg_userID = #check_ad.reg_userID#) or reg_userID = #check_ad.reg_userID#)
	</cfquery>
	<cfif check_free.recordcount gt 0>
		<cfset fp=1>
		<cfif check_ad.featured_job is 'y'>
			<cfset cost1 = job_pricing.enhanced>
			<cfset description1 = "Job Posting with Featured Listing in the Paint BidTracker Classifieds">
		<cfelse>
			<cflocation url="http://www.paintbidtracker.com/classifieds?fuseaction=jobs&action=post&process=4&jobID=#jobID#&expiration_date=#expiration_date#">
		</cfif>
	</cfif>
<cfelseif page is "edit_job" and isdefined("jobID")>
	<cfset date=#createodbcdatetime(now())#>
	<cfquery name="check_ad" datasource="#the_dsn#">
		select reg_userID, featured_job
		from job_master
		where jobID = #jobID#
	</cfquery>
	<cfquery name="job_pricing" datasource="#the_dsn#">
		select basic, enhanced
		from classified_pricing
		where class_type='jobs' and purchase_type='single'
	</cfquery>
	<cfif check_ad.featured_job is 'y'>
		<cfset cost1 = job_pricing.basic + job_pricing.enhanced>
		<cfset description1 = "Job Posting Renewal with Featured Listing in the Paint BidTracker Classifieds">
	<cfelse>
		<cfset cost1 = job_pricing.basic>
		<cfset description1 = "Job Posting Renewal in the Paint BidTracker Classifieds">
	</cfif>
	<cfquery name="check_free" datasource="#the_dsn#">
		select * from freeposter
		where ID in (select freeposterID from freeposter_log where siteID=3)
		and (expiration > '#dateformat(date-1, 'm/d/yyyy')#'  or (totalpost is not null and totalpost > 0))
		and (supplierID in (select supplierID from reg_users where reg_userID = #check_ad.reg_userID#) or reg_userID = #check_ad.reg_userID#)
	</cfquery>
	<cfif check_free.recordcount gt 0>
		<cfset fp=1>
		<cfif check_ad.featured_job is 'y'>
			<cfset cost1 = job_pricing.enhanced>
			<cfset description1 = "Job Posting Renewal with Featured Listing in the Paint BidTracker Classifieds">
		<cfelse>
			<cflocation url="http://www.paintbidtracker.com/classifieds?fuseaction=jobs&action=post&process=4&jobID=#jobID#&expiration_date=#expiration_date#">
		</cfif>
	</cfif>
</cfif>

<cfsetting enablecfoutputonly="true">
<!---
This sample code is designed to connect to Authorize.net using the SIM method.
For API documentation or additional sample code, please visit:
http://developer.authorize.net

Most of this page below (and including) this comment can be modified using any
standard html. The parts of the page that cannot be modified are noted in the
comments.  This file can be renamed as long as the file extension remains .cfm
--->

<!--- the parameters for the payment can be configured here --->
<!--- the API Login ID and Transaction Key must be replaced with valid values..in Application --->
<cfswitch expression="#page#">
	<cfcase value="post_job">
		<cfset amount="#cost1#">
		<cfset description="#description1#">
		<cfset temp_url_str = "page=#page#">
		<cfif isdefined("jobID") and jobID is not ""><cfset temp_url_str = temp_url_str & "&jobID=#jobID#"></cfif>
		<cfif isdefined("expiration_date") and expiration_date is not ""><cfset temp_url_str = temp_url_str & "&expiration_date=#dateformat(expiration_date, "mm-dd-yyyy")#"></cfif>
		<cfset relay_url="http://www.paintbidtracker.com/classifieds/includes/jobs_relay-resp.cfm?#temp_url_str#">
		<!---cfset cust_id = #reg_userID#>
		<cfset po_num = #tempID#--->
	</cfcase>
	<cfcase value="edit_job">
		<cfset amount="#cost1#">
		<cfset description="#description1#">
		<cfset temp_url_str = "page=#page#">
		<cfif isdefined("jobID") and jobID is not ""><cfset temp_url_str = temp_url_str & "&jobID=#jobID#"></cfif>
		<cfif isdefined("expiration_date") and expiration_date is not ""><cfset temp_url_str = temp_url_str & "&expiration_date=#dateformat(expiration_date, "mm-dd-yyyy")#"></cfif>
		<cfset relay_url="http://www.paintbidtracker.com/classifieds/includes/jobs_relay-resp.cfm?#temp_url_str#">
		<!---cfset cust_id = #reg_userID#>
		<cfset po_num = #tempID#--->
	</cfcase>
</cfswitch>
<!---cfset testMode="true"--->
<cfset testMode="false">
<!--- By default, this sample code is designed to post to our test server for
developer accounts: https://test.authorize.net/gateway/transact.dll for real
accounts (even in test mode), please make sure that you are posting to:
https://secure.authorize.net/gateway/transact.dll --->
<!---cfset posturl="https://test.authorize.net/gateway/transact.dll"--->
<cfset posturl="https://secure.authorize.net/gateway/transact.dll">

<!--- If an amount or description were posted to this page, the defaults are overidden --->
<!---cfif IsDefined("FORM.amount")>
  <cfset amount=FORM.amount>
</cfif>
<cfif IsDefined("FORM.description")>
  <cfset description=FORM.description>
</cfif>
<!--- also check to see if the amount or description were sent using the GET method --->
<cfif IsDefined("URL.amount")>
  <cfset amount=URL.amount>
</cfif>
<cfif IsDefined("URL.description")>
  <cfset description=URL.description>
</cfif--->

<!--- an invoice is generated using the date and time --->
<cfset invoice=DateFormat(Now(),"yyyymmdd") & TimeFormat(Now(),"HHmmss")>

<!--- a sequence number is randomly generated --->
<cfset sequence=RandRange(1, 1000)>

<!--- a timestamp is generated --->
<cfset timestamp=DateDiff("s", "January 1 1970 00:00", DateConvert('local2UTC', Now())) >
<cfscript>
	tz=createObject("component","timeZone");
	today=createodbcdatetime(now());
	timeZones=tz.getAvailableTZ();
	inDST=tz.isDST(today);
</cfscript>
<cfif inDST is 'YES'>
	<cfset timestamp = timestamp+18000>
<cfelse>
	<cfset timestamp = timestamp+14400>
</cfif>

<!--- The following lines generate the SIM fingerprint --->
<cf_hmac data="#loginID#^#sequence#^#timestamp#^#amount#^" key="#transactionKey#">
<cfset fingerprint=#digest#>


<cfoutput>

<!--- Create the HTML form containing necessary SIM post values --->
<FORM name="form1" method="post" action="#posturl#" >
<!--- Additional fields can be added here as outlined in the SIM integration
guide at http://developer.authorize.net --->
	<INPUT type="hidden" name="x_login" value="#loginID#">
	<INPUT type="hidden" name="x_amount" value="#amount#">
	<cfif isdefined("company")><INPUT type="hidden" name="x_company" value="#company#"></cfif>
	<INPUT type="hidden" name="x_description" value="#description#">
	<INPUT type="hidden" name="x_fp_sequence" value="#sequence#">
	<INPUT type="hidden" name="x_fp_timestamp" value="#timeStamp#">
	<INPUT type="hidden" name="x_fp_hash" value="#fingerprint#">
	<INPUT type="hidden" name="x_test_request" value="#testMode#">
	<INPUT type="hidden" name="x_show_form" value="PAYMENT_FORM">
	<!---INPUT type="hidden" name="x_receipt_link_method" value="POST">
	<INPUT type="hidden" name="x_receipt_link_text" value="CLICK TO COMPLETE TRANSACTION">
	<INPUT type="hidden" name="x_receipt_link_url" value="#receipt_url#"--->
	<INPUT type="hidden" name="x_relay_response" value="TRUE">
	<INPUT type="hidden" name="x_relay_URL" value="#relay_url#">
	<INPUT type="hidden" name="x_version" value="3.1">
	<cfif isdefined("cust_ID")><INPUT type="hidden" name="x_cust_id" value="#cust_id#"></cfif>
	<cfif isdefined("po_num")><INPUT type="hidden" name="x_po_num" value="#po_num#"></cfif>
	<cfif isdefined("invoice")><INPUT type="hidden" name="x_invoice_num" value="#invoice#"></cfif>
</FORM>
<!-- This is the end of the code generating the "submit payment" button.    -->
<!---Script to submit the form--->
<script> 
document.form1.submit(); 
</script> 
</BODY>
</HTML>
<!-- The last line is a necessary part of the coldfusion script -->
</cfoutput>