unit UMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.IniFiles,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, FMX.Colors, FMX.Objects, FMX.StdCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  FMX.TabControl, System.IOUtils;

type
  TForm1 = class(TForm)
    rectColorPanel: TRectangle;
    ColorPanel1: TColorPanel;
    Rectangle3: TRectangle;
    btnOn: TButton;
    btnOff: TButton;
    IdHTTP1: TIdHTTP;
    ScrollBar1: TScrollBar;
    btnApply: TButton;
    lblRgb: TLabel;
    lblRed: TLabel;
    lblGreen: TLabel;
    lblBlue: TLabel;
    RoundRect1: TRoundRect;
    StyleBook1: TStyleBook;
    RoundRect2: TRoundRect;
    Rectangle1: TRectangle;
    RoundRect3: TRoundRect;
    procedure ColorPanel1Change(Sender: TObject);
    procedure btnOnClick(Sender: TObject);
    procedure btnOffClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    i1, i2, i3: integer;
    AppPath: String;
    procedure iniLoad();
    procedure iniSave();
    procedure setParams();
    procedure myHttpRequest();
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}

procedure TForm1.btnApplyClick(Sender: TObject);

begin
   myHttpRequest;
end;

procedure TForm1.btnOffClick(Sender: TObject);
begin
  iniSave;
  try
    IdHTTP1.Get('http://192.168.101.20/?r=0&g=0&b=0');
  except
    on e: EIdHTTPProtocolException do
    begin
      if e.ErrorCode = 404 then
        ShowMessage('Bad Request');
    end;
  end;
end;

procedure TForm1.btnOnClick(Sender: TObject);
begin
 iniLoad;
 myHttpRequest;
end;

procedure TForm1.ColorPanel1Change(Sender: TObject);
var
  hexString, hexGreen, hexBlue, hexRed: String;

begin
  hexString := IntToHex(ColorPanel1.Color);
  lblRgb.Text := Copy(hexString, 3, 7);
  hexGreen := Copy(hexString, 3, 2);
  i1 := StrToInt64('$' + hexGreen);
  lblGreen.Text := IntToStr(i1);
  hexBlue := Copy(hexString, 5, 2);
  i2 := StrToInt64('$' + hexBlue);
  lblBlue.Text := IntToStr(i2);
  hexRed := Copy(hexString, 7, 2);
  i3 := StrToInt64('$' + hexRed);
  lblRed.Text := IntToStr(i3);

end;

procedure TForm1.FormShow(Sender: TObject);
begin
// setParams();
// iniLoad();
// myHttpRequest();
end;

procedure TForm1.iniLoad;
var
  appINI: TIniFile;
  h1, h2, h3: String;
begin
  appINI := TIniFile.Create(TPath.Combine(AppPath,'mysettings.ini'));
  try
    h1 := appINI.ReadString('rgb', 'i1', '255'); // 255 is default
    i1 := h1.ToInteger;
    h2 := appINI.ReadString('rgb', 'i2', '255'); // 255 is default
    i2 := h2.ToInteger;
    h3 := appINI.ReadString('rgb', 'i3', '255'); // 255 is default
    i3 := h3.ToInteger;
  finally
    appINI.Free;
  end;
end;

procedure TForm1.iniSave;
var
  appINI: TIniFile;
  h1, h2, h3: String;
begin
  appINI := TIniFile.Create(TPath.Combine(AppPath,'mysettings.ini'));
  try
    h1 := i1.ToString;
    appINI.WriteString('rgb', 'i1', h1);
    h2 := i2.ToString;
    appINI.WriteString('rgb', 'i2', h2);
    h3 := i3.ToString;
    appINI.WriteString('rgb', 'i3', h3);

  finally
    appINI.Free;
  end;
end;

procedure TForm1.myHttpRequest;
var
  urlString: String;
begin
  try
    urlString := 'http://192.168.101.20/?r=' + IntToStr(i3) + '&g=' +
      IntToStr(i1) + '&b=' + IntToStr(i2);
    IdHTTP1.Get(urlString);
  except
    on e: EIdHTTPProtocolException do
    begin
      if e.ErrorCode = 404 then
        ShowMessage('Bad Request');
    end;
  end;
end;

procedure TForm1.setParams;
begin
{$IF DEFINED (MSWINDOWS)}    // IFDEF ohne log operatoren
  AppPath := GetCurrentDir; // ACHTUNG VERLINKUNG! nur zum testen
{$ELSE}
  AppPath := TPath.GetPublicPath;

{$ENDIF}
end;

end.
