SendMode,Input
; ----------------------------------------------------------------------------
; Photoshop
;-----------------------------------------------------------------------------
Hotkey, IfWinActive, ahk_exe Photoshop.exe
Hotkey, %globalHotkey%, PhotoshopCallback

PhotoshopCallback()
{
    IfWinNotActive, ahk_class #32770
    {
        return
    }

    global currentPath
    global changeLocationFunctionName

    changeLocationFunctionName := "openFolderPhotoshop"

    ; for file opening
    currentPath := Acc_Get("Name","4.16.4.1.4.5.4.1.4.1.4.1",0, "ahk_exe Photoshop.exe")

    ; for file saving
    if !currentPath
    {
        currentPath := Acc_Get("Name","4.13.4.1.4.5.4.1.4.1.4.1",0, "ahk_exe Photoshop.exe")

    }
    currentPath := RegExReplace(currentPath, "^.*?: ", "")
    showMenu(currentPath)

    return
}


openFolderPhotoshop(path)
{
    tmp = %clipboard%
    clipboard = %path%
    acc := Acc_Get("Object","4.16.4.1.4.5.4.1.4",0, "ahk_exe Photoshop.exe")
    if !acc
    {
        currentPath := Acc_Get("Name","4.13.4.1.4.5.4.1.4",0, "ahk_exe Photoshop.exe")

    }
    acc.accDoDefaultAction(0)
    acc.accSelect(0x1,0)
    SetControlDelay, 0
    Send !d
    Send ^v
    Send {Enter}

    return
}
