Local $passthroughBinary = "\NAME_OF_YOUR_BINARY.exe" ; Binary you want to hide
Local $numArgs = $CmdLine[0] ; Get total number of args passed
Local $allArgs = "" ; Store all args here
For $i = 1 To $numArgs ; Loop through args and store them
	$allArgs &= $CmdLine[$i] & " "     ; Concatenate arg
Next
$applicationPID = ShellExecute(@ScriptDir & $passthroughBinary, $allArgs, @ScriptDir, "", @SW_HIDE) ; Shell execute binary in a hidden window
