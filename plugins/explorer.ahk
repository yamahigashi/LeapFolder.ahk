SendMode,Input
; ----------------------------------------------------------------------------
; explorer
;-----------------------------------------------------------------------------
Hotkey, IfWinActive, ahk_class CabinetWClass
Hotkey, %globalHotkey%, ExplorerCallback
ExplorerCallback()
{
    global window
    global currentPath
    global changeLocationFunctionName

    for window in ComObjCreate("Shell.Application").Windows
    {
        currentPath := ""
        try currentPath := window.Document.Folder.Self.Path
        IfWinActive, % "ahk_id " window.HWND
            break

    }
    changeLocationFunctionName := "openFolderExplorer"
    showMenu(currentPath)

    return
}

openFolderExplorer(path)
{
    global window

    if GetKeyState("Control")
    {
        Run, explorer %path%

    }
    else
    {
        window.Navigate(path)
    }
}
