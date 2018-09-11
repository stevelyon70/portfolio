	
<cfif isdefined("ref") and ref is 2>
	<cfset rootref = "../search/">
<cfelse>
	<cfset rootref = "../search/">
</cfif>

<script>
    submitForm2 = function() {
        ColdFusion.Ajax.submitForm('RFPManagement2', '<cfoutput>#rootref#</cfoutput>includes/submitCreateFolder.cfm', callback,
            errorHandler);
    }
    
    function callback(text)
    {
        //alert("Callback: " + text);
		
			ColdFusion.Window.hide('folderSave')
			window.location.reload()
		
    }
    
    function errorHandler(code, msg)
    {
        alert("Error!!! " + code + ": " + msg);
    }
</script>






<cfoutput>
<CFSET DATE = #CREATEODBCDATETIME(NOW())#>
<cfform NAME="RFPManagement2">
				  <TABLE width="100%" border=0>
				 	<cfinput type="hidden" value="#userid#" name="userid">
					<cfif isdefined("bidID")>
						<cfinput type="hidden" value="#bidid#" name="bidid">
					</cfif>
				  <tr><td><font size="2" face="arial"><b><h3>Create a New Folder:</h3></b></font></td></tr>
				  <tr>
				  <td><font size="2" face="arial"><b>Name:*</b></font></td>
				   </tr>
				   <tr>
				   <td><cfinput type="Text" name="foldername" message="Please name the folder." required="Yes" size="30" requiredmessage="Please name the folder"></td>
				</tr>
				<tr>
				   <td><font size="2" face="arial"><b>Folder Description:</b></font></td>
				</tr><cfif isdefined("ref") and ref is 2><input type="hidden" name="ref" value="2"></cfif>
			 <tr>
				   <td><textarea cols="30" rows="5" name="description"></textarea></td>
				</tr>
				  <tr><td><br><font size="2" face="arial"><b>Security Settings:</b></font><!---img src="images/security_settings.gif"---></td></tr>
				  <tr>
				  <td><font size="2" face="arial">Select the security settings for this folder:</font></td>
				   </tr>
				 <tr>
				   <td><cfinput type="radio" name="share" value="2" checked="Yes">
				   <font size="2" face="arial"> I would like this folder to be private.</font></td>
				</tr>
				   <tr>
				   <td><cfinput type="radio" name="share" value="1" >
				  <font size="2" face="arial">  I would like all users on our account to have access to this folder.</font></td>
				</tr>
				
				 <tr>
				   <td><cfinput type="radio" name="share" value="3" >
				 <font size="2" face="arial">  I would like the following users on our account to have access to this folder.</font></td>
				</tr>
				 <tr> 
				 <!---select bid_users.userid,reg_users.name from bid_users  left outer join reg_users on reg_users.reg_userid = bid_users.reguserid where bid_users.sid in (select sid from bid_users where userid = #userid# and bt_status = 1) and reg_users.name is not null order by reg_users.name--->
				<cfquery name="getusers" datasource="#application.datasource#">
				select distinct reg_users.name,bid_users.userid
				from reg_users 
				inner join bid_users on bid_users.reguserid = reg_users.reg_userid
				left outer join bid_subscription_log on bid_subscription_log.userid = bid_users.userid 
				where bid_users.sid in (select sid from bid_users where userid = #userid# and bt_status = 1) and bid_subscription_log.effective_date <= #date# and bid_subscription_log.expiration_date > #date# and bid_subscription_log.active = 1
				and bid_users.bt_status = 1
				order by reg_users.name
				</cfquery>
				   <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfselect name="specific_users" query="getusers" value="userid" display="name" multiple size="5"></cfselect></td>
				  
				</tr>
				
				 
			
				<tr><td><br><input type="submit" name="submit" onclick="javascript:submitForm2()" value="Save"  class="btn btn-primary">&nbsp;<input type="reset" value="Reset" class="btn btn-default"></td></tr>
				
				  </table>
</cfform>
</cfoutput>