// To make this script run in Fiji, please activate 
// the clij and clij2 update sites in your Fiji 
// installation. Read more: https://clij.github.io

// Generator version: 2.5.1.1

// Init GPU
run("CLIJ2 Macro Extensions", "cl_device=AMD");

// Load image from disc 
open("/Users/fernandesm/Documents/5x FAD gr3 5.tif");


rename("original");

image_1 = getTitle();
Ext.CLIJ2_pushCurrentZStack(image_1);
// The following auto-generated workflow is made for processing a 2D or 3D dataset.
// For processing multiple channels or time points, you need to program a for-loop.
// You can learn how to do this online: https://www.youtube.com/watch?v=ulSq-x5_in4

// Copy
Ext.CLIJ2_copy(image_1, image_2);
Ext.CLIJ2_release(image_1);

Ext.CLIJ2_pull(image_2);

// Copy
Ext.CLIJ2_copy(image_2, image_3);
Ext.CLIJ2_release(image_2);

Ext.CLIJ2_pull(image_3);

// Top Hat Box
radiusX = 10.0;
radiusY = 10.0;
radiusZ = 10.0;
Ext.CLIJ2_topHatBox(image_3, image_4, radiusX, radiusY, radiusZ);
Ext.CLIJ2_release(image_3);

Ext.CLIJ2_pull(image_4);

// Threshold Otsu
Ext.CLIJ2_thresholdOtsu(image_4, image_5);
Ext.CLIJ2_release(image_4);

Ext.CLIJ2_pull(image_5);

// Erode Box
Ext.CLIJ2_erodeBox(image_5, image_6);

Ext.CLIJ2_pull(image_6);
Ext.CLIJ2_release(image_6);

// Connected Components Labeling Box
Ext.CLIJ2_connectedComponentsLabelingBox(image_5, image_7);
Ext.CLIJ2_release(image_5);

Ext.CLIJ2_pull(image_7);
Ext.CLIJ2_release(image_7);


run("Duplicate...", " ");
run("Set Measurements...", "area mean standard min redirect=[original] decimal=3");
setOption("ScaleConversions", true);
run("8-bit");
setOption("BlackBackground", true);
setAutoThreshold("Default dark");
//run("Threshold...");
setAutoThreshold("Otsu dark");
//setThreshold(32, 255);
run("Convert to Mask");


run("Find Maxima...", "prominence=10 output=[Maxima Within Tolerance]");
run("Find Edges");
run("Fill Holes");

run("Set Measurements...", "area mean standard min centroid center fit area_fraction redirect=original decimal=3");
run("Analyze Particles...", "size=0.0001-1  show=Outlines display exclude clear summarize add");

Ext.CLIJ2_clear();
