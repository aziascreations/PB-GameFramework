
EnableExplicit

DeclareModule Resolutions
	Enumeration ResolutionStatus
		#Resolution_EndOfAspect
		#Resolution_EndOfResolutionTable
		#Resolution_Common
		#Resolution_Uncommon
	EndEnumeration
	
	Structure Resolution
		Status.b
		Width.u
		Height.u
		Name$
	EndStructure
	
	Structure AspectRatio Extends Resolution
		List Resolutions.Resolution()
	EndStructure
	
	Global NewList Ratios.AspectRatio()
	
	Declare Load()
	Declare Clean()
EndDeclareModule

Module Resolutions
	EnableExplicit
	
	Macro _AspectRatio(Width, Height, Status, Name=#Null$)
		Data.b Status
		Data.u Width, Height
		Data.s Name
	EndMacro
	
	Macro _Resolution(Width, Height, Status, Name=#Null$)
		_AspectRatio(Width, Height, Status, Name)
	EndMacro
	
	Macro _EndAspectRatio()
		Data.b #Resolution_EndOfAspect
	EndMacro
	
	Macro _EndAspectRatioTable()
		Data.b #Resolution_EndOfResolutionTable
	EndMacro
	
	Procedure Load()
		Restore ResolutionTable:
		
		Debug "Reading resolution list..."
		
		Define IsDoneParsingResolutions.b = #False
		Define IsReadingResolutions.b = #False
		
		Repeat
			Define ReadStatus.b
			
			Read.b ReadStatus
			
			If ReadStatus = #Resolution_EndOfResolutionTable
				IsDoneParsingResolutions = #True
			ElseIf ReadStatus = #Resolution_EndOfAspect
				IsReadingResolutions = #False
			Else
				If IsReadingResolutions
					AddElement(Ratios()\Resolutions())
					Ratios()\Resolutions()\Status = ReadStatus
					Read.u Ratios()\Resolutions()\Width
					Read.u Ratios()\Resolutions()\Height
					Read.s Ratios()\Resolutions()\Name$
				Else
					AddElement(Ratios())
					Ratios()\Status = ReadStatus
					Read.u Ratios()\Width
					Read.u Ratios()\Height
					Read.s Ratios()\Name$
					IsReadingResolutions = #True
				EndIf
			EndIf 
		Until IsDoneParsingResolutions
		
		Debug "Done !"
	EndProcedure
	
	Procedure Clean()
		ForEach Ratios()
			FreeList(Ratios()\Resolutions())
		Next
		
		FreeList(Ratios())
	EndProcedure
	
	DataSection
		ResolutionTable:
		_AspectRatio(1, 1, #Resolution_Uncommon)
		_Resolution(16, 16, #Resolution_Uncommon, "0.26K1")
		_Resolution(32, 32, #Resolution_Uncommon, "1.02K1")
		_Resolution(64, 64, #Resolution_Uncommon, "4.1K1")
		_Resolution(96, 96, #Resolution_Uncommon, "0.01M1")
		_Resolution(128, 128, #Resolution_Uncommon, "0.02M1")
		_Resolution(160, 160, #Resolution_Uncommon, "0.03M1")
		_Resolution(208, 208, #Resolution_Uncommon, "0.04M1")
		_Resolution(240, 240, #Resolution_Uncommon, "0.06M1")
		_Resolution(256, 256, #Resolution_Uncommon, "0.07M1")
		_Resolution(320, 320, #Resolution_Uncommon, "0.1M1")
		_Resolution(1024, 1024, #Resolution_Uncommon, "1.05M1:1")
		_Resolution(1440, 1440, #Resolution_Uncommon, "2.07M1")
		_Resolution(8192, 8192, #Resolution_Uncommon, "8K Fulldome")
		_EndAspectRatio()
		
		_AspectRatio(4, 3, #Resolution_Common)
		_Resolution(60, 120, #Resolution_Uncommon, "QQVGA")
		_Resolution(320, 240, #Resolution_Uncommon, "QVGA")
		_Resolution(640, 480, #Resolution_Common, "VGA")
		_Resolution(800, 600, #Resolution_Common, "SVGA")
		_Resolution(1024, 768, #Resolution_Common, "XGA")
		_Resolution(1152, 864, #Resolution_Common, "XGA+")
		_Resolution(2048, 1536, #Resolution_Uncommon, "QXGA")
		_Resolution(3200, 2400, #Resolution_Uncommon, "QUXGA")
		_Resolution(4096, 3072, #Resolution_Uncommon, "HXGA")
		_Resolution(6400, 4800, #Resolution_Uncommon, "HUXGA")
		_EndAspectRatio()
		
		_AspectRatio(16, 9, #Resolution_Common)
		_Resolution(256, 144, #Resolution_Uncommon)
		_Resolution(426, 240, #Resolution_Uncommon, "240p")
		_Resolution(640, 360, #Resolution_Uncommon, "360p, nHD")
		_Resolution(768, 432, #Resolution_Uncommon)
		_Resolution(800, 450, #Resolution_Uncommon)
		_Resolution(848, 480, #Resolution_Uncommon, "FWVGA")
		_Resolution(854, 480, #Resolution_Uncommon, "480p, SD")
		_Resolution(960, 540, #Resolution_Uncommon, "qHD")
		_Resolution(1024, 576, #Resolution_Uncommon, "XGA/1K")
		_Resolution(1280, 720, #Resolution_Common, "720p, HD")
		_Resolution(1366, 768, #Resolution_Common, "WXGA")
		_Resolution(1600, 900, #Resolution_Common, "HD+")
		_Resolution(1920, 1080, #Resolution_Common, "1080p, FHD")
		_Resolution(2048, 1152, #Resolution_Common, "QWXGA")
		_Resolution(2560, 1440, #Resolution_Common, "1440p, QHD")
		_Resolution(2880, 1620, #Resolution_Common, "3K")
		_Resolution(3200, 1800, #Resolution_Common, "QHD+")
		_Resolution(3840, 2160, #Resolution_Common, "2160p, 4K UHD")
		_Resolution(5120, 2880, #Resolution_Uncommon, "5K UHD+")
		_Resolution(5760, 3240, #Resolution_Uncommon, "6K")
		_Resolution(6720, 3780, #Resolution_Uncommon, "7K")
		_Resolution(7680, 4320, #Resolution_Uncommon, "8K UHD")
		_Resolution(15360, 8640, #Resolution_Uncommon, "16K UHD")
		_EndAspectRatio()
		
		_AspectRatio(16, 10, #Resolution_Common, "For when you want your screen to look like utter shit")
		_Resolution(1280, 800, #Resolution_Common, "WXGA")
		_Resolution(1440, 900, #Resolution_Common, "WXGA+")
		_Resolution(1680, 1050, #Resolution_Common, "WSXGA+")
		_Resolution(1920, 1200, #Resolution_Common, "WUXGA")
		_Resolution(2560, 1600, #Resolution_Common, "WQXGA")
		_Resolution(3840, 2400, #Resolution_Common, "WQUXGA")
		_EndAspectRatio()
		
		_AspectRatio(5, 3, #Resolution_Uncommon)
		_Resolution(320, 192, #Resolution_Uncommon, "0.06M6")
		_Resolution(400, 240, #Resolution_Uncommon, "WQVGA")
		_Resolution(800, 480, #Resolution_Uncommon, "WGA")
		_Resolution(1280, 768, #Resolution_Uncommon, "WXGA")
		_EndAspectRatio()
		
		_AspectRatio(5, 4, #Resolution_Common)
		_Resolution(220, 176, #Resolution_Uncommon, "0.04M4")
		_Resolution(320, 256, #Resolution_Uncommon, "0.08M4")
		_Resolution(600, 480, #Resolution_Uncommon, "0.29M4")
		_Resolution(640, 512, #Resolution_Uncommon, "0.33M3")
		_Resolution(1280, 1024, #Resolution_Common, "SXGA")
		_Resolution(1600, 1280, #Resolution_Common, "2.05M4")
		_Resolution(1800, 1440, #Resolution_Common, "2.59M4")
		_Resolution(2560, 2048, #Resolution_Uncommon, "QSXGA")
		_Resolution(5120, 4096, #Resolution_Uncommon, "HSXGA")
		_EndAspectRatio()
		
		_AspectRatio(3, 2, #Resolution_Common)
		_Resolution(48, 32, #Resolution_Uncommon, "1.54K2")
		_Resolution(60, 40, #Resolution_Uncommon, "2.4K2")
		_Resolution(96, 64, #Resolution_Uncommon, "0.01M2")
		_Resolution(96, 64, #Resolution_Uncommon, "0.01M2")
		_Resolution(240, 160, #Resolution_Uncommon, "HQVGA")
		_Resolution(480, 320, #Resolution_Uncommon, "HVGA")
		_Resolution(960, 640, #Resolution_Common, "DVGA")
		_Resolution(1152, 768, #Resolution_Common, "0.88M2")
		_Resolution(1440, 960, #Resolution_Common, "1.38M2")
		_Resolution(1920, 1280, #Resolution_Common, "FHD+")
		_Resolution(2160, 1440, #Resolution_Common, "3.11M2")
		_Resolution(2256, 1504, #Resolution_Uncommon, "3.39MA")
		_Resolution(2736, 1824, #Resolution_Uncommon, "4.99M2")
		_Resolution(3000, 2000, #Resolution_Uncommon, "3K")
		_Resolution(3240, 2160, #Resolution_Uncommon, "7M2")
		_Resolution(4500, 3000, #Resolution_Uncommon, "13.5M2")
		_EndAspectRatio()
		
		_AspectRatio(8, 5, #Resolution_Common)
		_Resolution(320, 200, #Resolution_Uncommon, "Color Graphics Adapter (CGA)")
		_Resolution(640, 400, #Resolution_Uncommon, "0.26M3")
		_Resolution(768, 480, #Resolution_Uncommon, "WVGA")
		_Resolution(1024, 640, #Resolution_Uncommon, "0.66MA")
		_Resolution(1152, 720, #Resolution_Uncommon, "0.83MA")
		_Resolution(1280, 800, #Resolution_Common, "WXGA")
		_Resolution(1440, 900, #Resolution_Common, "WSXGA")
		_Resolution(1440, 900, #Resolution_Common, "WXGA+")
		_Resolution(1680, 1050, #Resolution_Common, "WSXGA+")
		_Resolution(1920, 1200, #Resolution_Common, "WUXGA")
		_Resolution(2048, 1280, #Resolution_Uncommon, "2.62MA")
		_Resolution(2304, 1440, #Resolution_Uncommon, "3.32MA")
		_Resolution(2560, 1600, #Resolution_Uncommon, "WQXGA")
		_Resolution(2880, 1800, #Resolution_Uncommon, "5.18MA")
		_Resolution(3840, 2400, #Resolution_Uncommon, "WQUXGA")
		_Resolution(5120, 3200, #Resolution_Uncommon, "WHXGA")
		_Resolution(7680, 4800, #Resolution_Uncommon, "WHUXGA")
		_EndAspectRatio()
		
		_AspectRatio(9, 5, #Resolution_Uncommon)
		_Resolution(432, 240, #Resolution_Uncommon, "WQVGA")
		_Resolution(2160, 1200, #Resolution_Uncommon, "2.59M9")
		_EndAspectRatio()
		
		_AspectRatio(21, 9, #Resolution_Common)
		_Resolution(2560, 1080, #Resolution_Common, "UW-FHD")
		_Resolution(5120, 2160, #Resolution_Uncommon, "UW5K (WUHD)")
		_Resolution(10240, 4320, #Resolution_Uncommon, "UW10K")
		_EndAspectRatio()
		
		_EndAspectRatioTable()
	EndDataSection
EndModule
