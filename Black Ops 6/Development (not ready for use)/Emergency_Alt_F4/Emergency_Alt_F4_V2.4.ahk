#Persistent
CoordMode, Pixel, Screen  ; Ensure coordinates are absolute
SetTimer, CheckPixelColor, 100  ; Check every 100ms

CheckPixelColor:
    ; Get screen resolution
    SysGet, screenWidth, 78
    SysGet, screenHeight, 79

    ; Adjust for DPI scaling
    dpi := 1
    if (A_OSVersion >= "WIN_10")  ; Only needed for Windows 10+
        dpi := DllCall("GetDpiForSystem") / 96.0  ; 96 DPI is default

    ; Calculate pixel position dynamically
    targetX := Floor((1234 / 2560) * screenWidth / dpi)
    targetY := Floor((1010 / 1600) * screenHeight / dpi)

    ; Get the pixel color at the calculated position
    PixelGetColor, color, %targetX%, %targetY%, RGB
    color := SubStr(color, 3)  ; Trim "0x"

    ; Define target colors with slight tolerance
    targetColors := ["EB4442", "FF6E69", "FF706A", "FF6F6A", "FF6D6A"]

    for index, targetColor in targetColors
    {
        if (CheckColorTolerance(color, targetColor, 15))  ; Increase tolerance if needed
        {
            Send, !{F4}  ; Send ALT+F4 to close the window
            Sleep, 1000
            ExitApp
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

    dpi := 1
    if (A_OSVersion >= "WIN_10")
        dpi := DllCall("GetDpiForSystem") / 96.0

    targetX := Floor((1234 / 2560) * screenWidth / dpi)
    targetY := Floor((1010 / 1600) * screenHeight / dpi)

    PixelGetColor, color, %targetX%, %targetY%, RGB
    color := SubStr(color, 3)
    MsgBox, Current Pixel Color at (%targetX%, %targetY%) is %color%
return

F7::ExitApp