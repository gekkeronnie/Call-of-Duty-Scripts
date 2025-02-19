#Persistent
#MaxThreadsPerHotkey, 1
SetBatchLines, -1  ; Improves performance

Toggle := false

F5::
Toggle := !Toggle

if (Toggle)
{
    if !ProcessExist("cod.exe")
    {
        MsgBox, Call of Duty is not running. Exiting script.
        ExitApp
    }

    Send, {LButton Down}  ; Hold left mouse button
    SetTimer, CheckGame, 1000  ; Check if game is still running every second
}
else
{
    SetTimer, CheckGame, Off  ; Stop checking if game is running
    Send, {LButton Up}  ; Release left mouse button
}
return

CheckGame:
if (!ProcessExist("cod.exe"))  ; Stop if the game closes
{
    MsgBox, Call of Duty is not running. Exiting script.
    ExitApp
}
return

F6::ExitApp

; Function to check if process exists
ProcessExist(ProcessName)
{
    Process, Exist, %ProcessName%
    return ErrorLevel
}
