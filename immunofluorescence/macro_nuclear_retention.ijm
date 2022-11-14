

run("Close All");
run("Clear Results");
delta = 7;

inputFolder = getDirectory("");
images = getFileList(inputFolder);

dir = inputFolder + "quantification";
File.makeDirectory(dir);

//setBatchMode(true);
for (i=0; i<images.length; i++){
	//if (endsWith(images[i], ".czi")) {
	if (endsWith(images[i], ".tif")) {

		inputPath = inputFolder + images[i];
		//open(inputPath);
		run("Bio-Formats Importer", "open=inputPath autoscale color_mode=Grayscale rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

		rename("image");

		n = round((nSlices()/2)/2);
		ini = n - delta;
		fin = n + delta;
		run("Duplicate...", "duplicate slices=ini-fin");
		rename("image2");

		selectWindow("image");
		close();
	
		selectWindow("image2");
		nsl = nSlices()/2;
		//print(nsl);

		//transform stack in a merge
		run("Split Channels");
		run("Merge Channels...", "c2=C2-image2 c3=C1-image2");
		selectWindow("RGB");
		run("Stack to Images");

		//slice by slice
		for (ii=0; ii<=(nsl - 1); ii++) {

			j = ii + 1;
	
			if (j < 10) {
				selectWindow("RGB-000" + j);
			}
			else if (j >= 10) {
				selectWindow("RGB-00" + j);
			}

			rename("current_image");
			run("Split Channels");
			selectWindow("current_image (red)");
			close();

			selectWindow("current_image (blue)");
			run("Duplicate...", "title=mascara");
			setAutoThreshold("Mean dark");
			setOption("BlackBackground", false);
			run("Convert to Mask");
			run("Fill Holes");
			run("Erode");
			run("Erode");
			run("Erode");
			run("Dilate");
			run("Dilate");
			run("Dilate");
			//run("Watershed");
			run("Create Selection");
			run("ROI Manager...");
			roiManager("Add");
			run("Make Inverse");
			run("Set Measurements...", "mean redirect=[current_image (green)] decimal=3");
			run("Measure");
			bkg = getResult("Mean");
			//print(bkg);
			run("Clear Results");
			
			selectWindow("mascara");
			close();
			selectWindow("current_image (green)");		
			run("Subtract...", "value=bkg");
			roiManager("Select", ii);
			run("Clear Outside");

			run("Merge Channels...", "c2=[current_image (green)] c3=[current_image (blue)]");
			rename("image_" + j);
		}

		run("Images to Stack", "use");
		rename("stack");
		run("Split Channels");
		selectWindow("stack (red)");
		close();
		selectWindow("stack (blue)");
		run("Z Project...", "projection=[Max Intensity]");
		selectWindow("stack (blue)");
		close();
	
		selectWindow("stack (green)");
		run("Z Project...", "projection=[Average Intensity]");
		selectWindow("stack (green)");
		close();
	
		selectWindow("MAX_stack (blue)");
		setAutoThreshold("Mean dark");
		run("Convert to Mask");
		run("Watershed");
		run("Set Measurements...", "mean redirect=[AVG_stack (green)] decimal=3");
		selectWindow("MAX_stack (blue)");
		run("Analyze Particles...", "size=10-Infinity show=Outlines display");
	
		close();
		selectWindow("AVG_stack (green)");
		close();
		selectWindow("MAX_stack (blue)");
		close();
	
		saveAs("Results", dir + "/" + images[i] + ".txt");
		run("Clear Results");

		roiManager("Delete");
	}
}													
																					

