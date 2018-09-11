
<cfset bidID = #form.bidID#>


<cflock timeout="15" name="send">

	<cfset todate = CREATEODBCDATE(NOW())>
	<cfset todate = dateformat(todate, "mmddyyy")>
	<cfset variables.filetoSend = "PaintBidTracker_lead_detail_#bidID##userID##todate#.pdf">

	<cfdocument format="pdf" filename="D:\gateway_attachments\#variables.filetoSend#" encryption="128-BIT" permissions="ALLOWPRINTING" pagetype="LETTER" overwrite="YES" >
		<!---<img src="../../images/PaintBidTracker_PaintcanLogo.png" alt="Paint BidTracker" border="0"> --->
		<p class="BigBold" style="margin-top: 18; margin-bottom: 12">Paint BidTracker Project Detail</p>

			<cfif isDefined("session.leadDetail")>
				<cfoutput>#session.leadDetail#</cfoutput>
			</cfif>

		<p align="center">
		<span style="font-family: arial, Arial, Helvetica;  font-size: 6pt; color:red; font-weight:bold">
		Distribution of Paint BidTracker information to unauthorized users is strictly prohibited and will result in the permanent cancellation of your account.
		</span>
		</p>
	</cfdocument>

	<cfmail 
	to="jbirch@paintbidtracker.com;bnaccarelli@paintbidtracker.com" 
	from="admin@paintbidtracker.com"	
	subject="Requested Additional Research"
	bcc="slyon@technologypub.com"
	type="html"
	>
		<cfmailparam file="D:\gateway_attachments\#variables.filetoSend#">
		<cfoutput>
		The following subscriber has requested additional research on BidID-#bidID#:<br><br>

		#form.emailname#<br>
		#form.email#<br>
		#form.company#<br>
		#form.phone#<br><br>

		<cfif isdefined("comments") and comments NEQ "">
		Additional Comments: #form.comments#
		</cfif>
		<br>
		To review, open the attached PDF using Adobe Acrobat version 5.0 or greater. 
		<br>
		Paint BidTracker
		http://www.paintbidtracker.com
		</cfoutput>
	</cfmail>

 </cflock>