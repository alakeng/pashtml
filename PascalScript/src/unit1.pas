unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, dateutils,uPSComponent, SynEdit, SynHighlighterPas, uPSUtils,
  uPSComponent_Default, uPSComponent_COM, uPSComponent_DB,
  uPSComponent_StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ImageList1: TImageList;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    PSImport_Classes1: TPSImport_Classes;
    PSImport_ComObj1: TPSImport_ComObj;
    PSImport_DateUtils1: TPSImport_DateUtils;
    PSImport_DB1: TPSImport_DB;
    PSScript1: TPSScript;
    SaveDialog1: TSaveDialog;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    SynEdit1: TSynEdit;
    SynFreePascalSyn1: TSynFreePascalSyn;
    TabSheet1: TTabSheet;
    ToolBar1: TToolBar;
    btnOpen: TToolButton;
    btnSave: TToolButton;
    btnCompile: TToolButton;
    btnRun: TToolButton;
    btnSaveAs: TToolButton;
    ToolButton1: TToolButton;
    btnSaveCompiledScript: TToolButton;
    btnLoadCompiledScript: TToolButton;
    btnRunCompiledScript: TToolButton;
    TreeView1: TTreeView;
    procedure btnCompileClick(Sender: TObject);
    procedure btnLoadCompiledScriptClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnRunCompiledScriptClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveCompiledScriptClick(Sender: TObject);
    procedure PSScript1Compile(Sender: TPSScript);
    procedure PSScript1Execute(Sender: TPSScript);
    function PSScript1NeedFile(Sender: TObject; const OrginFileName: tbtstring;
      var FileName, Output: tbtstring): Boolean;
    procedure ToolButton1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation
uses
  dynlibs,
  uPSRuntime,
  RegExpr;

{$R *.lfm}

{ TForm1 }

procedure UseDLL;
type
  TMyFunc=function (aInt:Integer; aStr: string):String; StdCall;
var
  MyLibC: TLibHandle= dynlibs.NilHandle;
  MyFunc: TMyFunc;
  FuncResult: string;
begin
  MyLibC := LoadLibrary('libc.' + SharedSuffix);
  if MyLibC = dynlibs.NilHandle then Exit;  //DLL was not loaded successfully
  MyFunc:= TMyFunc(GetProcedureAddress(MyLibC, 'MyFunc'));
  FuncResult:= MyFunc (5,'Test');  //Executes the function
  if MyLibC <>  DynLibs.NilHandle then if FreeLibrary(MyLibC) then MyLibC:= DynLibs.NilHandle;  //Unload the lib, if already loaded
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
     SynEdit1.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.btnRunClick(Sender: TObject);
begin
  Memo1.Lines.Clear();
  PSScript1.Script := SynEdit1.Lines;
  if PSScript1.compile then
     if PSScript1.execute then
        Memo1.Lines.Add('Ok')
     else
        Memo1.Lines.Add(PSScript1.CompilerErrorToStr(0))
  else
      Memo1.Lines.Add(PSScript1.CompilerErrorToStr(0));
end;

procedure TForm1.btnRunCompiledScriptClick(Sender: TObject);
begin
  if PSScript1.Exec.RunScript then
    Memo1.Lines.Add('Compiled script executed.')
  else
    Memo1.Lines.Add(PSErrorToString(PSScript1.Exec.ExceptionCode,''));
end;

procedure TForm1.btnSaveAsClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
     SynEdit1.Lines.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TForm1.btnCompileClick(Sender: TObject);
begin
  Memo1.Lines.Clear();
  PSScript1.Script := SynEdit1.Lines;
  if PSScript1.compile then
     Memo1.Lines.Add('Ok')
  else
      Memo1.Lines.Add(PSScript1.CompilerErrorToStr(0));
end;

procedure TForm1.btnLoadCompiledScriptClick(Sender: TObject);
var
  sdata: string;
  f: TFileStream;
begin
  if OpenDialog1.Execute then
  begin
       try
          f := TFileStream.Create(OpenDialog1.FileName, fmOpenRead or fmShareDenyWrite);
          SetLength(sdata, f.Size);
          f.Read(sdata[1], Length(sdata));
          if PSScript1.Exec.LoadData(sdata) then
             Memo1.Lines.Add('Compiled script loaded.')
          else
             Memo1.Lines.Add(PSErrorToString(PSScript1.Exec.ExceptionCode,''));

       finally
          f.Free;
       end;
  end;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  if not SaveDialog1.FileName.IsNullOrEmpty(SaveDialog1.FileName) then
     SynEdit1.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TForm1.btnSaveCompiledScriptClick(Sender: TObject);
var
  sdata: string;
  fx: Longint;
begin
  if SaveDialog1.Execute then
  begin
    PSScript1.GetCompiled(sdata);
    fx:= FileCreate(SaveDialog1.FileName) ;
    FileWrite(fx,sdata[1],Length(sdata));
    FileClose(fx);
  end;
end;

procedure MWrites(const s: string);
begin
  Form1.Memo1.lines.add(s);
end;
procedure TForm1.PSScript1Compile(Sender: TPSScript);
begin
     Sender.AddFunction(@MWrites, 'procedure Writes(const s: string)');
     Sender.AddFunction(@DateTimeToStr, 'function DateTimeToStr(DateTime: TDateTime): string');
end;

procedure TForm1.PSScript1Execute(Sender: TPSScript);
begin

end;

function TForm1.PSScript1NeedFile(Sender: TObject; const OrginFileName: tbtstring; var FileName, Output: tbtstring): Boolean;
var
  path: string;
  f: TFileStream;
begin
  Path := ExtractFilePath(OpenDialog1.FileName) + FileName;
  try
    F := TFileStream.Create(Path, fmOpenRead or fmShareDenyWrite);
  except
    Result := false;
    exit;
  end;
  try
    SetLength(Output, f.Size);
    f.Read(Output[1], Length(Output));
  finally
    f.Free;
  end;
  Result := True;
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
var
  re: TRegExpr;
  sl: TStringList;
begin
  sl := TStringList.Create;
  sl.LoadFromFile('index.pshtml');
  re := TRegExpr.Create('@\{(.*)\}');
  re.ModifierG := false;
  re.ModifierS := true;

  if re.Exec(sl.Text) then
  begin
    Memo1.Lines.Add(IntToStr(re.MatchPos[1]));
    Memo1.Lines.Add(re.Match[1]);
    while re.ExecNext do
    begin
      Memo1.Lines.Add(IntToStr(re.MatchPos[1]));
      Memo1.Lines.Add(re.Match[1]);
    end;
  end;
  re.Free;

end;

end.

