object Ausgabefenster: TAusgabefenster
  Left = 672
  Top = 327
  Width = 589
  Height = 306
  ActiveControl = OKTaste
  Caption = 'Ausgabefenster'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object AusgabeProgrammName_: TLabel
    Left = 14
    Top = 54
    Width = 89
    Height = 14
    Caption = 'Programmname:'
  end
  object AusgabeProgrammParameter_: TLabel
    Left = 14
    Top = 80
    Width = 115
    Height = 14
    Caption = 'Programmparameter:'
  end
  object AusgabeParameter_: TLabel
    Left = 14
    Top = 104
    Width = 60
    Height = 14
    Caption = 'Parameter:'
  end
  object AusgabeOrgParameterDatei_: TLabel
    Left = 14
    Top = 132
    Width = 113
    Height = 14
    Caption = 'org. Parameterdatei:'
  end
  object AusgabeParameterDateiName_: TLabel
    Left = 14
    Top = 158
    Width = 87
    Height = 14
    Caption = 'Parameterdatei:'
  end
  object AusgabeEinstellungen_: TLabel
    Left = 14
    Top = 184
    Width = 76
    Height = 14
    Caption = 'Einstellungen:'
  end
  object AusgabeName_: TLabel
    Left = 14
    Top = 28
    Width = 35
    Height = 14
    Caption = 'Name:'
  end
  object ProgrammNameEdit: TEdit
    Left = 132
    Top = 50
    Width = 408
    Height = 22
    PopupMenu = EditBoxPopupMenu
    TabOrder = 3
    OnContextPopup = EditBoxContextPopup
    OnDblClick = EditBoxDblClick
  end
  object ProgrammParameterEdit: TEdit
    Left = 132
    Top = 76
    Width = 408
    Height = 22
    TabOrder = 5
  end
  object ParameterEdit: TEdit
    Left = 132
    Top = 102
    Width = 408
    Height = 22
    TabOrder = 6
  end
  object OrgParameterDateiEdit: TEdit
    Left = 132
    Top = 128
    Width = 408
    Height = 22
    PopupMenu = EditBoxPopupMenu
    TabOrder = 7
    OnContextPopup = EditBoxContextPopup
    OnDblClick = EditBoxDblClick
  end
  object ParameterDateiNameEdit: TEdit
    Left = 132
    Top = 154
    Width = 408
    Height = 22
    PopupMenu = EditBoxPopupMenu
    TabOrder = 9
    OnContextPopup = EditBoxContextPopup
    OnDblClick = EditBoxDblClick
  end
  object AbbrechenTaste: TBitBtn
    Left = 90
    Top = 228
    Width = 100
    Height = 35
    TabOrder = 1
    OnClick = AbbrechenTasteClick
    Kind = bkCancel
  end
  object OKTaste: TBitBtn
    Left = 390
    Top = 228
    Width = 100
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
  object EinstellungenEdit: TEdit
    Left = 132
    Top = 180
    Width = 408
    Height = 22
    TabOrder = 11
  end
  object NameEdit: TEdit
    Left = 132
    Top = 24
    Width = 408
    Height = 22
    TabOrder = 2
  end
  object ProgrammNameBitBtn: TBitBtn
    Left = 544
    Top = 50
    Width = 25
    Height = 21
    Caption = '-->'
    TabOrder = 4
    OnClick = EditBoxBitBtnClick
  end
  object OrgParameterDateiBitBtn: TBitBtn
    Left = 544
    Top = 130
    Width = 25
    Height = 21
    Caption = '-->'
    TabOrder = 8
    OnClick = EditBoxBitBtnClick
  end
  object ParameterDateiNameBitBtn: TBitBtn
    Left = 544
    Top = 154
    Width = 25
    Height = 21
    Caption = '-->'
    TabOrder = 10
    OnClick = EditBoxBitBtnClick
  end
  object EditBoxPopupMenu: TPopupMenu
    OnPopup = EditBoxPopupMenuPopup
    Left = 210
    Top = 230
    object EditBoxDateisuchen: TMenuItem
      Caption = 'Datei suchen'
      OnClick = EditBoxDateisuchenClick
    end
    object EditBoxVerzeichnissuchen: TMenuItem
      Caption = 'Verzeichnis suchen'
      OnClick = EditBoxVerzeichnissuchenClick
    end
    object Trennlinie22: TMenuItem
      Caption = '-'
    end
    object EditBoxAusschneidenClipboard: TMenuItem
      Caption = 'Ausschneiden'
      OnClick = EditBoxAusschneidenClipboardClick
    end
    object EditBoxKopierenClipboard: TMenuItem
      Caption = 'Kopieren'
      OnClick = EditBoxKopierenClipboardClick
    end
    object EditBoxEinfuegenClipboard: TMenuItem
      Caption = 'Einf'#252'gen'
      OnClick = EditBoxEinfuegenClipboardClick
    end
    object EditBoxLoeschenClipboard: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = EditBoxLoeschenClipboardClick
    end
  end
end
