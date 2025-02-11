#MaxThreadsPerHotkey, 2
Toggle := 0

F5::
Toggle := !Toggle
If (Toggle){
   Click, Down
} else {
   Click, Up
}

Return

F6::ExitApp