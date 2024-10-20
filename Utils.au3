;Utils.au3

Func _ToBool($sInput)
	Switch StringUpper($sInput)
		
		Case "1", "TRUE", "ON"
			Return True
		Case "0", "FALSE", "OFF"
			Return False
		Case Else
			Return SetError(1, 0, False)

	EndSwitch
EndFunc