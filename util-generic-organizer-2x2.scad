include <parametric-stackable-box.scad>

$fn=30;

/* Parameters */
DRAW_BODY=false;
BODY_Z = 47;

ORG_CLEARANCE=1;
ORG_FRAME_Z=3;
ORG_WALL_T=0.4*5;
ORG_WALL_Z=BODY_Z*0.7;

module orgBase(args) {
  rounding(r=2)
  offset(delta=-WALL_THICK-ORG_CLEARANCE)
  base();
}

translate([0, 0, 1])
difference() {
  union() {
    linear_extrude(height=ORG_FRAME_Z, center=!true, convexity=10, twist=0)
    shell(d=-3)
    orgBase();

    // divider
    linear_extrude(height=ORG_WALL_Z, center=!true, convexity=10, twist=0)
    intersection() {
      union() {
        square(size=[BODY_X, ORG_WALL_T], center=true);
        square(size=[ORG_WALL_T, BODY_Y], center=true);
      }
      orgBase();
    }

  }

  translate([0, ORG_CLEARANCE, 0]){
    frontEdge();
    frontEdgeTop();
  }
}


%body();
