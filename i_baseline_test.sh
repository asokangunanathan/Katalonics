#!/usr/bin/env bash
#set -xe
# Read Api Key needed to integrate Katalon with Slack and other pluggins

file="slack_apiKey" # File where the slack Api Key is stored
slack_apiKey=$(cat "$file")   #the output of 'cat $file' is assigned to the slack_apiKey variable

# Ask user to select browser
PS3='Create Baseline Image:  Choose Browser: '
run_options=("Chrome" "Firefox" "Quit")
select opt in "${run_options[@]}"
do
    case $opt in
        "Chrome")
        	browserName="Chrome"
            break
            ;;
        "Firefox")
        	browserName="Firefox"	
			break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

# Ask user to select environment
PS3='Create Baseline Image:  Choose Execution Profile: '
run_options=("local" "dev" "int" "ssr" "Quit")
select opt in "${run_options[@]}"
do
    case $opt in
        "local")
        	environment="local"
            break
            ;;
        "dev")
        	environment="dev"	
			break
            ;;
        "int")
        	environment="int"	
			break
            ;;
        "ssr")
        	environment="ssr"	
			break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

#Ask user to select script and run on Docker
PS3='Baseline Image Analysis:  Please select an option: '
options=("All Component Data" "Individual Component" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "All Component Data")
				echo -n "!!! Are you sure you want to Run for All Components? (y/n)? !!!"
				read answer
				if [ "$answer" != "${answer#[Yy]}" ] ;then
    				docker run -t --rm -v "$(pwd)":/tmp/source -w /tmp/source -v "$(pwd)/Screenshots":/tmp/katalon_execute/project/Screenshots -v "$(pwd)/Baseline_Images":/tmp/katalon_execute/project/Baseline_Images katalonstudio/katalon katalon-execute.sh -browserType=$browserName -retry=0 -statusDelay=15 -testSuitePath="Test Suites/Visual BaseLine Analysis/baseline_test_ALL" -executionProfile=$environment -apiKey=$slack_apiKey
				else
    				echo "Exiting..."
				fi
            break
            ;;
        "Individual Component")	
			echo "Enter Component Name:"
			read component_name
			echo "Enter Component Location:"
			read component_location
			docker run -t --rm --net=host -v "$(pwd)":/tmp/source -w /tmp/source -v "$(pwd)/Screenshots":/tmp/katalon_execute/project/Screenshots -v "$(pwd)/Baseline_Images":/tmp/katalon_execute/project/Baseline_Images katalonstudio/katalon katalon-execute.sh -browserType=$browserName -retry=0 -statusDelay=15 -testSuitePath="Test Suites/Visual BaseLine Analysis/baseline_test" -g_componentName=$component_name -g_componentLocation=$component_location -executionProfile=$environment -apiKey=$slack_apiKey
			break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
