#Persistent

; Emergency Save Script - Alt F4 upon bleedout
SetTimer, CheckPixelColor, 100  ; Check every 100ms

CheckPixelColor:
    ; Get screen resolution
    SysGet, screenWidth, 78
    SysGet, screenHeight, 79
    
    ; Define the scan area (25% of the screen, centered)
    boxWidth := screenWidth * 0.25
    boxHeight := screenHeight * 0.25
    startX := (screenWidth - boxWidth) / 2
    startY := (screenHeight - boxHeight) / 2
    
    ; Create a transparent GUI with the box outline
    Gui, +AlwaysOnTop +ToolWindow -Caption +E0x80000  ; Transparent background with borders
    Gui, Show, x%startX% y%startY% w%boxWidth% h%boxHeight% NoActivate, Scan Box
    
    ; Draw the scan box outline (just the borders)
    Gui, Add, Line, x0 y0 w%boxWidth% h1 cBlue  ; Top border
    Gui, Add, Line, x0 y%boxHeight% w%boxWidth% h1 cBlue  ; Bottom border
    Gui, Add, Line, x0 y0 w1 h%boxHeight% cBlue  ; Left border
    Gui, Add, Line, x%boxWidth% y0 w1 h%boxHeight% cBlue  ; Right border
    
    ; Define target colors (in BGR format)
    targetColors := ["4244EB", "69FF6E", "6AFF70", "6A6FFF", "6A6DFF", "6A6E6F"]
    
    ; Loop over the defined area
    Loop, % boxWidth
    {
        Loop, % boxHeight
        {
            xPos := startX + A_Index - 1  ; Adjust for proper x coordinate
            yPos := startY + A_Index - 1  ; Adjust for proper y coordinate
            PixelGetColor, color, %xPos%, %yPos%, RGB
            StringTrimLeft, color, color, 2  ; Trim the leading "0x" in color
            
            ; For debugging: show the color being detected
            ToolTip, Color: %color%  ; Show the current pixel color for testing
            
            ; Check if the color matches any of the target colors
            if (color in targetColors)
            {
                Send, !{F4}  ; Send ALT+F4 to close the window
                Sleep, 1000
                ExitApp  ; Exit the script
            }
        }
    }
return

#MaxThreadsPerHotkey 3

F7::ExitApp
