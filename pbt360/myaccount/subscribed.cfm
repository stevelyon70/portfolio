<cfsetting showDebugOutput="No">

<cfset date=createodbcdatetime(now())>

<cfquery name="check_status" datasource="#application.dataSource#">
	select a.ID, a.logID, b.listID, b.list_sourceID, a.statusID, d.status, e.name, a.date_processed
	from listman_status a
	inner join listman_contacts_log b on b.logID = a.logID
	inner join listman_contacts c on c.listID = b.listID
	left outer join listman_status_definer d on d.statusID = a.statusID
	left outer join listman_source e on e.list_sourceID = b.list_sourceID
	where b.list_sourceID = <cfqueryparam value="#list#" cfsqltype="cf_sql_varchar">
	<cfif isdefined("logID") and logID is not "">and a.logID = <cfqueryparam value="#logID#" cfsqltype="cf_sql_varchar"><cfelse>and 1=0</cfif>
	<cfif isdefined("listID") and listID is not "">and b.listID = <cfqueryparam value="#listID#" cfsqltype="cf_sql_varchar"><cfelse>and 1=0</cfif>
</cfquery>



<!---Subscribe/unsubscribe existing subscriber--->
<cfif isdefined("newstatus") and newstatus is not "" and check_status.recordcount gt 0 and newstatus is not #check_status.statusID#>
	<cfquery name="update_status" datasource="#application.dataSource#">
		update listman_status
		set statusID = <cfqueryparam value="#newstatus#" cfsqltype="cf_sql_integer">, ipaddress=<cfqueryparam value="#remote_addr#" cfsqltype="cf_sql_varchar">, date_processed = <cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">
		where logID = <cfqueryparam value="#logID#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfquery name="add_status_transaction" datasource="#application.dataSource#">
		insert into listman_status_log
		(ID, logID, statusID, date_processed, ipaddress, date_modified)
		values
		(<cfqueryparam value="#check_status.ID#" cfsqltype="cf_sql_integer">,
		<cfqueryparam value="#logID#" cfsqltype="cf_sql_integer">,
		<cfqueryparam value="#newstatus#" cfsqltype="cf_sql_integer">,
		<cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">,
		<cfqueryparam value="#remote_addr#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">
		)
	</cfquery>
	<cfquery name="check_status" datasource="#application.dataSource#">
		select a.ID, a.logID, b.listID, b.list_sourceID, a.statusID, d.status, e.name, a.date_processed
		from listman_status a
		inner join listman_contacts_log b on b.logID = a.logID
		inner join listman_contacts c on c.listID = b.listID
		left outer join listman_status_definer d on d.statusID = a.statusID
		left outer join listman_source e on e.list_sourceID = b.list_sourceID
		where b.list_sourceID = <cfqueryparam value="#list#" cfsqltype="cf_sql_varchar">
		and a.logID = <cfqueryparam value="#logID#" cfsqltype="cf_sql_varchar">
		and b.listID = <cfqueryparam value="#listID#" cfsqltype="cf_sql_varchar">
	</cfquery>
<!---Subscribe/unsubscribe new subscriber--->
<cfelseif isdefined("newstatus") and newstatus is not "" and check_status.recordcount is 0>
	<cftransaction action="begin">
		<cfquery name="get_user" datasource="#application.dataSource#">
			select *
			from reg_users
			where reg_userID = <cfqueryparam value="#cookie.psquare#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset email_var = #get_user.emailaddress#>
		<!---Check for existing in EMP--->
		<cfquery name="check_contacts" datasource="#application.dataSource#" maxrows="1">
			select distinct emailaddress, listID
			from listman_contacts
			where emailaddress = <cfqueryparam value="#email_var#" cfsqltype="cf_sql_varchar">
		</cfquery>	
		<!---If existing--->
		<cfif check_contacts.recordcount gt 0>
			<cfset listID = #check_contacts.listID#>
			<cfquery name="get_contact" datasource="#application.dataSource#">
				select * from listman_contacts
				where listID = <cfqueryparam value="#listID#" cfsqltype="cf_sql_integer">
			</cfquery>
		<!---If not existing, create and get listID for contact--->
		<cfelse>
			<cfquery name="add_contact" datasource="#application.dataSource#">
				insert into listman_contacts
				(emailaddress, firstname, lastname, jobtitle, companyname, address, city, stateID, postalcode, countryID, phonenumber, faxnumber)
				values
				(<cfif get_user.emailaddress is not ""><cfqueryparam value="#get_user.emailaddress#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
				<cfif get_user.firstname is not ""><cfqueryparam value="#get_user.firstname#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
				<cfif get_user.lastname is not ""><cfqueryparam value="#get_user.lastname#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
				<cfif get_user.title is not ""><cfqueryparam value="#get_user.title#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
				<cfif get_user.companyname is not ""><cfqueryparam value="#get_user.companyname#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
				<cfif get_user.billingaddress is not ""><cfqueryparam value="#get_user.billingaddress#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
				<cfif get_user.city is not ""><cfqueryparam value="#get_user.city#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
				<cfif get_user.stateID is not ""><cfqueryparam value="#get_user.stateID#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
				<cfif get_user.postalcode is not ""><cfqueryparam value="#get_user.postalcode#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
				<cfif get_user.countryID is not ""><cfqueryparam value="#get_user.countryID#" cfsqltype="cf_sql_integer"><cfelse>NULL</cfif>,
				<cfif get_user.phonenumber is not ""><cfqueryparam value="#get_user.phonenumber#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>,
				<cfif get_user.faxnumber is not ""><cfqueryparam value="#get_user.faxnumber#" cfsqltype="cf_sql_varchar"><cfelse>NULL</cfif>
				)
			</cfquery>
			<cfquery name="grab_listID" datasource="#application.dataSource#" maxrows="1">
				select max(listID) as listID
				from listman_contacts
				order by listID desc
			</cfquery>
			<cfset listID = #grab_listID.listID#>
		</cfif>		
		<!---Check existing list log entry for contact for listID/list_sourceID--->
		<cfquery name="check_list_log" datasource="#application.dataSource#">
			select logID 
			from listman_contacts_log
			where listID = <cfqueryparam value="#variables.listID#" cfsqltype="cf_sql_integer">
			and list_sourceID = <cfqueryparam value="#list#" cfsqltype="cf_sql_integer">
		</cfquery>
		<!---If existing, do nothing, otherwise, insert log entry--->
		<cfif check_list_log.recordcount gt 0 and check_list_log.logID is not "">
			<cfset logID = #check_list_log.logID#>
		<cfelse>
			<cfquery name="insert_list_log" datasource="#application.dataSource#">
				insert into listman_contacts_log
				(listID, list_sourceID, start_date)
				values
				(<cfqueryparam value="#listID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#list#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">
				)
			</cfquery>
			<cfquery name="get_logID" datasource="#application.dataSource#" maxrows="1">
				select max(logID) as logID
				from listman_contacts_log
				order by logID desc
			</cfquery>
			<cfset logID = #get_logID.logID#>
		</cfif>
		<cfquery name="check_status" datasource="#application.dataSource#">
			select logID, statusID, ID
			from listman_status
			where logID = <cfqueryparam value="#logID#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfif check_status.recordcount gt 0 and check_status.statusID is not "">
			<cfquery name="update_status" datasource="#application.dataSource#">
				update listman_status
				set statusID = <cfqueryparam value="#newstatus#" cfsqltype="cf_sql_integer">, ipaddress=<cfqueryparam value="#remote_addr#" cfsqltype="cf_sql_varchar">, date_processed = <cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">
				where logID = <cfqueryparam value="#logID#" cfsqltype="cf_sql_integer">
			</cfquery>
		<cfelse>
			<cfquery name="insert_status" datasource="#application.dataSource#">
				insert into listman_status
				(logID, statusID, date_processed, ipaddress)
				values
				(<cfqueryparam value="#logID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#newstatus#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#remote_addr#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
			<cfquery name="check_status" datasource="#application.dataSource#">
				select logID, statusID, ID
				from listman_status
				where logID = <cfqueryparam value="#logID#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		<cfquery name="add_status_transaction" datasource="#application.dataSource#">
			insert into listman_status_log
			(ID, logID, statusID, date_processed, ipaddress, date_modified)
			values
			(<cfqueryparam value="#check_status.ID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#logID#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#newstatus#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">,
			<cfqueryparam value="#remote_addr#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#date#" cfsqltype="cf_sql_timestamp">
			)
		</cfquery>
	</cftransaction>
	<!---Reload the page--->
	<!---cflocation url="#rootpath#register/?fuseaction=profile"--->
	<cfquery name="check_status" datasource="#application.dataSource#">
		select a.ID, a.logID, b.listID, b.list_sourceID, a.statusID, d.status, e.name, a.date_processed
		from listman_status a
		inner join listman_contacts_log b on b.logID = a.logID
		inner join listman_contacts c on c.listID = b.listID
		left outer join listman_status_definer d on d.statusID = a.statusID
		left outer join listman_source e on e.list_sourceID = b.list_sourceID
		where b.list_sourceID = <cfqueryparam value="#list#" cfsqltype="cf_sql_varchar">
		<cfif logID is not "">and a.logID = <cfqueryparam value="#logID#" cfsqltype="cf_sql_varchar"><cfelse>and 1=0</cfif>
		<cfif listID is not "">and b.listID = <cfqueryparam value="#listID#" cfsqltype="cf_sql_varchar"><cfelse>and 1=0</cfif>
	</cfquery>
</cfif>



<cfoutput>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<!---<link href="../assets/css/main.css" rel="stylesheet" type="text/css">--->
</head>
<cfif check_status.recordcount gt 0>
<p class="tinytext">
#check_status.status# on #dateformat(check_status.date_processed, 'mmm d, yyyy')#
</p>
<cfelse>
<p>Not yet subscribed</p>
</cfif>
</html>
</cfoutput>