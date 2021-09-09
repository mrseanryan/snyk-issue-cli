# snyk-issue-cli

Simple Unix CLI to show security issues from Snyk for projects for our organisation

## Dependencies

| What | Details |
|---|---|
| OS | Unix (tested on Mac) |
| curl | The Unix command line tool to download from a URL |
| jq | The Unix command line to process JSON |

## Setup

1. Install the dependencies, if they are missing

2. Create a file `api_token.txt` that contains your Snyk API key

3. Create a file `org_id.txt` that contains the ID of your Snyk 'organisation'.

4. Create a file `jq_project_filter.txt` that contains a jq filter on your Snyk project names.

Example:

```
contains("MyProject1") or contains("Project2")
```

## Usage

`go.sh`

Example output:

```
src/my-project(master):my-app/My.Project.One/My.Project.One.csproj
"Vulnerability: Remote Code Execution (RCE) in System.Text.Encodings.Web@4.6.0 - https://snyk.io/vuln/SNYK-DOTNET-SYSTEMTEXTENCODINGSWEB-1253267"
---------
src/my-project(release/1.1):my-app/My.Project.One.View/My.Project.One.View.csproj
"Vulnerability: Regular Expression Denial of Service (ReDoS) in RestSharp@106.6.9 - https://snyk.io/vuln/SNYK-DOTNET-RESTSHARP-1316436"
---------
src/my-project(release/1.1):modeler/My.Project.One/My.Project.One.csproj
"Vulnerability: Regular Expression Denial of Service (ReDoS) in RestSharp@105.0.1 - https://snyk.io/vuln/SNYK-DOTNET-RESTSHARP-1316436"
"Vulnerability: Denial of Service (DoS) in RestSharp@105.0.1 - https://snyk.io/vuln/SNYK-DOTNET-RESTSHARP-1316436"
```
