
EnableExplicit

XIncludeFile "./Launcher/LauncherWindow.pbf"
XIncludeFile "./Launcher/Resolutions.pbi"
XIncludeFile "./Launcher/PreferencesHelper.pbi"

UsePNGImageDecoder()

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


; TODO prepare the settings.



Define IsRunning.b = #True

Repeat
	Define Event = WindowEvent()
	
	Select Event
		Case #PB_Event_Gadget
			Define GadgetEvent = EventGadget()
			
			Select GadgetEvent
					
			EndSelect
			
			
		Case #PB_Event_CloseWindow
			IsRunning = #False
	EndSelect
	
	; Prevents the CPU from going way too fast.
	Delay(1)
Until Not IsRunning







If IsImage(LogoImage)
	FreeImage(LogoImage)
EndIf

PreferencesHelper::ClosePreferences()

Resolutions::Clean()

DataSection
	Logo:
	IncludeBinary "./Data/Launcher/Banner-300x150.png"
	LogoEnd:
EndDataSection
