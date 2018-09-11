

<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<cfquery name="title" datasource="#application.datasource#">
	select * from job_titlenew order by sort
</cfquery>
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
 <p><font size="2" face="Arial">
 Welcome to the Paint BidTracker Bid Posting Tool.  
 Please complete the following form to advertise your request to hundreds of paint and coating professionals looking to do business.  
 Contact <a href="mailto:bidposting@paintbidtracker.com" class="bold">bidposting@paintbidtracker.com</a> for questions. 
 </font></p>

<cfform method="POST" action="?action=confirm">

  <div align="left">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" height="826">
      <tr>
        <td width="134" valign="top" align="right" height="28">
          <p style="margin-right: 3; margin-top: 3"><b><font size="2" face="Arial">Poster Name:*</font></b>(will not be displayed)</td>
        <td width="452" valign="top" height="28">
          <p style="margin-top: 3"><font size="2" face="Arial"><cfinput type="Text" name="name" value="" required="yes" size="40" message="Please enter a Poster Name."></font></td>
      </tr> 
	  <tr>
        <td width="134" valign="top" align="right" height="28">
          <p style="margin-right: 3; margin-top: 3"><b><font size="2" face="Arial">Poster Company:*</font></b></td>
        <td width="452" valign="top" height="28">
          <p style="margin-top: 3"><font size="2" face="Arial"><cfinput type="text" size="40" name="companyname" required="yes"  message="Please enter a Poster Company."></font></td>
      </tr>
     
      <tr>
        <td width="134" valign="top" align="right" height="28">
          <p style="margin-right: 3; margin-top: 3"><b><font size="2" face="Arial">Poster Type:*</font></b></td>
        <td width="452" valign="top" height="28">
          <p style="margin-top: 3"><font size="2" face="Arial"><cfselect name="titleID" size="1" query="title" value="titleID" display="jobtitle" required="yes"  message="Please enter a Poster Type."><option value="" selected>Select one</option></cfselect></font></td>
      </tr>
      <tr>
        <td width="134" valign="top" align="right" height="27">
          <p style="margin-right: 3; margin-top: 3"><b><font size="2" face="Arial">Report Title/Project Name:*</font></b></td>
        <td width="452" valign="top" height="27">
          <p style="margin-top: 3"><font size="2" face="Arial"><cfinput type="Text" name="projectname" value="" required="yes" size="40"  message="Please enter a Report Title/Project Name."></font></td>
      </tr>
      <tr>
        <td width="134" valign="top" align="right" height="16">
          <p style="margin-right: 3; margin-top: 3"><font face="Arial" size="2"><b>Facility Owner Name:*</b></font></td>
        <td width="452" valign="top" height="16">
          <p style="margin-top: 3"><font face="Arial" size="2"><cfinput type="Text" name="ownername" value="" required="yes" size="40"  message="Please enter a Facility Owner Name."></font></td>
      </tr>
	       <tr>
        <td width="134" valign="top" align="right" height="28">
          <p style="margin-right: 3; margin-top: 3"><b><font size="2" face="Arial">Contact Name:*</font></b></td>
        <td width="452" valign="top" height="28">
          <p style="margin-top: 3"><font size="2" face="Arial"><cfinput type="Text" name="contactname" value="" required="yes" size="40"  message="Please enter a Contact Name."></font></td>
      </tr> 
	   <tr>
        <td width="134" valign="top" align="right" height="28">
          <p style="margin-right: 3; margin-top: 3"><b><font size="2" face="Arial">Phone:*</font></b></td>
        <td width="452" valign="top" height="28">
          <p style="margin-top: 3"><font size="2" face="Arial"><cfinput type="Text" name="phonenumber" value="" required="yes" size="12"  message="Please enter a Phone." validate="telephone"></font></td>
      </tr>
      <tr>
        <td width="134" valign="top" align="right" height="28">
          <p style="margin-right: 3; margin-top: 3"><b><font size="2" face="Arial">Fax:</font></b></td>
        <td width="452" valign="top" height="28">
          <p style="margin-top: 3"><font size="2" face="Arial"><cfinput type="Text" name="faxnumber" value="" required="No" size="12" validate="telephone"></font></td>
      </tr> 
	   <tr>
        <td width="134" valign="top" align="right" height="27">
          <p style="margin-right: 3; margin-top: 3"><b><font size="2" face="Arial">E-mail:*</font></b></td>
        <td width="452" valign="top" height="27">
          <p style="margin-top: 3"><font size="2" face="Arial"><cfinput type="Text" name="emailaddress" value="" required="yes" size="40" message="Please enter an E-mail."></font></td>
      </tr>
      <tr>
        <td width="134" valign="top" align="right" height="28">
          <p style="margin-right: 3; margin-top: 3"><font face="Arial" size="2"><b>City:</b></font></td>
        <td width="452" valign="top" height="28">
          <p style="margin-top: 3"><font face="Arial" size="2"><cfinput type="Text" name="city" value="" required="No" size="20"></font></td>
      </tr>
	   <cfquery name="st" datasource="#application.datasource#">
		select stateID, fullname
		from state_master
		where stateID <> '66'
		order by sort
		</cfquery>
      <tr>
        <td width="134" valign="top" align="right" height="42">
          <p style="margin-right: 3; margin-top: 3"><font face="Arial" size="2"><b>State:</b></font></td>
        <td width="452" valign="top" height="42">
          <p style="margin-top: 3"><font face="Arial" size="2"><cfselect name="stateID" size="1" query="st" value="stateID" display="fullname" ><option value="" selected>&nbsp;</option><option value="66">Not Applicable</option></cfselect><br>
          </font><font face="Arial" size="1">(If outside of US or Canada, please
          select 'Not Applicable')</font></td>
      </tr>
      <tr>
        <td width="134" valign="top" align="right" height="28">
          <p style="margin-right: 3; margin-top: 3"><font face="Arial" size="2"><b>Postal Code:</b></font></td>
        <td width="452" valign="top" height="28">
          <p style="margin-top: 3"><font face="Arial" size="2"><cfinput type="Text" name="postalcode" value="" required="No" size="10"></font></td>
      </tr>
	  <tr>
        <td width="134" valign="top" align="right" height="28">
          <p style="margin-right: 3; margin-top: 3"><b><font size="2" face="Arial">Type of Request:*</font></b></td>
        <td width="452" valign="top" height="28">
          <p style="margin-top: 3">
          	<font size="2" face="Arial">
          		
          	<select name="requesttype" size="1" required>
          	<option value="formalbid" selected>Formal Bid</option>
			<option value="subcontract" >Request for subcontracting quotes</option>
			<option value="rfp" >Request for proposals/qualifications/information</option>
			</select>
			</font></td>
      </tr>
	    <tr>
        <td width="134" valign="top" align="right" height="27">
          <p style="margin-right: 3; margin-top: 3"><b><font size="2" face="Arial">Advertisement/Description of Request:*</font></b></td>
        <td width="452" valign="top" height="27">
          <p style="margin-top: 3"><font size="2" face="Arial"><textarea name="description" required></textarea></font></td>
      </tr><input type="hidden" name="description_required">
	  <tr>
        <td width="134" valign="top" align="right" height="28">
          <p style="margin-right: 3; margin-top: 3"><font face="Arial" size="2"><b>Deadline:*</b></font></td>
        <td width="452" valign="top" height="28">
          <p style="margin-top: 3"><font face="Arial" size="2"><cfinput type="Text" name="deadline" value="" required="yes" size="20"  message="Please enter a Deadline."></font></td>
      </tr>
	   <tr>
        <td width="134" valign="top" align="right" height="27">
          <p style="margin-right: 3; margin-top: 3"><b><font size="2" face="Arial">Other Notes (lead abatement, specific brand requests, etc.):</font></b></td>
        <td width="452" valign="top" height="27">
          <p style="margin-top: 3"><font size="2" face="Arial"><textarea name="othernotes"></textarea></font></td>
      </tr>
	  
      <tr>
        <td width="134" valign="top" align="right" height="30">
          <p style="margin-right: 3; margin-top: 9"></td>
        <td width="452" valign="top" height="30">
          <p style="margin-top: 9"><font face="Arial" size="2"><input type="submit" value="Post" name="update">&nbsp;
          <input type="reset" value="Reset Form" name="reset"></font></td>
      </tr>
    </table>
  </div>
</cfform>    