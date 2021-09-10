echo Getting projects, filtered...

# READ CONFIG
_api_token=`cat ./api_token.txt`
_org_id=`cat ./org_id.txt`
_jq_project_filter=`cat ./jq_project_filter.txt`

_temp_file=./project_ids.txt.tmp

#################################################
# Assist projects!  (IDs and Names)
# List projects in "AppDev Studio Pro" - Assist OR Mars OR DPA
curl --silent --request POST \
     --header "Content-Type: application/json" \
     --header "Authorization: token $_api_token" \
  "https://snyk.io/api/v1/org/$_org_id/projects" | jq ".projects[] | {name: .name, id: .id} | select(.name | $_jq_project_filter)" | jq '"\(.id);\(.name)"' > $_temp_file

echo Getting issues for each project...

while IFS= read -r line
do
	# use xargs to strip quotes
	line2=`echo $line | xargs`

	# split by ;
	arrIN=(${line2//;/ })
	pid=${arrIN[0]}
	pname=${arrIN[1]}

	_url=https://snyk.io/api/v1/org/$_org_id/project/$pid/issues

	echo "---------"
	echo $pname
	# echo $_url

	curl --silent --request POST \
	   --header "Content-Type: application/json" \
	   --header "Authorization: token $_api_token" \
	   $_url \
	  | jq '"Vulnerability: \(.issues.vulnerabilities[].title) in \(.issues.vulnerabilities[].package)@\(.issues.vulnerabilities[].version) - \(.issues.vulnerabilities[].url)"'

done < $_temp_file

_project_count=`wc -l < project_ids.txt.tmp`
echo $_project_count projects found
