#!/bin/sh

count=`curl -X GET "https://eval.contrastsecurity.com/Contrast/api/ng/442311fd-c9d6-44a9-a00b-2b03db2d816c/traces/f17571b8-eb60-4767-81c7-230c6576fd47/?expand=skip_links" \
        -H "Authorization: dHVyYm91QGkuc29mdGJhbmsuanA6TDBGUUZZN1JGRVBOQUI4RQ==" \
        -H "API-Key: EFhK6pIuD6mh5RX6YQ2iMOOavh9Mc52u" \
        | jq '[.traces[] | select(.default_severity | test("CRITICAL|HIGH")) | .uuid] | length'`
echo $count

exit 0

