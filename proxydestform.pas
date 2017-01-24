unit proxydestform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmProxyDestination = class(TForm)
    Panel1: TPanel;
    rgProxyDestination: TRadioGroup;
    bntOK: TButton;
    btnCancel: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    SelectedIndex: Integer;
  end;

var
  frmProxyDestination: TfrmProxyDestination;

implementation

{$R *.dfm}

procedure TfrmProxyDestination.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Self.ModalResult = mrOk then
    SelectedIndex := rgProxyDestination.ItemIndex;
end;

end.
