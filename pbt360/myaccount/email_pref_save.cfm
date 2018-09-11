<cftry>

<cfif isDefined("url.reset")>
	<cfquery datasource="#application.dataSource#">
		delete
		FROM pbt_user_email_pref
		where userID = <cfqueryparam value="#session.auth.userid#" cfsqltype="cf_sql_integer">
	</cfquery>	
	<cfquery datasource="#application.dataSource#">
		delete
		FROM pbt_user_email_tag
		where userID = <cfqueryparam value="#session.auth.userid#" cfsqltype="cf_sql_integer">
	</cfquery>	
	<cfabort>
</cfif>

<cfif isDefined("form.emails")>
	<cfset eml = 11>
	<cfif form.emails EQ "no"><cfset eml = 100></cfif>
	<cfquery name="updatebuser" datasource="#application.dataSource#">
		update bid_users
		set email = '#eml#'
		where userid = #userid#
	</cfquery>
</cfif>

	<cfquery name="updatebuser" datasource="#application.dataSource#">
		update reg_users
		set emailaddress = '#emailaddress#'
		where reg_userid = #form.reg_userid#
	</cfquery>
<!--- 
remove current from db

enter new tags

--->
<cfparam name="form.project_stage" default="2"/>
<cfparam name="form.projecttype" default="2"/>
<cfparam name="form.emails" default="0"/>
<cfparam name="form.savedSrchEmail" default="0"/>

<cftransaction action="BEGIN">
<cfquery datasource="#application.dataSource#">
	delete
	FROM pbt_user_email_pref
	where userID= 	<cfqueryPARAM value = "#url.userid#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>	
<cfquery datasource="#application.dataSource#">
	insert into	pbt_user_email_pref
	(userid, dailyUpdates,getSavedSearchEmail,stages,projectTypes,sendInterval,updatedOn,budget,states)
	values
	(<cfqueryPARAM value = "#url.userid#" CFSQLType = "CF_SQL_INTEGER">, '#form.emails#','#form.savedSrchEmail#','#form.project_stage#','#form.projecttype#',1,'#datetimeformat(now(), "yyyy-mm-dd HH:mm:ss")#','#form.amount#','#form.state#')	
</cfquery>	
</cftransaction>

<cftransaction action="BEGIN">
<cfquery datasource="#application.dataSource#">
	delete
	FROM pbt_user_email_tag
	where userID= 	<cfqueryPARAM value = "#url.userid#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>	
<cfif isDefined("form.tags")>
	<cfloop list="#form.tags#" index="_t">
		<cfquery  datasource="#application.dataSource#">
			INSERT INTO pbt_user_email_tag
			(userID, tagID, active, enteredOn)
			values
			(#url.userID#, #_t#, 1, '#dateformat(now(), 'yyyy-mm-dd')#')
		</cfquery>	
	</cfloop>
</cfif>
</cftransaction>
<cfdump var="#form#" label="form" />
<cfdump var="#cookie#" label="cookie" />
<cfdump var="#url#" label="url" />
<cfdump var="#variables#" label="vars" />
<cfdump var="#client#" label="client" />
<cfcatch><cfdump var="#cfcatch#" label="client" /><cfabort /></cfcatch></cftry>

<cflocation url="#form.redir#" addtoken="false" />