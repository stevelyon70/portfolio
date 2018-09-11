<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<cfquery name="job_pricing" datasource="#the_dsn#">
	select basic, enhanced, basic_duration, enhanced_duration
	from classified_pricing
	where class_type='jobs' and purchase_type='single'
</cfquery>
<cfset baseprice = #job_pricing.basic#><!---Set price to be paid by credit card--->
<cfset basefeatured_price = #job_pricing.enhanced#>
<cfset duration = #job_pricing.basic_duration#>
<cfset featured_duration = #job_pricing.enhanced_duration#>

<!---Insert the basic details if coming from form submission--->
<!---Process initial information--->
<cfif isdefined("process") and process is 1 and not isdefined("jobID")>
	<cfset date=#createodbcdatetime(now())#>
	<cftransaction>
		<!---Define form date selection--->
		<cfif isdefined("startmonth") and startmonth is not 0 and isdefined ("startday") and startday is not 0 and isdefined ("startyear") and startyear is not 0>
			<cfset effective_date = '#startmonth#/#startday#/#startyear#'>
		<cfelse>
			<cfset effective_date = '#dateformat(date, 'm/d/yyyy')#'>
		</cfif>
		<cfif isdefined("endmonth") and endmonth is not 0 and isdefined ("endday") and endday is not 0 and isdefined ("endyear") and endyear is not 0>
			<cfset expiration_date = '#endmonth#/#endday#/#endyear#'>
		<cfelse>
			<cfset expiration_date = '#dateformat(date+duration, 'm/d/yyyy')#'>
		</cfif>
		<cfset temp_expiration_date = '#dateformat(date-1, 'm/d/yyyy')#'>
		<!---Save main profile--->
		<cfquery name="insert_item" datasource="#the_dsn#">
			insert into job_master
			(reg_userID, supplierID, displaycompany, positiontitle, dateposted, expire, lastupdated, positionID, location, stateID, countryID, payrate, jobstartdate, 
			description, featured_job, confidential, resumeemail, active)
			values
			(#reg_userID#, 
			<cfif isdefined("supplierID") and supplierID is not "">#supplierID#<cfelse>NULL</cfif>, 
			<cfif isdefined("companyname") and companyname is not "">'#companyname#'<cfelse>NULL</cfif>,
			<cfif isdefined("positiontitle") and positiontitle is not "">'#positiontitle#'<cfelse>NULL</cfif>,
			'#dateformat(effective_date, "m/d/yyyy")#', 
			'#dateformat(temp_expiration_date, "m/d/yyyy")#', 
			'#dateformat(date, "m/d/yyyy")#', 
			<cfif isdefined("positionID") and positionID is not "">#positionID#<cfelse>NULL</cfif>, 
			<cfif isdefined("location") and location is not "">'#location#'<cfelse>NULL</cfif>, 
			<cfif isdefined("stateID") and stateID is not "">#stateID#<cfelse>NULL</cfif>,
			<cfif isdefined("countryID") and countryID is not "">#countryID#<cfelse>NULL</cfif>,
			<cfif isdefined("payrate") and payrate is not "">'#payrate#'<cfelse>NULL</cfif>, 
			<cfif isdefined("jobstartdate") and jobstartdate is not "">'#jobstartdate#'<cfelse>NULL</cfif>, 
			<cfif isdefined("description") and description is not "">'#description#'<cfelse>NULL</cfif>, 
			'n',
			<cfif isdefined("confidential") and confidential is not "">#confidential#<cfelse>NULL</cfif>, 
			<cfif isdefined("resumeemail") and resumeemail is not "">'#resumeemail#'<cfelse>NULL</cfif>,
			'n')
		</cfquery>
		<cfquery name="get_jobID" datasource="#the_dsn#" maxrows="1">
			select jobID from job_master
			order by jobID desc
		</cfquery>	
		<cfset jobID = #get_jobID.jobID#>
		<!---Tag relevant site--->
		<cfquery name="insert_category_tags" datasource="#the_dsn#">
			insert into tags_log (tagID, contentID, content_typeID) 
			values (52,#jobID#,1329)
		</cfquery>
		<cfquery name="insert_category_tags" datasource="#the_dsn#">
			insert into tags_log (tagID, contentID, content_typeID) 
			values (1597,#jobID#,1329)
		</cfquery>
		<cfquery name="insert_category_tags" datasource="#the_dsn#">
			insert into tags_log (tagID, contentID, content_typeID) 
			values (50,#jobID#,1329)
		</cfquery>
		<cfif isdefined("featbypass")>
			<cfset nextstep = "preview">
		<cfelse>
			<cfset nextstep = "featured_upgrade">
		</cfif>
	</cftransaction>
<!---Process edits/updates after preview--->
<cfelseif isdefined("process") and process is 1 and isdefined("form.jobID") and not isdefined("noprocess")>
	<cftransaction action="begin">
		<cfset date=#createodbcdatetime(now())#>
		<!---Define form date selection--->
			<cfif isdefined("startmonth") and startmonth is not 0 and isdefined ("startday") and startday is not 0 and isdefined ("startyear") and startyear is not 0>
				<cfset effective_date = '#startmonth#/#startday#/#startyear#'>
			<cfelse>
				<cfset effective_date = '#dateformat(date, 'm/d/yyyy')#'>
			</cfif>
			<cfif isdefined("endmonth") and endmonth is not 0 and isdefined ("endday") and endday is not 0 and isdefined ("endyear") and endyear is not 0>
				<cfset expiration_date = '#endmonth#/#endday#/#endyear#'>
			<cfelse>
				<cfset expiration_date = '#dateformat(date+duration, 'm/d/yyyy')#'>
			</cfif>
			<cfset temp_expiration_date = '#dateformat(date-1, 'm/d/yyyy')#'>
			<cfif isdefined("featured_job") and featured_job is "y">
				<cfif isdefined("startmonth_f") and startmonth_f is not 0 and isdefined ("startday_f") and startday_f is not 0 and isdefined ("startyear_f") and startyear_f is not 0>
					<cfset effective_date_f = '#startmonth_f#/#startday_f#/#startyear_f#'>
				</cfif>
				<cfif isdefined("endmonth_f") and endmonth_f is not 0 and isdefined ("endday_f") and endday_f is not 0 and isdefined ("endyear_f") and endyear_f is not 0>
					<cfset expiration_date_f = '#endmonth_f#/#endday_f#/#endyear_f#'>
				</cfif>
			</cfif>
			<cfif isdefined("form.feat_logo") and form.feat_logo is not "">
				<cffile action="upload" filefield="form.feat_logo" destination="d:\wwwroot\paintsquare.com\classifieds\featuredjob_images" nameconflict="makeunique">
				<CFSET NEWFILE2 = #file.SERVERFILE#>
				<cffile action="READ" file="d:\wwwroot\paintsquare.com\classifieds\featuredjob_images\#file.SERVERFILE#" variable="#file.ClientFileExt#">
				<cfoutput>
				<cfset ext = file.ClientFileExt>
				</cfoutput>
				<CFFILE ACTION="RENAME" source="#file.SERVERDIRECTORY#\#file.SERVERFILE#" DESTINATION="#file.SERVERDIRECTORY#\#NEWFILE2#">
			</cfif>
		<!---Save the item info--->
			<cfquery name="update_item" datasource="#the_dsn#">
				update job_master set
					reg_userID=<cfif isdefined("reg_userID") and reg_userID is not "">#reg_userID#<cfelse>NULL</cfif>,
					supplierID=<cfif isdefined("supplierID") and supplierID is not "">#supplierID#<cfelse>NULL</cfif>,
					displaycompany=<cfif isdefined("companyname") and companyname is not "">'#companyname#'<cfelse>NULL</cfif>,
					positiontitle=<cfif isdefined("positiontitle") and positiontitle is not "">'#positiontitle#'<cfelse>NULL</cfif>,
					dateposted='#dateformat(effective_date, "m/d/yyyy")#',
					expire='#dateformat(temp_expiration_date, "m/d/yyyy")#',
					lastupdated='#dateformat(date, "m/d/yyyy")#',
					positionID=<cfif isdefined("positionID") and positionID is not "">#positionID#<cfelse>NULL</cfif>,
					location=<cfif isdefined("location") and location is not "">'#location#'<cfelse>NULL</cfif>,
					stateID=<cfif isdefined("stateID") and stateID is not "">#stateID#<cfelse>NULL</cfif>,
					countryID=<cfif isdefined("countryID") and countryID is not "">#countryID#<cfelse>NULL</cfif>,
					payrate=<cfif isdefined("payrate") and payrate is not "">'#payrate#'<cfelse>NULL</cfif>, 
					jobstartdate=<cfif isdefined("jobstartdate") and jobstartdate is not "">'#jobstartdate#'<cfelse>NULL</cfif>, 
					description=<cfif isdefined("description") and description is not "">'#description#'<cfelse>NULL</cfif>, 
					<cfif isdefined("form.feat_logo") and form.feat_logo is not "">featuredjob_imagelocation='featuredjob_images/#newfile2#',</cfif> 
					confidential=<cfif isdefined("confidential") and confidential is not "">#confidential#<cfelse>NULL</cfif>, 
					resumeemail=<cfif isdefined("resumeemail") and resumeemail is not "">'#resumeemail#'<cfelse>NULL</cfif>
				where jobID = #jobID#
			</cfquery>
		<cfset nextstep = "preview">
	</cftransaction>

<!---Process featured job upgrade--->
<cfelseif isdefined("process") and process is 2>
	<cftransaction action="begin">
	<cfif isdefined("featured_job") and featured_job is "y">
		<cfif isdefined("startmonth_f") and startmonth_f is not 0 and isdefined ("startday_f") and startday_f is not 0 and isdefined ("startyear_f") and startyear_f is not 0>
			<cfset effective_date_f = '#startmonth_f#/#startday_f#/#startyear_f#'>
		</cfif>
		<cfif isdefined("endmonth_f") and endmonth_f is not 0 and isdefined ("endday_f") and endday_f is not 0 and isdefined ("endyear_f") and endyear_f is not 0>
			<cfset expiration_date_f = '#endmonth_f#/#endday_f#/#endyear_f#'>
		</cfif>
		<cfif form.feat_logo is not "">
			<cffile action="upload" filefield="form.feat_logo" destination="d:\wwwroot\paintsquare.com\classifieds\featuredjob_images" nameconflict="makeunique">
			<CFSET NEWFILE2 = #file.SERVERFILE#>
			<cffile action="READ" file="d:\wwwroot\paintsquare.com\classifieds\featuredjob_images\#file.SERVERFILE#" variable="#file.ClientFileExt#">
			<cfoutput>
			<cfset ext = file.ClientFileExt>
			</cfoutput>
			<CFFILE ACTION="RENAME" source="#file.SERVERDIRECTORY#\#file.SERVERFILE#" DESTINATION="#file.SERVERDIRECTORY#\#NEWFILE2#">
		</cfif>
		<cfset price = price+basefeatured_price>
		<!---Save the item info--->
		<cfquery name="update_item" datasource="#the_dsn#">
			update job_master set
				featured_job=<cfif isdefined("featured_job") and featured_job is not "">'#featured_job#'<cfelse>NULL</cfif>, 
					featuredjob_inception=<cfif isdefined("effective_date_f") and effective_date_f is not "">'#effective_date_f#'<cfelse>NULL</cfif>, 
					featuredjob_expiration=<cfif isdefined("expiration_date_f") and expiration_date_f is not "">'#expiration_date_f#'<cfelse>NULL</cfif>,
					<cfif form.feat_logo is not "">featuredjob_imagelocation='featuredjob_images/#newfile2#',</cfif> 
					featuredjob_contact=<cfif isdefined("featuredjob_contact") and featuredjob_contact is not "" and isdefined("featured_job") and featured_job is "y">'#featuredjob_contact#'<cfelse>NULL</cfif>
			where jobID = #jobID#
		</cfquery>
	</cfif>
	<cfset nextstep = "preview">
	</cftransaction>


<!---Process redirect to payment--->
<cfelseif isdefined("process") and process is 3>
	
	<cflocation url="http://www.paintbidtracker.com/classifieds/includes/jobs_process.cfm?page=post_job&jobID=#jobID#&expiration_date=#expiration_date#">
	
<!---Process after preview approval (and, if necessary, payment)--->
<cfelseif isdefined("process") and process is 4 and isdefined("jobID")>
	<cfset date=#createodbcdatetime(now())#>
	<cftransaction>
		<cfif not isdefined("expiration_date")><cfset expiration_date = '#dateformat(date+duration, 'm/d/yyyy')#'></cfif>
		<cfquery name="update_item" datasource="#the_dsn#">
			update job_master
			set expire = '#expiration_date#', active='y'
			where jobID = #jobID#
		</cfquery>
		<cfquery name="get_item" datasource="#the_dsn#">
			select a.*, b.position, c.companyname, d.state, e.country, f.companyname as regconame
			from job_master a 
			left outer join position b on b.positionID = a.positionID
			left outer join supplier_master c on c.supplierID = a.supplierID
			left outer join state_master d on d.stateID = a.stateID
			left outer join country_master e on e.countryID = a.countryID
			left outer join reg_users f on f.reg_userID = a.reg_userID
			where a.jobID = #jobID#
		</cfquery>
		<cfquery name="check_free" datasource="#the_dsn#">
			select * from freeposter
			where ID in (select freeposterID from freeposter_log where siteID=3)
			and (expiration > '#dateformat(date-1, 'm/d/yyyy')#'  or (totalpost is not null and totalpost > 0))
			and (supplierID in (select supplierID from reg_users where reg_userID = #get_item.reg_userID#) or reg_userID = #get_item.reg_userID#)
		</cfquery>
		<cfif check_free.totalpost gt 0>
			<cfquery name="update_totpost" datasource="#the_dsn#">
				update freeposter 
				set totalpost = #check_free.totalpost#-1 
				where ID=#check_free.ID#
			</cfquery>
		</cfif>
		<cfquery name="check_res_access" datasource="#the_dsn#">
			select *
			from resume_access
			where reg_userID = #get_item.reg_userID# 
		</cfquery>
		<cfif check_res_access.recordcount is not 0 and expiration_date gt "#check_res_access.expirationdate#">
			<cfquery name="update_res" datasource="#the_dsn#">
				update resume_access 
				set expirationdate = '#expiration_date#', viewresume = '1'
				where reg_userID = #get_item.reg_userID#
			</cfquery>
		<cfelseif check_res_access.recordcount is 0>
			<cfquery name="insertresaccess" datasource="#the_dsn#">
				insert into resume_access
				(reg_userID, inceptiondate, expirationdate, viewresume)
				values
				(#get_item.reg_userID#, '#dateformat(date, "m/d/yyyy")#', '#expiration_date#', '1')
			</cfquery>
		</cfif>
		<cfinclude template="jobs_payment_confirm_email.cfm">
	</cftransaction>
	<cflocation url="http://www.paintbidtracker.com/classifieds/?fuseaction=jobs&action=post&confirm=1&jobID=#jobID#">
	<!---Manual continue to test e-mail--->
	<!---cfoutput><a href="#rootpath#classifieds/?fuseaction=jobs&action=post&confirm=1&jobID=#jobID#">Continue...</a></cfoutput--->
</cfif>

<cfif isdefined("jobID")>
	<cfquery name="get_item" datasource="#the_dsn#">
		select a.*, b.position, c.companyname, d.state, e.country, f.companyname as regconame
		from job_master a 
		left outer join position b on b.positionID = a.positionID
		left outer join supplier_master c on c.supplierID = a.supplierID
		left outer join state_master d on d.stateID = a.stateID
		left outer join country_master e on e.countryID = a.countryID
		left outer join reg_users f on f.reg_userID = a.reg_userID
		where a.jobID = #jobID#
	</cfquery>
	<cfset reg_userID = #get_item.reg_userID#>
	<cfquery name="get_reguser" datasource="#the_dsn#">
		select a.firstname, a.lastname, a.companyname, a.billingaddress,
		a.city, a.stateID, a.postalcode, a.countryID, a.emailaddress, b.state, c.country,
		a.phonenumber, a.faxnumber, a.supplierID
		from reg_users a
		left outer join state_master b on b.stateID = a.stateID
		left outer join country_master c on c.countryID = a.countryID
		where a.reg_userID = #reg_userID#
	</cfquery>
<cfelse>
	<cfif not isdefined("reg_userID") and isdefined("cookie.psquare") and cookie.psquare is not ""><cfset reg_userID = cookie.psquare></cfif>
	<cfif isdefined("reg_userID") and reg_userID is not "">
	<cfquery name="get_reguser" datasource="#the_dsn#">
		select a.firstname, a.lastname, a.companyname, a.billingaddress,
		a.city, a.stateID, a.postalcode, a.countryID, a.emailaddress, b.state, c.country,
		a.phonenumber, a.faxnumber, a.supplierID
		from reg_users a
		left outer join state_master b on b.stateID = a.stateID
		left outer join country_master c on c.countryID = a.countryID
		where a.reg_userID = <cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer">
	</cfquery>
	</cfif>
</cfif>



<cfoutput>
<cfinclude template="classifieds_header.cfm">
               
<table border="0" cellpadding="5" cellspacing="0" width="100%">
	<tr>
		<td valign="top" width="100%">
             <table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td width="50%">
									<h1>Post A Job</h1>
								</td>
								<!---td width="50%" align="right">
									<a href="#rootpath#classifieds/?fuseaction=jobs&action=viewall">View All Jobs</a> |
									<a href="#rootpath#classifieds/?fuseaction=jobs&action=search">Search Jobs</a> |
									<a href="#rootpath#classifieds/?fuseaction=jobs&action=post">Post a Job</a>
								</td--->
							</tr>
						</table>
						<hr class="PBTsmall" noshade>
					</td>
				</tr>
				
				<cfif not isdefined("cookie.psquare") and not isdefined("reg_userID")>
				<!---Require login--->
					<tr>
						<td width="100%">
							<div align="left">
								<p>To post a job, <a href="#rootpath#register/?fuseaction=login&r_directory=classifieds&r_fuseaction=#fuseaction#&r_action=#action#">please sign in</a> to your free Paint BidTracker account.</p> 
								<p>If you don't yet have a free Paint BidTracker account, please <a href="#rootpath#register/?fuseaction=signup&postjob=1">register</a>.</p>
							</div>                              
						</td>
					</tr>
				<cfelseif isdefined("confirm")>
				<!---Message to thank and confirm posting--->
					<tr>
						<td width="100%">
							<div align="left">
								<p>Thanks for choosing to post your job in the Paint BidTracker classifieds. Your listing has been successfully posted, 
								and can be seen by <a href="#rootpath#classifieds/?fuseaction=jobs&action=view&jobID=#jobID#">clicking here</a>.</p>
							</div>                              
						</td>
					</tr>
				<cfelseif isdefined("process") and process is 5>
				<!---Message of card error--->
					<tr>
						<td width="100%">
							<div align="left">
								<p>Your credit card was not able to be processed correctly. Please try again.</p>
							</div>                              
						</td>
					</tr>
				<cfelseif isdefined("nextstep") and nextstep is "featured_upgrade">
				<!---Form for upgrading to featured posting--->
					<!---cfquery name="getmax" datasource="#the_dsn#">
						select max(featuredjob_expiration) as expire
						from job_master
						where expire >= '#dateformat(date, "m/d/yyyy")#' 
						and featured_job = 'y' 
						and featuredjob_expiration >= '#dateformat(date, "m/d/yyyy")#'
					</cfquery--->
					<!---cfquery name="adcount" datasource="#the_dsn#">
						select *
						from job_master
						where featuredjob_expiration = '#dateformat(getmax.expire, "m/d/yyyy")#'
					</cfquery--->
					<!---cfif adcount.recordcount GTE 1 and adcount.recordcount LTE 3>
						<cfset inception = #dateformat(adcount.featuredjob_inception, "m/d/yyyy")#>
						<cfset expiration = #dateformat(adcount.featuredjob_expiration, "m/d/yyyy")#>
					<cfelseif adcount.recordcount GTE 4>
						<cfset inception = DateAdd("d", 1, "#getmax.expire#")>
						<cfset expiration = DateAdd("d", 10, "#inception#")>
					<cfelse--->
						<cfset inception = #dateformat(date, "m/d/yyyy")#>
						<cfset expiration = DateAdd("d", featured_duration, "#inception#")>
					<!---/cfif--->
					<tr>
						<td width="100%">
							<div align="left">
								<p>For an additional $#basefeatured_price#, you can get your listing to stand out with bold type and a company logo. The featured status
								would run for #featured_duration# days (from #inception# to #dateformat(expiration, 'm/d/yyyy')#).
								</p>
								<hr size="1" noshade>
							</div>                              
						</td>
					</tr>
					<tr>
						<td width="100%">
							<div align="left">
								<cfform action="#rootpath#classifieds/index.cfm?process=2" method="post" enctype="multipart/form-data">
								<table border="0" cellpadding="3" cellspacing="0" width="100%">
									<tr>
										<td align="right" valign="top">
											<font face="Arial" size="2"><b>Make Featured?*:</b></font>
										</td>
										<td valign="top">
											<cfselect name="featured_job" size="1">
												<option value="y" <cfif not isdefined("get_item") or (isdefined("get_item") and get_item.featured_job is "y")>selected</cfif>>Yes
												<option value="n" <cfif isdefined("get_item") and get_item.featured_job is not "y">selected</cfif>>No
											</cfselect>
										</td>
									</tr>
									<tr>
										<td align="right" valign="top" width="35%">
											<font face="Arial" size="2"><b>Featured Logo:</b></font>
										</td>
										<td valign="top" width="65%">
											<cfif get_item.featuredjob_imagelocation is not "">
												<cfif get_item.featuredjob_imagelocation is not "">
												<cfset max_width=115><cfset max_height=60>
												<cfobject type="JAVA" action="Create" name="tk" 
													class="java.awt.Toolkit">
												</cfobject>
												<cfobject type="JAVA" action="Create" name="img" 
													class="java.awt.Image">
												</cfobject>
												<cfscript>
													img = tk.getDefaultToolkit().getImage("d:\wwwroot\paintsquare.com\classifieds\#get_item.featuredjob_imagelocation#");
													width = img.getWidth();
													height = img.getHeight();
													img.flush();
												</cfscript>
												<cfset disp_width=#width#>
												<cfset disp_height=#height#>
												<cfif disp_width gt max_width><cfset disp_width="#max_width#"></cfif>
												<cfif disp_height gt max_height><cfset disp_height="#max_height#"></cfif>
												<img src="http://www.paintsquare.com/classifieds/#get_item.featuredjob_imagelocation#" width="#disp_width#" height="#disp_height#" alt="#get_item.positiontitle#"><br>
												<br><font face="Arial" size="2">Upload new image to replace:</font><br>
											</cfif>
											<br><font face="Arial" size="2">Upload new image to replace:</font><br></cfif>
											<cfinput type="file" name="feat_logo" size="40">
											<br><font face="Arial" size="2">(recommended 115 px wide x 60 px high; .gif or .jpg only)</font>
										</td>
									</tr>
									<tr>
										<td>&nbsp;
										<cfif isdefined("reg_userID")><cfinput type="hidden" name="reg_userID" value="#reg_userID#"></cfif>
										<cfif isdefined("price")><cfinput type="hidden" name="price" value="#price#"></cfif>
										<cfif isdefined("jobID")><cfinput type="hidden" name="jobID" value="#jobID#"></cfif>
										<cfif isdefined("fuseaction")><cfinput type="hidden" name="fuseaction" value="#fuseaction#"></cfif>
										<cfif isdefined("action")><cfinput type="hidden" name="action" value="#action#"></cfif>
										<!---cfinput type="hidden" name="featured_price" value="#featured_price#"--->
										<cfif isdefined("expiration_date")><cfinput type="hidden" name="expiration_date" value="#expiration_date#"></cfif>
										<cfinput type="hidden" name="effective_date_f" value="#dateformat(inception, 'm/d/yyyy')#">
										<cfinput type="hidden" name="expiration_date_f" value="#dateformat(expiration, 'm/d/yyyy')#">
										</td> 
										<td><cfinput name="submit" value="Submit" type="submit"><br><br></td>
									</tr>
								</table>
								</cfform>
							</div>                              
						</td>
					</tr>
				<cfelseif isdefined("nextstep") and nextstep is "preview">
				<!---Form to display preview and continue to payment/confirmation or go back to edit--->
					<tr>
						<td width="100%">
							<div align="left">
								<cfif price gt 0>
								<p>Below is a preview of your job posting. Please review carefully and click either the 'Approve and Purchase' button to continue,
								or the 'Make Changes' button to go edit your listing. You listing will only be confirmed once payment is completed.
								</p>
								<cfset process = 3>
								<cfset form_text = "Approve and Purchase">
								<cfelse>
								<p>Below is a preview of your job posting. Please review carefully and click either the 'Approve' button to confirm,
								or the 'Make Changes' button to go edit your listing. You listing will only be confirmed once the 'Approve' button is clicked.
								</p>
								<cfset process = 4>
								<cfset form_text = "Approve">
								</cfif>
								<hr size="1" noshade>
							</div>                              
						</td>
					</tr>
					<tr>
						<td width="100%">
							<div align="left">
								<table border="0" cellpadding="3" cellspacing="0" width="100%">
									<tr>
										<td width="25%" valign="top" align="right" class="bold">
											Company:
										</td>
										<td width="75%" valign="top" align="left"> 
											<cfif get_item.featured_job is "y" and get_item.featuredjob_imagelocation is not "">
												<cfset max_width=115><cfset max_height=60>
												<cfobject type="JAVA" action="Create" name="tk" 
													class="java.awt.Toolkit">
												</cfobject>
												<cfobject type="JAVA" action="Create" name="img" 
													class="java.awt.Image">
												</cfobject>
												<cfscript>
													img = tk.getDefaultToolkit().getImage("d:\wwwroot\paintsquare.com\classifieds\#get_item.featuredjob_imagelocation#");
													width = img.getWidth();
													height = img.getHeight();
													img.flush();
												</cfscript>
												<cfset disp_width=#width#>
												<cfset disp_height=#height#>
												<cfif disp_width gt max_width><cfset disp_width="#max_width#"></cfif>
												<cfif disp_height gt max_height><cfset disp_height="#max_height#"></cfif>
												<img src="http://www.paintsquare.com/classifieds/#get_item.featuredjob_imagelocation#" width="#disp_width#" height="#disp_height#" alt="#get_item.positiontitle#"><br>
											</cfif>
											<cfif get_item.confidential is 1>Confidential
											<cfelse><cfif get_item.displaycompany is not "">#get_item.displaycompany#<cfelseif get_item.supplierID is not "">#get_item.companyname#<cfelse>#get_item.regconame#</cfif>
											</cfif>
										</td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Location:</td>
										<td valign="top" align="left">#get_item.location# #get_item.state# #get_item.country#</td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">Posted:</td>
										<td valign="top" align="left">#dateformat(get_item.dateposted, "m/d/yyyy")#</td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">
											Salary:
										</td>
										<td valign="top" align="left">
											#get_item.payrate#
										</td>
									</tr>
									<tr>
										<td colspan="2" valign="top" align="left">
											<hr size="1" noshade>
											#get_item.description#
											<hr size="1" noshade>
										</td>
									</tr>
									<tr>
										<td valign="top" colspan="2">
											<br><br>
										</td>
									</tr>
									<tr>
										<td>&nbsp;
										</td> 
										<td>
											<cfform action="#rootpath#classifieds/index.cfm?process=#process#" method="post" enctype="multipart/form-data">
												<cfif isdefined("reg_userID")><cfinput type="hidden" name="reg_userID" value="#reg_userID#"></cfif>
												<cfif isdefined("price")><cfinput type="hidden" name="price" value="#price#"></cfif>
												<cfif isdefined("jobID")><cfinput type="hidden" name="jobID" value="#jobID#"></cfif>
												<cfif isdefined("fuseaction")><cfinput type="hidden" name="fuseaction" value="#fuseaction#"></cfif>
												<cfif isdefined("action")><cfinput type="hidden" name="action" value="#action#"></cfif>
												<cfif isdefined("expiration_date")><cfinput type="hidden" name="expiration_date" value="#expiration_date#"></cfif>
												<cfinput name="submit" value="#form_text#" type="submit">
											</cfform>
											&nbsp;&nbsp;&nbsp;&nbsp;
											<cfform action="#rootpath#classifieds/index.cfm?process=1" method="post" enctype="multipart/form-data">
												<cfif isdefined("reg_userID")><cfinput type="hidden" name="reg_userID" value="#reg_userID#"></cfif>
												<cfif isdefined("price")><cfinput type="hidden" name="price" value="#price#"></cfif>
												<cfif isdefined("jobID")><cfinput type="hidden" name="jobID" value="#jobID#"></cfif>
												<cfif isdefined("fuseaction")><cfinput type="hidden" name="fuseaction" value="#fuseaction#"></cfif>
												<cfif isdefined("action")><cfinput type="hidden" name="action" value="#action#"></cfif>
												<cfif isdefined("expiration_date")><cfinput type="hidden" name="expiration_date" value="#expiration_date#"></cfif>
												<cfinput type="hidden" name="noprocess" value="1">
												<cfinput type="hidden" name="featbypass" value="1">
												<cfinput name="submit" value="Make Changes" type="submit">
											</cfform>
										<br><br>
										</td>
									</tr>
								</table>
								
							</div>                              
						</td>
					</tr>
				<cfelse>
				<!---Form for basic listing and/or editing of listing after preview--->
					<!---Check for free poster--->
					<cfif not isdefined("reg_userID")><cfset reg_userID = cookie.psquare></cfif>
					<cfquery name="free_poster" datasource="#the_dsn#">
						select a.ID as freeposterID, a.reg_userID, a.supplierID, a.expiration, a.totalpost 
						from freeposter a
						where a.ID in (select freeposterID from freeposter_log where siteID=3)
						and (a.expiration > '#dateformat(date-1, 'm/d/yyyy')#'  or (a.totalpost is not null and a.totalpost > 0))
						and (a.supplierID in (select supplierID from reg_users where reg_userID = <cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer">) or a.reg_userID = <cfqueryparam value="#reg_userID#" cfsqltype="cf_sql_integer">)
					</cfquery>
					<cfif not isdefined("featbypass")>
						<cfif free_poster.recordcount gt 0>
							<cfset price = 0><!---Free post--->
						<cfelse>
							<cfquery name="get_reguser" datasource="#the_dsn#">
								select a.firstname, a.lastname, a.companyname, a.billingaddress,
								a.city, a.stateID, a.postalcode, a.countryID, a.emailaddress, b.state, c.country,
								a.phonenumber, a.faxnumber, a.supplierID
								from reg_users a
								left outer join state_master b on b.stateID = a.stateID
								left outer join country_master c on c.countryID = a.countryID
								where a.reg_userID = #reg_userID#
							</cfquery>
							<cfset price = baseprice><!---Paid post--->
						</cfif>
					</cfif>
					<tr>
						<td width="100%">
							<div align="left">
								<cfif price gt 0 and not isdefined("featbypass")>
								<p>Job postings cost $#baseprice# for #duration# days and must be paid online. After submitting and reviewing the information
								you enter into the form below, you will be redirected for secure third-party payment by credit card. For other payment options, 
								<a href="mailto:lmacek@protectivecoatings.com?subject=Payment Options for Job Posting on Paint BidTracker">contact us</a> or call 1-800-837-8303 or 1-412-431-8300.
								</p>
								<cfelseif not isdefined("featbypass")>
								<p>You and/or your company are entitled to free postings. To add a free basic listing, enter the details into the form below.
								You may choose to upgrade to a featured listing for a fee on the next screen.</p> 
								<cfelse>
								<p>Please make any changes to your posting using the form below.</p> 
								</cfif>
								<hr size="1" noshade>
							</div>                              
						</td>
					</tr>
					<tr>
						<td width="100%">
							<div align="left">
								<cfform action="#rootpath#classifieds/index.cfm?process=1" method="post" enctype="multipart/form-data">
								<table border="0" cellpadding="3" cellspacing="0" width="100%">
									<tr>
										<td align="right" valign="top" width="25%">
											<font face="Arial" size="2"><b>Position*:</b></font>
										</td>
										<td valign="top" width="75%">
											<cfif isdefined("get_item")>
												<cfinput name="positiontitle" type="text" value="#get_item.positiontitle#" size="60" required message="Please enter a position headline for the posting.">
											<cfelse>
												<cfinput name="positiontitle" type="text" size="60" required message="Please enter a position headline for the posting.">
											</cfif>
										</td>
									</tr>
									<cfset date = #createodbcdatetime(now())#>
									<cfif isdefined("get_item")>
										<cfset startpost = '#get_item.dateposted#'>
										<cfif isdefined("expiration_date")>
											<cfset endpost = '#expiration_date#'>
										<cfelse>
											<cfset endpost = '#get_item.expire#'>
										</cfif>
									<cfelse>
										<cfset startpost = '#dateformat(date)#'>
										<cfset endpost = '#dateformat(date+duration)#'>
									</cfif>
									<cfquery name="get_category" datasource="#the_dsn#">
										select positionID, position from position
										order by sort
									</cfquery>
									<tr>
										<td align="right" valign="top">
											<font face="Arial" size="2"><b>Category*:</b></font>
										</td>
										<td valign="top">
											<cfselect name="positionID" size="1" required message="Please select a category.">
												<cfloop query="get_category">
													<option value="#positionID#" <cfif isdefined("get_item") and positionID is #get_item.positionID#>selected</cfif>>#position#
												</cfloop>
											</cfselect>
										</td>
									</tr>
									<tr>
										<td align="right" valign="top" width="25%">
											<font face="Arial" size="2"><b>Company Name:</b></font>
										</td>
										<td valign="top" width="75%">
											<cfif isdefined("get_item")>
												<cfinput name="companyname" type="text" value="#get_item.companyname#" size="60">
											<cfelse>
												<cfinput name="companyname" type="text" value="#get_reguser.companyname#" size="60">
											</cfif>
										</td>
									</tr>
									<tr>
										<td align="right" valign="top">
											<font face="Arial" size="2"><b>Company Name Confidential?*:</b></font>
										</td>
										<td valign="top">
											<cfselect name="confidential" size="1" required message="Please select a confidential option.">
												<option value="1" <cfif isdefined("get_item") and get_item.confidential is 1>selected</cfif>>Yes
												<option value="2" <cfif not isdefined("get_item") or (isdefined("get_item") and get_item.confidential is not 1)>selected</cfif>>No
											</cfselect>
										</td>
									</tr>
									<tr>
										<td align="right" valign="top" width="35%">
											<font face="Arial" size="2"><b>E-mail for Applications:</b></font>
										</td>
										<td valign="top" width="65%">
											<cfif isdefined("get_item")>
												<cfinput name="resumeemail" type="text" value="#get_item.resumeemail#" size="60">
											<cfelse>
												<cfinput name="resumeemail" type="text" value="#get_reguser.emailaddress#" size="60">
											</cfif>
											<br>(E-mail address is not displayed nor able to seen by job seekers.)
										</td>
									</tr>
									<cfquery name="get_states" datasource="#the_dsn#">
										select stateID, stateabb from state_master
										order by sort
									</cfquery>
									<cfquery name="get_countries" datasource="#the_dsn#">
										select countryID, country from country_master
										order by sort
									</cfquery>
									<tr>
										<td align="right" valign="top">
											<font face="Arial" size="2"><b>Location:</b></font>
										</td>
										<td valign="top">
											<font face="Arial" size="2">City: 
											<cfif isdefined("get_item")>
												<cfinput name="location" type="text" value="#get_item.location#" size="55">
											<cfelse>
												<cfinput name="location" type="text" size="55">
											</cfif>
											<br>State:
											<cfselect name="stateID" size="1">
												<option value="0">
												<cfloop query="get_states">
													<option value="#stateID#" <cfif isdefined("get_item") and stateID is #get_item.stateID#>selected</cfif>>#stateabb#
												</cfloop>
											</cfselect>
											Country:
											<cfselect name="countryID" size="1">
												<option value="0">
												<cfloop query="get_countries">
													<option value="#countryID#" <cfif isdefined("get_item") and countryID is #get_item.countryID#>selected</cfif>>#country#
												</cfloop>
											</cfselect>
											</font>
										</td>
									</tr>
									<tr>
										<td align="right" valign="top">
											<font face="Arial" size="2"><b>Salary Range:</b></font>
										</td>
										<td valign="top">
											<cfif isdefined("get_item")>
												<cfinput name="payrate" type="text" value="#get_item.payrate#" size="60">
											<cfelse>
												<cfinput name="payrate" type="text" size="60">
											</cfif>
										</td>
									</tr>
									<tr>
										<td align="right" valign="top">
											<font face="Arial" size="2"><b>Job Start Date:</b></font>
										</td>
										<td valign="top" width="65%">
											<cfif isdefined("get_item")>
												<cfinput name="jobstartdate" type="text" value="#get_item.jobstartdate#" size="60">
											<cfelse>
												<cfinput name="jobstartdate" type="text" size="60">
											</cfif>
										</td>
									</tr>
									<tr>
										<td valign="top" align="right" class="bold">
											Job Description:
										</td>
										<td valign="top" align="left"> 
											<textarea id="job_description" name="description"><cfif isdefined("get_item")>#get_item.description#</cfif></textarea>
											<script language="JavaScript">
											generate_wysiwyg('job_description');
											</script>
										</td>
									</tr>
									<cfif isdefined("get_item") and get_item.featured_job is "y">
										<tr>
											<td align="right" valign="top">
												<font face="Arial" size="2"><b>Featured Job:</b></font>
											</td>
											<td valign="top">
												To be featured from #dateformat(get_item.featuredjob_inception, 'm/d/yyyy')# to #dateformat(get_item.featuredjob_expiration, 'm/d/yyyy')#
											</td>
										</tr>
										<tr>
											<td align="right" valign="top" width="35%">
												<font face="Arial" size="2"><b>Featured Logo:</b></font>
											</td>
											<td valign="top" width="65%">
												<cfif get_item.featuredjob_imagelocation is not "">
												<cfset max_width=115><cfset max_height=60>
												<cfobject type="JAVA" action="Create" name="tk" 
													class="java.awt.Toolkit">
												</cfobject>
												<cfobject type="JAVA" action="Create" name="img" 
													class="java.awt.Image">
												</cfobject>
												<cfscript>
													img = tk.getDefaultToolkit().getImage("d:\wwwroot\paintsquare.com\classifieds\#get_item.featuredjob_imagelocation#");
													width = img.getWidth();
													height = img.getHeight();
													img.flush();
												</cfscript>
												<cfset disp_width=#width#>
												<cfset disp_height=#height#>
												<cfif disp_width gt max_width><cfset disp_width="#max_width#"></cfif>
												<cfif disp_height gt max_height><cfset disp_height="#max_height#"></cfif>
												<img src="http://www.paintsquare.com/classifieds/#get_item.featuredjob_imagelocation#" width="#disp_width#" height="#disp_height#" alt="#get_item.positiontitle#"><br>
												<br><font face="Arial" size="2">Upload new image to replace:</font><br></cfif>
												<cfinput type="file" name="feat_logo" size="40">
												<br><font face="Arial" size="2">(recommended 115 px wide x 60 px high; .gif or .jpg only)</font>
											</td>
										</tr>
									</cfif>
									<tr>
										<td>&nbsp;
										<cfif isdefined("reg_userID")><cfinput type="hidden" name="reg_userID" value="#reg_userID#"></cfif>
										<cfif isdefined("price")><cfinput type="hidden" name="price" value="#price#"></cfif>
										<cfif isdefined("duration")><cfinput type="hidden" name="duration" value="#duration#"></cfif>
										<cfif isdefined("jobID")><cfinput type="hidden" name="jobID" value="#jobID#"></cfif>
										<cfif isdefined("fuseaction")><cfinput type="hidden" name="fuseaction" value="#fuseaction#"></cfif>
										<cfif isdefined("action")><cfinput type="hidden" name="action" value="#action#"></cfif>
										<cfif isdefined("expiration_date")><cfinput type="hidden" name="expiration_date" value="#expiration_date#"></cfif>
										<cfinput type="hidden" name="supplierID" value="#get_reguser.supplierID#">
										<cfif isdefined("featbypass")><cfinput type="hidden" name="featbypass" value="1"></cfif>
										</td> 
										<td><cfinput name="submit" value="Submit" type="submit"><br><br></td>
									</tr>
								</table>
								</cfform>
							</div>                              
						</td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>
</table>
</cfoutput>