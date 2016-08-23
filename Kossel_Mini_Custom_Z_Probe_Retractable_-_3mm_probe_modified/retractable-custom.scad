include <configuration.scad>;

use <microswitch.scad>;
use <effector.scad>;

height = 30;  //26
height2 = 30;  //26
tunnel = 3;
face_offset = 6; //4

foot_side = 0;
foot_forward = 12;
foot_thick = 3;
foot_down = 13;
foot_up = foot_down + foot_thick + 8;

module foot() {
  difference() {
    union() {
      difference() {
        translate([12.5, 0, 0]) rotate([0, 0, -60])
          translate([-12.5, 0, foot_thick/2]) rotate([0, 0, -60]) union() {
            cylinder(r=5, h=foot_thick, center=true, $fn=24);
            translate([10, 0, 0])
              cube([20, 10, foot_thick], center=true);
            translate([10, -2.75, 0]) rotate([0,0,-15])
              cube([20, 10, foot_thick], center=true);
        }
        translate([0, -10, 0])
          cube([40, 20, 20], center=true);
        translate([12.5, 0, 0]) {
          // Space for bowden push fit connector.
          cylinder(r=6.49, h=3*height, center=true, $fn=32);
          for (a = [60:120:359]) {
    	    rotate([0, 0, a]) translate([-12.5, 0, 0])
            cylinder(r=m3_wide_radius, h=20, center=true, $fn=12);
          }
        }
      }
      translate([-foot_forward-8,0,0])
        cube([foot_forward+8,6,foot_thick]);
    }
    rotate([0, 0, 0])
      cylinder(r=m3_wide_radius, h=20, center=true, $fn=12);
  }
}

module retractable() {
  difference() {
    union() {
      translate([0, 0, height/2])
        cylinder(r=6, h=height, center=true, $fn=32);
      translate([0, -3, height/2])
        cube([12, 6, height], center=true);
      // Lower part on the left.
      translate([-6, 0, height2/2])
        cylinder(r=6, h=height2, center=true, $fn=32);
      translate([-3, 0, height2/2])
        cube([6, 12, height2], center=true);
      translate([-3, -3, height2/2])
        cube([18, 6, height2], center=true);
      // Feet for vertical M3 screw attachment.
      translate([0,0,foot_up]){
          translate([-foot_side, foot_forward, 0]) rotate([0, 0, 90]) {
            foot();
          }
          translate([-foot_side+0.001, foot_forward, 0]) rotate([0, 0, 90]) {
            scale([1, -1, 1])
                foot();
          }
      }
      translate([0,0,foot_down]) {
          translate([-foot_side+0.001, foot_forward, foot_thick/2])
            difference() {
                union() {
                    cylinder(r=5, h=foot_thick, center=true, $fn=24);
                    translate([0,-5,0]) cube([10,10,foot_thick], center=true);
                }
                cylinder(r=m3_wide_radius, h=foot_thick, center=true, $fn=24);
            }
       }
    }
    translate([-19, 0, height/2+6]) rotate([0, 15, 0])
      cube([20, 14, height], center=true);
    cylinder(r=tunnel/2+extra_radius, h=3*height, center=true, $fn=12);
    translate([0, -6, height/2+12])
      cube([tunnel, 12, height], center=true);
    rotate([0, 0, 30]) translate([0, -6, height/2+22])
      cube([tunnel, 12, height], center=true);
    rotate([0, 0, 15]) translate([0, -6, height/2+22])
      cube([tunnel, 12, height], center=true);
    
    // Safety needle spring.
    translate([-4.5, 0, height-11]) rotate([90, 0, 0])
      cylinder(r=2.5/2, h=12, center=true, $fn=12);
    translate([-4, 0, height-2]) rotate([90, 0, 0])
      cylinder(r=3/4, h=12, center=true, $fn=12);
    
    // Flat front face.
    translate([0, -face_offset-10, height/2]) difference() {
      cube([30, 20, 2*height], center=true);
    }
    
    // Sub-miniature micro switch.
    translate([-2.5, -face_offset-3, 5]) {
      % microswitch();
      for (x = [-9.5/2, 9.5/2]) {
        translate([x, 0, 0]) rotate([90, 0, 0])
          cylinder(r=2.5/2, h=40, center=true, $fn=12);
      }
    }
    
    // effector cut out
    translate([0, foot_forward+12.5, foot_down+foot_thick+4])
      cylinder(r=31, h=8.5, $fn=6, center=true);

    // allow bend in angle bar
    translate([0,0,height/2-tunnel*3/2])
      difference() {
        rotate([45,0,0]) cube([tunnel, tunnel, height], center=true);
        translate([-height/2,0,-height/2]) cube([height, height, height]);
      }
  }
}

retractable();

translate([0, foot_forward+12.5, foot_down+foot_thick+4])
  % effector();

