object frmAddProxy: TfrmAddProxy
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1086#1082#1089#1080' '#1089#1077#1088#1074#1077#1088
  ClientHeight = 188
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 93
    Top = 155
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 174
    Top = 155
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 257
    Height = 149
    Align = alTop
    Color = clBtnHighlight
    ParentBackground = False
    TabOrder = 2
    object lblProxyType: TLabel
      Left = 104
      Top = 51
      Width = 18
      Height = 13
      Caption = #1058#1080#1087
    end
    object lbeProxyHost: TLabeledEdit
      Left = 8
      Top = 24
      Width = 241
      Height = 21
      EditLabel.Width = 31
      EditLabel.Height = 13
      EditLabel.Caption = #1040#1076#1088#1077#1089
      TabOrder = 0
    end
    object lbeProxyPort: TLabeledEdit
      Left = 8
      Top = 67
      Width = 90
      Height = 21
      EditLabel.Width = 25
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1086#1088#1090
      NumbersOnly = True
      TabOrder = 1
    end
    object cmbProxyType: TComboBox
      Left = 104
      Top = 67
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'HTTP'
      Items.Strings = (
        'HTTP'
        'HTTPS'
        'SOCKS4'
        'SOCKS5')
    end
    object lbeProxyUser: TLabeledEdit
      Left = 8
      Top = 110
      Width = 114
      Height = 21
      EditLabel.Width = 72
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      TabOrder = 3
    end
    object lbeProxyPassword: TLabeledEdit
      Left = 128
      Top = 110
      Width = 121
      Height = 21
      EditLabel.Width = 37
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1072#1088#1086#1083#1100
      PasswordChar = '*'
      TabOrder = 4
    end
  end
end
