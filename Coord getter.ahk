tool_CoordGetter() {

	;We get all the coordinates and the pixel color at absolute coords
	CoordMode("Mouse", "Screen")
	MouseGetPos(&locScrX, &locScrY)

	CoordMode("Mouse", "Client")
	MouseGetPos(&locCliX, &locCliY)

	CoordMode("Mouse", "Window")
	MouseGetPos(&locWinX, &locWinY)

	CoordMode("Pixel", "Screen")
	pixel := PixelGetColor(locScrX, locScrY, "Alt Slow") ;Haven't used pixelgetcolor so using the slowest method for safety

	;Creation of the gui
	g_CrdGet := Gui(, "Coord Getter")
	g_CrdGet.Backcolor := "171717"
	g_CrdGet.SetFont("S30 cC5C5C5", "Consolas")

	CrdGet_hwnd := g_CrdGet.hwnd

	;Adding all the text for the gui
	g_CrdGet_CtrlFormat := g_CrdGet.Add("Text",, "X = " . locCliX . "`nY = " . locCliY)
	g_CrdGet_Screen     := g_CrdGet.Add("Text",, "Screen")
	g_CrdGet_Client     := g_CrdGet.Add("Text", "y+15", "Client")
	g_CrdGet_Window     := g_CrdGet.Add("Text", "y+15", "Window") ;The 'word' text is visually more grouped together
	g_CrdGet_Pixel      := g_CrdGet.Add("Text", "y+35", pixel)

	;Destroys the gui as well as every previously created hotkey
	;You can also append defining arrow functions, but there has to be nothing after them (on the same line). Otherwise that next thing is considered as the second value for => to return, which is an error. To go around this, you can wrap the whole arrow definition into () and then it's all good. But at that point, what are you doing (we draw the line right below what we believe)
	FlushHotkeys := (*) => (
		HotIfWinActive("ahk_id " CrdGet_hwnd),
		Hotkey("F1", "Off"),
		Hotkey("F2", "Off"),
		Hotkey("F3", "Off"),
		Hotkey("F4", "Off"),
		Hotkey("F5", "Off"),
		Hotkey("Escape", "Off"),
		g_CrdGet.Destroy()
	)

	;This function copies the text you clicked to your clipboard and destroys the gui right after
	ToClip(text, *) => (A_Clipboard := text, FlushHotkeys())

	;Defining all the function objects that we're gonna call by hotkeys and buttons. (*) takes care of Hotkey and OnEvent requiring parameters we aren't gonna use
	;If you keep appending lines for too long, it overflows the memory and gives an error -- this is why there's no , here. Plus, harder to debug because ahk sees it as one line. The positive is that it's around 35% faster. Be careful with this tradeoff (you can remove all the ,'s at starts of lines if you want)
	ToClip_CtrlFormat := ToClip.Bind("`"X" locCliX " Y" locCliY "`"") ;You get the formatting that you can just paste into your controlclick without having to change anything
	ToClip_Screen     := ToClip.Bind(locScrX " " locScrY)
	ToClip_Client     := ToClip.Bind(locCliX " " locCliY)
	ToClip_Window     := ToClip.Bind(locWinX " " locWinY) ;Pure coords with no formatting for the other options
	ToClip_Pixel      := ToClip.Bind(pixel)

	;Press a hotkey to activate its func object
	HotIfWinActive("ahk_id " CrdGet_hwnd)
	Hotkey("F1",     ToClip_CtrlFormat, "On")
	Hotkey("F2",     ToClip_Screen,     "On")
	Hotkey("F3",     ToClip_Client,     "On")
	Hotkey("F4",     ToClip_Window,     "On")
	Hotkey("F5",     ToClip_Pixel,      "On")
	Hotkey("Escape", FlushHotkeys,      "On")

	;Click the text to activate its func object (same as with hotkeys)
	g_CrdGet_CtrlFormat.OnEvent("Click", ToClip_CtrlFormat)
	g_CrdGet_Screen.OnEvent(    "Click", ToClip_Screen)
	g_CrdGet_Client.OnEvent(    "Click", ToClip_Client)
	g_CrdGet_Window.OnEvent(    "Click", ToClip_Window)
	g_CrdGet_Pixel.OnEvent(     "Click", ToClip_Pixel)

	g_CrdGet.OnEvent("Close", FlushHotkeys) ;The gui isn't automatically destroyed when you click X by default, you'd have to do `guiObj.OnEvent("Close", (*) => guiObj.Destroy())` usually

	g_CrdGet.Show("Center H440 W300 y0 x" A_ScreenWidth / 8 * 6.3)

}
