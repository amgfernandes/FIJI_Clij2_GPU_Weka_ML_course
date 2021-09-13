run("8-bit");
run("Duplicate...", " ");
run("Subtract Background...", "rolling=50");
setAutoThreshold("Default");
setAutoThreshold("Default dark");
//run("Threshold...");
setAutoThreshold("Otsu dark");
//setThreshold(47, 255);
setOption("BlackBackground", true);
run("Convert to Mask");

