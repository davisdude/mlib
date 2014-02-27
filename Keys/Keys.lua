local TapTime = .25

local KeyTapped = {
	escape = { Status = false, Time = 0, StartTime = 0 }, 
	f1 = { Status = false, Time = 0, StartTime = 0 }, 
	f2 = { Status = false, Time = 0, StartTime = 0 }, 
	f3 = { Status = false, Time = 0, StartTime = 0 }, 
	f4 = { Status = false, Time = 0, StartTime = 0 }, 
	f5 = { Status = false, Time = 0, StartTime = 0 }, 
	f6 = { Status = false, Time = 0, StartTime = 0 }, 
	f7 = { Status = false, Time = 0, StartTime = 0 }, 
	f8 = { Status = false, Time = 0, StartTime = 0 }, 
	f9 = { Status = false, Time = 0, StartTime = 0 }, 
	f10 = { Status = false, Time = 0, StartTime = 0 }, 
	f11 = { Status = false, Time = 0, StartTime = 0 }, 
	f12 = { Status = false, Time = 0, StartTime = 0 }, 
	insert = { Status = false, Time = 0, StartTime = 0 }, 
	printscreen = { Status = false, Time = 0, StartTime = 0 }, 
	delete = { Status = false, Time = 0, StartTime = 0 }, 
	tab = { Status = false, Time = 0, StartTime = 0 }, 
	q = { Status = false, Time = 0, StartTime = 0 }, 
	w = { Status = false, Time = 0, StartTime = 0 }, 
	e = { Status = false, Time = 0, StartTime = 0 }, 
	r = { Status = false, Time = 0, StartTime = 0 }, 
	t = { Status = false, Time = 0, StartTime = 0 }, 
	y = { Status = false, Time = 0, StartTime = 0 }, 
	u = { Status = false, Time = 0, StartTime = 0 }, 
	i = { Status = false, Time = 0, StartTime = 0 }, 
	o = { Status = false, Time = 0, StartTime = 0 }, 
	p = { Status = false, Time = 0, StartTime = 0 }, 
	pageup = { Status = false, Time = 0, StartTime = 0 }, 
	capslock = { Status = false, Time = 0, StartTime = 0 }, 
	a = { Status = false, Time = 0, StartTime = 0 }, 
	s = { Status = false, Time = 0, StartTime = 0 }, 
	d = { Status = false, Time = 0, StartTime = 0 }, 
	f = { Status = false, Time = 0, StartTime = 0 }, 
	g = { Status = false, Time = 0, StartTime = 0 }, 
	h = { Status = false, Time = 0, StartTime = 0 }, 
	j = { Status = false, Time = 0, StartTime = 0 }, 
	k = { Status = false, Time = 0, StartTime = 0 }, 
	l = { Status = false, Time = 0, StartTime = 0 }, 
	pagedown = { Status = false, Time = 0, StartTime = 0 }, 
	lshift = { Status = false, Time = 0, StartTime = 0 }, 
	z = { Status = false, Time = 0, StartTime = 0 }, 
	x = { Status = false, Time = 0, StartTime = 0 }, 
	c = { Status = false, Time = 0, StartTime = 0 }, 
	v = { Status = false, Time = 0, StartTime = 0 }, 
	b = { Status = false, Time = 0, StartTime = 0 }, 
	n = { Status = false, Time = 0, StartTime = 0 }, 
	m = { Status = false, Time = 0, StartTime = 0 }, 
	rshift = { Status = false, Time = 0, StartTime = 0 }, 
	up = { Status = false, Time = 0, StartTime = 0 }, 
	lctrl = { Status = false, Time = 0, StartTime = 0 }, 
	rgui = { Status = false, Time = 0, StartTime = 0 }, 
	lgui = { Status = false, Time = 0, StartTime = 0 }, 
	lalt = { Status = false, Time = 0, StartTime = 0 }, 
	ralt = { Status = false, Time = 0, StartTime = 0 }, 
	rctrl = { Status = false, Time = 0, StartTime = 0 }, 
	application = { Status = false, Time = 0, StartTime = 0 }, 
	left = { Status = false, Time = 0, StartTime = 0 }, 
	down = { Status = false, Time = 0, StartTime = 0 }, 
	right = { Status = false, Time = 0, StartTime = 0 }, 
	backspace = { Status = false, Time = 0, StartTime = 0 }, 
	home = { Status = false, Time = 0, StartTime = 0 }, 
}
KeyTapped['1'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['2'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['3'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['4'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['5'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['6'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['7'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['8'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['9'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['0'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['['] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped[']'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['\\'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped[';'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped["'"]	= { Status = false, Time = 0, StartTime = 0 }
KeyTapped['return'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped[','] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['.'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['/'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['end'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped[' '] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['`'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['-'] = { Status = false, Time = 0, StartTime = 0 }
KeyTapped['='] = { Status = false, Time = 0, StartTime = 0 }

local KeyPressed = {
	escape = { Status = false, Time = 0, StartTime = 0 }, 
	f1 = { Status = false, Time = 0, StartTime = 0 }, 
	f2 = { Status = false, Time = 0, StartTime = 0 }, 
	f3 = { Status = false, Time = 0, StartTime = 0 }, 
	f4 = { Status = false, Time = 0, StartTime = 0 }, 
	f5 = { Status = false, Time = 0, StartTime = 0 }, 
	f6 = { Status = false, Time = 0, StartTime = 0 }, 
	f7 = { Status = false, Time = 0, StartTime = 0 }, 
	f8 = { Status = false, Time = 0, StartTime = 0 }, 
	f9 = { Status = false, Time = 0, StartTime = 0 }, 
	f10 = { Status = false, Time = 0, StartTime = 0 }, 
	f11 = { Status = false, Time = 0, StartTime = 0 }, 
	f12 = { Status = false, Time = 0, StartTime = 0 }, 
	insert = { Status = false, Time = 0, StartTime = 0 }, 
	printscreen = { Status = false, Time = 0, StartTime = 0 }, 
	delete = { Status = false, Time = 0, StartTime = 0 }, 
	tab = { Status = false, Time = 0, StartTime = 0 }, 
	q = { Status = false, Time = 0, StartTime = 0 }, 
	w = { Status = false, Time = 0, StartTime = 0 }, 
	e = { Status = false, Time = 0, StartTime = 0 }, 
	r = { Status = false, Time = 0, StartTime = 0 }, 
	t = { Status = false, Time = 0, StartTime = 0 }, 
	y = { Status = false, Time = 0, StartTime = 0 }, 
	u = { Status = false, Time = 0, StartTime = 0 }, 
	i = { Status = false, Time = 0, StartTime = 0 }, 
	o = { Status = false, Time = 0, StartTime = 0 }, 
	p = { Status = false, Time = 0, StartTime = 0 }, 
	pageup = { Status = false, Time = 0, StartTime = 0 }, 
	capslock = { Status = false, Time = 0, StartTime = 0 }, 
	a = { Status = false, Time = 0, StartTime = 0 }, 
	s = { Status = false, Time = 0, StartTime = 0 }, 
	d = { Status = false, Time = 0, StartTime = 0 }, 
	f = { Status = false, Time = 0, StartTime = 0 }, 
	g = { Status = false, Time = 0, StartTime = 0 }, 
	h = { Status = false, Time = 0, StartTime = 0 }, 
	j = { Status = false, Time = 0, StartTime = 0 }, 
	k = { Status = false, Time = 0, StartTime = 0 }, 
	l = { Status = false, Time = 0, StartTime = 0 }, 
	pagedown = { Status = false, Time = 0, StartTime = 0 }, 
	lshift = { Status = false, Time = 0, StartTime = 0 }, 
	z = { Status = false, Time = 0, StartTime = 0 }, 
	x = { Status = false, Time = 0, StartTime = 0 }, 
	c = { Status = false, Time = 0, StartTime = 0 }, 
	v = { Status = false, Time = 0, StartTime = 0 }, 
	b = { Status = false, Time = 0, StartTime = 0 }, 
	n = { Status = false, Time = 0, StartTime = 0 }, 
	m = { Status = false, Time = 0, StartTime = 0 }, 
	rshift = { Status = false, Time = 0, StartTime = 0 }, 
	up = { Status = false, Time = 0, StartTime = 0 }, 
	lctrl = { Status = false, Time = 0, StartTime = 0 }, 
	rgui = { Status = false, Time = 0, StartTime = 0 }, 
	lgui = { Status = false, Time = 0, StartTime = 0 }, 
	lalt = { Status = false, Time = 0, StartTime = 0 }, 
	ralt = { Status = false, Time = 0, StartTime = 0 }, 
	rctrl = { Status = false, Time = 0, StartTime = 0 }, 
	application = { Status = false, Time = 0, StartTime = 0 }, 
	left = { Status = false, Time = 0, StartTime = 0 }, 
	down = { Status = false, Time = 0, StartTime = 0 }, 
	right = { Status = false, Time = 0, StartTime = 0 }, 
	backspace = { Status = false, Time = 0, StartTime = 0 }, 
	home = { Status = false, Time = 0, StartTime = 0 }, 
}
KeyPressed['1'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['2'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['3'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['4'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['5'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['6'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['7'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['8'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['9'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['0'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['['] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed[']'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['\\'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed[';'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed["'"]	= { Status = false, Time = 0, StartTime = 0 }
KeyPressed['return'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed[','] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['.'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['/'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['end'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed[' '] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['`'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['-'] = { Status = false, Time = 0, StartTime = 0 }
KeyPressed['='] = { Status = false, Time = 0, StartTime = 0 }

local KeyManager = { KeyTapped = KeyTapped, KeyPressed = KeyPressed }

function KeyManager.Keypressed( Key, IsRepeat )
	if KeyTapped[Key] then
		KeyTapped[Key].Status = true
		KeyTapped[Key].Time = 0
		KeyTapped[Key].StartTime = love.timer.getTime()
		
		KeyPressed[Key].Status = true
		KeyPressed[Key].Time = 0
		KeyPressed[Key].StartTime = love.timer.getTime()
	else
		KeyManager.AddKey( Key )
		KeyManager.Keypressed( Key, IsRepeat )
	end
end

function KeyManager.Keyreleased( Key, IsRepeat )
	KeyTapped[Key].Status = false
	
	KeyPressed[Key].Status = false
end

function KeyManager.Update( dt )
	for a, e in pairs( KeyTapped ) do
		if e.Status then
			e.Time = e.Time + dt
			
			if e.Time > TapTime then
				e.Status = false
			end
		end
	end
	
	for a, e in pairs( KeyPressed ) do
		if e.Status then
			e.Time = e.Time + dt
		end
	end
end

function KeyManager.SetTapTo( Key, Boolean )
	KeyTapped[Key].Status = Boolean
end

function KeyManager.SetPressTo( Key, Boolean )
	KeyPressed[Key].Status = Boolean
end

function KeyManager.ChangePressedTimeTo( Key, Time )
	KeyPressed[Key].Time = Time
end

function KeyManager.ChangeTappedTimeTo( Key, Time )
	KeyTapped[Key].Time = Time
end

function KeyManager.ChangeTapTime( Time )
	TapTime = Time
end

function KeyManager.GetTapTime()
	return TapTime
end

function KeyManager.AddKey( Key )
	KeyTapped[Key] = { Status = false, Time = 0, StartTime = 0 }
	KeyPressed[Key] = { Status = false, Time = 0, StartTime = 0 }
end

return KeyManager