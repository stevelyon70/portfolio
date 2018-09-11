<cfdocument localUrl="yes" format="pdf">
	<!--- Header --->
	<cfdocumentitem type="header">
		<!---<img src="../images/PaintBidTracker_PaintcanLogo.png" alt="Paint BidTracker" border="0">---> Paint BidTracker Lead Details
	</cfdocumentitem>
		<cfif isDefined("session.leadDetail")>
			<cfoutput>#session.leadDetail#</cfoutput>
		</cfif>
	<!--- Footer --->
	<cfdocumentitem type="footer">
		<p align="center">
			Distribution of Paint BidTracker information to unauthorized users is strictly prohibited and will result in the permanent cancellation of your account.
		</p>
	</cfdocumentitem>
</cfdocument>