unit testproxyform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdRawBase, IdRawClient, IdIcmpClient;

type
  TfrmTestProxy = class(TForm)
    IdIcmpClient: TIdIcmpClient;
    lbProxyList: TListBox;
    lblProxyListTitle: TLabel;
    btnOK: TButton;
    btnTest: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ProxyList: TStringList;
  end;

var
  frmTestProxy: TfrmTestProxy;

implementation

{$R *.dfm}

procedure TfrmTestProxy.btnTestClick(Sender: TObject);
var
  i: Integer;
begin
  btnTest.Enabled := False;
  lbProxyList.Items.Clear;
  for i := 0 to ProxyList.Count - 1 do
  begin
    IdIcmpClient.Host := ProxyList[i];
    IdIcmpClient.Ping();
    lbProxyList.Items.Add('Proxy: ' + ProxyList[i] + '; Ping: ' + IntToStr(IdIcmpClient.ReplyStatus.MsRoundTripTime) + ' ms');
    Application.ProcessMessages;
    Sleep(500);
  end;
  lbProxyList.Items.Add('Тест окончен.');
  ProxyList.Free;
  btnTest.Enabled := True;
end;

procedure TfrmTestProxy.FormCreate(Sender: TObject);
begin
  ProxyList := TStringList.Create;
end;

end.
