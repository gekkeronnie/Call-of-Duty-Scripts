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
    currentImagePath := imagePaths%A_Index%
    currentImageURL := imageURLs%A_Index%

    if !FileExist(currentImagePath)
    {
        URLDownloadToFile, % currentImageURL, % currentImagePath
        Sleep, 500  ; Wait for the file to save

        if !FileExist(currentImagePath)
        {
            MsgBox, 16, Error, The required image %A_Index% could not be downloaded.
            ExitApp  ; Exit if any download fails
        }
    }
}

; Declare a variable to track the first run
started := false

; Hotkey to start the loop manually the first time (F5)
F5::
    if (!started)
    {
        started := true  ; Mark the first run as started
        SetTimer, CheckCodRunning, 1000  ; Check if cod.exe is running every second
        SetTimer, CheckScreen, 500  ; Start the loop after hotkey press
    }
Return

; Function to check if cod.exe is running
CheckCodRunning:
    ; Check if cod.exe is running
    Process, Exist, cod.exe
    if (ErrorLevel = 0)
    {
        ; If cod.exe is not running, exit the script
        MsgBox, 16, Error, cod.exe is not running. Exiting the script.
        ExitApp
    }
Return

CheckScreen:
    ; Switch to Sword and Run left
    Send, {A Down}
    Send, {v Down}
    sleep 2000
    Send, {v Up}
    Send, {A Up}

    ; Hold mouse, A, and S keys for 5 hours (in reality for a short test duration)
    Click, Down  ; Hold left mouse button down
    Send, {a down}  ; Hold A to move left
    Send, {s down}  ; Hold S to move (as you wanted)

    Sleep, 18000000  ; Hold the keys and mouse for 5 hours (18 million milliseconds for testing, adjust as necessary)

    ; After 5 hours, release the mouse and keys
    Send, {a up}  ; Release A
    Send, {s up}  ; Release S
    Click, Up  ; Release the mouse button

    ; After holding the mouse, press Escape and wait for 3 seconds
    Send, {Esc}  ; Press Escape
    Sleep, 3000  ; Wait for 3 seconds before starting the search

    ; Process image 1
    currentImagePath := imagePaths1
    ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
    if (ErrorLevel = 0)
    {
        Click, %FoundX%, %FoundY%
        Sleep, 3000
    }

    ; Process image 2
    currentImagePath := imagePaths2
    ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
    if (ErrorLevel = 0)
    {
        Click, %FoundX%, %FoundY%
        Sleep, 3000
        Sleep, 30000
        Send, {Esc}
        Sleep, 3000
    }

    ; Process image 3
    currentImagePath := imagePaths3
    ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
    if (ErrorLevel = 0)
    {
        Click, %FoundX%, %FoundY%
        Sleep, 3000
    }

    ; Process image 4
    currentImagePath := imagePaths4
    ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
    if (ErrorLevel = 0)
    {
        Click, %FoundX%, %FoundY%
        Sleep, 3000
    }

    ; Process image 5
    currentImagePath := imagePaths5
    ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
    if (ErrorLevel = 0)
    {
        Click, %FoundX%, %FoundY%
        Sleep, 50000
    }

    ; Restart process (loop)
    Return

Return

; Hotkey to exit the script (F6)
F6::ExitApp  ; Press F6 to exit script
