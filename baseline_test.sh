#!/bin/bash

# Read Command Line Arguments and show usage information if the arguments are passed in wrong (Two usage messsages depending on if the user
# is running the command using -r All or -r Single
usage() { 
	echo "Usage example: ./baseline_test.sh -b Chrome|Firefox -c component-name -l location-name -e local|dev|int|ssr -r All|Single" 1>&2; 
	exit 1; 
	}
	
usage_for_All() {
        echo "Usage example: ./baseline_test.sh -b Chrome|Firefox -e local|dev|int|ssr -r All|Single" 1>&2;
        exit 1;
        }

while getopts "b::c:l:e:r:" o; do
    case "${o}" in
        b)  b=${OPTARG}
	    ;;
	c)
            c=${OPTARG}
            ;;
        l)
            l=${OPTARG}
            ;;
	e)  e=${OPTARG}
	    ;;
	r)  r=${OPTARG}
	    ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
# If the user is running the script without -r All and didn't provide the required options
if [ "${r}" != "All" ]; then
	if [ -z "${b}" ] || [ -z "${c}" ] || [ -z "${l}" ] || [ -z "${e}" ] || [ -z "${r}" ]; then
    usage
	fi
fi
# If the user used -r All and didn't provide -e and -b
if [ "${r}" == "All" ]; then
        if [ -z "${b}" ] || [ -z "${e}" ]; then
        usage_for_All
        fi
fi

# Write variables used to screen
echo "c = ${c}"
echo "l = ${l}"
echo "e = ${e}"
echo "b = ${b}"
echo "r = ${r}"

# If run type is All then run docker script with Katalon Test suite for for All component data else run the Katalon Test Suite for single component (passing in the component name and component location as global variables)
case $r in
	All)
		docker run -t --rm -v "$(pwd)":/tmp/source -w /tmp/source -v "$(pwd)/Screenshots":/tmp/katalon_execute/project/Screenshots -v "$(pwd)/Baseline_Images":/tmp/katalon_execute/project/Baseline_Images katalonstudio/katalon katalon-execute.sh -browserType=$b -retry=0 -statusDelay=15 -testSuitePath="Test Suites/Visual BaseLine Analysis/baseline_test_ALL" -executionProfile=$e
		;;
	Single)
		docker run -t --rm -v "$(pwd)":/tmp/source -w /tmp/source -v "$(pwd)/Screenshots":/tmp/katalon_execute/project/Screenshots -v "$(pwd)/Baseline_Images":/tmp/katalon_execute/project/Baseline_Images katalonstudio/katalon katalon-execute.sh -browserType=$b -retry=0 -statusDelay=15 -testSuitePath="Test Suites/Visual BaseLine Analysis/baseline_test" -g_componentName=$c -g_componentLocation=$l -executionProfile=$e
		;;
	*)
		usage
		;;
esac
