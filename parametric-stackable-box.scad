include <scad-utils/mirror.scad>
include <scad-utils/morphology.scad>

$fn=30;

/* Parameters */
BODY_X = 80;
BODY_Y = 110;
BODY_Z = 47;

module base(r=1) {
  basePoints = [
    [BODY_X/2, 0],
    [0, 0],
    [0, BODY_Y/4],
    [3, BODY_Y/4 + 3],
    [3, BODY_Y/4 * 3 - 3],
    [0, BODY_Y/4 * 3],
    [0, BODY_Y/4 * 4],
    [0 + BODY_X/3 - 3, BODY_Y/4 * 4],
    [0 + BODY_X/3, BODY_Y/4 * 4 - 3],
    [BODY_X/2, BODY_Y/4 * 4 - 3],
  ];

  pointsCentered = [for (p=basePoints)
    [
      p[0] - BODY_X/2,
      p[1] - BODY_Y/2
    ]
  ];

  points = concat(
    pointsCentered,
    [for (p=pointsCentered) [p[0]*-1, p[1]] ]
  );

  rounding(r=r)
  polygon(points=points);
}

/* Parameters 2 */
WALL_THICK = 0.4*4;

HOLDER_Z_TOTAL = 10;
HOLDER_Z_JOINT = 3;
HOLDER_Z = HOLDER_Z_TOTAL - HOLDER_Z_JOINT;
HOLDER_DELTA = 0.8+0.4*4;
HOLDER_CLEARANCE = 0.4*2;

FRONT_EDGE_DEG = 35;
FRONT_EDGE_LEN = 20;

FRONT_EDGE_TOP_DEG = 30;
FRONT_EDGE_TOP_LEN = 25;

DRAW_BODY=true;
DRAW_DIMEN=false;


module body() {
  difference() {
    union() {
      // inner
      linear_extrude(height=BODY_Z-HOLDER_Z_TOTAL, center=!true, convexity=10, twist=0)
      base();

      // joint
      translate([0, 0, BODY_Z-HOLDER_Z])
      minkowski() {
        hull() {
          linear_extrude(height=0.01, center=!true)
          rounding(r=2-0.01)
          square(size=[HOLDER_DELTA*2, HOLDER_DELTA*2], center=true);
          translate([0, 0, -HOLDER_Z_JOINT])
          sphere(r=0.01);
        }

        linear_extrude(
          height=0.01,
          center=!true,
          convexity=10
        )
        base();
      }

      // holder
      translate([0, 0, BODY_Z-HOLDER_Z])
      linear_extrude(height=HOLDER_Z, center=!true, convexity=10, twist=0)
      offset(r=HOLDER_DELTA)
      base();
    }

    // inner space
    difference() {
      translate([0, 0, 1])
      linear_extrude(height=BODY_Z, center=!true, convexity=10, twist=0)
      offset(r=-WALL_THICK)
      base();

      // frontEdge
      frontEdge();
    }

    // holder inner space
    translate([0, 0, BODY_Z-HOLDER_Z+1])
    linear_extrude(height=HOLDER_Z, center=!true, convexity=10, twist=0)
    offset(r=HOLDER_CLEARANCE)
    base();

    // front space
    translate([0, -BODY_Y/2, BODY_Z/2 + FRONT_EDGE_LEN + 1])
    cube(size=[BODY_X-WALL_THICK*2, 10, BODY_Z+1], center=true);

    // frontEdge
    translate([0, -1*sin(FRONT_EDGE_DEG), -1*cos(FRONT_EDGE_DEG)])
    frontEdge();

    // frontEdgeTop
    translate([0, -1*sin(FRONT_EDGE_TOP_DEG), -1*cos(FRONT_EDGE_TOP_DEG)])
    frontEdgeTop();
  }
}

module frontEdge(args) {
  translate([0, -BODY_Y/2, 0])
  rotate([FRONT_EDGE_DEG, 0, 0])
  cube(
    size=[
      BODY_X+10,
      FRONT_EDGE_LEN*2*sin(FRONT_EDGE_DEG),
      FRONT_EDGE_LEN*2*cos(FRONT_EDGE_DEG)
    ],
    center=true
  );
}

module frontEdgeTop() {
  translate([0, -BODY_Y/2, BODY_Z])
  rotate([180-FRONT_EDGE_TOP_DEG, 0, 0])
  cube(
    size=[
      BODY_X+10,
      FRONT_EDGE_TOP_LEN*2*sin(FRONT_EDGE_TOP_DEG),
      FRONT_EDGE_TOP_LEN*2*cos(FRONT_EDGE_TOP_DEG)
    ],
    center=true
  );
}

if (DRAW_BODY) {
  body();
}

/* Show dimentions */
module dimenText(text, len, pos=0) {
  module vert(t=0.5) {
    translate([0, len/2 - t/2, -3/2])
    rotate([90, 0, 90])
    square(size=[t, 3], center=true);
  }

  module dimen() {
    rotate([90, 0, 90])
    square(size=[len, 0.5], center=true);

    vert();
    mirror_y()
    vert();
  }

  textAligns = [
    "center",
    "left",
    "right",
    "center",
  ];
  textPositions = [
    [0, 0, 5],
    [0, 5, 0],
    [0, -5, 0],
    [0, 0, -10],
  ];
  dimenRotations = [
    [0, 0, 0],
    [-90, 0, 0],
    [90, 0, 0],
    [0, 180, 0],
  ];

  color("red") {
    translate(textPositions[pos])
    rotate([90, 0, 90])
    text(text, size=4, font="Sans", halign=textAligns[pos], valign="center",
    spacing=1.0, direction="ltr", language="en", script="latin", center=true);

    rotate(dimenRotations[pos])
    dimen();
  }
}

if (DRAW_DIMEN) {
  translate([0, 0, BODY_Z + 8])
  dimenText("BODY_Y", BODY_Y, 0);

  translate([0, BODY_Y/2 + 8, BODY_Z/2])
  dimenText("BODY_Z", BODY_Z, 1);

  translate([0, BODY_Y/2 + 8 + 8, HOLDER_Z_TOTAL/2 + BODY_Z - HOLDER_Z_TOTAL])
  dimenText("HOLDER_Z_TOTAL", HOLDER_Z_TOTAL, 1);

  translate([0, -BODY_Y/2 - 8, HOLDER_Z_JOINT/2 + BODY_Z - HOLDER_Z_TOTAL])
  dimenText("HOLDER_Z_JOINT", HOLDER_Z_JOINT, 2);

  translate([0, -BODY_Y/2, (FRONT_EDGE_LEN)*sin(FRONT_EDGE_DEG)/2])
  rotate([FRONT_EDGE_DEG, 0, 0])
  dimenText("FRONT_EDGE_LEN", FRONT_EDGE_LEN, 2);
}
