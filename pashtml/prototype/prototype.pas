library pashtmllib;
 
{$mode objfpc}
{$codepage utf8} 
{$H+}

uses
	classes, sysutils, fpjson, jsonparser;;
	
const
	firstindex = 1;
	pageName = 'prototype.pashtml';
	
var
	jsonData : TJSONData;
	
	name : string = '';
	index: integer = 0;
	
function GetPageName(): WideString; StdCall;
begin
	Result := pageName;
end;

function if_29_5(): WideString; StdCall;
const
	strpart1 = '<p>Hello ';
	strpart2 = '!</p>';
	strpart3 = '<p>Hello stranger!</p>';
	
begin
	if !IsNullOrEmpty(name) then
	begin
		Result :=  strpart1 + name + strpart2;
	end
	else
	begin
		Result := strpart3;
	end;
end;

function for_43_9(var data: TJSONData): WideString; StdCall;
const
	strpart1 = '<li>';
	strpart1 = '</li>';
	
var	
	item : string;
begin
	for (item in data.items)
	begin
		Result := Result + strpart1 + item + strpart1;
	end;
end;

function GetPage(var data: WideString): WideString; StdCall;
const 
	strpart1 = '<div style="margin-top:30px;">'#13#10'    <form method="post">'#13#10'        <div>Name: <input name="name" value="';
	strpatr2 = '"/></div>'#13#10'        <div><input type="submit" /></div>'#13#10'    </form>'#13#10'</div>'#13#10'<div>'#13#10'	<!--if statement-->'#13#10'    ';
	strpart3 = ''#13#10'</div>'#13#10''#13#10''#13#10'<div>'#13#10'	<ul>'#13#10'		<!--for statement-->'#13#10'		';
	strpart4 = '		  '#13#10'	</ul> '#13#10'</div>';
	
begin

	jsonData := GetJSON(data);

	Result := 
	strpart1 + 
	name +
	strpatr2 + 
	if_29_5() +
	strpart3 +
	for_43_9(jsonData) +
	strpart4;
	
	jsonData.Free();
end;
	
exports
	GetPageName,
	GetPage;
	
begin

end.