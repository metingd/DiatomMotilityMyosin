//This macro reduces horizontal abberations in an open kymograph .tif file and rotates it 90 degrees left to facilitate directionality measurements
//Get name of currently open kymograph
name = getInfo("image.filename");
run("Remove Overlay");
run("Set Scale...", "distance=0 known=0 unit=pixel");
run("Select None");

//Select open kymograph
selectWindow(name);

//Perform fast Fourier transformation
run("FFT");

//Draw 2 px wide mask in the vertical center of orientation map
getDimensions(width, height, channels, slices, frames);
x_pos = width/2;
y_pos = height/2;
makeRectangle(1, 1, 1, 1);
run("Specify...", "width=2 height="+height+" x="+x_pos+" y="+y_pos+" centered");
run("Clear");

//Invert FFT
run("Select None");
run("Inverse FFT");
run("Rotate 90 Degrees Left");

