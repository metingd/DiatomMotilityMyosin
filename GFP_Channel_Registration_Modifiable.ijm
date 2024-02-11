//Define px size (set to 1 as default unless otherwise specified in MATLAB tracking script)
px = 1
run("Close All");
run("Clear Results");

//Run open dialog and select file of choice
run("Open...");

//Select a reference frame in which the cell is roughly in the center of the FOV
waitForUser("Check movie and choose suitable reference frame.");
Ref_frame = getNumber("Enter reference frame number", 1);

//Remove scale before processing and reintroduce later if needed for scale bars
//Set reference points using frame of choice
run("Set Scale...", "distance=0 known=0 unit=pixel");
setSlice(Ref_frame);
run("Set Measurements...", "area mean min center redirect=None decimal=3");
run("Measure");

//Set reference points for cell position`
x_ref = getResult("XM")/px; 	//Divide by px size to get correct output
y_ref = getResult("YM")/px;
run("Clear Results");

//Import transformation coordinates generated in MATLAB
d = getInfo("image.directory");
Table.open(d+"Trafo_coord.csv");

//Translate and rotate each frame using transformation coordinates to match reference frame
for (i = 1; i <= nSlices; i++) {
    setSlice(i);
    x_shift = x_ref - getResult("C1", i-1)/px;   //Divide by px size to get correct output
    y_shift = y_ref - getResult("C2",i-1)/px;
    run("Translate...", "x="+x_shift+" y="+y_shift+" interpolation=None slice");
    
    if (abs(getResult("C3",i-1)-180)>90){
    ang = getResult("C3",i-1);}
    else {
    	ang =180+ getResult("C3",i-1);
    }
   
    run("Rotate... ", "angle="+ang+" grid=1 interpolation=Bilinear slice");  
}

//Save registered GFP channel movie
title = getTitle();
newname = replace(title,".tif","_registered.tif")
path = getDirectory("image");
saveAs("Tiff",path +newname)


//Create kymograph from registered GFP channel movie
run("Reslice [/]...", "output="+px+" start=Top avoid");
run("Z Project...", "projection=[Max Intensity]");
run("Set Scale...", "distance=1 known=0.13 unit=um");
run("Scale Bar...", "width=5 height=4 font=14 color=White background=None location=[Lower Left] bold overlay");

