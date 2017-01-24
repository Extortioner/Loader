unit addproxyform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmAddProxy = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    lbeProxyHost: TLabeledEdit;
    lbeProxyPort: TLabeledEdit;
    cmbProxyType: TComboBox;
    lblProxyType: TLabel;
    lbeProxyUser: TLabeledEdit;
    lbeProxyPassword: TLabeledEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    ProxyHost: string;
    ProxyPort: Word;
    ProxyType: string;
    ProxyUser: string;
    ProxyPassword: string;
  end;

var
  frmAddProxy: TfrmAddProxy;

implementation

{$R *.dfm}

procedure TfrmAddProxy.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if Self.ModalResult = mrOk then
 begin
   ProxyHost := lbeProxyHost.Text;
   ProxyPort := StrToInt(lbeProxyPort.Text);
   ProxyType := cmbProxyType.Text;
   ProxyUser := lbeProxyUser.Text;
   ProxyPassword := lbeProxyPassword.Text;
 end;
end;

end.
