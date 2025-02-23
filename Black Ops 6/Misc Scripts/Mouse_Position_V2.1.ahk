#Persistent
#SingleInstance Force
CoordMode, Mouse, Screen  ; Ensure absolute screen coordinates
CoordMode, Pixel, Screen  ; Ensure absolute screen coordinates
SetTimer, ShowMouseInfo, 100  ; Update every 100ms

ShowMouseInfo:
    ; Get screen resolution dynamically
    SysGet, screenWidth, 78
    SysGet, screenHeight, 79
    
    ; Get current mouse position
    MouseGetPos, mouseX, mouseY
    
    ; Calculate percentages based on screen resolution
    xPercent := (mouseX / screenWidth) * 100
    yPercent := (mouseY / screenHeight) * 100
    
    ; Format the percentage values to 2 decimal places
    xPercent := Format("{:.2f}", xPercent)
    yPercent := Format("{:.2f}", yPercent)
    
    ; Get pixel color at mouse position
    PixelGetColor, color, mouseX, mouseY, RGB
    StringTrimLeft, color, color, 2  ; Remove '0x' from color code
    
    ; Display the results in the tooltip
    ToolTip, Mouse Position:`nX: %mouseX% (%xPercent%`)`nY: %mouseY% (%yPercent%`)`nColor: #%color%
return

#MaxThreadsPerHotkey 3

F7::ExitApp