program BTCExposed;

uses
  Vcl.Forms,
  mainform in 'mainform.pas' {Form2},
  st4makers.BitCoin in '..\..\..\..\src\st4makers.BitCoin.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
