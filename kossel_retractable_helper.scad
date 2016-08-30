//118
mount_length=50.0;    // the length of the mount sides
mount_width=15.0;     // the width of the mount sides
mount_thickness=2.0;  // the thickness of the mount sides
span_width=139;
span_y_offset=16;   // 22
riser_height=15;
riser_thickness=3;
$fn=16;

// Increase this if your slicer or printer make holes too tight.
extra_radius = 0.1;

// Major diameter of metric 3mm thread.
m3_major = 2.85;
m3_radius = m3_major/2 + extra_radius;
m3_wide_radius = m3_major/2 + extra_radius + 0.2;

difference() {
    union() {
        // mounting bars
        translate([span_width/2,0,0]) rotate([0,0,30]) bar();
        translate([-span_width/2,0,0]) rotate([0,0,-30]) bar();
        // span between bars
        translate([0,span_y_offset,0]) union() {
            translate([0,mount_width/4,0])
                cube([span_width-span_y_offset*2,mount_width/2,mount_thickness], center=true);
            translate([0,-mount_width/4,0])
                cube([span_width-span_y_offset,mount_width/2,mount_thickness], center=true);
        }
        translate([0,span_y_offset,0])
            cylinder(r=mount_width/4, h=riser_height);
        difference() {
            translate([0,span_y_offset,riser_height/2])
                cube([span_width-span_y_offset/2,riser_thickness,riser_height], center=true);
            translate([0,span_y_offset,riser_height+riser_height/2]) rotate([0,10,0]) 
                cube([span_width*2-span_y_offset,riser_thickness,riser_height], center=true);
            translate([0,span_y_offset,riser_height+riser_height/2]) rotate([0,-10,0]) 
                cube([span_width*2-span_y_offset,riser_thickness,riser_height], center=true);
        }
    }
    translate([0,span_y_offset,0])
        cylinder(r=m3_radius/2, h=riser_height);
}

module bar() {
    difference() {
        cube([mount_width,mount_length+mount_width,mount_thickness], center=true);
        translate([0,mount_length/2,0]) cylinder(r=m3_wide_radius, h=mount_thickness, center=true);
        translate([0,-mount_length/2,0]) cylinder(r=m3_wide_radius, h=mount_thickness, center=true);
    }
}