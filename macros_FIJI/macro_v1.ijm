//get title of current image
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

//extract ROIs
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
run("Hi");

setMinAndMax(0, 100);
