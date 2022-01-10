#!/bin/sh

APP_VERSION="CODEBUILD_TEST_$1"
ORG_ID="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
APP_ID="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
count=`curl -s -X GET "https://eval.contrastsecurity.com/Contrast/api/ng/${ORG_ID}/traces/${APP_ID}/ids?appVersionTags=${APP_VERSION}&severities=CRITICAL" \
        -H "Authorization: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX==" \
        -H "API-Key: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
        | jq '[.traces[]] | length'`
echo $count
if [ $count -gt 0 ]; then
  exit 1
fi

exit 0

