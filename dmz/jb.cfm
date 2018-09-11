<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Untitled Document</title>
</head>

<body>
<cfdump var="#application#" />
<cfdump var="#session#" />
<cfdump var="#request#" />
<cfdump var="#url#" />
<cfhttp url="https://slack.com/api/chat.postMessage?token=xoxp-8493706871-103523458545-317528084049-01cc16aecbb546fb57620598fe6275d7&channel=%23pbt_tech_issues&text=BidNoticesDailyEmail%20send%20begin.&pretty=1" method="GET"/>

</body>
</html>
