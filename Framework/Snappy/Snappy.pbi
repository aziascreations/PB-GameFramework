
;- Compiler Directives

CompilerIf #PB_Compiler_IsMainFile: CompilerError "Unable to compile an include file !": CompilerEndIf
EnableExplicit


;- Module

DeclareModule Snappy
	CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
		CompilerError "Unable to compile snappy module for non-windows platform."
	CompilerEndIf
	
	CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
		#LibPath$ = "../../Libraries/.lib/x86/snappy.lib"
	CompilerElseIf #PB_Compiler_Processor = #PB_Processor_x64
		#LibPath$ = "../../Libraries/.lib/x64/snappy.lib"
	CompilerEndIf
	
	Import #LibPath$
		snappy_compress.b(*input, input_length.i, *compressed, *compressed_length)
		
		snappy_uncompress.b(*compressed, compressed_length.i, *uncompressed, uncompressed_length.i)
		
		snappy_max_compressed_length.i(source_length.i)
		
		snappy_uncompressed_length.b(*compressed, compressed_length.i, *result)
		
		snappy_validate_compressed_buffer.b(*compressed, compressed_length.i)
	EndImport
	
	Enumeration snappy_status
		#SNAPPY_OK = 0
		#SNAPPY_INVALID_INPUT = 1
		#SNAPPY_BUFFER_TOO_SMALL = 2
	EndEnumeration
EndDeclareModule

Module Snappy
	; Nothing here...
EndModule
