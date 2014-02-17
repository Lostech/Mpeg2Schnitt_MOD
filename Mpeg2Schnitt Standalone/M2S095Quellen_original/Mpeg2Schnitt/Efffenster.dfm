object Effektfenster: TEffektfenster
  Left = 852
  Top = 312
  ActiveControl = OKTaste
  BorderStyle = bsDialog
  Caption = 'Effektfenster'
  ClientHeight = 324
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object OKTaste: TBitBtn
    Left = 228
    Top = 280
    Width = 90
    Height = 35
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = OKTasteClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object AbbrechenTaste: TBitBtn
    Left = 50
    Top = 280
    Width = 90
    Height = 35
    TabOrder = 1
    Kind = bkCancel
  end
  object EffektAnfangGroupBox: TGroupBox
    Left = 2
    Top = 58
    Width = 375
    Height = 119
    Caption = 'Anfangseffekt'
    TabOrder = 3
    object EffektAnfangEinstellungen_: TLabel
      Left = 8
      Top = 70
      Width = 76
      Height = 14
      Caption = 'Einstellungen:'
    end
    object EffektZeitAnfang_: TLabel
      Left = 228
      Top = 22
      Width = 56
      Height = 14
      Caption = 'Effektzeit:'
    end
    object EffektSekunden1_: TLabel
      Left = 350
      Top = 22
      Width = 15
      Height = 14
      Caption = 'ms'
    end
    object EffektAnfangComboBox: TComboBox
      Left = 8
      Top = 18
      Width = 169
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 0
      OnCloseUp = EffektAnfangComboBoxCloseUp
    end
    object EffektAnfangParameterEdit: TEdit
      Left = 8
      Top = 88
      Width = 357
      Height = 22
      TabOrder = 3
    end
    object EffektZeitAnfangEdit: TEdit
      Left = 286
      Top = 18
      Width = 59
      Height = 22
      TabOrder = 1
      Text = '0'
    end
    object EffektgesamterSchnittCheckBox: TCheckBox
      Left = 8
      Top = 46
      Width = 359
      Height = 17
      Caption = 'Anfangseffekt '#252'ber den gesamten Schnitt anwenden'
      TabOrder = 2
      OnClick = EffektgesamterSchnittCheckBoxClick
    end
  end
  object EffektEndeGroupBox: TGroupBox
    Left = 2
    Top = 178
    Width = 375
    Height = 93
    Caption = 'Endeffekt'
    TabOrder = 4
    object EffektEndeEinstellungen_: TLabel
      Left = 8
      Top = 44
      Width = 76
      Height = 14
      Caption = 'Einstellungen:'
    end
    object EffektSekunden2_: TLabel
      Left = 350
      Top = 22
      Width = 15
      Height = 14
      Caption = 'ms'
    end
    object EffektZeitEnde_: TLabel
      Left = 228
      Top = 22
      Width = 56
      Height = 14
      Caption = 'Effektzeit:'
    end
    object EffektEndeComboBox: TComboBox
      Left = 8
      Top = 18
      Width = 169
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 0
      OnCloseUp = EffektEndeComboBoxCloseUp
    end
    object EffektEndeParameterEdit: TEdit
      Left = 8
      Top = 62
      Width = 357
      Height = 22
      TabOrder = 2
    end
    object EffektZeitEndeEdit: TEdit
      Left = 286
      Top = 18
      Width = 59
      Height = 22
      TabOrder = 1
      Text = '0'
    end
  end
  object EffektvorgabenGroupBox: TGroupBox
    Left = 2
    Top = 6
    Width = 375
    Height = 51
    Caption = 'Effektvorgaben'
    TabOrder = 2
    object EffektvorgabenComboBox: TComboBox
      Left = 8
      Top = 20
      Width = 169
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 0
      OnCloseUp = EffektvorgabenComboBoxCloseUp
    end
  end
  object EffektvorgabeGroupBox: TGroupBox
    Left = 2
    Top = 6
    Width = 375
    Height = 51
    Caption = 'Effektvorgabe'
    TabOrder = 5
    object EffektvorgabeEdit: TEdit
      Left = 8
      Top = 18
      Width = 169
      Height = 22
      TabOrder = 0
    end
  end
end
