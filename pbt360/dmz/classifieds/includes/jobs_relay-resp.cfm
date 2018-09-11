
<!---Relay repsonse from Authorize.net.
****************************************************************
SIM Developer Guide located at http://developer.authorize.net.

Note, if supplierID is defined, it will be passed via x_cust_id;
If reg_userID is defined, it will also be passed via x_cust_id;
If another parameter is needed for confirmation page processing, 
it will be passed via x_po_num and/or x_invoice_num
****************************************************************
--->

<!---Grab Authorize.net response from post from secure gateway--->
<cfparam name="FORM.x_response_code" default="">
<cfparam name="FORM.x_response_reason_code" default="">
<cfparam name="FORM.x_response_reason_text" default="">
<cfparam name="FORM.x_auth_code" default="">
<cfparam name="FORM.x_avs_code" default="">
<cfparam name="FORM.x_trans_id" default="">
<cfparam name="FORM.x_invoice_num" default="">
<cfparam name="FORM.x_description" default="">
<cfparam name="FORM.x_amount" default="">
<cfparam name="FORM.x_method" default="">
<cfparam name="FORM.x_cust_id" default="">
<cfparam name="FORM.x_first_name" default="">
<cfparam name="FORM.x_last_name" default="">
<cfparam name="FORM.x_company" default="">
<cfparam name="FORM.x_address" default="">
<cfparam name="FORM.x_city" default="">
<cfparam name="FORM.x_state" default="">
<cfparam name="FORM.x_zip" default="">
<cfparam name="FORM.x_country" default="">
<cfparam name="FORM.x_phone" default="">
<cfparam name="FORM.x_fax" default="">
<cfparam name="FORM.x_email" default="">
<cfparam name="FORM.x_po_num" default="">

<!---Set redirect values for relevant confirmation/processing page--->
<cfswitch expression="#page#">
	<cfcase value="post_job">
		<cfset temp_url_str = "">
		<cfswitch expression="#x_response_code#">
			<cfcase value="1">
				<cfset confirm_url="http://www.paintbidtracker.com/classifieds/index.cfm?fuseaction=jobs&action=post&process=4">
			</cfcase>
			<cfcase value="2">
				<cfset confirm_url="http://www.paintbidtracker.com/classifieds/index.cfm?fuseaction=jobs&action=post&process=5">
			</cfcase>
			<cfcase value="3">
				<cfset confirm_url="http://www.paintbidtracker.com/classifieds/index.cfm?fuseaction=jobs&action=post&process=5">
			</cfcase>
			<cfcase value="4">
				<cfset confirm_url="http://www.paintbidtracker.com/classifieds/index.cfm?fuseaction=jobs&action=post&process=5">
			</cfcase>
		</cfswitch>
	</cfcase>
	<cfcase value="edit_job">
		<cfset temp_url_str = "">
		<cfswitch expression="#x_response_code#">
			<cfcase value="1">
				<cfset confirm_url="http://www.paintbidtracker.com/classifieds/index.cfm?fuseaction=jobs&action=edit&process=4">
			</cfcase>
			<cfcase value="2">
				<cfset confirm_url="http://www.paintbidtracker.com/classifieds/index.cfm?fuseaction=jobs&action=edit&process=5">
			</cfcase>
			<cfcase value="3">
				<cfset confirm_url="http://www.paintbidtracker.com/classifieds/index.cfm?fuseaction=jobs&action=edit&process=5">
			</cfcase>
			<cfcase value="4">
				<cfset confirm_url="http://www.paintbidtracker.com/classifieds/index.cfm?fuseaction=jobs&action=edit&process=5">
			</cfcase>
		</cfswitch>
	</cfcase>
</cfswitch>

<!---Re-post Authorize.net response to page on PaintSquare site--->
<cfform name="form1" method="post" action="#confirm_url#">
	<cfinput type="hidden" name="x_response_code" value="#form.x_response_code#">
	<cfinput type="hidden" name="x_response_reason_code" value="#form.x_response_reason_code#">
	<cfinput type="hidden" name="x_response_reason_text" value="#form.x_response_reason_text#">
	<cfinput type="hidden" name="x_auth_code" value="#form.x_auth_code#">
	<cfinput type="hidden" name="x_avs_code" value="#form.x_avs_code#">
	<cfinput type="hidden" name="x_trans_id" value="#form.x_trans_id#">
	<cfinput type="hidden" name="x_invoice_num" value="#form.x_invoice_num#">
	<cfinput type="hidden" name="x_description" value="#form.x_description#">
	<cfinput type="hidden" name="x_amount" value="#form.x_amount#">
	<cfinput type="hidden" name="x_method" value="#form.x_method#">
	<cfinput type="hidden" name="x_cust_id" value="#form.x_cust_id#">
	<cfinput type="hidden" name="x_first_name" value="#form.x_first_name#">
	<cfinput type="hidden" name="x_last_name" value="#form.x_last_name#">
	<cfinput type="hidden" name="x_company" value="#form.x_company#">
	<cfinput type="hidden" name="x_address" value="#form.x_address#">
	<cfinput type="hidden" name="x_city" value="#form.x_city#">
	<cfinput type="hidden" name="x_state" value="#form.x_state#">
	<cfinput type="hidden" name="x_zip" value="#form.x_zip#">
	<cfinput type="hidden" name="x_country" value="#form.x_country#">
	<cfinput type="hidden" name="x_phone" value="#form.x_phone#">
	<cfinput type="hidden" name="x_fax" value="#form.x_fax#">
	<cfinput type="hidden" name="x_email" value="#form.x_email#">
	<cfinput type="hidden" name="x_po_num" value="#form.x_po_num#">
	<cfif isdefined("jobID") and jobID is not ""><cfinput type="hidden" name="jobID" value="#jobID#"></cfif>
	<cfif isdefined("expiration_date") and expiration_date is not ""><cfinput type="hidden" name="expiration_date" value="#expiration_date#"></cfif>
</cfform>
<script> 
document.form1.submit(); 
</script> 


