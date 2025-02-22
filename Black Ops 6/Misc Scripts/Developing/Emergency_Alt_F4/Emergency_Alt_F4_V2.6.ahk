#Persistent
SetTimer, CheckPixelColor, 100
CoordMode, Pixel, Screen

CheckPixelColor:
    SysGet, screenWidth, 0
    SysGet, screenHeight, 1
    
    boxWidth := screenWidth * 0.25 * 0.194
    boxHeight := screenHeight * 0.25 * 0.59
    
    boxX := (screenWidth - boxWidth) // 2 - 60
    boxY := screenHeight // 2
    
    targetColors := ["EB4442", "FF6E69", "FF706A", "FF6F6A", "FF6D6A"]
    for index, targetColor in targetColors
    {
        PixelSearch, Px, Py, boxX, boxY, boxX + boxWidth, boxY + boxHeight, 0x%targetColor%, 0, Fast RGB
        if !ErrorLevel
        {
            ; Ensure the detected color is within the specified area
            if (Px >= boxX && Px <= boxX + boxWidth && Py >= boxY && Py <= boxY + boxHeight)
            {
                MsgBox, Color detected: %targetColor% at (%Px%, %Py%)
                Sleep, 1000
                ; Send, {Alt down}{F4 down}
                ; Sleep, 50
                ; Send, {F4 up}{Alt up}
                ; ExitApp
            }
        }
    }
return

F7::ExitApp