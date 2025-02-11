XButton1:: ; Press Mouse4 to trigger the macro
{
    Send, {w down}  ; Hold W down
    Sleep, 200      ; Wait 200ms

    Send, {x down}  ; Hold X down
    Sleep, 100      ; Wait 100ms

    Send, {Space down}  ; Hold Space down
    Sleep, 50           ; Wait 50ms

    Send, {x up}  ; Release X
    Sleep, 50     ; Wait 50ms

    Send, {Space up}  ; Release Space
    Sleep, 100        ; Wait 100ms

    Send, {a down}  ; Hold A down
    Sleep, 100      ; Wait 100ms

    Send, {a up}  ; Release A
    Sleep, 800    ; Wait 800ms

    Send, {w up}  ; Release W
    Return
}
F7::ExitApp