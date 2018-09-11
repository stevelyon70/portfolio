<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!---
	live set to tday3 -32
	remove cfparam trackid
--->
<cfparam default="0" name="trackid" />
<cfparam default="0" name="nl_versionID" />
<cfparam default="0" name="sendid" />

<cfparam name="user_stage" default="">
<cfparam name="auth_stage" default="">

<cfset request.emailType = 'awards' />
<!--- options for algorithm are
CFMX_COMPAT (default), AES, BLOWFISH, DES, and DESEDE --->
<cfset algorithm = "AES">
<!--- encoding options, Base64, hex, or uu --->
<cfset encoding = "hex">
<!---set the encrypt key--->
<cfset application.enc_key = "vXEEoqVBt94kWEI2heBLZQ==">
<CFSET todaydate = #CREATEODBCDATETIME(url.reportDate)#>
<cfset day=dayofweek(todaydate)>
<cfset d =#dayofweekasstring(day)#>
<Cfif d is "Saturday" or d is "Sunday"><cfabort showerror="Weekend"></cfif>
<!---run holiday check--->
<cfset cdate = dateformat(todaydate, "mm/dd/yyy")>
<cfquery name="check_holiday" datasource="paintsquare_master">
	select nl_holidayid
	from nl_holiday
	where target_date = '#cdate#' and (content_type = 'all' or content_type = 'pbt')
</cfquery>
<Cfif check_holiday.recordcount gt 0><cfabort showerror="holiday"></cfif>
<cfquery name="getEmailPrefs" datasource="paintsquare_master"><!---pull categories--->
	select *
	from pbt_user_email_pref
	where userID = #url.userid# 
</cfquery>

<cftransaction action="begin">
<cfquery name="check" datasource="paintsquare_master">
	select max(datesent) as sendd 
	from bid_processor_log 
	where awards is null
</cfquery>
<cfset yeard = year(check.sendd)>
<cfset monthd = month(check.sendd)>
<cfset dayd = day(check.sendd)>
<cfset year1 = year(todaydate)>
<cfset month1 = month(todaydate)>
<cfset day1 = day(todaydate)>
<cfset tday3 = createdate(year1,month1,day1)>
<cfset tday2 = createdate(yeard,monthd,dayd)>
<cfif tday2 is tday2>
	<cfinclude template="initialize_trigger.cfm">
	<cfquery name="getusers" datasource="paintsquare_master">
		select distinct bid_users.userid, bid_users.reguserid, bid_user_suppliers.basicpkg,bid_user_suppliers.aebids,
			reg_users.emailaddress, reg_users.reg_userid, bid_user_suppliers.sid,bid_subscription_log.effective_date 
		from bid_users, bid_user_suppliers, reg_users,bid_subscription_log
		where bid_subscription_log.effective_date <= #todaydate# 
			and bid_subscription_log.expiration_date >= #todaydate#
			--and bid_users.supplierid=9000
			and reg_users.reg_userid = bid_users.reguserid 
			and bid_subscription_log.packageid in (1,2,3,4,8,9) 
			and bid_subscription_log.userid not in (select distinct userID from bid_subscription_log where packageid = 16 and active = 1) 
			and bid_subscription_log.active = 1
			and bid_users.sid = bid_user_suppliers.sid 
			and bid_users.userid = bid_subscription_log.userid
			and bid_users.email <> 100 
			and reg_users.emailaddress <> ''   
			and (bid_user_suppliers.aebids = 1 or bid_user_suppliers.basicpkg = 1) 
			and bid_users.bt_status <> 2 
			and bid_users.userid = #url.userid#
		order by bid_users.userid
	 </cfquery>
	 <cfset ad_group = 0>
<CFLOOP query="getusers">
  <CFIF REFindNoCase("^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))$",EmailAddress)>
	<cfset ad_group = 1>
	<cfif isdefined("trackID") and not isnumeric(trackID)>
		<cfset trackID = Decrypt(trackID, application.enc_key, algorithm, encoding)>
	</cfif>
	<cfset trackid = trackid + 1>
	<!---  THIS IS TO TRACK DAILY SEND
	<cfquery name="insert_user_sento" datasource="paintsquare_master">
		insert into nl_sentto
		(nl_versionID,generic_indv_id, datesent,trackid,list_source,ad_group)
		values(#nl_versionid#,#reg_userID#, '#dateformat(todaydate, "mm/dd/yy")#',#trackid#,5,#ad_group#)
	</cfquery>
	--->
	<cfset list_source = 5>
	<cfset userid = #getusers.userid#>
	<cfset oldbid="">
	<cfset email = emailaddress>
	<cfset user1 = userid>
	<!---set the tracking information variables for reporting--->
	<cfset generic_indv_id = URLEncodedFormat(Encrypt(reg_userID, application.enc_key, algorithm, encoding))>
	<cfset source =  URLEncodedFormat(Encrypt(list_source, application.enc_key, algorithm, encoding))>
	<cfset trackID = URLEncodedFormat(Encrypt(trackID, application.enc_key, algorithm, encoding))>
	<cfset addt_variables = "trackID=#trackid#&source=#source#&uid=#generic_indv_id#">
	<!---set the ad group to determine which set of ads to pull rotation--->
	<cfset ad_group = ad_group>	
	<cfset bidStage = '' />
<cfquery name="getcustomerstates" datasource="paintsquare_master"><!---get the user states--->
	select distinct b.stateid 
	from bid_user_state_log a 
		inner join bid_user_supplier_state_log b on b.id = a.id
	where a.userid = #user1#  <cfif getEmailPrefs.states neq 66>and b.stateid in (#getEmailPrefs.states#)</cfif>
</cfquery>
<cfset states = "#valuelist(getcustomerstates.stateid)#">	
<cfquery name="getcustomerscope" datasource="paintsquare_master"><!---pull categories--->
	select tagid
	from pbt_user_email_tag
	where userID = #user1# 
</cfquery>	 
<cfset scopes = "#valuelist(getcustomerscope.tagid)#">
<!---<cfset scopes = listappend(scopes,67) />--->
<!--	
	notice 1,2,3,4
	awards 7,8,9
			

*********** STAGES ********
-->

	<cfloop list="#getEmailPrefs.stages#" index="i">
	 <cfswitch expression="#i#">
		   <!---
	 	   <cfcase value="1">
		   	<cfset stages = "21">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="2">
		   	<cfset stages = "1,4,9">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="3">
		   	 <cfset stages = "24">
	 		 <cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="4">
		   	<cfset stages = "20">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="5">
		   	<cfset stages = "20">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="6">
		   	<cfset stages = "5,6">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		  --->
		   <cfcase value="7">
		   	<cfset stages = "6">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="8">
		   	<cfset stages = "5">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="9">
		   	<cfset stages = "5">
	 		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		  <!---
		   <cfcase value="10">
		   	<cfset stages = "22">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="11">
		   	<cfset stages = "23">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="12">
		   	<cfset stages = "1,4,9,20,21,24">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="13">
		   	<cfset stages = "5,6">
	 		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		   <cfcase value="14">
		   	 <cfset stages = "22,23">
	  		 <cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		  <cfcase value="15">
		   	 <cfset stages = "25">
	  		 <cfset user_stage = listappend(user_stage,stages)>
		  </cfcase>
		  --->
		   <!---cfcase value="16">
		   	<cfset stages = "1,4,9,20,21,24">
	  		<cfset user_stage = listappend(user_stage,stages)>
		  </cfcase--->
		</cfswitch>
	</cfloop>
	
	<!---designate authorized stages based on packages--->
	<cfif listfind(session.packages,"1") or listfind(session.packages,"2") or listfind(session.packages,"3")>
			<cfset authstages = "20,21,22,23,24">
	  		<cfset auth_stage = listappend(auth_stage,authstages)>
	</cfif>
	<cfif listfind(session.packages,"5") or listfind(session.packages,"6") or listfind(session.packages,"15") or listfind(valuelist(session.packages),"12")  >
			<cfset authstages = "5,6">
	 		<cfset auth_stage = listappend(auth_stage,authstages)>
	</cfif>
	<cfif listfind(session.packages,"4") >
			<cfset authstages = "24,25">
	 		<cfset auth_stage = listappend(auth_stage,authstages)>
	</cfif>
	<cfif listfind(session.packages,"7") >
			<cfset authstages = "25">
	 		<cfset auth_stage = listappend(auth_stage,authstages)>
	</cfif>
	<cfif listfind(session.packages,"9") >
			<cfset authstages = "20,23">
	 		<cfset auth_stage = listappend(auth_stage,authstages)>
	</cfif>	

	<cfset user_projecttypes = getEmailPrefs.projectTypes />			
<!---translate the project type form values
	<cfswitch expression="#getEmailPrefs.projectTypes#">
		<cfcase value="1">
			<cfset verifiedProjects = 1>
			<cfset user_projecttypes = 1>
		</cfcase>
		<cfcase value="2">
			<cfset paintingProjects = 1>
			<cfset user_projecttypes = 2>
		</cfcase>
		<cfcase value="3">
			<cfset allProjects = 1>
			<cfset user_projecttypes = 4>
		</cfcase>
	</cfswitch>--->
			
<!-- *************************** -->
<cfset arrQueryNames = ["indPaintAwdResProjUpds","comPaintAwdsRsltUpds","indPaintAwdsRslt","comPaintAwdsRslt","genConsMaintAwdsRslt","engDsgnAwdRslt"]>
	
<cfset arrQueryNameLabels=	["Industrial Painting Awards & Results Project Updates","Commercial Painting Awards & Results Project Updates","Industrial Painting Awards & Results","Commercial Painting Awards & Results","General Construction Maintenance Awards & Results","Engineering & Design Awards & Results"]>
<cfinclude template="inc/db.cfm" />
			
<CFMAIL SUBJECT="Paint BidTracker Award Results for #dateformat(todaydate, "mmmm d, yyyy")#" FROM="daily_email@paintbidtracker.com" to="#emailaddress#"  type="html" bcc="slyon@technologypub.com">
	<!---set the bounceback variables for boogietools software--->
		<cfmailparam name = "X-BPS1" value = "#source#">
		<cfmailparam name = "X-BPS2" value = "#generic_indv_id#">
		<cfmailparam name = "X-NL_versionID" value = "#nl_versionID#">
		<cfmailparam name = "X-SES-CONFIGURATION-SET" value = "PBT_Email_Events">
		<cfmailparam name = "X-SES-MESSAGE-TAGS" value = "campaign=daily_email">
	
<body bgcolor="##5a7775">
<span style="font-family:Verdana, Arial, Helvetica; font-size:10px; color:##bcbcbc; text-decoration:none;">
Trouble viewing this mail?</span> <a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=1&nl_versionid=#nl_versionid#&redirectid=673&#addt_variables#" style="font-family:Verdana, Arial, Helvetica; font-size:10px; color:##bcbcbc; text-decoration:underline">Read it online</a> <span style="font-family:Verdana, Arial, Helvetica; font-size:10px; color:##bcbcbc; text-decoration:bold;">|</span> <a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=1&nl_versionid=#nl_versionid#&redirectid=589&#addt_variables#" style="font-family:Verdana, Arial, Helvetica; font-size:10px; color:##bcbcbc; text-decoration:underline">Add to address book</a> <br /><br />
<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="##ffffff">
	<tr>
    	<td width="180" valign="top">
        	<table width="180" cellpadding="5" cellspacing="0" border="0" bgcolor="##ffffff">
            	<tr>
                	<td align="left" width="195" valign="top">
                   		<span style="font-family:Verdana, Arial, Helvetica, sans-serif;font-size:24px;">
                   			<a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=1&nl_versionid=#nl_versionid#&redirectid=673&#addt_variables#">
                   				<img src="http://www.paintbidtracker.com/images/PBT_Logo_WebHeader_Home_DoubleSize.png" border ="0" alt="Paint BidTracker" width="175" />
                   			</a>
                   		</span>
                    </td>
                </tr>
                <tr>
                    <td height="10"></td>
               	</tr>
                <tr>
                	<td width="185" valign="top">
					<!---include the sponsor ads--->
                    	<cfinclude template="ads_inc.cfm">
                   	</td>
          		</tr>
			</table>
       	</td>
        <td width="100%" valign="top" bgcolor="##FFFFFF">
		<!---include the header--->
        	<cfinclude template="header_inc.cfm">
			
            <table width="100%" cellpadding="5" cellspacing="0" border="0" bgcolor="##ffffff">
				<!---include the announcement if there is one--->
				<cfinclude template="announce_inc.cfm">
				
               <tr>
               	<td width="100%" align="left" height="30" valign="middle" bgcolor="##cbdcdc"><p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:16px; font-weight:bold; margin:5px; padding:5px;">All Awards & Results: <a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=1&nl_versionid=#nl_versionid#&redirectid=673&#addt_variables#" style="color:##2d53ac; text-decoration:none; font-size:12px;">http://www.PaintBidTracker.com </a> </p>
                    <p style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px;  margin:5px; padding:5px;"> You are assigned to receive bids for the following states: <br />
						<cfif isdefined("states") and states is not "">
							<cfquery name="pstates" datasource="paintsquare_master">
								select state_master.state 
								from state_master 
								where stateid in (#states#) 
									and   countryid = 73   
								order by state_master.state
							</cfquery>  
							<cfloop query="pstates">#state#, </cfloop>
						<cfelse>
							<CFMAIL	SUBJECT="PaintSquare BidTracker Email State Insert Problem"	FROM="daily_email@paintbidtracker.com" to="jbirch@paintbidtracker.com,slyon@technologypub.com" type="html">
								Problem with states for user #user1# on line 482 on new_email_v1.cfm
							</cfmail>
						</cfif>
                    </p>
                </td>
			   </tr>
               <tr>
                    <td height="10"></td>
               </tr>
			   <!---if the user has industrial package display--->
              
               
               <tr>
                    <td valign="top" width="100%" cellpadding="0" cellspacing="0" style="background-color: ##FFFFFF;">
                    <span style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
                    	<table width="100%" cellpadding="2" cellspacing="0" style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px;">
                        	<tr>
                            	<td width="20%" style="font-weight:bold;" bgcolor="##fbedbd">
                                Project Name
                                </td>
								<td width="10%" style="font-weight:bold;" bgcolor="##fbedbd">
                                Project Number
                                </td>
                                <td width="10%" style="font-weight:bold;" bgcolor="##fbedbd">
                                Submittal Date
                                </td>
                                <td width="15%" style="font-weight:bold;" bgcolor="##fbedbd">
                                Agency
                                </td>
                                <td width="10%" style="font-weight:bold;" bgcolor="##fbedbd">
                                Location
                                </td>
                                <td width="15%" style="font-weight:bold;" bgcolor="##fbedbd">
                                Relevant Tags
                                </td>
                                <td width="15%" style="font-weight:bold;" bgcolor="##fbedbd">
                                Low Bidders
                                </td>
                       		</tr>
                           <cfinclude template="inc/dataView.cfm"/>  
					</table>
                        </span>
                  	</td>
               	</tr>
                <tr>
                	<td height="10"></td>
                </tr>	



   	<tr>
    	<td colspan="3">
        <hr style="color:##ffc303" size="5" noshade/>
        </td>
   	</tr>	
<cfinclude template="footer_inc.cfm">
</table><br />
</div>
</table>
<span style="font-family:Verdana, Arial, Helvetica; font-size:11px; color:##bcbcbc; text-decoration:none;">
Distribution of Paint BidTracker information to unauthorized users is strictly
prohibited and will result in the permanent cancellation of your account.<br />
<br />
Please visit PaintSquare on the web at <a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=15&nl_versionid=#nl_versionid#&redirectid=1&#addt_variables#" style="font-family:Verdana, Arial, Helvetica; color:##bcbcbc; text-decoration:underline;">http://www.paintsquare.com</a> <br /><br />
You have received this email as a result of your subscription/trial request. If you no longer wish to receive
these emails, please login to your Paint BidTracker account at <a href="http://www.paintsquare.com/newsletter/tracking/bid/?nl_moduleid=15&nl_versionid=#nl_versionid#&redirectid=21&#addt_variables#" style="font-family:Verdana, Arial, Helvetica; color:##bcbcbc; text-decoration:underline;">http://www.PaintBidTracker.com</a> to update your
preferences or contact us at:<br />
<br />
Technology Publishing/PaintSquare<br />
1501 Reedsdale Street, Suite 2008<br />
Pittsburgh, PA 15233<br />
Telephone: 412.431.8300<br />
Email: <a href="mailto:webmaster@paintsquare.com" style="font-family:Verdana, Arial, Helvetica; color:##bcbcbc; text-decoration:underline;">webmaster@paintsquare.com</a>
</span>
</body>
<!---img src="http://www.paintsquare.com/emailtracker.cfm?userid=#user1#"--->
<cfset emaildate = #dateformat(todaydate, "mmmm d, yyyy")#>
<img src="http://www.paintsquare.com/emailtracker2.cfm?userid=#user1#&emaildate=#emaildate#&type=1">
</cfmail>
<cfset bidnum = "">
 </cfif>
</cfloop>




<!---  THIS IS TO TRACK DAILY SEND
	<cfquery name="insert_log" datasource="paintsquare_master">
		insert into bid_email_sent_processor_log
		(datesent,ref)
		values(#todaydate#,'1')
	</cfquery>
	<cfquery name="statusup" datasource="paintsquare_master">
		update nl_main
		set status = 2 
		where nl_versionid = #nl_versionid#
	</cfquery>
--->
<!---cfmail 
to="webmaster@paintsquare.com" 
from="webmaster@paintsquare.com" 
subject="TESTING **** PBT Daily Send Confirmation" 
cc="jbirch@paintbidtracker.com;bchurray@paintsquare.com,slyon@technologypub.com" 
 
<cfmail to="slyon@technologypub.com" from="webmaster@paintsquare.com" subject="TESTING **** PBT Daily Send Confirmation" >
	Email Sending Totals 

	Date Sent: #dateformat(todaydate)#

	Total Send-  #getusers.recordcount#
</cfmail>
<CFMAIL SUBJECT="email pref email send" FROM="PaintBidtracker@paintsquare.com" to="slyon@technologypub.com" type="html">
	<cfif isdefined('r1')><cfdump var="#r1#" /></cfif>
	</cfmail>---->
<cfelse>
	<cfmail to="slyon@technologypub.com" from="daily_email@paintbidtracker.com" subject="Email Error" >
		There was an error with the Daily Email Results.
	</cfmail>
</cfif>
</cftransaction>


</html>
