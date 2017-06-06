# MLib

A math and shape intersection library for Lua.

## Table of Contents:

- [Usage](#usage)
- [Functions](#functions)

## Usage

## Functions

- [mlib.line](#line)
	- [line.areLinesParallel](#linearelinesparallel)
	- [line.checkPoint](#linecheckpoint)
	- [line.getClosestPoint](#linegetclosestpoint)
	- [line.getLineIntersection](#linegetlineintersection)
	- [line.getSlope](#linegetslope)
	- [line.getPerpendicularSope](#linegetperpendicularslope)
	- [line.getYIntercept](#linegetyintercept)
	- [line.isVertical](#lineisvertical)
- [mlib.segment](#segment)
	- [segment.checkPoint](#segmentcheckpoint)
	- [segment.getDistance](#segmentgetdistance)
	- [segment.getDistance2](#segmentgetdistance2)
	- [segment.getMidpoint](#segmentgetmidpoint)
	- [segment.getLineIntersection](#segmentgetlineintersection)
	- [segment.getSegmentIntersection](#segmentgetsegmentintersection)

## Line

### line.areLinesParallel

Checks if lines two lines are parallel.

---

- Synopsis:
`parallel = mlib.line.areLinesParallel( line1, line2 )`

- Parameters:
	- `table line1`: A table in one of the following formats:
		- `{ m }`: Contains just the slope of the line.
			- `m`:
				- `number`: The slope of the line.
				- `boolean (false)`: The slope if the line is vertical.
		- `{ m, x, y }`: Contains the slope and a point on the line.
			- `m`:
				- `number`: The slope of the line.
				- `boolean (false)`: The slope if the line is vertical.
			- `number x`: The position on the x-axis of a point on the line.
			- `number y`: The position on the y-axis of a point on the line.
		- `{ x1, y1, x2, y2 }`:
			- `number x1`: The position on the x-axis of a point on the line.
			- `number y1`: The position on the y-axis of a point on the line.
			- `number x2`: The position on the x-axis of another point on the line.
			- `number y2`: The position on the y-axis of another point on the line.
	- `table line2`: A table in one of the above formats (see `line1`).

- Returns:
	- `boolean parallel`: Whether the lines are parallel (`true`) or not (`false`).

### line.checkPoint

Checks if a point is on a line.

---

- Synopsis:
`onLine = mlib.line.checkPoint( px, py, m, b )`

- Parameters:
	- `number px`: The position on the x-axis of a point to check.
	- `number py`: The position on the y-axis of a point to check.
	- `m`:
		- `number`: The slope of the line.
		- `boolean (false)`: The slope if the line is vertical.
	- `b`:
		- `number`: The y-intercept of the line.
		- `boolean (false)`: The y-itnercept if the line is vertical.

- Returns:
	- `boolean onLine`: Whether the point is on the line (`true`) or not (`false`).

---

- Synopsis:
`onLine = mlib.line.checkPoint( px, py, m, x, y )`

- Parameters:
	- `number px`: The position on the x-axis of a point to check.
	- `number py`: The position on the y-axis of a point to check.
	- `m`:
		- `number`: The slope of the line.
		- `boolean (false)`: The slope if the line is vertical.
	- `number x`: The position on the x-axis of a point on the line.
	- `number y`: The position on the y-axis of a point on the line.

- Returns:
	- `boolean onLine`: Whether the point is on the line (`true`) or not (`false`).

---

- Synopsis:
`onLine = mlib.line.checkPoint( px, py, x1, y1, x2, y2 )`

- Parameters:
	- `number px`: The position on the x-axis of a point to check.
	- `number py`: The position on the y-axis of a point to check.
	- `m`:
		- `number`: The slope of the line.
		- `boolean (false)`: The slope if the line is vertical.
	- `number x1`: The position on the x-axis of a point on the line.
	- `number y1`: The position on the y-axis of a point on the line.
	- `number x2`: The position on the x-axis of another point on the line.
	- `number y2`: The position on the y-axis of another point on the line.

- Returns:
	- `boolean onLine`: Whether the point is on the line (`true`) or not (`false`).

### line.getClosestPoint

Checks if a point is on a line.

---

- Synopsis:
`x, y = mlib.line.getClosestPoint( px, py, m, x, y )`

- Parameters:
	- `number px`: The position on the x-axis of a point to check.
	- `number py`: The position on the y-axis of a point to check.
	- `m`:
		- `number`: The slope of the line.
		- `boolean (false)`: The slope if the line is vertical.
	- `number x`: The position on the x-axis of a point on the line.
	- `number y`: The position on the y-axis of a point on the line.

- Returns:
	- `number x`: The position on the x-axis of the closest point on the line.
	- `number y`: The position on the y-axis of the closest point on the line.

---

- Synopsis:
`x, y = mlib.line.getClosestPoint( px, py, x1, y1, x2, y2 )`

- Parameters:
	- `number px`: The position on the x-axis of a point to check.
	- `number py`: The position on the y-axis of a point to check.
	- `m`:
		- `number`: The slope of the line.
		- `boolean (false)`: The slope if the line is vertical.
	- `number x1`: The position on the x-axis of a point on the line.
	- `number y1`: The position on the y-axis of a point on the line.
	- `number x2`: The position on the x-axis of another point on the line.
	- `number y2`: The position on the y-axis of another point on the line.

- Returns:
	- `number x`: The position on the x-axis of the closest point on the line.
	- `number y`: The position on the y-axis of the closest point on the line.

### line.getLineIntersection

Checks if lines two lines are parallel.

---

- Synopsis:
`x, y = mlib.line.areLinesParallel( line1, line2 )`

- Parameters:
	- `table line1`: A table in one of the following formats:
		- `{ m, x, y }`: Contains the slope and a point on the line.
			- `m`:
				- `number`: The slope of the line.
				- `boolean (false)`: The slope if the line is vertical.
			- `number x`: The position on the x-axis of a point on the line.
			- `number y`: The position on the y-axis of a point on the line.
		- `{ x1, y1, x2, y2 }`:
			- `number x1`: The position on the x-axis of a point on the line.
			- `number y1`: The position on the y-axis of a point on the line.
			- `number x2`: The position on the x-axis of another point on the line.
			- `number y2`: The position on the y-axis of another point on the line.
	- `table line2`: A table in one of the above formats (see `line1`).

- Returns:
	- `x`:
		- `number`: The position on the x-axis of where the lines intersect.
		- `boolean (false):` The lines do not intersect anywhere
	- `number y`: The position on the y-axis of where the lines intersect.

### line.getPerpendicularSlope

Gets the perpendicular slope to a line.

---

- Synopsis:
`pm = mlib.line.getPerpendicularSlope( m )`

- Parameters:
	- `m`:
		- `number`: The slope of the line.
		- `boolean (false)`: The slope if the line is vertical.

- Returns:
	- `pm`:
		- `number`: The slope of the perpendicular line.
		- `boolean (false)`: The slope if the perpendicular line is vertical.

---

- Synopsis:
`pm = mlib.line.getPerpendicularSlope( x1, y1, x2, y2 )`

- Parameters:
	- `number x1`: The position on the x-axis of a point on the line.
	- `number y1`: The position on the y-axis of a point on the line.
	- `number x2`: The position on the x-axis of another point on the line.
	- `number y2`: The position on the y-axis of another point on the line.

- Returns:
	- `pm`:
		- `number`: The slope of the perpendicular line.
		- `boolean (false)`: The slope if the perpendicular line is vertical.

### line.getSlope

Gets the slope of a line.

---

- Synopsis:
`m = mlib.line.getSlope( x1, y1, x2, y2 )`

- Parameters:
	- `number x1`: The position on the x-axis of a point on the line.
	- `number y1`: The position on the y-axis of a point on the line.
	- `number x2`: The position on the x-axis of another point on the line.
	- `number y2`: The position on the y-axis of another point on the line.

- Returns
	- `m`:
		- `number`: The slope of the line.
		- `boolean (false)`: The slope if the line is vertical.

### line.getYIntercept

Gets the y-intercept of a line.

---

- Synopsis:
`b = mlib.line.getYIntercept( m, x, y )`

- Parameters:
	- `m`:
		- `number`: The slope of the line.
		- `boolean (false)`: The slope if the line is vertical.
	- `number x`: The position on the x-axis of a point on the line.
	- `number y`: The position on the y-axis of a point on the line.

- Returns:
	- `b`:
		- `number`: The y-intercept of the line.
		- `boolean (false)`: The y-intercept if the line is vertical.

---

- Synopsis:
`b = mlib.line.getYIntercept( x1, y1, x2, y2 )`

- Parameters:
	- `number x1`: The position on the x-axis of a point on the line.
	- `number y1`: The position on the y-axis of a point on the line.
	- `number x2`: The position on the x-axis of another point on the line.
	- `number y2`: The position on the y-axis of another point on the line.

- Returns:
	- `b`:
		- `number`: The y-intercept of the line.
		- `boolean (false)`: The y-intercept if the line is vertical.

### line.isVertical

Checks if the line is vertical

---

- Synopsis:
`vertical = mlib.line.isVertical( m, x, y )`

- Parameters:
	- `m`:
		- `number`: The slope of the line.
		- `boolean (false)`: The slope if the line is vertical.
	- `number x`: The position on the x-axis of a point on the line.
	- `number y`: The position on the y-axis of a point on the line.

- Returns:
	- `boolean vertical`: Whether the line is vertical (`true`) or not (`false`).

---

- Synopsis:
`vertical = mlib.line.isVertical( x1, y1, x2, y2 )`

- Parameters:
	- `number x1`: The position on the x-axis of a point on the line.
	- `number y1`: The position on the y-axis of a point on the line.
	- `number x2`: The position on the x-axis of another point on the line.
	- `number y2`: The position on the y-axis of another point on the line.

- Returns:
	- `boolean vertical`: Whether the line is vertical (`true`) or not (`false`).

## Segment

### segment.checkPoint

Checks if a point is on a line segment.

---

- Synopsis:
`onSegment = mlib.segment.checkPoint( px, py, x1, y1, x2, y2 )`

- Parameters:
	- `number px`: The position on the x-axis of the point to check.
	- `number py`: The position on the y-axis of the point to check.
	- `number x1`: The position on the x-axis of a point on the line.
	- `number y1`: The position on the y-axis of a point on the line.
	- `number x2`: The position on the x-axis of another point on the line.
	- `number y2`: The position on the y-axis of another point on the line.

- Returns
	- `boolean onPoint`: Whether the given point is on the line segment (`true`) or not (`false`).

### segment.getDistance

Gets the squared distance between two points.

---

- Synopsis:
`dist = mlib.segment.getDistance( x1, y1, x2, y2 )`

- Parameters:
	- `number x1`: The position on the x-axis of a point on the segment.
	- `number y1`: The position on the y-axis of a point on the segment.
	- `number x2`: The position on the x-axis of another point on the segment.
	- `number y2`: The position on the y-axis of another point on the segment.

- Returns:
	- `number dist`: The distance between the two points.

### segment.getDistance2

Gets the squared distance between two points.

---

- Synopsis:
`dist2 = mlib.segment.getDistance2( x1, y1, x2, y2 )`

- Parameters:
	- `number x1`: The position on the x-axis of a point on the segment.
	- `number y1`: The position on the y-axis of a point on the segment.
	- `number x2`: The position on the x-axis of another point on the segment.
	- `number y2`: The position on the y-axis of another point on the segment.

- Returns:
	- `number dist2`: The squared distance between the two points.

### segment.getMidpoint

Gets the midpoint of a segment.

---

- Synopsis:
`mx, my = mlib.segment.getDistance2( x1, y1, x2, y2 )`

- Parameters:
	- `number x1`: The position on the x-axis of a point on the segment.
	- `number y1`: The position on the y-axis of a point on the segment.
	- `number x2`: The position on the x-axis of another point on the segment.
	- `number y2`: The position on the y-axis of another point on the segment.

- Returns:
	- `number mx`: The position on the x-axis of the midpoint.
	- `number my`: The position on the y-axis of the midpoint.

### segment.getLineIntersection

Gets the intersection of a line and a segment.

---

- Synopsis:
`x, y = mlib.segment.getLineIntersection( segment, line )`

- Parameters:
	- `table segment`: The two points that define the line segment in the form `{ x1, y1, x2, y2 }`.
	- `table line`: A table in one of the following formats:
		- `{ m, x, y }`: Contains the slope and a point on the line.
			- `m`:
				- `number`: The slope of the line.
				- `boolean (false)`: The slope if the line is vertical.
			- `number x`: The position on the x-axis of a point on the line.
			- `number y`: The position on the y-axis of a point on the line.
		- `{ x1, y1, x2, y2 }`:
			- `number x1`: The position on the x-axis of a point on the line.
			- `number y1`: The position on the y-axis of a point on the line.
			- `number x2`: The position on the x-axis of another point on the line.
			- `number y2`: The position on the y-axis of another point on the line.

- Returns:
	- `x`:
		- `number`: The position on the x-axis of where the line and segment intersect.
		- `boolean (false):` The lines do not intersect anywhere
	- `number y`: The position on the y-axis of where the line and segment intersect.

### segment.getSegmentIntersection

Gets the intersection of two line segments.

---

- Synopsis:
`x, y = mlib.segment.getSegmentIntersection( segment1, segment2 )`

- Parameters:
	- `table segment1`: The two points that define the first line segment in the form `{ x1, y1, x2, y2 }`.
	- `table segment2`: The two points that define the second line segment in the form `{ x1, y1, x2, y2 }`.

- Returns:
	- `x`:
		- `number`: The position on the x-axis of where the two segments intersect.
		- `boolean (false):` The lines do not intersect anywhere
	- `number y`: The position on the y-axis of where the two segments intersect.
