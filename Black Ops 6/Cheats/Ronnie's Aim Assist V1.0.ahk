#NoEnv
#SingleInstance, Force
#Persistent
#InstallKeybdHook
#UseHook
#KeyHistory, 0
#HotKeyInterval 1
#MaxHotkeysPerInterval 127
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, High

; Variables to track button states
headActive := false
chestActive := true  ; Chest is activated by default

; Dynamic width based on screen resolution
Width := A_ScreenWidth * 0.20  ; Set window width to 20% of screen width (adjust as needed)
MaxWidth := 600  ; Set a maximum width for the window
Width := (Width > MaxWidth) ? MaxWidth : Width  ; Limit the width to a maximum

; Set a max height to prevent UI truncation
MaxHeight := A_ScreenHeight * 0.50  ; Maximum height (50% of screen height)
MinHeight := 300  ; Minimum height to keep all elements visible
H := MinHeight  ; Start with min height and increase dynamically

; Calculate proportions for buttons and other elements
ButtonWidth := (Width - 14) * 0.30  ; Set button width to 40% of the window width (60% reduction)
TextWidth := Width - 14    ; Text width, adjusted to fit within the window
SmoothingButtonWidth := Width - 275  ; Smoothing buttons width
SmoothingTextWidth := Width - 100  ; Smoothing text width

Gui, +AlwaysOnTop
Gui, +LastFound
WinSet, Transparent, 220        ; Transparency of gui
Gui, Color, 808080              ; Background color of gui
Gui, Margin, 0, 0

; GUI Title - Left Aligned
Gui, Font, s10 cD0D0D0 Bold
Gui, Add, Progress, % "x-1 y-1 w" (Width+2) " h31 Background000000 Disabled hwndHPROG"
Control, ExStyle, -0x20000, , ahk_id %HPROG%
Gui, Add, Text, % "x7 y0 w" (Width - 14) " h30 BackgroundTrans Left 0x200 gGuiMove vCaption", Gekke Ronnie's - Aim Assist




; GUI Body
Gui, Font, s8
Gui, Add, CheckBox, % "x7 y+10 w" ButtonWidth "r1 +0x4000 vEnableCheckbox", Enable (F7)
Gui, Add, CheckBox, % "x+2 w" ButtonWidth "r1 +0x4000 vEnablePredictionCheckbox", Enable Prediction (F8)
; Target
Gui, Add, Text, % "x7 y+10 w" ButtonWidth "r1 +0x4000", Target Location
Gui, Add, Button, % "x7 y+5 w" ButtonWidth "r1 +0x4000 gHeadshotsButton vHeadshotsButton", Head
Gui, Add, Button, % "x+2 w" ButtonWidth "r1 +0x4000 gChestButton vChestButton", Chest

; Set default state
GuiControl,, ChestButton, "Chest (Active)"
GuiControl,, HeadshotsButton, "Head"

; Add Smoothing Control
Gui, Add, Text, % "x7 y+10 w" (SmoothingTextWidth * 0.40) "r1 +0x4000", Lissage (Default a 0.11)
Gui, Add, Text, % "x+m w" ((ButtonWidth - 14) * 0.40) "r1 +0x4000 vSmoothingValue", %smoothing%
Gui, Add, Button, % "x7 y+5 w" (SmoothingButtonWidth * 0.40) "r1 +0x4000 gDecreaseSmoothing", -
Gui, Add, Button, % "x+2+m w" (SmoothingButtonWidth * 0.40) "r1 +0x4000 gIncreaseSmoothing", +


; Close Window
Gui, Add, Button, % "x7 y+15 w" ButtonWidth "r1 +0x4000 gClose", Close Script
Gui, Add, Text, % "x7 y+30 w" "h5 vP"
GuiControlGet, P, Pos
H := PY + PH

; Adjust position to make sure F9 and F10 text are visible
Gui, Add, Text, % "x7 y" (H + -20) " w160 h30 BackgroundTrans Left", Hidden Window (F9)
Gui, Add, Text, % "x7 y" (H + -5) " w160 h30 BackgroundTrans Left", Reload Script (F10)

; Footer text (ensuring it's visible)
Gui, Add, Text, % "x7 y" (H + 25) " w160 h5 vFooter", Hidden Window (F9)
Gui, Add, Text, % "x+2 w160 h5", Reload Script (F10)


; Adjust window height dynamically
GuiControlGet, FooterPos, Pos, Footer
H := FooterPosY + 100  ; Ensures footer is inside window
H := (H > MaxHeight) ? MaxHeight : H  ; Limit height

; Adjust window region and show GUI
Gui, -Caption
WinSet, Region, 0-0 w%Width% h%H% r6-6
Gui, Show, % "w" Width " NA" " x" (A_ScreenWidth - Width) "x10 y550"

; Settings
EMCol := 0xb528c0               ; Target color c9008d
ColVn := 30                     ; Tolerance for color matching
ZeroX := A_ScreenWidth / 2      ; DO NOT CHANGE, UNIVERSAL RESOLUTION
ZeroY := A_ScreenHeight / 2.22  ; Default for Chest
CFovX := 78                     ; Adjusted for a larger FOV
CFovY := 78                     ; Adjusted for a larger FOV
ScanL := ZeroX - CFovX
ScanT := ZeroY - CFovY
ScanR := ZeroX + CFovX
ScanB := ZeroY + CFovY
SearchArea := 40                ; Smaller area around the last known position

; Variables for prediction
prevX := 0
prevY := 0
lastTime := 0
smoothing := 0.11               ; Default smoothing value
predictionMultiplier := 2.5     ; Adjust this to control how far ahead you predict

Loop
{
    ; Check if the script is enabled
    GuiControlGet, EnableState,, EnableCheckbox
    if (EnableState) {
        targetFound := False

        if GetKeyState("LButton", "P") or GetKeyState("RButton", "P") {
            ; Search for target pixel in a smaller region around the last known position
            PixelSearch, AimPixelX, AimPixelY, targetX - SearchArea, targetY - SearchArea, targetX + SearchArea, targetY + SearchArea, EMCol, ColVn, Fast RGB
            if (!ErrorLevel) {
                targetX := AimPixelX
                targetY := AimPixelY
                targetFound := True
            } else {
                PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EMCol, ColVn, Fast RGB
                if (!ErrorLevel) {
                    targetX := AimPixelX
                    targetY := AimPixelY
                    targetFound := True
                }
            }

            if (targetFound) {
                ; Get current time
                currentTime := A_TickCount

                ; Calculate the velocity of the target
                if (lastTime != 0) {
                    deltaTime := (currentTime - lastTime) / 1000.0  ; Convert to seconds
                    velocityX := (targetX - prevX) / deltaTime
                    velocityY := (targetY - prevY) / deltaTime
                }

                ; Store the current position and time for the next iteration
                prevX := targetX
                prevY := targetY
                lastTime := currentTime

                ; Apply prediction if enabled
                GuiControlGet, PredictionEnabled,, EnablePredictionCheckbox
                if (PredictionEnabled && deltaTime != 0) {
                    PredictedX := targetX + Round(velocityX * predictionMultiplier * deltaTime)
                    PredictedY := targetY + Round(velocityY * predictionMultiplier * deltaTime)
                } else {
                    PredictedX := targetX
                    PredictedY := targetY
                }

                ; Move the mouse smoothly with strength adjustment
                AimX := PredictedX - ZeroX
                AimY := PredictedY - ZeroY
                DllCall("mouse_event", uint, 1, int, Round(AimX * smoothing), int, Round(AimY * smoothing), uint, 0, int, 0)
            }
        }
    }
    Sleep, 10
}

; Button callbacks for GUI
HeadshotsButton:
    ; Change state
    headActive := true
    chestActive := false
    GuiControl,, HeadshotsButton, "Head (Active)"
    GuiControl,, ChestButton, "Chest"
    ZeroY := A_ScreenHeight / 2.18
    GuiControl,, ZeroYLabel, %ZeroY%
    Return

ChestButton:
    ; Change state
    chestActive := true
    headActive := false
    GuiControl,, ChestButton, "Chest (Active)"
    GuiControl,, HeadshotsButton, "Head"
    ZeroY := A_ScreenHeight / 2.22
    GuiControl,, ZeroYLabel, %ZeroY%
    Return

GuiMove:
    PostMessage, 0xA1, 2
    return

IncreaseSmoothing:
    smoothing += 0.01
    if (smoothing > 2)  ; Set a maximum limit for smoothing
        smoothing := 2
    GuiControl,, SmoothingValue, %smoothing%
    Return

DecreaseSmoothing:
    smoothing -= 0.01
    if (smoothing < 0.0)  ; Set a minimum limit for smoothing
        smoothing := 0.0
    GuiControl,, SmoothingValue, %smoothing%
    Return

toggle := false

if (targetFound && toggle) {
    click down
} else {
    click up
}

Paused := False

F7:: ;Enable Checkbox
    ; Toggle the Enable checkbox state
    GuiControlGet, EnableState,, EnableCheckbox
    GuiControl,, EnableCheckbox, % !EnableState
    ; Toggle the script state based on the checkbox
    toggle := EnableState
    ; Play sound
    if (!toggle) {
        SoundBeep, 400, 100
    } else {
        SoundBeep, 300, 100
    }
Return

F8:: ;Enable Checkbox
    ; Toggle the Enable checkbox state
    GuiControlGet, EnableState,, EnablePredictionCheckbox
    GuiControl,, EnablePredictionCheckbox, % !EnableState
    ; Toggle the script state based on the checkbox
    toggle := EnableState
    ; Play sound
    if (!toggle) {
        SoundBeep, 400, 100
    } else {
        SoundBeep, 300, 100
    }
Return

F9::
    if (GuiVisible) {
        Gui, Hide
        GuiVisible := false
    } else {
        Gui, Show
        GuiVisible := true
    }
return

Close:
ExitApp

F10::Reload
