#Persistent  ; Keep the script running

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
    ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, *5 %imagePath%
    if (ErrorLevel = 0)
    {
        ExitApp  ; Exit after displaying message
    }
Return



F5::  ; Press F5 to start the macro
Loop
{
    ; Check if cod.exe is running
    Process, Exist, cod.exe
    if (ErrorLevel = 0)
    {
        MsgBox, The process cod.exe is not running. The script will now exit.
        ExitApp
    }
    
    Send, {e down}
    Sleep, 5000
    Send, {1}
    Sleep, 100
    Send, {e up}

    Sleep, 500
    Send, {g down}  
    Sleep, 100           
    Send, {g up}   

    Send, {g down}  
    Sleep, 100           
    Send, {g up}
    Sleep, 700

    Send, {x down}  
    Sleep, 100           
    Send, {x up}  

    Sleep, 2500
} 
return

F6::  ; Execute this part only once
Click, Left, Down
Sleep, 600
Send, {x Down}
Sleep, 100
Send, {x Up}
Sleep, 3000
Click, Left, Up
Sleep, 3000
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {w Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Sleep, 1703
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Click, Left, Down
Sleep, 110
Click, Left, Up
Return

F7::ExitApp  ; Press F7 to exit the script
