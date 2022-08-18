

run("Close All");
run("Clear Results");

inputFolder = getDirectory("");
images = getFileList(inputFolder);

dir = inputFolder + "quantification";
File.makeDirectory(dir);

setBatchMode(true);
kk = 1;
for (i=0; i<images.length; i++){
	if (endsWith(images[i], ".czi")) {
	
		inputPath = inputFolder + images[i];
		//open(inputPath);
		
		run("Bio-Formats Importer", "open=inputPath autoscale color_mode=Grayscale rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

		rename("image");
		run("Z Project...", "projection=[Max Intensity]");
		run("8-bit");
		run("Split Channels");
		selectWindow("C2-MAX_image");

		run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'C2-MAX_image', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");

		selectWindow("C1-MAX_image");

		numROIs = roiManager("count");
		//print(numROIs);
		for(k=0; k<numROIs; k++) {// loop through ROIs
			selectWindow("C1-MAX_image");
			roiManager("Select", k);
			//run("Duplicate...", " ");
			run("Duplicate...", "title=" + images[i] + "_" + kk);
			kk = kk + 1;
			setAutoThreshold("Otsu dark");
			setOption("BlackBackground", false);
			run("Convert to Mask");
			//run("Watershed");
			run("Set Measurements...", "area display redirect=None decimal=3");
			run("Analyze Particles...", "  show=Outlines display");
			//selectWindow("C1-MAX_image-1");
			//close();
			//selectWindow("Drawing of C1-MAX_image-1");
			//close();
		}
		run("Close All");
		//saveAs("Results", dir + "/" + images[i] + ".txt");
		//run("Clear Results");
	}
}

saveAs("Results", dir + "/data" + ".txt");


