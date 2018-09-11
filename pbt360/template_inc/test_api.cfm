<cfset clientid = "843781046083363553ef9d6e725312b6cac09b18d1dafa2edf1e7aa93cf18a2e"/>
<cfset secret = "31daab6f2413b79265e595546705f927b08c68f12263d886608f08b0b07a8b4d"/>

<cfhttp method="get" url="https://api.bime.io/v3/dashboards?access_token=842061b3b8907bd495ec674fe83d3476585b2bb45987c2839c1b6f2272a063c4" result="local.test">
	
	 <cfhttpparam type="header" name="Content-Type" value="application/json" >

	 
    
</cfhttp>

<cfdump var="#local.test#">


<iframe frameBorder="0" seamless id="frame1" name="frame1" scroll="no" height=820px width=1600px  src="https://technologypublishing.bime.io/dashboard/brand-share?access_token=579ef9e09d922d5edbba23f1ad16a74cccc402d14583d583ece645ed72c5a2c2"></iframe>
					