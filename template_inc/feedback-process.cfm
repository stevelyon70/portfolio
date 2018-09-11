<cfmail to="jbirch@paintsquare.com, slyon@technologypub.com, rmahathey@technologypub.com" from="error@paintbidtracker.com" subject="Beta360 Feedback" type="HTML">
	User Name: #session.auth.name#<br>
	User Id: #session.auth.userID#<br><br>
	Page Name: #form.pagename#<br><br>
	User Feedback: #form.feedback#<br>
</cfmail>