unit mainform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.IniFiles, ShellAPI, Vcl.AppEvnts;

type
  TfrmMain = class(TForm)
    pcPages: TPageControl;
    tsLogin: TTabSheet;
    tsProxy: TTabSheet;
    lbePathToClient: TLabeledEdit;
    btnSetPathToClient: TSpeedButton;
    OD: TFileOpenDialog;
    lbeCurrentToken: TLabeledEdit;
    lbeComment: TLabeledEdit;
    btnGetToken: TButton;
    btnAddTokenToList: TButton;
    lblSavedTokens: TLabel;
    btnReloadTokens: TButton;
    btnDeleteSelectedToken: TButton;
    btnClearList: TButton;
    cbAutoPlay: TCheckBox;
    btnRun: TButton;
    lbTokens: TListBox;
    TrayIcon: TTrayIcon;
    ApplicationEvents: TApplicationEvents;
    procedure btnSetPathToClientClick(Sender: TObject);
    procedure cbAutoPlayClick(Sender: TObject);
    procedure btnReloadTokensClick(Sender: TObject);
    procedure btnDeleteSelectedTokenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddTokenToListClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbTokensDblClick(Sender: TObject);
    procedure btnClearListClick(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure ApplicationEventsMinimize(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ReadCurrentToken;
    procedure RunWithToken(token: String);
    procedure SaveSettings;
    procedure LoadSettings;
  end;

  PTokenData = ^TTokenData;
  TTokenData = record
    Token: string;
  end;
var
  frmMain: TfrmMain;
  
  PathToClient: string = '';
  AppWorkDir: string = '';
  CurrentComment: string = '';

implementation

{$R *.dfm}

procedure TfrmMain.ApplicationEventsMinimize(Sender: TObject);
begin
  frmMain.Hide;
  TrayIcon.Visible := True;
end;

procedure TfrmMain.btnAddTokenToListClick(Sender: TObject);
var
  TokenData: PTokenData;
begin
  New(TokenData);
  TokenData.Token := lbeCurrentToken.Text;
  lbTokens.AddItem(lbeComment.Text, TObject(TokenData));
  SaveSettings;
end;

procedure TfrmMain.btnClearListClick(Sender: TObject);
begin
  lbTokens.Items.Clear;
  SaveSettings;
end;

procedure TfrmMain.btnDeleteSelectedTokenClick(Sender: TObject);
begin
  if lbTokens.ItemIndex >= 0 then
  begin
    Dispose(PTokenData(lbTokens.Items.Objects[lbTokens.ItemIndex]));
    lbTokens.DeleteSelected;
    ShowMessage(lbTokens.Items.Count.ToString);
    SaveSettings;
  end;

end;

procedure TfrmMain.btnReloadTokensClick(Sender: TObject);
begin
  LoadSettings;
end;

procedure TfrmMain.btnRunClick(Sender: TObject);
var
  TokenData: PTokenData;
begin
  if lbTokens.ItemIndex >= 0 then
  begin
    TokenData := PTokenData(lbTokens.Items.Objects[lbTokens.ItemIndex]);
    RunWithToken(TokenData.Token);
  end
  else
    MessageBox(Handle, '������� �������� �������', '��������', MB_ICONWARNING + MB_OK);
end;

procedure TfrmMain.btnSetPathToClientClick(Sender: TObject);
begin
  if OD.Execute then
  begin
    lbePathToClient.Text := OD.FileName;
    PathToClient := OD.FileName;
    ReadCurrentToken;
    SaveSettings;
  end;
end;

procedure TfrmMain.ReadCurrentToken;
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(PathToClient + '\asterios\asteriosgame.ini');
  lbeCurrentToken.Text := iniFile.ReadString('Auth', 'Key', 'empty');
  iniFile.Free;
end;

procedure TfrmMain.RunWithToken(token: String);
var
  iniFile: TIniFile;
  params: String;
begin
  iniFile := TIniFile.Create(PathToClient + '\asterios\asteriosgame.ini');
  iniFile.WriteString('Auth', 'Key', token);
  iniFile.Free;
  params := '';
  if cbAutoPlay.Checked then
    params := '/autoplay';
  ShellExecute(0,'open', PChar(PathToClient + '\Asterios.exe'), PChar(params), PChar(PathToClient),1);
  Application.Minimize;
end;

procedure TfrmMain.SaveSettings;
var
  iniFile: TIniFile;
  i: Integer;
  TokenData: PTokenData;
begin
  iniFile := TIniFile.Create(AppWorkDir + '\settings.ini');
  iniFile.WriteString('Client', 'Path', PathToClient);
  iniFile.WriteBool('Client', 'Autoplay', cbAutoPlay.Checked);
  iniFile.EraseSection('Tokens');
  iniFile.EraseSection('Notes');
  if lbTokens.Items.Count > 0 then
  begin
    for i := 0 to lbTokens.Items.Count - 1 do
    begin
      TokenData := PTokenData(lbTokens.Items.Objects[i]);
      iniFile.WriteString('Tokens', 'Token' + IntToStr(i + 1), TokenData.Token);
      iniFile.WriteString('Notes', 'Note' + IntToStr(i + 1), lbTokens.Items[i]);
    end;
  end;
  iniFile.Free;
end;

procedure TfrmMain.TrayIconClick(Sender: TObject);
begin
  frmMain.Show;
  TrayIcon.Visible := False;
end;

procedure TfrmMain.cbAutoPlayClick(Sender: TObject);
begin
  if cbAutoPlay.Tag = 0 then
    SaveSettings;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  AppWorkDir := ExtractFilePath(Application.ExeName);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lbTokens.Items.Count - 1 do
    Dispose(PTokenData(lbTokens.Items.Objects[i]));
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  LoadSettings;
  ReadCurrentToken;
end;

procedure TfrmMain.lbTokensDblClick(Sender: TObject);
var
  TokenData: PTokenData;
begin
  TokenData := PTokenData(lbTokens.Items.Objects[lbTokens.ItemIndex]);
  RunWithToken(TokenData.Token);
end;

procedure TfrmMain.LoadSettings;
var
  iniFile: TIniFile;
  i: Integer;
  Tokens, Notes: TStringList;
  TokenData: PTokenData;
begin
  Tokens := TStringList.Create;
  Notes := TStringList.Create;
  iniFile := TIniFile.Create(AppWorkDir + '\settings.ini');
  PathToClient := iniFile.ReadString('Client', 'Path', '');
  lbePathToClient.Text := PathToClient;
  cbAutoPlay.Tag := 1;
  cbAutoPlay.Checked := iniFile.ReadBool('Client', 'Autoplay', False);
  cbAutoPlay.Tag := 0;
  if (iniFile.SectionExists('Tokens') and iniFile.SectionExists('Notes')) then
  begin
    iniFile.ReadSectionValues('Tokens', Tokens);
    iniFile.ReadSectionValues('Notes', Notes);
    lbTokens.Clear;
    for i := 0 to Tokens.Count - 1 do
    begin
      New(TokenData);
      TokenData.Token := StringReplace(Tokens[i], 'Token' + IntToStr(i + 1) + '=', '', [rfReplaceAll]);
      lbTokens.AddItem(StringReplace(Notes[i], 'Note' + IntToStr(i + 1) + '=', '', [rfReplaceAll]), TObject(TokenData));
    end;
  end;
  Tokens.Free;
  Notes.Free;
  iniFile.Free;
end;

end.