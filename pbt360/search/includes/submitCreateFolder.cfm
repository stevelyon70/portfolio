

<cftransaction action="begin">
<CFSET DATE = #CREATEODBCDATETIME(NOW())#>	
	<cfif form.foldername EQ "">
	<cfabort showerror="Project Name is required.">
	</cfif>
	<cfquery name="getfoldername" datasource="#application.dataSource#">
		select foldername 
		from bid_user_project_folders 
		where userID = #form.userID# 
		and foldername = '#form.foldername#'
	</cfquery>
	<cfif getfoldername.recordcount GT 0>
	<cfabort showerror="Folder already exist. Please rename folder.">
	</cfif>
	
		<cfquery name="insertfolder" datasource="#application.dataSource#">
		insert into bid_user_project_folders
		(foldername,active,datecreated,userid,description,privacy_setting)
		values('#form.foldername#',1,#date#,#form.userid#,'#form.description#',#share#)
		</cfquery>
		<cfquery name="check" datasource="#application.dataSource#">
   		select max(folderid) as lastid
   		from bid_user_project_folders
   		where userid = #form.userid#
    	</cfquery>
		<cfset uniqueid = #check.lastid#>
		<cfif share is 3>
		<cfloop index="i" list="#specific_users#">
		<cfquery name="insert_users" datasource="#application.dataSource#">
		insert into bid_user_privacy_log
		(folderid,userid)
		values(#uniqueid#,#i#)
		</cfquery>
		</cfloop>
		</cfif>
		
	<cfif isdefined("form.bidid") and form.bidid is not "">
	<cfloop list="#form.bidID#" index="i">
		<cfquery name="getprojectname" datasource="#application.dataSource#">select projectname from pbt_project_master where bidid = #i#</cfquery>
		<cfquery name="insert_bid" datasource="#application.dataSource#">
		insert into bid_user_project_bids
		(bidid,folderid,userid,date_entered,projectname,active)
		values(#i#,#uniqueid#,#form.userid#,#date#,'#getprojectname.projectname#',1)
		</cfquery>
		<cfquery name="grablast" datasource="#application.dataSource#">
		   		select max(projectid) as lastprojectid
		   		from bid_user_project_bids
		   		where userid = #form.userid# and bidid = #i# and active = 1
		    	</cfquery>
			<cfset projectid = #grablast.lastprojectid#>	
	</cfloop>
	</cfif>
		
</cftransaction>
