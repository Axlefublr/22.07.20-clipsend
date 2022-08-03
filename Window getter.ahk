tool_WindowGetter() {

	;Getting the current window's info
	winTitle   := WinGetTitle("A")
	winExePath := WinGetProcessPath("A")
	winExe     := WinGetProcessName("A")
	winID      := WinGetID("A")
	winPID     := WinGetPID("A")

	;Gui creation
	g_WinGet := Gui(, "WindowGetter")
	g_WinGet.Backcolor := "171717"
	g_WinGet.SetFont("S20 cC5C5C5", "Consolas")

	WinGet_hwnd := g_WinGet.hwnd

	;Show the window's info
	g_WinGet_WinTitle   := g_WinGet.Add("Text", "Center", winTitle)
	g_WinGet_WinExePath := g_WinGet.Add("Text", "Center", winExePath)
	g_WinGet_WinExe     := g_WinGet.Add("Text", "Center", winExe)
	g_WinGet_WinID      := g_WinGet.Add("Text", "Center", "id: " winID)
	g_WinGet_WinPID     := g_WinGet.Add("Text", "Center", "pid: " winPID)

	;Destroys the gui as well as every previously created hotkeys
	FlushHotkeys := (*) => (
		HotIfWinActive("ahk_id " WinGet_hwnd),
		Hotkey("F1", "Off"),
		Hotkey("F2", "Off"),
		Hotkey("F3", "Off"),
		Hotkey("F4", "Off"),
		Hotkey("F5", "Off"),
		Hotkey("Escape", "Off"),
		g_WinGet.Destroy()
	)

	;This function copies the text you clicked to your clipboard and destroys the gui right after
	ToClip := (text, *) => (
		A_Clipboard := text,
		FlushHotkeys()
	)

	;Making the func objects to later call in two separate instances
	ToClip_Title := ToClip.Bind(winTitle) ;We pass the params of winSmth
	ToClip_Path  := ToClip.Bind(winExePath) ;To copy it, disable the hotkeys and destroy the gui
	ToClip_Exe   := ToClip.Bind(winExe) 
	ToClip_ID    := ToClip.Bind(winID) 
	ToClip_PID   := ToClip.Bind(winPID) 

	HotIfWinActive("ahk_id " WinGet_hwnd)
	Hotkey("F1", ToClip_Title, "On")
	Hotkey("F2", ToClip_path,  "On")
	Hotkey("F3", ToClip_Exe,   "On")
	Hotkey("F4", ToClip_ID,    "On")
	Hotkey("F5", ToClip_PID,   "On")

	Hotkey("Escape", FlushHotkeys, "On")

	g_WinGet_WinTitle.OnEvent(  "Click", ToClip_Title)
	g_WinGet_WinExePath.OnEvent("Click", ToClip_Path)
	g_WinGet_WinExe.OnEvent(    "Click", ToClip_Exe)
	g_WinGet_WinID.OnEvent(     "Click", ToClip_ID)
	g_WinGet_WinPID.OnEvent(    "Click", ToClip_PID)

	g_WinGet.OnEvent("Close", FlushHotkeys) ;Destroys the gui when you close the X button on it

	g_WinGet.Show("Center H300 W1000 y0")
}
