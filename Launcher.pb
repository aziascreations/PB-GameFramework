
;- Compiler directives

EnableExplicit

XIncludeFile "./Launcher/LauncherWindow.pbf"
XIncludeFile "./Launcher/Resolutions.pbi"
XIncludeFile "./Launcher/PreferencesHelper.pbi"

UsePNGImageDecoder()


;- Default values

; 0-Windowed 1-Fullscreen 2-Borderless
#Default_WindowMode = 0
#Default_ManualResWidth = 800
#Default_ManualResHeight = 600
#Default_LoadUncommon = #False
#Default_GameExecutable$ = "Game.exe"
#Default_GameExecutableDir$ = ".\"
#Default_ShowConsole = #False
#Default_ShowTraceLogs = #False

; This piece of code is an absolute disgrace, I don't recommend you
;  don't go trough it any further for your own sake.


;- Globals

Global LoadUncommon = #Default_LoadUncommon
Global ShowConsole = #Default_ShowConsole
Global ShowTraceLogs = #Default_ShowTraceLogs


;- Loading

Resolutions::Load()
If Not PreferencesHelper::SetupPreferences("./launcher.ini")
	MessageRequester("Error", "Unable to create config file for the launcher !")
	End 1
EndIf

OpenWindow_Launcher()
SetWindowTitle(Window_Launcher, "My title")
Global LogoImage = CatchImage(#PB_Any, ?Logo, ?LogoEnd - ?Logo)
If IsImage(LogoImage)
	SetGadgetState(Image_0, ImageID(LogoImage))
Else
	Debug "failed to load image !"
EndIf


;- Preferences parsing

Procedure SetDefaultResolutionFields(SetManualResolution.b = #False)
	If SetManualResolution
		Debug "setting default fields in ini"
		PreferencesHelper::WritePreferenceInteger("resolution-width", #Default_ManualResWidth)
		PreferencesHelper::WritePreferenceInteger("resolution-height", #Default_ManualResHeight)
	EndIf
	SetGadgetText(String_ManualResWidth,
	              Str(PreferencesHelper::ReadPreferenceInteger("resolution-width",
	                                                           #Default_ManualResWidth)))
	SetGadgetText(String_ManualResHeight,
	              Str(PreferencesHelper::ReadPreferenceInteger("resolution-height",
	                                                           #Default_ManualResHeight)))
	AddGadgetItem(Combo_AspectRatio, 0, "Custom resolution")
	SetGadgetState(Combo_AspectRatio, 0)
	AddGadgetItem(Combo_Resolution, 0, "Select an aspect ratio")
	SetGadgetState(Combo_Resolution, 0)
EndProcedure

SetGadgetState(Combo_WindowMode,
               PreferencesHelper::ReadPreferenceInteger("window-mode", #Default_WindowMode))

LoadUncommon = PreferencesHelper::ReadPreferenceBoolean("show-uncommon", #Default_LoadUncommon)


Procedure UpdateResolutionFields(SetManualResolution.b = #False)
	; TODO: Save settings
	
	; TODO: Clear shit
	
	ForEach Resolutions::Ratios()
		If Resolutions::Ratios()\Status = Resolutions::#Resolution_Uncommon And LoadUncommon = #False
			Continue
		EndIf
		
		AddGadgetItem(Combo_AspectRatio, 0,
		              Str(Resolutions::Ratios()\Width)+":"+Str(Resolutions::Ratios()\Height))
	Next
	
	; Checking if the user used a specific resolution
	If PreferencesHelper::ReadPreferenceInteger("resolution-width", 0) <> 0 And
	   PreferencesHelper::ReadPreferenceInteger("resolution-height", 0) <> 0
		Debug "Found a manual resolution !"
		SetDefaultResolutionFields()
	Else
		Debug "Didn't find a valid manual resolution"
		Define UserAspectRatio$ = PreferencesHelper::ReadPreferenceString("aspect-ratio", #Null$)
		
		If UserAspectRatio$ = #Null$
			Debug "Didn't find a valid aspect ratio"
			SetDefaultResolutionFields(#True)
		Else
			Define i.i, WasFound.b = #False
			
			For i=0 To CountGadgetItems(Combo_AspectRatio)
				If GetGadgetItemText(Combo_AspectRatio, i) = UserAspectRatio$
					WasFound = #True
					Break
				EndIf
			Next
			
			If Not WasFound
				Debug "Didn't find the desired aspect ratio"
				SetDefaultResolutionFields(#True)
			Else
				Define UserResolution$ = PreferencesHelper::ReadPreferenceString("resolution", #Null$)
				
				If UserAspectRatio$ = #Null$
					Debug "Didn't find a valid resolution"
				Else
					; TODO: Load resolution list
					WasFound = #False
				EndIf
			EndIf
		EndIf
	EndIf
EndProcedure


SetGadgetState(Checkbox_ShowLogs,
               PreferencesHelper::ReadPreferenceBoolean("show-logs", #Default_ShowConsole))
SetGadgetState(Checkbox_ShowTracing,
               PreferencesHelper::ReadPreferenceBoolean("show-trace", #Default_ShowTraceLogs))


;- Main loop

HideWindow(Window_Launcher, #False)

Define IsRunning.b = #True
Define ShouldGameRun.b = #False

Repeat
	Define Event = WindowEvent()
	
	Select Event
		Case #PB_Event_Gadget
			Define GadgetEvent = EventGadget()
			
			Select GadgetEvent
				Case Combo_WindowMode
					
				Case Combo_AspectRatio
					
				Case Combo_Resolution
					
				Case Combo_Display
					
				Case Checkbox_ShowUncommon
					PreferencesHelper::WritePreferenceBoolean("show-uncommon",
					                                          GetGadgetState(Checkbox_ShowUncommon))
					LoadUncommon = GetGadgetState(Checkbox_ShowUncommon)
					
					; TODO: Reset things
				Case Checkbox_ShowLogs
					PreferencesHelper::WritePreferenceBoolean("show-logs",
					                                          GetGadgetState(Checkbox_ShowLogs))
					ShowConsole = GetGadgetState(Checkbox_ShowLogs)
				Case Checkbox_ShowTracing
					PreferencesHelper::WritePreferenceBoolean("show-trace",
					                                          GetGadgetState(Checkbox_ShowTracing))
					ShowTraceLogs = GetGadgetState(Checkbox_ShowTracing)
				Case String_ManualResWidth
					
				Case String_ManualResHeight
					
				Case Button_Launch
					ShouldGameRun = #True
					IsRunning = #False
				Case Button_Quit
					IsRunning = #False
			EndSelect
		Case #PB_Event_CloseWindow
			IsRunning = #False
	EndSelect
	
	; Prevents the CPU from going way too fast.
	Delay(1)
Until Not IsRunning

;- End of main loop

If IsImage(LogoImage)
	FreeImage(LogoImage)
EndIf

PreferencesHelper::ClosePreferences()

Resolutions::Clean()

If ShouldGameRun
	; TODO: Run the actual game
	Debug "> "+#Default_GameExecutableDir$+#Default_GameExecutable$
EndIf

DataSection
	Logo:
	IncludeBinary "./Data/Launcher/Banner-300x150.png"
	LogoEnd:
EndDataSection
