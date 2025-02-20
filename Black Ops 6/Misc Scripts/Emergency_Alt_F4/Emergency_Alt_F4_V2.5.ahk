#Persistent
CoordMode, Pixel, Screen  ; Ensure absolute screen coordinates
if (A_OSVersion >= "WIN_10")
    DllCall("SetProcessDPIAware")  ; Force DPI Awareness for accurate scaling
SetTimer, CheckPixelColor, 100

CheckPixelColor:
    ; Get screen resolution & DPI scaling
    SysGet, screenWidth, 78
    SysGet, screenHeight, 79
    dpi := 1
    if (A_OSVersion >= "WIN_10")
        dpi := DllCall("GetDpiForSystem") / 96.0  ; Windows DPI scaling adjustment

    ; Get Primary Monitor
    SysGet, MonitorPrimary, MonitorPrimary

    ; Dynamic pixel calculation (percentage-based)
    targetX := Floor((19.33 / 100) * screenWidth / dpi)
    targetY := Floor((46.71 / 100) * screenHeight / dpi)

    ; Get the pixel color with "Fast" mode for consistency
    PixelGetColor, color, %targetX%, %targetY%, RGB Fast
    color := SubStr(color, 3)

    ; Define target colors with increased tolerance
    targetColors := ["EB4442", "FF6E69", "FF706A", "FF6F6A", "FF6D6A"]

    for index, targetColor in targetColors
    {
        if (CheckColorTolerance(color, targetColor, 20))  ; Higher tolerance for screens
        {
            Send, !{F4}  ; ALT+F4
            Sleep, 1000
            ExitApp
        }
    }
return

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

    targetX := Floor((19.33 / 100) * screenWidth / dpi)
    targetY := Floor((46.71 / 100) * screenHeight / dpi)

    PixelGetColor, color, %targetX%, %targetY%, RGB Fast
    color := SubStr(color, 3)
    MsgBox, Current Pixel Color at (%targetX%, %targetY%) is %color%
return

F7::ExitApp
