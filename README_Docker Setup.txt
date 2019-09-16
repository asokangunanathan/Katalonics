by: Asokan Gunanathan

Setup needed to run Katalon on Docker:
1) Install Docker (https://docs.docker.com/docker-for-mac/install/)
2) Use command: "docker pull katalonstudio/katalon" to create a docker container for Katalon Studio (Image contains Google Chrome, 
Mozilla Firefox, Xvfb and Katalon Studio)

That's all it takes for setup!!!


Now about how to Run Katalon Studio Scripts on Docker:

There are two groups of scripts created for convenience (interactive and non-interactive).  The non-interactive scripts will be useful for running the 
scripts in a CI pipeline or for users who are comfortable in running scripts in a non-interactive way.

Interactive scripts:
1) i_baseline_test.sh           

	Creates an actual(current) image at a specified environment with a specified browser and compares that image to an existing baseline image with the specification.
	The test passes if the images are identical.  If the images are different the actual(current) file and a diff file can be viewed in the Screenshots folder to 
	troubleshoot further.
	

2) i_create_baseline_image.sh
	
	This script is used to create a new baseline image or to update a baseline image.  Environment and browser type can be specified while running the script interactively.
	

To run the scripts go to project folder and type ./i_baseline_test.sh or ./i_create_baseline_image.sh

**NOTE: Selecting All Component Data" will initiate Data Drive Test using the Data file and it will take a relatively long time
to run.


Non-interactive scripts:
1) baseline_test.sh
2) create_baseline_image.sh

The non-interactive scripts were created so that we can have the ability to run these scripts in a CI pipeline.
Usage:

example: ./baseline_test.sh -b Chrome -c component-name -l location-name -e dev -r Single

-b : Browser Type - Can either be Chrome or Firefox
-c : Component Name - for example: my-examples
-l : Location Name - This is the location where type-ahead is nested in.  For example "p" in https://katalonics.blogspot.com/p/katalon-studio.html
-e : Execution Profile - Currently there are 4 execution profiles setup in Katalon : dev, int, local, and ssr
-r : run type Single or All - used to specify if you are running for an individual component (Single) or for All data found in the component data file used for
	 Data driven testing
	 
	  