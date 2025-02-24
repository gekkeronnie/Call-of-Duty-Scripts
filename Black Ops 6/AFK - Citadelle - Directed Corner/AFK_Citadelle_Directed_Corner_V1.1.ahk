#Persistent

; Image URLs & Paths (Use raw URLs for GitHub images)
imageURLs1 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/save_and_quit.png"
imageURLs2 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/save.png"
imageURLs3 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/select_mission.png"
imageURLs4 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/save_file.png"
imageURLs5 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/citadelle.png"

imagePaths1 := A_Temp . "\save_and_quit.png"
imagePaths2 := A_Temp . "\save.png"
imagePaths3 := A_Temp . "\select_mission.png"
imagePaths4 := A_Temp . "\save_file.png"
imagePaths5 := A_Temp . "\citadelle.png"

; Download the images if they don’t exist
Loop, 5
{
    ; Checking each individual image path
    currentImagePath := imagePaths%A_Index%
    currentImageURL := imageURLs%A_Index%

    if !FileExist(currentImagePath)
    {
        ; Download the image to the temporary location
        URLDownloadToFile, % currentImageURL, % currentImagePath
        Sleep, 500  ; Wait for the file to save

        ; Check if the image file exists
        if !FileExist(currentImagePath)
        {
            MsgBox, 16, Error, The required image %A_Index% could not be downloaded. The URL might be incorrect or there may be an internet issue.
            ExitApp  ; Exit if any download fails
        }
    }
}

; Declare a variable to track the first run
started := false

; Hotkey to start the loop manually the first time (F5)
F5::
    ; Only start manually if it's the first time
    if (!started)
    {
        started := true  ; Mark the first run as started
        SetTimer, CheckScreen, 500  ; Start the loop after hotkey press
    }
Return

CheckScreen:
    ; Hold left mouse button for 5 hours (18,000,000 milliseconds)
    Click, Down
    Sleep, 18000000  ; 5 hours (for testing, reduce sleep time)
    Click, Up

    sleep, 1000 ; Wait for 1 second before starting the restart process

    ; After holding the mouse, press Escape and wait for 3 seconds
    Send, {Esc}  ; Press Escape
    Sleep, 3000  ; Wait for 3 seconds before starting the search

    ; Process image 1
    currentImagePath := imagePaths1
    ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
    if (ErrorLevel = 0)
    {
        ; Click the found position
        Click, %FoundX%, %FoundY%  ; Click at the found position
        Sleep, 3000  ; Wait 3 seconds after clicking image 1

        ; Process image 2
        currentImagePath := imagePaths2
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
        if (ErrorLevel = 0)
        {
            ; Click the found position
            Click, %FoundX%, %FoundY%  ; Click at the found position
            Sleep, 3000  ; Wait 3 seconds after clicking image 2

            ; Wait for 30 seconds after image 2 and then press Escape
            Sleep, 30000  ; 30 seconds
            Send, {Esc}   ; Press Escape
            Sleep, 3000   ; Wait for 3 seconds before moving to next image
        }

        ; Process image 3
        currentImagePath := imagePaths3
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
        if (ErrorLevel = 0)
        {
            ; Click the found position
            Click, %FoundX%, %FoundY%  ; Click at the found position
            Sleep, 3000  ; Wait 3 seconds after clicking image 3
        }

        ; Process image 4
        currentImagePath := imagePaths4
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
        if (ErrorLevel = 0)
        {
            ; Click the found position
            Click, %FoundX%, %FoundY%  ; Click at the found position
            Sleep, 3000  ; Wait 3 seconds after clicking image 4
        }

        ; Process image 5
        currentImagePath := imagePaths5
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
        if (ErrorLevel = 0)
        {
            ; Click the found position
            Click, %FoundX%, %FoundY%  ; Click at the found position
            Sleep, 60000  ; Wait 3 seconds after clicking image 5
        }

        ; Restart process (loop)
        Return
    }
    else
    {
        ; If the first image is not found, press Escape, hold mouse, and retry
        Send, {Esc}  ; Press Escape
        Sleep, 1000  ; Wait 1 second before continuing
        Click, Down   ; Hold left mouse button
        Sleep, 10000  ; Hold for 10 seconds
        Click, Up     ; Release mouse button
        Sleep, 1000   ; Wait 1 second before retrying the search

        ; Restart the search for image 1
        SetTimer, CheckScreen, -500  ; Restart the CheckScreen timer immediately
    }
Return

; Hotkey to exit the script (F6)
F6::ExitApp  ; Press F6 to exit script
