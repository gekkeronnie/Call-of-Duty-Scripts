#Persistent

F5::  
#MaxThreadsPerHotkey 1

Loop
{
    ; Check if cod.exe is running in every loop iteration
    Process, Exist, cod.exe
    if (ErrorLevel = 0)
    {
        MsgBox, The process cod.exe is not running. The script will now exit.
        ExitApp
    }

    ; First Shot & Apply Armor
    Send, {LButton Down}
    Sleep 500
    Send, {G}
    Sleep 2000
    Send, {LButton Up}
    Sleep 100

    ; Energy Mine
    Send, {X}
    Sleep, 2000

    ; Second Shot
    Send, {LButton Down}
    Sleep, 2500
    Send, {LButton Up}
    Sleep 100

    ; Energy Mine
    Send, {X}
    Sleep, 2000

    ; Shoot, Apply Armor, Reload & Walk Forward + Left
    Send, {LButton Down}
    Sleep 500
    Send, {G}
    Sleep 2000
    Send, {LButton Up}
    Sleep 100
    Send, {R}
    Send, {W Down}
    Send, {A Down}
    Sleep 200
    Sleep, 2300
    Send, {W Up}
    Send, {A Up}

    ; Energy Mine & Walk Forward + Right
    Send, {W Down}
    Send, {D Down}
    Send, {X}
    Sleep 300
    Send, {W Up}
    Send, {D Up}
}
return

F6::ExitApp
