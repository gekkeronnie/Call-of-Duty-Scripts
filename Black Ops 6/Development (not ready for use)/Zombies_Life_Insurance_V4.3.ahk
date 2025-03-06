#Persistent

; Image URL & Path
imageURL := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/downed.png"
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
SetTimer, CheckScreen, 5000  
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
    ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, *2 %imagePath%
    if (ErrorLevel = 0)
    {
        Sleep, 1000  ; Wait 5 seconds
        
        Send, {F Down}  ; Hold "F"
        Sleep, 4500     ; Hold for 4,5 seconds
        Send, {F Up}    ; Release "F"

        Sleep, 1000     ; Wait 1 second

        Send, {Esc}     ; Press Escape
        Sleep, 1000      ; Wait 1 second
        
        Loop, 7         ; Press Down Arrow 7 times
        {
            Send, {Down}
            Sleep, 100   ; Small delay between presses
        }

        Send, {Space}   ; Press Spacebar
        Sleep, 1000      ; Wait 1 second

        Send, {Up}      ; Press Up Arrow once
        Sleep, 1000      ; Wait 1 second

        Send, {Space}   ; Press Spacebar again

        ; Display message before exiting
        MsgBox, 48, Game Over, You died, script has been terminated!

        ExitApp  ; Exit after displaying message
    }
Return

F8::ExitApp  ; New hotkey to exit script
