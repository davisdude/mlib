MLib
====

__MLib__ is a math library that does math functions for you. It is designed to be __easy to use__ and __intuitive__. It has many <a href="http://github.com/davisdude/mlib#function-list">functions</a>. 

__MLib__ is written in pure <a href="http://lua.org">Lua</a>, and can easily be dropped into any project! Examples are done with the *awesome* framework of <a href="http://www.love2d.org">LÖVE</a>, but should also work with other frameworks. 

##Installation
You can get the most recent version of MLib by:

###Bash
```bash
git clone git://github.com/davisdude/mlib.git
````

###Download
The __latest release__ can be found <a href="https://github.com/davisdude/mlib/releases/tag/1.1.0.0">here</a>, and previous releases <a href="https://github.com/davisdude/mlib/releases">here</a>. 

##Usage of MLib
Download the file called <a href="https://github.com/davisdude/mlib/blob/master/mlib.lua">`mlib.lua`</a> and put it somewhere in the file for the process you want it in. Use the *require* function to import the module into the library.

##An Example of Usage
Here is an example of how to use MLib:
```lua
-- Require libraries:
MLib = require( 'path/mlib' )
-- The first "MLib" can be whatever you want to call it.
-- "path" is how you get to the file from the main directory of the application.
-- See http://www.lua.org/pil/8.1.html for more information on the require function.  

-- Make your data:
local Line1 = { 0, 1, 1, 2 }
local Line2 = { { x = 0, y = 0 }, { x = 1, y = 1 } }
-- You can set up the data any way. Line1 is more compatable with the library, but line2 will work, too.

-- Get the slope and y-intercept for the data.
local Slope1, Intercept1 = MLib.Line.GetSlope( unpack( Line1 ) ), MLib.Line.GetIntercept( unpack( Line1 ) )
local Slope2, Intercept2 = MLib.Line.GetSlope( Line2[1].x, Line2[1].y, Line2[2].x, Line2[2].y ), MLib.Line.GetIntercept( Line2[1].x, Line2[1].y, Line2[2].x, Line2[2].y )

print( string.format( 'Line 1: \n\tSlope: %s \n\tY-Intercept: %s', Slope1, Intercept1 ) )
print( string.format( 'Line 2: \n\tSlope: %s \n\tY-Intercept: %s', Slope2, Intercept2 ) )

--> Output: 
--> Line 1
-->   Slope: 1
-->   Y-Intercept: 1
--> Line 2
-->   Slope: 1
-->   Y-Intercept: 0

--> Output: 
--> Line 1
-->   Slope: 1
-->   Y-Intercept: 1
--> Line 2
-->   Slope: 1
-->   Y-Intercept: 0
```

#Function List
####<a href="http://github.com/davisdude/mlib#mlibline-1">MLib.Line</a>
#####<a href="http://github.com/davisdude/mlib#mliblinegetlength-1">MLib.Line.GetLength</a>
#####<a href="http://github.com/davisdude/mlib#mliblinegetmidpoint-1">MLib.Line.GetMidpoint</a>
#####<a href="http://github.com/davisdude/mlib#mliblinegetslope-1">MLib.Line.GetSlope</a>
#####<a href="http://github.com/davisdude/mlib#mliblinegetperpendicularslope-1">MLib.Line.GetPerpendicularSlope</a>
#####<a href="http://github.com/davisdude/mlib#mliblinegetperpendicularbisector-1">MLib.Line.GetPerpendicularBisector</a>
#####<a href="http://github.com/davisdude/mlib#mliblinegetintercept-1">MLib.Line.GetIntercept</a>
#####<a href="http://github.com/davisdude/mlib#mliblinegetintersection-1">MLib.Line.GetIntersection</a>
#####<a href="http://github.com/davisdude/mlib#mliblinegetclosestpoint-1">MLib.Line.GetClosestPoint</a>
#####<a href="http://github.com/davisdude/mlib#mliblinegetsegmentintersection-1">MLib.Line.GetSegmentIntersection</a>
####<a href="http://github.com/davisdude/mlib#mliblinesegment-1">MLib.Line.Segment</a>
#####<a href="http://github.com/davisdude/mlib#mliblinesegmentcheckpoint-1">MLib.Line.Segment.CheckPoint</a>
#####<a href="https://github.com/davisdude/mlib#mliblinesegmentgetintersection-1">MLib.Line.Segment.GetIntersection</a>
####<a href="http://github.com/davisdude/mlib#mlibpolygon-1">MLib.Polygon</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygongettriangleheight-1">MLib.Polygon.GetTriangleHeight</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygongetsignedarea-1">MLib.Polygon.GetSignedArea</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygongetarea-1">MLib.Polygon.GetArea</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygongetcentroid-1">MLib.Polygon.GetCentroid</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygoncheckpoint-1">MLib.Polygon.CheckPoint</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygonlineintersects-1">MLib.Polygon.LineIntersects</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygonpolygonintersects-1">MLib.Polygon.PolygonIntersects</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygoncircleintersects-1">MLib.Polygon.CircleIntersects</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygonispolygoninside-1">MLib.Polygon.IsPolygonInside</a>
####<a href="http://github.com/davisdude/mlib#mlibcircle-1">MLib.Circle</a>
#####<a href="http://github.com/davisdude/mlib#mlibcirclegetarea-1">MLib.Circle.GetArea</a>
#####<a href="http://github.com/davisdude/mlib#mlibcirclecheckpoint-1">MLib.Circle.CheckPoint</a>
#####<a href="http://github.com/davisdude/mlib#mlibcirclegetcircumference-1">MLib.Circle.GetCircumference</a>
#####<a href="https://github.com/davisdude/mlib#mlibcircleislinesecant-1">MLib.Circle.IsLineSecant</a>
#####<a href="https://github.com/davisdude/mlib#mlibcircleissegmentsecant-1">MLib.Circle.IsSegmentSecant</a>
#####<a href="http://github.com/davisdude/mlib#mlibcirclecircleintersects-1">MLib.Circle.CircleIntersects</a>
#####<a href="http://github.com/davisdude/mlib#mlibcircleispointincircle-1">MLib.Circle.IsPointInCircle</a>
####<a href="http://github.com/davisdude/mlib#mlibstatistics-1">MLib.Statistics</a>
#####<a href="http://github.com/davisdude/mlib#mlibstatisticsgetmean-1">MLib.Statistics.GetMean</a>
#####<a href="http://github.com/davisdude/mlib#mlibstatisticsgetmedian-1">MLib.Statistics.GetMedian</a>
#####<a href="http://github.com/davisdude/mlib#mlibstatisticsgetmode-1">MLib.Statistics.GetMode</a>
#####<a href="http://github.com/davisdude/mlib#mlibstatisticsgetrange-1">MLib.Statistics.GetRange</a>
#####<a href="http://github.com/davisdude/mlib#mlibstatisticsgetfrequency-1">MLib.Statistics.GetFrequency</a>
####<a href="http://github.com/davisdude/mlib#mlibmath-1">MLib.Math</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathgetroot-1">MLib.Math.GetRoot</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathisprime-1">MLib.Math.IsPrime</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathround-1">MLib.Math.Round</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathgetsummation-1">MLib.Math.GetSummation</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathgetpercentofchange-1">MLib.Math.GetPercentOfChange</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathgetpercent-1">MLib.Math.GetPercent</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathgetrootsofquadratic-1">MLib.Math.GetRootsOfQuadratic</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathgetangle-1">MLib.Math.GetAngle</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathfactorial-1">MLib.Math.Factorial</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathsystemofequations-1">MLib.Math.SystemOfEquations</a>

#Functions
####MLib.Line
Deals with linear aspects, such as slope. Also handles line segments.
#####MLib.Line.GetLength
- Gets the length from one set of points to another. 
- Synopsis:
  - `MLib.Line.GetLength( x1, y1, x2, y2 )`
- Arguments:
  - `x1`: Number. The x-coordinate of the first point.
  - `y1`: Number. The y-coordinate of the first point.
  - `x2`: Number. The x-coordinate of the second point.
  - `y2`: Number. The y-coordinate of the second point. 
- Returns:
  - The distance between the two points. 
- Example:
  - Gets the length from ( 1, 1 ) to ( 2, 1 ), which is 1.
    - `Length = MLib.Line.GetLength( 1, 1, 2, 1 )`

#####MLib.Line.GetMidpoint
- Gets the <a href="http://en.wikipedia.org/wiki/Midpoint">midpoint</a> of a two points. 
- Synopsis:
    - `MLib.Line.GetMidpoint( x1, y1, x2, y2 )`
- Arguments: 
  - `x1`: Number. The x-coordinate of the first point.
  - `y1`: Number. The y-coordinate of the first point.
  - `x2`: Number. The x-coordinate of the second point.
  - `y2`: Number. The y-coordinate of the second point. 
- Returns:
  - The midpoint of the two points.
- Example:
  - Gets the midpoint from ( 0, 0 ) to ( 2, 2 ) which is ( 1, 1 ). 
    - `x, y = MLib.Line.GetMidpoint( 0, 0, 2, 2 )`

#####MLib.Line.GetSlope
- Gets the <a href="http://en.wikipedia.org/wiki/Slope">slope</a> of a line.
- Synopsis:
  - `MLib.Line.GetSlope( x1, y1, x2, y2 )`
- Arguments: 
  - `x1`: Number. The x-coordinate of the first point.
  - `y1`: Number. The y-coordinate of the first point.
  - `x2`: Number. The x-coordinate of the second point.
  - `y2`: Number. The y-coordinate of the second point.
- Returns:
  - The slope of the line that consists of those two points.
  - __IMPORTANT__: If the line is vertical, it will return false. 
- Examples:
  - Gets the slope of a line with points on ( 1, 1 ) and ( 0, 0 ), which is 1.
    - `Slope = milb.Line.GetSlope( 1, 1, 0, 0 )`
  - Gets the slope of a vertical line with points on ( 5, 4 ) and ( 5, 6 ), which is `false`.
    - `Slope = MLib.Line.GetSlope( 5, 4, 5, 6 )`
    - __Note__: In reality, the slope would actually be `x = 5`, but since computers don't work that way, you need to make it a special case.

#####MLib.Line.GetPerpendicularSlope
- Gets the <a href="http://en.wikipedia.org/wiki/Perpendicular">perpendicular</a> slope of a line.
- Synopsis: 
  - `MLib.Line.GetPerpendicularSlope( x1, y1, x2, y2 )`
  - `MLib.Line.GetPerpendicularSlope( Slope )`
- Arguments:
  - `MLib.Line.GetPerpendicularSlope( x1, y1, x2, y2 )`
    - `x1`: Number. The x-coordinate of the first point of the original line.
    - `y1`: Number. The y-coordinate of the first point of the original line.
    - `x2`: Number. The x-coordinate of the second point of the original line.
    - `y2`: Number. The y-coordinate of the second point of the original line.
  - `MLib.Line.GetPerpendicularSlope( Slope )`
    - `Slope`: Number. The slope of the original line.
- Returns:
  - The slope that is perpendicular to the original slope.
  - __IMPORTANT__: If the original line is horizontal, then the perpendicular line will be vertical, so it will return `false`.
- Examples:
  - Gets the slope perpendicular to the line with points on ( 1, 1 ) and ( 4, 4 ), which is -1.
    - `PerpendicularSlope = MLib.Line.GetPerpendicularSlope( 1, 1, 4, 4 )`
  - Gets the slope perpendicular to the line with points on ( 1, 1 ) and ( 4, 4 ), which is -1.
    - `Slope = MLib.Line.GetSlope( 1, 1, 4, 4 )`
    - `PerpendicularSlope = MLib.Line.perpendicularSlop( Slope )`

#####MLib.Line.GetPerpendicularBisector
- Gets the <a href="http://en.wikipedia.org/wiki/Bisection#Perpendicular_bisectors">perpendicular bisector</a> between two points. 
- Synopsis:
  - `MLib.Line.GetPerpendicularBisector( x1, y1, x2, y2 )`
- Arguments:
  - `x1`: Number. The x-coordinate of the first point.
  - `y1`: Number. The y-coordinate of the first point.
  - `x2`: Number. The x-coordinate of the second point.
  - `y2`: Number. The y-coordinate of the second point.
- Returns:
  - The perpendicular slope and the midpoint of the line.
- Example:
  - Gets the perpendicular biisector of ( 1, 1 ) and ( 3, 3 ), which will be 2, 2, -1.
    - `x, y, PerpendicularSlope = MLib.Line.GetPerpendicularBisector( 1, 1, 3, 3 )`

#####MLib.Line.GetIntercept
- Gets the <a href="http://en.wikipedia.org/wiki/Y-intercept">y-intercept</a> of a line.
- Synopsis:
  - `MLib.Line.GetIntercept( x1, y1, x2, y2 )`
  - `MLib.Line.GetIntercept( x, y, Slope )`
- Arguments:
  - `MLib.Line.GetIntercept( x1, y1, x2, y2 )`
    - `x1`: Number. The x-coordinate of the first point.
    - `y1`: Number. The y-coordinate of the first point.
    - `x2`: Number. The x-coordinate of the second point.
    - `y2`: Number. The y-coordinate of the second point.
  - `MLib.Line.GetIntercept( x, y, Slope )`
    - `x`: Number. An x-coordinate of the line.
    - `y`: Number. A y-coordinate of the line.
    - `Slope`: Number. The slope of the line.
- Returns:
  - The y-intercept of the line. 
  - __IMPORTANT__: If the line is vertical, it has no intercept, so it will return `false`.
- Examples:
  - Gets the y-intercept of ( 0, 0 ) and ( 1, 1 ), which is 0.
    - `Intercept = MLib.Line.GetIntercept( 0, 0, 1, 1 )`
  - Gets the y-intercept of ( 0, 0 ) and ( 1, 1 ), which is 0.
    - `Slope = MLib.Line.GetSlope( 0, 0, 1, 1 )`
    - `Inercept = MLib.Line.GetIntercept( 0, 0, Slope )`

#####MLib.Line.GetIntersection
- Gets where two lines intersect.
- Synopsis:
  - `MLib.Line.GetIntersection( Slope, Intercept, x1, y1, x2, y2 )`
  - `MLib.Line.GetIntersection( Slope1, Intercept1, Slope2, Intercept2 )`
  - `MLib.Line.GetIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )`
- Arguments:
  - `MLib.Line.GetIntersection( Slope, Intercept, x1, y1, x2, y2 )`
    - `Slope`: Number. The slope of the first line. 
    - `Intercept`: Number. The y-intercept of the first line. 
    - `x1`: Number. The x-coordinate of the first point.
    - `y1`: Number. The y-coordinate of the first point.
    - `x2`: Number. The x-coordinate of the second point.
    - `y2`: Number. The y-coordinate of the second point.
  - `MLib.Line.GetIntersection( Slope1, b1, Slope2, b2 )`
    - `Slope1`: Number. The slope of the first line.
    - `Intercept1`: Number. The y-intercept of the first line. 
    - `Slope2`: Number. The slope of the second line.
    - `Intercept2`: Number. The y-intercept of the second line. 
  - `MLib.Line.GetIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )`
    - `x1`: Number. The one x-coordinate of the first line.
    - `y1`: Number. The one y-coordinate of the first line.
    - `x2`: Number. The the other x-coordinate of the second line.
    - `y2`: Number. The the other y-coordinate of the second line.
	- `x3`: Number. The one x-coordinate of the third line.
    - `y3`: Number. The one y-coordinate of the third line.
    - `x4`: Number. The the other x-coordinate of the fourth line.
    - `y4`: Number. The the other y-coordinate of the fourth line.
- Returns:
  - Where the lines intersect.
  - __IMPORTANT__: If the lines are parallel, it will return false.
- Examples:
  - Gives the x and y where the lines with slopes of 1 and -1 and y-intercepts of 0, 2 will intersect ( 1, 1 ).
    - `x, y = MLib.Line.GetIntersection( 1, 0, -1, 2 )`
  - Gives the x and y where the first line has a slope of 1 and y-intercept of 0 and the second has points on ( -2, 0 ) and ( 0, 2 ), which is ( 1, 1 ).
    - `x, y = MLib.Line.GetIntersection( 1, 0, -2, 0, 0, 2 )`
  - Gives the x and y where one has a slope of 0, y-intercept of 5, the other has a slope of 0 and y-intercept of 2, which is `false`.
    - `x, y = MLib.Line.GetIntersection( 0, 5, 0, 2 )`

#####MLib.Line.GetClosestPoint
- Gives the closest point on a line to the given point.
- Synopsis:
  - `MLib.Line.GetClosestPoint( x, y, x1, y1, x2, y2 )`
  - `MLib.Line.GetClosestPoint( x, y, Slope, Intercept )`
- Arguments:
  - `MLib.Line.GetClosestPoint( x, y, x1, y1, x2, y2 )`
    - `x`: Number. The x-coordinate of the point.
    - `y`: Number. The y-coordinate of the point.
    - `x1`: Number. The x-coordinate for the first point of the second line.
    - `y1`: Number. The y-coordinate for the first point of the second line.
    - `x2`: Number. The x-ccordinate for the second point of the second line.
    - `y2`: Number. The y-coordinate for the second point of the second line.
  - `MLib.Line.GetClosestPoint( x, y, slope, yIntercept )`
    - `x`: Number. The x-coordinate of the point.
    - `y`: Number. The y-coordinate of the point.
    - `Slope`: 
      - Number. The slope of the line.
      - Boolean (false) if the line is vertical. 
    - `Intercept`: 
      - Number. The y-intercept of the line.
      - Boolean (false) if the line is vertical.
- Returns:
  - Where the closest point on the line to the line is.
- Examples:
  - Gets the closest point to point ( 4, 2 ) and a line with a slope of 2 and a y-intercept of -1, which is ( 2, 3 ).
    - `x, y = MLib.Line.GetClosestPoint( 4, 2, 2, -1 )`
  - Gets the closest point to point ( 4, 2 ) and a line with points on ( 1, 1 ) and ( 3, 5 ), which is ( 2, 3 ).
    - `x, y = MLib.Line.GetClosestPoint( 4, 2, 1, 1, 3, 5 )`

#####MLib.Line.GetSegmentIntersection
- Gives where a line segment intersects a line. 
- Synopsis:
  - `MLib.Line.GetSegmentIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )`
  - `MLib.Line.GetSegmentIntersection( x1, y1, x2, y2, Slope, Intercept )`
- Arguments:
  - `MLib.Line.GetSegmentIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )`
    - `x1`: Number. The first x-coordinate of the line segment.
    - `y1`: Number. The first y-coordinate of the line segment.
    - `x2`: Number. The second x-coordinate of the line segment.
    - `y2`: Number. The second y-coordinate of the line segment.
    - `x3`: Number. An x-coordinate on the line.
    - `y3`: Number. A y-coordinate on the line.
    - `x4`: Number. Another x-coordinate on the line.
    - `y4`: Number. Another y-coordinate on the line. 
  - `MLib.Line.GetSegmentIntersection( x1, y1, x2, y2, slope, yIntercept )`
    - `x1`: Number. The first x-coordinate of the line segment.
    - `y1`: Number. The first y-coordinate of the line segment.
    - `x2`: Number. The second x-coordinate of the line segment.
    - `y2`: Number. The second y-coordinate of the line segment.
    - `Slope`:Number. The slope of the line.
    - `Intercept`: Number. The y-intercept of the line.
- Returns:
  - The x and y coordinates where they intersect.
  - `false` if they don't intersect. 
- Examples:
  - Gets the intersection of a line segment ( 3, 6 ) and ( 5, 8 ) and a line ( 3, 8 ), ( 5, 6 ), which is ( 4, 7 ).
    - `x, y = MLib.Line.GetSegmentIntersection( 3, 6, 5, 8, 3, 8, 5, 6 )`
  - Gets the intersection of a line segment ( 3, 6 ) and ( 5, 8 ) and a line with a slope of -1 and a y-intercept of 11, which is ( 4, 7 ).
    - `x, y = MLib.Line.GetSegmentIntersection( 3, 6, 5, 8, -1, 11 )`

####MLib.Line.Segment
Handles the line segment aspect of lines.
#####MLib.Line.Segment.CheckPoint
- Checks whether or not a point is on a line segment.
- Synopsis:
  - `MLib.Line.Segment.CheckPoint( x1, y1, x2, y2, PointX, PointY )`
- Arguments:
  - `x1`: Number. The first x-coordinate of the line segment. 
  - `y1`: Number. The first y-coordinate of the line segment.
  - `x2`: Number. The second x-coordinate of the line segment.
  - `y2`: Number. The second y-coordinate of the line segment.
  - `PointX`: Number. The x-coordinate of the point that you are testing
  - `PointY`: Number. The y-coordinate of the point that you are testing. 
- Returns:
  - `true` if the point is on the line segment.
  - `false` if the point is not on the line segment.
- Example:
  - Returns `true`, because the point ( 1, 1 ) is on the line segment ( 2, 2 ), ( 0, 0 ).
    - `PointIsOnLine = MLib.Line.Segment.CheckPoint( 2, 2, 0, 0, 1, 1 )`

#####MLib.Line.Segment.GetIntersection
- Checks if two line segments intersect.
- Synopsis:
  - `MLib.Line.Segment.GetIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )`
- Arguments:
  - `x1`: Number. The first x-coordinate of the first line segment.
  - `y1`: Number. The first y-coordinate of the first line segment.
  - `x2`: Number. The second x-coordinate of the first line segment.
  - `y2`: Number. The second y-coordinate of the first line segment.
  - `x3`: Number. The first x-coordinate of the second line segment.
  - `y3`: Number. The first y-coordinate of the second line segment.
  - `x4`: Number. The second x-coordinate of the second line segment.
  - `y4`: Number. The second y-coordinate of the second line segment.
- Returns:
  - x, y if the line segments do intersect.
  - `false` if the line segments don't intersect.
  - x1, y1, x2, y2 if the line segments have the same slope and y-intercept and intersect. 
    - The `x1`, `y1` represent the beginning of the intersection. `x2`, `y2` represent the end of the intersection.
- Examples:
  - Checks if the line segments ( 1, 1 ), ( 5, 3) and ( 2, 3 ), ( 4, 1 ) intersect, which do, at ( 3, 2 ).
    - `x1, y1, x2, y2 = MLib.Line.Segment.GetIntersection( 1, 1, 5, 3, 2, 3, 4, 1 )`
      - Output: 3, 2, nil, nil
  - Checks if the line segments ( 3, 7 ), ( 6, 8 ) and ( 1, 6 ), ( 5, 4 ) intersect, which don't.
    - `x1, y1, x2, y2 = MLib.Line.Segment.GetIntersection( 3, 7, 6, 8, 1, 6, 5, 4 )`
      - Output: false, nil, nil, nil
  - Checks if the line segments ( 0, 0 ), ( 2, 2 ) and ( 1, 1 ), ( 3, 3 ) intersect, which they do, from ( 1, 1 ) to ( 2, 2 )
    - `x1, y1, x2, y2 = MLib.Line.Segment.GetIntersection( 0, 0, 2, 2, 1, 1, 3, 3 )`
      - Output: 1, 1, 2, 2

####MLib.Polygon
Handles polygon-related functions.
#####MLib.Polygon.GetTriangleHeight
- Gives the height of a triangle.
- Synopsis:
  - `MLib.Polygon.GetTriangleHeight( Base, x1, y1, x2, y2, x3, y3 )`
  - `MLib.Polygon.GetTriangleHeight( Base, Area )`
- Arguments:
  - `MLib.Polygon.GetTriangleHeight( Base, x1, y1, x2, y2, x3, y3 )`
    - `Base`: Number. Length of the base of the triangle.
    - `x1`: Number. First x-coordinate of the triangle.
    - `y1`: Number. First y-coordinate of the triangle.
    - `x2`: Number. Second x-coordinate of the triangle.
    - `y2`: Number. Second y-coordinate of the triangle.
    - `x3`: Number. Third x-coordinate of the triangle.
    - `y3`: Number. Third y-coordinate of the triangle.
  - `MLib.Polygon.GetTriangleHeight( base, area )`
    - `Base`: Number. Length of the base of the triangle.
    - `Area`: Number. Area of the triangle.
- Returns:
  - The height and area of the triangle.
- Example:
  - Gives the height of a triangle at ( 0, 0 ), ( 0, 4 ) and  ( 3, 0 ) and a base of 3. The height is 4, area is 6.
    - `Height, Area = MLib.Polygon.GetTriangleHeight( 3, 0, 0, 0, 4, 3, 0 )`
  - Gives the height of a triangle with a base of 3 and an area of 6. The height is 4.
    - `Height, Area = MLib.Polygon.GetTriangleHeight( 3, 6 )`

#####MLib.Polygon.GetSignedArea
- Gives the signed area of any <a href="http://en.wikipedia.org/wiki/Simple_polygon">simple polygon</a>.
- Synopsis:
  - `MLib.Polygon.GetArea( Vertices )`
- Arguments:
  - `Vertices`: 
    - Table. Contains the x and y of the vertices.
    - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns:
  - The area of the polygon.
- Example: 
  - Gives the area of the polygon with points at ( 0, 0 ), ( 0, 4 ), ( 3, 0 ), which has an area of 6.
    - `Vertices = { 0, 0, 0, 4, 3, 0 }`
    - `Area = MLib.Polygon.GetSignedArea( Vertices )`
  - Gives the area of the polygon with points at ( 0, 0 ), ( 0, 4 ), ( 3, 0 ), ( 3, 4 ), which has an area of 12.
    - `Area = MLib.Polygon.GetSignedArea( 0, 0, 0, 4, 3, 0, 3, 4 )`
	
#####MLib.Polygon.GetArea
- Gives the area of any <a href="http://en.wikipedia.org/wiki/Simple_polygon">simple polygon</a>.
- Synopsis:
  - `MLib.Polygon.GetArea( Vertices )`
- Arguments:
  - `Vertices`: 
    - Table. Contains the x and y of the vertices.
    - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns:
  - The area of the polygon.
- Example: 
  - Gives the area of the polygon with points at ( 0, 0 ), ( 0, 4 ), ( 3, 0 ), which has an area of 6.
    - `Vertices = { 0, 0, 0, 4, 3, 0 }`
    - `Area = MLib.Polygon.GetArea( Vertices )`
  - Gives the area of the polygon with points at ( 0, 0 ), ( 0, 4 ), ( 3, 0 ), ( 3, 4 ), which has an area of 12.
    - `Area = MLib.Polygon.GetArea( 0, 0, 0, 4, 3, 0, 3, 4 )`

#####MLib.Polygon.GetCentroid
- Gives the <a href="http://en.wikipedia.org/wiki/Centroid">centroid</a> of any <a href="http://en.wikipedia.org/wiki/Simple_polygon">simple polygon</a>.
- Synopsis:
  - `MLib.Polygon.GetCentroid( Vertices )`
- Arguments:
  - `Vertices`: 
    - Table. Contains the x and y of the vertices.
    - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns:
  - The centroid x and y of the polygon.
- Example:
  - Gives the centroid of the polygon with points at ( 0, 0 ), ( 0, 6 ), ( 3, 0 ), which is at ( 1, 2 )
    - `Vertices = { 0, 0, 0, 6, 3, 0 }`
    - `CentroidX, CentroidY = MLib.Polygon.GetCentroid( Vertices )`
  - Gives centroid of a polygon with points at ( 0, 0 ), ( 0, 4 ), ( 4, 4 ), ( 4, 0 )
    - `CentroidX, CentroidY = MLib.Polygon.GetCentroid( 0, 0, 0, 4, 4, 4, 4, 0 )`

#####MLib.Polygon.CheckPoint
- Checks whether or not a point is inside a <a href="http://en.wikipedia.org/wiki/Simple_polygon">simple polygon</a>.
- Synopsis:
  - `MLib.Polygon.CheckPoint( x, y, Vertices )`
- Arguments:
  - `x`: Number. The x-coordinate that is being checked.
  - `y`: Number. The y-coordinate that is being checked.
  - `Vertices`: 
    - Table. Contains the x and y of the vertices.
    - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns:
  - `true` if the point is inside the polygon.
  - `false` if the point is outside the polygon.
- Example:
  - Checks if the point ( 2, 2 ) is inside the polygon ( 0, 0 ), ( 0, 4 ), ( 4, 4 ), ( 4, 0 ). It is.
    - `PointIsInPolygon = MLib.Polygon.CheckPoint( 2, 2, 0, 0, 0, 4, 4, 4, 4, 0 )`
  - Checks if the point ( 7, 8 ) is inside the polygon ( 0, 0 ), ( 0, 4 ), ( 4, 4 ), ( 4, 0 ). It is not.
    - `PointIsInPolygon = MLib.Polygon.CheckPoint( 7, 8, 0, 0, 0, 4, 4, 4, 4, 0 )`

#####MLib.Polygon.LineIntersects
- Checks whether or not a line intersects a polygon. 
- Synopsis:
  - `MLib.Polygon.LineIntersects( x1, y1, x2, y2, ... )`
- Arguments:
  - `x1`: Number. An x-coordinate on the line. 
  - `y1`: Number. A y-coordinate on the line. 
  - `x2`: Number. Another x-coordinate on the line.
  - `y2`: Number. Another y-coordinate on the line. 
  - `...`: Table. The points of the polygon.
- Returns:
  - `Collisions`: Table. The spots where the line intersects the polygon if the line intersects the polygon. 
  - `false` if the line does not intersect the polygon.
- Example:
  - Check if a line with the points ( 3, 7 ) and ( 5, 4 ) intersects with the polygon. It does, at ( 3.8, 5.8 ), ( 4.6, 4.6 ).
    - `Collision = MLib.Polygon.LineIntersects( 3, 7, 5, 4, 3, 5, 4, 4, 5, 5, 6, 4, 6, 6, 3, 6 )`
  - Checks if a line with the points ( 2, 5 ) and ( 3, 7 ) intersects with the polygon. It does not. 
    - `LineIntersects = MLib.Polygon.LineIntersects( 2, 5, 3, 7, 3, 5, 4, 4, 5, 5, 6, 4, 6, 6, 3, 6 )`

#####MLib.Polygon.PolygonIntersects
- Checks whether or not two polygons intersect.
- Synopsis:
  - `MLib.Polygon.PolygonIntersects( polygon1, polygon2 )`
- Arguments:
  - `Polygon1`: Table. A table containing all of the points of `polygon1` in the form of `( x1, y1, x2, y2, ... )`.
  - `Polygon2`: Table. A table containing all of the points of `polygon2` in the form of `( x1, y1, x2, y2, ... )`.
- Returns:
  - `Collisions`: Table. The spots where the polygon intersects the other polygon if the polygon intersects the other polygon. 
  - `false` if the polygons don't intersect. 
- Example:
  - Checks if polygons with points ( 2, 6, ), ( 3, 8 ), ( 4, 6 ) and ( 4, 7 ), ( 3, 9 ), )( 5, 9 ) intersect. They don't.
    - `PolygonIntersects = MLib.Polygon.PolygonIntersects( { 2, 6, 3, 8, 4, 6 }, { 4, 7, 3, 9, 5, 9 } )`
  - Checks if polygons with points ( 2, 6 ), ( 3, 8 ), ( 4, 6 ) and ( 3, 7 ), ( 2, 9 ), ( 4, 9 ) intersect. They do, at, ( 2.75, 7.5 ), ( 3.25, 7.5 ).
    - `Collisions = MLib.Polygon.PolygonIntersects( { 2, 6, 3, 8, 4, 6 }, { 3, 7, 2, 9, 4, 9 } )`

#####MLib.Polygon.CircleIntersects
- Checks whether or not a circle intersects a polygon. 
- Synopsis:
  - `MLib.Polygon.CircleIntersects( CircleX, CircleY, Radius, Points )`
  - `MLib.Polygon.CircleIntersects( CircleX, CircleY, Radius, ... )`
- Arguments:
  - `MLib.Polygon.CircleIntersects( CircleX, CircleY, Radius, Points )`
    - `CircleX`: Number. The x location of the circle center. 
    - `CircleY`: Number. The y location of the circle center. 
    - `Radius`: Number. The radius of the circle.
    - `Points`: Table. A table containing all of the points of the polygon in the form of `( x1, y1, x2, y2, ... )`
  - `MLib.Polygon.CircleIntersects( CircleX, CircleY, Radius, ... )`
    - `CircleX`: Number. The x location of the circle center. 
    - `CircleY`: Number. The y location of the circle center. 
    - `Radius`: Number. The radius of the circle.
    - `...`: Numbers. All of the points of the polygon in the form of `( x1, y1, x2, y2, ... )`
- Returns:
  - `Collisions`: Table. The spots where the circle intersects the polygon if the circle intersects the polygon. 
  - `false` if the circle and polygon don't intersect.
- Example: 
  - Checks if a circle with a radius of 2 located on ( 3, 5 ) intersects with a polygon with points on ( 3, 1 ), ( 3, 6 ), ( 7, 4 ). It does, at ( 3, 3 ) and ( 5, 5 ).
    - `Collisions = MLib.Polygon.CircleIntersects( 3, 5, 2, 3, 1, 3, 6, 7, 4 )`
  - Checks if a circle with a radius of 2 located on ( 3, 3 ) intersects with a polygon with points on ( 2, 6 ), ( 4, 6 ), ( 3, 8 ). It does not. 
    - `CircleIntersects = MLib.Polygon.CircleIntersects( 3, 3, 2, 2, 6, 4, 6, 3, 8 )`
	
#####MLib.Polygon.IsPolygonInside
- Checks whether a polygon inside (or intersecting) another polygon. 
- Synopsis:
  - `MLib.Polygon.CircleIntersects( Polygon1, Polygon2 )`
- Arguments:
  - `MLib.Polygon.CircleIntersects( CircleX, CircleY, Radius, Points )`
    - `Polygon1`: Table. The coordinates of the polygon that is being checked to be on the outside.
    - `Polygon2`: Table. The coordinates of the polygon that is being checked to be on the inside. 
- Returns:
  - `Inside`: Boolean. `true` if `Polygon2` has at least one point inside `Polygon1`. `false` otherwise. 
- Example: 
  - Checks if a square at points ( 0, 0 ), ( 0, 4 ), ( 4, 4 ), ( 4, 0 ) encloses a square with coordinates ( 2, 2 ), ( 2, 3 ), ( 3, 3 ), ( 3, 2 ). It does. 
    - `Inside = MLib.Polygon.IsPolygonInside( { 0, 0, 0, 4, 4, 4, 4, 0 }, { 2, 2, 2, 3, 3, 3, 3, 2 } )`
  - Checks if a square at points ( 0, 0 ), ( 0, 4 ), ( 4, 4 ), ( 4, 0 ) encloses a square with coordinates ( 5, 5 ), ( 5, 7 ), ( 7, 7 ), ( 7, 5 ). It does not. 
    - `Inside = MLib.Polygon.IsPolygonInside( { 0, 0, 0, 4, 4, 4, 4, 0 }, { 5, 5, 5, 7, 7, 7, 7, 5 } )`

####MLib.Circle
Handles functions dealing with circles.
#####MLib.Circle.GetArea
- Gives the area of a circle.
- Synopsis: 
  - `MLib.Circle.GetArea( Radius )`
- Arguments:
  - `Radius`: Number. the radius of the circle.
- Returns:
  - The area of the circle.
- Example:
  - Get the area of a circle with a radius of 1. The area is 3.14159265359...
    - `Area = MLib.Circle.GetArea( 1 )`

#####MLib.Circle.CheckPoint
- Checks whether or not a point is on the outer-edge of a circle.
- Synopsis:
  - `MLib.Circle.CheckPoint( CircleX, CircleY, Radius, x, y )`
- Arguments:
  - `CircleX`: Number. The circle's x (where the center of the circle is).
  - `CircleY`: Number. The circle's y (where the center of the circle is).
  - `Radius`: Number. The radius of the circle.
  - `x`: Number. The x of the point you are testing.
  - `y`: Number. The y of the point you are testing.
- Returns:
  - `true` if the point is along the edge of the circle.
  - `false` if the point is not along the edge of the circle.
- Example:
  - Checks whether the circle has the point ( 1, 4 ) with its center at ( 3, 4 ) and a radius of ( 2 ), which it is. 
    - `PointIsOnCircle = MLib.Circle.CheckPoint( 3, 4, 2, 1, 4 )`

#####MLib.Circle.GetCircumference
- Gives the circumference of a circle.
- Synopsis:
  - `MLib.Circle.GetCircumference( Radius )`
- Arguments:
  - `Radius`: Number. The radius of the circle.
- Returns:
  - The circumference of the circle.
- Example:
  - Gives the circumference of the circle with a radius of 1, which is 6.28318530718...
    - `Circumference = MLib.Circle.GetCircumference( 1 )`

#####MLib.Circle.IsLineSecant
- Checks whether the line is a <a href="http://en.wikipedia.org/wiki/Secant_line">secant</a>, a <a href="http://en.wikipedia.org/wiki/Tangent">tangent</a> or neither.
- Synopsis:
  - `MLib.Circle.IsLineSecant( CircleX, CircleY, Radius, x1, x2, y1, y2 )`
  - `MLib.Circle.IsLineSecant( CircleX, CircleY, Radius, Slope, Intercept )`
- Arguments:
  - `MLib.Circle.IsLineSecant( CircleX, CircleY, Radius, x1, x2, y1, y2 )`
    - `CircleX`: Number. The x-coordinate of the center of the circle.
    - `CircleY`: Number. The y-coordinate of the center of the circle.
    - `Radius`: Number. The radius of the circle.
    - `x1`: Number. The first x-coordinate of the line.
    - `y1`: Number. The first y-coordinate of the line.
    - `x2`: Number. The second x-coordinate of the line.
    - `y2`: Number. The second y-coordinate of the line.
  - `MLib.Circle.IsLineSecant( CircleX, CircleY, Radius, Slope, Intercept )`
    - `CircleX`: Number. The x-coordinate of the center of the circle.
    - `CircleY`: Number. The y-coordinate of the center of the circle.
    - `Radius`: Number. The radius of the circle.
    - `Slope`: Number. The slope of the line.
    - `Intercept`: Number. The y-intercept of the line.
- Returns: 
  - `Type`:
    - String:
      - `'Secant'` if the line is a <a href="http://en.wikipedia.org/wiki/Secant_line">secant</a> to the circle.
      - `'Tangent'` if the line is tangental<a href="http://en.wikipedia.org/wiki/Tangent">tangent</a>
    - Boolean:
      - `false` if the line is neither a secant not a tangent.
  - `x1`: Number. The first x-coordinate of where the intersection occurs.
  - `y1`: Number. The first y-coordinate of where the intersection occurs.
  - `x2`: Number. The second x-coordinate of where the intersection occurs.
  - `y2`: Number. The second y-coordinate of where the intersection occurs.
- Example:
  - A line with points on ( 0, 9 ), ( 6, 9 ), and a circle center on ( 4, 9 ) and a radius of 1. 
    - `Type, x1, y1, x2, y2 = MLib.Circle.IsLineSecant( 4, 9, 1, 0, 9, 6, 9 ) }
      - Output: `'Secant', 3, 9, 5, 9`
  - A line with a slope of 0 and a y-intercept of 9 and a a circle center on ( 4, 9 ) and a radius of 1.
    - `Type, x1, y1, x2, y2 = MLib.Circle.IsLineSecant( 4, 9, 1, 0, 9 )`
      - Output: `'Secant', 3, 9, 5, 9. `
  - A line with points on ( 0, 8 ), ( 6, 8 ), and a circle center on ( 4, 9 ) and a radius of 1. 
	- `Type, x1, y1, x2, y2 = MLib.Circle.IsLineSecant( 4, 9, 1, 0, 8, 6, 8 )
      - Output: `'Tangent', 4, 8`

#####MLib.Circle.IsSegmentSecant
- Checks whether the line is a <a href="http://en.wikipedia.org/wiki/Secant_line">secant</a>, a <a href="http://en.wikipedia.org/wiki/Tangent">tangent</a> or neither.
- Synopsis:
  - `MLib.Circle.IsSegmentSecant( CircleX, CircleY, Radius, x1, y1, x2, y2 )`
- Arguments:
  - `CircleX`: Number. The x-coordinate of the center of the circle.
  - `CircleY`: Number. The y-coordinate of the center of the circle.
  - `Radius`: Number. The radius of the circle.
  - `x1`: Number. The first x-coordinate of the line.
  - `y1`: Number. The first y-coordinate of the line.
  - `x2`: Number. The second x-coordinate of the line.
  - `y2`: Number. The second y-coordinate of the line.
- Returns: 
  - `Type`:
    - String:
      - `'Secant'` if the line is a <a href="http://en.wikipedia.org/wiki/Secant_line">secant</a> to the circle.
      - `'Tangent'` if the line is tangental <a href="http://en.wikipedia.org/wiki/Tangent">tangent</a>
	  - `'Enclosed'` if the line is completely within the circle. 
	  - `'Chord'` if the line is exactly on the circle's circumference. 
    - Boolean:
      - `false` if the line is neither a secant not a tangent.
  - `x1`: Number. The first x-coordinate of where the intersection occurs.
  - `y1`: Number. The first y-coordinate of where the intersection occurs.
  - `x2`: Number. The second x-coordinate of where the intersection occurs.
  - `y2`: Number. The second y-coordinate of where the intersection occurs.
- Example:
  - A line segment with points on ( 0, 9 ), ( 6, 9 ), and a circle center on ( 4, 9 ) and a radius of 1. 
    - `Type, x1, y1, x2, y2 = MLib.Circle.IsLineSecant( 4, 9, 1, 0, 9, 6, 9 )`
      - Output: `'Secant', 3, 9, 5, 9`

#####MLib.Circle.CircleIntersects
- Returns the point that intersects the circles.
- Synopsis:
  - `MLib.Circle.CircleIntersects( CircleX1, CircleY1, Radius1, CircleX2, CircleY2, Radius2 )`
- Arguments: 
  - `CircleX1`: Number. The x-coordinate of the first center circle.
  - `CircleY1`: Number. The y-coordinate of the first center circle.
  - `Radius1`: Number. The radius of the first circle.
  - `CircleX2`: Number. The x-coordinate of the second center circle.
  - `CircleY2`: Number. The y-coordinate of the second center circle.
  - `Radius2`: Number. The radius of the first circle.
- Returns:
  - String:
	- `'Equal'` if the circles have the same x and y and radius. 
	- `'Colinear'` if the circles have the same x and y, but different radii. 
  - The points where the circles intersect.
  - `false` if they don't intersect.
- Example:
  - Checks whether circle 1, at ( 1, 1 ) and a radius of 1, and circle 2 at ( 2, 2 ) and a radius of 1 intersect. It does, at ( 2, 1 ), ( 1, 2 ). 
    - `MLib.Circle.CircleIntersects( 1, 1, 1, 2, 2, 1 )`

#####MLib.Circle.IsPointInCircle
- Returns if the point is in the circle.
- Synopsis:
  - `MLib.Circle.IsPointInCircle( CircleX, CircleY, Radius, x, y )
- Arguments:
  - `CircleX`: Number. The x-coordinate of the center of the circle.
  - `CircleY`: Number. The y-coordinate of the center of the circle. 
  - `Radius`: Number. The radius of the circle. 
  - `x`: Number. The x-position of the point being checked. 
  - `y`: Number. The y-position of the point being checked. 
- Returns:
  - Boolean:
	- `true` if the point is inside the circle. 
    - `false` if the point is not inside the circle. 
- Example:
  - Checks if the point ( 0, 1 ) is inside a circle with a center of ( 0, 0 ) and a radius of 2. 
	- `MLib.Circle.IsPointInsideCircle( 0, 0, 2, 0, 1 )`

####MLib.Statistics
Handles functions dealing with statisticsistics.
#####MLib.Statistics.GetMean
- Gives the <a href="http://en.wikipedia.org/wiki/Arithmetic_mean">arithmetic mean</a> of the data set.
- Synopsis: 
  - `MLib.Statistics.GetMean( Data )`
- Arguments:
  - `data`: 
    - Table. Contains the numbers data.
    - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns:
  - The average of the numbers.
- Example:
  - Gets the average of a data set containing the numbers 1, 2, 3, 4, and 5, which is 3.
    - `Mean = MLib.Statistics.GetMean( 1, 2, 3, 4, 5 )`

#####MLib.Statistics.GetMedian
- Gets the <a href="http://en.wikipedia.org/wiki/Median">median</a> of the data set. 
- Synopsis:
  - `MLib.Statistics.GetMedian( Data )`
- Arguments:
  - Table. Contains the numbers data.
  - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns: 
  - The median of the numbers.
- Example:
  - Gets the median of a data set containing the numbers, 1, 2, 3, 4, and 5, which is 3.
    - `Median = MLib.Statistics.GetMedian( 1, 2, 3, 4, 5 )`

#####MLib.Statistics.GetMode
- Gets the <a href="http://en.wikipedia.org/wiki/Mode_(statisticsistics)">mode</a> of the data set. 
- Synopsis: 
  - `MLib.Statistics.GetMode( Data )`
- Arguments:
  - Table. Contains the numbers data.
  - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns: 
  - If there is one mode or more:
	- `Numbers`: Table. A table in the form `{ Number1, Number2, etc. }`
	- `Occurrences`: Number. The number of times the number(s) appeared. 
  - `false` if there is not a mode. 
- Example:
  - Gets the median of a data set containing the numbers, 1, 5, 6, 22, 2, 2, 1, 2, which is 2, which appears 3 times.
    - `Modes, Times = MLib.Statistics.GetMode( 1, 5, 6, 22, 2, 2, 1, 2 )`

#####MLib.Statistics.GetRange
- Gets the <a href="http://en.wikipedia.org/wiki/Range_(statisticsistics)">range</a> of the data set. 
- Synopsis:
  - `MLib.Statistics.GetRange( Data )`
- Arguments:
  - Table. Contains the numbers data.
  - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns: 
  - The range of the numbers.
- Example:
  - Gets the range of a data set containing the numbers, 1, 2, 3, and 4, which is 3.
    - `Range = MLib.Statistics.GetRange( 1, 2, 3, 4 )`

####MLib.Statistics.GetFrequency
- Gets the <a href="http://en.wikipedia.org/wiki/Frequentist_probability#Definition">frequency</a> of the occurrences. 
- Synopsis:
  - MLib.Statistics.GetFrequency( TotalTrials, SuccessfulTrials )
- Arguments:
  - `TotalTrials`: Number. The number of trials attempted. 
  - `SuccessfulTrials`: Number. The number of successful trials. 
- Returns: 
  - The frequency of the occurrence. 
- Example:
  - Gets the frequency of 1/10 successful attempts (.1). 
    - `Frequency = MLib.Statistics.GetFrequency( 10, 1 )

####MLib.Math
Handles functions that have to do with math in general.
#####MLib.Math.GetRoot
- Gets the nth root of a number.
- Synopsis:
  - `MLib.Math.GetRoot( Number, Root )`
- Arguments:
  - `Number`: Number. The number you are getting the nth root of.
  - `Root`: Number. The number that is n for the nth root.
- Returns:
  - The roots of the number (positive, negative).
- Example:
  - Gets the square (2) root of 4, which is 2.
    - `Root = MLib.Math.GetRoot( 4, 2 ) `

#####MLib.Math.IsPrime
- Checks whether a number or set of numbers is <a href="http://en.wikipedia.org/wiki/Prime">prime</a> or not.
- Synopsis: 
  - `MLib.Math.IsPrime( Number )`
- Arguments:
  - `Number`: Number. The number that is being checked for prime-ness.
- Returns:
  - `true` if the number is prime.
  - `false` if the number is not prime.
- Example:
  - Checks if the number 3 is prime or not. 3 is prime.
    - `Prime = MLib.Math.IsPrime( 3 )`

#####MLib.Math.Round
- Rounds a number up or down, depending on which it's closer to.
- Synopsis:
  - `MLib.Math.Round( Number )`
- Arguments:
  - `Number`: Number. The number that you want to round.
- Returns:
  - The number rounded up or down. 
- Example:
  - Rounds .999 up to 1
    - `new = MLib.Math.Round( .999 )`

#####MLib.Math.GetSummation
- Gives the <a href="http://en.wikipedia.org/wiki/Summation">summation</a>.
- Synopsis:
  - `MLib.Math.GetSummation( Start, Stop, Function )`
- Arguments:
  - `Start`: Number. Where should the summation begin?
  - `Stop`: Number. Where shuld the summation end?
  - `Function`: Function. A Functiontion that gives the new value to add to the previous. Can have two arguments:
    - `Index`: The first argument. Represents the current number
    - `Previous`: The second argument. Has all the previous values in it. 
      - __IMPORTANT__: If you use `Previous`, your function must have an `if` statement, regarding what to do if there is not a value for that number yet. 
- Returns:
  - The sum of all of the values.
- Example:
  - Gives the sum of numbers that start at 1 and end at 10, multiplying each time by 2, which is 110. 
    - `Sum = MLib.Math.GetSummation( 1, 10, function( Index ) return ( Index * 2 ) end )`
  - Gives the sum of numbers that start at 1 and end at 5, adding the previous value each time, which is 35.
    - `Sum = MLib.Math.GetSummation( 1, 5, function( Index, Previous ) if Previous[Index - 1] then return Index + Previous[Index - 1] else return 1 end end )`

#####MLib.Math.GetPercentOfChange
- Gives the <a href="http://en.wikipedia.org/wiki/Percentage_change#Percentage_change">percent of change</a> from two numbers.
- Synopsis:
  - `MLib.Math.GetPercentOfChange( Old, New )`
- Arguments:
  - `Old`: Number. The previous number.
  - `New`: Number. The new number.
- Returns:
  - The percentage difference from `old` to `new`.
- Example:
  - Gets the percent of change going from 2 to 4, or 1 (or 100%).
    - `MLib.Math.GetPercentOfChange( 2, 4 )`

#####MLib.Math.GetPercent
- Gets the percentage of a number. 
- Synopsis:
  - `MLib.Math.GetPercent( Percent, Number )`
- Arguments:
  - `Percent`: Number. The percentage you are getting of `Number`.
  - `Number`: Number. The number that is getting changed. 
- Returns:
  - `Percentage`% of `Number`.
- Example:
  - 100% of 2 is 2.
    - `MLib.Math.GetPercent( 1, 2 )`

#####MLib.Math.GetRootsOfQuadratic
- Gets the `x` of the <a href="http://en.wikipedia.org/wiki/Quadratic_equation">quadratic equation</a>.
- Synopsis:
  - `MLib.Math.GetRootsOfQuadratic( a, b, c )`
- Arguments:
  - `a`: Number. The number that has `x^2` next to it.
  - `b`: Number. The number that has `x` next to it.
  - `c`: Number. The number that has no variable next to it.
- Returns:
  - `false` if the given quadratic has no solution. 
  - The value of x, otherwise.
- Example:
  - Gets the x of the quadratic equation `1 * x ^ 2 + 3 * x - 4`, which is -4, 1.
    - `x1, x2 = MLib.Math.GetRootsOfQuadratic( 1, 3, -4 )`

#####MLib.Math.GetAngle
- Gets the angle between two points.
- Synopsis:
  - `MLib.Math.GetAngle( x1, y1, x2, y2, x3, y3 )`
- Arguments:
  - `MLib.Math.GetAngle( x1, y1, x2, y2, x3, y3 )`
    - `x1`: Number. The x-coordinate of the first point.
    - `y1`: Number. The y-coordinate of the first point.
    - `x2`: Number. The x-coordinate of the second point.
    - `y2`: Number. The y-coordinate of the second point.
    - `x3`: Number. The x-coordinate of the third point.
    - `y3`: Number. The y-coordinate of the third point. 
- Returns:
  - The angle between point ( 1, 3 ) and ( 3, 1 ) with a vertex of ( 1, 1 ). This is 90 degrees or about 1.57079633 radians. 
- Example:
  - `Angle = MLib.Math.GetAngle( 1, 3, 1, 1, 3, 1 )
  
#####MLib.Statistics.Factorial
- Gets the factorial of the number. 
- Synopsis:
  - MLib.Math.Factorial( Number )
- Arguments:
  - `Number`: Number. The number you wish to get the factorial of. 
- Returns: 
  - The factorial of the number.
- Example:
  - Gets the factorial of 3 (1 * 2 * 3 = 6). 
    - `Factorial = MLib.Statistics.Factorial( 3 )`
	
#####MLib.Statistics.SystemOfEquations
- Gets the factorial of the number. 
- Synopsis:
  - MLib.Math.SystemOfEquations( Number, Function )
- Arguments:
  - `Number`: Number. The number you wish to get the factorial of. 
  - `Function`: Function. The function that determines how to accept input. 
- Returns: 
  - The proper value. 
- Example:
```lua
Factorial = MLib.Math.SystemOfEquations( 5, 
  function ( Number )
    if Number < 5 then return Number * 3 + 1
	elseif Number < 5 then return Number * 2 - 1
	else return Number end
  end
) -- Returns 5.```