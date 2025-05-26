#Persistent

; Variables to track which script is selected, if Life Insurance is active, and if scripts are running
script1Active := false
script2Active := false
script3Active := false
script4Active := false
lifeInsuranceActive := false  ; Track the state of the Life Insurance checkbox
downedDetected := false  ; Track if downed image is detected
scriptRunning := false  ; Flag to check if any script is running

; Image URLs & Paths for all images (including the ones from Script 4)
bannerURL := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/banner.png"
imageURL := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/downed.png"
imageURLs1 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/save_and_quit.png"
imageURLs2 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/save.png"
imageURLs3 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/escape.png"
imageURLs4 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/select_mission.png"
imageURLs5 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/save_file.png"
imageURLs6 := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/citadelle.png"

bannerLocalPath := A_Temp "\banner.png"
imagePath := A_Temp . "\downed.png"
imagePaths1 := A_Temp . "\save_and_quit.png"
imagePaths2 := A_Temp . "\save.png"
imagePaths3 := A_Temp . "\escape.png"
imagePaths4 := A_Temp . "\select_mission.png"
imagePaths5 := A_Temp . "\save_file.png"
imagePaths6 := A_Temp . "\citadelle.png"

; Download the images if they don't exist
IfNotExist, %bannerLocalPath%
{
    URLDownloadToFile, %bannerURL%, %bannerLocalPath%
    Sleep, 500
}

IfNotExist, %imagePath%
{
    URLDownloadToFile, %imageURL%, %imagePath%
    Sleep, 500
}

; Download additional images for Script 4
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

; GUI Setup (unchanged from the original script)
Width := A_ScreenWidth * 0.20
MaxWidth := 600
Width := (Width > MaxWidth) ? MaxWidth : Width
MaxHeight := A_ScreenHeight * 0.80
MinHeight := 300
H := MinHeight

ButtonWidth := (Width - 14) * 0.80  ; 80% of available width for other buttons
TextWidth := Width - 14
SmoothingButtonWidth := Width - 275
SmoothingTextWidth := Width - 100
CloseButtonWidth := ButtonWidth * 0.3  ; 30% of the width for the Close Script button

Gui, +AlwaysOnTop
Gui, +LastFound
WinSet, Transparent, 220
Gui, Color, 808080
Gui, Margin, 0, 0

Gui, Font, s10 cD0D0D0 Bold
Gui, Add, Progress, % "x-1 y-1 w" (Width+2) " h30 Background006400 Disabled hwndHPROG"
Control, ExStyle, -0x20000, , ahk_id %HPROG%

Gui, Add, Picture, % "x0 y28 w" ((Width - 14) * 0.70) " h" ((HeightBanner := 100) * 0.80) " vBannerImage", %bannerLocalPath%

Gui, Add, Text, % "x7 y0 w" (Width - 14) " h30 BackgroundTrans Left 0x200 +gGuiMove vCaption", Gekke Ronnie's - AFK SCRIPTS

Gui, Font, s8

; Initialize the starting Y position
yPos := 115  ; Initial position for Liberty Falls

; Define a global variable to track the selected radio button
selectedScript := ""

; Grouping scripts into categories with GroupBox
; Liberty Falls Category
Gui, Add, GroupBox, % "x7 y" yPos " w" (Width * 0.64) " h100", Liberty Falls  ; 80% width for GroupBox
Gui, Add, Radio, % "x15 y" (yPos + 20) " w" (Width * 0.32 - 30) " r1 +0x4000 vScript4Radio gOnSelect", Jetgun  ; Adjust width of radio buttons to fit inside GroupBox
Gui, Add, Radio, % "x" (15 + (Width * 0.32 - 30) + 10) " y" (yPos + 20) " w" (Width * 0.32 - 30) " r1 +0x4000 vScript6Radio gOnSelect", Activate Glitch  ; Added radio button next to Jetgun

; Update yPos for the next category
yPos += 110  ; Add 120 pixels for the next GroupBox

; Terminus Category (Newly Added, 2nd Position)
Gui, Add, GroupBox, % "x7 y" yPos " w" (Width * 0.64) " h100", Terminus  ; 80% width for GroupBox
Gui, Add, Radio, % "x15 y" (yPos + 20) " w" (Width * 0.32 - 30) " r1 +0x4000 vScript5Radio gOnSelect", Placeholder  ; Adjust width of radio buttons to fit inside GroupBox

; Update yPos for the next category
yPos += 110  ; Add 120 pixels for the next GroupBox

; Citadelle Des Morts Category (3rd Position)
Gui, Add, GroupBox, % "x7 y" yPos " w" (Width * 0.64) " h120", Citadelle Des Morts  ; 80% width for GroupBox
Gui, Add, Radio, % "x15 y" (yPos + 20) " w" (Width * 0.32 - 30) " r1 +0x4000 vScript2Radio gOnSelect", Lion Sword Room  ; Adjust width of radio buttons to fit inside GroupBox
Gui, Add, Radio, % "x15 y" (yPos + 40) " w" (Width * 0.32 - 30) " r1 +0x4000 vScript3Radio gOnSelect", Directed Corner  ; Adjust width of radio buttons to fit inside GroupBox

; Update yPos for the next category
yPos += 130  ; Add 140 pixels for the next GroupBox

; The Tombs Category (4th Position)
Gui, Add, GroupBox, % "x7 y" yPos " w" (Width * 0.64) " h120", The Tombs  ; 80% width for GroupBox
Gui, Add, Radio, % "x15 y" (yPos + 20) " w" (Width * 0.32 - 30) " r1 +0x4000 vScript1Radio gOnSelect", Ice Staff  ; Adjust width of radio buttons to fit inside GroupBox



; Adjust vertical positioning of the CheckBox, Close Script button, and other controls
Gui, Add, CheckBox, % "x7 y" (yPos + 130) " w" ButtonWidth "r1 +0x4000 vZombiesLifeInsurance", Zombies Life Insurance

Gui, Add, Button, % "x7 y" (yPos + 160) " w" CloseButtonWidth "r1 +0x4000 gClose", Close Script
Gui, Add, Text, % "x7 y" (yPos + 180) " w" "h5 vP"
GuiControlGet, P, Pos
H := PY + PH

Gui, Add, Text, % "x7 y" (H + 31) " w160 h30 BackgroundTrans Left", F5 - Start AFK Script
Gui, Add, Text, % "x7 y" (H + 44) " w160 h30 BackgroundTrans Left", F6 - Stop AFK Script
Gui, Add, Text, % "x7 y" (H + 57) " w160 h30 BackgroundTrans Left", F7 - Hide Window
Gui, Add, Text, % "x7 y" (H + 70) " w160 h30 BackgroundTrans Left", F8 - Reload Script

Gui, Add, Text, % "x7 y" (H + 350) " w160 h5 vFooter"

; Ensure footer position is inside the window
GuiControlGet, FooterPos, Pos, Footer
FooterPosY := FooterPosY  ; Get Footer's position
H := FooterPosY + 100  ; Footer's position + buffer

; Limit height to MaxHeight
H := (H > MaxHeight) ? MaxHeight : H

; Adjust GUI region
Gui, -Caption
WinSet, Region, 0-0 w%Width% h%H% r6-6
Gui, Show, % "w" Width " NA" " x" (A_ScreenWidth - Width) "x10 y50"

Gui, +E0x80000
Gui, +LastFound
WinGet, WindowID, ID, A
return

GuiMove:
    PostMessage, 0xA1, 2
    return

Close:
ExitApp

OnSelect:
    ; Check which radio button was clicked by checking the variable values
    if (Script5Radio) {
        MsgBox, You selected Placeholder from Terminus.
        ; Additional logic for Placeholder (Script 5)
    }
    else if (Script2Radio) {
        MsgBox, You selected Lion Sword Room from Citadelle Des Morts.
        ; Additional logic for Lion Sword Room (Script 2)
    }
    else if (Script3Radio) {
        MsgBox, You selected Directed Corner from Citadelle Des Morts.
        ; Additional logic for Directed Corner (Script 3)
    }
    else if (Script1Radio) {
        MsgBox, You selected Ice Staff from The Tombs.
        ; Additional logic for Ice Staff (Script 1)
    }
return


PerformLifeInsuranceActions:
    ; Actions for Life Insurance when downed image is detected
    ; Here we perform the necessary actions, such as:
    Sleep, 10000    ; Wait 10 seconds before performing actions
    Send, {Escape}  ; Escape first ensure we not getting stuck in bug to freeze frames
    Sleep, 1000     ; Wait 1 second
    Send, {Escape}  ; Escape first ensure we not getting stuck in bug to freeze frames
    Sleep, 1000     ; Wait 1 second
    Send, {F Down}  ; Hold "F"
    Sleep, 4200     ; Hold for 4.2 seconds
    Send, {F Up}    ; Release "F"
    
    Sleep, 1000     ; Wait 1 second

    Send, {Esc}     ; Press Escape
    Sleep, 1000     ; Wait 1 second

    Loop, 7         ; Press Down Arrow 7 times
    {
        Send, {Down}
        Sleep, 100   ; Small delay between presses
    }

    Send, {Space}   ; Press Spacebar
    Sleep, 1000     ; Wait 1 second

    Send, {Up}      ; Press Up Arrow once
    Sleep, 1000     ; Wait 1 second

    Send, {Space}   ; Press Spacebar again

    ; Display message before exiting
    MsgBox, 48, Game Over, You died, Life Insurance script has been completed!

    ExitApp  ; Exit after performing Life Insurance actions
return

; Timer to check for downed image every 10 seconds, but only if the checkbox is checked
SetTimer, CheckForDownedImage, 10000 ; Check every 10 seconds

CheckForDownedImage:
    ; Only check for the downed image if the Life Insurance checkbox is checked
    GuiControlGet, LifeInsuranceChecked, , ZombiesLifeInsurance
    if (LifeInsuranceChecked = 1) {
        ; Check for "downed.png" image
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *5 %imagePath%
        if (ErrorLevel = 0) {
            downedDetected := true
            ; Break the current script loop if downed image is found
            scriptRunning := false
            SetTimer, RunScript1, Off  ; Turn off the script timer
            SetTimer, RunScript2, Off  ; Turn off other script timers if active
            SetTimer, RunScript3, Off
            SetTimer, RunScript4, Off
            GoSub, PerformLifeInsuranceActions ; Call the label
        }
    }
return

F7::  ; Hide Window
    if (GuiVisible) {
        Gui, Hide
        GuiVisible := false
    } else {
        Gui, Show
        GuiVisible := true
    }
return

F8::Reload

F5::  ; Start AFK Script
    GuiControlGet, Script1Radio, , Script1Radio
    if (Script1Radio) {
        script1Active := true
        script2Active := false
        script3Active := false
        script4Active := false
        scriptRunning := true
        SetTimer, RunScript1, 10
    }
    GuiControlGet, Script2Radio, , Script2Radio
    if (Script2Radio) {
        script1Active := false
        script2Active := true
        script3Active := false
        script4Active := false
        scriptRunning := true
        SetTimer, RunScript2, 10
    }
    GuiControlGet, Script3Radio, , Script3Radio
    if (Script3Radio) {
        script1Active := false
        script2Active := false
        script3Active := true
        script4Active := false
        scriptRunning := true
        SetTimer, RunScript3, 10
    }
    GuiControlGet, Script4Radio, , Script4Radio
    if (Script4Radio) {
        script1Active := false
        script2Active := false
        script3Active := false
        script4Active := true
        scriptRunning := true
        SetTimer, RunScript4, 10
    }
return

RunScript1:
    if (!scriptRunning) {
        return
    }
        ; Start the loop for image search and actions
    Loop {
        ; Check for the image "downed.png" and click when detected
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *5 %imagePath%
        if (ErrorLevel = 0) {
            Click, %FoundX%, %FoundY%
            Sleep, 500
            ; Break the loop to stop AFK script
            scriptRunning := false
            SetTimer, RunScript1, Off  ; Turn off the script timer
            Break
        }
        else {
            ; First Shot & Apply Armor
            Send, {LButton Down}
            Sleep 500
            Send, {G}
            Sleep 2000
            Send, {LButton Up}
            Sleep 100

            ; Energy Mine
            Send, {X}
            Sleep, 2000

            ; Second Shot
            Send, {LButton Down}
            Sleep, 2500
            Send, {LButton Up}
            Sleep 100

            ; Energy Mine
            Send, {X}
            Sleep, 2000

            ; Shoot, Apply Armor, Reload & Walk Forward + Left
            Send, {LButton Down}
            Sleep 500
            Send, {G}
            Sleep 2000
            Send, {LButton Up}
            Sleep 100
            Send, {R}
            Send, {W Down}
            Send, {A Down}
            Sleep 200
            Sleep, 2300
            Send, {W Up}
            Send, {A Up}

            ; Energy Mine & Walk Forward + Right
            Send, {W Down}
            Send, {D Down}
            Send, {X}
            Sleep 300
            Send, {W Up}
            Send, {D Up}
        }
    }

    ; After the loop is broken (image detected), perform Life Insurance actions
    GoSub, PerformLifeInsuranceActions  ; Call the label
    ExitApp ; Exit the script after Life Insurance actions are performed

return

RunScript2:
    if (!scriptRunning) {
        return
    }
    ; Start the loop for image search and actions
    Loop {
        ; Check for the image "downed.png" and click when detected
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *5 %imagePath%
        if (ErrorLevel = 0) {
            Click, %FoundX%, %FoundY%
            Sleep, 500
            ; Break the loop to stop AFK script
            scriptRunning := false
            SetTimer, RunScript2, Off  ; Turn off the script timer
            Break
        }
        else {
        ; Hold down the left mouse button continuously
        Send, {LButton Down}  ; Simulate holding down the left mouse button
    
        while (scriptRunning) {
        ; Check if the left mouse button is still down
        GetKeyState, LButtonState, LButton, P  ; Get the physical state of the left mouse button
        if (LButtonState = "U") {
            ; If the left mouse button is released, exit the loop
            scriptRunning := false  ; Stop the script from running again until F5 is pressed
            break
            }
        }
    }
}
        

    ; After the loop is broken (image detected), perform Life Insurance actions
    GoSub, PerformLifeInsuranceActions  ; Call the label

    ExitApp ; Exit the script after Life Insurance actions are performed

return

RunScript3:
    if (!scriptRunning) {
        return
    }

    ; Start the loop for image search and actions
    Loop {
        ; Check for the image "downed.png" and click when detected
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *5 %imagePath%
        if (ErrorLevel = 0) {
            Click, %FoundX%, %FoundY%
            Sleep, 500
            ; Break the loop to stop AFK script
            scriptRunning := false
            SetTimer, RunScript3, Off  ; Turn off the script timer
            Break
        }
        else {
            
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

    Sleep, 18000000  ; Sleep for 5 hours (18 million milliseconds)

    ; After 5 hours, release the mouse and keys
    Send, {a up}  ; Release A
    Send, {s up}  ; Release S
    Click, Up  ; Release the mouse button

    ; After holding the mouse, press Escape and wait for 3 seconds
    Send, {Esc}  ; Press Escape
    Sleep, 500

    ; Process image 1
    Loop
    {
        currentImagePath := imagePaths1
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
        if (ErrorLevel = 0)
        {
            Click, %FoundX%, %FoundY%
            Sleep, 500
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
            Sleep, 500
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
            Sleep, 30000
            Break
        }
        else
        {
            Sleep, 1000  ; Retry every 1 second if not found
        }
    }

    ; Process image 3 and 4
    Loop
    {
        ; Check for image 3
        currentImagePath := imagePaths3
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
        if (ErrorLevel = 0)
        {
            ; Show the message box
            ; Wait for 5 seconds
            Sleep, 5000
            Click, %FoundX%, %FoundY%
            Sleep, 500
        }

        ; Check for image 4
        currentImagePath := imagePaths4
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
        if (ErrorLevel = 0)
        {
            Click, %FoundX%, %FoundY%
            Sleep, 500
            Break
        }

        Sleep, 3000 ; Wait 3 seconds before retrying.
    }

    ; Process image 5
    Loop
    {
        currentImagePath := imagePaths5
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
        if (ErrorLevel = 0)
        {
            Click, %FoundX%, %FoundY%
            Sleep, 500
            Break
        }
        else
        {
            Sleep, 1000  ; Retry every 1 second if not found
        }
    }

    ; Process image 6
    Loop
    {
        currentImagePath := imagePaths6
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *20 %currentImagePath%
        if (ErrorLevel = 0)
        {
            Click, %FoundX%, %FoundY%
            Sleep, 500
            Break
        }
        else
        {
            Sleep, 1000  ; Retry every 1 second if not found
        }
    }

    ; Wait for 48 seconds before restarting the script from CheckScreen
    Sleep, 48000  ; Wait 50 seconds before continuing

    ; Restart the CheckScreen process
    Goto, CheckScreen
        }
    }

    ; After the loop is broken (image detected), perform Life Insurance actions
    GoSub, PerformLifeInsuranceActions  ; Call the label

    ExitApp ; Exit the script after Life Insurance actions are performed

return

RunScript4:
    if (!scriptRunning) {
        return
    }
    ; Start the loop for image search and actions
    Loop {
        ; Check for the image "downed.png" and click when detected
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *5 %imagePath%
        if (ErrorLevel = 0) {
            Click, %FoundX%, %FoundY%
            Sleep, 500
            ; Break the loop to stop AFK script
            scriptRunning := false
            SetTimer, RunScript1, Off  ; Turn off the script timer
            Break
        }
        else {
	        Send, {e down}
	        Sleep, 100
	        Send, {e up}
  	        Sleep, 5000

	        Send, {1 down}
	        Sleep, 100
	        Send, {1 up}

	        Sleep, 500
	        Send, {g down}  
   	        Sleep, 100           
   	        Send, {g up}   

	        Send, {g down}  
   	        Sleep, 100           
   	        Send, {g up}
	        Sleep, 700

	        ;Send, {x down}  
   	        ;Sleep, 100           
   	        ;Send, {x up}  	 

  	        ;Sleep, 2500
        }
    }

    ; After the loop is broken (image detected), perform Life Insurance actions
    GoSub, PerformLifeInsuranceActions  ; Call the label

    ExitApp ; Exit the script after Life Insurance actions are performed

return

; F6 Hotkey - Stop All Scripts
F6::
    scriptRunning := false  ; Immediately stop all running scripts
    
    ; If scriptRunning is false, turn off timers for all scripts
    if (!scriptRunning) {
        SetTimer, RunScript1, Off  ; Turn off the timer for RunScript1
        SetTimer, RunScript2, Off  ; Turn off the timer for RunScript2
        SetTimer, RunScript3, Off  ; Turn off the timer for RunScript3
        SetTimer, RunScript4, Off  ; Turn off the timer for RunScript4
    }
return