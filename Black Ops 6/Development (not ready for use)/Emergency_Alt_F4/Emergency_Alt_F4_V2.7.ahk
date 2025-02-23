#Persistent

; Emergency Save Script - Alt+F4 upon detecting specific colors
SetTimer, CheckPixelColor, 100  ; Check every 100ms

CheckPixelColor:
    MouseGetPos, mouseX, mouseY  ; Get current mouse position
    PixelGetColor, color, 1236, 1009, RGB  ; Get color at X:1236, Y:1009
    
    ; Alternative resolutions (uncomment if needed)
    ; PixelGetColor, color, 1267, 1128, RGB  ; 2560x1600 Resolution
    ; PixelGetColor, color, 969, 783, RGB  ; 1920x1080 Resolution
    
    StringTrimLeft, color, color, 2  ; Format color to remove "0x"
    
    ; Define target colors
    targetColors := ["Eb4442", "ff6e69", "ff706a", "FF6F6A", "FF6D6A"]
    
    ; Loop through target colors and check for a match
    for index, targetColor in targetColors
    {
        if (color = targetColor)
        {
            Send, !{F4}  ; Send ALT+F4 to close the window
            Sleep, 1000
            ExitApp  ; Exit the script
        }
    }
return

F7::ExitApp  ; Press F7 to manually exit the script
