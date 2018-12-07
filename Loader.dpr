program Loader;

uses
  Vcl.Forms,
  Winapi.Windows,
  mainform in 'mainform.pas' {frmMain},
  addproxyform in 'addproxyform.pas' {frmAddProxy},
  proxydestform in 'proxydestform.pas' {frmProxyDestination},
  testproxyform in 'testproxyform.pas' {frmTestProxy},
  RegExpr in 'RegExpr.pas',
  proxyparserform in 'proxyparserform.pas' {frmProxyParser};

{$R *.res}

begin
  CreateMutex(nil, True, '{CA906874-2065-49F6-A0AE-780520ED7E4C}');
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    Application.MessageBox('Программа уже запущена', 'Внимание', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
