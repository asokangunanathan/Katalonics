#!/bin/bash
# Read Api Key needed to integrate Katalon with Slack and other pluggins

file="slack_apiKey" # File where the slack Api Key is stored
slack_apiKey=$(cat "$file")   #the output of 'cat $file' is assigned to the slack_apiKey variable

# Read Command Line Arguments and show usage information if the arguments are passed in wrong (Two usage messsages depending on if the user
# is running the command using -r All or -r Single
usage() { 
	echo "Usage example: ./i_functional_test.sh -b Chrome|Firefox -e local|dev|int|ssr" 1>&2; 
	exit 1; 
	}

while getopts "b:e:" o; do
    case "${o}" in
        b)  b=${OPTARG}
	    ;;
	e)  e=${OPTARG}
	    ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
# If the user didn't provide the required options
if [ "${r}" != "All" ]; then
	if [ -z "${b}" ] || [ -z "${e}" ]; then
    usage
	fi
fi

# Write variables used to screen
echo "e = ${e}"
echo "b = ${b}"

docker run -t --rm -v "$(pwd)":/tmp/source -w /tmp/source -v "$(pwd)/Screenshots":/tmp/katalon_execute/project/Screenshots -v "$(pwd)/Baseline_Images":/tmp/katalon_execute/project/Baseline_Images katalonstudio/katalon katalon-execute.sh -browserType=$b -retry=0 -statusDelay=15 -testSuitePath="Test Suites/Functional Tests/my_functional_tests" -executionProfile=$e -apiKey=$slack_apiKey
	
