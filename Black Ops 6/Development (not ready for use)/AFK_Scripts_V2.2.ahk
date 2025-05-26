#Persistent

; Variables to track which script is selected, if Life Insurance is active, and if scripts are running
GuiVisible := true
script1Active := false
script2Active := false
script3Active := false
script4Active := false
script5Active := false
script6Active := false
scriptRunning := false  ; Flag to check if any script is running
lifeInsuranceActive := false  ; Track the state of the Life Insurance checkbox
downedDetected := false  ; Track if downed image is detected

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

SaveState() {
    ; Save window position, size, and screen number
    WinGetPos, x, y, width, height, A
    SysGet, MonitorCount, MonitorCount
    Loop, %MonitorCount%
    {
        SysGet, Monitor, Monitor, %A_Index%
        if (x >= MonitorLeft and x < MonitorRight and y >= MonitorTop and y < MonitorBottom) {
            screenNumber := A_Index
            break
        }
    }
    IniWrite, %x%, State.ini, Window, X
    IniWrite, %y%, State.ini, Window, Y
    IniWrite, %width%, State.ini, Window, Width
    IniWrite, %height%, State.ini, Window, Height
    IniWrite, %screenNumber%, State.ini, Window, Screen

    ; Save selected radio button
    GuiControlGet, script1Selected,, Script1Radio
    GuiControlGet, script2Selected,, Script2Radio
    GuiControlGet, script3Selected,, Script3Radio
    GuiControlGet, script4Selected,, Script4Radio
    GuiControlGet, script5Selected,, Script5Radio
    GuiControlGet, script6Selected,, Script6Radio
    if (script1Selected) {
        IniWrite, Script1Radio, State.ini, Radio, Selected
    } else if (script2Selected) {
        IniWrite, Script2Radio, State.ini, Radio, Selected
    } else if (script3Selected) {
        IniWrite, Script3Radio, State.ini, Radio, Selected
    } else if (script4Selected) {
        IniWrite, Script4Radio, State.ini, Radio, Selected
    } else if (script5Selected) {
        IniWrite, Script5Radio, State.ini, Radio, Selected
    } else if (script6Selected) {
        IniWrite, Script6Radio, State.ini, Radio, Selected
    }

    ; Save ZombiesLifeInsurance checkbox state
    GuiControlGet, lifeInsuranceChecked,, ZombiesLifeInsurance
    IniWrite, %lifeInsuranceChecked%, State.ini, Checkbox, ZombiesLifeInsurance

    ; Save lifeInsuranceActive status
    IniWrite, %lifeInsuranceActive%, State.ini, Status, LifeInsuranceActive
}

LoadState() {
    ; Load window position, size, and screen number
    IniRead, x, State.ini, Window, X, A_ScreenWidth/2
    IniRead, y, State.ini, Window, Y, A_ScreenHeight/2
    IniRead, width, State.ini, Window, Width, 600
    IniRead, height, State.ini, Window, Height, 400
    IniRead, screenNumber, State.ini, Window, Screen, 1

    ; Adjust position based on the screen number
    SysGet, Monitor, Monitor, %screenNumber%
    x := MonitorLeft + (x - MonitorLeft)
    y := MonitorTop + (y - MonitorTop)

    Gui, Show, x%x% y%y% w%width% h%height%

    ; Load selected radio button
    IniRead, selectedRadio, State.ini, Radio, Selected
    if (selectedRadio) {
        GuiControl,, %selectedRadio%, 1
    }

    ; Load ZombiesLifeInsurance checkbox state
    IniRead, lifeInsuranceChecked, State.ini, Checkbox, ZombiesLifeInsurance
    GuiControl,, ZombiesLifeInsurance, %lifeInsuranceChecked%

    ; Load lifeInsuranceActive status
    IniRead, lifeInsuranceActive, State.ini, Status, LifeInsuranceActive
    IniRead, reloading, State.ini, Reloading, Reloading

    if (reloading == 1 && lifeInsuranceActive == 1) {
    GuiControl,, ZombiesLifeInsurance, 0
    Gui, Hide
    FileDelete, %A_ScriptDir%\State.ini
    GoSub, PerformLifeInsuranceActions
    } else {
    IniWrite, 0, State.ini, Status, LifeInsuranceActive
    IniWrite, 0, State.ini, Reloading, Reloading
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

; Liberty Falls Category
Gui, Add, GroupBox, % "x7 y" yPos " w" (Width * 0.64) " h100", Liberty Falls
Gui, Add, Radio, % "x15 y" (yPos + 20) " w" (Width * 0.32 - 30) " r1 +0x4000 vScript4Radio gOnSelect", Jetgun  ; First radio gets +Group
Gui, Add, Radio, % "x" (15 + (Width * 0.32 - 30) + 10) " y" (yPos + 20) " w" (Width * 0.32 - 30) " r1 +0x4000 vScript6Radio gOnSelect", Activate Glitch  

yPos += 110  

; Terminus Category
Gui, Add, GroupBox, % "x7 y" yPos " w" (Width * 0.64) " h100", Terminus
Gui, Add, Radio, % "x15 y" (yPos + 20) " w" (Width * 0.32 - 30) " r1 +0x4000 vScript5Radio gOnSelect", Placeholder  

yPos += 110  

; Citadelle Des Morts Category
Gui, Add, GroupBox, % "x7 y" yPos " w" (Width * 0.64) " h120", Citadelle Des Morts
Gui, Add, Radio, % "x15 y" (yPos + 20) " w" (Width * 0.32 - 30) " r1 +0x4000 vScript2Radio gOnSelect", Lion Sword Room  
Gui, Add, Radio, % "x15 y" (yPos + 40) " w" (Width * 0.32 - 30) " r1 +0x4000 vScript3Radio gOnSelect", Directed Corner  

yPos += 130  

; The Tombs Category
Gui, Add, GroupBox, % "x7 y" yPos " w" (Width * 0.64) " h120", The Tombs
Gui, Add, Radio, % "x15 y" (yPos + 20) " w" (Width * 0.32 - 30) " r1 +0x4000 vScript1Radio gOnSelect", Ice Staff  


; Adjust vertical positioning of the CheckBox, Close Script button, and other controls
Gui, Add, CheckBox, % "x7 y" (yPos + 130) " w" ButtonWidth "r1 +0x4000 vZombiesLifeInsurance Checked gCheckLifeInsurance", Zombies Life Insurance

Gui, Add, Button, % "x7 y" (yPos + 160) " w" CloseButtonWidth "r1 +0x4000 gClose", Close Script
Gui, Add, Text, % "x7 y" (yPos + 180) " w" "h5 vP"
GuiControlGet, P, Pos
H := PY + PH

Gui, Add, Text, % "x7 y" (H + 31) " w160 h30 BackgroundTrans Left", F5 - Start AFK Script
Gui, Add, Text, % "x7 y" (H + 44) " w160 h30 BackgroundTrans Left", F6 - Stop AFK Script
Gui, Add, Text, % "x7 y" (H + 57) " w160 h30 BackgroundTrans Left", F7 - Hide Window
Gui, Add, Text, % "x7 y" (H + 70) " w160 h30 BackgroundTrans Left", F8 - Close

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

; Loading saved state
IniRead, reloading, State.ini, Reloading, Reloading
if (reloading == 1) {
    LoadState()
    IniWrite, 0, State.ini, Reloading, Reloading
} else {
    ; Remove the existing State.ini file
    FileDelete, %A_ScriptDir%\State.ini
}

; Manually call CheckLifeInsurance to ensure the timer starts correctly
GoSub, CheckLifeInsurance

Gui, +E0x80000
Gui, +LastFound
WinGet, WindowID, ID, A
return

GuiMove:
    PostMessage, 0xA1, 2
    return
        
Close:
ExitApp

Gui, Show, , Radio Button Selection
return

OnSelect:
    ; Deselect all radio buttons
    GuiControl,, Script1Radio, 0
    GuiControl,, Script2Radio, 0
    GuiControl,, Script3Radio, 0
    GuiControl,, Script4Radio, 0
    GuiControl,, Script5Radio, 0
    GuiControl,, Script6Radio, 0

    ; Get the control that triggered the event
    GuiControlGet, selectedRadio
    selectedScript := A_GuiControl  ; AHK stores the clicked control in A_GuiControl

    ; Select the clicked radio button manually
    GuiControl,, %selectedScript%, 1

    ; Get the selected radio button
    GuiControlGet, script1Selected,, Script1Radio
    GuiControlGet, script2Selected,, Script2Radio
    GuiControlGet, script3Selected,, Script3Radio
    GuiControlGet, script4Selected,, Script4Radio
    GuiControlGet, script5Selected,, Script5Radio
    GuiControlGet, script6Selected,, Script6Radio

    ; Store the selected script in a global variable
    if (script1Selected) {
        selectedScript := "Script1Radio"
    } else if (script2Selected) {
        selectedScript := "Script2Radio"
    } else if (script3Selected) {
        selectedScript := "Script3Radio"
    } else if (script4Selected) {
        selectedScript := "Script4Radio"
    } else if (script5Selected) {
        selectedScript := "Script5Radio"
    } else if (script6Selected) {
        selectedScript := "Script6Radio"
    }
return

PerformLifeInsuranceActions:
    ; Actions for Life Insurance when downed image is detected

    ; Put game in focus mode and ensure we don't get stuck on freeze frame or connected delays.
    Sleep, 1000
    Send, {LButton} ; Ensure the game is in focus mode
    Sleep, 1000     ; Wait 1 second
    Send, {Tab Down} ; Get rid of freeze frame, connected issues.
    Sleep, 2000     ; Wait 2 seconds
    Send, {Tab Up}  ; Get rid of freeze frame, connected issues.
    Sleep, 1000     ; Wait 1 second
    Send, {Escape}  ; Get rid of freeze frame, connected issues.
    Sleep, 1000     ; Wait 1 second
    Send, {Escape}  ; Get rid of freeze frame, connected issues.
    
   
    ; Start Save Process
    Sleep, 10000    ; Wait 10 seconds before performing actions
    Send, {F Down}  ; Hold "F"
    Sleep, 4000     ; Hold for 4 seconds
    Send, {F Up}    ; Release "F"
    Sleep, 100

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
    MsgBox, 48, Game Over, You died!

    Sleep, 100

    ; Remove the existing State.ini file
    FileDelete, %A_ScriptDir%\State.ini

    ExitApp  ; Exit after performing Life Insurance actions
return

GuiControl, +gCheckLifeInsurance, ZombiesLifeInsurance

CheckLifeInsurance:
    GuiControlGet, LifeInsuranceChecked, , ZombiesLifeInsurance
    if (LifeInsuranceChecked = 1) {
        SetTimer, CheckForDownedImage, 10000 ; Start the timer
    } else {
        SetTimer, CheckForDownedImage, Off ; Stop the timer
    }
return

CheckForDownedImage:
    ; Only check for the downed image if the Life Insurance checkbox is checked
    GuiControlGet, LifeInsuranceChecked, , ZombiesLifeInsurance
    if (LifeInsuranceChecked = 1) {
        ; Check for "downed.png" image
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *1.3 %imagePath%
        if (ErrorLevel = 0) {
            ; Save lifeInsuranceActive status
            lifeInsuranceActive := true
            SaveState()
            IniWrite, %lifeInsuranceActive%, State.ini, Status, LifeInsuranceActive
            IniWrite, 1, State.ini, Reloading, Reloading
            Reload
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

F6::
    SaveState()
    IniWrite, 1, State.ini, Reloading, Reloading
    Reload
return

F5::
    ; Stop any running scripts
    scriptRunning := false  

    ; Retrieve selected script radio button
    GuiControlGet, script1Selected,, Script1Radio
    GuiControlGet, script2Selected,, Script2Radio
    GuiControlGet, script3Selected,, Script3Radio
    GuiControlGet, script4Selected,, Script4Radio
    GuiControlGet, script5Selected,, Script5Radio
    GuiControlGet, script6Selected,, Script6Radio

    if (script1Selected) {
        script1Active := true
        scriptRunning := true
        RunScript1()
    } else if (script2Selected) {
        script2Active := true
        scriptRunning := true
    } else if (script3Selected) {
        script3Active := true
        scriptRunning := true
    } else if (script4Selected) {
        script4Active := true
        scriptRunning := true
        RunScript4()
    } else if (script5Selected) {
        script5Active := true
        scriptRunning := true
    } else if (script6Selected) {
        script6Active := true
        scriptRunning := true
        RunScript6()
    } else {
        MsgBox, Please select a script before pressing F5!
    }

; ICE STAFF AFK
RunScript1() {
    global scriptRunning  ; Ensure scriptRunning is accessible

    if (!scriptRunning) {
        return
    }

    ; Start the loop
    Loop {
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

RunScript2:
    if (!scriptRunning) {
        return
    }
    ; Start the loop for image search and actions
    Loop {
        ; Check for the image "downed.png" and click when detected
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *1 %imagePath%
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
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *1 %imagePath%
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

; JETGUN AFK
RunScript4() {
    global scriptRunning  ; Ensure scriptRunning is accessible

    if (!scriptRunning) {
        return
    }

    ; Start the loop
    Loop {
	    Send, {e down}
	    Sleep, 100
	    Send, {e up}
  	    Sleep, 10000

	    Send, {1 down}
	    Sleep, 100
	    Send, {1 up}

	    Sleep, 500
	    Send, {g down}  
   	    Sleep, 100           
   	    Send, {g up}
        Sleep, 1000

        ;Send, {X}
        ;sleep 1000
    }
}

RunScript5:
    if (!scriptRunning) {
        return
    }
    ; Start the loop for image search and actions
    Loop {
        ; Check for the image "downed.png" and click when detected
        ImageSearch, FoundX, FoundY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *1 %imagePath%
        if (ErrorLevel = 0) {
            Click, %FoundX%, %FoundY%
            Sleep, 500
            ; Break the loop to stop AFK script
            scriptRunning := false
            SetTimer, RunScript5, Off  ; Turn off the script timer
            Break
        }
        else {

        }
    }

    ; After the loop is broken (image detected), perform Life Insurance actions
    GoSub, PerformLifeInsuranceActions  ; Call the label

    ExitApp ; Exit the script after Life Insurance actions are performed

return

; ACTIVATE JETGUN GLITCH
RunScript6() {
    global scriptRunning  ; Ensure scriptRunning is accessible

    if (!scriptRunning)  
        return  ; Exit immediately if script is not running

    Click, Left, Down
    Sleep, 600
    Send, {x Down}
    Sleep, 100
    Send, {x Up}
    Sleep, 3000
    Click, Left, Up
    Sleep, 3000

    Loop, 13 {
        Send, {W Down}
        Sleep, 50
        Send, {v Down}
        Sleep, 50
        Send, {W Up}
        Sleep, 50
        Send, {v Up}
        Sleep, 50
    }
    
    Sleep, 1500

    Click, Left, Down
    Sleep, 110
    Click, Left, Up

    scriptRunning := false  ; Ensure script is properly stopped
}

F8::ExitApp
return