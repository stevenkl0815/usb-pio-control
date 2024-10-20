#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Icon=..\..\..\Applications\AutoIt3\Icons\MyAutoIt3_Blue.ico
#AutoIt3Wrapper_Outfile=C:\Library\Projects\usb-pio-control\USB-PIO_Control_x64.a3x
#AutoIt3Wrapper_UseUpx=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;*****************************************
;USB-PIO_Control.au3 by Steven
;Created with ISN AutoIt Studio v. 1.13
;*****************************************
AutoItSetOption("GUIOnEventMode", 1)

#include <Array.au3>
#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>

#include "LIBAD4.au3"
#include "Utils.au3"
#include "FormMain.isf"


Global $Button_ON_Color  = "0x00FF80"
Global $Button_OFF_Color = "0xC0C0C0"
Global $Button_Color[2] = ["0xC0C0C0", "0x00FF80"]

Global $Label_ON_Color  = "0x00FF80"
Global $Label_OFF_Color = "0xC0C0C0"
Global $Label_Color[2] = ["0xC0C0C0", "0x00FF80"]

Global $FormTitleTemplate = "USB-PIO Control (Device S/N: %s)"


Global $aChannels_Ports[3][8] = [ _
	[0, 0, 0, 0, 0, 0, 0, 0], _
	[0, 0, 0, 0, 0, 0, 0, 0], _
	[0, 0, 0, 0, 0, 0, 0, 0] _
]

Global $usbpio = Null
Global $bProcessingRules = False

Main()



Func Main()
	$bProcessingRules = _ToBool(IniRead(@ScriptDir & "\config.ini", "rules", "enabled", "false"))
	$sSerial = IniRead(@ScriptDir & "\config.ini", "device", "serial", "n/a")
	WinSetTitle($FormMain, "", StringFormat($FormTitleTemplate, $sSerial))
	_ShowGui()

	_AD_Startup(@ScriptDir & "\lib\libad4.dll")

	$usbpio = _AD_Open("usb-pio")
	If @error Then
		MsgBox( _
			$MB_OK+$MB_ICONERROR, _
			"Error", _
			StringFormat("Error connecting to USB-PIO.\r\nCode: %d\r\nMessage: %s", @extended, _WinAPI_GetLastErrorMessage()), _
			0, _
			$FormMain _
		)
		Exit
	EndIf

	_AD_SetLineDirection($usbpio, BitOr($AD_CHA_TYPE_DIGITAL_IO, 1), $AD_CHA_DIRECTION_OUTPUT)
	_AD_SetLineDirection($usbpio, BitOr($AD_CHA_TYPE_DIGITAL_IO, 2), $AD_CHA_DIRECTION_INPUT)

	_AD_DigitalOut($usbpio, 1, 0)

	While 1
		Sleep(250)
		_ProcessInput()
		_ProcessRules()
		_ProcessOutput()
		_UpdateGUI()
	Wend
EndFunc


Func _ProcessInput()
	_ReadData()
EndFunc


Func _ProcessRules()
	If $bProcessingRules Then

	EndIf
EndFunc


Func _ProcessOutput()
	_UpdateData()
EndFunc


Func _UpdateGUI()
	If Not BitAND(WinGetState($FormMain), $WIN_STATE_MINIMIZED) Then
		_SetButtonColors()
		_SetLabelColors()
	EndIf
EndFunc


Func _UpdateData()
	Local $iData = 0

	If $aChannels_Ports[0][0] = 1 Then $iData = $iData + 1
	If $aChannels_Ports[0][1] = 1 Then $iData = $iData + 2
	If $aChannels_Ports[0][2] = 1 Then $iData = $iData + 4
	If $aChannels_Ports[0][3] = 1 Then $iData = $iData + 8
	If $aChannels_Ports[0][4] = 1 Then $iData = $iData + 16
	If $aChannels_Ports[0][5] = 1 Then $iData = $iData + 32
	If $aChannels_Ports[0][6] = 1 Then $iData = $iData + 64
	If $aChannels_Ports[0][7] = 1 Then $iData = $iData + 128

	_AD_DigitalOut($usbpio, 1, $iData)
EndFunc


Func _ReadData()
	local $iData = _AD_DigitalIn($usbpio, 2)

	Local $aValues[8] = [1, 2, 4, 8, 16, 32, 64, 128]
	For $i = 0 To UBound($aValues) - 1
		$aChannels_Ports[1][$i] = BitAND($iData, $aValues[$i]) ? 1 : 0
	Next

EndFunc


Func _SetButtonColors()
	For $port = 0 to 7
		$button = Eval("btn_port_1_" & ($port+1))
		GUICtrlSetBkColor($button, $Button_Color[$aChannels_Ports[0][$port]])
	Next
EndFunc


Func _SetLabelColors()
	For $port = 0 to 7
		$label = Eval("lbl_port_2_" & ($port+1))
		GUICtrlSetBkColor($label, $Label_Color[$aChannels_Ports[1][$port]])
	Next
EndFunc


Func _ShowGui()
	GUISetState(@SW_SHOW, $FormMain)
EndFunc


Func _EXIT()
	GUISetState(@SW_HIDE, $FormMain)
	_AD_DigitalOut($usbpio, 1, 0)
	_AD_Close($usbpio)
	_AD_Shutdown()
	Exit
EndFunc


Func Toggle_1_1()
	ToggleButton(0)
EndFunc
Func Toggle_1_2()
	ToggleButton(1)
EndFunc
Func Toggle_1_3()
	ToggleButton(2)
EndFunc
Func Toggle_1_4()
	ToggleButton(3)
EndFunc
Func Toggle_1_5()
	ToggleButton(4)
EndFunc
Func Toggle_1_6()
	ToggleButton(5)
EndFunc
Func Toggle_1_7()
	ToggleButton(6)
EndFunc
Func Toggle_1_8()
	ToggleButton(7)
EndFunc
Func ToggleButton($iPort)
	$aChannels_Ports[0][$iPort] = Number(not $aChannels_Ports[0][$iPort])
EndFunc
