object frmProxyDestination: TfrmProxyDestination
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1090#1080#1087#1072
  ClientHeight = 131
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 301
    Height = 89
    Align = alTop
    Color = clBtnHighlight
    ParentBackground = False
    TabOrder = 0
    object rgProxyDestination: TRadioGroup
      Left = 1
      Top = 1
      Width = 299
      Height = 87
      Align = alClient
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1088#1086#1082#1089#1080
      ItemIndex = 0
      Items.Strings = (
        #1044#1083#1103' '#1082#1083#1080#1077#1085#1090#1072
        #1044#1083#1103' '#1072#1087#1076#1077#1081#1090#1077#1088#1072
        #1044#1083#1103' '#1074#1089#1077#1075#1086)
      TabOrder = 0
    end
  end
  object bntOK: TButton
    Left = 137
    Top = 98
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 218
    Top = 98
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
