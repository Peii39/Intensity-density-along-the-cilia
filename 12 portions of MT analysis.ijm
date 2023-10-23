waitForUser("Select Rectangle");
if (selectionType() != 0){
	exit("Sorry, no rectangle");//make sure we have got a rectangular selection
}
run("Duplicate...", "title=2_1");
//run("Duplicate...", "slices=6");
selectWindow("2_1");
//run("Duplicate...", "duplicate channels=3 slices=6");

selectWindow("2_1");
waitForUser("Select Segmented Line");
if (selectionType() != 6){
	exit("Sorry, no Segmented Line");//make sure we have got a Segmented Line selection
}

run("Fit Spline");
run("Interpolate", "interval=0.05 smooth");

getSelectionCoordinates(xp, yp);
//run("Add Selection...","stroke=green width=3");
List.setMeasurements();

steps = 12; //Change this to set how many pieces you want to divide the cilia
xm=newArray(steps+1);
ym=newArray(steps+1);
xtop=newArray(steps+1);
ytop=newArray(steps+1);
xbot=newArray(steps+1);
ybot=newArray(steps+1);
 
//print(xp.length)
for (i=0;i<xm.length;i++){
 	xm[i]=xp[i*(xp.length-1)/steps];
 	ym[i]=yp[i*(yp.length-1)/steps];
}

L=250; //Edit this to change how wide the ROI polygon needs to be

 for (i=0;i<xm.length;i++){
 	if(i<xm.length-1){
 		x1=xm[i];
 		x2=xp[i*(xp.length-1)/steps+1];
 		y1=ym[i];
 		y2=yp[i*(yp.length-1)/steps+1];
 		
 		D=sqrt((x1-x2)^2+(y1-y2)^2);
 		xtop[i]=(x1)-L*(y2-y1)/D;
 		ytop[i]=(y1)+L*(x2-x1)/D;
 		xbot[i]=(x1)+L*(y2-y1)/D;
 		ybot[i]=(y1)-L*(x2-x1)/D;
 	} else {
 		x2=xm[i];
 		x1=xp[i*(xp.length-1)/steps-1];
 		y2=ym[i];
 		y1=yp[i*(yp.length-1)/steps-1];
 		
 		D=sqrt((x1-x2)^2+(y1-y2)^2);
 		xtop[i]=(x2)-L*(y2-y1)/D;
 		ytop[i]=(y2)+L*(x2-x1)/D;
 		xbot[i]=(x2)+L*(y2-y1)/D;
 		ybot[i]=(y2)-L*(x2-x1)/D;
 	}
 }
 //makeSelection("Point",xtop,ytop);
 //run("Point Tool...","type=Dot color=Red size=[Extra Large] counter=0");

roiManager("reset"); 

for (i=0;i<xm.length-1;i++){
	makePolygon(xtop[i],ytop[i],xtop[i+1],ytop[i+1],xbot[i+1],ybot[i+1],xbot[i],ybot[i]);
	roiManager("add");
}

selectWindow("2_1");//Edit name to match the desired channel
setSlice(1);//Edit number to match the desired slice
for (i=0;i<xm.length-1;i++){
	roiManager("select", i);
	Stack.setChannel(2);
	run("Measure");
}
 
 //waitForUser("Select Rectangle");
//if (selectionType() != 0){
//	exit("Sorry, no rectangle");//make sure we have got a rectangular selection
//}
//run("Measure");
