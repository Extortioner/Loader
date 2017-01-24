program Loader;

uses
  Vcl.Forms,
  mainform in 'mainform.pas' {frmMain},
  addproxyform in 'addproxyform.pas' {frmAddProxy},
  proxydestform in 'proxydestform.pas' {frmProxyDestination};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
