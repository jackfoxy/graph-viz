# labelangle

The angle (in degrees) in polar coordinates of the head & tail edge labels.

type: [double](../attribute-types/double.md), default: `-25.0`, minimum: `-180.0`

Determines, along with [labeldistance](labeldistance.md), where the [headlabel](headlabel.md) / [taillabel](taillabel.md) are placed with respect to the head / tail in polar coordinates.

The origin in the coordinate system is the point where the edge touches the node. The ray of 0 degrees goes from the origin back along the edge, parallel to the edge at the origin.

The angle, in degrees, specifies the rotation from the 0 degree ray, with positive angles moving counterclockwise and negative angles moving clockwise.

_Valid on:_

  * Edges
