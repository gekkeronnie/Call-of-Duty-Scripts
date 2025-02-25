#Persistent

; Image URL & Path
imageURL := "https://github.com/gekkeronnie/Call-of-Duty-Scripts/blob/main/Black%20Ops%206/Sources/Images/downed.png"
imagePath := A_Temp . "\downed.png"

; Download the image if it doesn’t exist (BEFORE the loop)
If !FileExist(imagePath)
{
    URLDownloadToFile, %imageURL%, %imagePath%
    Sleep, 500  ; Give time for the file to save

    If !FileExist(imagePath)
    {
        MsgBox, 16, Error, The required image could not be downloaded. Check the URL or internet connection.
        ExitApp  ; Exit if the download failed
    }
    else
    {
        MsgBox, 64, Success, Required image downloaded: %imagePath%
    }
}

; Start the loop AFTER image handling is done
SetTimer, CheckScreen, 500  
Return

CheckScreen:
    ; Define search region dynamically
    centerX := A_ScreenWidth * 0.5
    centerY := A_ScreenHeight * 0.5

    x1 := centerX - (A_ScreenWidth * 0.1)
    y1 := centerY
    x2 := centerX + (A_ScreenWidth * 0.1)
    y2 := centerY + (A_ScreenHeight * 0.3)

    ; Search for the downed indicator
    ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, *10 %imagePath%
    if (ErrorLevel = 0)
    {
        Send, !{F4}  ; Sends Alt+F4
        ExitApp      ; Exit after closing
    }
Return

F7::ExitApp
