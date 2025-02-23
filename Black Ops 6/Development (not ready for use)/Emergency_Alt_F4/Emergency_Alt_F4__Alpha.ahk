#Persistent
SetTimer, CheckScreen, 500  ; Check every 500ms
Return

CheckScreen:
    ; Define new dynamic search region
    centerX := A_ScreenWidth * 0.5
    centerY := A_ScreenHeight * 0.5

    x1 := centerX - (A_ScreenWidth * 0.1)  ; 10% left of center
    y1 := centerY  ; Start from center (no upward scanning)
    x2 := centerX + (A_ScreenWidth * 0.1)  ; 10% right of center
    y2 := centerY + (A_ScreenHeight * 0.3)  ; 20% down from center

    ; Image URL
    imageURL := "https://example.com/downed.png"
    imagePath := A_Temp "\downed.png"

    ; Download the image if it doesn’t exist
    If !FileExist(imagePath)
    {
        URLDownloadToFile, %imageURL%, %imagePath%
    }

    ; Search for the downed indicator within the new area
    ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, *10 %imagePath%
    if (ErrorLevel = 0)
    {
        Send, !{F4}  ; Sends Alt+F4
        ExitApp      ; Exit the script after closing the application
    }
Return
