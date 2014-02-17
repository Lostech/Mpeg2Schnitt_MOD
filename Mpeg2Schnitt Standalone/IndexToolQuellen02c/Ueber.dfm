object UeberFenster: TUeberFenster
  Left = 499
  Top = 290
  BorderStyle = bsDialog
  Caption = #220'ber dieses Programm'
  ClientHeight = 364
  ClientWidth = 519
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 505
    Height = 277
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    object ProgramIcon: TImage
      Left = 40
      Top = 20
      Width = 33
      Height = 33
      Picture.Data = {
        055449636F6E0000010001002020100000000000E80200001600000028000000
        2000000040000000010004000000000080020000000000000000000000000000
        0000000000000000000080000080000000808000800000008000800080800000
        80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
        FFFFFF0000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000000000000000000000F000000000
        000000000000000000000F000F0000000000000000000000000000F00F000000
        000000000000000000000000000000000000000000000F00F0F0000000000000
        000000000000F000F0000000000000000000000000000F00F000000000000000
        000000000000000000000000FFF000000000000000000000000000F000FFFF00
        0000000000000000000000F00000FFF00000000000000000000000F0000000FF
        0000000000000000000000F000000000F0000000000000000000000F00000000
        00000000000000000000000F0000000000000000000888888888880888888880
        0000000000000800080008000080008000000000000908090809080090009080
        0000000000090809080908090000908000000000000908090809080900809080
        0000000000090809080908090800908000000000000900900090000090009080
        0000000000000000000000000000908000000000000000000000000000009080
        0000000000000000000000000000908000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000FFFFFFFFFFF87FFFFFF03FFFFFF19FFFFFF39FFFF8719FFFF2113FFF
        E3007FFFE703FFFFE3381FFFF33803FFF87801FFFFF8C0FFFFF8F07FFFF8FC3F
        FFFC7F1FFFFC7FCFE00201F7C00201FFC00001FFC00061FFC00001FFC00001FF
        C00401FFC48E21FFFFFFE1FFFFFFE1FFFFFFE3FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF}
      Stretch = True
      IsControl = True
    end
    object ProductName: TLabel
      Left = 112
      Top = 16
      Width = 76
      Height = 13
      Caption = 'Programmname:'
      IsControl = True
    end
    object Version: TLabel
      Left = 280
      Top = 16
      Width = 38
      Height = 13
      Caption = 'Version:'
      IsControl = True
    end
    object Copyright: TLabel
      Left = 112
      Top = 36
      Width = 47
      Height = 13
      Caption = 'Copyright:'
      IsControl = True
    end
    object Kommentar1: TLabel
      Left = 12
      Top = 104
      Width = 481
      Height = 93
      AutoSize = False
      WordWrap = True
      IsControl = True
    end
    object Kommentar2: TLabel
      Left = 12
      Top = 212
      Width = 481
      Height = 57
      AutoSize = False
      WordWrap = True
      IsControl = True
    end
    object Internet_: TLabel
      Left = 112
      Top = 56
      Width = 61
      Height = 13
      Caption = 'Internetseite:'
    end
    object EMail_: TLabel
      Left = 112
      Top = 76
      Width = 29
      Height = 13
      Caption = 'EMail:'
    end
  end
  object OKButton: TButton
    Left = 227
    Top = 324
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = OKButtonClick
  end
  object akzeptiert: TCheckBox
    Left = 260
    Top = 296
    Width = 169
    Height = 17
    Caption = 'Den Lizenzvertrag akzeptieren.'
    TabOrder = 2
  end
  object Lizenzvertrag: TButton
    Left = 100
    Top = 292
    Width = 89
    Height = 21
    Caption = 'Lizenzvertrag'
    TabOrder = 3
    OnClick = LizenzvertragClick
  end
end
