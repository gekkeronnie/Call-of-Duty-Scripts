#Persistent
#MaxThreadsPerHotkey 1

F5::
if KeeploopRunning
{
    KeeploopRunning := false
    return
}

; Otherwise, start the loop
KeeploopRunning := true

Loop
{
    ; Check if cod.exe is running, exit if not
    if !ProcessExist("cod.exe")
    {
        MsgBox, Call of Duty is not running. Exiting script.
        ExitApp
    }

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

    ; Stop the loop if the toggle is turned off
    if not KeeploopRunning
        break
}

KeeploopRunning := false
return

F6::ExitApp

; Function to check if process exists
ProcessExist(ProcessName)
{
    Process, Exist, %ProcessName%
    return ErrorLevel
}