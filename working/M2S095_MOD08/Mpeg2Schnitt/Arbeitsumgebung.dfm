object ArbeitsumgebungFenster: TArbeitsumgebungFenster
  Left = 466
  Top = 294
  ActiveControl = OKTaste
  BorderStyle = bsDialog
  Caption = 'Arbeitsumgebungsfenster'
  ClientHeight = 416
  ClientWidth = 582
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    582
    416)
  PixelsPerInch = 96
  TextHeight = 14
  object ArbeitsumgebungAllgemein_: TGroupBox
    Left = 8
    Top = 12
    Width = 565
    Height = 123
    Caption = 'Allgemeine Einstellungen'
    TabOrder = 2
    object Arbeitsumgebungverzeichnis_: TLabel
      Left = 8
      Top = 24
      Width = 60
      Height = 14
      Caption = 'Verzeichnis'
    end
    object ArbeitsumgebungenverzeichnisEdit: TEdit
      Left = 132
      Top = 22
      Width = 253
      Height = 22
      PopupMenu = ArbeitsumgebungenverzeichnisMenue
      TabOrder = 0
      OnDblClick = ArbeitsumgebungenverzeichnisEditDblClick
    end
    object ArbeitsumgebungaktbeiEndespeichernBox: TCheckBox
      Left = 10
      Top = 78
      Width = 545
      Height = 17
      Caption = 'aktuelle Arbeitsumg. bei Programmende speichern'
      TabOrder = 4
    end
    object ArbeitsumgebungBeiStartStandardladenBox: TCheckBox
      Left = 10
      Top = 58
      Width = 545
      Height = 17
      Caption = 'bei Programmstart Standard laden'
      TabOrder = 3
    end
    object ArbeitsumgebungbeiOKspeichernBox: TCheckBox
      Left = 10
      Top = 98
      Width = 545
      Height = 17
      Caption = 'Arbeitsumgebung bei OK speichern'
      TabOrder = 5
    end
    object ArbeitsumgebungverzeichnisspeichernBox: TCheckBox
      Left = 424
      Top = 24
      Width = 137
      Height = 17
      Caption = 'Verzeichnis '#228'ndern'
      TabOrder = 2
    end
    object ArbeitsumgebungenverzeichnisBitBtn: TBitBtn
      Left = 392
      Top = 23
      Width = 25
      Height = 21
      Caption = '-->'
      TabOrder = 1
      OnClick = ArbeitsumgebungenverzeichnisBitBtnClick
    end
  end
  object ArbeitsumgebungListe_: TGroupBox
    Left = 8
    Top = 150
    Width = 565
    Height = 89
    Caption = 'Arbeitsumgebungsliste'
    TabOrder = 3
    object Arbeitsumgebungakt_: TLabel
      Left = 10
      Top = 28
      Width = 143
      Height = 14
      Caption = 'aktuelle Arbeitsumgebung'
    end
    object ArbeitsumgebungenListe_: TLabel
      Left = 10
      Top = 60
      Width = 123
      Height = 14
      Caption = 'Arbeitsumgebungsliste'
    end
    object ArbeitsumgebungenListeComboBox: TComboBox
      Left = 160
      Top = 56
      Width = 253
      Height = 22
      AutoComplete = False
      ItemHeight = 14
      PopupMenu = ArbeitsumgebungenMenu
      TabOrder = 1
      OnDblClick = ArbeitsumgebungenListeComboBoxDblClick
    end
    object ArbeitsumgebungenListeBitBtn: TBitBtn
      Left = 420
      Top = 57
      Width = 25
      Height = 21
      Caption = '-->'
      TabOrder = 2
      OnClick = ArbeitsumgebungenListeBitBtnClick
    end
    object aktArbeitsumgebungComboBox: TComboBox
      Left = 160
      Top = 24
      Width = 253
      Height = 22
      AutoComplete = False
      Style = csDropDownList
      ItemHeight = 14
      TabOrder = 0
    end
  end
  object Arbeitsumgebungbearbeiten_: TGroupBox
    Left = 8
    Top = 252
    Width = 565
    Height = 51
    Caption = 'Arbeitsumgebung bearbeiten'
    TabOrder = 4
    object ArbeitsumgebungOeffnenTaste: TBitBtn
      Left = 156
      Top = 18
      Width = 130
      Height = 21
      Hint = 'Arbeitsumgebung '#246'ffnen'
      Caption = #214'ffnen/Bearbeiten'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = ArbeitsumgebungOeffnenTasteClick
    end
  end
  object AbbrechenTaste: TBitBtn
    Left = 34
    Top = 366
    Width = 100
    Height = 35
    Hint = 'Einstellungen verwerfen'
    Anchors = [akLeft, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Kind = bkAbort
  end
  object OKTaste: TBitBtn
    Left = 450
    Top = 366
    Width = 100
    Height = 35
    Hint = 'Einstellungen '#252'bernehmen'
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ParentShowHint = False
    ShowHint = True
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
  object ArbeitsumgebungenMenu: TPopupMenu
    OnPopup = ArbeitsumgebungenMenuPopup
    Left = 166
    Top = 318
    object Listeneintrageinfuegen: TMenuItem
      Caption = 'Eintrag einf'#252'gen'
      OnClick = ListeneintrageinfuegenClick
    end
    object Listeneintragbearbeiten: TMenuItem
      Caption = 'Eintrag bearbeiten'
      OnClick = ListeneintragbearbeitenClick
    end
    object Listeneintragloeschen: TMenuItem
      Caption = 'Eintrag l'#246'schen'
      OnClick = ListeneintragloeschenClick
    end
  end
  object ArbeitsumgebungenverzeichnisMenue: TPopupMenu
    OnPopup = ArbeitsumgebungenverzeichnisMenuePopup
    Left = 70
    Top = 318
    object EditBoxVerzeichnissuchen: TMenuItem
      Caption = 'Verzeichnis suchen'
      OnClick = EditBoxVerzeichnissuchenClick
    end
    object Trennlienie21: TMenuItem
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
