#SingleInstance Force
global	Border := new Outline, Stored:={}, Acc, ChildId, TVobj, Win:={}

^!r::Reload  ; Ctrl+Alt+R

#w::
	global Whwnd
	;Gui Acc: Default
	;static ShowButtonEnabled
	MouseGetPos, , , Whwnd
	GuiControlGet, SectionLabel, , WinCtrl
	Acc := Acc_ObjectFromPoint(ChildId)
	Location := GetAccLocation(Acc, ChildId)
	Hwnd := Acc_WindowFromObject(Acc)
	
	WinGet, proc, ProcessName, ahk_id %Hwnd%
	WinGet, procid, PID, ahk_id %Hwnd%
	
	;Gui Main: Default
	Location := GetAccLocation(Acc, ChildId, x,y,w,h)
	;MsgBox, %x%, "-",%y%,"-",%w%,"-",%h%
	MsgBox, % Acc.accName(ChildId) 
	
	;MsgBox, % Acc_Query(Acc)
	
	;MsgBox, % (DllCall("GetParent", Uint,Acc_WindowFromObject(Acc))? "Control":"Window") " Info"
	;GuiControlGet, AccName, % Acc.accName(ChildId)
	
	;UpdateAccInfo(Acc, ChildId)
	
	;MsgBox, "Process Name: ", %proc%, " Id: ", %procid%, " ChildName: ", %AccName%
return

#s::
; try to show all the objects in screen up to "ventana"
	;Acc := Acc_ObjectFromWindow(hWnd)
	;Acc := Acc_ObjectFromWindow(Acc)
	global Whwnd
	MouseGetPos, , , Whwnd
	GuiControlGet, SectionLabel, , WinCtrl
	Acc := Acc_ObjectFromPoint(ChildId)
	Location := GetAccLocation(Acc, ChildId)
	Whwnd := Acc_WindowFromObject(Acc)
	
	BuildTreeView()
	
	MsgBox, % TVobj[0].obj
	;r := GetAccPath(Acc)
	;Child_Path:=r.Path
	;MsgBox, % Child_Path
return

BuildTreeView()
{
	r := GetAccPath(Acc)
	AccObj:=r.AccObj, Child_Path:=r.Path, r:=""
;	Gui Acc: Default
	TV_Delete()
;	GuiControl, -Redraw, TView
	parent := TV_Add(Acc_Role(AccObj), "", "Bold Expand")
	TVobj := {(parent): {is_obj:true, obj:AccObj, need_children:false, childid:0, Children:[]}}
	Loop Parse, Child_Path, .
	{
		if A_LoopField is not Digit
			TVobj[parent].Obj_Path := Trim(TVobj[parent].Obj_Path "," A_LoopField, ",")
		else {
			StoreParent := parent
			parent := TV_BuildAccChildren(AccObj, parent, "", A_LoopField)
			TVobj[parent].need_children := false
			TV_Expanded(StoreParent)
			TV_Modify(parent,"Expand")
			AccObj := TVobj[parent].obj
		}
	}
	if Not ChildId {
		TV_BuildAccChildren(AccObj, parent)
		TV_Modify(parent, "Select")
	}
	else
		TV_BuildAccChildren(AccObj, parent, ChildId)
	TV_Expanded(parent)
;	GuiControl, +Redraw, TView
}

TV_Expanded(TVid) {
	For Each, TV_Child_ID in TVobj[TVid].Children
		if TVobj[TV_Child_ID].need_children
			TV_BuildAccChildren(TVobj[TV_Child_ID].obj, TV_Child_ID)
}
TV_BuildAccChildren(AccObj, Parent, Selected_Child="", Flag="") {
	TVobj[Parent].need_children := false
	Parent_Obj_Path := Trim(TVobj[Parent].Obj_Path, ",")
	If (ComObjType(AccObj, "Name") = "IAccessible") {
		for wach, child in Acc_Children(AccObj) {
			if Not IsObject(child) {
				added := TV_Add("[" A_Index "] " Acc_GetRoleText(AccObj.accRole(child)), Parent)
				TVobj[added] := {is_obj:false, obj:Acc, childid:child, Obj_Path:Parent_Obj_Path}
				if (child = Selected_Child)
					TV_Modify(added, "Select")
			}
			else {
				added := TV_Add("[" A_Index "] " Acc_Role(child), Parent, "bold")
				TVobj[added] := {is_obj:true, need_children:true, obj:child, childid:0, Children:[], Obj_Path:Trim(Parent_Obj_Path "," A_Index, ",")}
			}
			TVobj[Parent].Children.Insert(added)
			if (A_Index = Flag)
				Flagged_Child := added
		}
	}
	return Flagged_Child
}

GetAccPath(Acc, byref hwnd="") {
	hwnd := Acc_WindowFromObject(Acc)
	WinObj := Acc_ObjectFromWindow(hwnd)
	WinObjPos := Acc_Location(WinObj).pos
	while Acc_WindowFromObject(Parent:=Acc_Parent(Acc)) = hwnd {
		t2 := GetEnumIndex(Acc) "." t2
		if Acc_Location(Parent).pos = WinObjPos
			return {AccObj:Parent, Path:SubStr(t2,1,-1)}
		Acc := Parent
	}
	while Acc_WindowFromObject(Parent:=Acc_Parent(WinObj)) = hwnd
		t1.="P.", WinObj:=Parent
	return {AccObj:Acc, Path:t1 SubStr(t2,1,-1)}
}

GetEnumIndex(Acc, ChildId=0) {
	if Not ChildId {
		ChildPos := Acc_Location(Acc).pos
		For Each, child in Acc_Children(Acc_Parent(Acc))
			if IsObject(child) and Acc_Location(child).pos=ChildPos
				return A_Index
				;return Acc_Role(child)
	} 
	else {
		ChildPos := Acc_Location(Acc,ChildId).pos
		For Each, child in Acc_Children(Acc)
			if Not IsObject(child) and Acc_Location(Acc,child).pos=ChildPos
				return A_Index
				;return Acc_Role(child)
	}
}

GetAccLocation(AccObj, Child=0, byref x="", byref y="", byref w="", byref h="") {
	AccObj.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), Child)
	return	"x" (x:=NumGet(x,0,"int")) "  "
	.	"y" (y:=NumGet(y,0,"int")) "  "
	.	"w" (w:=NumGet(w,0,"int")) "  "
	.	"h" (h:=NumGet(h,0,"int"))
}



{ ; Acc Library
	Acc_Init()
	{
		Static	h
		If Not	h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
	}
	Acc_ObjectFromEvent(ByRef _idChild_, hWnd, idObject, idChild)
	{
		Acc_Init()
		If	DllCall("oleacc\AccessibleObjectFromEvent", "Ptr", hWnd, "UInt", idObject, "UInt", idChild, "Ptr*", pacc, "Ptr", VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0
		Return	ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")
	}
	Acc_ObjectFromPoint(ByRef _idChild_ = "", x = "", y = "")
	{
		Acc_Init()
		If	DllCall("oleacc\AccessibleObjectFromPoint", "Int64", x==""||y==""?0*DllCall("GetCursorPos","Int64*",pt)+pt:x&0xFFFFFFFF|y<<32, "Ptr*", pacc, "Ptr", VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0
		Return	ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")
	}
	Acc_ObjectFromWindow(hWnd, idObject = 0)
	{
		Acc_Init()
		If	DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
		Return	ComObjEnwrap(9,pacc,1)
	}
	Acc_WindowFromObject(pacc)
	{
		If	DllCall("oleacc\WindowFromAccessibleObject", "Ptr", IsObject(pacc)?ComObjValue(pacc):pacc, "Ptr*", hWnd)=0
		Return	hWnd
	}
	Acc_GetRoleText(nRole)
	{
		nSize := DllCall("oleacc\GetRoleText", "Uint", nRole, "Ptr", 0, "Uint", 0)
		VarSetCapacity(sRole, (A_IsUnicode?2:1)*nSize)
		DllCall("oleacc\GetRoleText", "Uint", nRole, "str", sRole, "Uint", nSize+1)
		Return	sRole
	}
	Acc_GetStateText(nState)
	{
		nSize := DllCall("oleacc\GetStateText", "Uint", nState, "Ptr", 0, "Uint", 0)
		VarSetCapacity(sState, (A_IsUnicode?2:1)*nSize)
		DllCall("oleacc\GetStateText", "Uint", nState, "str", sState, "Uint", nSize+1)
		Return	sState
	}
	Acc_Role(Acc, ChildId=0)
	{
		try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetRoleText(Acc.accRole(ChildId)):"invalid object"
	}
	Acc_State(Acc, ChildId=0)
	{
		try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetStateText(Acc.accState(ChildId)):"invalid object"
	}
	Acc_Children(Acc)
	{
		if ComObjType(Acc,"Name")!="IAccessible"
			error_message := "Cause:`tInvalid IAccessible Object`n`n"
		else
		{
			Acc_Init()
			cChildren:=Acc.accChildCount, Children:=[]
			if DllCall("oleacc\AccessibleChildren", "Ptr", ComObjValue(Acc), "Int", 0, "Int", cChildren, "Ptr", VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*", cChildren)=0
			{
				Loop %cChildren%
					i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=3?child:Acc_Query(child)), ObjRelease(child)
			return Children
			}
		}
		error:=Exception("",-1)
		MsgBox, 262148, Acc_Children Failed, % (error_message?error_message:"") "File:`t" (error.file==A_ScriptFullPath?A_ScriptName:error.file) "`nLine:`t" error.line "`n`nContinue Script?"
		IfMsgBox, No
			ExitApp
	}
	Acc_Location(Acc, ChildId=0)
	{
		try Acc.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
		catch
		return
		return	{x:NumGet(x,0,"int"), y:NumGet(y,0,"int"), w:NumGet(w,0,"int"), h:NumGet(h,0,"int")
		,	pos:"x" NumGet(x,0,"int")" y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")}
	}
	Acc_Parent(Acc)
	{
		try parent:=Acc.accParent
		return parent?Acc_Query(parent):
	}
	Acc_Child(Acc, ChildId=0)
	{
		try child:=Acc.accChild(ChildId)
		return child?Acc_Query(child):
	}
	Acc_Query(Acc)
	{
		try return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
	}
}
