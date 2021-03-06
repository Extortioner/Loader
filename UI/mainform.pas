unit mainform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.IniFiles, ShellAPI, Vcl.AppEvnts, Vcl.Menus, Vcl.Mask,
  Vcl.Samples.Spin;

type
  TfrmMain = class(TForm)
    pcPages: TPageControl;
    tsLogin: TTabSheet;
    tsProxy: TTabSheet;
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
    btnAddProxy: TButton;
    lvProxyList: TListView;
    lblProxyList: TLabel;
    btnDeleteProxy: TButton;
    btnClearProxyList: TButton;
    btnTestProxy: TButton;
    btnSaveProxyToClient: TButton;
    btnSetDefaultProxySettings: TButton;
    pmTrayMenu: TPopupMenu;
    miLastToken: TMenuItem;
    miOpenApp: TMenuItem;
    empty: TMenuItem;
    miExit: TMenuItem;
    Timer: TTimer;
    cbAutoHide: TCheckBox;
    tsClientSettings: TTabSheet;
    btnSetPathToClient: TSpeedButton;
    lbePathToClient: TLabeledEdit;
    gbClientSettings: TGroupBox;
    ApplicationEvents: TApplicationEvents;
    cbUseWindowFrame: TCheckBox;
    cbUseJoystick: TCheckBox;
    cmbProcessPriority: TComboBox;
    cmbCacheSizeMegs: TComboBox;
    lblProcessPriority: TLabel;
    lblCacheSizeMegs: TLabel;
    lblMegabytes: TLabel;
    lblReplayTimeLimit: TLabel;
    lblMins: TLabel;
    edReplayTimeLimit: TEdit;
    lblContrast: TLabel;
    lblBrightness: TLabel;
    lblGamma: TLabel;
    edContrast: TEdit;
    edBrightness: TEdit;
    edGamma: TEdit;
    btnRename: TButton;
    pmProxyAddMenu: TPopupMenu;
    miAddProxyManually: TMenuItem;
    miUseParser: TMenuItem;
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
    procedure btnSaveProxyToClientClick(Sender: TObject);
    procedure btnClearProxyListClick(Sender: TObject);
    procedure btnDeleteProxyClick(Sender: TObject);
    procedure btnSetDefaultProxySettingsClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miLastTokenClick(Sender: TObject);
    procedure btnGetTokenClick(Sender: TObject);
    procedure btnTestProxyClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure cbAutoHideClick(Sender: TObject);
    procedure edContrastKeyPress(Sender: TObject; var Key: Char);
    procedure edBrightnessKeyPress(Sender: TObject; var Key: Char);
    procedure edGammaKeyPress(Sender: TObject; var Key: Char);
    procedure cbUseWindowFrameClick(Sender: TObject);
    procedure cbUseJoystickClick(Sender: TObject);
    procedure btnRenameClick(Sender: TObject);
    procedure miAddProxyManuallyClick(Sender: TObject);
    procedure btnAddProxyClick(Sender: TObject);
    procedure miUseParserClick(Sender: TObject);
    procedure lvProxyListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ReadCurrentToken;
    procedure RunWithToken(token: String);
    procedure SaveProxy(Filename, ProxyHost, ProxyPort, ProxyType, ProxyUser, ProxyPassword: String);

    //---------SETTINGS SECTION--------
    //-----------application-----------
    procedure SaveAppSettings;
    procedure LoadAppSettings;
    //-----------client----------------
    procedure SaveClientSettings;
    procedure LoadClientSettings;
    //-----------updater---------------
    //---------------------------------

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
  LastToken: string = '';

implementation

{$R *.dfm}

uses addproxyform, proxydestform, testproxyform, proxyparserform;

procedure TfrmMain.ApplicationEventsMinimize(Sender: TObject);
begin
  frmMain.Hide;
  TrayIcon.Visible := True;
end;

procedure TfrmMain.btnAddProxyClick(Sender: TObject);
begin
  miAddProxyManually.Click;
end;

procedure TfrmMain.btnAddTokenToListClick(Sender: TObject);
var
  TokenData: PTokenData;
begin
  New(TokenData);
  TokenData.Token := lbeCurrentToken.Text;
  lbTokens.AddItem(lbeComment.Text, TObject(TokenData));
  SaveAppSettings;
end;

procedure TfrmMain.btnClearListClick(Sender: TObject);
begin
  lbTokens.Items.Clear;
  SaveAppSettings;
end;

procedure TfrmMain.btnClearProxyListClick(Sender: TObject);
begin
  lvProxyList.Items.Clear;
  SaveAppSettings;
end;

procedure TfrmMain.btnDeleteProxyClick(Sender: TObject);
begin
  lvProxyList.DeleteSelected;
  SaveAppSettings;
end;

procedure TfrmMain.btnDeleteSelectedTokenClick(Sender: TObject);
begin
  if lbTokens.ItemIndex >= 0 then
  begin
    Dispose(PTokenData(lbTokens.Items.Objects[lbTokens.ItemIndex]));
    lbTokens.DeleteSelected;
    SaveAppSettings;
  end;

end;

procedure TfrmMain.btnGetTokenClick(Sender: TObject);
begin
  ReadCurrentToken;
end;

procedure TfrmMain.btnReloadTokensClick(Sender: TObject);
begin
  LoadAppSettings;
end;

procedure TfrmMain.btnRenameClick(Sender: TObject);
var
  oldName, newName: String;
begin
  if (lbTokens.ItemIndex >= 0) then
  begin
    oldName := lbTokens.Items[lbTokens.ItemIndex];
    newName := InputBox('�������������', '����� ��������:', oldName);
    if (newName <> oldName) then
    begin
      lbTokens.Items[lbTokens.ItemIndex] := newName;
      SaveAppSettings;
    end;
  end;
end;

procedure TfrmMain.btnRunClick(Sender: TObject);
var
  TokenData: PTokenData;
begin
  if lbTokens.ItemIndex >= 0 then
  begin
    TokenData := PTokenData(lbTokens.Items.Objects[lbTokens.ItemIndex]);
    LastToken := TokenData.Token;
    RunWithToken(LastToken);
  end
  else
    MessageBox(Handle, '������� �������� �������', '��������', MB_ICONWARNING + MB_OK);
end;

procedure TfrmMain.btnSaveProxyToClientClick(Sender: TObject);
var
  frmProxyDest: TfrmProxyDestination;
  selectedIndex: Integer;
begin
  if lvProxyList.ItemIndex >= 0 then
  begin
    frmProxyDest := TfrmProxyDestination.Create(Self);
    if frmProxyDest.ShowModal = mrOk then
    begin
      selectedIndex := frmProxyDest.SelectedIndex;
      case selectedIndex of
        0 : begin
              SaveProxy(PathToClient + '\asterios\asteriosgame.ini', lvProxyList.Selected.Caption,
                        lvProxyList.Selected.SubItems[0], lvProxyList.Selected.SubItems[1],
                        lvProxyList.Selected.SubItems[2], lvProxyList.Selected.SubItems[3]);
            end;
        1 : begin
              SaveProxy(PathToClient + '\asterios.ini', lvProxyList.Selected.Caption,
                        lvProxyList.Selected.SubItems[0], lvProxyList.Selected.SubItems[1],
                        lvProxyList.Selected.SubItems[2], lvProxyList.Selected.SubItems[3]);
            end;
        2 : begin
              SaveProxy(PathToClient + '\asterios\asteriosgame.ini', lvProxyList.Selected.Caption,
                        lvProxyList.Selected.SubItems[0], lvProxyList.Selected.SubItems[1],
                        lvProxyList.Selected.SubItems[2], lvProxyList.Selected.SubItems[3]);
              SaveProxy(PathToClient + '\asterios.ini', lvProxyList.Selected.Caption,
                        lvProxyList.Selected.SubItems[0], lvProxyList.Selected.SubItems[1],
                        lvProxyList.Selected.SubItems[2], lvProxyList.Selected.SubItems[3]);
            end;
      end;
      frmProxyDest.Free;
    end;
  end;
end;

procedure TfrmMain.btnSetDefaultProxySettingsClick(Sender: TObject);
var
  frmProxyDest: TfrmProxyDestination;
  selectedIndex: Integer;
begin
  frmProxyDest := TfrmProxyDestination.Create(Self);
  if frmProxyDest.ShowModal = mrOk then
  begin
    selectedIndex := frmProxyDest.SelectedIndex;
    case selectedIndex of
      0 : begin
            SaveProxy(PathToClient + '\asterios\asteriosgame.ini', '', '', 'NONE', '', '');
          end;
      1 : begin
            SaveProxy(PathToClient + '\asterios.ini', '', '', 'NONE', '', '');
          end;
      2 : begin
            SaveProxy(PathToClient + '\asterios\asteriosgame.ini', '', '', 'NONE', '', '');
            SaveProxy(PathToClient + '\asterios.ini', '', '', 'NONE', '', '');
          end;
    end;
    frmProxyDest.Free;
  end;
end;

procedure TfrmMain.btnSetPathToClientClick(Sender: TObject);
begin
  if OD.Execute then
  begin
    lbePathToClient.Text := OD.FileName;
    PathToClient := OD.FileName;
    ReadCurrentToken;
    SaveAppSettings;
  end;
end;

procedure TfrmMain.btnTestProxyClick(Sender: TObject);
var
  frmTestProxy: TfrmTestProxy;
  i: Integer;
  proxyList: TStringList;
begin
  proxyList := TStringList.Create;
  frmTestProxy := TfrmTestProxy.Create(Self);
  for i := 0 to lvProxyList.Items.Count - 1 do
    proxyList.Add(lvProxyList.Items[i].Caption);
  frmTestProxy.ProxyList := proxyList;
  frmTestProxy.ShowModal;
  btnTestProxy.Enabled := False;
  Timer.Enabled := True;
  frmTestProxy.Free;
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
  if cbAutoHide.Checked = True then
    Application.Minimize;
end;

procedure TfrmMain.SaveAppSettings;
var
  iniFile: TIniFile;
  i: Integer;
  TokenData: PTokenData;
begin
  iniFile := TIniFile.Create(AppWorkDir + '\settings.ini');
  iniFile.WriteString('Client', 'Path', PathToClient);
  iniFile.WriteBool('Client', 'Autoplay', cbAutoPlay.Checked);
  iniFile.WriteBool('Client', 'Autohide', cbAutoHide.Checked);
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
  if lvProxyList.Items.Count > 0 then
  begin
    inifile.EraseSection('ProxyHosts');
    inifile.EraseSection('ProxyPorts');
    inifile.EraseSection('ProxyTypes');
    inifile.EraseSection('ProxyUsers');
    inifile.EraseSection('ProxyPasswords');
    for i := 0 to lvProxyList.Items.Count - 1 do
    begin
      iniFile.WriteString('ProxyHosts', 'Host' + IntToStr(i + 1), lvProxyList.Items[i].Caption);
      iniFile.WriteString('ProxyPorts', 'Port' + IntToStr(i + 1), lvProxyList.Items[i].SubItems[0]);
      iniFile.WriteString('ProxyTypes', 'Type' + IntToStr(i + 1), lvProxyList.Items[i].SubItems[1]);
      iniFile.WriteString('ProxyUsers', 'User' + IntToStr(i + 1), lvProxyList.Items[i].SubItems[2]);
      iniFile.WriteString('ProxyPasswords', 'Password' + IntToStr(i + 1), lvProxyList.Items[i].SubItems[3]);
    end;
  end;
  iniFile.Free;
end;

procedure TfrmMain.TimerTimer(Sender: TObject);
begin
  btnTestProxy.Enabled := True;
  Timer.Enabled := False;
end;

procedure TfrmMain.TrayIconClick(Sender: TObject);
begin
  frmMain.Show;
  TrayIcon.Visible := False;
end;

procedure TfrmMain.cbAutoHideClick(Sender: TObject);
begin
  if (cbAutoHide.Tag = 0) then
    SaveAppSettings;
end;

procedure TfrmMain.cbAutoPlayClick(Sender: TObject);
begin
  if (cbAutoPlay.Tag = 0) then
    SaveAppSettings;
end;

procedure TfrmMain.cbUseJoystickClick(Sender: TObject);
begin
  if (cbUseJoystick.Tag = 0) then
    SaveClientSettings;
end;

procedure TfrmMain.cbUseWindowFrameClick(Sender: TObject);
begin
  if (cbUseWindowFrame.Tag = 0) then
    SaveClientSettings;
end;

procedure TfrmMain.edBrightnessKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #8,'0'..'9':
            if length(edBrightness.Text) = 1 then
              Key := '.'
            else
             if (Pos('.', edBrightness.Text) >= 0 ) and
                (length(edBrightness.Text) - pos('.', edBrightness.Text) > 5) and
                (Key <> #8) then Key := #0;
    '.':  begin
            if (Pos('.', edBrightness.Text) >= 0 ) or
               (length(edBrightness.Text) = 0) then Key := #0;
          end;
    else
     key := Chr(0);
  end;
end;

procedure TfrmMain.edContrastKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #8,'0'..'9':
            if length(edContrast.Text) = 1 then
              Key := '.'
            else
             if (Pos('.', edContrast.Text) >= 0 ) and
                (length(edContrast.Text) - pos('.', edContrast.Text) > 5) and
                (Key <> #8) then Key := #0;
    '.':  begin
            if (Pos('.', edContrast.Text) >= 0 ) or
               (length(edContrast.Text) = 0) then Key := #0;
          end;
    else
     key := Chr(0);
  end;
end;

procedure TfrmMain.edGammaKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #8,'0'..'9':
            if length(edGamma.Text) = 1 then
              Key := '.'
            else
             if (Pos('.', edGamma.Text) >= 0 ) and
                (length(edGamma.Text) - pos('.', edGamma.Text) > 5) and
                (Key <> #8) then Key := #0;
    '.':  begin
            if (Pos('.', edGamma.Text) >= 0 ) or
               (length(edGamma.Text) = 0) then Key := #0;
          end;
    else
     key := Chr(0);
  end;
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
  LoadAppSettings;
  ReadCurrentToken;
  LoadClientSettings;
end;

procedure TfrmMain.lbTokensDblClick(Sender: TObject);
var
  TokenData: PTokenData;
begin
  if (lbTokens.ItemIndex >= 0) then
  begin
    TokenData := PTokenData(lbTokens.Items.Objects[lbTokens.ItemIndex]);
    LastToken := TokenData.Token;
    RunWithToken(LastToken);
  end;
end;

procedure TfrmMain.LoadAppSettings;
var
  iniFile: TIniFile;
  i: Integer;
  Tokens, Notes, Hosts, Ports, Types, Users, Passwords: TStringList;
  TokenData: PTokenData;
  ListItem: TListItem;
begin
  iniFile := TIniFile.Create(AppWorkDir + '\settings.ini');
  PathToClient := iniFile.ReadString('Client', 'Path', '');
  lbePathToClient.Text := PathToClient;
  cbAutoPlay.Tag := 1;
  cbAutoHide.Tag := 1;
  cbAutoPlay.Checked := iniFile.ReadBool('Client', 'Autoplay', False);
  cbAutoHide.Checked := iniFile.ReadBool('Client', 'Autohide', False);
  cbAutoPlay.Tag := 0;
  cbAutoHide.Tag := 0;
  if (iniFile.SectionExists('Tokens') and iniFile.SectionExists('Notes')) then
  begin
    Tokens := TStringList.Create;
    Notes := TStringList.Create;
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
  if (iniFile.SectionExists('ProxyHosts') and iniFile.SectionExists('ProxyPorts') and
      iniFile.SectionExists('ProxyTypes') and iniFile.SectionExists('ProxyUsers') and
      iniFile.SectionExists('ProxyPasswords')) then
  begin
    Hosts := TStringList.Create;
    Ports := TStringList.Create;
    Types := TStringList.Create;
    Users := TStringList.Create;
    Passwords := TStringList.Create;
    iniFile.ReadSectionValues('ProxyHosts', Hosts);
    iniFile.ReadSectionValues('ProxyPorts', Ports);
    iniFile.ReadSectionValues('ProxyTypes', Types);
    iniFile.ReadSectionValues('ProxyUsers', Users);
    iniFile.ReadSectionValues('ProxyPasswords', Passwords);
    lvProxyList.Items.Clear;
    for i := 0 to Hosts.Count - 1 do
    begin
      ListItem := lvProxyList.Items.Add;
      ListItem.Caption := StringReplace(Hosts[i], 'Host' + IntToStr(i + 1) + '=', '', [rfReplaceAll]);
      with ListItem.SubItems do
      begin
        Add(StringReplace(Ports[i], 'Port' + IntToStr(i + 1) + '=', '', [rfReplaceAll]));
        Add(StringReplace(Types[i], 'Type' + IntToStr(i + 1) + '=', '', [rfReplaceAll]));
        Add(StringReplace(Users[i], 'User' + IntToStr(i + 1) + '=', '', [rfReplaceAll]));
        Add(StringReplace(Passwords[i], 'Password' + IntToStr(i + 1) + '=', '', [rfReplaceAll]));
      end;
    end;
  end;
  Tokens.Free;
  Notes.Free;
  Hosts.Free;
  Ports.Free;
  Types.Free;
  Users.Free;
  Passwords.Free;
  iniFile.Free;
end;

procedure TfrmMain.miAddProxyManuallyClick(Sender: TObject);
var
  frmNewProxy: TfrmAddProxy;
  ListItem: TListItem;
begin
  frmNewProxy := TfrmAddProxy.Create(Self);
  if frmNewProxy.ShowModal = mrOk then
  begin
    ListItem := lvProxyList.Items.Add;
    ListItem.Caption := frmNewProxy.ProxyHost;
    with ListItem.SubItems do
    begin
      Add(frmNewProxy.ProxyPort.ToString);
      Add(frmNewProxy.ProxyType);
      Add(frmNewProxy.ProxyUser);
      Add(frmNewProxy.ProxyPassword);
    end;
    SaveAppSettings;
  end;
  frmNewProxy.Free;
end;

procedure TfrmMain.miExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.miLastTokenClick(Sender: TObject);
begin
  RunWithToken(LastToken);
end;

procedure TfrmMain.miUseParserClick(Sender: TObject);
var
  frmProxyParser: TfrmProxyParser;
  i: Integer;
  ListItem: TListItem;
  ProxyString: TStringList;
begin
  frmProxyParser := TfrmProxyParser.Create(Self);
  if frmProxyParser.ShowModal = mrOk then
  begin
    for I := 0 to frmProxyParser.ProxyList.Count - 1 do
    begin
      ProxyString := TStringList.Create;
      ProxyString.Delimiter := ':';
      ProxyString.DelimitedText := frmProxyParser.ProxyList[i];
      ListItem := lvProxyList.Items.Add;
      ListItem.Caption := ProxyString[0];
      with ListItem.SubItems do
      begin
        Add(ProxyString[1]);
        Add('HTTP');
        Add('');
        Add('');
      end;
      ListItem := lvProxyList.Items.Add;
      ListItem.Caption := ProxyString[0];
      with ListItem.SubItems do
      begin
        Add(ProxyString[1]);
        Add('HTTPS');
        Add('');
        Add('');
      end;
      ProxyString.Free;
    SaveAppSettings;
    end;
  end;
  frmProxyParser.Free;
end;

procedure TfrmMain.SaveProxy(Filename, ProxyHost,ProxyPort, ProxyType, ProxyUser, ProxyPassword: String);
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(Filename);
  iniFile.WriteString('Proxy', 'Host', ProxyHost);
  iniFile.WriteString('Proxy', 'Port', ProxyPort);
  iniFile.WriteString('Proxy', 'Protocol', ProxyType);
  iniFile.WriteString('Proxy', 'User', ProxyUser);
  iniFile.WriteString('Proxy', 'Pass', ProxyPassword);
  iniFile.Free;
end;

procedure TfrmMain.LoadClientSettings;
var
  iniFile: TIniFile;
  priority: string;
  cachesize: Word;
  i: Integer;
begin
  iniFile := TIniFile.Create(PathToClient + '\asterios\asteriosgame.ini');
  cbUseWindowFrame.Tag := 1;
  cbUseJoystick.Tag := 1;
  cbUseWindowFrame.Checked := iniFile.ReadBool('L2', 'UseWindowFrame', False);
  cbUseJoystick.Checked := iniFile.ReadBool('L2', 'UseJoystick', False);
  cbUseWindowFrame.Tag := 0;
  cbUseJoystick.Tag := 0;
  edContrast.Text := iniFile.ReadString('L2', 'Contrast', '0.00000');
  edBrightness.Text := iniFile.ReadString('L2', 'Brightness', '0.00000');
  edGamma.Text := iniFile.ReadString('L2', 'Gamma', '0.00000');
  priority := iniFile.ReadString('Options', 'Priority', 'NORMAL').ToUpper;
  for i := 0 to cmbProcessPriority.Items.Count - 1 do
    if (cmbProcessPriority.Items[i] = priority) then
    begin
      cmbProcessPriority.ItemIndex := i;
      break;
    end
    else
      cmbProcessPriority.ItemIndex := 2;
  cachesize := iniFile.ReadInteger('L2', 'CacheSizeMegs', 32);
  for i := 0 to cmbCacheSizeMegs.Items.Count - 1 do
    if (cmbCacheSizeMegs.Items[i] = cachesize.ToString) then
    begin
      cmbCacheSizeMegs.ItemIndex := i;
      break;
    end
    else
      cmbCacheSizeMegs.ItemIndex := 0;
  edReplayTimeLimit.Text := iniFile.ReadInteger('Options', 'ReplayTimeLimit', 30).ToString;
  iniFile.Free;
end;

procedure TfrmMain.lvProxyListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LastIndex: Integer;
begin
  if Key = VK_DELETE then
    if lvProxyList.ItemIndex >= 0 then
    begin
      LastIndex := lvProxyList.Selected.Index;
      lvProxyList.Items[LastIndex].Delete;
      if (LastIndex <= lvProxyList.Items.Count - 1) then
        lvProxyList.ItemIndex := LastIndex
      else
        if lvProxyList.Items.Count > 0 then
          lvProxyList.ItemIndex := lvProxyList.Items.Count - 1;
      SaveAppSettings;
    end;
end;

procedure TfrmMain.SaveClientSettings;
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create(PathToClient + '\asterios\asteriosgame.ini');
  iniFile.WriteBool('L2', 'UseWindowFrame', cbUseWindowFrame.Checked);
  iniFile.WriteBool('L2', 'UseJoystick', cbUseJoystick.Checked);
  iniFile.WriteString('L2', 'Contrast', edContrast.Text);
  iniFile.WriteString('L2', 'Brightness', edBrightness.Text);
  iniFile.WriteString('L2', 'Gamma', edGamma.Text);
  iniFile.WriteString('L2', 'CacheSizeMegs', cmbCacheSizeMegs.Items[cmbCacheSizeMegs.ItemIndex]);
  iniFile.WriteString('Options', 'Priority', cmbProcessPriority.Items[cmbProcessPriority.ItemIndex]);
  iniFile.WriteString('Options', 'ReplayTimeLimit', edReplayTimeLimit.Text);
  iniFile.Free;
end;

end.
