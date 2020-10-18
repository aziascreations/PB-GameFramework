
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf

CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
	CompilerError "Unable to XInput module for an OS that isn't Windows !"
CompilerEndIf

CompilerIf Not Defined(FRAMEWORK_MODULE_XINPUT, #PB_Constant)
	CompilerError "The #FRAMEWORK_MODULE_XINPUT constant is not defined !"
CompilerEndIf

XIncludeFile "./XInput.pbi"


;- Notes

; TODO: Make it so that the screens module is required.

; FIXME: Misses button presses if the user is mashing them...


;- Module

DeclareModule ControllerManager
	CompilerIf Not Defined(ERROR_DEVICE_NOT_CONNECTED, #PB_Constant)
		#ERROR_DEVICE_NOT_CONNECTED = 1167
	CompilerEndIf
	
	Declare.b Update()
EndDeclareModule

Module ControllerManager
	EnableExplicit
	
	Structure InternalControllerInfo
		LastControllerState.XInput::XINPUT_STATE
		LastPacketNumber.l
	EndStructure
	
	Global TempControllerState.XInput::XINPUT_STATE
	
	Global Controller1.InternalControllerInfo
	Global Controller2.InternalControllerInfo
	Global Controller3.InternalControllerInfo
	Global Controller4.InternalControllerInfo
	
	Procedure.b CheckController(dwUserIndex.l, *CurrentControllerInfo.InternalControllerInfo,
	                            *TempControllerInfo.XInput::XINPUT_STATE)
		If *CurrentControllerInfo And *TempControllerInfo
			If XInput::XInputGetState(dwUserIndex, *TempControllerInfo) = #ERROR_SUCCESS
				If *CurrentControllerInfo\LastPacketNumber <> *TempControllerInfo\dwPacketNumber
					*CurrentControllerInfo\LastPacketNumber = *TempControllerInfo\dwPacketNumber
					ProcedureReturn #True
				EndIf
			EndIf
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure.b ProcessControllerChange(dwUserIndex.l, *CurrentControllerInfo.InternalControllerInfo,
	                                    *TempControllerInfo.XInput::XINPUT_STATE)
		Protected HasDoneSomething.b = #False
		
		If *CurrentControllerInfo And *TempControllerInfo
			If *CurrentControllerInfo\LastControllerState\Gamepad\wButtons <> *TempControllerInfo\Gamepad\wButtons
				; We get a bitmask of the button(s?) that changed
				Protected ChangedButtons.w = *CurrentControllerInfo\LastControllerState\Gamepad\wButtons ! *TempControllerInfo\Gamepad\wButtons
				
				; We make a bitwise AND, and if it is != 0 it means the button was pressed.
				If ChangedButtons & *TempControllerInfo\Gamepad\wButtons
					If ScreenManager::*CurrentScreen\OnControllerButtonDown
						CallFunctionFast(ScreenManager::*CurrentScreen\OnControllerButtonDown,
						                 dwUserIndex, ChangedButtons)
					EndIf
				Else
					If ScreenManager::*CurrentScreen\OnControllerButtonUp
						CallFunctionFast(ScreenManager::*CurrentScreen\OnControllerButtonUp,
						                 dwUserIndex, ChangedButtons)
					EndIf
				EndIf
				
				HasDoneSomething = #True
			EndIf
			
			If *CurrentControllerInfo\LastControllerState\Gamepad\bLeftTrigger <> *TempControllerInfo\Gamepad\bLeftTrigger
				;Debug "bLeftTrigger"
				HasDoneSomething = #True
			EndIf
			
			If *CurrentControllerInfo\LastControllerState\Gamepad\bRightTrigger <> *TempControllerInfo\Gamepad\bRightTrigger
				;Debug "bRightTrigger"
				HasDoneSomething = #True
			EndIf
			
			If *CurrentControllerInfo\LastControllerState\Gamepad\sThumbLX <> *TempControllerInfo\Gamepad\sThumbLX
				;Debug "sThumbLX"
				HasDoneSomething = #True
			EndIf
			
			If *CurrentControllerInfo\LastControllerState\Gamepad\sThumbLY <> *TempControllerInfo\Gamepad\sThumbLY
				;Debug "sThumbLY"
				HasDoneSomething = #True
			EndIf
			
			If *CurrentControllerInfo\LastControllerState\Gamepad\sThumbRX <> *TempControllerInfo\Gamepad\sThumbRX
				;Debug "sThumbRX"
				HasDoneSomething = #True
			EndIf
			
			If *CurrentControllerInfo\LastControllerState\Gamepad\sThumbRY <> *TempControllerInfo\Gamepad\sThumbRY
				;Debug "sThumbRY"
				HasDoneSomething = #True
			EndIf
			
			If HasDoneSomething
				CopyMemory(*TempControllerInfo, @*CurrentControllerInfo\LastControllerState,
				           SizeOf(XInput::XINPUT_STATE))
			EndIf
		EndIf
		
		ProcedureReturn HasDoneSomething
	EndProcedure
	
	Procedure.b Update()
		Protected HasDoneSomething.b = #False
		
		If CheckController(0, @Controller1, @TempControllerState)
			ProcessControllerChange(0, @Controller1, @TempControllerState)
			HasDoneSomething = #True
		EndIf
		
		If CheckController(1, @Controller2, @TempControllerState)
			ProcessControllerChange(0, @Controller2, @TempControllerState)
			HasDoneSomething = #True
		EndIf
		
		If CheckController(2, @Controller3, @TempControllerState)
			ProcessControllerChange(0, @Controller3, @TempControllerState)
			HasDoneSomething = #True
		EndIf
		
		If CheckController(3, @Controller4, @TempControllerState)
			ProcessControllerChange(0, @Controller4, @TempControllerState)
			HasDoneSomething = #True
		EndIf
		
		ProcedureReturn HasDoneSomething
	EndProcedure
EndModule
