program Loader;

uses
  Vcl.Forms,
  Winapi.Windows,
  RegExpr in 'Core\RegExpr.pas',
  addproxyform in 'UI\addproxyform.pas' {frmAddProxy},
  mainform in 'UI\mainform.pas' {frmMain},
  proxydestform in 'UI\proxydestform.pas' {frmProxyDestination},
  proxyparserform in 'UI\proxyparserform.pas' {frmProxyParser},
  testproxyform in 'UI\testproxyform.pas' {frmTestProxy};   

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
