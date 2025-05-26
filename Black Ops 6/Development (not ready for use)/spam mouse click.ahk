; AutoHotkey v1 script
; Press F5 to start/stop auto-clicking and spamming F key
; Press F8 to exit the script

Toggle := false

F5::
    Toggle := !Toggle
    if (Toggle) {
        SetTimer, SpamLoop, 100
    } else {
        SetTimer, SpamLoop, Off
    }
return

SpamLoop:
    Click
    Send, f
return

F8::ExitApp
