program pashtml;

{$mode objfpc}
{$codepage utf8} 
{$H+}

uses sysutils, dynlibs;

type
	TGetAStringFunc = function (): WideString; stdcall;
	TGetAStringProc = procedure (var s: WideString); stdcall;
	
var
	LibHandle: TLibHandle = dynlibs.NilHandle;
	GetAStringFunc: TGetAStringFunc;
	GetAStringProc: TGetAStringProc;
	s: WideString = '';
  
begin
	try
		LibHandle := LoadLibrary('pashtmllib.' + SharedSuffix);

		if LibHandle = dynlibs.NilHandle then 
		begin
			WriteLn('Library was not loaded successfully.');
			exit; 
		end;

		WriteLn('Library was loaded successfully.');
		
		GetAStringFunc := TGetAStringFunc(GetProcAddress(LibHandle, 'GetAStringFunc'));
		GetAStringProc := TGetAStringProc(GetProcAddress(LibHandle, 'GetAStringProc'));	
		
		if not Assigned(GetAStringFunc) then
			WriteLn('Error handler method GetAStringFunc is not assignd.');
			
		if not Assigned(GetAStringProc) then
			WriteLn('Error handler method GetAStringProc is not assignd.');
		
		try		
			WriteLn('GetAStringFunc value: ' + GetAStringFunc());			
			
			GetAStringProc(s); 
			WriteLn('GetAStringProc value: ' + s);
		except
			WriteLn('Error call method.');
			exit;
		end;
		
	finally
		if LibHandle <> DynLibs.NilHandle then 
		begin	
			WriteLn('Unloading library.');
			if UnloadLibrary(LibHandle) then 
			begin			
				LibHandle := DynLibs.NilHandle;  //Unload the lib, if already loaded
				WriteLn('Library was unload successfully.');
			end;
		end;
	end;
    ReadLn();
end.
