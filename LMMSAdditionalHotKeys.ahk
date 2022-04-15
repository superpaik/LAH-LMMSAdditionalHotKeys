; LMMS Additional HotKeys using AutoHotKey (only for windows)
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
#Persistent

#include acc-for-lah.ahk

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

VstVisibles := true
VstVisiblePID := ""
LoopPointsActive := false
IsPlaying := false
; This value is used in "Check for updates" against the file called version.txt on master/github
LocalVersion := "0.9"
CheckForUpdateURL := "https://raw.githubusercontent.com/superpaik/LAH-LMMSAdditionalHotKeys/master/version.txt"

MouseXPos := 0
MouseYPos := 0

;------------------------------------------------------------------------------
; SET TRAY-MENU
;------------------------------------------------------------------------------
Menu, Tray, Standard
Menu, Tray, Add
Menu, Tray, Add, My music, MyMusic
Menu, Tray, Add, Check for updates, ChkUpdates
Menu, Tray, Add, About..., About 
Menu, Tray, Click, 1
Menu, Tray, Tip, LAH (LMMS Additional HotKeys)


;-------------------------------------
; HotKey "creation"
;-------------------------------------

#IfWinActive ahk_exe lmms.exe

; Ctrl+Space: Song-Editor Play/Stop
HotKey, ^Space, SongEditor-PlayStop
; Alt+Space: Piano-Roll Play/Stop
HotKey, !Space, PianoRoll-PlayStop
; Ctrl+Alt+Space: Piano-Roll record while playing
HotKey, ^!Space, PianoRoll-Record-While-Playing
; Ctrl+Alt+p: Song-Editor Stop
HotKey, ^!p, SongEditor-Stop
; Ctrl+l: Enable/Disable Loop-points
HotKey, ^l, Loop-Points-EnableDisable
; Ctrl+Alt+V: LMMS: hide/show all visible VST (only works when Plugin embedding option is set to "no embedding")
HotKey, ^!v, VST-HideShow
; Ctrl+Alt+w: Clear the workspace, closing all windows (except VST if Plugin embedding option is set to "no embedding") and then opens de Song-Editor
HotKey, ^!w, Clear-WorkSpace
; Ctrl+Alt+p: Click on "Mute this FX channel" for all Pinned FX Channels (trough context menu)

#IfWinActive

return

MyMusic:
	Run, https://soundcloud.com/superpaik
return

About:
	Run, https://github.com/superpaik/LAH-LMMSAdditionalHotKeys
return

ChkUpdates:
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", CheckForUpdateURL, true)
	whr.Send()
	; Using 'true' above and the call below allows the script to remain responsive.
	whr.WaitForResponse() ;this is taken from the installer. Can also be located as an example on the urldownloadtofile page of the quick reference guide.
	RemoteVersion := whr.ResponseText
	if (LocalVersion == RemoteVersion)
		MsgBox, 64, Version information, You have the latest version. `nThanks for using LAH (LMMS Additional HotKeys).
	else
		MsgBox, 48, new Version available, Your current version is %LocalVersion%. The latest is %remoteVersion%. `nClick on "About..." in the script menu tray to go get the latest version.
return



;--------------------------------
; Hotkey functions definition
;--------------------------------

; Ctrl+Space: Song-Editor Play/Stop (equivalent to hit "Space" inside the Song-Editor)
SongEditor-PlayStop:
	WinActivate, ahk_exe lmms.exe
	WinGet, hWnd, ID, A
	if IsPlaying 
	{
		PathObj := "4.1.1.2.1.8.1.2.3" ; --> this is the Song-Editor Stop-Button Id
		IsPlaying := false
	}
	else
	{
		PathObj := "4.1.1.2.1.8.1.2.2" ; --> this is the Song-Editor Play-Button Id
		IsPlaying := true
	}
	oAcc := Acc_Get("Object", PathObj, 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)
return

; Alt+Space: Piano-Roll Play/Stop ((equivalent to hit "Space" inside the Piano-Roll)
PianoRoll-PlayStop:
	WinActivate, ahk_exe lmms.exe
	WinGet, hWnd, ID, A
	if IsPlaying 
	{
		PathObj := "4.1.1.2.1.7.1.2.5" ; --> this is the Piano-Roll Stop-Button Id.
		IsPlaying := false
	}
	else
	{
		PathObj := "4.1.1.2.1.7.1.2.2" ; --> this is the Piano-Roll Play-Button Id
		IsPlaying := true
	}
	oAcc := Acc_Get("Object", PathObj, 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)	
return	

; Ctrl+Alt+Space: Piano-Roll record while playing
PianoRoll-Record-While-Playing:
	WinActivate, ahk_exe lmms.exe
	WinGet, hWnd, ID, A
	if IsPlaying 
	{
		PathObj := "4.1.1.2.1.7.1.2.5" ; --> this is the Piano-Roll Stop-Button Id. 
		IsPlaying := false
	}
	else
	{
		PathObj := "4.1.1.2.1.7.1.2.4" ; --> this is the Piano-Roll Record while Playing Button Id
		IsPlaying := true
	}
	oAcc := Acc_Get("Object", PathObj, 0, "ahk_id " hWnd)
	oAcc.accDoDefaultAction(0)
return

; Ctrl+Alt+p: Song-Editor Stop
SongEditor-Stop:
	WinActivate, ahk_exe lmms.exe
	WinGet, hWnd, ID, A
	PathObj := "4.1.1.2.1.8.1.2.3" ; --> this is the Song-Editor Stop-Button Id
	IsPlaying := false
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
	if (WinObjPos == "x0 y0 w0 h0")
		return
	StringSplit, PosXY, WinObjPos, %A_Space%
	PosX := SubStr(PosXY1, 2) + 10
	PosY := SubStr(PosXY2, 2) + 10
	Click, %PosX% %PosY%
	; return focus and mouse to original state
	if (IsObject(acc_window_focus))
		acc_window_focus.accDoDefaultAction(0)
	MouseMove, MouseX, MouseY
return

; Ctrl+Alt+v: LMMS: hide/show all visible VST (only works when Plugin embedding option is set to "no embedding")
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




