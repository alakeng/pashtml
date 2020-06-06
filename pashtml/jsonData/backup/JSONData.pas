program JSONData;

{$mode objfpc}
{$codepage utf8}
{$H+}

USES classes, fpjson, jsonparser, jsonscanner;

PROCEDURE JSONTest;
VAR
   jData : TJSONData;
   jObject : TJSONObject;
   jArray : TJSONArray;
   s : string;
   ss : TStringList;

	//Parser:TJSONParser;
	//jObject, jSubObject  : TJSONObject;


BEGIN
   ss := TStringList.Create;
   ss.LoadFromFile('e:\\!projects\\!lazarus\\Development\\pashtml\\jsonData\\json.json');

   //Parser := TJSONParser.Create('{"поле1" : "поле1", "поле2" : 42, "Цвет" : ["Красный", "Зелёный", "Голубой"]}', [joUTF8]);
   //jObject := Parser.Parse as TJSONObject;
   //s := jObject.Get('поле1');
   // это лишь минимальный пример того, что можно сделать с помощью этого API

   // создать строки JSON
   s := ss.Text;//'{"поле1" : "поле1", "field2" : 42, "Цвет" : ["Красный", "Зелёный", "Голубой"]}';
    WriteLn(s);
   jData := GetJSON(s, false);

   // вывести как плоскую строку
   s := jData.AsJSON;
     WriteLn(s);
   //  вывести замечательно-отформатированный JSON
   s := jData.FormatJSON;
        WriteLn(s);
   // передан как TJSONObject для простого доступа
   jObject := TJSONObject(jData);

   // передача значения ключа "поле1"
   s := jObject.Get(UTF8String('поле1'), '');
        WriteLn(s);
   // установка значения ключа "поле2"
   jObject.Integers['поле2'] := 123;

   // передача второго цвета
   s := jData.FindPath(UTF8String('Цвет[1]')).AsString;
         WriteLn(s);
   // добавить новый элемент
   jObject.Add('Happy', True);

   // передать новый подмассив
   jArray := TJSONArray.Create;
   jArray.Add('Север');
   jArray.Add('Юг');
   jArray.Add('Восток');
   jArray.Add('Запад');
   jObject.Add('Направление', jArray);

	ReadLn();
END;

begin
  JSONTest;
end.


