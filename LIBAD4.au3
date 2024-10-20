;LIBAD4.au3
#include-once
#include <WinAPIError.au3>

Global $g__hLIBADDLL = 0



Global $AD_CHA_TYPE_MASK            = 0xff000000
Global $AD_CHA_TYPE_ANALOG_IN       = 0x01000000
Global $AD_CHA_TYPE_ANALOG_OUT      = 0x02000000
Global $AD_CHA_TYPE_DIGITAL_IO      = 0x03000000
Global $AD_CHA_TYPE_SYNC            = 0x05000000
Global $AD_CHA_TYPE_ROUTE           = 0x06000000
Global $AD_CHA_TYPE_CAN             = 0x07000000
Global $AD_CHA_TYPE_COUNTER         = 0x08000000
Global $AD_CHA_TYPE_ANALOG_COUNTER  = 0x09000000

Global $AD_CHA_TYPE_DIGITAL_LONG    = 0x0b000000

Global $AD_CHA_DIRECTION_INPUT      = 0xFFFF
Global $AD_CHA_DIRECTION_OUTPUT     = 0x0000


Global $tagAD_DEVICE_INFO = "STRUCT;int analog_in;int analog_out;int digital_io;int res[3];int can;int counter;ENDSTRUCT"
Global $tagAD_SAMPLE      = "STRUCT;float a;int d;ENDSTRUCT"


Func _AD_Startup($sDllPath = "libad4.dll")
	If $g__hLIBADDLL = 0 Then
		$g__hLIBADDLL = DllOpen($sDllPath)
		If $g__hLIBADDLL = -1 Then
			Return SetError(1, 0)
		EndIf
	EndIf
EndFunc


Func _AD_Shutdown()
	If $g__hLIBADDLL = -1 Then
		DllClose($g__hLIBADDLL)
	EndIf
EndFunc


Func _AD_Open($sName)
	Local $aResult = DllCall($g__hLIBADDLL, "int:cdecl", "ad_open", _
		"str", $sname)
	If $aResult[0] = -1 Then
		Return SetError(1, _WinAPI_GetLastError(), $aResult[0])
	EndIf
	Return $aResult[0]
EndFunc


Func _AD_Close($hDevice)
	Local $aResult = DllCall($g__hLIBADDLL, "int:cdecl", "ad_close", _
		"int", $hDevice)
	Return $aResult[0]
EndFunc


Func _AD_DiscreteIn($hADH, $iCHA, $iRange, $pData)
	Local $aResult = DllCall($g__hLIBADDLL, "int:cdecl", "ad_discrete_in", _
		"int", $hADH, _
		"int", $iCHA, _
		"int", $iRange, _
		"ptr", $pData)
	Return $aResult[0]
EndFunc


Func _AD_DiscreteOut($hADH, $iCHA, $iRange, $uiData)
	Local $aResult = DllCall($g__hLIBADDLL, "int:cdecl", "ad_discrete_out", _
		"int", $hADH, _
		"int", $iCHA, _
		"int", $iRange, _
		"uint", $uiData)
	Return $aResult[0]
EndFunc

; INPUT   0xFFFF
; OUTPUT  0x0000
Func _AD_SetLineDirection($hADH, $iCHA, $uiDirection)
	Local $aResult = DllCall($g__hLIBADDLL, "int:cdecl", "ad_set_line_direction", _
		"int", $hADH, _
		"int", $iCHA, _
		"uint", $uiDirection)
	Return $aResult[0]
EndFunc


Func _AD_DigitalIn($hADH, $iCHA)
	Local $tData = DllStructCreate("uint data")
	Local $aResult = DllCall($g__hLIBADDLL, "int:cdecl", "ad_digital_in", _
		"int", $hADH, _
		"int", $iCHA, _
		"ptr", DllStructGetPtr($tData))
	If $aResult[0] = 0 Then
		Return DllStructGetData($tData, 1)
	EndIf
	Return SetError(1, 1, $aResult[0])
EndFunc


Func _AD_DigitalOut($hADH, $iCHA, $uiData)
	Local $aResult = DllCall($g__hLIBADDLL, "int:cdecl", "ad_digital_out", _
		"int", $hADH, _
		"int", $iCHA, _
		"uint", $uiData)
	If $aResult[0] = 0 Then
		Return true
	EndIf
	Return SetError(1, 2, $aResult[0])
EndFunc

