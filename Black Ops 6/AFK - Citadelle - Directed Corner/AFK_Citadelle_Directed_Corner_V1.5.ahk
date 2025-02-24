#Persistent

; Image URLs & Paths (Use raw URLs for GitHub images)
imageURLs1 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/save_and_quit.png"
imageURLs2 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/save.png"
imageURLs3 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/escape.png"
imageURLs4 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/select_mission.png"
imageURLs5 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/save_file.png"
imageURLs6 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/citadelle.png"

imagePaths1 := A_Temp . "\save_and_quit.png"
imagePaths2 := A_Temp . "\save.png"
imagePaths3 := A_Temp . "\escape.png"
imagePaths4 := A_Temp . "\select_mission.png"
imagePaths5 := A_Temp . "\save_file.png"
imagePaths6 := A_Temp . "\citadelle.png"

; Download the images if they don't exist
Loop, 6
{
    currentImagePath := imagePaths%A_Index%
    currentImageURL := imageURLs%A_Index%

    if !FileExist(currentImagePath)  ; Check if file already exists
    {
        URLDownloadToFile, %currentImageURL%, %currentImagePath%
        Sleep, 1000  ; Wait for the file to save
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
    Process, Exist, cod.exe
    if (ErrorLevel = 0)
    {
        MsgBox, 16, Error, cod.exe is not running. Exiting the script.
        ExitApp
    }
Return

CheckScreen:
    ; Switch to Sword and Run left
    Send, {a Down}
    Send, {v Down}
    sleep 2000
    Send, {v Up}
    Send, {a Up}

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
    Loop
    {
        currentImagePath := imagePaths1
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
        if (ErrorLevel = 0)
        {
            Click, %FoundX%, %FoundY%
            Sleep, 3000
            Break
        }
        else
        {
            Send, {Esc}
            Sleep, 1000
            Click, Down
            Sleep, 10000
            Click, Up
            Sleep, 1000
            Send, {Esc}
        }
    }

    ; Process image 2
    Loop
    {
        currentImagePath := imagePaths2
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
        if (ErrorLevel = 0)
        {
            Click, %FoundX%, %FoundY%
            Sleep, 3000
            Break
        }
    }

    ; Process image 3 (Retry up to 10 times, then skip if not found)
    RetryCount := 0
    Loop
    {
        currentImagePath := imagePaths3
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
        if (ErrorLevel = 0)
        {
            Click, %FoundX%, %FoundY%
            Sleep, 3000
            Break
        }
        RetryCount++
        if (RetryCount >= 10)
        {
            Break
        }
    }

    ; Process remaining images (continue flow even if image 3 was skipped)
    Loop, 3
    {
        currentImagePath := imagePaths%A_Index%+3
        Loop
        {
            ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
            if (ErrorLevel = 0)
            {
                Click, %FoundX%, %FoundY%
                Sleep, 3000
                Break
            }
        }
    }

Return

; Hotkey to exit the script (F6)
F6::ExitApp
