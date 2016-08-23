// FSR holder for KosselPlus printer.
//
// This work is licensed under a Creative Commons
// Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)
// Visit: http://creativecommons.org/licenses/by-nc-sa/4.0/
//
// Haydn Huntley
// haydn.huntley@gmail.com

$fn=60;

include <configuration.scad>;
use <roundedBox.scad>;

// All measurements in mm.
bodyLength      = 45.0+4;
lowerBodyHeight = 4.4;
fsrThickness    = 0.6;
fsrRadius       = 18.5/2;
fsrRadiusExtra  = fsrRadius + 2.0;
fsrPocketDepth  = 2.4;
fsrLeadWidth    = 8.0;
maxButtonRadius = fsrRadius - 0.25;
minButtonRadius = 0.5/2 * mmPerInch;
buttonThickness = 2.6;
upperBodyHeight =
		lowerBodyHeight - fsrPocketDepth + fsrThickness + buttonThickness + glassHeight+0.6+0.6;
screwOffset     = bodyLength/2 - 6;
lockingPieceHeight = 2.0;
lockingPieceWidth  = 10.0;
lockingPieceScrewXOffset = 3.5;
lockingPieceNutTrapHeight = upperBodyHeight + lockingPieceHeight - 6;


module m3x6(x, y, z)
{
	translate([x, y, z - m3HeadHeight-smidge/2])
	cylinder(r=m3LooseHeadRadius+smidge, h=2*m3HeadHeight+smidge);

	translate([x, y, -smidge/2])
	cylinder(r=m3LooseRadius, h=z+smidge);
}


module lockingPiece()
{
	offset = 2.0;
	difference()
	{
		// The locking piece's body.
		translate([offset/2, 0, lockingPieceHeight/2])
		roundedBox([extrusionWidth-offset,
					lockingPieceWidth,
					lockingPieceHeight], 3, true);

		// Remove an m3x6 screw hole.
		translate([lockingPieceScrewXOffset, 0, -smidge/2])
		cylinder(r=m3LooseRadius+smidge/2, h=lockingPieceHeight+smidge);
	}
}


module fsrButton()
{
	// The height of the step to trigger the active area of the FSR's.
	stepHeight = 0.6;

	translate([0, 0, buttonThickness - stepHeight])
	cylinder(r=minButtonRadius, h=stepHeight);
		
	cylinder(r=maxButtonRadius, h=buttonThickness-stepHeight);
}


module main()
{
	difference()
	{
		union()
		{
			// The rectangular body.
			translate([0, 0, upperBodyHeight/2])
			roundedBox([extrusionWidth, bodyLength, upperBodyHeight], 3, true);

			// Add an ear reaching toward the center to hold the FSR.
			translate([-fsrRadiusExtra, 0, 0])
			cylinder(r=fsrRadiusExtra, h=upperBodyHeight);

			// Add a little more support for the FSR ears.
			translate([-fsrRadiusExtra/2, 0, upperBodyHeight/2])
			cube([fsrRadiusExtra, 2*fsrRadiusExtra, upperBodyHeight],
				 center=true);

			// Add more material around the locking piece's nut trap, so that
			// it doesn't mar the outside finish.
			//translate([lockingPieceScrewXOffset, 0, 0])
			//cylinder(r=m3LooseNutRadius+1.5, h=upperBodyHeight);
		}

		// Remove a big arc for the glass.
		translate([-glassRadius-extrusionWidth/2+6+1.0, 0, lowerBodyHeight])
		cylinder(r=glassRadius, h=upperBodyHeight+smidge);

		// Remove a circular indentation to hold the FSR.
		translate([-fsrRadiusExtra, 0, lowerBodyHeight-fsrPocketDepth])
		cylinder(r=fsrRadius, h=upperBodyHeight);
	
		// Remove an indentation for the FSR's leads to exit.
		translate([-fsrLeadWidth/2-fsrRadiusExtra,
				   -fsrRadiusExtra-smidge,
				   lowerBodyHeight-fsrPocketDepth])
		cube([fsrLeadWidth, fsrLeadWidth, fsrPocketDepth+smidge]);
	
		// Remove two countersunk M3x6 screws.
		m3x6(0,  screwOffset, lowerBodyHeight+m3HeadHeight);
		m3x6(0, -screwOffset, lowerBodyHeight+m3HeadHeight);

		// Remove a screw hole for the locking piece.
		translate([lockingPieceScrewXOffset, 0, 0])
		cylinder(r=m3LooseRadius, h=upperBodyHeight);

		// Remove a nut trap for the locking piece.
		// An M3x8 bolt and nut will hold it on.
		translate([lockingPieceScrewXOffset, 0, -smidge/2])
		rotate([0, 0, 0])
		{
			translate([0, 0, lockingPieceNutTrapHeight-smidge/2])
			cylinder(r1=m3NutRadius, r2=m3LooseRadius, h=1, $fn=6);
            translate([0, 0, m3NutHeight])
            cylinder(r=m3NutRadius, h=lockingPieceNutTrapHeight-m3NutHeight, $fn=6);
            translate([0, -m3NutRadiusMin, lockingPieceNutTrapHeight-m3NutHeight])
            cube([m3NutRadiusMin*2, m3NutRadiusMin*2, m3NutHeight]);
		}

		// Remove a little bit to make the locking piece stay in place better.
		translate([0, 0, upperBodyHeight - 0.6])
		{
			translate([0, 0, lockingPieceHeight/2])
			cube([extrusionWidth+4,
				  lockingPieceWidth+4*smidge,
				  lockingPieceHeight], true);
		}
	}
}

main();

translate([-17, -19, 0])
lockingPiece();

translate([0, 0, upperBodyHeight - 0.6])
%lockingPiece();

translate([-18, 22, 0])
fsrButton();

translate([-fsrRadiusExtra, 0,
		   lowerBodyHeight-fsrPocketDepth+fsrThickness+buttonThickness])
rotate([180, 0, 0])
%fsrButton();

