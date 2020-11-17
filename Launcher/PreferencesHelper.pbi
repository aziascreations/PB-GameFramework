
EnableExplicit

DeclareModule PreferencesHelper
	Declare.b SetupPreferences(FilePath$, AttemptToCreate.b = #True)
	
	Macro ClosePreferences()
		ClosePreferences()
	EndMacro
	
	Macro ReadPreferenceInteger(Key, DefaultValue)
		ReadPreferenceInteger(Key, DefaultValue)
	EndMacro
	
	Macro ReadPreferenceBoolean(Key, DefaultValue)
		ReadPreferenceInteger(Key, DefaultValue)
	EndMacro
	
	Macro ReadPreferenceString(Key, DefaultValue)
		ReadPreferenceString(Key, DefaultValue)
	EndMacro
	
	Macro WritePreferenceInteger(Key, DefaultValue)
		WritePreferenceInteger(Key, DefaultValue)
	EndMacro
	
	Macro WritePreferenceBoolean(Key, DefaultValue)
		WritePreferenceInteger(Key, DefaultValue)
	EndMacro
	
EndDeclareModule

Module PreferencesHelper
	EnableExplicit
	
	Procedure.b SetupPreferences(FilePath$, AttemptToCreate.b = #True)
		Select FileSize(FilePath$)
			Case -2
				ProcedureReturn #False
			Case -1
				If AttemptToCreate
					ProcedureReturn CreatePreferences(FilePath$)
				Else
					ProcedureReturn #False
				EndIf
			Default
				ProcedureReturn OpenPreferences(FilePath$)
		EndSelect
		
		ProcedureReturn #False
	EndProcedure
EndModule
