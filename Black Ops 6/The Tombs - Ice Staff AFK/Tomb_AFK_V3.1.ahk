#Persistent

;Emergency Save Script - Alt F4 upon bleedout

SetTimer, CheckPixelColor, 100  ; Check every 100ms

CheckPixelColor:
    MouseGetPos, mouseX, mouseY  ; Get current mouse position
    PixelGetColor, color, 1236, 1009, RGB  ; Get color at X:1236, Y:1009
	
	;2560x1600 Resolution if needed, replace line 8 if wanna use this.
	;PixelGetColor, color, 1267, 1128, RGB  ; Get color at X:1267, Y:1128
	
	;1920x1080 Resolution if needed, replace line 8 if wanna use this.
	;PixelGetColor, color, 969, 783, RGB  ; Get color at X:969, Y:783
    
    ; Format the color into a more readable hex format (remove the leading 0x)
    StringTrimLeft, color, color, 2
    
    ; Check if the color matches the target color (#Eb4442)
    if (color = "Eb4442")
    {
        Send, !{F4}  ; Send ALT+F4 to close the window
		sleep 1000
        ExitApp  ; Exit the script after sending the keystroke
    }
	
    ; Check if the color matches the target color (#ff6e69)
    if (color = "ff6e69")
    {
        Send, !{F4}  ; Send ALT+F4 to close the window
		sleep 1000
        ExitApp  ; Exit the script after sending the keystroke
    }
	
    ; Check if the color matches the target color (#ff706a)
    if (color = "ff706a")
    {
        Send, !{F4}  ; Send ALT+F4 to close the window
		sleep 1000
        ExitApp  ; Exit the script after sending the keystroke
    }
	
	; Check if the color matches the target color (#FF6F6A)
    if (color = "FF6F6A")
    {
        Send, !{F4}  ; Send ALT+F4 to close the window
		sleep 1000
        ExitApp  ; Exit the script after sending the keystroke
    }
	
	; Check if the color matches the target color (#FF6D6A)
    if (color = "FF6D6A")
    {
        Send, !{F4}  ; Send ALT+F4 to close the window
		sleep 1000
        ExitApp  ; Exit the script after sending the keystroke
    }
return
#MaxThreadsPerHotkey 3


;Main Script Starts Below

F5::  
#MaxThreadsPerHotkey 1
if KeeploopRunning  
{
    KeeploopRunning := false  
    return  
}
; Otherwise:
KeeploopRunning := true
Loop
{
		
        ; First Shot & Apply Armor
        Send, {LButton Down}
		Sleep 500
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
		Sleep 500
		Send, {G}
        Sleep, 2000
        Send, {LButton Up}
        Sleep, 100
        Send, {R}
		Send, {W Down}
		Send, {A Down}
		sleep 200
		Sleep, 2300
		Send, {W Up}
		Send, {A Up}
		
		; Energy Mine & Walk Forward + Right
		Send, {W Down}
		Send, {D Down}
		Send, {X}
		sleep 300
		Send, {W Up}
		Send, {D Up}
           
    if not KeeploopRunning  
        break  
}
KeeploopRunning := false  
return
F6::ExitApp