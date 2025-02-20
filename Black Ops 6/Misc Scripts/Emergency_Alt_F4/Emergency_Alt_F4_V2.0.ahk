#Persistent

; Emergency Save Script - Alt F4 upon bleedout
SetTimer, CheckPixelColor, 100  ; Check every 100ms

CheckPixelColor:
    ; Get screen resolution
    SysGet, screenWidth, 78
    SysGet, screenHeight, 79
    
    ; Calculate the pixel position based on a percentage of the screen size
    targetX := Floor(screenWidth * 0.1928)  ; 19.28% of screen width
    targetY := Floor(screenHeight * 0.4685) ; 46.85% of screen height
    
    ; Get the pixel color at the calculated position
    PixelGetColor, color, %targetX%, %targetY%, RGB
    
    ; Format the color into a more readable hex format (remove the leading 0x)
    StringTrimLeft, color, color, 2
    
    ; Define target colors
    targetColors := ["EB4442", "FF6E69", "FF706A", "FF6F6A", "FF6D6A", "FF6E6A"]
    
    ; Check if the detected color matches any target color
    for index, targetColor in targetColors
    {
        if (color = targetColor)
        {
            Send, !{F4}  ; Send ALT+F4 to close the window
            Sleep, 1000
            ExitApp  ; Exit the script after sending the keystroke
        }
    }
return

#MaxThreadsPerHotkey 3

F7::ExitApp