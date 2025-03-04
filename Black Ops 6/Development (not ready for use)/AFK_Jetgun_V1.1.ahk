#Persistent  ; Keep the script running

F5::  ; Press F5 to start the macro
Loop
{
    ; Check if cod.exe is running
    Process, Exist, cod.exe
    if (ErrorLevel = 0)
    {
        MsgBox, The process cod.exe is not running. The script will now exit.
        ExitApp
    }
    
    Send, {e down}
    Sleep, 5000
    Send, {1}
    Sleep, 100
    Send, {e up}

    Sleep, 500
    Send, {g down}  
    Sleep, 100           
    Send, {g up}   

    Send, {g down}  
    Sleep, 100           
    Send, {g up}
    Sleep, 700

    Send, {x down}  
    Sleep, 100           
    Send, {x up}  

    Sleep, 2500
} 
return

F6::  ; Execute this part only once
Click, Left, Down
Sleep, 600
Send, {x Down}
Sleep, 100
Send, {x Up}
Sleep, 3000
Click, Left, Up
Sleep, 3500
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {w Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Send, {W Down}
Sleep, 50
Send, {v Down}
Sleep, 50
Send, {W Up}
Sleep, 50
Send, {v Up}
Sleep, 50
Sleep, 1703
Click, Left, Down
Sleep, 110
Click, Left, Up
Return

F7::ExitApp  ; Press F7 to exit the script
