<cftry>

<cfif isDefined("url.reset")>
	<cfquery datasource="#application.dataSource#">
		delete
		FROM pbt_user_email_pref
		where userID = <cfqueryparam value="#session.auth.userid#" cfsqltype="cf_sql_integer">
		and siteid = <cfqueryPARAM value = "#session.auth.siteID#" CFSQLType = "CF_SQL_INTEGER">
	</cfquery>	
	<cfquery datasource="#application.dataSource#">
		delete
		FROM pbt_user_email_tag
		where userID = <cfqueryparam value="#session.auth.userid#" cfsqltype="cf_sql_integer">
		and siteid = <cfqueryPARAM value = "#session.auth.siteID#" CFSQLType = "CF_SQL_INTEGER">
	</cfquery>	
		<cflog application="yes" file="wbt_emailPrefs" type="Information" text="User Reset Defaults #session.auth.userid#" />
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
		<cflog application="yes" file="wbt_emailPrefs" type="Information" text="User Prefs Update: Email #eml# #userid#" />
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
<cfparam name="form.structures" default="10000"/>
<cfparam name="form.emails" default="0"/>
<cfparam name="form.savedSrchEmail" default="0"/>
<cfparam name="form.tags" default=""/>

<cftransaction action="BEGIN">
<cfquery datasource="#application.dataSource#">
	delete
	FROM pbt_user_email_pref
	where userID= 	<cfqueryPARAM value = "#url.userid#" CFSQLType = "CF_SQL_INTEGER">
	and siteid = <cfqueryPARAM value = "#session.auth.siteID#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>	
<cfquery datasource="#application.dataSource#">
	insert into	pbt_user_email_pref
	(userid, dailyUpdates,getSavedSearchEmail,stages,projectTypes,sendInterval,updatedOn,budget,states,siteid)
	values
	(<cfqueryPARAM value = "#url.userid#" CFSQLType = "CF_SQL_INTEGER">, '#form.emails#','#form.savedSrchEmail#','#form.project_stage#','#form.projecttype#',1,<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,'#form.amount#','#form.state#',<cfqueryPARAM value = "#session.auth.siteID#" CFSQLType = "CF_SQL_INTEGER">)<!---'#datetimeformat(now(), "yyyy-mm-dd HH:mm:ss")#'--->	
</cfquery>	
</cftransaction>

<cftransaction action="BEGIN">
<cfquery datasource="#application.dataSource#">
	delete
	FROM pbt_user_email_tag
	where userID= 	<cfqueryPARAM value = "#url.userid#" CFSQLType = "CF_SQL_INTEGER">
	and siteid = <cfqueryPARAM value = "#session.auth.siteID#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>	
<cfset form.tags = listappend(form.tags,form.structures)>
	<cfloop list="#form.tags#" index="_t">
		<cfquery  datasource="#application.dataSource#">
			INSERT INTO pbt_user_email_tag
			(userID, tagID, active, enteredOn,siteid)
			values
			(#url.userID#, #_t#, 1, <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,<cfqueryPARAM value = "#session.auth.siteID#" CFSQLType = "CF_SQL_INTEGER">)
		</cfquery>	
	</cfloop>

</cftransaction>
	<cflog application="yes" file="wbt_emailPrefs" type="Information" text="User Prefs Update: Settings #userid#" />
<cfcatch><cfdump var="#cfcatch#" label="client" /><cfabort /></cfcatch></cftry>

<cflocation url="#form.redir#" addtoken="false" />