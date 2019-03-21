include <parametric-stackable-box.scad>

$fn=30;

/* Parameters */
DRAW_BODY=false;
BODY_Z = 47;

ORG_CLEARANCE=1;
ORG_FRAME_Z=3;
ORG_WALL_T=0.4*5;
ORG_WALL_Z=BODY_Z*0.7;
ORG_DIV_X=1;
ORG_DIV_Y=2;

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

    // dividers
    linear_extrude(height=ORG_WALL_Z, center=!true, convexity=10, twist=0)
    intersection() {
      union() {
        xDividers = ORG_DIV_X-1;
        for (i=[0:xDividers]) {
          if (i > 0) {
            distance = BODY_X/ORG_DIV_X;
            total = distance * (xDividers-1);
            translate([distance*(i-1) - total/2, 0, 0])
            square(size=[ORG_WALL_T, BODY_Y], center=true);
          }
        }
        yDividers = ORG_DIV_Y-1;
        for (i=[0:yDividers]) {
          if (i > 0) {
            distance = BODY_Y/ORG_DIV_Y;
            total = distance * (yDividers-1);
            translate([0, distance*(i-1) - total/2, 0])
            square(size=[BODY_X, ORG_WALL_T], center=true);
          }
        }
      }
      if (ORG_DIV_X > 1 || ORG_DIV_Y > 1) {
        orgBase();
      }
    }
  }

  translate([0, ORG_CLEARANCE, 0]){
    frontEdge();
    frontEdgeTop();
  }
}


%body();
