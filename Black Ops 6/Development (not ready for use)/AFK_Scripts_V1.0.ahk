#Persistent

; Variables to track which script is selected, if Life Insurance is active, and if scripts are running
script1Active := false
script2Active := false
script3Active := false
script4Active := false
lifeInsuranceActive := false  ; Track the state of the Life Insurance checkbox
downedDetected := false  ; Track if downed image is detected
scriptRunning := false  ; Flag to check if any script is running

; Image URL & Path
bannerURL := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/banner.png"
imageURL := "https://raw.githubusercontent.com/gekkeronnie/Call-of-Duty-Scripts/main/Black%20Ops%206/Sources/Images/downed.png"
bannerLocalPath := A_Temp "\banner.png"
imagePath := A_Temp . "\downed.png"

; Download banner and downed image if they don't exist
IfNotExist, %bannerLocalPath%
{
    URLDownloadToFile, %bannerURL%, %bannerLocalPath%
    Sleep, 500
}

IfNotExist, %imagePath%
{
    URLDownloadToFile, %imageURL%, %imagePath%
    Sleep, 500  ; Give time for the file to save

    IfNotExist, %imagePath%
    {
        MsgBox, 16, Error, The required image could not be downloaded. Check the URL or internet connection.
        ExitApp  ; Exit if the download failed
    }
    else
    {
        MsgBox, 64, Success, Required image downloaded: %imagePath%
    }
}

; GUI Setup (unchanged from the original script)

Width := A_ScreenWidth * 0.20
MaxWidth := 600
Width := (Width > MaxWidth) ? MaxWidth : Width
MaxHeight := A_ScreenHeight * 0.50
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
Gui, Add, Radio, % "x7 y115 w" ButtonWidth "r1 +0x4000 vScript1Radio", AFK - The Tombs - Ice Staff
Gui, Add, Radio, % "x7 y+2 w" ButtonWidth "r1 +0x4000 vScript2Radio", AFK - Citadelle - Lion Sword Room
Gui, Add, Radio, % "x7 y+2 w" ButtonWidth "r1 +0x4000 vScript3Radio", AFK - Citadelle - Directed Corner
Gui, Add, Radio, % "x7 y+2 w" ButtonWidth "r1 +0x4000 vScript4Radio", AFK - Liberty Falls - Jetgun

Gui, Add, CheckBox, % "x7 y+15 w" ButtonWidth "r1 +0x4000 vZombiesLifeInsurance", Zombies Life Insurance

Gui, Add, Button, % "x7 y+15 w" CloseButtonWidth "r1 +0x4000 gClose", Close Script  ; Reduced width by 70% here
Gui, Add, Text, % "x7 y+90 w" "h5 vP"
GuiControlGet, P, Pos
H := PY + PH

Gui, Add, Text, % "x7 y" (H + -47) " w160 h30 BackgroundTrans Left", F5 - Start AFK Script
Gui, Add, Text, % "x7 y" (H + -34) " w160 h30 BackgroundTrans Left", F6 - Stop AFK Script
Gui, Add, Text, % "x7 y" (H + -21) " w160 h30 BackgroundTrans Left", F7 - Hide Window
Gui, Add, Text, % "x7 y" (H + -08) " w160 h30 BackgroundTrans Left", F8 - Reload Script

Gui, Add, Text, % "x7 y" (H + 75) " w160 h5 vFooter"

GuiControlGet, FooterPos, Pos, Footer
H := FooterPosY + 100  ; Ensures footer is inside window
H := Min(H, MaxHeight)  ; Limit height to MaxHeight

Gui, -Caption
WinSet, Region, 0-0 w%Width% h%H% r6-6
Gui, Show, % "w" Width " NA" " x" (A_ScreenWidth - Width) "x10 y550"

Gui, +E0x80000
Gui, +LastFound
WinGet, WindowID, ID, A
return

GuiMove:
    PostMessage, 0xA1, 2
    return

Close:
ExitApp

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
        MsgBox, Running AFK - The Tombs - Ice Staff...
        scriptRunning := true
        SetTimer, RunScript1, 10
    }
    GuiControlGet, Script2Radio, , Script2Radio
    if (Script2Radio) {
        script1Active := false
        script2Active := true
        script3Active := false
        script4Active := false
        MsgBox, Running AFK - Citadelle - Lion Sword Room...
        scriptRunning := true
        SetTimer, RunScript2, 10
    }
    GuiControlGet, Script3Radio, , Script3Radio
    if (Script3Radio) {
        script1Active := false
        script2Active := false
        script3Active := true
        script4Active := false
        MsgBox, Running AFK - Citadelle - Directed Corner...
        scriptRunning := true
        SetTimer, RunScript3, 10
    }
    GuiControlGet, Script4Radio, , Script4Radio
    if (Script4Radio) {
        script1Active := false
        script2Active := false
        script3Active := false
        script4Active := true
        MsgBox, Running AFK - Liberty Falls - Jetgun...
        scriptRunning := true
        SetTimer, RunScript4, 10
    }
return

CheckLifeInsurance:
    GuiControlGet, ZombiesLifeInsurance, , ZombiesLifeInsurance
    if (ZombiesLifeInsurance) {
        lifeInsuranceActive := true
    } else {
        lifeInsuranceActive := false
    }

    if (lifeInsuranceActive) {
        SetTimer, LifeInsurance, 10000
    } else {
        SetTimer, LifeInsurance, Off
    }
return

LifeInsurance:
    centerX := A_ScreenWidth * 0.5
    centerY := A_ScreenHeight * 0.5

    x1 := centerX - (A_ScreenWidth * 0.1)
    y1 := centerY
    x2 := centerX + (A_ScreenWidth * 0.1)
    y2 := centerY + (A_ScreenHeight * 0.3)

    ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, *2 %imagePath%
    if (ErrorLevel = 0) {
        downedDetected := true
    }
    else {
        downedDetected := false
    }

    if (downedDetected) {
        MsgBox, Player is downed. Exiting AFK script.
        ExitApp
    }
return

RunScript1:
    if (!scriptRunning) {
        return
    }
    MsgBox, Starting AFK - The Tombs - Ice Staff script...
    Loop {
        if (!scriptRunning) {
            return
        }
        Send, {LButton Down}
        Sleep 500
        Send, {G}
        Sleep 2000
        Send, {LButton Up}
        Sleep 100

        Send, {X}
        Sleep, 2000
    }
return

RunScript2:
    if (!scriptRunning) {
        return
    }
    MsgBox, Starting AFK - Citadelle - Lion Sword Room script...
    
    ; Hold down the left mouse button continuously
    Send, {LButton Down}  ; Simulate holding down the left mouse button
    
    while (scriptRunning) {
        ; Check if the left mouse button is still down
        GetKeyState, LButtonState, LButton, P  ; Get the physical state of the left mouse button
        if (LButtonState = "U") {
            ; If the left mouse button is released, exit the loop
            MsgBox, Left mouse button was released. Exiting loop.
            scriptRunning := false  ; Stop the script from running again until F5 is pressed
            break
        }
        Sleep, 100  ; The sleep ensures the script pauses briefly between iterations
    }
    
    ; Release the left mouse button when the loop ends
    Send, {LButton Up}
    return



RunScript3:
    if (!scriptRunning) {
        return
    }
return

RunScript4:
    if (!scriptRunning) {
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
   	    ;  Sleep, 100           
   	    ;Send, {x up}  	 

  	    ;Sleep, 2500
        return
    }
return

F6::  ; Stop running script when F6 is pressed
    scriptRunning := false  ; Stop the running script
    SetTimer, RunScript1, Off
    SetTimer, RunScript2, Off
    SetTimer, RunScript3, Off
    SetTimer, RunScript4, Off
return
