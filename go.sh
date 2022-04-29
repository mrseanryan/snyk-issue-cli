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

	# note: the tutorial at https://snyk.io/blog/using-the-snyk-api-to-get-your-vulnerabilities/ uses /issues 
	# but that stopped working and is not mentioned in the API docs! - see https://snyk.docs.apiary.io/#reference/projects/activate-an-individual-project/list-all-aggregated-issues
	_url=https://snyk.io/api/v1/org/$_org_id/project/$pid/aggregated-issues

	echo "---------"
	echo $pname

	# xxx for debugging
	#echo $_url
	#curl --silent --request POST \
	#   --header "Content-Type: application/json" \
	#   --header "Authorization: token $_api_token" \
	#   -d '{ "includeDescription": false, "includeIntroducedThrough": true }' \
	#   $_url

	curl --silent --request POST \
	   --header "Content-Type: application/json" \
	   --header "Authorization: token $_api_token" \
	   -d '{ "includeDescription": false, "includeIntroducedThrough": true }' \
	   $_url \
	  | jq '"Vulnerability: [\(.issues[].issueData.severity)] \(.issues[].id) \"\(.issues[].issueData.title)\" in \(.issues[].pkgName)@\(.issues[].pkgVersions)"'

done < $_temp_file

_project_count=`wc -l < project_ids.txt.tmp`
echo $_project_count projects found
