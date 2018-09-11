<!---
********************************
	EMAIL LEAD FROM CLIPBOARD
	CREATED BY RM 02/23/2018
*************************************-
--->

<!--- USER EMAIL INFO --->
<cfquery name="getname" datasource="#application.datasource#">
	select name,emailaddress
	from reg_users 
	inner join bid_users on bid_users.reguserID = reg_users.reg_userID
	where bid_users.userID = <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER">
</cfquery>
<cfset emailname = getname.name>
<cfset email = getname.emailaddress>

<!--- GENERAL VARIABLES --->
<cfset b = bidID>
<cfset spend = true>
<CFSET todate = CREATEODBCDATE(NOW())>
<cfset todate = dateformat(todate, "mmddyyy")>
<cfparam default="50" name="site_tagID" />

<cflock type="exclusive" timeout="60">

	<!--- PROCESS TO GENERATE CONTENT AND CREATE PDF FILE FOR EMAIL ATTACHMENT --->
	<cfset variables.filetoSend = "PaintBidTracker_lead_detail_#b##userID##todate#.pdf">

	<!--- TEST IF BID IS CAP SPENDING, PULL BID DETAILS --->
	<cfstoredproc procedure="pbt_project_detail_agency_spending" datasource="#application.dataSource#" >
		<cfprocparam type="in" dbvarname="@bidid" cfsqltype="CF_SQL_INTEGER" value="#b#">
		<cfprocresult name="getdetail" resultset="1">
	</cfstoredproc>

	<!--- IF NOT CAP SPENDING, PULL BID DETAILS --->
	<cfif getdetail.recordcount EQ 0>
		<cfset spend = false>
		<cfstoredproc procedure="pbt_project_detail" datasource="#application.datasource#" >
			<cfprocparam type="in" dbvarname="@bidid" cfsqltype="CF_SQL_INTEGER" value="#b#">
			<cfprocresult name="getdetail" resultset="1">
		</cfstoredproc>
	</cfif>

	<cfif spend>
		<cfinclude template="lead_content_spending.cfm">
	<cfelse>
		<cfinclude template="lead_content.cfm">
	</cfif>

	<cfdocument format="pdf" filename="D:\gateway_attachments\#variables.filetoSend#" encryption="128-BIT" permissions="ALLOWPRINTING" pagetype="LETTER" overwrite="YES" >
		<!---<img src="../../images/PaintBidTracker_PaintcanLogo.png" alt="Paint BidTracker" border="0"> --->
		<p class="BigBold" style="margin-top: 18; margin-bottom: 12">Paint BidTracker Project Detail</p>

		<cfoutput>#evaluate("leadDetail_" & b)#</cfoutput>

		<p align="center">
		<span style="font-family: arial, Arial, Helvetica;  font-size: 6pt; color:red; font-weight:bold">
		Distribution of Paint BidTracker information to unauthorized users is strictly prohibited and will result in the permanent cancellation of your account.
		</span>
		</p>
	</cfdocument>

	<!---
	<cfhtmltopdf destination="D:\gateway_attachments\#variables.filetoSend#" overwrite="yes" pageType="letter" permissions="AllowPrinting" encryption="AES_128">
		<img src="../../images/PaintBidTracker_PaintcanLogo.png" alt="Paint BidTracker" border="0"> <p class="BigBold" style="margin-top: 18; margin-bottom: 12">Paint BidTracker Project Detail</p>
		<span style="font-family: arial, Arial, Helvetica;  font-size: 10pt;>

		</span>

		<p align="center">
		<span style="font-family: arial, Arial, Helvetica;  font-size: 6pt; color:red; font-weight:bold">
		Distribution of Paint BidTracker information to unauthorized users is strictly prohibited and will result in the permanent cancellation of your account.
		</span>
		</p>
	 </cfhtmltopdf>
	 --->
	 
	 
	<!--- TRACK LEAD SENT - CREATE EMAIL --->
	<CFSET todaydate = CREATEODBCDATETIME(NOW())>
	<cfif tosubject EQ "">
		<cfset tosubject = "#emailname# sent you something from Paint BidTracker">
	</cfif>

	<cfquery name="tracksend" datasource="#application.datasource#">
		insert into pbt_user_leads_sent
		(userID,bidID,sender_name,sender_email,receive_name,receive_email,message,date_sent,remoteIP)
		values(<cfif isdefined("userID") and userID NEQ "">#userID#<cfelse>NULL</cfif>,<cfif isdefined("b") and b NEQ "">#b#<cfelse>NULL</cfif>,<cfif isdefined("emailname") and emailname NEQ "">'#emailname#'<cfelse>NULL</cfif>,<cfif isdefined("email") and email NEQ "">'#email#'<cfelse>NULL</cfif>,<cfif isdefined("toname") and toname NEQ "">'#toname#'<cfelse>NULL</cfif>,<cfif isdefined("toemail") and toemail NEQ "">'#toemail#'<cfelse>NULL</cfif>,<cfif isdefined("comments") and comments NEQ "">'#comments#'<cfelse>NULL</cfif>,<cfif isdefined("todaydate") and todaydate NEQ "">#todaydate#<cfelse>NULL</cfif>,<cfif isdefined("cgi.remote_addr") and cgi.remote_addr NEQ "">'#cgi.remote_addr#'<cfelse>NULL</cfif>)
	</cfquery>


	<cfmail 
		to="#toemail#" 
		from="paintbidtracker@paintsquare.com"
		cc="#email#" 
		subject="#tosubject#"
		type="html">
		<cfmailparam file="D:\gateway_attachments\#variables.filetoSend#">
		<cfoutput>
			<div align="left">
				<table border="0" cellpadding="0" cellspacing="0" width="550">
					<tr>
						<td>
							<table width="100%" cellspacing="0" cellpadding="0">
								<tr>
									<td width="50%">
										<a href="http://app.paintbidtracker.com">
										<img src="http://www.paintbidtracker.com/images/PBT_Logo_Footer.png" border="0">						
										</a>
									</td>
									<td width="50%" align="right" valign="top">
										<p style="margin-right: 6; margin-top: 12">
										<font face="Arial, Helvetica, sans-serif" size="3" color="333399">
										<b>Paint BidTracker Project Report</b>
										</font></p>
									</td>
								</tr>
								<tr>
									<td width="100%" colspan="2" background="http://app.paintbidtracker.com/images/Yellow_Block.jpg">
										<img src="http://app.paintbidtracker.com/images/Yellow_Block.jpg" 
										width="12" height="12" border="0">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<p align="right"><font face="Arial" size="2">#dateformat(date, "mmmm d, yyyy")#; #timeformat(date, "h:mm tt")#&nbsp;</font>
						</td>
					</tr>
					<tr>
						<td>
							<p><font face="Arial" size="2">Hello <cfif isdefined("toname") and toname NEQ "">#toname#,</cfif></font></p>
							<hr>
							<p style="margin-left: 6; margin-bottom: 3;"><font face="Arial" size="2">
								#emailname# has sent you this lead from Paint BidTracker.<br><br>

							<cfif isdefined("comments") and comments NEQ "">
								Additional Comments: #comments#
							</cfif>

							</font></p>
							<hr>
							<p><font face="Arial" size="2">
								To review, open the attached PDF using Adobe Acrobat version 5.0 or greater. 

								Paint BidTracker
								http://www.paintbidtracker.com
							</font>
						</td>
					</tr>
					<tr>
						<td>
							<table width="100%" cellspacing="0" cellpadding="0">
								<tr height="6">
									<td width="100%">
										<hr width="100%" height="6" color="355097">
									</td>
								</tr>
								<tr>
									<td width="100%">
										<p style="margin: 6"><font face="Arial, Helvetica, sans-serif" size="1">
										Technology Publishing/PaintSquare, 1501 Reedsdale Street, Suite 2008, Pittsburgh, PA 15233
										</font></p>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
		</cfoutput>
	</cfmail>

 </cflock>