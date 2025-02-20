#Persistent

; Emergency Save Script - Alt F4 upon bleedout
SetTimer, CheckPixelColor, 100  ; Check every 100ms

CheckPixelColor:
    ; Get screen resolution
    SysGet, screenWidth, 78
    SysGet, screenHeight, 79
    
    ; Recalculate X and Y based on your new reference
    targetX := Floor(screenWidth * (1234 / 2560))  ; Convert from your reference resolution (e.g., 2560px width)
    targetY := Floor(screenHeight * (1010 / 1600)) ; Convert from your reference resolution (e.g., 1600px height)
    
    ; Get the pixel color at the calculated position
    PixelGetColor, color, %targetX%, %targetY%, RGB
    
    ; Format color into hex format (remove "0x")
    StringTrimLeft, color, color, 2
    
    ; Define target colors with slight tolerance
    targetColors := ["EB4442", "FF6E69", "FF706A", "FF6F6A", "FF6D6A", "FF6E6A"]

    for index, targetColor in targetColors
    {
        if (CheckColorTolerance(color, targetColor, 10))  ; 10 tolerance for slight color variations
        {
            Send, !{F4}  ; Send ALT+F4 to close the window
            Sleep, 1000
            ExitApp  ; Exit the script after sending the keystroke
        }
    }
return

; Function to compare two colors with slight tolerance
CheckColorTolerance(color1, color2, tolerance)
{
    r1 := "0x" . SubStr(color1, 1, 2)
    g1 := "0x" . SubStr(color1, 3, 2)
    b1 := "0x" . SubStr(color1, 5, 2)

    r2 := "0x" . SubStr(color2, 1, 2)
    g2 := "0x" . SubStr(color2, 3, 2)
    b2 := "0x" . SubStr(color2, 5, 2)

    return (Abs(r1 - r2) <= tolerance && Abs(g1 - g2) <= tolerance && Abs(b1 - b2) <= tolerance)
}

; Debug Mode - Press F8 to check pixel color
F8::
    SysGet, screenWidth, 78
    SysGet, screenHeight, 79
    targetX := Floor(screenWidth * (1234 / 2560))
    targetY := Floor(screenHeight * (1010 / 1600))

    PixelGetColor, color, %targetX%, %targetY%, RGB
    StringTrimLeft, color, color, 2
    MsgBox, Current Pixel Color at (%targetX%, %targetY%) is %color%
return

F7::ExitApp
