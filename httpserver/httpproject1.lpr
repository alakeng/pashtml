program httpproject1;

{$mode objfpc}{$H+}

uses
  fphttpapp, Unit1;

begin
  Application.LegacyRouting := true;
  Application.Title:='httpproject1';
  Application.Port:=8080;
  Application.Threaded:=True;
  Application.Initialize;
  Application.Run;
end.

