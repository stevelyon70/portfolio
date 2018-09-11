<cfset clientid = "843781046083363553ef9d6e725312b6cac09b18d1dafa2edf1e7aa93cf18a2e"/>
<cfset secret = "31daab6f2413b79265e595546705f927b08c68f12263d886608f08b0b07a8b4d"/>

<cfhttp method="post" url="https://technologypublishing.bime.io/oauth/token?client_id=your-client-id&redirect_uri=your-redirect-uri&client_secret=your-client-secret&code=verification-code" result="local.test">
    <cfhttpparam type="formfield" name="client_id" value="#clientid#" >
	 <cfhttpparam type="formfield" name="redirect_uri" value="http://127.0.0.1:8500/contrak/template_inc/test_api.cfm" >
	  <cfhttpparam type="formfield" name="client_secret" value="#secret#" >
	  <cfhttpparam type="formfield" name="code" value="#code#" >
    
</cfhttp>



<cfdump var="#local.test#">


<iframe frameBorder="0" seamless id="frame1" name="frame1" scroll="no" height=820px width=1600px  src="https://technologypublishing.bime.io/dashboard/brand-share"></iframe>
					