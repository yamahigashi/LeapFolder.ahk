SendMode,Input
#Include Acc.ahk

;-----------------------------------------------------------------------------
; settings
; ---------------------------------------------------------------------------
DetectHiddenText, On

; global variables
currentPath := ""
changeLocationFunctionName := ""
window :=

; constancs
INI_FILENAME := "LeapFolder.ini"
configPath := A_MyDocuments . "\" . INI_FILENAME
if !FileExist(configPath)
{
    configPath := A_ScriptDir . "\" . INI_FILENAME
}

IniRead, globalHotkey, %configPath%, global, hotkey


;-----------------------------------------------------------------------------
; By software plugins
; --------------------------------------------------------------------------- 

#Include plugins\explorer.ahk
#Include plugins\maya.ahk
#Include plugins\motionbuilder.ahk
#Include plugins\photoshop.ahk
#Include plugins\firefox.ahk



; ----------------------------------------------------------------------------
; common functions
;-----------------------------------------------------------------------------
showMenu(currentPath)
{
    global INI_FILENAME

    ; ------------------------------------------------------------------------
    CoordMode,Mouse,Screen
    CoordMode,Menu,Screen
    MouseGetPos,mx,my

    WinSet,Transparent,90,wt_topMenu
    WinSet,Top,,wt_topMenu
    SysGet,x,76
    SysGet,y,77
    SysGet,w,78
    SysGet,h,79
    WinMove,wt_topMenu,,%x%,%y%,%w%,%h%

    ; ------------------------------------------------------------------------
    configPath := A_MyDocuments . "\" . INI_FILENAME
    if !FileExist(configPath)
    {
        configPath := A_ScriptDir . "\" . INI_FILENAME
    }

    ; ------------------------ construct menu --------------------------------
    entryHitCount := 0

    ; ------------------------ folder jump -----------------------------------
    Menu,Bookmark,Add,Add Current Folder,addBookmarkCallback
    Menu,Bookmark,Add,Remove Current Folder,removeBookmarkCallback
    Menu,Bookmark,Add  ; separator

    IniRead, bookmark, %configPath%, Bookmark
    Loop, parse, bookmark,`n, `r
    {
        entryHitCount += 1
        baseName := A_LoopField
        Menu,Bookmark,Add,%baseName%,chooseBookmarkCallback

    }
    if entryHitCount > 0
    {
        Menu,topMenu,Add, Bookmark, :Bookmark
        ; Menu,topMenu,Add  ; separator
    }

    ; ------------------------ search children -------------------------------
    IniRead, parents, %configPath%, SearchChildren
    Loop, parse, parents,`n, `r
    {
        baseName := A_LoopField
        IfInString, currentPath, %baseName%
        {
            entryHitCount += 1
            baseDir := RegExReplace(currentPath, baseName . "\\.*", baseName)
            Loop, %baseDir%\*, 2
            {
                Menu,%baseName%,Add,%A_LoopFileName%,chooseChildFolderCallback
            }

            Menu,topMenu,Add,%baseName%, :%baseName%
        }
    }

    ; ------------------------------------------------------------------------
    if entryHitCount > 0
    {
        Menu,topMenu,Show,%mx%,%my%
        Menu,Bookmark,DeleteAll
        Menu,topMenu,DeleteAll
    }

}


addBookmarkCallback(ItemName, ItemPos, MenuName)
{
    global INI_FILENAME
    global currentPath

    ; ------------------------------------------------------------------------
    configPath := A_MyDocuments . "\" . INI_FILENAME
    if !FileExist(configPath)
    {
        configPath := A_ScriptDir . "\" . INI_FILENAME
    }

    IniWrite, %currentPath%, %configPath%, Bookmark
}


removeBookmarkCallback(ItemName, ItemPos, MenuName)
{
    global INI_FILENAME
    global currentPath

    ; ------------------------------------------------------------------------
    configPath := A_MyDocuments . "\" . INI_FILENAME
    if !FileExist(configPath)
    {
        configPath := A_ScriptDir . "\" . INI_FILENAME
    }

    IniRead, bookmarks, %configPath%, Bookmark
    res := ""
    Loop, parse, bookmarks,`n, `r
    {
        tmp := A_LoopField
        IfNotInString, tmp, %currentPath%
        {
            res := res . tmp . "`n"
        }

    }
    IniDelete, %configPath%, Bookmark
    IniWrite, %res%, %configPath%, Bookmark
}


chooseBookmarkCallback(ItemName, ItemPos, MenuName)
{
    global changeLocationFunctionName
    changeLocationFunction := Func(changeLocationFunctionName)

    newPath := ItemName

    if FileExist(newPath)
    {
        changeLocationFunction.Call(newPath)
        return
    }

    else
    {
        tmp := ""
        dirParts := StrSplit(newPath, "\")
        Loop % dirParts.MaxIndex() - 1
        {
            tmp := ""
            revIndex := dirParts.MaxIndex() - A_Index
            Loop % revIndex
            {
                tmp .= dirParts[A_Index] . "\"
            }

            newPath := RegExReplace(tmp, "\\$", "")  ; strip trailing backslash
            if FileExist(newPath)
            {

                changeLocationFunction.Call(newPath)
                return

            }

        }
    }

    return

}


chooseChildFolderCallback(ItemName, ItemPos, MenuName)
{
    global currentPath
    global changeLocationFunctionName
    changeLocationFunction := Func(changeLocationFunctionName)

    newPath := RegExReplace(currentPath, MenuName . "\\\w+", MenuName . "\" . ItemName)

    if FileExist(newPath)
    {
        changeLocationFunction.Call(newPath)
        return
    }

    else
    {
        tmp := ""
        dirParts := StrSplit(newPath, "\")
        Loop % dirParts.MaxIndex() - 1
        {
            tmp := ""
            revIndex := dirParts.MaxIndex() - A_Index
            Loop % revIndex
            {
                tmp .= dirParts[A_Index] . "\"
            }

            newPath := RegExReplace(tmp, "\\$", "")  ; strip trailing backslash
            if FileExist(newPath)
            {

                changeLocationFunction.Call(newPath)
                return

            }

        }
    }

    return

}
