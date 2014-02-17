object UeberFenster: TUeberFenster
  Left = 561
  Top = 275
  ActiveControl = OKTaste
  BorderStyle = bsDialog
  Caption = #220'ber dieses Programm'
  ClientHeight = 423
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    592
    423)
  PixelsPerInch = 96
  TextHeight = 14
  object ProgramIcon: TImage
    Left = 30
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
  object ProgrammName_: TLabel
    Left = 112
    Top = 12
    Width = 89
    Height = 14
    Caption = 'Programmname:'
    IsControl = True
  end
  object Copyright_: TLabel
    Left = 112
    Top = 32
    Width = 56
    Height = 14
    Caption = 'Copyright:'
    IsControl = True
  end
  object Internet_: TLabel
    Left = 112
    Top = 52
    Width = 76
    Height = 14
    Caption = 'Internetseite:'
  end
  object EMail_: TLabel
    Left = 112
    Top = 72
    Width = 34
    Height = 14
    Caption = 'E-Mail:'
  end
  object Programmname: TLabel
    Left = 216
    Top = 12
    Width = 7
    Height = 14
    Caption = '_'
  end
  object Copyright: TLabel
    Left = 216
    Top = 32
    Width = 7
    Height = 14
    Caption = '_'
  end
  object Internetseite: TLabel
    Left = 216
    Top = 52
    Width = 7
    Height = 14
    Cursor = crHandPoint
    Caption = '_'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = InternetseiteClick
  end
  object E_Mail: TLabel
    Left = 216
    Top = 72
    Width = 7
    Height = 14
    Cursor = crHandPoint
    Caption = '_'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = E_MailClick
  end
  object Version_: TLabel
    Left = 396
    Top = 12
    Width = 44
    Height = 14
    Caption = 'Version:'
    IsControl = True
  end
  object Versi: TLabel
    Left = 450
    Top = 12
    Width = 7
    Height = 14
    Caption = '_'
  end
  object Sprache_: TLabel
    Left = 16
    Top = 321
    Width = 304
    Height = 14
    Anchors = [akLeft, akBottom]
    Caption = 'Sprachen / Languages/ Idiomas / Langues / Lingue / ...'
  end
  object OKTaste: TButton
    Left = 236
    Top = 381
    Width = 121
    Height = 31
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = OKTasteClick
  end
  object akzeptiert: TCheckBox
    Left = 290
    Top = 349
    Width = 289
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Den Lizenzvertrag akzeptieren.'
    TabOrder = 4
  end
  object Lizenzvertrag: TButton
    Left = 100
    Top = 349
    Width = 117
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'Lizenzvertrag'
    TabOrder = 3
    OnClick = LizenzvertragClick
  end
  object Sprachbox: TComboBox
    Left = 388
    Top = 315
    Width = 191
    Height = 22
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemHeight = 14
    TabOrder = 2
    OnChange = SprachboxChange
  end
  object TextRichEdit: TRichEdit
    Left = 10
    Top = 98
    Width = 573
    Height = 205
    TabStop = False
    Anchors = [akLeft, akTop, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    WordWrap = False
  end
  object Komponenten: TButton
    Left = 28
    Top = 396
    Width = 25
    Height = 25
    Caption = 'K'
    TabOrder = 5
    Visible = False
    OnClick = KomponentenClick
  end
end
