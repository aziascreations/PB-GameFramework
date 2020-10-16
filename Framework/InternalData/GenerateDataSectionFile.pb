EnableExplicit

DeleteFile("./DataSection-Data.Internal.pbi")
DeleteFile("./DataSection-Data.Internal.pbi.cfg")

NewList IgnoredFiles.s()

If ReadFile()
	
Else
	MessageRequester("error", "failed to read ignored-files.txt !")
EndIf


Directory$ = GetHomeDirectory()
If ExamineDirectory(0, Directory$, "*.*")  
	While NextDirectoryEntry(0)
		If DirectoryEntryType(0) = #PB_DirectoryEntry_File
			
			Type$ = "[File] "
			Size$ = " (Size: " + DirectoryEntrySize(0) + ")"
		EndIf
		
		Debug Type$ + DirectoryEntryName(0) + Size$
	Wend
	FinishDirectory(0)
EndIf