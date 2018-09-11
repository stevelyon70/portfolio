<!---verify captcha. If not redirect them to previous page
	<cfif not application.captcha.validateCaptcha(form.hash, form.captcha)>
			<cflocation url="#rootpath#post/?err=2">
	</cfif>--->
<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<cfquery name="insertadmin" datasource="#application.datasource#">
insert into pbt_user_bid_postings
(
postername,
companyname,
contactname,
city,
stateID,
phonenumber,
faxnumber,
postalcode,
emailaddress,
deadline,
description,
othernotes,
requesttype,
postertype,
dateposted,
remoteIP,
ownername
)
values(
<cfif isdefined("name") and name NEQ ""><cfqueryPARAM value = "#form.name#" CFSQLType="cf_sql_varchar"><cfelse>NULL</cfif>,
<cfif isdefined("companyname") and companyname NEQ ""><cfqueryPARAM value = "#form.companyname#" CFSQLType="cf_sql_varchar" ><cfelse>NULL</cfif>,
<cfif isdefined("contactname") and contactname NEQ ""><cfqueryPARAM value = "#form.contactname#" CFSQLType="cf_sql_varchar"><cfelse>NULL</cfif>,
<cfif isdefined("city") and city NEQ ""><cfqueryPARAM value = "#form.city#" CFSQLType="cf_sql_varchar"><cfelse>NULL</cfif>,
<cfif isdefined("stateID") and stateID NEQ ""><cfqueryPARAM value = "#form.stateID#" CFSQLType="CF_SQL_INTEGER"><cfelse>NULL</cfif>,
<cfif isdefined("phonenumber") and phonenumber NEQ ""><cfqueryPARAM value = "#form.phonenumber#" CFSQLType="cf_sql_varchar"><cfelse>NULL</cfif>,
<cfif isdefined("faxnumber") and faxnumber NEQ ""><cfqueryPARAM value = "#form.faxnumber#" CFSQLType="cf_sql_varchar"><cfelse>NULL</cfif>,
<cfif isdefined("postalcode") and postalcode NEQ ""><cfqueryPARAM value = "#form.postalcode#" CFSQLType="cf_sql_varchar"><cfelse>NULL</cfif>,
<cfif isdefined("emailaddress") and emailaddress NEQ ""><cfqueryPARAM value = "#form.emailaddress#" CFSQLType="cf_sql_varchar"><cfelse>NULL</cfif>,
<cfif isdefined("deadline") and deadline NEQ ""><cfqueryPARAM value = "#form.deadline#" CFSQLType="cf_sql_varchar"><cfelse>NULL</cfif>,
<cfif isdefined("description") and description NEQ ""><cfqueryPARAM value = "#form.description#" CFSQLType="cf_sql_varchar"><cfelse>NULL</cfif>,
<cfif isdefined("othernotes") and othernotes NEQ ""><cfqueryPARAM value = "#form.othernotes#" CFSQLType="cf_sql_varchar"><cfelse>NULL</cfif>,
<cfif isdefined("requesttype") and requesttype NEQ ""><cfqueryPARAM value = "#form.requesttype#" CFSQLType="cf_sql_varchar"><cfelse>NULL</cfif>,
<cfif isdefined("postertype") and postertype NEQ ""><cfqueryPARAM value = "#form.titleID#" CFSQLType="CF_SQL_INTEGER"><cfelse>NULL</cfif>,
#date#,
'#cgi.remote_addr#',
<cfif isdefined("ownername") and ownername NEQ ""><cfqueryPARAM value = "#form.ownername#" CFSQLType="cf_sql_varchar"><cfelse>NULL</cfif>)
</cfquery>
<cfquery name="title" datasource="#application.datasource#">
	select * 
	from job_titlenew 
	where titleID = #form.titleID#
	order by sort
</cfquery>
<cfif isdefined("stateID") and stateID NEQ "">
  <cfquery name="st" datasource="#application.datasource#">
		select stateID, fullname
		from state_master
		where stateID <> '66' and stateID = #form.stateID#
		order by sort
	</cfquery>
</cfif>
<cfmail 
to="bchurray@paintsquare.com,jbirch@paintsquare.com" 
from="bidposting@paintbidtracker.com" 
subject="Paint BidTracker Bid Posting Submitted" 
bcc="slyon@technologypub.com"
type="text/html" 
>
#form.name# from #form.companyname# has posted a project using the Bid Posting Form. The description of the request is below.<br><br>
Facility Owner Name - #form.ownername#<br>
Contact Name - #form.contactname#<br>
<cfif isdefined("city") and city NEQ "">City - #form.city#<br></cfif>
<cfif isdefined("stateID") and stateID NEQ "">State - #st.fullname#<br></cfif>
<cfif isdefined("postalcode") and postalcode NEQ "">Postalcode - #form.postalcode#<br></cfif>
<cfif isdefined("phonenumber") and phonenumber NEQ "">Phonenumber - #form.phonenumber#<br></cfif>
<cfif isdefined("faxnumber") and faxnumber NEQ "">Faxnumber - #form.faxnumber#<br></cfif>
<cfif isdefined("emailaddress") and emailaddress NEQ "">Email Address - #form.emailaddress#<br></cfif>
Deadline - #form.deadline#<br>
Request Type - #form.requesttype#<br>
Poster Type - #title.jobtitle#<br>
<cfif isdefined("othernotes") and othernotes NEQ "">Other Notes - #form.othernotes#<br></cfif>

Description -#form.description#

</cfmail>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
    	<td width="100%" align="left" valign="top" colspan="3">
        	<div align="left">
          	<table border="0" cellpadding="0" cellspacing="0" width="100%">
            	<tr>
                	<td align="left" valign="bottom">
                   	<h1><span style="font-size:16px">Paint BidTracker Bid Posting Tool</span></h1>
                  	</td>
                 	<td valign="top" width="180">
					<p>
					<!-- AddThis Button BEGIN -->
					<div class="addthis_toolbox addthis_default_style"><a class="addthis_button_email"></a> <a class="addthis_button_print"></a> <a class="addthis_button_twitter"></a> <a class="addthis_button_facebook"></a> <a class="addthis_button_linkedin"></a> <!---a class="addthis_button_stumbleupon"></a> <a class="addthis_button_digg"></a---> <span class="addthis_separator">|</span> <a class="addthis_button_expanded">More</a></div>
					<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js?pub=xa-4a843f5743c4576f"></script>
					<!-- AddThis Button END -->
               		</p>
					</td>
             	</tr>
         	</table>
            </div>
            <div align="left">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
    			<tr>
      				<td width="100%"><hr class="PBT" noshade></td>
    			</tr>
  			</table>
			</div>
		</td>
    </tr>
</table>
		<table border="0" width="100%">
            <tr>
              <td width="100%">	
			<p><font face="Arial" size="2">
			Thank you for submitting your request. The report will be posted to Paint BidTracker shortly (typically within 1 business day).
			If you have any questions or need to change the deadline or other information in the report, please email <a href="mailto:bidposting@paintbidtracker.com" class="bold">bidposting@paintbidtracker.com</a></font></p>
			</span>
			</font>
			</td>
             </tr>
         </table>
		