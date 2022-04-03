; Additional HotKeys to LMMS using AutoHotKey (only for windows)
;
; Inspired after checking the https://enhancementsuite.me/ project, that is something similar but for Ableton Live.
; It uses acc.ahk Standard Library by Sean Updated by jethrow
; 	http://www.autohotkey.com/board/topic/77303-acc-library-ahk-l-updated-09272012/
; 	https://dl.dropbox.com/u/47573473/Web%20Server/AHK_L/Acc.ahk
; It also uses additional acc functions (acc-extended.ahk) Sorry, I don't know the author
; both are included in the acc-for-lmms.ahk
;------------------------------------------------------------------------------

#NoEnv  
#SingleInstance Force
#UseHook

#include acc-for-lah.ahk

VstVisibles := True
VstVisiblePID := ""
LoopPointsActive := False

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

MouseXPos := 0
MouseYPos := 0

; global variables for context menus
global fxMenu, fxArray := []
global vstMenu, vstArray := []
global samplesFoldersMenu, samplesFoldersArray := []

global PinnedFxChannels := "|"
global FxChannelToPinUnPin


; read config.xml file
xmlFile := A_ScriptDir "\config.xml"
FileRead, xmlData, % xmlFile
xmlDoc := ComObjCreate("MSXML2.DOMDocument.6.0")
xmlDoc.async := false
xmlDoc.loadXML(xmlData)

;-------------------------------------
; Context Menus creation
;-------------------------------------

; Create MenuSampleFolder
for Item in ( xmlDoc.selectNodes( "//ConfigFile/MenuSamplesFolders/MenuItem" ),  descList2 := ""  )
{
	MenuItem := Item.getAttribute( "show" )
	MenuShowItem := Item.getAttribute( "value" )
	MenuItemShow := StrSplit(MenuItem, "/")
	MenuFather := "samplesFoldersMenu"
	SubMenuFather := ""
	if MenuItemShow.Count() == 1
	{
		Menu, %MenuFather%, Add, %MenuItem%, MenuHandlerSamplesFolders
		if (MenuShowItem == "")
			samplesFoldersArray[MenuItem] := MenuItem
		else
			samplesFoldersArray[MenuItem] := MenuShowItem
	}
	else
	{
		for index, MenuItem in MenuItemShow
		{		
			if % index == 1
				SubMenuFather := MenuItem
			else
			{
				Menu, %SubMenuFather%, Add, %MenuItem%, MenuHandlerSamplesFolders
				Menu, %MenuFather%, Add, %SubMenuFather%, % ":" . SubMenuFather
				MenuFather := SubMenuFather
				SubMenuFather := MenuItem
				if % index == MenuItemShow.Count()
				{
					if (MenuShowItem == "")
						samplesFoldersArray[MenuItem] := MenuItem
					else
						samplesFoldersArray[MenuItem] := MenuShowItem
				}
			}
		}
	}
}	

; Create fxMenu context menu
for Item in ( xmlDoc.selectNodes( "//ConfigFile/MenuFX/MenuItem" ),  descList2 := ""  )
{
	MenuItem := Item.getAttribute( "show" )
	MenuShowItem := Item.getAttribute( "value" )
	MenuItemShow := StrSplit(MenuItem, "/")
	MenuFather := "fxMenu"
	SubMenuFather := ""
	if MenuItemShow.Count() == 1
	{
		Menu, %MenuFather%, Add, %MenuItem%, MenuHandlerFX
		if (MenuShowItem == "")
			fxArray[MenuItem] := MenuItem
		else
			fxArray[MenuItem] := MenuShowItem
	}
	else
	{
		for index, MenuItem in MenuItemShow
		{		
			if % index == 1
				SubMenuFather := MenuItem
			else
			{
				Menu, %SubMenuFather%, Add, %MenuItem%, MenuHandlerFX
				Menu, %MenuFather%, Add, %SubMenuFather%, % ":" . SubMenuFather
				MenuFather := SubMenuFather
				SubMenuFather := MenuItem
				if % index == MenuItemShow.Count()
				{
					if (MenuShowItem == "")
						fxArray[MenuItem] := MenuItem
					else
						fxArray[MenuItem] := MenuShowItem
				}
			}
		}
	}
}	

; Create vstMenu context menu
for Item in ( xmlDoc.selectNodes( "//ConfigFile/MenuVeSTige/MenuItem" ),  descList2 := ""  )
{
	MenuItem := Item.getAttribute( "show" )
	MenuShowItem := Item.getAttribute( "value" )
	MenuItemShow := StrSplit(MenuItem, "/")
	MenuFather := "vstMenu"
	SubMenuFather := ""
	if MenuItemShow.Count() == 1
	{
		Menu, %MenuFather%, Add, %MenuItem%, MenuHandlerVST
		if (MenuShowItem == "")
			vstArray[MenuItem] := MenuItem
		else
			vstArray[MenuItem] := MenuShowItem
	}
	else
	{
		for index, MenuItem in MenuItemShow
		{		
			if % index == 1
				SubMenuFather := MenuItem
			else
			{
				Menu, %SubMenuFather%, Add, %MenuItem%, MenuHandlerVST
				Menu, %MenuFather%, Add, %SubMenuFather%, % ":" . SubMenuFather
				MenuFather := SubMenuFather
				SubMenuFather := MenuItem
				if % index == MenuItemShow.Count()
				{
					if (MenuShowItem == "")
						vstArray[MenuItem] := MenuItem
					else
						vstArray[MenuItem] := MenuShowItem
				}
			}
		}
	}
}	

; Create FX context menu for Pinning and Unpinning Fx Channels
Menu fxChannelMenu, Add, Pin this channel, MenuHandlerFxMenu
Menu fxChannelMenu, Add, Pin All Channels to the right, MenuHandlerFxMenu
																		 
Menu fxChannelMenu, Add, UnPin this channel, MenuHandlerFxMenu
Menu fxChannelMenu, Add, UnPin all channels, MenuHandlerFxMenu


;-------------------------------------
; HotKey "creation"
;-------------------------------------


#IfWinActive ahk_exe lmms.exe

; Ctrl+Space: Song-Editor Play/Pause 
HotKey, ^Space, SongEditor-PlayStop
; Alt+Space: Piano-Roll Play/Pause
HotKey, !Space, PianoRoll-PlayStop
; Ctrl+Alt+Space: Piano-Roll record while playing
HotKey, ^!Space, PianoRoll-Record-While-Playing
; Ctrl+l: Enable/Disable Loop-points
HotKey, ^l, Loop-Points-EnableDisable
; Ctrl+Alt+V: LMMS: hide/show all visible VST (only works when Plugin embedding option is set to "no embedding")
HotKey, ^!v, VST-HideShow
; Ctrl+Alt+w: Clear the workspace, closing all windows (except VST if Plugin embedding option is set to "no embedding") and then opens de Song-Editor
HotKey, ^!w, Clear-WorkSpace
; Ctrl+Alt+p: Click on "Mute this FX channel" for all Pinned FX Channels (trough context menu)
Hotkey, ^!p, Click-On-Pin-Fx-Channels
; Ctrl+LeftMouseButton: (context action) show context menu, for effects and for VesTIge instruments (menus are defined in config.xml file). And to Pin FX channels (menu inside this code)
Hotkey, ^LButton, Show-Context-Menu
; MiddleMouseButton: (context action) delete the FX the cursor is over. Turning off this effect temporarily
; Hotkey, MButton, Delete-FX


#IfWinActive

return

;--------------------------------
; Hotkey functions definition
;--------------------------------

; Ctrl+Space: Song-Editor Play/Stop (equivalent to hit "Space" inside the Song-Editor)
SongEditor-PlayStop:
	WinActivate, ahk_exe lmms.exe
	WinGet, hWnd, ID, A
	;PathObj := "4.1.1.2.1.8.1.2.2" ; --> this is the Play-Button Id
	; Get object with focus
	acc_window_focus := Acc_ObjectFromWindow(hWnd)
	if (IsObject(acc_window_focus.accFocus))
		acc_window_focus := acc_window_focus.accFocus
	;Send focus to Song-Editor window and send a "Space" key
	PathObj := "4.1.1.2.1.8" ; --> this is the Song-Editor window Id
	oAcc := Acc_Get("Object", PathObj, 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)
	Send {Space}
	; return focus to original object
	if (IsObject(acc_window_focus))
		acc_window_focus.accDoDefaultAction(0)
return

; Alt+Space: Piano-Roll Play/Stop ((equivalent to hit "Space" inside the Piano-Roll)
PianoRoll-PlayStop:
	WinActivate, ahk_exe lmms.exe
	WinGet, hWnd, ID, A
	;PathObj := "4.1.1.2.1.7.1.2.2" ; --> this is the Play-Button Id
	; Get object with focus
	acc_window_focus := Acc_ObjectFromWindow(hWnd)
	if (IsObject(acc_window_focus.accFocus))
		acc_window_focus := acc_window_focus.accFocus
	;Send focus to Piano-Roll window and send a "Space" key
	PathObj := "4.1.1.2.1.7" ; --> this is the Piano-Roll window Id
	oAcc := Acc_Get("Object", PathObj, 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)
	Send {Space}
	; return focus to original object
	if (IsObject(acc_window_focus))
		acc_window_focus.accDoDefaultAction(0)
return

; Ctrl+Alt+Space: Piano-Roll record while playing
PianoRoll-Record-While-Playing:
	WinActivate, ahk_exe lmms.exe
	WinGet, hWnd, ID, A
	;Send focus to Piano-Roll window
	PathObj := "4.1.1.2.1.7" ; --> this is the Piano-Roll window Id
	oAcc := Acc_Get("Object", PathObj, 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)
	;Click on Record-While-Playing Button
	PathObj := "4.1.1.2.1.7.1.2.4" ; --> this is the Record-While-Playing-Button Id
	oAcc := Acc_Get("Object", PathObj, 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)
return

; Ctrl+l: Enable/Disable Loop-points
Loop-Points-EnableDisable:
	WinActivate, ahk_exe lmms.exe
	WinGet, hWnd, ID, A
	; Get original mouse position
	MouseGetPos, MouseX, MouseY
	; Get object with focus
	acc_window_focus := Acc_ObjectFromWindow(hWnd)
	if (IsObject(acc_window_focus.accFocus))
		acc_window_focus := acc_window_focus.accFocus
	;Set focus to Song-Editor
	PathObj := "4.1.1.2.1.8"
	oAcc := Acc_Get("Object", PathObj, 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)	
	;Click on Enable/Disable loop-points button by getting it's position relative to the Song-Editor window and click on that point
	PathObj := "4.1.1.2.1.8.1.6.3" ; --> this is the Enable/Disable loop-points button Id
	oAcc := Acc_Get("Object", PathObj, 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)
	WinObjPos := Acc_Get("Location", PathObj, 0, "ahk_id " hWnd)
	StringSplit, PosXY, WinObjPos, %A_Space%
	PosX := SubStr(PosXY1, 2) + 10
	PosY := SubStr(PosXY2, 2) + 10
	Click, %PosX% %PosY%
	; return focus and mouse to original state
	if (IsObject(acc_window_focus))
		acc_window_focus.accDoDefaultAction(0)
	MouseMove, MouseX, MouseY
return

; "Ctrl+Alt+V": LMMS: hide/show all visible VST (only works when Plugin embedding option is set to "no embedding")
VST-HideShow:
	; set hourglass cursor while the function is running
	SetSystemCursor()
	if (VstVisibles = True) 
	{
		; if VST are visible, then store its processID, and hide them
		DetectHiddenWindows, Off
		VstVisiblePID := ""
		; get all visible windows
		windows := ""
		WinGet windows, List,,, Program Manager
		Loop %windows%
		{
			id := windows%A_Index%
			processnameoutput := ""
			Winget processnameoutput, ProcessName, ahk_id %id%
			; if it's a VST Process (32 or 64 bits)
			if (RegExMatch(processnameoutput, "RemoteVstPlugin")){ 
				Winget pid, PID, ahk_id %id%
				WinHide, ahk_pid %pid%
				VstVisiblePID := pid . "|" . VstVisiblePID
				Sleep, 100
			}
		}
		VstVisibles := False
	}
	else
	{
		; show VST previously hidden, on VstVisible PID
		VstPID := VstVisiblePID
		loop, Parse, VstPID, "|"
		{
			pid := A_LoopField
			WinShow, ahk_pid %pid%
			Sleep, 100
		}
		VstVisibles := True
		VstVisiblePID := ""

	}
	; set cursor to default
	RestoreCursors()
return

; Ctrl+Alt+w: Clear the workspace, closing all windows (except VST if Plugin embedding option is set to "no embedding")) and then opens de Song-Editor, as a default window
Clear-WorkSpace:
	; set hourglass cursor while the function is running
	SetSystemCursor()
	WinActivate, ahk_exe lmms.exe
	WinGet, hWnd, ID, A
	; All windows inside LMMS main "workspace"
	loop {
		PathObj := "4.1.1.2.1." . A_index
		oAcc := Acc_Get("Object", PathObj, 0, "ahk_id " hWnd)
		if isObject(oAcc)
		{
			WinObjPos := Acc_Get("Location", PathObj, 0, "ahk_id " hWnd)
			; if Position = "x0 y0 w0 h0" means the window is hidden, so there is no point in closing the window
			If (WinObjPos != "x0 y0 w0 h0")
			{
				oAcc.accDoDefaultAction(0)
				;Sleep, 50
				Send ^{F4}
			}
		}
		else
		{
			; Opens Song-Editor
			Send {F5}
			; we break the loop as there are no more windows
			break
		}
	}
	RestoreCursors()
return

; Alt + P: Click on "Mute this FX channel" for all Pinned FX Channels (trough context menu)
Click-On-Pin-Fx-Channels:
	if ( PinnedFxChannels == "|")
		MsgBox, 64,, No Pinned chanels. `r`nPlease, pin them with the context menu on the FX channels.
	else
	{
		; Note: all channels should be visible
		WinActivate, ahk_exe lmms.exe
		WinGet, hWnd, ID, A
		vAccPath := "4.1.1.2.1.1" ; --> this is FX-mixer window. Give the focus to the window, so FX are visible
		Obj := Acc_Get("Object", vAccPath, 0, "ahk_id " hWnd)
		Obj.accDoDefaultAction(0)
		RealPinnedFxChannels := SubStr(PinnedFxChannels, 2, StrLen(PinnedFxChannels) - 2)
		Loop, Parse, RealPinnedFxChannels, "|"
		{
			vAccPath := "4.1.1.2.1.1.1.2.1.1." . A_LoopField . ".1"
			WinObjPos := Acc_Get("Location", vAccPath, 0, "ahk_id " hWnd)
																					   
											
	   
			vAccPath := "4.1.1.2.1.1.1.2.1.1." . A_LoopField . ".6" ;-> this is the path to the "Mute this FX channel" object
			WinObjPos := Acc_Get("Location", vAccPath, 0, "ahk_id " hWnd)
			StringSplit, PosXY, WinObjPos, %A_Space%
			PosX := SubStr(PosXY1, 2) + 8
			PosY := SubStr(PosXY2, 2) + 8
			CoordMode, Mouse, Screen
			Click, %PosX% %PosY%
		}
	}
return

; Ctrl+LeftMouseButton: show context menu, for effects and for VesTIge instruments (menus are defined in config.xml file)
; unfortunately, only works when the clicked object doesn't have anything behind it.
Show-Context-Menu:
	WinGet, hWnd, ID, A
	oAcc := Acc_ObjectFromPoint(vChildID)
	vName := vValue := ""
	vName := oAcc.accName(0)
	vValue := oAcc.accValue(0)
	vDescription := oAcc.accDescription(0)
	vHelp := oAcc.accHelp(0)
	; if the user clicks on "Add effect" button either on smple/instrument FX tab or in FX-Mixer
	if (vName == "Add effect")
	{ 
		MouseGetPos, MouseXPos, MouseYPos
		Menu, fxMenu, Show
		return
	}
	; if the user clicks on the VeTIge folder icon to load a VST instrument
	if (vDescription == "Open other VST-plugin")
	{ 
		MouseGetPos, MouseXPos, MouseYPos
		Menu, vstMenu, Show
		return
	}
	; if the user clicks on the folder icon on "AudioFileProcessor" or in a sample-track, helps you go to an establish folder where your project sampler are.
	if (vDescription == "Open other sample") or (vDescription == "double-click to select sample")
	{ 
		MouseGetPos, MouseXPos, MouseYPos
		Menu, samplesFoldersMenu, Show
		return
	}
	; if users clicks on an FX channel, we have to search for description in an inside object because the FX channel doesn't have any name nor description
	FxChannelToPinUnPin := 0
	vAccPath := JEE_AccGetPath(oAcc, hWnd)
	SvAccPath := StrSplit(vAccPath, ".")
	FxChannel := SvAccPath[11]
	vAccPath := "4.1.1.2.1.1.1.2.1.1." . FxChannel  ;-> this is the path to the FX channel object																							  
	oAcc := Acc_Get("Object", vAccPath, 0, "ahk_id " hWnd)
	vDescription := oAcc.accDescription(0)
	if (InStr (vDescription, "The FX channel receives input" > 0))
	{ 
		FxChannelToPinUnPin := FxChannel
		MouseGetPos, MouseXPos, MouseYPos
		Menu, fxChannelMenu, Show
	}
return


; MiddleMouseButton: (context action) delete the FX the cursor is over
Delete-FX:
	WinGet, hWnd, ID, A
	oAcc := Acc_ObjectFromPoint(vChildID)
	vHelp := oAcc.accHelp(vChildID)
	;if the user middle-click on an Effect either on smple/instrument FX tab or in FX-Mixer
	if (InStr (vHelp, "Effect plugins function" > 0))
	{ 
		Send {RButton}
		Send R
	}
return


;------------------------------
; Menu Handlers
;------------------------------

; menuHandler for "Add effect" button
MenuHandlerFX:
;MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
Send {Click %MouseXPos% %MouseYPos%}
Sleep 500
SendInput %A_ThisMenuItem%
Sleep 500
Send {ENTER}
return

; menuHandler for VeSTige folder icon
MenuHandlerVST:
;MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
vstName := vstArray[A_ThisMenuItem]
Send {Click %MouseXPos% %MouseYPos%}
Sleep 500
SendInput C:\Users\superpaik\lmms\VST\%vstName%
Sleep 500
Send {ENTER}
return

; menuHandler for folder icon inside AudioFileProcessor or in Sample Track
MenuHandlerSamplesFolders:
	sampleFolder := samplesFoldersArray[A_ThisMenuItem]
	if (vDescription == "Open other sample")
		Send {Click %MouseXPos% %MouseYPos%}
	else
		; for sample track, a double-click is needed
		Send {Click %MouseXPos% %MouseYPos% 2}
	Sleep 500
	SendInput %sampleFolder%
	Sleep 500
	Send {ENTER}
return

; menuHandler for FX channel
MenuHandlerFxMenu:
	SetSystemCursor() ; this action might take some time
	;if no channel selected, return
	if FxChannelToPinUnPin == 0
		return
	if (A_ThisMenuItem == "Pin this channel")
	{
		; if the channel is not already pinned
		if (InStr(PinnedFxChannels, FxChannelToPinUnPin) == 0)
			PinnedFxChannels .= FxChannelToPinUnPin . "|"
	}
	if (A_ThisMenuItem == "Pin All Channels to the right")
	{
		; Pin the channel the cursor is, if the channel is not already pinned
		if (InStr(PinnedFxChannels, FxChannelToPinUnPin) == 0)
			PinnedFxChannels .= FxChannelToPinUnPin . "|"
		; Pin all other other channels to the right
		FxChannel := FxChannelToPinUnPin +  1
		loop {
			PathObj := "4.1.1.2.1.1.1.2.1.1." . FxChannel  ;-> this is the path to the FX channel object
			oAcc := Acc_Get("Object", PathObj, 0, "ahk_id " hWnd)
			if isObject(oAcc)
			{
				vDescription := oAcc.accDescription(0)
				if (InStr (vDescription, "The FX channel receives input" > 0))
					if (InStr(PinnedFxChannels, FxChannel) == 0)
						PinnedFxChannels .= FxChannel . "|"
				FxChannel += 1
			} 
			else
				break
		}
	}
	if (A_ThisMenuItem == "UnPin this channel")
	{
		FoundPos := InStr(PinnedFxChannels, FxChannelToPinUnPin)
		if FoundPos != 0
		{
			LeftString := SubStr(PinnedFxChannels, 1, FoundPos - 1)
			RightString := SubStr(PinnedFxChannels, FoundPos + StrLen(FxChannelToPinUnPin) + 1)
			MsgBox, "L" %LeftString% "R" %RightString% "Pos" %FoundPos%
			PinnedFxChannels := LeftString . RightString
		}
	}
	if (A_ThisMenuItem == "UnPin all channels")
		PinnedFxChannels := "|"
	RestoreCursors()
return


;------------------------------
; Common Functions
;------------------------------

SetSystemCursor()
{
	IDC_WAIT := 32514
	CursorHandle := DllCall( "LoadCursor", Uint,0, Int,IDC_WAIT )
	Cursors = 32512,32513,32514,32515,32516,32640,32641,32642,32643,32644,32645,32646,32648,32649,32650,32651
	Loop, Parse, Cursors, `,
	{
		DllCall( "SetSystemCursor", Uint,CursorHandle, Int,A_Loopfield )
	}
}

RestoreCursors() 
{
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt,SPI_SETCURSORS, UInt,0, UInt,0, UInt,0 )
}




