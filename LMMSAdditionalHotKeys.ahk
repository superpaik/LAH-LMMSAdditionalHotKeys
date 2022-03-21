#SingleInstance Force
VstVisibles := True
VstVisiblePID := ""
LoopPointsActive := False
#UseHook

;return   ;// end of auto exec


#IfWinActive ahk_exe lmms.exe
; Ctrl+Space: play/stop from Song Editor
HotKey, ^Space, Song-Editor-PlayStop
; Alt+Space: play/stop from Piano Roll
HotKey, !Space, Piano-Roll-PlayStop
; Ctrl+Alt+Space: play/stop record button from Piano Roll 
HotKey, ^!Space, Piano-Roll-Record-PlayStop
; Ctrl+l: Enable/Disable Loop-points
HotKey, ^l, Loop-Points-EnableDisable
; hide/show all visible VST "Alt+V"
HotKey, !v, VST-HideShow


;--------------------------------
; Hotkey functions definition
;--------------------------------

; Ctrl+Space: play/stop from Song Editor
Song-Editor-PlayStop:
	WinActivate, ahk_exe lmms.exe
	Send, {F9}
	Sleep, 100
	Send, {F5}
	Sleep, 100
	Send {Space}
	;Sleep, 100
return

; Alt+Space: play/stop from Piano Roll
Piano-Roll-PlayStop:
	WinActivate, ahk_exe lmms.exe
	Send, {F9}
	Sleep, 100
	Send, {F7}
	Sleep, 100
	Send {Space}
	Sleep, 100
return

; Ctrl+Alt+Space: play record button from Piano Roll 
Piano-Roll-Record-PlayStop:
	WinActivate, ahk_exe lmms.exe
	Send, {F9}
	Sleep, 100
	Send, {F7}
	MouseMove, 0, 0
	Sleep, 100
	WinSet, Transparent, Off
	;CoordMode Pixel  ; Interprets the coordinates below as relative to the screen rather than the active window.
	WinGetPos, X, Y, Width, Height, A
	;MsgBox Window Pos&Size %X%x%Y% %Width%x%Height% 
	CoordMode, Pixel, Window
	ImageSearch, FoundX, FoundY, 0, 0, Width, Height, *3 resources\record-play.bmp
	if (ErrorLevel = 2)
		MsgBox Sorry, Record Play icon file could not be found. Try again.
	else if (ErrorLevel = 1)
		MsgBox Sorry, Record Play button could not be found on the screen. Try again.
	else
	{
		;MsgBox The icon was found at %FoundX%x%FoundY%.
		Sleep, 100
		MouseMove, FoundX, FoundY
		Click, FoundX, FoundY
	}
return

; Ctrl+l: Enable/Disable Loop-points
Loop-Points-EnableDisable:
	WinActivate, ahk_exe lmms.exe
	IconExists := False
	Send, {F9}
	Sleep, 100
	Send, {F5}
	MouseMove, 0, 0
	Sleep, 100
	WinSet, Transparent, Off
	WinGetPos, X, Y, Width, Height, A
	CoordMode, Pixel, Window	
	ImageSearch, FoundX, FoundY, 0, 0, Width, Height, *3 resources\loop-points-active.png
	if (ErrorLevel = 2)
		MsgBox Sorry, Loop-Points active button icon file could not be found. Try again.
	else if (ErrorLevel = 1)
	{
		ImageSearch, FoundX, FoundY, 0, 0, Width, Height, *3 resources\loop-points-inactive.png
		if (ErrorLevel = 2)
			MsgBox Sorry, Loop-Points inactive button icon file could not be found. Try again.
		else if (ErrorLevel = 1)
		{
			MsgBox Sorry, Loop-Points button could not be found on the screen. Try again.
		}
		else
			IconExists := True
	}
	else
		IconExists := True
		
	If (IconExists = True)
	{
		MouseMove, FoundX, FoundY
		Sleep, 100
		Click, FoundX, FoundY
	}
return


; LMMS: hide/show all visible VST "Alt+V"
VST-HideShow:
	if (VstVisibles = True) 
	{
		DetectHiddenWindows, Off
		VstVisiblePID := ""
		;MsgBox, Hide all visible VST . %VstVisibles%
	}
	else
	{
		DetectHiddenWindows, On
		;MsgBox, Show all visible VST . %VstVisibles%
	}
	WinGet windows, List
	SetTitleMatchMode, 3
	;windowlist := ""
	Loop %windows%
	{
		id := windows%A_Index%
		Winget processnameoutput, ProcessName, ahk_id %id%
		Winget pid, PID, ahk_id %id%
	;	windowlist .= pid . " # " . processnameoutput . " # " . classnameoutput . "`n"
		if (RegExMatch(processnameoutput, "RemoteVstPlugin")){ 
			if (VstVisibles = True) 
			{
				WinHide, ahk_pid %pid%
				VstVisiblePID := pid . "|" . VstVisiblePID
				Sleep, 100
			}
			else
			{
				if RegExMatch(VstVisiblePID, pid) {
					WinShow, ahk_pid %pid%
					Sleep, 100
				}
			}
		}
	}
	if (VstVisibles = True) 
	{
		VstVisibles := False
	}
	else
	{
		VstVisibles := True
		VstVisiblePID := ""
	}
	;MsgBox %VstVisiblePID%
	;MsgBox %windowlist%
	SetTitleMatchMode, 2
return

;------------------------------
; Common Functions
;------------------------------

#IfWinActive

;^!r::Reload  ; Ctrl+Alt+R


^!t::
	;MouseGetPos,,,guideUnderCursor
	;WinGetTitle, WinTitle, ahk_id %guideUnderCursor%
	;MsgBox, %WinTitle%
	;ControlGet, OutVar, Hwnd, ,ahk_id %guideUnderCursor%
	;MsgBox, %OutVar%
	
	MouseGetPos, , , id, control
	WinGetTitle, title, ahk_id %id%
	WinGetClass, class, ahk_id %id%
	ToolTip, ahk_id %id%`nahk_class %class%`n%title%`nControl: %control%
	
return
