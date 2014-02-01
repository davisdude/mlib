MLib
====

__MLib__ is a math library that does math functions for you. It is designed to be __easy to use__ and __intuitive__. It has many <a href="http://github.com/davisdude/mlib#function-list">functions</a>. 

__MLib__ is written in mostly pure <a href="http://lua.org">Lua</a> with some drawing functions using <a href="http://love2d.org">LÖVE</a>, which can be changed if need be. 

##Installation
You can get the most recent version of MLib by:

###Bash
```bash
git clone git://github.com/davisdude/mlib.git
````

###Download
The __latest release__ can be found <a href="https://github.com/davisdude/mlib/releases/tag/2.0.0">here</a> or <a href="http://love2d.org/forums/viewtopic.php?f=5&t=36552">here</a> (link is at the bottom of the first post).

##Usage of MLib##
Download the file called <a href="https://github.com/davisdude/mlib/blob/master/mlib.lua">`mlib.lua`</a> and put it somewhere in the file for the process you want it in. Use the *require* function to import the module into the library.

##An Example of Use
Here is an example of how to use MLib:
```lua
-- Require libraries
mlib = require 'path/mlib' 
-- The first "mlib" can be whatever you want it to be.
-- "path" is how you get to the file from the main directory of the application. 

-- Make your data
local line1 = { 0, 1, 1, 2 }
local line2 = { { x = 0, y = 0 }, { x = 1, y = 1 } }
-- You can set up the data any way. line1 is more compatable with the library, but line2 will work, too.

-- Get the slope and y-intercept for the data.
local m1, b1 = mlib.line.slope( unpack( line1 ) ), mlib.line.intercept( unpack( line1 ) )
local m2, b2 = mlib.line.slope( line2[1].x, line2[1].y, line2[2].x, line2[2].y ), mlib.line.intercept( line2[1].x, line2[1].y, line2[2].x, line2[2].y )

print( "Line 1: \n\tSlope: "..m1.."\n\tY-Intercept: "..b1 )
print( "Line 2: \n\tSlope: "..m2.."\n\tY-Intercept: "..b2 )

--> Output: 
--> Line 1
-->   Slope: 1
-->   Y-Intercept: 1
--> Line 2
-->   Slope: 1
-->   Y-Intercept: 0
````

#Function List
####<a href="http://github.com/davisdude/mlib#mlibline-1">mlib.line</a>
#####<a href="http://github.com/davisdude/mlib#mliblinelength-1">mlib.line.length</a>
#####<a href="http://github.com/davisdude/mlib#mliblinemidpoint-1">mlib.line.midpoint</a>
#####<a href="http://github.com/davisdude/mlib#mliblineslope-1">mlib.line.slope</a>
#####<a href="http://github.com/davisdude/mlib#mliblineperpendicularslope-1">mlib.line.perpendicularSlope</a>
#####<a href="http://github.com/davisdude/mlib#mliblineperpendicularbisector-1">mlib.line.perpendicularBisector</a>
#####<a href="http://github.com/davisdude/mlib#mliblineintercept-1">mlib.line.intercept</a>
#####<a href="http://github.com/davisdude/mlib#mliblinedraw-1">mlib.line.draw</a>
#####<a href="http://github.com/davisdude/mlib#mliblinedrawstandard-1">mlib.line.drawStandard</a>
#####<a href="http://github.com/davisdude/mlib#mliblineintersect-1">mlib.line.intersect</a>
#####<a href="http://github.com/davisdude/mlib#mliblineclosestpoint-1">mlib.line.closestPoint</a>
#####<a href="http://github.com/davisdude/mlib#mliblinesegmentintersects-1">mlib.line.segmentIntersects</a>
####<a href="http://github.com/davisdude/mlib#mliblinefunc-1">mlib.line.func</a>
#####<a href="http://github.com/davisdude/mlib#mliblinefuncget-1">mlib.line.func.get</a>
#####<a href="http://github.com/davisdude/mlib#mliblinefuncdraw-1">mlib.line.func.draw</a>
#####<a href="http://github.com/davisdude/mlib#mliblinefuncdrawstandard-1">mlib.line.func.drawStandard</a>
####<a href="http://github.com/davisdude/mlib#mliblinesegment-1">mlib.line.segment</a>
#####<a href="http://github.com/davisdude/mlib#mliblinesegmentcheckpoint-1">mlib.line.segment.checkPoint</a>
#####<a href="http://github.com/davisdude/mlib#mliblinesegmentintersect-1">mlib.line.segment.intersect</a>
####<a href="http://github.com/davisdude/mlib#mlibpolygon-1">mlib.polygon</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygontriangleheight-1">mlib.polygon.triangleHeight</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygonarea-1">mlib.polygon.area</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygoncentroid-1">mlib.polygon.centroid</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygoncheckpoint-1">mlib.polygon.checkPoint</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygonlineintersects-1">mlib.polygon.lineIntersects</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygonpolygonintersects-1">mlib.polygon.polygonIntersects</a>
#####<a href="http://github.com/davisdude/mlib#mlibpolygoncircleintersects-1">mlib.polygon.circleIntersects</a>
####<a href="http://github.com/davisdude/mlib#mlibcircle-1">mlib.circle</a>
#####<a href="http://github.com/davisdude/mlib#mlibcirclearea-1">mlib.circle.area</a>
#####<a href="http://github.com/davisdude/mlib#mlibcirclecheckpoint-1">mlib.circle.checkPoint</a>
#####<a href="http://github.com/davisdude/mlib#mlibcircleincircle-1">mlib.circle.inCircle</a>
#####<a href="http://github.com/davisdude/mlib#mlibcirclecircumference-1">mlib.circle.circumference</a>
#####<a href="http://github.com/davisdude/mlib#mlibcirclesecant-1">mlib.circle.secant</a>
#####<a href="http://github.com/davisdude/mlib#mlibcirclesegmentsecant-1">mlib.circle.segmentSecant</a>
#####<a href="http://github.com/davisdude/mlib#mlibcirclecirclesintersect-1">mlib.circle.circlesIntersect</a>
####<a href="http://github.com/davisdude/mlib#mlibstats-1">mlib.stats</a>
#####<a href="http://github.com/davisdude/mlib#mlibstatsmean-1">mlib.stats.mean</a>
#####<a href="http://github.com/davisdude/mlib#mlibstatsmedian-1">mlib.stats.median</a>
#####<a href="http://github.com/davisdude/mlib#mlibstatsmode-1">mlib.stats.mode</a>
#####<a href="http://github.com/davisdude/mlib#mlibstatsrange-1">mlib.stats.range</a>
####<a href="http://github.com/davisdude/mlib#mlibmath-1">mlib.math</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathroot-1">mlib.math.root</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathprime-1">mlib.math.prime</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathround-1">mlib.math.round</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathlog-1">mlib.math.log</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathsummation-1">mlib.math.summation</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathpercentofchange-1">mlib.math.percentOfChange</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathpercent-1">mlib.math.percent</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathquadraticfactor-1">mlib.math.quadraticFactor</a>
#####<a href="http://github.com/davisdude/mlib#mlibmathgetangle-1">mlib.math.getAngle</a>
####<a href="http://github.com/davisdude/mlib#mlibshape-1">mlib.shape</a>
#####<a href="http://github.com/davisdude/mlib#mlibshapenew-1">mlib.shape.new</a>
#####<a href="http://github.com/davisdude/mlib#mlibshapecheckcollisions-1">mlib.shape.checkCollisions</a>
#####<a href="http://github.com/davisdude/mlib#mlibshaperemove-1">mlib.shape.remove/a>

#Functions
####mlib.line
Deals with linear aspects, such as slope. Also handles <a href="http://en.wikipedia.org/wiki/Exponential_function">functions</a> and line segments.
#####mlib.line.length
- Gets the length from one set of points to another. 
- Synopsis:
  - `mlib.line.length( x1, y1, x2, y2 )`
- Arguments:
  - `x1`: Number. The x-coordinate of the first point.
  - `y1`: Number. The y-coordinate of the first point.
  - `x2`: Number. The x-coordinate of the second point.
  - `y2`: Number. The y-coordinate of the second point. 
- Returns:
  - The distance between the two points. 
- Example:
  - Gets the length from ( 1, 1 ) to ( 2, 1 ), which is 1.
    - `length = mlib.line.length( 1, 1, 2, 1 )`

#####mlib.line.midpoint
- Gets the <a href="http://en.wikipedia.org/wiki/Midpoint">midpoint</a> of a two points. 
- Synopsis:
    - `mlib.line.midpoint( x1, y1, x2, y2 )`
- Arguments: 
  - `x1`: Number. The x-coordinate of the first point.
  - `y1`: Number. The y-coordinate of the first point.
  - `x2`: Number. The x-coordinate of the second point.
  - `y2`: Number. The y-coordinate of the second point. 
- Returns:
  - The midpoint of the two points.
- Example:
  - Gets the midpoint from ( 0, 0 ) to ( 2, 2 ) which is ( 1, 1 ). 
    - `x, y = mlib.line.midpoint( 0, 0, 2, 2 )`

#####mlib.line.slope
- Gets the <a href="http://en.wikipedia.org/wiki/Slope">slope</a> of a line.
- Synopsis:
  - `mlib.line.slope( x1, y1, x2, y2 )`
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
    - `slope = milb.line.slope( 1, 1, 0, 0 )`
  - Gets the slope of a vertical line with points on ( 5, 4 ) and ( 5, 6 ), which is `false`.
    - `slope = mlib.line.slope( 5, 4, 5, 6 )`
    - __Note__: In reality, the slope would actually be `x = 5`, but since computers don't work that way, you need to make it a special case.

#####mlib.line.perpendicularSlope
- Gets the <a href="http://en.wikipedia.org/wiki/Perpendicular">perpendicular</a> slope of a line.
- Synopsis: 
  - `mlib.line.perpendicularSlope( x1, y1, x2, y2 )`
  - `mlib.line.perpendicularSlope( slope )`
- Arguments:
  - `mlib.line.perpendicularSlope( x1, y1, x2, y2 )`
    - `x1`: Number. The x-coordinate of the first point of the original line.
    - `y1`: Number. The y-coordinate of the first point of the original line.
    - `x2`: Number. The x-coordinate of the second point of the original line.
    - `y2`: Number. The y-coordinate of the second point of the original line.
  - `mlib.line.perpendicularSlope( slope )`
    - `slope`: Number. The slope of the original line.
- Returns:
  - The slope that is perpendicular to the original slope.
  - __IMPORTANT__: If the original line is horizontal, then the perpendicular line will be vertical, so it will return `false`.
- Examples:
  - Gets the slope perpendicular to the line with points on ( 1, 1 ) and ( 4, 4 ), which is -1.
    - `perpendicular = mlib.line.perpendicularSlope( 1, 1, 4, 4 )`
  - Gets the slope perpendicular to the line with points on ( 1, 1 ) and ( 4, 4 ), which is -1.
    - `slope = mlib.line.slope( 1, 1, 4, 4 )`
    - `perpendicular = mlib.line.perpendicularSlop( slope )`

#####mlib.line.perpendicularBisector
- Gets the <a href="http://en.wikipedia.org/wiki/Bisection#Perpendicular_bisectors">perpendicular bisector</a> between two points. 
- Synopsis:
  - `mlib.line.perpendicularBisector( x1, y1, x2, y2 )`
- Arguments:
  - `x1`: Number. The x-coordinate of the first point.
  - `y1`: Number. The y-coordinate of the first point.
  - `x2`: Number. The x-coordinate of the second point.
  - `y2`: Number. The y-coordinate of the second point.
- Returns:
  - The perpendicular slope and the midpoint of the line.
- Example:
  - Gets the perpendicular biisector of ( 1, 1 ) and ( 3, 3 ), which will be -1, 2, 2.
    - `perpendicular, x, y = mlib.line.perpendicularBisector( 1, 1, 3, 3 )`

#####mlib.line.intercept
- Gets the <a href="http://en.wikipedia.org/wiki/Y-intercept">y-intercept</a> of a line.
- Synopsis:
  - `mlib.line.intercept( x1, y1, x2, y2 )`
  - `mlib.line.intercept( x, y, slope )`
- Arguments:
  - `mlib.line.intercept( x1, y1, x2, y2 )`
    - `x1`: Number. The x-coordinate of the first point.
    - `y1`: Number. The y-coordinate of the first point.
    - `x2`: Number. The x-coordinate of the second point.
    - `y2`: Number. The y-coordinate of the second point.
  - `mlib.line.intercept( x, y, slope )`
    - `x`: Number. An x-coordinate of the line.
    - `y`: Number. A y-coordinate of the line.
    - `slope`: Number. The slope of the line.
- Returns:
  - The y-intercept of the line. 
  - __IMPORTANT__: If the line is vertical, it has no intercept, so it will return `false`.
- Examples:
  - Gets the y-intercept of ( 0, 0 ) and ( 1, 1 ), which is 0.
    - `b = mlib.line.intercept( 0, 0, 1, 1 )`
  - Gets the y-intercept of ( 0, 0 ) and ( 1, 1 ), which is 0.
    - `slope = mlib.line.slope( 0, 0, 1, 1 )`
    - `b = mlib.line.intercept( 0, 0, slope )`

#####mlib.line.draw
- Draws the line using game-style coordinates (( 0, 0 ) being the top left, increasing as you go down/right). 
- Synopsis: 
  - `mlib.line.draw( slope, yIntercept )`
- Arguments:
  - `slope`: Number. The slope of the line. 
  - `yIntercept`: Number. The y-intercept of the line.
- Returns:
  - Nothing.
- Examples:
  - Draws a line with a slope of 1 and a y-intercept of 0.
    - `mlib.line.draw( 1, 0 )`
    - This line will start in the top left corner and go until x = height.

#####mlib.line.drawStandard
- Draws the line as if on a standard plane (( 0, 0 ) being the bottom left, increasing as you go up/right).
- Synopsis:
  - `mlib.line.drawStandard( slope, yIntercept )`
- Arguments:
  - `slope`: Number. The slope of the line. 
  - `yIntercept`: Number. The y-intercept of the line.
- Returns:
  - Nothing.
- Examples:
  - Draws a line with a slope of 1 and a y-intercept of 0.
    - `mlib.line.draw( 1, 0 )`
    - This line will start in the bottom left corner and go until x = height.

#####mlib.line.intersect
- Gets where two lines intersect.
- Synopsis:
  - `mlib.line.intersect( m, b, x1, y1, x2, y2 )`
  - `mlib.line.intersect( m1, b1, m2, b2 )`
- Arguments:
  - `mlib.line.intersect( m, b, x1, y1, x2, y2 )`
    - `m`: Number. The slope of the first line.
    - `b`: Number. The y-intercept of the first line.
    - `x1`: Number. The x-coordinate for the first point of the second line.
    - `y1`: Number. The y-coordinate for the first point of the second line.
    - `x2`: Number. The x-ccordinate for the second point of the second line.
    - `y2`: Number. The y-coordinate for the second point of the second line.
  - `mlib.line.intersect( m1, b1, m2, b2 )`
    - `m1`: Number. The slope of the first line.
    - `b1`: Number. The y-intercept of the first line. 
    - `m2`: Number. The slope of the second line.
    - `b2`: Number. The y-intercept of the second line. 
- Returns:
  - Where the lines intersect.
  - __IMPORTANT__: If the lines are parallel, it will return false.
- Examples:
  - Gives the x and y where the lines with slopes of 1 and -1 and y-intercepts of 0, 2 will intersect ( 1, 1 ).
    - `x, y = mlib.line.intersect( 1, 0, -1, 2 )`
  - Gives the x and y where the first line has a slope of 1 and y-intercept of 0 and the second has points on ( -2, 0 ) and ( 0, 2 ), which is ( 1, 1 ).
    - `x, y = mlib.line.intersect( 1, 0, -2, 0, 0, 2 )`
  - Gives the x and y where one has a slope of 0, y-intercept of 5, the other has a slope of 0 and y-intercept of 2, which is `false`.
    - `x, y = mlib.line.intersect( 0, 5, 0, 2 )`

#####mlib.line.closestPoint
- Gives the closest point on a line to the given point.
- Synopsis:
  - `mlib.line.closestPoint( x, y, x1, y1, x2, y2 )`
  - `mlib.line.closestPoint( x, y, slope, yIntercept )`
- Arguments:
  - `mlib.line.closestPoint( x, y, x1, y1, x2, y2 )`
    - `x`: Number. The x-coordinate of the point.
    - `y`: Number. The y-coordinate of the point.
    - `x1`: Number. The x-coordinate for the first point of the second line.
    - `y1`: Number. The y-coordinate for the first point of the second line.
    - `x2`: Number. The x-ccordinate for the second point of the second line.
    - `y2`: Number. The y-coordinate for the second point of the second line.
  - `mlib.line.closestPoint( x, y, slope, yIntercept )`
    - `x`: Number. The x-coordinate of the point.
    - `y`: Number. The y-coordinate of the point.
    - `slope`: 
      - Number. The slope of the line.
      - Boolean (false) if the line is vertical. 
    - `yIntercept`: 
      - Number. The y-intercept of the line.
      - Boolean (false) if the line is vertical.
- Returns:
  - Where the closest point on the line to the line is.
- Examples:
  - Gets the closest point to point ( 4, 2 ) and a line with a slope of 2 and a y-intercept of -1, which is ( 2, 3 ).
    - `x, y = mlib.line.closestPoint( 4, 2, 2, -1 )`
  - Gets the closest point to point ( 4, 2 ) and a line with points on ( 1, 1 ) and ( 3, 5 ), which is ( 2, 3 ).
    - `x, y = mlib.line.closestPoint( 4, 2, 1, 1, 3, 5 )`

#####mlib.line.segmentIntersects
- Gives where a line segment intersects a line. 
- Synopsis:
  - `mlib.line.segmentIntersects( x1, y1, x2, y2, x3, y3, x4, y4 )`
  - `mlib.line.segmentIntersects( x1, y1, x2, y2, slope, yIntercept )`
- Arguments:
  - `mlib.line.segmentIntersects( x1, y1, x2, y2, x3, y3, x4, y4 )`
    - `x1`: Number. The first x-coordinate of the line segment.
    - `y1`: Number. The first y-coordinate of the line segment.
    - `x2`: Number. The second x-coordinate of the line segment.
    - `y2`: Number. The second y-coordinate of the line segment.
    - `x3`: Number. An x-coordinate on the line.
    - `y3`: Number. A y-coordinate on the line.
    - `x4`: Number. Another x-coordinate on the line.
    - `y4`: Number. Another y-coordinate on the line. 
  - `mlib.line.segmentIntersects( x1, y1, x2, y2, slope, yIntercept )`
    - `x1`: Number. The first x-coordinate of the line segment.
    - `y1`: Number. The first y-coordinate of the line segment.
    - `x2`: Number. The second x-coordinate of the line segment.
    - `y2`: Number. The second y-coordinate of the line segment.
    - `slope`:Number. The slope of the line.
    - `yIntercept`: Number. The y-intercept of the line.
- Returns:
  - The x and y coordinates where they intersect.
  - `false` if they don't intersect. 
- Examples:
  - Gets the intersection of a line segment ( 3, 6 ) and ( 5, 8 ) and a line ( 3, 8 ), ( 5, 6 ), which is ( 4, 7 ).
    - `x, y = mlib.line.segmentIntersects( 3, 6, 5, 8, 3, 8, 5, 6 )`
  - Gets the intersection of a line segment ( 3, 6 ) and ( 5, 8 ) and a line with a slope of -1 and a y-intercept of 11, which is ( 4, 7 ).
    - `x, y = mlib.line.segmentIntersects( 3, 6, 5, 8, -1, 11 )`

####mlib.line.func
Handles the <a href="http://en.wikipedia.org/wiki/Exponential_function">exponential function</a> aspect of lines.
#####mlib.line.func.get
- Gets the a and the b of the function.
- Synopsis:
  - `mlib.line.func.get( x1, y1, x2, y2 )`
- Arguments:
  - `x1`: Number. The first x-coordinate on the exponential function.
  - `y1`: Number. The first y-coordinate on the exponential function.
  - `x2`: Number. The second x-coordinate on the exponential function. 
  - `y2`: Number. The second y-coordinate on the exponential function.
- Returns:
  - The a of the function and the b of the function.
  - Keep in mind, `y = a * ( b ^ x )`
  - __IMPORTANT__: Returns false if one of the y's if <= 0, since that's impossible. Also returns false if the x's are the same, since that is also impossible.
- Example:
  - Gets the a and b of a function with points ( 1, 2 ) and ( 2, 2 ), a = 2, b = 1
    - `a, b = mlib.line.func.get( 1, 2, 2, 2 )`

#####mlib.line.func.draw
- Draws the exponential function using game-style coordinates, (( 0, 0 ) being the top left, increasing as you go down/right). 
- Synopsis:
  - `mlib.line.func.draw( a, b )`
- Arguments:
  - `a`: Number. The a of the function.
  - `b`: Number. The b of the function.
  - Keep in mind, `y = a * ( b ^ x )`
- Returns: 
  - Nothing.
- Example:
  - Draws an exponential function with an a of 1 and a b of 2.
    - `mlib.line.func.draw( 1, 2 )`
    - Starts in the top left of the screen and goes sharply downward.

#####mlib.line.func.drawStandard
- Draws the exponential function using standard coordinates, (( 0, 0 ) being the bottom left, increasing as you go up/right). 
- Synopsis:
  - `mlib.line.func.draw( a, b )`
- Arguments:
  - `a`: Number. The a of the function.
  - `b`: Number. The b of the function.
  - Keep in mind, `y = a * ( b ^ x )`
- Returns: 
  - Nothing.
- Example:
  - Draws an exponential function with an a of 1 and a b of 2.
    - `mlib.line.func.draw( 1, 2 )`
    - Starts in the bottom left of the screen and goes sharply upward.

####mlib.line.segment
Handles the line segment aspect of lines.
#####mlib.line.segment.checkPoint
- Checks whether or not a point is on a line segment.
- Synopsis:
  - `mlib.line.segment.checkPoint( x1, y1, x2, y2, px, py )`
- Arguments:
  - `x1`: Number. The first x-coordinate of the line segment. 
  - `y1`: Number. The first y-coordinate of the line segment.
  - `x2`: Number. The second x-coordinate of the line segment.
  - `y2`: Number. The second y-coordinate of the line segment.
  - `px`: Number. The x-coordinate of the point that you are testing
  - `py`: Number. The y-coordinate of the point that you are testing. 
- Returns:
  - `true` if the point is on the line segment.
  - `false` if the point is not on the line segment.
- Example:
  - Returns `true`, because the point ( 1, 1 ) is on the line segment ( 2, 2 ), ( 0, 0 ).
    - `on = mlib.line.segment.checkPoint( 2, 2, 0, 0, 1, 1 )`

#####mlib.line.segment.intersect
- Checks if two line segments intersect.
- Synopsis:
  - `mlib.line.segment.intersect( x1, y1, x2, y2, x3, y3, x4, y4 )`
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
    - `x1, y1, x2, y2 = mlib.line.segment.intersect( 1, 1, 5, 3, 2, 3, 4, 1 )`
      - Output: 3, 2, nil, nil
  - Checks if the line segments ( 3, 7 ), ( 6, 8 ) and ( 1, 6 ), ( 5, 4 ) intersect, which don't.
    - `x1, y1, x2, y2 = mlib.line.segment.intersect( 3, 7, 6, 8, 1, 6, 5, 4 )`
      - Output: false, nil, nil, nil
  - Checks if the line segments ( 0, 0 ), ( 2, 2 ) and ( 1, 1 ), ( 3, 3 ) intersect, which they do, from ( 1, 1 ) to ( 2, 2 )
    - `x1, y1, x2, y2 = mlib.line.segment.intersect( 0, 0, 2, 2, 1, 1, 3, 3 )`
      - Output: 1, 1, 2, 2

####mlib.polygon
Handles polygon-related functions.
#####mlib.polygon.triangleHeight
- Gives the height of a triangle.
- Synopsis:
  - `mlib.polygon.triangleHeight( base, x1, y1, x2, y2, x3, y3 )`
  - `mlib.polygon.triangleHeight( base, area )`
- Arguments:
  - `mlib.polygon.triangleHeight( base, x1, y1, x2, y2, x3, y3 )`
    - `base`: Number. Length of the base of the triangle.
    - `x1`: Number. First x-coordinate of the triangle.
    - `y1`: Number. First y-coordinate of the triangle.
    - `x2`: Number. Second x-coordinate of the triangle.
    - `y2`: Number. Second y-coordinate of the triangle.
    - `x3`: Number. Third x-coordinate of the triangle.
    - `y3`: Number. Third y-coordinate of the triangle.
  - `mlib.polygon.triangleHeight( base, area )`
    - `base`: Number. Length of the base of the triangle.
    - `area`: Number. Area of the triangle.
- Returns:
  - The height of the triangle.
- Example:
  - Gives the height of a triangle at ( 0, 0 ), ( 0, 4 ) and  ( 3, 0 ) and a base of 3. The height is 4.
    - `height = mlib.polygon.triangleHeight( 3, 0, 0, 0, 4, 3, 0 )`
  - Gives the height of a triangle with a base of 3 and a and area of 6. The height is 4.
    - `height = mlib.polygon.triangleHeight( 3, 6 )

#####mlib.polygon.area
- Gives the area of any <a href="http://en.wikipedia.org/wiki/Simple_polygon">simple polygon</a>.
- Synopsis:
  - `mlib.polygon.area( verticies )`
- Arguments:
  - `verticies`: 
    - Table. Contains the x and y of the verticies.
    - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns:
  - The area of the polygon.
- Example: 
  - Gives the area of the polygon with points at ( 0, 0 ), ( 0, 4 ), ( 3, 0 ), which has an area of 6.
    - `verticies = { 0, 0, 0, 4, 3, 0 }`
    - `area = mlib.polygon.area( verticies )`
  - Gives the area of the polygon with points at ( 0, 0 ), ( 0, 4 ), ( 3, 0 ), ( 3, 4 ), which has an area of 12.
    - `area = mlib.polygon.area( 0, 0, 0, 4, 3, 0, 3, 4 )`

#####mlib.polygon.centroid
- Gives the <a href="http://en.wikipedia.org/wiki/Centroid">centroid</a> of any <a href="http://en.wikipedia.org/wiki/Simple_polygon">simple polygon</a>.
- Synopsis:
  - `mlib.polygon.centroid( verticies )`
- Arguments:
  - `verticies`: 
    - Table. Contains the x and y of the verticies.
    - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns:
  - The centroid x and y of the polygon.
- Example:
  - Gives the centroid of the polygon with points at ( 0, 0 ), ( 0, 6 ), ( 3, 0 ), which is at ( 1, 2 )
    - `verticies = { 0, 0, 0, 6, 3, 0 }`
    - `cx, cx = mlib.polygon.centroid( verticies )`
  - Gives centroid of a polygon with points at ( 0, 0 ), ( 0, 4 ), ( 4, 4 ), ( 4, 0 )
    - `cx, cy = mlib.polygon.centroid( 0, 0, 0, 4, 4, 4, 4, 0 )`

#####mlib.polygon.checkPoint
- Checks whether or not a point is inside a <a href="http://en.wikipedia.org/wiki/Simple_polygon">simple polygon</a>.
- Synopsis:
  - `mlib.polygon.checkPoint( x, y, verticies )`
- Arguments:
  - `x`: Number. The x-coordinate that is being checked.
  - `y`: Number. The y-coordinate that is being checked.
  - `verticies`: 
    - Table. Contains the x and y of the verticies.
    - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns:
  - `true` if the point is inside the polygon.
  - `false` if the point is outside the polygon.
- Example:
  - Checks if the point ( 2, 2 ) is inside the polygon ( 0, 0 ), ( 0, 4 ), ( 4, 4 ), ( 4, 0 ). It is.
    - `in = mlib.polygon.checkPoint( 2, 2, 0, 0, 0, 4, 4, 4, 4, 0 )`
  - Checks if the point ( 7, 8 ) is inside the polygon ( 0, 0 ), ( 0, 4 ), ( 4, 4 ), ( 4, 0 ). It is not.
    - `in = mlib.polygon.checkPoint( 7, 8, 0, 0, 0, 4, 4, 4, 4, 0 )`

#####mlib.polygon.lineIntersects
- Checks whether or not a line intersects a polygon. 
- Synopsis:
  - `mlib.polygon.lineIntersects( x1, y1, x2, y2, ... )`
- Arguments:
  - `x1`: Number. An x-coordinate on the line. 
  - `y1`: Number. A y-coordinate on the line. 
  - `x2`: Number. Another x-coordinate on the line.
  - `y2`: Number. Another y-coordinate on the line. 
  - `...`: Table. The points of the polygon.
- Returns:
  - `true` if the line intersects the polygon. 
  - `false` if the line does not intersect the polygon.
- Example:
  - Check if a line with the points ( 3, 7 ) and ( 5, 4 ) intersects with the polygon. It does. 
    - `mlib.polygon.lineIntersects( 3, 7, 5, 4, 3, 5, 4, 4, 5, 5, 6, 4, 6, 6, 3, 6 )`
  - Checks if a line with the points ( 2, 5 ) and ( 3, 7 ) intersects with the polygon. It does not. 
    - `mlib.polygon.lineIntersects( 2, 5, 3, 7, 3, 5, 4, 4, 5, 5, 6, 4, 6, 6, 3, 6 )`

#####mlib.polygon.polygonIntersects
- Checks whether or not two polygons intersect.
- Synopsis:
  - `mlib.polygon.polygonIntersects( polygon1, polygon2 )`
- Arguments:
  - `polygon1`: Table. A table containing all of the points of `polygon1` in the form of `( x1, y1, x2, y2, ... )`.
  - `polygon2`: Table. A table containing all of the points of `polygon2` in the form of `( x1, y1, x2, y2, ... )`.
- Returns:
  - `true` if the polygons intersect.
  - `false` if the polygons don't intersect. 
- Example:
  - Checks if polygons with points ( 2, 6, ), ( 3, 8 ), ( 4, 6 ) and ( 4, 7 ), ( 3, 9 ), )( 5, 9 ) intersect. They don't.
    - `mlib.polygon.polygonIntersects( { 2, 6, 3, 8, 4, 6 }, { 4, 7, 3, 9, 5, 9 } )`
  - Checks if polygons with points ( 2, 6 ), ( 3, 8 ), ( 4, 6 ) and ( 3, 7 ), ( 2, 9 ), ( 4, 9 ) intersect. They do.
    - `mlib.polygon.polygonIntersects( { 2, 6, 3, 8, 4, 6 }, { 3, 7, 2, 9, 4, 9 } )`

#####mlib.polygon.circleIntersects
- Checks whether or not a circle intersects a polygon. 
- Synopsis:
  - `mlib.polygon.circleIntersects( cx, cy, r, points )`
  - `mlib.polygon.circleIntersects( cx, cy, r, ... )`
- Arguments:
  - `mlib.polygon.circleIntersects( cx, cy, r, points )`
    - `cx`: Number. The x location of the circle center. 
    - `cy`: Number. The y location of the circle center. 
    - `r`: Number. The radius of the circle.
    - `points`: Table. A table containing all of the points of the polygon in the form of `( x1, y1, x2, y2, ... )`
  - `mlib.polygon.circleIntersects( cx, cy, r, ... )`
    - `cx`: Number. The x location of the circle center. 
    - `cy`: Number. The y location of the circle center. 
    - `r`: Number. The radius of the circle.
    - `...`: Numbers. All of the points of the polygon in the form of `( x1, y1, x2, y2, ... )`
- Returns:
  - `true` if the circle and polygon intersects. 
  - `false` if the circle and polygon don't intersect.
- Example: 
  - Checks if a circle with a radius of 2 located on ( 3, 5 ) intersects with a polygon with points on ( 2, 6 ), ( 4, 6 ), ( 3, 8 ). It does. 
    - `mlib.polygon.circleIntersects( 3, 5, 2, 2, 6, 4, 6, 3, 8 )`
  - Checks if a circle with a radius of 2 located on ( 3, 3 ) intersects with a polygon with points on ( 2, 6 ), ( 4, 6 ), ( 3, 8 ). It does not. 
  	- `mlib.polygon.circleIntersects( 3, 3, 2, 2, 6, 4, 6, 3, 8 )`

####mlib.circle
Handles functions dealing with circles.
#####mlib.circle.area
- Gives the area of a circle.
- Synopsis: 
  - `mlib.circle.area( radius )`
- Arguments:
  - `radius`: Number. the radius of the circle.
- Returns:
  - The area of the circle.
- Example:
  - Get the area of a circle with a radius of 1. The area is 3.14159265359...
    - `area = mlib.circle.area( 1 )`

#####mlib.circle.checkPoint
- Checks whether or not a point is within a circle.
- Synopsis:
  - `mlib.circle.checkPoint( cx, cy, r, x, y )`
- Arguments:
  - `cx`: Number. The circle's x (where the center of the circle is).
  - `cy`: Number. The circle's y (where the center of the circle is).
  - `r`: Number. The radius of the circle.
  - `x`: Number. The x of the point you are testing.
  - `y`: Number. The y of the point you are testing.
- Returns:
  - `true` if the point is along the edge of the circle.
  - `false` if the point is not along the edge of the circle.
- Example:
  - Checks whether the circle has the point ( 1, 4 ) with its center at ( 3, 4 ) and a radius of ( 2 ), which it is. 
    - `mlib.circle.checkPoint( 3, 4, 2, 1, 4 )`

#####mlib.circle.inCircle
- Checks whether or not a point is inside a circle. 
- Synopsis:
  - `mlib.circle.inCircle( cx, cy, r, x, y )`
- Arguments:
  - `cx`: Number. The circle's x (where the center of the circle is).
  - `cy`: Number. The circle's y (where the center of the circle is).
  - `r`: Number. The radius of the circle.
  - `x`: Number. The x of the point you are testing.
  - `y`: Number. The y of the point you are testing.
- Returns:
  - `true` if the point is inside of the circle.
  - `false` if the point is not inside of the circle.
- Example:
  - Checks whether the circle has the point ( 1, 4 ) with its center at ( 3, 4 ) and a radius of ( 2 ), which it is. 
    - `mlib.circle.inCircle( 3, 4, 2, 1, 4 )`
  
#####mlib.circle.circumference
- Gives the circumference of a circle.
- Synopsis:
  - `mlib.circle.circumference( radius )`
- Arguments:
  - `radius`: Number. The radius of the circle.
- Returns:
  - The circumference of the circle.
- Example:
  - Gives the circumference of the circle with a radius of 1, which is 6.28318530718...
    - `circumference = mlib.circle.circumference( 1 )`
  
#####mlib.circle.secant
- Checks whether the line is a <a href="http://en.wikipedia.org/wiki/Secant_line">secant</a>, a <a href="http://en.wikipedia.org/wiki/Tangent">tangent</a> or neither.
- Synopsis:
  - `mlib.circle.secant( cx, cy, r, x1, x2, y1, y2 )`
  - `mlib.circle.secant( cx, cy, r, slope, yIntercept )`
- Arguments:
  - `mlib.circle.secant( cx, cy, r, x1, x2, y1, y2 )`
    - `cx`: Number. The x-coordinate of the center of the circle.
    - `cy`: Number. The y-coordinate of the center of the circle.
    - `r`: Number. The radius of the circle.
    - `x1`: Number. The first x-coordinate of the line.
    - `y1`: Number. The first y-coordinate of the line.
    - `x2`: Number. The second x-coordinate of the line.
    - `y2`: Number. The second y-coordinate of the line.
  - `mlib.circle.secant( cx, cy, r, slope, yIntercept )`
    - `cx`: Number. The x-coordinate of the center of the circle.
    - `cy`: Number. The y-coordinate of the center of the circle.
    - `r`: Number. The radius of the circle.
    - `slope`: Number. The slope of the line.
    - `yIntercept`: Number. The y-intercept of the line.
- Returns: 
  - `type`:
    - String:
      - `'secant'` if the line is a <a href="http://en.wikipedia.org/wiki/Secant_line">secant</a> to the circle.
      - `'tangent'` if the line is tangental<a href="http://en.wikipedia.org/wiki/Tangent">tangent</a>
    - Boolean:
      - `false` if the line is neither a secant not a tangent.
  - `x1`: Number. The first x-coordinate of where the intersection occurs.
  - `y1`: Number. The first y-coordinate of where the intersection occurs.
  - `x2`: Number. The second x-coordinate of where the intersection occurs.
  - `y2`: Number. The second y-coordinate of where the intersection occurs.
- Example:
  - A line with points on ( 0, 9 ), ( 6, 9 ), and a circle center on ( 4, 9 ) and a radius of 1. 
    - `type, x1, y1, x2, y2 = mlib.circle.secant( 4, 9, 1, 0, 9, 6, 9 )`
      - Output: `'secant', 3, 9, 5, 9.`
  - A line with a slope of 0 and a y-intercept of 9 and a a circle center on ( 4, 9 ) and a radius of 1.
    - `type, x1, y1, x2, y2 = mlib.circle.secant( 4, 9, 1, 0, 9 )`
      - Output: `'secant', 3, 9, 5, 9. `

#####mlib.circle.segmentSecant
- Checks whether the line is a <a href="http://en.wikipedia.org/wiki/Secant_line">secant</a>, a <a href="http://en.wikipedia.org/wiki/Tangent">tangent</a> or neither.
- Synopsis:
  - `mlib.circle.segmentSecant( cx, cy, r, x1, y1, x2, y2 )`
- Arguments:
  - `cx`: Number. The x-coordinate of the center of the circle.
  - `cy`: Number. The y-coordinate of the center of the circle.
  - `r`: Number. The radius of the circle.
  - `x1`: Number. The first x-coordinate of the line.
  - `y1`: Number. The first y-coordinate of the line.
  - `x2`: Number. The second x-coordinate of the line.
  - `y2`: Number. The second y-coordinate of the line.
- Returns: 
  - `type`:
    - String:
      - `'secant'` if the line is a <a href="http://en.wikipedia.org/wiki/Secant_line">secant</a> to the circle.
      - `'tangent'` if the line is tangental<a href="http://en.wikipedia.org/wiki/Tangent">tangent</a>
    - Boolean:
      - `false` if the line is neither a secant not a tangent.
  - `x1`: Number. The first x-coordinate of where the intersection occurs.
  - `y1`: Number. The first y-coordinate of where the intersection occurs.
  - `x2`: Number. The second x-coordinate of where the intersection occurs.
  - `y2`: Number. The second y-coordinate of where the intersection occurs.
- Example:
  - A line segment with points on ( 0, 9 ), ( 6, 9 ), and a circle center on ( 4, 9 ) and a radius of 1. 
    - `type, x1, y1, x2, y2 = mlib.circle.secant( 4, 9, 1, 0, 9, 6, 9 )`
      - Output: `'secant', 3, 9, 5, 9.`

#####mlib.circle.circlesIntersect
- Returns the point that intersects the circles.
- Synopsis:
  - `mlib.circle.circlesIntersect( cx1, cy1, r1, cx2, cy2, r2 )`
- Arguments: 
  - `cx1`: Number. The x-coordinate of the first center circle.
  - `cy1`: Number. The y-coordinate of the first center circle.
  - `r1`: Number. The radius of the first circle.
  - `cx2`: Number. The x-coordinate of the second center circle.
  - `cy2`: Number. The y-coordinate of the second center circle.
  - `r2`: Number. The radius of the first circle.
- Returns:
  - The points where the circles intersect.
  - `false` if they don't intersect.
- Example:
  - Checks whether circle 1, at ( 1, 1 ) and a radius of 1, and circle 2 at ( 2, 2 ) and a radius of 1 intersect. It does, at ( 2, 1 ), ( 1, 2 ). 
    - `mlib.circle.circlesIntersect( 1, 1, 1, 2, 2, 1 )`

####mlib.stats
Handles functions dealing with statistics.
#####mlib.stats.mean
- Gives the <a href="http://en.wikipedia.org/wiki/Arithmetic_mean">arithmetic mean</a> of the data set.
- Synopsis: 
  - `mlib.stats.mean( data )`
- Arguments:
  - `data`: 
    - Table. Contains the numbers data.
    - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns:
  - The average of the numbers.
- Example:
  - Gets the average of a data set containing the numbers 1, 2, 3, 4, and 5, which is 3.
    - `mean = mlib.stats.mean( 1, 2, 3, 4, 5 )`

#####mlib.stats.median
- Gets the <a href="http://en.wikipedia.org/wiki/Median">median</a> of the data set. 
- Synopsis:
  - `mlib.stats.median( data )`
- Arguments:
  - Table. Contains the numbers data.
  - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns: 
  - The median of the numbers.
- Example:
  - Gets the median of a data set containing the numbers, 1, 2, 3, 4, and 5, which is 3.
    - `median = .stats.median( 1, 2, 3, 4, 5 )`

#####mlib.stats.mode
- Gets the <a href="http://en.wikipedia.org/wiki/Mode_(statistics)">mode</a> of the data set. 
- Synopsis: 
  - `mlib.stats.mode( data )`
- Arguments:
  - Table. Contains the numbers data.
  - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns: 
  - The mode of the numbers and how many times it appears.
  - `false` if bimodial.
  - `false` if no mode. 
- Example:
  - Gets the median of a data set containing the numbers, 1, 5, 6, 22, 2, 2, 1, 2, which is 2, which appears 3 times.
    - `mode, times = mlib.stats.mode( 1, 5, 6, 22, 2, 2, 1, 2 )`

#####mlib.stats.range
- Gets the <a href="http://en.wikipedia.org/wiki/Range_(statistics)">range</a> of the data set. 
- Synopsis:
  - `mlib.stats.range( data )`
- Arguments:
  - Table. Contains the numbers data.
  - Numbers. Can just be the numbers, or the `unpack`ed table containing the numbers.
- Returns: 
  - The range of the numbers.
- Example:
  - Gets the range of a data set containing the numbers, 1, 2, 3, and 4, which is 3.
    - `range = mlib.stats.range( 1, 2, 3, 4 )`

####mlib.math
Handles functions that have to do with math in general.
#####mlib.math.root
- Gets the nth root of a number.
- Synopsis:
  - `mlib.math.root( number, root )`
- Arguments:
  - `number`: Number. The number you are getting the nth root of.
  - `root`: Number. The number that is n for the nth root.
- Returns:
  - The number.
- Example:
  - Gets the square (2) root of 4, which is 2.
    - `root = mlib.math.root( 4, 2 ) `

#####mlib.math.prime
- Checks whether a number or set of numbers is <a href="http://en.wikipedia.org/wiki/Prime">prime</a> or not.
- Synopsis: 
  - `mlib.math.prime( number )`
- Arguments:
  - `number`: Number. The number that is being checked for prime-ness.
- Returns:
  - `true` if the number is prime.
  - `false` if the number is not prime.
- Example:
  - Checks if the number 3 is prime or not. 3 is prime.
    - `prime = mlib.math.prime( 3 )`

#####mlib.math.round
- Rounds a number up or down, depending on which it's closer to.
- Synopsis:
  - `mlib.math.round( number )`
- Arguments:
  - `number`: Number. The number that you want to round.
- Returns:
  - The number rounded up or down. 
- Example:
  - Rounds .999 up to 1
    - `new = mlib.math.round( .999 )`

#####mlib.math.log
- Gets the <a href="http://en.wikipedia.org/wiki/Logarithm">log</a> of a number.
- Synopsis:
  - `mlib.math.log( number, base )`
- Arguments:
  - `number`: Number. The number that is being logged.
  - `base`: Number. What the number is being logged by.
- Returns:
  - The `number` logged by the `base`.
- Example:
  - 1 logged by 2 is 0.
    - `new = mlib.math.log( 1, 2 )`

#####mlib.math.summation
- Gives the <a href="http://en.wikipedia.org/wiki/Summation">summation</a>.
- Synopsis:
  - `mlib.math.summation( start, stop, func )`
- Arguments:
  - `start`: Number. Where should the summation begin?
  - `stop`: Number. Where shuld the summation end?
  - `func`: Function. A function that gives the new value to add to the previous. Can have two arguments:
    - `i`: The first argument. Represents the current number
    - `t`: The second argument. Has all the previous values in it. 
      - __IMPORTANT__: If you use `t`, your function must have an `if` statement, regarding what to do if there is not a value for that number yet. 
- Returns:
  - The sum of all of the values.
- Example:
  - Gives the sum of numbers that start at 1 and end at 10, multuplying each time by 2, which is 110. 
    - `sum = mlib.math.summation( 1, 10, function( i ) return ( i * 2 ) end )`
  - Gives the sum of numbers that start at 1 and end at 5, adding the previous value each time, which is 35.
    - `sum = mlib.math.summation( 1, 5, function( i, t ) if t[i-1] then return i + t[i-1] else return 1 end end )`

#####mlib.math.percentOfChange
- Gives the <a href="http://en.wikipedia.org/wiki/Percentage_change#Percentage_change">percent of change</a> from two numbers.
- Synopsis:
  - `mlib.math.percentOfChange( old, new )`
- Arguments:
  - `old`: Number. The previous number.
  - `new`: Number. The new number.
- Returns:
  - The percentage difference from `old` to `new`.
- Example:
  - Gets the percent of change going from 2 to 4, or 1 (or 100%).
    - `mlib.math.percentOfChange( 2, 4 )`

#####mlib.math.percent
- Gets the percentage of a number. 
- Synopsis:
  - `mlib.math.percent( percent, num )`
- Arguments:
  - `percent`: Number. The percentage you are getting of `num`.
  - `num`: Number. The number that is getting changed. 
- Returns:
  - `percentage`% of `num`.
- Example:
  - 100% of 2 is 4.
    - `mlib.math.percent( 1, 2 )`

#####mlib.math.quadraticFactor
- Gets the `x` of the <a href="http://en.wikipedia.org/wiki/Quadratic_equation">quadratic equation</a>.
- Synopsis:
  - `mlib.math.quadraticFactor( a, b, c )`
- Arguments:
  - `a`: Number. The number that has `x^2` next to it.
  - `b`: Number. The number that has `x` next to it.
  - `c`: Number. The number that has no variable next to it.
- Returns:
  - The value of x.
- Example:
  - Gets the x of the quadratic equation `1 * x ^ 2 + 3 * x - 4`, which is -4, 1.
    - `x1, x2 = mlib.math.quadraticFactor( 1, 3, -4 )`

#####mlib.math.getAngle
- Gets the angle between two points.
- Synopsis:
  - `mlib.math.getAngle( x1, y1, x2, y2, dir )`
  - `mlib.math.getAngle( x1, y1, x2, y2, x3, y3 )`
- Arguments:
  - `mlib.math.getAngle( x1, y1, x2, y2, dir )`
    - `x1`: Number. The x-coordinate of the primary point.
    - `y1`: Number. The y-coordinate of the primary point.
    - `x2`: Number. The x-coordinate of the secondary point.
    - `y2`: Number. The y-coordinate of the secondary point.
    - `dir`: String. Can be `up`, `down`, `left` or `right`. Used for the orientation of the picture. If not applicable, leave blank or make it `up`.
  - `mlib.math.getAngle( x1, y1, x2, y2, x3, y3 )`
    - `x1`: Number. The x-coordinate of the first point.
    - `y1`: Number. The y-coordinate of the first point.
    - `x2`: Number. The x-coordinate of the second point.
    - `y2`: Number. The y-coordinate of the second point.
    - `x3`: Number. The x-coordinate of the third point.
    - `y3`: Number. The y-coordinate of the third point. 
- Returns:
  - The angle from point 1 to point 2 (and possibly point 3) in radians.
- Example:
  - `angle = mlib.math.getAngle( 0, 0, 3, 3, 'up' ), 2.35619449 )`

###mlib.shape
Handles shape collision/intersection. 
#####mlib.shape.new
- Registers a new shape/line.
- Synopsis:
  - `mlib.shape.new( x, y, r )`
  - `mlib.shape.new( x1, y1, x2, y2 )`
  - `mlib.shape.new( ... )`
- Arguments: 
  - `mlib.shape.new( x, y, r )`
    - `x`: Number. The x-coordinant of the circle. 
    - `y`: Number. The y-coordinant of the circle. 
    - `r`: Number. The radius of the circle. 
  - `mlib.shape.new( x1, y1, x2, y2 )`
    - `x1`: Number. The first x-coordinant of the line segment. 
    - `y1`: Number. The first y-coordinant of the line segment. 
    - `x2`: Number. The second x-coordinant of the line segment. 
    - `y2`: Number. The second y-coordinant of the line segment. 
  - `mlib.shape.new( ... )`
    - `...`: Table or Numbers. All of the points in the polygon. 
- Returns:
  - A table containing information regarding the shape registered. 
    - All:
      - `table.type`: String. The type of the shape (`'circle'`, `'line'`, or `'polygon'`).
      - `table.collided`: Boolean. `true` if the shape is collided with anything, `false` otherwise. 
        - __Note__: You must call <a href="http://github.com/davisdude/mlib#mlibshapecheckcollisions-1">mlib.shape.checkCollisions</a> in <a href="http://www.love2d.org/wiki/love.update">love.update</a>.
      - `table.index`: Number. The reference of the shape. 
    - Circle:
      - `x`: Number. The x-coordinant of the circle.
      - `y`: Number. The y-coordinant of the circle. 
      - `radius`: Number. The radius of the circle. 
      - `area`: Number. The area of the circle. 
    - Line segment:
      - `x1`: Number. The first x-coordinant of the line segment. 
      - `y1`: Number. The first y-coordinant of the line segment. 
      - `x2`: Number. The second x-coordinant of the line segment. 
      - `y2`: Number. The second y-coordinant of the line segment. 
      - `slope`: Number. The slope of the line.
      - `intercept`: Number or boolean. The y-intercept of the line. Boolean if the line is vertical.
    - Polygon:
      - `area`: Number. The area of the polygon. 
      - `points`: Table. All of the points of the polygon. 
- Example:
  - See <a href="https://github.com/davisdude/mlib#mlibshape-example">the example</a>.

#####mlib.shape:checkCollisions
- Checks collisions between shapes. 
- Synopsis:
  - `mlib.shape.checkCollisions()`
  - `mlib.shape.checkCollisions( shapes )`
  - `shape:checkCollisions()`
  - `shape:checkCollisions( shapes )`
- Arguments: 
  - `mlib.shape.checkCollisions()`
  - `mlib.shape.checkCollisions( shapes )`
    - `shapes`: Table. A table containing all of the shapes you want to check for collisions (the shapes excluded will not be checked for collisions).
      - __Note__: The shapes must be enclosed in a table, like follows: `{ shape1, shape2, ... }`.
  - `shape:checkCollisions()`
    - `shape`: Table. The table returned from <a href="http://github.com/davisdude/mlib#mlibshapenew-1">mlib.shape.new</a>.
  - `shape:checkCollisions( shapes )`
    - `shape`: Table. The table returned from <a href="http://github.com/davisdude/mlib#mlibshapenew-1">mlib.shape.new</a>.
    - `shapes`: Tables. All the shapes being checked against `shape` (this checks if any of the `shapes` collide with `shape`).
      - __Note__: Unlike other ones, the shapes in this one must be done seperately, like follows: `shape1, shape2, ...`.
- See <a href="https://github.com/davisdude/mlib#mlibshape-example">the example</a>.

#####mlib.shape:remove
- Removes a table from testing. 
- Synopsis:
  - `mlib.shape.remove()`
  - `mlib.shape.remove( shapes )`
  - `shape:remove()`
  - `shape:remove( shapes )`
- Arguments:
  - `mlib.shape.remove()`
  - `mlib.shape.remove( shapes )`
    - `shapes`: Table. A table containing all of the shapes you want to remove. 
  - `shape:remove()`
	- `shape`: Table. The table returned from <a href="http://github.com/davisdude/mlib#mlibshapenew-1">mlib.shape.new</a>.
  - `shape:remove( shapes )`
	- `shape`: Table. The table returned from <a href="http://github.com/davisdude/mlib#mlibshapenew-1">mlib.shape.new</a>.
	- `shapes`: Table. A table containing all of the shapes you want to remove. 

##mlib.shape Example
Here is an example of how to use mlib.shape.
```lua
-- Require libraries
mlib = require 'path/mlib' 
-- The first "mlib" can be whatever you want it to be.
-- "path" is how you get to the file from the main directory of the application. 

function love.load()
  circle = mlib.shape.new( 300, 300, 10 )
	rectangle = mlib.shape.new( 400, 300, 400, 200, 600, 200, 600, 300 )
	line = mlib.shape.new( 400, 200, 300, 400 )
end

function love.draw()
  love.graphics.circle( 'fill', circle.x, circle.y, circle.radius )
	love.graphics.polygon( 'fill', unpack( rectangle.points ) )
	love.graphics.line( line.x1, line.y1, line.x2, line.y2 )
end

function love.update( dt )
  mlib.shape.checkCollisions( dt )
    -- This checks all collisions, between rectangle, circle and line. 
  print( rectangle.collided, line.collided, circle.collided ) --> true, true, false
  
  mlib.shape.checkCollisions( dt, { rectangle, circle } ) 
    -- This checks collisions between rectangle and circle only.
  print( rectangle.collided, line.collided, circle.collided ) --> false, false, false
  
  mlib.shape.checkCollisions( dt, { rectangle, line } ) 
    -- This checks collisions between rectangle and line only.
  print( rectangle.collided, line.collided, circle.collided ) --> true, true, false
  
  rectangle:checkCollisions( dt )
    -- This checks all collisions of rectangle. 
  print( rectangle.collided, line.collided, circle.collided ) --> true, true, false
  
  rectangle:checkCollisions( dt, circle )
    -- This checks collisions between circle and rectangle only. 
  print( rectangle.collided, line.collided, circle.collided ) --> false, false, false
  
  rectangle:checkCollisions( dt, line )
    -- This checks collisions between line and rectangle only. 
  print( rectangle.collided, line.collided, circle.collided ) --> true, true, false
end
````
