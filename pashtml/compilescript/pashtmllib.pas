library pashtmllib;

{$mode objfpc}
{$codepage utf8} 
{$H+}

//resourcestring
//	value = 'UTF8 строка';
	
const
	value = 'UTF8 строка';	
	
procedure GetAStringProc(var S: WideString); StdCall;
begin
	S := value;
end;

function GetAStringFunc: WideString; StdCall;
begin
	Result := value;
end;

exports
	GetAStringProc,
	GetAStringFunc;
	
begin

end.