SendMode,Input
; ----------------------------------------------------------------------------
; MotionBuilder
;-----------------------------------------------------------------------------
Hotkey, IfWinActive, ahk_exe motionbuilder.exe
Hotkey, %globalHotkey%, MotionBuilderCallback


MotionBuilderCallback()
{
    IfWinNotActive, ahk_class #32770
    {
        return
    }

    global currentPath
    global changeLocationFunctionName

    acc := Acc_Get("Object","4.1",0, "ahk_exe motionbuilder.exe")
    acc.accSelect(0x1,0)
    acc.accDoDefaultAction(0) ; Set Focus
    Sleep, 10

    changeLocationFunctionName := "openFolderMobu"
    acc := Acc_Get("Object","4.2.4.3.4",0, "ahk_exe motionbuilder.exe") ;test = Application
    acc.accSelect(0x1,0)
    Sleep, 10

    i := 0
    res := ""

    inDriveFirst := -100
    inDrive := false
    toBreak := false

    Loop % acc.accChildCount
    {
        name := acc.accName(i)
        driveRootMatch := RegExMatch(name, "\([A-Z]:\)")

        if ((driveRootMatch != 0) && (toBreak = false))
        {
            res := SubStr(name, driveRootMatch + 1, 2)
            inDriveFirst := A_Index 
            inDrive := false
        }
        else if (driveRootMatch != 0) && toBreak = true
        {
            Break
        }
        else if ((inDriveFirst + 1) = A_Index)
        {
            inDrive := true
            toBreak := true
        }
        else if (inDrive = true)
        {
        }
        else 
        {
            inDriveFirst := -25
        }

        if (inDrive)
            res := res . "`\" . name

        i += 1
    }

    currentFolderName := Acc_Get("Value","4.2.4",0, "ahk_exe motionbuilder.exe")
    resHasTrailingFolderName := RegExMatch(res, "`\" . currentFolderName . "$")
    if (resHasTrailingFolderName = 0)
    {
        res := res . "`\" . currentFolderName
    }

    acc := Acc_Get("Object","4.1",0, "ahk_exe motionbuilder.exe")
    acc.accSelect(0x1,0)
    acc.accDoDefaultAction(0) ; Set Focus
    Sleep, 10

    currentPath := res
    showMenu(currentPath)

    return
}


openFolderMobu(path)
{

    tmp = %clipboard%
    clipboard = %path%
    acc := Acc_Get("Object","4.9.4.1.4.1.4",0, "ahk_exe motionbuilder.exe")
    acc.accSelect(0x1,0)
    Sleep, 10

    Send !n
    Send ^v
    Sleep, 10
    Send {Enter}
    ; clipboard = %tmp%

    return
}
