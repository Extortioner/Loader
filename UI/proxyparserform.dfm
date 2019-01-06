object frmProxyParser: TfrmProxyParser
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1089#1077#1088' proxy '#1089#1077#1088#1074#1077#1088#1086#1074
  ClientHeight = 207
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lblProxySourceList: TLabel
    Left = 8
    Top = 8
    Width = 121
    Height = 13
    Caption = #1040#1076#1088#1077#1089#1072' '#1089#1072#1081#1090#1086#1074' '#1089' '#1087#1088#1086#1082#1089#1080
  end
  object lblProxyList: TLabel
    Left = 263
    Top = 8
    Width = 144
    Height = 13
    Caption = #1057#1087#1080#1089#1086#1082' '#1080#1079#1074#1083#1077#1095#1077#1085#1085#1099#1093' '#1087#1088#1086#1082#1089#1080
  end
  object lblProgressState: TLabel
    Left = 128
    Top = 186
    Width = 78
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = #1048#1079#1074#1083#1077#1082#1072#1077#1084': '
    Layout = tlCenter
  end
  object mmProxySourceList: TMemo
    Left = 8
    Top = 24
    Width = 249
    Height = 145
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object mmProxyList: TMemo
    Left = 263
    Top = 24
    Width = 242
    Height = 145
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object btnParse: TButton
    Left = 8
    Top = 175
    Width = 75
    Height = 25
    Caption = #1048#1079#1074#1083#1077#1095#1100
    TabOrder = 2
    OnClick = btnParseClick
  end
  object btnAdd: TButton
    Left = 349
    Top = 175
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 430
    Top = 175
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object pbProgress: TProgressBar
    Left = 89
    Top = 182
    Width = 249
    Height = 17
    Step = 1
    TabOrder = 5
  end
  object HTTP: TIdHTTP
    OnWork = HTTPWork
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams, hoNoProtocolErrorException]
    Left = 24
    Top = 32
  end
end
