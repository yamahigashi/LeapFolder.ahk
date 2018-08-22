SendMode,Input
#Include Acc.ahk
; ----------------------------------------------------------------------------
; Firefox
;-----------------------------------------------------------------------------
Hotkey, IfWinActive, ahk_exe firefox.exe
Hotkey, %globalHotkey%, FirefoxCallback

; #If (WinActive("ahk_class #32770") && WinActive("ahk_exe firefox.exe"))
; ^J::
FirefoxCallback()
{
    changeLocationFunctionName := "openFolderFirefox"
    currentPath := Acc_Get("Name","4,15,4,1,4,5,4,1,4,3,4,1,4",0, "ahk_exe firefox.exe") ;test = Application
    showMenu(currentPath)

    return
}
; #If


openFolderFirefox(path)
{
    tmp = %clipboard%
    clipboard = %path%
    acc := Acc_Get("Object","4,15,4,1,4,5,4,1,4,3,4,1,4,1,4",0, "ahk_exe firefox.exe")
    acc.accDoDefaultAction(0) ; Set Focus
    SetControlDelay, 0
    ControlSend,, ^a
    ControlSend,, ^a
    ControlSend,, ^a
    ControlSend,, {Del}
    ControlSend,, ^a
    ControlSend,, {Del}
    ControlSend,, ^a
    ControlSend,, {Del}
    ControlSend,, ^a
    ControlSend,, {Del}
    ControlSend,, ^v
    ControlSend,, {Enter} ; Select All
    ; Control, EditPaste, "test"
    ; PostMessage, 0xc, 0, "test"
    ; clipboard = %tmp%
    return
}
