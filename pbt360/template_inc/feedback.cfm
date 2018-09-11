	<cfset _url = cgi.server_name & cgi.script_name & cgi.query_string>
	<div id="feedback">
		<div id="feedback-form" style='display:none;' class="col-xs-4 col-md-4 panel panel-default">
			<form method="POST" action="../template_inc/feedback-process.cfm" class="form panel-body" role="form">
				<input type="hidden" name="pagename" value="<cfoutput>#_url#</cfoutput>">
				<!---<div class="form-group">
					<input class="form-control" name="email" autofocus placeholder="Your e-mail" type="email" />
				</div>--->
				<div class="form-group">
					<textarea class="form-control" name="feedback" required placeholder="Please enter your feedback here..." rows="3"></textarea>
					<span id="message" style="color:red"></span>
				</div>
				<button class="btn btn-primary pull-right" type="submit">Send</button>
			</form>
		</div>
		<div id="feedback-tab">Feedback</div>
	</div>