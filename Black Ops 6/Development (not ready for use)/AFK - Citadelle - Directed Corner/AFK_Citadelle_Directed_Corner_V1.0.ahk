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

        ; Check if the image file exists and is non-empty by reading the file
        if !FileExist(currentImagePath) or (FileRead, FileContent, %currentImagePath%) = 0
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
    ;;Sleep, 18000000  ; 5 hours
    sleep 1000 ; 10 seconds for testing
    Click, Up

    sleep, 1000 ; Wait for 5 seconds before start the restart process

    ; After holding the mouse, press Escape and wait for 5 seconds
    Send, {Esc}  ; Press Escape
    Sleep, 5000  ; Wait for 5 seconds before starting the search

    ; Process images
    Loop, 5
    {
        ; Dynamically assign the current image path
        currentImagePath := imagePaths%A_Index%

        ; Fix: Concatenate variables properly for ImageSearch
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *10 %currentImagePath%

        ; Show MessageBox for debugging purposes
        if (ErrorLevel = 0)
        {
            MsgBox, Image %A_Index% found at %FoundX%, %FoundY% ; Show where it was found
            Click, %FoundX%, %FoundY%
            
            ; Wait for 5 seconds for images 1, 3, 4, and 5
            if (A_Index != 2)
            {
                Sleep, 5000  ; 5-second delay
            }
        }
        else
        {
            MsgBox, Image %A_Index% not found. ; Show if the image wasn't found
        }

        ; After the 2nd image, press Escape again after 20 seconds
        if (A_Index = 2)
        {
            Sleep, 20000  ; 20-second delay
            Send, {Esc}   ; Press Escape
            Sleep, 500    ; Wait after pressing Escape
        }
    }

    ; Restart process (loop)
Return

; Hotkey to exit the script (F6)
F6::ExitApp  ; Press F6 to exit script
