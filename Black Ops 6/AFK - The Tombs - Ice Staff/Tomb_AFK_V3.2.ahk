#Persistent
#MaxThreadsPerHotkey 1

F5::
SetTimer, CheckGameRunning, 5000 ; Check every 5 seconds if cod.exe is still running
GameLoop()
return

F6::
ExitApp

GameLoop()
{
    While ProcessExist("cod.exe") ; Run only if the game is open
    {
        ; First Shot & Apply Armor
        Send, {LButton Down}
        Sleep, 500
        Send, {G}
        Sleep, 2000
        Send, {LButton Up}
        Sleep, 100

        ; Energy Mine
        Send, {X}
        Sleep, 2000

        ; Second Shot
        Send, {LButton Down}
        Sleep, 2500
        Send, {LButton Up}
        Sleep, 100

        ; Energy Mine
        Send, {X}
        Sleep, 2000

        ; Shoot, Apply Armor, Reload & Walk Forward + Left
        Send, {LButton Down}
        Sleep, 500
        Send, {G}
        Sleep, 2000
        Send, {LButton Up}
        Sleep, 100
        Send, {R}
        Send, {W Down}
        Send, {A Down}
        Sleep, 2300
        Send, {W Up}
        Send, {A Up}

        ; Energy Mine & Walk Forward + Right
        Send, {W Down}
        Send, {D Down}
        Send, {X}
        Sleep, 300
        Send, {W Up}
        Send, {D Up}
    }

    ; If game closes, exit script
    MsgBox, Call of Duty is not running. Exiting script.
    ExitApp
}

CheckGameRunning()
{
    if !ProcessExist("cod.exe")
    {
        MsgBox, Call of Duty is not running. Exiting script.
        ExitApp
    }
}

; Function to check if process exists
ProcessExist(ProcessName)
{
    Process, Exist, %ProcessName%
    return ErrorLevel
}