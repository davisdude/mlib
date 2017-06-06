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
	- [segment.getDistance2](#segmentgetdistance2)
	- [segment.getDistance](#segmentgetdistance)
	- [segment.getMidpoint](#segmentgetmidpoint)
	- [segment.checkPoint](#segmentcheckpoint)
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

### segment.getDistance2
### segment.getDistance
### segment.getMidpoint
### segment.checkPoint
### segment.getLineIntersection
### segment.getSegmentIntersection
