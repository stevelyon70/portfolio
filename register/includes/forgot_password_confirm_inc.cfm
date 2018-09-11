<cfsetting showdebugoutput="false">
<cfset valid = false>
<cfset message = "">


<CFSET DATE = #CREATEODBCDATETIME(NOW())#>

<cfquery name="email" datasource="#application.datasource#">
select reg_userID, emailaddress from reg_users where emailaddress = '#form.emailaddress#'
</cfquery>

<cfif email.recordcount>
	<cfset valid = true>

	<cfset reg_userID=email.reg_userID>
	
	<cfquery name="getinfo" datasource="#application.datasource#">
	select reg_userID, firstname, lastname, emailaddress, password
	from reg_users
	where reg_userID = #reg_userID#
	</cfquery>
	
	<cfoutput>
	<CFMAIL
			SUBJECT="Your login information for Paint BidTracker"
			FROM="webmaster@paintsquare.com"			
			TO="""#getinfo.FirstName# #getinfo.LastName#"" <#getinfo.emailaddress#>"
			type="html">

		<table width="550" cellspacing="0" cellpadding="0">
			<tr>
				<td width="100%">
					<table width="100%" cellspacing="0" cellpadding="0">
						<tr>
							<td width="50%">
								<a href="http://beta360.paintbidtracker.com">
								<img src="http://www.paintbidtracker.com/images/PBT_Logo_WebHeader_Home_DoubleSize.png" border="0" width="300">
								</a>
							</td>
							<td width="50%" align="right" valign="top">
								<p style="margin-right: 6; margin-top: 12">
								<font face="Arial, Helvetica, sans-serif" size="3" color="333399">
								<b>Password Reminder</b>
								</font></p>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				<td>
			</tr>
			<tr>
				<td width="100%">
					<table width="100%" cellspacing="0" cellpadding="6">
						<tr>
							<td width="100%">
								<p><font face="Arial, Helvetica, sans-serif" size="2">
								Dear #getinfo.firstname# #getinfo.lastname#,<br><br>
								Here is the password reminder that you requested.<br><br>
								E-mail address: <b>#getinfo.emailaddress#</b><br><br>
								Password: <b>#getinfo.password#</b><br><br>
								To sign in, please <a href="http://beta360.paintbidtracker.com/?defaultdashboard">
								click here</a>.<br><br>
								<a href="http://www.paintbidtracker.com">Paint BidTracker</a> is a publication of Technology Publishing / PaintSquare. 
								</font></p>
							</td>
						</tr>
					</table>
				<td>
			</tr>
			<tr>
				<td width="100%">
					<table width="100%" cellspacing="0" cellpadding="0">
						<tr height="6">
							<td width="100%">
								<hr width="100%" height="6" color="333399">
							</td>
						</tr>
						<tr>
							<td width="100%">
								<p style="margin: 6"><font face="Arial, Helvetica, sans-serif" size="1">
								You received this message by submitting the password reminder form on Paint BidTracker.<br><br>
								If you believe you received this message in error, please e-mail 
								<a href="mailto:webmaster@paintsquare.com">webmaster@paintsquare.com</a> or contact:<br><br>
								Technology Publishing/PaintSquare, 1501 Reedsdale Street, Suite 2008, Pittsburgh, PA 15233, USA
								</font></p>
							</td>
						</tr>
					</table>
				<td>
			</tr>
		</table>
	</cfmail>
	</cfoutput>

</cfif>

{ "valid": <cfoutput>#valid#</cfoutput>, "message": "<cfoutput>#message#</cfoutput>"}