difference() {
    union() {
        cylinder(r=4.50, h=5, $fn=32);
        cylinder(r=2.75, h=6.5, $fn=32);
    }
    cylinder(r=1.75, h=7, $fn=32);
    cylinder(r=3.25, h=2.75, $fn=32);
    translate([0,0,2.75])
        cylinder(r1=3.25, r2=1.75, h=0.5, $fn=32);
    //cube([10,10,10]);
}
