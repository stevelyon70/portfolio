

<!---Generate internal notification e-mail of transaction--->
<cfoutput>
<cfif isdefined("x_response_code")>
<cfmail
	subject="A Job Posting Has Been Renewed via Authorize.net"
	from="webmaster@paintsquare.com"			
	to="invoicing@paintsquare.com"
	cc="afolmer@technologypub.com, lskrainy@paintsquare.com, mwelsh@paintsquare.com"
	
	type="html">
<font face="Arial, Helvetica, sans-serif" size="2" >	
The following transaction for a <strong>Job Posting Renewal</strong> has been processed via Authorize.net.<br>
<hr>
Datestamp: #dateformat (date, 'dddd, mmmm d, yyyy')# #timeformat (date, 'h:mm TT')#<br>
Response code: #x_response_code#<br>
Response reason code: #x_response_reason_code# (#x_response_reason_text#)<br>
Approval code: #x_auth_code#<br>
Transaction ID: #x_trans_id#<br>
Amount paid: $#x_amount#<br>
Description of item: #x_description#<br>
Invoice number: #x_invoice_num#<br>
<cfif x_po_num is not "">PO Number: #x_po_num#<br></cfif>
Payment method: #x_method#<br>
<hr>
<cfif x_cust_id is not "">Reg_userID: #x_cust_id#</cfif>
Name: #x_first_name# #x_last_name#<br>
Company: #x_company#<br>
Address: #x_address#<br>
#x_city# #x_state# #x_zip# #x_country#<br>
Phone: #x_phone#<br>
Fax: #x_fax#<br>
E-mail: #x_email#<br>
<hr>
Headline: #get_item.positiontitle#<br>
Listed under: #get_item.displaycompany#
<br><br>
</font>		
</cfmail>
<cfelse>
<cfmail
	subject="A Job Posting Has Been Renewed by a Free Poster"
	from="webmaster@paintsquare.com"			
	to="lmacek@paintsquare.com"
	cc="afolmer@technologypub.com, psimmons@paintsquare.com"
	
	type="html">
<font face="Arial, Helvetica, sans-serif" size="2" >	
The following transaction for a <strong>Job Posting Renewal</strong> has been processed.<br>
<hr>
Datestamp: #dateformat (date, 'dddd, mmmm d, yyyy')# #timeformat (date, 'h:mm TT')#<br>
<hr>
Headline: #get_item.positiontitle#<br>
Listed under: #get_item.displaycompany#
<br><br>
</font>		
</cfmail>
</cfif>
</cfoutput>