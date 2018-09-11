<cfinvoke  
		component="#Application.CFCPath#.engineer_profile"  
		method="pull_company_details"  
		returnVariable="getContractor"> 
				<cfinvokeargument name="engineerID" value="#url.engineerID#"/> 
	</cfinvoke>
<cfoutput>
<cfsavecontent variable="card">
BEGIN:VCARD
VERSION:3.0
N:User;Name
FN:#getContractor.companyname#
ORG:#getContractor.companyname#
URL:#getContractor.WEBSITEURL#
EMAIL:#getContractor.EMAILADDRESS#
TEL;TYPE=voice,work,pref:#getContractor.PHONENUMBER#
ADR;TYPE=intl,work,postal,parcel:;;#getContractor.BILLINGADDRESS#;#getContractor.city#;#getContractor.state#;#getContractor.zipcode#;
END:VCARD
</cfsavecontent>
</cfoutput>

<cffile action = "write"
file = "#expandpath('./cards')#/#url.engineerID#.vcf"
output = "#card#" nameconflict="OVERWRITE">


<cflocation url="cards/#url.engineerID#.vcf" />