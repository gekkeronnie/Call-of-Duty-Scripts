#Persistent

; Emergency Save Script - Alt+F4 upon detecting specific colors
SetTimer, CheckPixelColor, 100  ; Check every 100ms

CheckPixelColor:
    ; Get current screen resolution
    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight

    ; Define pixel position as a percentage of screen size
    percentX := 1236 / 2560  ; Reference resolution: 2560x1600
    percentY := 1009 / 1600

    ; Calculate dynamic position based on current resolution
    posX := Round(screenWidth * percentX)
    posY := Round(screenHeight * percentY)

    ; Get color at calculated position
    PixelGetColor, color, %posX%, %posY%, RGB

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
