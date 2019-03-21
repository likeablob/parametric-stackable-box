include <parametric-stackable-box.scad>

$fn=30;

/* Parameters */
DRAW_BODY=false;
BODY_Z = 47*1.5;

BATT_D=14 + 1; // AA
HOLDER_Z=8;

translate([0, 0, 2])
difference() {
  linear_extrude(height=HOLDER_Z, center=!true, convexity=10, twist=0)
  rounding(r=2)
  offset(delta=-WALL_THICK-1)
  base();

  distanceBetweenBatteries = BATT_D+1.5;

  // holes
  translate([0, 5, 1]){
    mirror_y()
    mirror_x()
    for (i=[0:BODY_X/distanceBetweenBatteries/2 - 1]) {
      for (j=[0:BODY_Y/distanceBetweenBatteries/2 - 1]) {
        translate([
          i*(distanceBetweenBatteries) + distanceBetweenBatteries/2,
          j*(distanceBetweenBatteries),
          0
        ])
        cylinder(d=BATT_D, h=HOLDER_Z*2, center=!true);
      }
    }

    mirror_y()
    mirror_x()
    for (i=[0:BODY_X/distanceBetweenBatteries/2 - 1]) {
      hull() {
        for (j=[0:BODY_Y/distanceBetweenBatteries/2 - 1]) {
          translate([
            i*(distanceBetweenBatteries) + distanceBetweenBatteries/2,
            j*(distanceBetweenBatteries),
            0
          ])
          cylinder(d=BATT_D/2, h=HOLDER_Z*2, center=!true);
        }
      }
    }
  }

  translate([0, 3, 0])
  frontEdge();
}

%body();
