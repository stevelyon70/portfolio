<!--- Example to connect to google
---------------------------------------------------------------------------------
1) Assumes there is a CF mapping of oauth pointing to the oauth folder.
2) add your consumerkey and secret
3) change the sScope variable to something else if you want
4) save and run
--->

<!--- set up the parameters --->
<cfset sConsumerKey = "843781046083363553ef9d6e725312b6cac09b18d1dafa2edf1e7aa93cf18a2e"> <!--- the consumer key you got from google when registering you app  --->
<cfset sConsumerSecret = "31daab6f2413b79265e595546705f927b08c68f12263d886608f08b0b07a8b4d"> <!--- the consumer secret you got from google --->
<cfset sTokenEndpoint = "https://api.bime.io/v3/dashboards"> <!--- Access Token URL --->
<cfset sAuthorizationEndpoint = "https://api.bime.io/v3/dashboards"> <!--- Authorize URL --->
<cfset sCallbackURL = "www.paintsquare.com/authorize.cfm"> <!--- where google will redirect to after the user enters their details --->
<cfset sClientToken = ""> <!--- returned after an access token call --->
<cfset sClientTokenSecret = ""> <!--- returned after an access token call --->

<!--- set up the required objects including signature method--->
<cfset oReqSigMethodSHA = CreateObject("component", "oauth.oauthsignaturemethod_hmac_sha1")>
<cfset oToken = CreateObject("component", "oauth.oauthtoken").createEmptyToken()>
<cfset oConsumer = CreateObject("component", "oauth.oauthconsumer").init(sKey = sConsumerKey, sSecret = sConsumerSecret)>

<cfset oReq = CreateObject("component", "oauth.oauthrequest").fromConsumerAndToken(
	oConsumer = oConsumer,
	oToken = oToken,
	sHttpMethod = "GET",
	sHttpURL = sTokenEndpoint)>
<cfset oReq.signRequest(
	oSignatureMethod = oReqSigMethodSHA,
	oConsumer = oConsumer,
	oToken = oToken)>

<cfhttp url="#oREQ.getString()#" method="get" result="tokenResponse"/>

<!--- grab the token and secret from the response if its there--->
<cfif findNoCase("oauth_token",tokenresponse.filecontent)>
	<cfset sClientToken = listlast(listfirst(tokenResponse.filecontent,"&"),"=")>
	<cfset sClientTokenSecret = listlast(listlast(tokenResponse.filecontent,"&"),"=")>

	<!--- you can add some additional parameters to the callback --->
	<cfset sCallbackURL = sCallbackURL & "?" &
		"key=" & sConsumerKey &
		"&" & "secret=" & sConsumerSecret &
		"&" & "token=" & sClientToken &
		"&" & "token_secret=" & sClientTokenSecret &
		"&" & "endpoint=" & URLEncodedFormat(sAuthorizationEndpoint)>

	<cfset sAuthURL = sAuthorizationEndpoint & "?oauth_token=" & sClientToken & "&" & "oauth_callback=" & URLEncodedFormat(sCallbackURL) >

	<cflocation url="#sAuthURL#">
<cfelse>
	<cfoutput>#tokenResponse.filecontent#</cfoutput>
</cfif>
