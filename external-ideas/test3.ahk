;==================================================
#SingleInstance Force

^!r::Reload  ; Ctrl+Alt+R

;===============
; ^!q::
; MouseGetPos,,, hWnd, hCtl, 2
; if !hCtl
	; hCtl := hWnd
; WinGetClass, vWinClass, % "ahk_id " hCtl
; vText := JEE_AccCtlGetText(hCtl, "`r`n")
; MsgBox, % "[" vWinClass "]`r`n" vText
; return
;===============

; de aquí https://www.autohotkey.com/boards/viewtopic.php?f=6&t=40514
^!q:: ;Notepad - get status bar text
WinGet, hWnd, ID, A
MsgBox, % Clipboard := JEE_AccGetTextAll(hWnd, "`r`n")
return

^!w:: ;Notepad - get Acc info (controls)
ControlGet, hCtl1, Hwnd,, Edit1, A
ControlGet, hCtl2, Hwnd,, msctls_statusbar321, A
MsgBox, % Clipboard := JEE_AccGetTextAll(hCtl1, "`r`n")
MsgBox, % Clipboard := JEE_AccGetTextAll(hCtl2, "`r`n")

;Edit control info is: 4
;the acc path will be 4
;and we will use 0 with accValue()
oAcc := Acc_Get("Object", "4", 0, "ahk_id " hCtl1)
MsgBox, % oAcc.accValue(0)
oAcc := ""

;status bar info is: 4 c2
;the acc path will be 4
;and we will use 2 with accName()
oAcc := Acc_Get("Object", "4", 0, "ahk_id " hCtl2)
MsgBox, % oAcc.accName(2)
oAcc := ""
return

;==================================================

JEE_StrRept(vText, vNum)
{
	if (vNum <= 0)
		return
	return StrReplace(Format("{:" vNum "}", ""), " ", vText)
	;return StrReplace(Format("{:0" vNum "}", 0), 0, vText)
}

;==================================================

; ;e.g.
; q::
; WinGet, hWnd, ID, A
; MsgBox, % Clipboard := JEE_AccGetTextAll(hWnd, "`r`n")
; return

; ;e.g.
; q::
; ControlGet, hCtl, Hwnd,, Edit1, A
; MsgBox, % Clipboard := JEE_AccGetTextAll(hCtl, "`r`n")
; return

; ;e.g.
; q::
; ControlGetFocus, vCtlClassNN, A
; ControlGet, hCtl, Hwnd,, % vCtlClassNN, A
; MsgBox, % Clipboard := JEE_AccGetTextAll(hCtl, "`r`n")
; return

;vOpt: space-separated list
;vOpt: n#: e.g. n20 ;limit retrieve name to first 20 characters
;vOpt: v#: e.g. v20 ;limit retrieve value to first 20 characters

JEE_AccGetTextAll(hWnd:=0, vSep:="`n", vIndent:="`t", vOpt:="")
{
	vLimN := 20, vLimV := 20, vLevelLim := 5
	Loop, Parse, vOpt, % " "
	{
		vTemp := A_LoopField
		if (SubStr(vTemp, 1, 1) = "n")
			vLimN := SubStr(vTemp, 2)
		else if (SubStr(vTemp, 1, 1) = "v")
			vLimV := SubStr(vTemp, 2)
	}

	oMem := {}, oPos := {}
	;OBJID_WINDOW := 0x0
	oMem[1, 1] := Acc_ObjectFromWindow(hWnd, 0x0)
	oPos[1] := 1, vLevel := 1
	VarSetCapacity(vOutput, 1000000*2)

	Loop
	{
		if !vLevel
			break
		if !oMem[vLevel].HasKey(oPos[vLevel])
		{
			oMem.Delete(vLevel)
			oPos.Delete(vLevel)
			vLevelLast := vLevel, vLevel -= 1
			oPos[vLevel]++
			continue
		}
		oKey := oMem[vLevel, oPos[vLevel]]

		vName := "", vValue := "", vRoleText := ""
		if IsObject(oKey)
		{
			vRoleText := Acc_GetRoleText(oKey.accRole(0))
			try vName := oKey.accName(0)
			try vValue := oKey.accValue(0)
		}
		else
		{
			oParent := oMem[vLevel-1,oPos[vLevel-1]]
			vChildId := IsObject(oKey) ? 0 : oPos[vLevel]
			try vRoleText := Acc_GetRoleText(oParent.accRole(vChildID))
			try vName := oParent.accName(vChildID)
			try vValue := oParent.accValue(vChildID)
		}
		if (StrLen(vName) > vLimN)
			vName := SubStr(vName, 1, vLimN) "..."
		if (StrLen(vValue) > vLimV)
			vValue := SubStr(vValue, 1, vLimV) "..."
		vName := RegExReplace(vName, "[`r`n]", " ")
		vValue := RegExReplace(vValue, "[`r`n]", " ")

		vAccPath := ""
		if IsObject(oKey)
		{
			Loop, % oPos.Length() - 1
				vAccPath .= (A_Index=1?"":".") oPos[A_Index+1]
		}
		else
		{
			Loop, % oPos.Length() - 2
				vAccPath .= (A_Index=1?"":".") oPos[A_Index+1]
			vAccPath .= " c" oPos[oPos.Length()]
		}
		Needle := "4.1.1.2"
		StringGetPos, pos, vAccPath, %Needle%
		;MsgBox, "#",%vAccPath%,"#"
		if (pos > = 0)
		{
			vOutput .= vAccPath "`t" JEE_StrRept(vIndent, vLevel-1) vRoleText " [" vName "][" vValue "]" vSep
		}

		oChildren := Acc_Children(oKey)
		if (vLevel == vLevelLim)
		{
			oPos[vLevel]++
			continue
		}
		if !oChildren.Length()
			oPos[vLevel]++
		else
		{
			vLevelLast := vLevel, vLevel += 1
			oMem[vLevel] := oChildren
			oPos[vLevel] := 1
		}
	}
	return SubStr(vOutput, 1, -StrLen(vSep))
}


;notes:
;problem - AutoHotkey Help - treeview
;problem - Explorer folders (Windows 7) - DirectUIHWND (how to invoke invert selection?)
;problem - Tools, Folder Options, View tab - treeview
;problem+ - MSTaskListWClass (taskbar), one item has error
;problem+ - WordPad (Windows XP) - toolbar (can get text from toolbar button as long as mouse over it, so move mouse as you retrieve text)
;possible to get all listview columns?
;any other roles to accept for 'if vRole in ...'? some more general criteria than a list of roles?
;possibly add option to retrieve ticked status of buttons/menu items
;add support for title bars? NCHITTEST?
;TrayTip is tooltips_class32?
;control types not considered: RICHEDIT,RichEdit20A,RichEdit20W,ComboBoxEx,DragList,ScrollBar,ReBarWindow32,msctls_trackbar32,msctls_updown32,msctls_progress32,SysAnimate32,SysMonthCal32,SysPager

;accepts hWnd/hCtl
;JEE_AccGetControlText
;JEE_AccGetCtlText
;JEE_AccControlGetText
JEE_AccCtlGetText(hWnd, vSep:="`n")
{
	WinGetClass, vWinClass, % "ahk_id " hWnd
	if vWinClass in SysTreeView32,SysListView32,SysHeader32,ListBox,ComboLBox,Static,msctls_statusbar32,ComboBox,hh_kwd_vlist,MSTaskListWClass,ToolbarWindow32,SysLink,SysTabControl32,Qt5QWindowIcon
	{
	MsgBox, 1
		oAcc := Acc_Get("Object", "4", 0, "ahk_id " hWnd)
		Loop, % oAcc.accChildCount
		{
			vRole := Acc_Role(oAcc, A_Index)
			MsgBox, %vRole%
			;if vRole in list item,outline item,text,push button,link,column header,page,ventana,Qt5QWindowIcon, tab
			;	{ 
					vOutput .= oAcc.accName(A_Index) vSep
					MsgBox, %vOutput%
			;	}
		}
		vOutput := SubStr(vOutput, 1, -StrLen(vSep))
		vRet := 1
	}
	if vWinClass in #32768
	{
		oAcc := Acc_Get("Object", "1", 0, "ahk_id " hWnd)
		Loop, % oAcc.accChildCount
			if (Acc_Role(oAcc, A_Index) = "menu item")
				vOutput .= oAcc.accName(A_Index) vSep
		vOutput := SubStr(vOutput, 1, -StrLen(vSep))
		vRet := 1
	}
	if vWinClass in Edit,SysDateTimePick32,#32769,RICHEDIT50W
	{
		oAcc := Acc_Get("Object", "4", 0, "ahk_id " hWnd)
		vOutput := oAcc.accValue, vRet := 1
	}
	if vWinClass in Button,Static,tooltips_class32
	{
		oAcc := Acc_Get("Object", "4", 0, "ahk_id " hWnd)
		vOutput := oAcc.accName, vRet := 1
	}
	if !vRet
		oAcc := Acc_ObjectFromWindow(hWnd), vOutput := oAcc.accName
	oAcc := ""
	return vOutput
}

;==================================================

;e.g. Media Player Classic, open right-click menu, click item
;q::
;vList := "View,On Top,Default"
;JEE_MenuRCSelectItem(vList)
;return

;improve Acc error handling
;JEE_MenuRightClickSelectItem
JEE_MenuRCSelectItem(vList, vDelim:=",", vPosX:="", vPosY:="", vDelay:=0)
{
	DetectHiddenWindows, Off
	CoordMode, Mouse, Screen
	MouseGetPos, vPosX2, vPosY2
	(vPosX = "") ? (vPosX := vPosX2) : 0
	(vPosY = "") ? (vPosY := vPosY2) : 0

	if !(vPosX = vPosX2) || !(vPosY = vPosY2)
		MouseMove, % vPosX, % vPosY
	Click, right

	Loop, Parse, vList, % vDelim
	{
		vTemp := A_LoopField
		WinGet, hWnd, ID, ahk_class #32768
		if !hWnd
		{
			MsgBox, error
			return
		}
		oAcc := Acc_Get("Object", "1", 0, "ahk_id " hWnd)
		Loop, % oAcc.accChildCount
			if (Acc_Role(oAcc, A_Index) = "menu item")
			&& (oAcc.accName(A_Index) = vTemp)
			{
				oRect := Acc_Location(oAcc, A_Index), vIndex := A_Index
				break
			}
		vPosX := Round(oRect.x + oRect.w/2)
		vPosY := Round(oRect.y + oRect.h/2)
		MouseMove, % vPosX, % vPosY
		Sleep, % vDelay ;optional delay
		oAcc.accDoDefaultAction(vIndex)
		WinWaitNotActive, % "ahk_id " hWnd,, 6
		if ErrorLevel
		{
			MsgBox, error
			return
		}
	}
	MouseMove, % vPosX2, % vPosY2
}

;==================================================


#include acc.ahk