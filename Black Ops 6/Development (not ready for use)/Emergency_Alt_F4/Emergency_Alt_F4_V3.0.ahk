#Persistent

; Emergency Save Script - Alt+F4 upon detecting specific colors
SetTimer, CheckPixelColor, 100  ; Check every 100ms

CheckPixelColor:
    ; Get current screen resolution
    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight

    ; Get DPI scaling factor (100% = 1.0, 125% = 1.25, etc.)
    dpiScaling := A_Dpi_Scale / 100

    ; Reference resolution (1920x1080)
    refWidth := 1920
    refHeight := 1080

    ; Define pixel position as a percentage of 1920x1080 (common reference resolution)
    percentX := 48.20 / 100  ; X Position percentage (48.20%)
    percentY := 63.25 / 100  ; Y Position percentage (63.25%)

    ; Adjust for DPI scaling
    posX := Round(screenWidth * percentX / dpiScaling)
    posY := Round(screenHeight * percentY / dpiScaling)

    ; Get color at calculated position (Using BGR mode for testing)
    PixelGetColor, color, %posX%, %posY%, BGR

    StringTrimLeft, color, color, 2  ; Format color to remove "0x"
    
    ; Output the color at that position for debugging
    ToolTip, Color: %color% ; Show color for debugging
    
    ; Define target colors
    targetColors := ["Eb4442", "ff6e69", "ff706a", "FF6F6A", "FF6D6A"]
    
    ; Loop through target colors and check for a match
    colorMatched := false
    for index, targetColor in targetColors
    {
        if (color = targetColor)
        {
            ToolTip, Match Found! ; Show match message for debugging
            Send, !{F4}  ; Send ALT+F4 to close the window
            Sleep, 1000
            ExitApp  ; Exit the script
        }
    }
    
    ; Hide the tooltip if no match
    ToolTip

    ; Small delay to ensure the pixel color has been retrieved correctly
    Sleep, 50  ; Adjust if needed, this gives time for pixel retrieval and screen refresh
return

F7::ExitApp  ; Press F7 to manually exit the script
