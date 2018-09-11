
<CFSET DATE = #CREATEODBCDATETIME(NOW())#>


<!---adding new folder and project--->
<cfif isdefined("form.process") and form.process is 21>

	<cftransaction action="begin">
		<cfquery name="insertfolder" datasource="#application.datasource#">
			insert into bid_user_project_folders
			(foldername,active,datecreated,userid,description,privacy_setting)
			values('#form.foldername#',1,#date#,#form.userid#,'#form.description#',#form.share#)
		</cfquery>

		<cfquery name="check" datasource="#application.datasource#">
			select max(folderid) as lastid
			from bid_user_project_folders
			where userid = #form.userid#
		</cfquery>

		<cfset uniqueid = #check.lastid#>	

		<cfif form.share is 3>
			<cfloop index="i" list="#form.specific_users#">
				<cfquery name="insert_users" datasource="#application.datasource#">
					insert into bid_user_privacy_log
					(folderid,userid)
					values(#uniqueid#,#i#)
				</cfquery>
			</cfloop>
		</cfif>

		<cfif isdefined("bidid") and bidid is not "">
		<cfloop list="#form.bidID#" index="i">
			<cfquery name="getprojectname" datasource="#application.datasource#">
				<!---select projectname from bid_edited_live where bidid = #form.bidid#--->
				select projectname from pbt_project_master where bidid = #i#
			</cfquery>
			<cfquery name="insert_bid" datasource="#application.datasource#">
				insert into bid_user_project_bids
				(bidid,folderid,userid,date_entered,projectname,active)
				values(#i#,#uniqueid#,#form.userid#,#date#,'#getprojectname.projectname#',1)
			</cfquery>
			<!---<cfquery name="grablast" datasource="#application.datasource#">
				select max(projectid) as lastprojectid
				from bid_user_project_bids
				where userid = #form.userid# and bidid = #form.bidid#
				</cfquery>
			<cfset projectid = #grablast.lastprojectid#>--->	
		</cfloop>
		</cfif>

	</cftransaction>

</cfif>