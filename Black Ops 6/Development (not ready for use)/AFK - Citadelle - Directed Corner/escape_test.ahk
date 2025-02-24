; Image URL & Path for Image 3 (escape.png)
imageURLs3 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/escape.png"
imagePaths3 := A_Temp . "\escape.png"

; Download Image 3 if it doesn't exist
if !FileExist(imagePaths3)  
{
    URLDownloadToFile, %imageURLs3%, %imagePaths3%
    Sleep, 1000  ; Wait for the file to save
}

; Hotkey to start the image detection (F5)
F5::
    Loop
    {
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *100 %imagePaths3%
        if (ErrorLevel = 0)
        {
            MsgBox, Image 3 found! Clicking on it now.
            Click, %FoundX%, %FoundY%
            Sleep, 500
        }
        else
        {
            MsgBox, Image 3 not found. Retrying in 3 seconds...
            Sleep, 3000
        }
    }
Return

; Hotkey to exit the script (F6)
F6::
    ExitApp
Return
