program led;

uses
  System.StartUpCopy,
  FMX.Forms,
  UMain in 'oberfl�che\UMain.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
