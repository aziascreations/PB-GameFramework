
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf

CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
	CompilerError "Unable to XInput module for an OS that isn't Windows !"
CompilerEndIf

CompilerIf Not Defined(FRAMEWORK_MODULE_XINPUT, #PB_Constant)
	CompilerError "The #FRAMEWORK_MODULE_XINPUT constant is not defined !"
CompilerEndIf

EnableExplicit


;- Notes

; Translated from xinput.h from the Windows SDK 10.0.19041.0


;- Module

DeclareModule XInput
	;-> Constants
	
	; Device types available in XINPUT_CAPABILITIES
	#XINPUT_DEVTYPE_GAMEPAD         = $01
	
	; Device subtypes available in XINPUT_CAPABILITIES
	#XINPUT_DEVSUBTYPE_GAMEPAD          = $01
	
	#XINPUT_DEVSUBTYPE_UNKNOWN          = $00
	#XINPUT_DEVSUBTYPE_WHEEL            = $02
	#XINPUT_DEVSUBTYPE_ARCADE_STICK     = $03
	#XINPUT_DEVSUBTYPE_FLIGHT_STICK     = $04
	#XINPUT_DEVSUBTYPE_DANCE_PAD        = $05
	#XINPUT_DEVSUBTYPE_GUITAR           = $06
	#XINPUT_DEVSUBTYPE_GUITAR_ALTERNATE = $07
	#XINPUT_DEVSUBTYPE_DRUM_KIT         = $08
	#XINPUT_DEVSUBTYPE_GUITAR_BASS      = $0B
	#XINPUT_DEVSUBTYPE_ARCADE_PAD       = $13
	
	; Flags for XINPUT_CAPABILITIES
	#XINPUT_CAPS_VOICE_SUPPORTED    = $0004
	
	#XINPUT_CAPS_FFB_SUPPORTED      = $0001
	#XINPUT_CAPS_WIRELESS           = $0002
	#XINPUT_CAPS_PMD_SUPPORTED      = $0008
	#XINPUT_CAPS_NO_NAVIGATION      = $0010
	
	; Constants for gamepad buttons
	#XINPUT_GAMEPAD_DPAD_UP         = $0001
	#XINPUT_GAMEPAD_DPAD_DOWN       = $0002
	#XINPUT_GAMEPAD_DPAD_LEFT       = $0004
	#XINPUT_GAMEPAD_DPAD_RIGHT      = $0008
	#XINPUT_GAMEPAD_START           = $0010
	#XINPUT_GAMEPAD_BACK            = $0020
	#XINPUT_GAMEPAD_LEFT_THUMB      = $0040
	#XINPUT_GAMEPAD_RIGHT_THUMB     = $0080
	#XINPUT_GAMEPAD_LEFT_SHOULDER   = $0100
	#XINPUT_GAMEPAD_RIGHT_SHOULDER  = $0200
	#XINPUT_GAMEPAD_A               = $1000
	#XINPUT_GAMEPAD_B               = $2000
	#XINPUT_GAMEPAD_X               = $4000
	#XINPUT_GAMEPAD_Y               = $8000
	
	; Gamepad thresholds
	#XINPUT_GAMEPAD_LEFT_THUMB_DEADZONE  = 7849
	#XINPUT_GAMEPAD_RIGHT_THUMB_DEADZONE = 8689
	#XINPUT_GAMEPAD_TRIGGER_THRESHOLD    = 30
	
	; Flags To pass To XInputGetCapabilities
	#XINPUT_FLAG_GAMEPAD            = $00000001
	
	; Devices that support batteries
	#BATTERY_DEVTYPE_GAMEPAD        = $00
	#BATTERY_DEVTYPE_HEADSET        = $01
	
	; Flags for battery status level
	#BATTERY_TYPE_DISCONNECTED      = $00
	#BATTERY_TYPE_WIRED             = $01
	#BATTERY_TYPE_ALKALINE          = $02
	#BATTERY_TYPE_NIMH              = $03
	#BATTERY_TYPE_UNKNOWN           = $FF
	
	; These are only valid for wireless, connected devices, with known battery types
	; The amount of use time remaining depends on the type of device.
	#BATTERY_LEVEL_EMPTY            = $00
	#BATTERY_LEVEL_LOW              = $01
	#BATTERY_LEVEL_MEDIUM           = $02
	#BATTERY_LEVEL_FULL             = $03
	
	; User index definitions
	#XUSER_MAX_COUNT                = 4
	
	#XUSER_INDEX_ANY                = $000000FF
	
	; Codes returned for the gamepad keystroke
	#VK_PAD_A                       = $5800
	#VK_PAD_B                       = $5801
	#VK_PAD_X                       = $5802
	#VK_PAD_Y                       = $5803
	#VK_PAD_RSHOULDER               = $5804
	#VK_PAD_LSHOULDER               = $5805
	#VK_PAD_LTRIGGER                = $5806
	#VK_PAD_RTRIGGER                = $5807
	#VK_PAD_DPAD_UP                 = $5810
	#VK_PAD_DPAD_DOWN               = $5811
	#VK_PAD_DPAD_LEFT               = $5812
	#VK_PAD_DPAD_RIGHT              = $5813
	#VK_PAD_START                   = $5814
	#VK_PAD_BACK                    = $5815
	#VK_PAD_LTHUMB_PRESS            = $5816
	#VK_PAD_RTHUMB_PRESS            = $5817
	#VK_PAD_LTHUMB_UP               = $5820
	#VK_PAD_LTHUMB_DOWN             = $5821
	#VK_PAD_LTHUMB_RIGHT            = $5822
	#VK_PAD_LTHUMB_LEFT             = $5823
	#VK_PAD_LTHUMB_UPLEFT           = $5824
	#VK_PAD_LTHUMB_UPRIGHT          = $5825
	#VK_PAD_LTHUMB_DOWNRIGHT        = $5826
	#VK_PAD_LTHUMB_DOWNLEFT         = $5827
	#VK_PAD_RTHUMB_UP               = $5830
	#VK_PAD_RTHUMB_DOWN             = $5831
	#VK_PAD_RTHUMB_RIGHT            = $5832
	#VK_PAD_RTHUMB_LEFT             = $5833
	#VK_PAD_RTHUMB_UPLEFT           = $5834
	#VK_PAD_RTHUMB_UPRIGHT          = $5835
	#VK_PAD_RTHUMB_DOWNRIGHT        = $5836
	#VK_PAD_RTHUMB_DOWNLEFT         = $5837
	
	; Flags used in XINPUT_KEYSTROKE
	#XINPUT_KEYSTROKE_KEYDOWN       = $0001
	#XINPUT_KEYSTROKE_KEYUP         = $0002
	#XINPUT_KEYSTROKE_REPEAT        = $0004
	
	
	;-> Structures
	
	; Note: Other people used .b but in xinput.h the type is BYTE which is the same an unsigned char...
	;       Might not be important here since these variables are mostly used for bitmasks.
	
	Structure XINPUT_GAMEPAD
		wButtons.u      ; ### Bitmask of the device digital buttons, as follows. A set bit indicates that the corresponding button is pressed.
		bLeftTrigger.a	; Current value of the left trigger. (Range: 0 to 255)
		bRightTrigger.a	; Current value of the right trigger. (Range: 0 to 255)
		sThumbLX.w		; 
		sThumbLY.w		; Left thumbstick y-axis. (Range: -32768 to 32767)
		sThumbRX.w		; Right thumbstick x-axis. (Range: -32768 to 32767)
		sThumbRY.w		; Right thumbstick y-axis. (Range: -32768 to 32767)
	EndStructure
	
	Structure XINPUT_STATE
		dwPacketNumber.l ; Was an unsigned long, not long in the .h file
		Gamepad.XINPUT_GAMEPAD
	EndStructure
	
	Structure XINPUT_VIBRATION
		wLeftMotorSpeed.u
		wRightMotorSpeed.u
	EndStructure
	
	; Defines the structure for what kind of abilities the joystick has
	;  such abilities are things such As if the joystick has the ability
	;  to send and receive audio, if the joystick is in fact a driving
	;  wheel or perhaps if the joystick is some kind of dance pad Or
	;  guitar.
	Structure XINPUT_CAPABILITIES
		Type.a
		SubType.a
		Flags.u
		Gamepad.XINPUT_GAMEPAD
		Vibration.XINPUT_VIBRATION
	EndStructure
	
	Structure XINPUT_BATTERY_INFORMATION
		BatteryType.a
		BatteryLevel.a
	EndStructure
	
	Structure XINPUT_KEYSTROKE
		VirtualKey.u
		Unicode.u ; WCHAR - "unsigned short is the WCHAR Windows UNICODE type" - http://blog.kowalczyk.info/archives/2006/01/
				  ; Taken from "https://www.purebasic.fr/english/viewtopic.php?f=12&t=24087"
				  ;  where a signed short (.w) was used...
		Flags.u
		UserIndex.a
		HidCode.a
	EndStructure
	
	
	;-> Prototype
	
	; Sets the reporting state of XInput.
	Prototype _XInputEnable(enable.b)
	Global XInputEnable._XInputEnable
	
	; Retrieves the sound rendering and sound capture audio device IDs that are
	;  associated with the headset connected to the specified controller.
	Prototype.l _XInputGetAudioDeviceIds(dwUserIndex.l, pRenderDeviceId.s, *pRenderCount, pCaptureDeviceId.s, *pCaptureCount)
	Global XInputGetAudioDeviceIds._XInputGetAudioDeviceIds
	; UINT *pRenderCount !!!!!!!!!!!!!!
	
	; Retrieves the battery type and charge status of a wireless controller.
	Prototype.l _XInputGetBatteryInformation(dwUserIndex.l, devType.b, *pBatteryInformation.XINPUT_BATTERY_INFORMATION)
	Global XInputGetBatteryInformation._XInputGetBatteryInformation
	
	; Retrieves the capabilities and features of a connected controller.
	Prototype.l _XInputGetCapabilities(dwUserIndex.l, dwFlags.l, *pCapabilities.XINPUT_CAPABILITIES)
	Global XInputGetCapabilities._XInputGetCapabilities
	
	; Gets the sound rendering and sound capture device GUIDs that are associated
	;  with the headset connected to the specified controller.
	Prototype.l _XInputGetDSoundAudioDeviceGuids(dwUserIndex.l, *pDSoundRenderGuid, *pDSoundCaptureGuid)
	Global XInputGetDSoundAudioDeviceGuids._XInputGetDSoundAudioDeviceGuids
	
	; Retrieves a gamepad input event.
	Prototype.l _XInputGetKeystroke(dwUserIndex.l, dwReserved.l, *pKeystroke.XINPUT_KEYSTROKE)
	Global XInputGetKeystroke._XInputGetKeystroke
	
	; Retrieves the current state of the specified controller.
	Prototype.l _XInputGetState(dwUserIndex.l, *pState.XINPUT_STATE)
	Global XInputGetState._XInputGetState
	
	; Sends data to a connected controller.
	; This function is used to activate the vibration function of a controller.
	Prototype.l _XInputSetState(dwUserIndex.l, *pVibration.XINPUT_VIBRATION)
	Global XInputSetState._XInputSetState
	
	
	;-> Custom Stuff
	
	Enumeration _XInput
		#XINPUT_ERROR_LIBRARY_NOT_LOADED = 1
		#XINPUT_ERROR_FAILURE_TO_LOAD_FROM_LIBRARY = 2
	EndEnumeration
	
	; What is XInputUap.dll ??? - Universal App Platform or some shit ?
	; Has the same stuff as 1.4.
	
	Enumeration _XInputVersions
		#XINPUT_VERSION_1_0	; -> xinput9_1_0.dll (???)
		#XINPUT_VERSION_1_1	; -> xinput1_1.dll (DirectX SDK)
		#XINPUT_VERSION_1_2	; -> xinput1_2.dll (DirectX SDK)
		#XINPUT_VERSION_1_3	; -> xinput1_3.dll (DirectX SDK)
		#XINPUT_VERSION_1_4	; -> XInput1_4.dll (Windows 8+)
							; Taken as default since W7 is deprecated as of 2020.
	EndEnumeration
	
	#XINPUT_VERSION_LATEST = #XINPUT_VERSION_1_4
	
	Global XInputLoadedVersion$ = "0.0"
	Global XInputLoadedVersion.i = 0
	
	Macro GetLoadedXInputVersionString() : XInputLoadedVersion$ : EndMacro
	Macro GetLoadedXInputVersion() : XInputLoadedVersion : EndMacro
	
	Declare InitXInput(MaxVersion = #XINPUT_VERSION_LATEST, MinVersion = #XINPUT_VERSION_LATEST)
	Declare LoadXInputFunctions(XInputLibraryID)
	Declare CloseXInputLibrary(XInputLibraryID)
EndDeclareModule

Module XInput
	;-> Module
	
	; Returns the library ID if it was loaded successfully, or zero otherwise.
	Procedure InitXInput(MaxVersion = #XINPUT_VERSION_LATEST, MinVersion = #XINPUT_VERSION_LATEST)
		CompilerIf Not #PB_Compiler_OS = #PB_OS_Windows
			DebuggerWarning("Tried to load the XInput library on a non-windows OS !")
			CompilerWarning("Compiling XInput stuff for non-windows OS !")
			ProcedureReturn #False
		CompilerElse ; #PB_Compiler_OS = #PB_OS_Windows is implied
			Protected XInputLibraryID = 0
			
			If XInputLibraryID = 0 And MaxVersion >= #XINPUT_VERSION_1_4 
				XInputLibraryID = OpenLibrary(#PB_Any, "XInput1_4.dll")
				XInputLoadedVersion$ = "1.4"
				XInputLoadedVersion = #XINPUT_VERSION_1_4
			EndIf
			
			If XInputLibraryID = 0 And MaxVersion >= #XINPUT_VERSION_1_3
				XInputLibraryID = OpenLibrary(#PB_Any, "xinput1_3.dll")
				XInputLoadedVersion$ = "1.3"
				XInputLoadedVersion = #XINPUT_VERSION_1_3
			EndIf
			
			If XInputLibraryID = 0 And MaxVersion >= #XINPUT_VERSION_1_2
				XInputLibraryID = OpenLibrary(#PB_Any, "xinput1_2.dll")
				XInputLoadedVersion$ = "1.2"
				XInputLoadedVersion = #XINPUT_VERSION_1_2
			EndIf
			
			If XInputLibraryID = 0 And MaxVersion >= #XINPUT_VERSION_1_1
				XInputLibraryID = OpenLibrary(#PB_Any, "xinput1_1.dll")
				XInputLoadedVersion$ = "1.1"
				XInputLoadedVersion = #XINPUT_VERSION_1_1
			EndIf
			
			If XInputLibraryID = 0 And MaxVersion >= #XINPUT_VERSION_1_0
				XInputLibraryID = OpenLibrary(#PB_Any, "xinput9_1_0.dll")
				XInputLoadedVersion$ = "1.0"
				XInputLoadedVersion = #XINPUT_VERSION_1_0
			EndIf
			
			If XInputLibraryID = 0
				XInputLoadedVersion$ = "0.0"
				XInputLoadedVersion = 0
				
				Debug "Failed to open XInput library !"
				
				ProcedureReturn #False
			EndIf
			
			ProcedureReturn XInputLibraryID
		CompilerEndIf
	EndProcedure
	
	; Returns non-zero if an error occured
	Procedure LoadXInputFunctions(XInputLibraryID)
		If Not IsLibrary(XInputLibraryID)
			ProcedureReturn #XINPUT_ERROR_LIBRARY_NOT_LOADED
		EndIf
		
		If XInputLoadedVersion >= #XINPUT_VERSION_1_0
			XInputGetCapabilities = GetFunction(XInputLibraryID, "XInputGetCapabilities")
			XInputGetState = GetFunction(XInputLibraryID, "XInputGetState")
			XInputSetState = GetFunction(XInputLibraryID, "XInputSetState")
			
			; Was deprecated in 1.4
			; FIXME: not checked, but assumed to be loaded if all others were.
			If XInputLoadedVersion < #XINPUT_VERSION_1_4
				XInputGetDSoundAudioDeviceGuids = GetFunction(XInputLibraryID, "XInputGetDSoundAudioDeviceGuids")
			EndIf
			
			If XInputGetCapabilities = #Null Or XInputGetState = #Null Or XInputSetState = #Null
				XInputGetCapabilities = #Null
				XInputGetDSoundAudioDeviceGuids = #Null
				XInputGetState = #Null
				XInputSetState = #Null
				
				ProcedureReturn #XINPUT_ERROR_FAILURE_TO_LOAD_FROM_LIBRARY
			EndIf
			
			If XInputLoadedVersion >= #XINPUT_VERSION_1_4
				; Is present from 1.1 onward but doesn't seem to be officially.
				XInputEnable = GetFunction(XInputLibraryID, "XInputEnable")
				
				; Is present from 1.3 onward but doesn't seem to be officially. - You can't read shit dickhead.
				XInputGetBatteryInformation = GetFunction(XInputLibraryID, "XInputGetBatteryInformation")
				XInputGetKeystroke = GetFunction(XInputLibraryID, "XInputGetKeystroke")
				
				; Replaces "XInputGetDSoundAudioDeviceGuids" from 1.4 onward
				XInputGetAudioDeviceIds = GetFunction(XInputLibraryID, "XInputGetAudioDeviceIds")
				
				If XInputEnable = #Null Or XInputGetAudioDeviceIds = #Null Or XInputGetBatteryInformation = #Null Or
				   XInputGetKeystroke = #Null
					XInputGetCapabilities = #Null
					XInputGetDSoundAudioDeviceGuids = #Null
					XInputGetState = #Null
					XInputSetState = #Null
					
					XInputEnable = #Null
					XInputGetAudioDeviceIds = #Null
					XInputGetBatteryInformation = #Null
					XInputGetKeystroke = #Null
					
					ProcedureReturn #XINPUT_ERROR_FAILURE_TO_LOAD_FROM_LIBRARY
				EndIf
			EndIf
		EndIf
		
		ProcedureReturn #False
	EndProcedure
	
	Procedure CloseXInputLibrary(XInputLibraryID)
		If IsLibrary(XInputLibraryID)
			XInputLoadedVersion$ = "0.0"
			XInputLoadedVersion = 0
			
			XInputEnable = #Null
			XInputGetCapabilities = #Null
			XInputGetDSoundAudioDeviceGuids = #Null
			XInputGetState = #Null
			XInputSetState = #Null
			XInputGetAudioDeviceIds = #Null
			XInputGetBatteryInformation = #Null
			XInputGetKeystroke = #Null
			
			CloseLibrary(XInputLibraryID)
			
			ProcedureReturn #False
		Else
			ProcedureReturn #XINPUT_ERROR_LIBRARY_NOT_LOADED
		EndIf
	EndProcedure
EndModule
