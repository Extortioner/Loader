unit proxyparserform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, RegExpr,
  IdComponent, IdBaseComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TfrmProxyParser = class(TForm)
    mmProxySourceList: TMemo;
    mmProxyList: TMemo;
    lblProxySourceList: TLabel;
    lblProxyList: TLabel;
    btnParse: TButton;
    btnAdd: TButton;
    btnCancel: TButton;
    pbProgress: TProgressBar;
    lblProgressState: TLabel;
    HTTP: TIdHTTP;
    procedure FormCreate(Sender: TObject);
    procedure HTTPWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure btnParseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ProxyList: TStringList;
  end;

var
  frmProxyParser: TfrmProxyParser;

implementation

{$R *.dfm}


procedure TfrmProxyParser.btnParseClick(Sender: TObject);
var
  regexp: TRegExpr;
  Data: String;
  i: Integer;

begin
  ProxyList.Sorted := True;
  ProxyList.Duplicates := dupIgnore;
  lblProgressState.Visible := True;
  pbProgress.Visible := True;
  pbProgress.Position := 0;
  pbProgress.Max := mmProxySourceList.Lines.Count;

  for I := 0 to mmProxySourceList.Lines.Count - 1 do
  begin
    try
      Data := HTTP.Get(mmProxySourceList.Lines[i]);
      regexp :=TRegExpr.Create;
      regexp.Expression := '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,5}';
      if regexp.Exec(Data) then
      repeat
        ProxyList.Add(regexp.Match[0]);
      until not regexp.ExecNext;
    except
    end;
    pbProgress.StepIt;
  end;

  mmProxyList.Lines.Assign(ProxyList);
  lblProgressState.Visible := False;
  pbProgress.Visible := False;
end;

procedure TfrmProxyParser.FormCreate(Sender: TObject);
begin
  with lblProgressState do
  begin
    Parent := pbProgress;
    Top := 0;
    Left := 0;
    Width := pbProgress.ClientWidth;
    Height := pbProgress.ClientHeight;
    Visible := False;
  end;
  pbProgress.Visible := False;
  ProxyList := TStringList.Create;
end;

procedure TfrmProxyParser.FormDestroy(Sender: TObject);
begin
  ProxyList.Free;
end;

procedure TfrmProxyParser.HTTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  lblProgressState.Caption := 'Извлекаем: ' + HTTP.Socket.Host;
  Application.ProcessMessages;
end;

end.
