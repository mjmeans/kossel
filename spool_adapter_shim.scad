include <configuration.scad>;

$fn=40;
rad=14;

difference() {
    cube([40,20,1.5]);
    translate([10,10,0]) cylinder(h=5, r=m3_wide_radius);
    translate([30,10,0]) cylinder(h=5, r=m3_wide_radius);
}
difference() {
    translate([0,0,0]) cube([40,2.5,rad]);
    translate([0,0,rad+1.5]) rotate([-90,0,0]) cylinder(h=30, r=rad);
    translate([40,0,rad+1.5]) rotate([-90,0,0]) cylinder(h=30, r=rad);
}
