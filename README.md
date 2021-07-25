# MultiscaleHip
RASIS: the right anterior superior iliac spines

LASIS: the left anterior superior iliac spines

RPT: the right pubic tubercles

LPT: the left pubic tubercles

This Matlab programme will be used to automatically determine the four bony landmarks on the pelvis (RASIS, LASIS, RPT and LPT) and establish the pelvic coordinate system based on the bony landmarks. The algorithm for the Matlab programme is as follow:

(1)	Four arbitrary points were randomly selected from the 3D point clouds on the four bony landmark regions, respectively

(2)	An initial plane was then created through the arbitrary points selected around RASIS, LASIS, and the midpoint between the arbitrary points selected around RPT and LPT

(3)	The initial plane was translated 50 mm along its normal vector toward the ventral direction. The distances between each point in the point clouds and the translated plane were calculated

(4)	A new point that had the minimum distance to the translated plane was obtained for each of the four bony landmark regions

(5)	A new plane was then created based on the new points and the process was repeated until the selected four points were the same as those selected in the previous step.
