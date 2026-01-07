; ------------------------------------------------------------------------------
; nodejs-sea-hide-passthrough
; ------------------------------------------------------------------------------
; This script acts as a wrapper to launch a Node.js Single Executable Application (SEA)
; (or any other executable) in a hidden window, passing through all command-line arguments.
;
; It reads the target binary name from a 'config.ini' file located in the same directory.
; ------------------------------------------------------------------------------

#NoTrayIcon

; -- Configuration --
Local $sIniFile = @ScriptDir & "\config.ini"
Local $sSection = "Settings"
Local $sKey = "Target"
Local $sDefault = "app.exe"

; -- Read Config --
; Read the target executable name from config.ini.
; If the file or key doesn't exist, it defaults to $sDefault.
Local $sTargetBinary = IniRead($sIniFile, $sSection, $sKey, $sDefault)

; -- Validation --
; Construct the full path to the target binary
Local $sTargetPath = @ScriptDir & "\" & $sTargetBinary

; Check if the target file actually exists
If Not FileExists($sTargetPath) Then
	; Display an error message box if the target is missing
	; Flag 16 = Stop-sign icon (Error)
	MsgBox(16, "Launch Error", "Error: Configuration target not found." & @CRLF & @CRLF & _
			"Looking for: " & $sTargetPath & @CRLF & _
			"Please check " & $sIniFile)
	Exit 1
EndIf

; -- Argument Processing --
; Retrieve command line arguments passed to this wrapper script
; $CmdLine[0] contains the count of arguments
Local $iNumArgs = $CmdLine[0]
Local $sPassArgs = ""

; Loop through all arguments to reconstruct the parameter string
For $i = 1 To $iNumArgs
	Local $sArg = $CmdLine[$i]

	; If the argument contains spaces, wrap it in double quotes to preserve them
	If StringInStr($sArg, " ") Then
		$sArg = '"' & $sArg & '"'
	EndIf

	$sPassArgs &= $sArg & " "
Next

; Remove trailing whitespace from the arguments string
$sPassArgs = StringStripWS($sPassArgs, 2)

; -- Execution --
; Launch the target binary with the constructed arguments.
; @ScriptDir: Sets the working directory to the script's location.
; @SW_HIDE:   Hides the main window of the launched application.
ShellExecute($sTargetPath, $sPassArgs, @ScriptDir, "", @SW_HIDE)

