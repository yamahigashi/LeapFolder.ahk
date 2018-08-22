SendMode,Input
; ----------------------------------------------------------------------------
; Maya 2017
;-----------------------------------------------------------------------------
Hotkey, IfWinActive, ahk_exe maya.exe
Hotkey, %globalHotkey%, Maya2017Callback

Maya2017Callback()
{
    IfWinNotActive, ahk_class Qt5QWindowIcon
    {
        return
    }

    global currentPath
    global changeLocationFunctionName

    changeLocationFunctionName := "openFolderMaya"
    currentPath := Acc_Get("Name","4.2.1.1",0, "ahk_exe maya.exe") ;test = Application
    showMenu(currentPath)

    return
}


openFolderMaya(path)
{
    tmp = %clipboard%
    clipboard = %path%
    acc := Acc_Get("Object","4.2.2",0, "ahk_exe maya.exe")
    acc.accDoDefaultAction(0) ; Set Focus
    SetControlDelay, 0

    Send ^a
    Send ^v
    Sleep, 10
    Send ^a
    Send ^v
    Sleep, 10
    Send {Enter}
    ; Control, EditPaste, "test"
    ; PostMessage, 0xc, 0, "test"
    ; clipboard = %tmp%
    return
}
