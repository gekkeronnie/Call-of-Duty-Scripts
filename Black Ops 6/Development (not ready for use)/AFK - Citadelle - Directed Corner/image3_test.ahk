; Image URLs & Paths (Use raw URLs for GitHub images)
imageURLs1 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/save_and_quit.png"
imageURLs2 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/save.png"
imageURLs3 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/escape1.png"
imageURLs4 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/select_mission.png"
imageURLs5 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/save_file.png"
imageURLs6 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/citadelle.png"

imagePaths1 := A_Temp . "\save_and_quit.png"
imagePaths2 := A_Temp . "\save.png"
imagePaths3 := A_Temp . "\escape1.png"
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

    ; Process image 3 (only for testing)
    Loop
    {
        ; Check for image 3
        currentImagePath := imagePaths3
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *40 %currentImagePath%
        if (ErrorLevel = 0)
        {
            ; If image 3 is found, show a message box
            MsgBox, Image 3 found at coordinates: X = %FoundX%, Y = %FoundY%
            Sleep, 500  ; Wait a bit after showing the message box
            Break
        }

        ; If image 3 is not found, continue searching
        Sleep, 3000 ; Wait 3 seconds before retrying.
    }

    ; Uncomment below lines to enable the other actions, currently all commented out for testing only image3
    ; 
    ; Process image 1
    ; Loop
    ; {
    ;     currentImagePath := imagePaths1
    ;     ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
    ;     if (ErrorLevel = 0)
    ;     {
    ;         Click, %FoundX%, %FoundY%
    ;         Sleep, 3000
    ;         Break
    ;     }
    ;     else
    ;     {
    ;         Send, {Esc}
    ;         Sleep, 1000
    ;         Click, Down
    ;         Sleep, 10000
    ;         Click, Up
    ;         Sleep, 1000
    ;         Send, {Esc}
    ;         Sleep, 1500
    ;     }
    ; }
    ; 
    ; Process image 2 (with continuous retry)
    ; Loop
    ; {
    ;     currentImagePath := imagePaths2
    ;     ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
    ;     if (ErrorLevel = 0)
    ;     {
    ;         Click, %FoundX%, %FoundY%
    ;         Sleep, 30000
    ;         Break
    ;     }
    ;     else
    ;     {
    ;         Sleep, 1000  ; Retry every 1 second if not found
    ;     }
    ; }
    ; 
    ; Process image 4 (with continuous retry)
    ; Loop
    ; {
    ;     currentImagePath := imagePaths4
    ;     ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
    ;     if (ErrorLevel = 0)
    ;     {
    ;         Click, %FoundX%, %FoundY%
    ;         Sleep, 1500
    ;         Break
    ;     }
    ;     else
    ;     {
    ;         Sleep, 1000  ; Retry every 1 second if not found
    ;     }
    ; }
    ; 
    ; Process image 5 (with continuous retry)
    ; Loop
    ; {
    ;     currentImagePath := imagePaths5
    ;     ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
    ;     if (ErrorLevel = 0)
    ;     {
    ;         Click, %FoundX%, %FoundY%
    ;         Sleep, 1500
    ;         Break
    ;     }
    ;     else
    ;     {
    ;         Sleep, 1000  ; Retry every 1 second if not found
    ;     }
    ; }
    ; 
    ; Process image 6 (with continuous retry)
    ; Loop
    ; {
    ;     currentImagePath := imagePaths6
    ;     ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
    ;     if (ErrorLevel = 0)
    ;     {
    ;         Click, %FoundX%, %FoundY%
    ;         Sleep, 1500
    ;         Break
    ;     }
    ;     else
    ;     {
    ;         Sleep, 1000  ; Retry every 1 second if not found
    ;     }
    ; }

    ; Wait for 50 seconds before restarting the script from CheckScreen
    Sleep, 50000  ; Wait 50 seconds before continuing

    ; Restart the CheckScreen process
    Goto, CheckScreen
Return

; Hotkey to exit the script (F6)
F6::
    ; Release all keys and mouse buttons before exiting
    Send, {a up}  ; Release 'a' key
    Send, {s up}  ; Release 's' key
    Send, {v up}  ; Release 'v' key (if held)
    Click, Up  ; Release the mouse button
    Send, {Esc}  ; Ensure Escape key is released
    
    ; Exit the script
    ExitApp
Return
