/* This macro counts the number of plaques 
 *  in a folder with multiple 2D images
 *  
Author: Miguel Fernandes (IDAF)
Date: 10 Sep 2021
*/
/*
Usage:
There should not be any " " in your directory or file names
At the moment working for 2D image data

Only one channel is expected to perform analysis
Keep it consistent across experiments!

Run this macro and select a folder containing imaging files
(inputFolder)

Select type of input stacks with the format defined in suffix
(example .tif files)

Select output folder to save results for each individual file and summary across all images
(outputFolder)

At the moment only for 2D but in principle could be extended to 3D

TODO: improve documentation for each step

*/


#@ File (label="Select a folder to process", style="directory") inputFolder
#@ String (label = "File suffix input folder", value = ".tif") suffix
#@ File (label="Select a folder to save results", style="directory") outputFolder


dir=File.getDirectory(inputFolder);
print (inputFolder);


print("User selected input folder: " + inputFolder);
print("User selected save folder: " + outputFolder);


setBatchMode(true); //batch mode on


//get file list from input folder
fileList=getFileList(inputFolder);


for (i = 0; i < lengthOf(fileList); i++) {
	
	fileName=fileList[i];
	
	//check if file is correct one
    if (endsWith(fileName, suffix)) {
    	path=inputFolder + "/"+ fileList[i];
    	print(fileName,"is a " + suffix + " file");
         
		// open file
		open(path);

		count_rois();

    }
    else {
    	print(fileList[i],"is NOT a"+ suffix + " file.");
    }
    close("*"); //close all images
                
}

selectWindow("Summary");
	
// save the results table to saveDir using saveAs() 
saveAs("Results", outputFolder +"/" + "Summary.csv");


//close all windows including results at the end
list = getList("window.titles");
	   for (i=0; i<list.length; i++){
	    winame = list[i];
	     selectWindow(winame);
	    run("Close");
		}
		
print ("FINISHED ALL FILES")


setBatchMode(false); //exit batch mode


function count_rois() {
input = getTitle();
			
// get image name without extension
nameOnly = File.nameWithoutExtension;
rename("original");

run("8-bit");
run("Morphological Filters", "operation=[White Top Hat] element=Square radius=2");
run("Subtract Background...", "rolling=50");

run("Find Maxima...", "prominence=10 output=[Maxima Within Tolerance]");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");

setAutoThreshold("Otsu dark");
//setThreshold(41, 255);
setOption("BlackBackground", true);
run("Convert to Mask");

//label the ROIs
run("Connected Components Labeling", "connectivity=4 type=[16 bits]");
run("glasbey on dark");


run("Duplicate...", " ");


run("Find Maxima...", "prominence=10 output=[Maxima Within Tolerance]");
run("Fill Holes");

run("Set Measurements...", "area mean standard min centroid center fit area_fraction redirect=original decimal=3");
run("Analyze Particles...", "size=0.0001-1  show=Outlines display exclude clear summarize add");

selectWindow("original-White-lbl-1 Maxima");
run("Outline");

imageCalculator("Add create 32-bit", "original","original-White-lbl-1 Maxima");
//change lookup table
run("HiLo");

setMinAndMax(0, 100);

saveAs("tif", outputFolder+"/ROIs_"+nameOnly);
	
// introduce a variable tableName for the results table custom-name
tableName = "Results_Stats" + "_" + nameOnly;
	
// save the results table to saveDir using saveAs() 
saveAs("Results", outputFolder +"/" + tableName + ".csv");

}