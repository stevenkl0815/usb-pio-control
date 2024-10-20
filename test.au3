;test.au3

#include <Array.au3>
#include "LIBAD4.au3"


$AD_PORT_1 = 1
$AD_PORT_2 = 2
$AD_PORT_3 = 4
$AD_PORT_4 = 8
$AD_PORT_5 = 16
$AD_PORT_6 = 32
$AD_PORT_7 = 64
$AD_PORT_8 = 128


_AD_Startup(@ScriptDir & "\lib\libad4.dll")
If @error Then
	ConsoleWrite(StringFormat("[_AD_Startup] @error: %d, @extended: %d", @error, @extended) & @CRLF)
	Exit
EndIf


$device = _AD_Open("usb-pio")
If @error Then
	ConsoleWrite(StringFormat("[_AD_Startup] @error: %d, @extended: %d", @error, @extended) & @CRLF)
	Exit
EndIf
ConsoleWrite("Device: " & $device)


$ret1 = _AD_SetLineDirection($device, BitOr($AD_CHA_TYPE_DIGITAL_IO, 1), $AD_CHA_DIRECTION_OUTPUT)
If @error Then
	ConsoleWrite(StringFormat("[_AD_SetLineDirection] @error: %d, @extended: %d", @error, @extended) & @CRLF)
	Exit
EndIf


$ret2 = _AD_DigitalOut($device, 1, 0)
If @error Then
	ConsoleWrite(StringFormat("[_AD_DigitalOut] @error: %d, @extended: %d", @error, @extended) & @CRLF)
	Exit
EndIf

_AD_Close($device)