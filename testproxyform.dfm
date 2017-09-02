object frmTestProxy: TfrmTestProxy
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Test Proxy'
  ClientHeight = 238
  ClientWidth = 286
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    286
    238)
  PixelsPerInch = 96
  TextHeight = 13
  object lblProxyListTitle: TLabel
    Left = 8
    Top = 5
    Width = 148
    Height = 13
    Caption = #1057#1087#1080#1089#1086#1082' '#1090#1077#1089#1090#1080#1088#1091#1077#1084#1099#1093' '#1087#1088#1086#1082#1089#1080':'
  end
  object lbProxyList: TListBox
    Left = 8
    Top = 24
    Width = 270
    Height = 175
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 203
    Top = 205
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnTest: TButton
    Left = 8
    Top = 205
    Width = 75
    Height = 25
    Caption = #1058#1077#1089#1090
    TabOrder = 2
    OnClick = btnTestClick
  end
  object IdIcmpClient: TIdIcmpClient
    ReceiveTimeout = 2000
    Protocol = 1
    ProtocolIPv6 = 58
    IPVersion = Id_IPv4
    Left = 56
    Top = 48
  end
end
