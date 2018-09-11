<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
  <cfscript>
// *** Restrict Access To Page: Grant or deny access to this page
/*MM_authorizedUsers="";
MM_authFailedURL="../register/";
MM_grantAccess=false;
MM_Session = IIf(IsDefined("Session.MM_Username"),"Session.MM_Username",DE(""));
if (MM_Session IS NOT "") {
  if (true OR (Session.MM_UserAuthorization IS "") OR (Find(Session.MM_UserAuthorization, MM_authorizedUsers) GT 0)) {
    MM_grantAccess = true;
  }
}
if (NOT MM_grantAccess) {
  MM_qsChar = "?";
  if (Find("?",MM_authFailedURL) GT 0) MM_qsChar = "&";
  MM_referrer = CGI.SCRIPT_NAME;
  if (CGI.QUERY_STRING IS NOT "") MM_referrer = MM_referrer & "?" & CGI.QUERY_STRING;
  MM_authFailedURL_Trigger = MM_authFailedURL & MM_qsChar & "accessdenied=" & URLEncodedFormat(MM_referrer);
}*/
</cfscript>
<!---<cfif IsDefined("MM_authFailedURL_Trigger")>
<cflocation url="#MM_authFailedURL_Trigger#" addtoken="no">
</cfif>--->
<cfif isUserLoggedIn()>
 <CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<html>
<head>
	<title>Paint BidTracker</title>
	<style>
TD.DataA{background:white;color:black}
TD.DataB{background:DCDCDC;color:black}
BODY{background-color:white;font-size: 11px}
A{color: ; font-weight:; text-decoration:none}
A:hover{color: }
A:visited:{color:  }
.tex{font-size: 11px; color: black; font-weight: ; font-family: Arial, Helvetica, non-serif}
.tex2{font-size: 11px; color: blue; font-weight:bold ; font-family: Arial, Helvetica, non-serif}
.tex3{font-size: 11px; color: purple; font-weight:bold ; font-family: Arial, Helvetica, non-serif}
.tex4{font-size: 11px; color: white; font-weight:bold ; font-family: Arial, Helvetica, non-serif}
.tex5{font-size: 11px; color: red; font-weight: ; font-family: Arial, Helvetica, non-serif}
</style>

</head>

<body>
		
		<!---cfquery name="checkpackage" datasource="#application.datasource#">
	select bid_subscription_log.packageid
	from bid_subscription_log inner join bid_users on bid_users.userid = bid_subscription_log.userid 
	where bid_users.userid =  <cfqueryPARAM value = "#userid#" CFSQLType = "CF_SQL_INTEGER"> and bid_subscription_log.packageid = 13  and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date >= #date# and bid_subscription_log.active = 1
	</cfquery> 
	<cfif checkpackage.packageid is 13 --->
	
					
					
					
<cfquery name="getplandate" datasource="#application.datasource#">
select max(receivedate) as datereceived from bid_planholders where bidid =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#"> and bid_planholders.active is null
</cfquery>				
					
<cfquery name="getplanlist" datasource="#application.datasource#">
select distinct companyname,city,bid_planholders.state,contactphone,companyphone,companyfax,state_master.state,address1,postalcode,firstname,lastname,emailaddress,receivedate,bid_planholders.stateid from bid_planholders left outer join state_master on state_master.stateid = bid_planholders.stateid where bidid = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#bidid#"> and bid_planholders.active is null  order by companyname
</cfquery>					
					
			<cfif getplanlist.recordcount gt 0>
				<cfoutput>		
				
                   <!--mstheme--><font face="arial, Arial, Helvetica" size="2"><font size=2 face="arial"><strong>Planholders List </strong></font><!--mstheme--></font>
                   <br><br>
					  <font size=2 face="arial">
					  As of #dateformat(getplandate.datereceived,"mmmm d, yyyy")#</font>
					  
					  
					  
					   <table width="100%" cellpadding=2 cellspacing=0 border=0 >
					   <tr><td>&nbsp;</td></tr>
	   
					   	<cfloop query="getplanlist">		
												 <cfif currentrow MOD 2 IS 1> 
												  <tr valign="top">
												</cfif>
								

<cfif companyphone is not "">			
<cfset ph = rereplace(companyphone,"[^0-9]","","all")>
<cfset length = len("#ph#")>
<cfset phon = mid(#ph#,"1","3")>
<cfset phon2= mid(#ph#,"4","3")>
<cfset phon3=mid(#ph#,"7","4")>

<cfset phonenumber="(#phon#) #phon2#-#phon3#">
</cfif>	

<cfif companyphone is "">	
<cfif contactphone is not "">	
<cfset ph = rereplace(contactphone,"[^0-9]","","all")>
<cfset length = len("#ph#")>
<cfset phon = mid(#ph#,"1","3")>
<cfset phon2= mid(#ph#,"4","3")>
<cfset phon3=mid(#ph#,"7","4")>

<cfset phonenumber="(#phon#) #phon2#-#phon3#">
</cfif>	

</cfif>	


<cfif companyfax is not "">
<cfset fx = rereplace(companyfax,"[^0-9]","","all")>
<cfset length = len("#fx#")>
<cfset fax = mid(#fx#,"1","3")>
<cfset fax2= mid(#fx#,"4","3")>
<cfset fax3=mid(#fx#,"7","4")>

<cfset faxnumber="(#fax#) #fax2#-#fax3#">
</cfif>				

					                              <td width="50%" height="20"><span class="tex"><strong><cfif companyname is "">Not Available<cfelse>#companyname#</cfif></strong></span><br><span class="tex"><cfif address1 is not "">#address1#<br></cfif><cfif city is not "">#city#,</cfif><cfif stateid is not 66> #state#<cfif postalcode is ""><br></cfif></cfif><cfif postalcode is not ""> #postalcode#<br></cfif></span>
												 <span class="tex"><cfif firstname is not "" and lastname is not ""> Contact: <cfif firstname is not "">#trim(firstname)#</cfif> <cfif lastname is not "">#trim(lastname)#</cfif><br></cfif></span>
												  <cfif emailaddress is not ""><span class="tex">Email: #trim(emailaddress)#</span><br><cfelse></cfif>
												 <cfif contactphone is ""><cfelse><span class="tex">Phone: #trim(phonenumber)#</span><br></cfif>
												 <cfif companyfax is ""><cfelse><span class="tex">Fax:  #trim(faxnumber)#</span><br></cfif>
												  </td>
				                                
					                              
                                               
                                                
												
											<cfif CurrentRow MOD 2 IS 0>
                                                </tr>
                                               </cfif>	
											 </cfloop>  
											 <!---if the query record count is not equally divisible by 2,--->
					<!---the last row was not close.--->
					<cfif getplanlist.RecordCount MOD 2 IS NOT 0>
							<CFSET ColsLeft = 2 - (getplanlist.RecordCount MOD 2)>
							<cfloop from = "1" TO = "#ColsLeft#" INDEX = "i"></td>
									<TD>&nbsp;</td><td>&nbsp;</td>
							</cfloop>
							</TR>
						</cfif>
					   
			   
					   </table>
					  
					 <!---table width="100%" cellpadding=2 cellspacing=0 border=0 >
				<tr><td class="generalFT generalBold" colspan=5><font size=2 face="arial"><strong>Planholders List as of #dateformat(getplanlist.receivedate,"mmmm d, yyyy")#</strong></font></td></tr>
				
				<tr>
					<td width="40%"><span class="tex"><strong>Company:</strong></span></td>
					<td width="20%"><span class="tex"><strong>Contact Name:</strong></span></td>
					<td width="15%"><span class="tex"><strong>Phone:</strong></span></td>
					<td width="15%"><span class="tex"><strong>Fax:</strong></span></td>
				</tr>


<cfloop query="getplanlist">
<cfif companyphone is not "">			
<cfset ph = rereplace(companyphone,"[^0-9]","","all")>
<cfset length = len("#ph#")>
<cfset phon = mid(#ph#,"1","3")>
<cfset phon2= mid(#ph#,"4","3")>
<cfset phon3=mid(#ph#,"7","4")>

<cfset phonenumber="(#phon#) #phon2#-#phon3#">
</cfif>	

<cfif companyphone is "">	
<cfif contactphone is not "">	
<cfset ph = rereplace(contactphone,"[^0-9]","","all")>
<cfset length = len("#ph#")>
<cfset phon = mid(#ph#,"1","3")>
<cfset phon2= mid(#ph#,"4","3")>
<cfset phon3=mid(#ph#,"7","4")>

<cfset phonenumber="(#phon#) #phon2#-#phon3#">
</cfif>	

</cfif>	


<cfif companyfax is not "">
<cfset fx = rereplace(companyfax,"[^0-9]","","all")>
<cfset length = len("#fx#")>
<cfset fax = mid(#fx#,"1","3")>
<cfset fax2= mid(#fx#,"4","3")>
<cfset fax3=mid(#fx#,"7","4")>

<cfset faxnumber="(#fax#) #fax2#-#fax3#">
</cfif>

				
				<tr>
					<td width="40%"><span class="tex"><strong>#companyname#</strong></span><span class="tex"><br><cfif address1 is not "">#address1#<br></cfif><cfif city is not "">#city#,</cfif> #fullname# #postalcode#</span></td>
					<td width="20%"><span class="tex"><cfif firstname is not "">#firstname#</cfif> <cfif lastname is not "">#lastname#</cfif><br>#emailaddress#</span></td>
					<td width="15%"><span class="tex"><cfif contactphone is ""><cfelse>#phonenumber#</cfif></span></td>
					<td width="15%"><span class="tex"><cfif companyfax is ""><cfelse>#faxnumber#</cfif></span></td>
					
				</tr>
				</cfloop>
				
			
				</table--->
		
					  
					
				</cfoutput>		
					 </cfif>
					
<!---/cfif--->						


</body>
</html>
</cfif>