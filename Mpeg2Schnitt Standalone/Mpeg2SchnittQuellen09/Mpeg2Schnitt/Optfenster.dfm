object Optionenfenster: TOptionenfenster
  Left = 613
  Top = 329
  ActiveControl = OKTaste
  BorderStyle = bsDialog
  Caption = 'Optionenfenster'
  ClientHeight = 456
  ClientWidth = 581
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    581
    456)
  PixelsPerInch = 96
  TextHeight = 14
  object OKTaste: TBitBtn
    Left = 458
    Top = 413
    Width = 90
    Height = 35
    Hint = 'Einstellungen '#252'bernehmen'
    Anchors = [akLeft, akBottom]
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
  object AbbrechenTaste: TBitBtn
    Left = 34
    Top = 413
    Width = 90
    Height = 35
    Hint = 'Einstellungen verwerfen'
    Anchors = [akLeft, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Kind = bkAbort
  end
  object OptionenSeiten: TPageControl
    Left = 0
    Top = 0
    Width = 581
    Height = 402
    ActivePage = OptionenEffektseiteTab
    HotTrack = True
    MultiLine = True
    TabHeight = 20
    TabOrder = 5
    object OptionenAllgemeinSeiteTab: TTabSheet
      Caption = 'Allgemein'
      object OptionenAllgemeineEinstellungen_: TGroupBox
        Left = 4
        Top = 4
        Width = 279
        Height = 323
        Caption = 'Allgemeine Einstellungen'
        TabOrder = 0
        object OptionenHinweisanzeigedauer_: TLabel
          Left = 10
          Top = 176
          Width = 117
          Height = 14
          Caption = 'Hinweisanzeigedauer:'
        end
        object OptionenfesteFramerate_: TLabel
          Left = 237
          Top = 70
          Width = 16
          Height = 14
          Caption = 'fps'
        end
        object OptionenHinweisanzeigedauerSek_: TLabel
          Left = 200
          Top = 176
          Width = 55
          Height = 14
          Caption = 'Sekunden'
        end
        object OptionenBeendenanzeigedauer_: TLabel
          Left = 10
          Top = 200
          Width = 125
          Height = 14
          Caption = 'Beendenanzeigedauer:'
        end
        object OptionenBeendenanzeigedauerSek_: TLabel
          Left = 200
          Top = 200
          Width = 55
          Height = 14
          Caption = 'Sekunden'
        end
        object OptionenIndexdateienloeschenBox: TCheckBox
          Left = 10
          Top = 26
          Width = 265
          Height = 17
          Caption = 'Indexdateien beim Beenden l'#246'schen'
          TabOrder = 0
        end
        object OptionenProtokollerstellenBox: TCheckBox
          Left = 10
          Top = 48
          Width = 265
          Height = 17
          Caption = 'Protokoll erstellen (unvollst'#228'ndig)'
          TabOrder = 1
        end
        object OptionenfesteFramerateverwendenBox: TCheckBox
          Left = 10
          Top = 70
          Width = 179
          Height = 17
          Caption = 'feste Framerate verwenden'
          TabOrder = 2
          OnClick = OptionenfesteFramerateverwendenBoxClick
        end
        object OptionenSequenzEndeignorierenBox: TCheckBox
          Left = 10
          Top = 92
          Width = 265
          Height = 17
          Caption = 'Sequenzende in der Videodatei ignorieren'
          TabOrder = 4
        end
        object OptionennachSchneidenbeendenBox: TCheckBox
          Left = 10
          Top = 114
          Width = 265
          Height = 17
          Caption = 'Programm nach dem Schneiden beenden'
          TabOrder = 5
        end
        object HinweisanzeigedauerEdit: TEdit
          Left = 140
          Top = 172
          Width = 53
          Height = 22
          TabOrder = 6
        end
        object festeFramerateEdit: TEdit
          Left = 188
          Top = 66
          Width = 47
          Height = 22
          TabOrder = 3
        end
        object BeendenanzeigedauerEdit: TEdit
          Left = 140
          Top = 196
          Width = 53
          Height = 22
          TabOrder = 7
        end
        object OptionenSchiebereglerPosbeibehaltenBox: TCheckBox
          Left = 10
          Top = 136
          Width = 265
          Height = 17
          Caption = 'Schiebereglerposition beibehalten'
          TabOrder = 8
        end
      end
      object OptionenProjektGroupBox: TGroupBox
        Left = 290
        Top = 4
        Width = 279
        Height = 323
        Caption = 'Projekt ge'#228'ndert'
        TabOrder = 1
        object OptionenProjektDateilisteBox: TCheckBox
          Left = 10
          Top = 26
          Width = 265
          Height = 17
          Caption = 'Dateiliste ge'#228'ndert'
          TabOrder = 0
        end
        object OptionenProjektSchnittlisteBox: TCheckBox
          Left = 10
          Top = 48
          Width = 265
          Height = 17
          Caption = 'Schnittliste ge'#228'ndert'
          TabOrder = 1
        end
        object OptionenProjektKapitellisteBox: TCheckBox
          Left = 10
          Top = 70
          Width = 265
          Height = 17
          Caption = 'Kapitelliste ge'#228'ndert'
          TabOrder = 2
          OnClick = OptionenfesteFramerateverwendenBoxClick
        end
        object OptionenProjektMarkenlisteBox: TCheckBox
          Left = 10
          Top = 92
          Width = 265
          Height = 17
          Caption = 'Markenliste ge'#228'ndert'
          TabOrder = 3
        end
        object OptionenProjektEffektBox: TCheckBox
          Left = 10
          Top = 114
          Width = 265
          Height = 17
          Caption = 'Effekt ge'#228'ndert'
          TabOrder = 4
        end
        object OptionenProjektSchneidenBox: TCheckBox
          Left = 10
          Top = 136
          Width = 265
          Height = 17
          Caption = 'Cut setzt Projekt ge'#228'ndert zur'#252'ck'
          TabOrder = 5
        end
      end
    end
    object OptionenOberflaecheTab: TTabSheet
      Caption = 'Oberfl'#228'che'
      ImageIndex = 1
      object OptionenOberflaeche_: TGroupBox
        Left = 4
        Top = 4
        Width = 279
        Height = 323
        Caption = 'Oberfl'#228'che'
        TabOrder = 0
        object OptionenDateienfensterhoehe_: TLabel
          Left = 10
          Top = 26
          Width = 113
          Height = 14
          Caption = 'Dateienfensterh'#246'he:'
        end
        object OptionenDateienfensterhoehePixel_: TLabel
          Left = 228
          Top = 26
          Width = 24
          Height = 14
          Caption = 'Pixel'
        end
        object OptionenListenfensterBreitePixel_: TLabel
          Left = 228
          Top = 52
          Width = 24
          Height = 14
          Caption = 'Pixel'
        end
        object OptionenListenfensterBreite_: TLabel
          Left = 10
          Top = 52
          Width = 107
          Height = 14
          Caption = 'Listenfensterbreite:'
        end
        object OptionenDateienfensterhoeheEdit: TEdit
          Left = 128
          Top = 22
          Width = 93
          Height = 22
          TabOrder = 0
        end
        object OptionenListenfensterBreiteEdit: TEdit
          Left = 128
          Top = 48
          Width = 93
          Height = 22
          TabOrder = 1
        end
        object OptionenListenfensterLinksBox: TCheckBox
          Left = 8
          Top = 78
          Width = 265
          Height = 17
          Caption = 'Listenfenster auf der linken Seite'
          TabOrder = 2
        end
        object OptionenSymbolGroupBox: TGroupBox
          Left = 8
          Top = 240
          Width = 267
          Height = 73
          Caption = 'Symbole'
          TabOrder = 3
          object BilderdateiEdit: TEdit
            Left = 102
            Top = 42
            Width = 131
            Height = 22
            PopupMenu = EditBoxMenue
            TabOrder = 3
            OnContextPopup = EditBoxContextPopup
            OnKeyPress = EditBoxKeyPress
          end
          object OptionenkeineSymboleRadioButton: TRadioButton
            Left = 8
            Top = 20
            Width = 117
            Height = 17
            Caption = 'keine Symbole'
            TabOrder = 0
            OnClick = SymboleRadioButtonClick
          end
          object OptionenStandardRadioButton: TRadioButton
            Left = 126
            Top = 20
            Width = 133
            Height = 17
            Caption = 'Standardsymbole'
            TabOrder = 1
            OnClick = SymboleRadioButtonClick
          end
          object OptionenSymboldateiRadioButton: TRadioButton
            Left = 8
            Top = 44
            Width = 93
            Height = 17
            Caption = 'Symboldatei:'
            TabOrder = 2
            OnClick = SymboleRadioButtonClick
          end
          object BilderdateiBitBtn: TBitBtn
            Left = 234
            Top = 42
            Width = 25
            Height = 22
            Caption = '-->'
            TabOrder = 4
            OnClick = EditBoxBitBtnClick
          end
        end
        object OptionenTastenfensterzentrierenBox: TCheckBox
          Left = 8
          Top = 122
          Width = 265
          Height = 17
          Caption = 'Tastenfenster zentrieren'
          TabOrder = 4
        end
        object OptionenSchiebereglerMarkeranzeigenBox: TCheckBox
          Left = 8
          Top = 140
          Width = 265
          Height = 17
          Caption = 'Schiebereglermarker anzeigen'
          TabOrder = 5
        end
        object OptionenDateienimListenfensterBox: TCheckBox
          Left = 8
          Top = 96
          Width = 265
          Height = 17
          Caption = 'Dateien im Listenfenster'
          TabOrder = 6
        end
        object OptionenMenueTastenbedienungBox: TCheckBox
          Left = 8
          Top = 166
          Width = 265
          Height = 17
          Caption = 'Men'#252' per Tasten bedienen'
          TabOrder = 7
        end
        object OptionenEnderechtsBox: TCheckBox
          Left = 26
          Top = 186
          Width = 249
          Height = 17
          Caption = 'Taste Springe zum Ende  - links/rechts'
          TabOrder = 8
        end
        object OptionenEndelinksBox: TCheckBox
          Left = 8
          Top = 186
          Width = 15
          Height = 17
          TabOrder = 9
        end
      end
      object OptionenSchriftarten_: TGroupBox
        Left = 290
        Top = 4
        Width = 279
        Height = 323
        Caption = 'Schriftarten'
        TabOrder = 1
        object OptionenHauptfensterSchriftart_: TLabel
          Left = 10
          Top = 26
          Width = 76
          Height = 14
          Caption = 'Hauptfenster:'
        end
        object OptionenTastenfensterSchriftart_: TLabel
          Left = 10
          Top = 52
          Width = 81
          Height = 14
          Caption = 'Tastenfenster:'
        end
        object OptionenAnzeigefensterSchriftart_: TLabel
          Left = 10
          Top = 78
          Width = 86
          Height = 14
          Caption = 'Anzeigefenster:'
        end
        object OptionenDialogeSchriftart_: TLabel
          Left = 10
          Top = 104
          Width = 43
          Height = 14
          Caption = 'Dialoge:'
        end
        object OptionenHauptfensterSchriftartEdit: TEdit
          Left = 104
          Top = 22
          Width = 109
          Height = 22
          ReadOnly = True
          TabOrder = 0
        end
        object OptionenHauptfensterSchriftgroesseEdit: TEdit
          Left = 216
          Top = 22
          Width = 24
          Height = 22
          ReadOnly = True
          TabOrder = 1
        end
        object OptionenHauptfensterSchriftartBtn: TBitBtn
          Left = 244
          Top = 22
          Width = 25
          Height = 22
          Caption = '-->'
          TabOrder = 2
          OnClick = OptionenHauptfensterSchriftartBtnClick
        end
        object OptionenTastenfensterSchriftartEdit: TEdit
          Left = 104
          Top = 48
          Width = 109
          Height = 22
          ReadOnly = True
          TabOrder = 3
        end
        object OptionenTastenfensterSchriftgroesseEdit: TEdit
          Left = 216
          Top = 48
          Width = 24
          Height = 22
          ReadOnly = True
          TabOrder = 4
        end
        object OptionenTastenfensterSchriftartBtn: TBitBtn
          Left = 244
          Top = 48
          Width = 25
          Height = 22
          Caption = '-->'
          TabOrder = 5
          OnClick = OptionenTastenfensterSchriftartBtnClick
        end
        object OptionenAnzeigefensterSchriftartEdit: TEdit
          Left = 104
          Top = 74
          Width = 109
          Height = 22
          ReadOnly = True
          TabOrder = 6
        end
        object OptionenAnzeigefensterSchriftgroesseEdit: TEdit
          Left = 216
          Top = 74
          Width = 24
          Height = 22
          ReadOnly = True
          TabOrder = 7
        end
        object OptionenAnzeigefensterSchriftartBtn: TBitBtn
          Left = 244
          Top = 74
          Width = 25
          Height = 22
          Caption = '-->'
          TabOrder = 8
          OnClick = OptionenAnzeigefensterSchriftartBtnClick
        end
        object OptionenDialogeSchriftartEdit: TEdit
          Left = 104
          Top = 100
          Width = 109
          Height = 22
          ReadOnly = True
          TabOrder = 9
        end
        object OptionenDialogeSchriftgroesseEdit: TEdit
          Left = 216
          Top = 100
          Width = 24
          Height = 22
          ReadOnly = True
          TabOrder = 10
        end
        object OptionenDialogeSchriftartBtn: TBitBtn
          Left = 244
          Top = 100
          Width = 25
          Height = 22
          Caption = '-->'
          TabOrder = 11
          OnClick = OptionenDialogeSchriftartBtnClick
        end
        object OptionenTastenFetteSchriftBox: TCheckBox
          Left = 8
          Top = 140
          Width = 265
          Height = 17
          Caption = 'Tasten im Hauptfenster fette Schrift'
          TabOrder = 12
        end
      end
    end
    object OptionenVerzeichnisseiteTab: TTabSheet
      Caption = 'Verzeichnisse'
      ImageIndex = 7
      object OptionenVideoAudioVerzeichnis_: TLabel
        Left = 10
        Top = 20
        Width = 97
        Height = 14
        Caption = 'Video/Audioverz.:'
      end
      object OptionenZielVerzeichnis_: TLabel
        Left = 8
        Top = 44
        Width = 80
        Height = 14
        Caption = 'Zielverzeichnis:'
      end
      object OptionenProjektVerzeichnis_: TLabel
        Left = 8
        Top = 70
        Width = 101
        Height = 14
        Caption = 'Projektverzeichnis:'
      end
      object OptionenKapitelVerzeichnis_: TLabel
        Left = 8
        Top = 96
        Width = 98
        Height = 14
        Caption = 'Kapitelverzeichnis:'
      end
      object OptionenVorschauVerzeichnis_: TLabel
        Left = 8
        Top = 122
        Width = 112
        Height = 14
        Caption = 'Vorschauverzeichnis:'
      end
      object OptionenZwischenVerzeichnis_: TLabel
        Left = 8
        Top = 148
        Width = 113
        Height = 14
        Caption = 'Zwischenverzeichnis:'
      end
      object VideoAudioVerzeichnisEdit: TEdit
        Left = 128
        Top = 16
        Width = 281
        Height = 22
        PopupMenu = EditBoxMenue
        TabOrder = 0
        OnContextPopup = EditBoxContextPopup
        OnKeyPress = EditBoxKeyPress
      end
      object OptionenVideoAudioVerzeichnisBox: TCheckBox
        Left = 444
        Top = 18
        Width = 130
        Height = 17
        Caption = 'Verzeichnis '#228'ndern'
        TabOrder = 2
      end
      object ZielVerzeichnisEdit: TEdit
        Left = 128
        Top = 42
        Width = 281
        Height = 22
        PopupMenu = EditBoxMenue
        TabOrder = 3
        OnContextPopup = EditBoxContextPopup
        OnKeyPress = EditBoxKeyPress
      end
      object OptionenZielVerzeichnisBox: TCheckBox
        Left = 444
        Top = 46
        Width = 130
        Height = 17
        Caption = 'Verzeichnis '#228'ndern'
        TabOrder = 5
      end
      object ProjektVerzeichnisEdit: TEdit
        Left = 128
        Top = 68
        Width = 281
        Height = 22
        PopupMenu = EditBoxMenue
        TabOrder = 6
        OnContextPopup = EditBoxContextPopup
        OnKeyPress = EditBoxKeyPress
      end
      object OptionenProjektVerzeichnisBox: TCheckBox
        Left = 444
        Top = 72
        Width = 130
        Height = 17
        Caption = 'Verzeichnis '#228'ndern'
        TabOrder = 8
      end
      object KapitelVerzeichnisEdit: TEdit
        Left = 128
        Top = 96
        Width = 281
        Height = 22
        PopupMenu = EditBoxMenue
        TabOrder = 9
        OnContextPopup = EditBoxContextPopup
        OnKeyPress = EditBoxKeyPress
      end
      object OptionenKapitelVerzeichnisBox: TCheckBox
        Left = 444
        Top = 98
        Width = 130
        Height = 17
        Caption = 'Verzeichnis '#228'ndern'
        TabOrder = 11
      end
      object VorschauVerzeichnisEdit: TEdit
        Left = 128
        Top = 122
        Width = 281
        Height = 22
        PopupMenu = EditBoxMenue
        TabOrder = 12
        OnContextPopup = EditBoxContextPopup
        OnKeyPress = EditBoxKeyPress
      end
      object ZwischenVerzeichnisEdit: TEdit
        Left = 128
        Top = 148
        Width = 281
        Height = 22
        PopupMenu = EditBoxMenue
        TabOrder = 14
        OnContextPopup = EditBoxContextPopup
        OnKeyPress = EditBoxKeyPress
      end
      object VideoAudioVerzeichnisBitBtn: TBitBtn
        Left = 412
        Top = 16
        Width = 25
        Height = 21
        Caption = '-->'
        TabOrder = 1
        OnClick = EditBoxBitBtnClick
      end
      object ZielVerzeichnisBitBtn: TBitBtn
        Left = 412
        Top = 42
        Width = 25
        Height = 21
        Caption = '-->'
        TabOrder = 4
        OnClick = EditBoxBitBtnClick
      end
      object ProjektVerzeichnisBitBtn: TBitBtn
        Left = 412
        Top = 70
        Width = 25
        Height = 21
        Caption = '-->'
        TabOrder = 7
        OnClick = EditBoxBitBtnClick
      end
      object KapitelVerzeichnisBitBtn: TBitBtn
        Left = 412
        Top = 96
        Width = 25
        Height = 21
        Caption = '-->'
        TabOrder = 10
        OnClick = EditBoxBitBtnClick
      end
      object VorschauVerzeichnisBitBtn: TBitBtn
        Left = 412
        Top = 122
        Width = 25
        Height = 21
        Caption = '-->'
        TabOrder = 13
        OnClick = EditBoxBitBtnClick
      end
      object ZwischenVerzeichnisBitBtn: TBitBtn
        Left = 412
        Top = 148
        Width = 25
        Height = 21
        Caption = '-->'
        TabOrder = 15
        OnClick = EditBoxBitBtnClick
      end
    end
    object OptionenDateinamenEndungenseiteTab: TTabSheet
      Caption = 'Dateinamen/Endungen'
      ImageIndex = 9
      object OptionenEndungenVideo_: TGroupBox
        Left = 290
        Top = 4
        Width = 279
        Height = 71
        Caption = 'Video'
        TabOrder = 2
        object OptionenDateiendungenVideo_: TLabel
          Left = 12
          Top = 20
          Width = 88
          Height = 14
          Caption = 'Dateiendungen:'
        end
        object OptionenStandardendungenVideo_: TLabel
          Left = 12
          Top = 46
          Width = 95
          Height = 14
          Caption = 'Standardendung:'
        end
        object DateiendungenVideoEdit: TEdit
          Left = 120
          Top = 16
          Width = 151
          Height = 22
          TabOrder = 0
        end
        object StandardendungenVideoEdit: TEdit
          Left = 120
          Top = 42
          Width = 151
          Height = 22
          TabOrder = 1
        end
      end
      object OptionenEndungenAudio_: TGroupBox
        Left = 290
        Top = 78
        Width = 279
        Height = 177
        Caption = 'Audio'
        TabOrder = 3
        object OptionenDateiendungenAudio_: TLabel
          Left = 12
          Top = 20
          Width = 88
          Height = 14
          Caption = 'Dateiendungen:'
        end
        object OptionenStandardendungenAudio_: TLabel
          Left = 12
          Top = 46
          Width = 95
          Height = 14
          Caption = 'Standardendung:'
        end
        object OptionenStandardendungenPCM_: TLabel
          Left = 12
          Top = 74
          Width = 105
          Height = 14
          Caption = 'Standardend. PCM:'
        end
        object OptionenStandardendungenMP2_: TLabel
          Left = 12
          Top = 100
          Width = 105
          Height = 14
          Caption = 'Standardend. MP2:'
        end
        object OptionenStandardendungenAC3_: TLabel
          Left = 12
          Top = 126
          Width = 104
          Height = 14
          Caption = 'Standardend. AC3:'
        end
        object OptionenAudioTrennzeichen_: TLabel
          Left = 12
          Top = 152
          Width = 106
          Height = 14
          Caption = 'Audiotrennzeichen:'
        end
        object DateiendungenAudioEdit: TEdit
          Left = 120
          Top = 16
          Width = 151
          Height = 22
          TabOrder = 0
        end
        object StandardendungenAudioEdit: TEdit
          Left = 120
          Top = 42
          Width = 151
          Height = 22
          TabOrder = 1
        end
        object StandardendungenPCMEdit: TEdit
          Left = 120
          Top = 70
          Width = 151
          Height = 22
          TabOrder = 2
        end
        object StandardendungenMP2Edit: TEdit
          Left = 120
          Top = 96
          Width = 151
          Height = 22
          TabOrder = 3
        end
        object StandardendungenAC3Edit: TEdit
          Left = 120
          Top = 122
          Width = 151
          Height = 22
          TabOrder = 4
        end
        object AudioTrennzeichenEdit: TEdit
          Left = 120
          Top = 148
          Width = 151
          Height = 22
          TabOrder = 5
        end
      end
      object OptionenDateinamen_: TGroupBox
        Left = 4
        Top = 4
        Width = 279
        Height = 173
        Caption = 'Dateinamen'
        TabOrder = 0
        object OptionenZielDateiname_: TLabel
          Left = 12
          Top = 58
          Width = 79
          Height = 14
          Caption = 'Zieldateiname:'
        end
        object OptionenProjektdateiname_: TLabel
          Left = 12
          Top = 18
          Width = 100
          Height = 14
          Caption = 'Projektdateiname:'
        end
        object OptionenKapiteldateiname_: TLabel
          Left = 12
          Top = 102
          Width = 97
          Height = 14
          Caption = 'Kapiteldateiname:'
        end
        object ZielDateinameEdit: TEdit
          Left = 116
          Top = 54
          Width = 155
          Height = 22
          TabOrder = 2
        end
        object OptionenZieldateidialogunterdrueckenBox: TCheckBox
          Left = 14
          Top = 76
          Width = 259
          Height = 17
          Caption = 'Zieldateidialog unterdr'#252'cken'
          TabOrder = 3
        end
        object OptionenProjektdateidialogunterdrueckenBox: TCheckBox
          Left = 14
          Top = 36
          Width = 259
          Height = 17
          Caption = 'Projektdialog unterdr'#252'cken'
          TabOrder = 1
        end
        object ProjektdateinameEdit: TEdit
          Left = 116
          Top = 14
          Width = 155
          Height = 22
          TabOrder = 0
        end
        object KapiteldateinameEdit: TEdit
          Left = 116
          Top = 98
          Width = 155
          Height = 22
          TabOrder = 4
        end
      end
      object OptionenStandardEndungenverwendenBox: TCheckBox
        Left = 10
        Top = 308
        Width = 271
        Height = 17
        Caption = 'Standardendungen verwenden'
        TabOrder = 4
      end
      object OptionenDateinamennummerieren_: TGroupBox
        Left = 4
        Top = 180
        Width = 279
        Height = 103
        Caption = 'Dateinamen nummerieren'
        TabOrder = 1
        object OptionenProjektdateieneinzeln_: TLabel
          Left = 10
          Top = 22
          Width = 84
          Height = 14
          Caption = 'Projektdateien:'
        end
        object OptionenSchnittdateieneinzeln_: TLabel
          Left = 10
          Top = 48
          Width = 84
          Height = 14
          Caption = 'Schnittdateien:'
        end
        object ProjektdateieneinzelnFormatEdit: TEdit
          Left = 100
          Top = 20
          Width = 171
          Height = 22
          TabOrder = 0
        end
        object SchnittpunkteeinzelnFormatEdit: TEdit
          Left = 100
          Top = 46
          Width = 171
          Height = 22
          TabOrder = 1
        end
      end
      object OptionenEndungenKapitel_: TGroupBox
        Left = 290
        Top = 258
        Width = 279
        Height = 71
        Caption = 'Kapitel'
        TabOrder = 5
        object OptionenDateiendungenKapitel_: TLabel
          Left = 12
          Top = 20
          Width = 88
          Height = 14
          Caption = 'Dateiendungen:'
        end
        object OptionenStandardendungenKapitel_: TLabel
          Left = 12
          Top = 46
          Width = 95
          Height = 14
          Caption = 'Standardendung:'
        end
        object DateiendungenKapitelEdit: TEdit
          Left = 120
          Top = 16
          Width = 151
          Height = 22
          TabOrder = 0
        end
        object StandardendungenKapitelEdit: TEdit
          Left = 120
          Top = 42
          Width = 151
          Height = 22
          TabOrder = 1
        end
      end
    end
    object OptionenWiedergabeSeiteTab: TTabSheet
      Caption = 'Anzeige/Wiedergabe'
      ImageIndex = 11
      object OptionenVideoanzeige_: TGroupBox
        Left = 4
        Top = 4
        Width = 280
        Height = 171
        Caption = 'Videoanzeige'
        TabOrder = 0
        object OptionenVideohintergrund_: TLabel
          Left = 12
          Top = 114
          Width = 123
          Height = 14
          Caption = 'Videohintergrundfarbe'
        end
        object OptionenVideohintergrundakt_: TLabel
          Left = 12
          Top = 140
          Width = 111
          Height = 14
          Caption = 'aktives Videofenster'
        end
        object OptionenVideograudarstellenBox: TCheckBox
          Left = 12
          Top = 20
          Width = 265
          Height = 17
          Caption = 'Video grau anzeigen'
          TabOrder = 0
        end
        object OptionenHauptfensteranpassenBox: TCheckBox
          Left = 12
          Top = 60
          Width = 265
          Height = 17
          Caption = 'Programmfenster an Videogr'#246#223'e anpassen'
          TabOrder = 2
        end
        object OptionenVideoanzeigegroesseBox: TCheckBox
          Left = 12
          Top = 80
          Width = 265
          Height = 17
          Caption = 'Videoanzeigegr'#246#223'e einrasten'
          TabOrder = 3
        end
        object OptionenkeinVideoBox: TCheckBox
          Left = 12
          Top = 40
          Width = 265
          Height = 17
          Caption = 'kein Video abspielen'
          TabOrder = 1
        end
        object OptionenVideohintergrundColorBox: TColorBox
          Left = 140
          Top = 112
          Width = 129
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
          ItemHeight = 16
          TabOrder = 4
        end
        object OptionenVideohintergrundaktColorBox: TColorBox
          Left = 140
          Top = 138
          Width = 129
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
          ItemHeight = 16
          TabOrder = 5
        end
      end
      object OptionenAudiowiedergabe_: TGroupBox
        Left = 290
        Top = 4
        Width = 280
        Height = 325
        Caption = 'Audiowiedergabe'
        TabOrder = 1
        object OptionenAudioGraphName_: TLabel
          Left = 10
          Top = 134
          Width = 103
          Height = 14
          Caption = 'DirectShow Graph:'
        end
        object OptionenAudioFehleranzeigenBox: TCheckBox
          Left = 12
          Top = 20
          Width = 265
          Height = 17
          Caption = 'Fehler beim Audio'#246'ffnen anzeigen'
          TabOrder = 0
        end
        object OptionenkeinAudioRadio: TRadioButton
          Left = 12
          Top = 46
          Width = 265
          Height = 17
          Caption = 'kein Audio abspielen'
          TabOrder = 1
        end
        object OptionenMCIPlayerRadio: TRadioButton
          Left = 12
          Top = 68
          Width = 265
          Height = 17
          Caption = 'MCI Schnittstelle verwenden'
          TabOrder = 2
        end
        object OptionenDSPlayerRadio: TRadioButton
          Left = 12
          Top = 92
          Width = 265
          Height = 17
          Caption = 'Direct Show Schnittstelle verwenden'
          Checked = True
          TabOrder = 3
          TabStop = True
        end
        object AudioGraphNameEdit: TEdit
          Left = 116
          Top = 130
          Width = 129
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 4
          OnContextPopup = EditBoxContextPopup
          OnKeyPress = EditBoxKeyPress
        end
        object AudioGraphNameBitBtn: TBitBtn
          Left = 248
          Top = 130
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 5
          OnClick = EditBoxBitBtnClick
        end
      end
      object OptionenWiedergabe_: TGroupBox
        Left = 4
        Top = 182
        Width = 281
        Height = 147
        Caption = 'Wiedergabe'
        TabOrder = 2
        object OptionenletztesVideoanzeigenBox: TCheckBox
          Left = 12
          Top = 20
          Width = 265
          Height = 17
          Caption = 'Video nach dem '#214'ffnen anzeigen'
          TabOrder = 0
        end
        object OptionenTempo1beiPauseBox: TCheckBox
          Left = 12
          Top = 40
          Width = 265
          Height = 17
          Caption = 'Geschwindigkeit bei Pause auf 1 setzen'
          TabOrder = 1
        end
      end
    end
    object OptionenVideoAudioSchnittseiteTab: TTabSheet
      Caption = 'Video/Audioschnitt'
      ImageIndex = 3
      object OptionenVideoschnitt_: TGroupBox
        Left = 4
        Top = 110
        Width = 280
        Height = 219
        Caption = 'Videoschnitt'
        TabOrder = 1
        object OptionenersterHeader_: TLabel
          Left = 12
          Top = 150
          Width = 75
          Height = 14
          AutoSize = False
          Caption = '1. Header'
        end
        object OptionenminBilder_: TLabel
          Left = 14
          Top = 102
          Width = 107
          Height = 14
          AutoSize = False
          Caption = 'min. Bilder:'
        end
        object OptionenFramegenauschneidenBox: TCheckBox
          Left = 12
          Top = 32
          Width = 265
          Height = 17
          Caption = 'Framegenau schneiden'
          Checked = True
          Enabled = False
          State = cbChecked
          TabOrder = 0
          Visible = False
        end
        object OptionenTimecodekorrigierenBox: TCheckBox
          Left = 12
          Top = 20
          Width = 265
          Height = 17
          Caption = 'Timecode korrigieren'
          TabOrder = 1
        end
        object OptionenBitratekorrigierenBox: TCheckBox
          Left = 12
          Top = 40
          Width = 265
          Height = 17
          Caption = 'Bitrate korrigieren'
          TabOrder = 2
        end
        object OptionenD2VDateierstellenBox: TCheckBox
          Left = 12
          Top = 60
          Width = 265
          Height = 17
          Caption = 'D2V-Datei erstellen'
          TabOrder = 3
        end
        object OptionenIDXDateierstellenBox: TCheckBox
          Left = 12
          Top = 80
          Width = 265
          Height = 17
          Caption = 'IDX-Datei erstellen'
          TabOrder = 4
        end
        object OptionenMaxGOPLaengeBox: TCheckBox
          Left = 12
          Top = 124
          Width = 169
          Height = 17
          Caption = 'maximale GOP-L'#228'nge'
          TabOrder = 5
          OnClick = OptionenMaxGOPLaengeBoxClick
        end
        object MaxGOPLaengeEdit: TEdit
          Left = 182
          Top = 122
          Width = 53
          Height = 22
          TabOrder = 6
        end
        object BitrateersterHeaderComboBox: TComboBox
          Left = 88
          Top = 146
          Width = 183
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          TabOrder = 7
          OnCloseUp = BitrateersterHeaderComboBoxCloseUp
          OnSelect = BitrateersterHeaderComboBoxSelect
          Items.Strings = (
            'Bitrate nicht '#228'ndern'
            'Bitrate vom Orginal'
            'durchschnl. Bitrate'
            'maximale Bitrate'
            'feste Bitrate')
        end
        object minBilderEndeEdit: TEdit
          Left = 182
          Top = 98
          Width = 53
          Height = 22
          TabOrder = 8
        end
        object minBilderAnfangEdit: TEdit
          Left = 124
          Top = 98
          Width = 53
          Height = 22
          TabOrder = 9
        end
        object AspectratioersterHeaderComboBox: TComboBox
          Left = 88
          Top = 170
          Width = 183
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          TabOrder = 10
          OnCloseUp = AspectratioersterHeaderComboBoxCloseUp
          OnSelect = AspectratioersterHeaderComboBoxSelect
          Items.Strings = (
            'Aspectrato nicht '#228'ndern'
            'Aspectrato  vom Orginal'
            'Aspectrato 1/1'
            'Aspectrato 3/4'
            'Aspectrato 9/16'
            'Aspectrato 1/2,21'
            'Aspectrato nach ')
        end
      end
      object OptionenAudioschnitt_: TGroupBox
        Left = 288
        Top = 110
        Width = 280
        Height = 219
        Caption = 'Audioschnitt'
        TabOrder = 2
        object OptionenAudioframesMpeg_: TLabel
          Left = 8
          Top = 40
          Width = 23
          Height = 14
          Caption = 'Mp2'
        end
        object OptionenAudioframesAC3_: TLabel
          Left = 8
          Top = 66
          Width = 22
          Height = 14
          Caption = 'AC3'
        end
        object OptionenAudioframesPCM_: TLabel
          Left = 8
          Top = 92
          Width = 23
          Height = 14
          Caption = 'PCM'
          Visible = False
        end
        object OptionenStilleAudioframes_: TLabel
          Left = 8
          Top = 20
          Width = 96
          Height = 14
          Caption = 'Stille Audioframes'
        end
        object AudioframesMpegComboBox: TComboBox
          Left = 38
          Top = 36
          Width = 207
          Height = 22
          AutoComplete = False
          ItemHeight = 14
          ParentShowHint = False
          PopupMenu = ComboBoxMenue
          ShowHint = False
          TabOrder = 0
          OnContextPopup = ComboboxContextPopup
          OnKeyPress = ComboboxKeyPress
          OnSelect = ComboBoxSelect
        end
        object AudioframesAC3ComboBox: TComboBox
          Left = 38
          Top = 62
          Width = 207
          Height = 22
          AutoComplete = False
          ItemHeight = 14
          ParentShowHint = False
          PopupMenu = ComboBoxMenue
          ShowHint = False
          TabOrder = 2
          OnContextPopup = ComboboxContextPopup
          OnKeyPress = ComboboxKeyPress
          OnSelect = ComboBoxSelect
        end
        object AudioframesPCMComboBox: TComboBox
          Left = 38
          Top = 88
          Width = 207
          Height = 22
          AutoComplete = False
          ItemHeight = 14
          ParentShowHint = False
          PopupMenu = ComboBoxMenue
          ShowHint = False
          TabOrder = 4
          Visible = False
          OnContextPopup = ComboboxContextPopup
          OnKeyPress = ComboboxKeyPress
          OnSelect = ComboBoxSelect
        end
        object AudioframesMpegBitBtn: TBitBtn
          Left = 248
          Top = 36
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 1
          OnClick = ComboBoxBitBtnClick
        end
        object AudioframesAC3BitBtn: TBitBtn
          Left = 248
          Top = 62
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 3
          OnClick = ComboBoxBitBtnClick
        end
        object AudioframesPCMBitBtn: TBitBtn
          Left = 248
          Top = 88
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 5
          Visible = False
          OnClick = ComboBoxBitBtnClick
        end
      end
      object OptionenSchnittAllgemein_: TGroupBox
        Left = 4
        Top = 6
        Width = 563
        Height = 99
        Caption = 'Schnittoptionen'
        TabOrder = 0
        object OptionenIndexDateierstellenBox: TCheckBox
          Left = 12
          Top = 16
          Width = 265
          Height = 17
          Caption = 'Indexdatei  erstellen'
          TabOrder = 0
        end
        object OptionenKapiteldateierstellenBox: TCheckBox
          Left = 12
          Top = 36
          Width = 265
          Height = 17
          Caption = 'Kapiteldatei erstellen'
          TabOrder = 1
        end
        object OptionenMuxenBox: TCheckBox
          Left = 12
          Top = 56
          Width = 265
          Height = 17
          Caption = 'Nachbearbeitung'
          TabOrder = 2
        end
      end
    end
    object OptionenSchnittlistenFormatseiteTab: TTabSheet
      Caption = 'Schnittliste'
      ImageIndex = 2
      object OptionenSchnittlistenformat_: TGroupBox
        Left = 4
        Top = 6
        Width = 565
        Height = 119
        Caption = 'Schnittlistenformat '
        TabOrder = 0
        object OptionenSchnittFormat_: TLabel
          Left = 8
          Top = 22
          Width = 42
          Height = 14
          Caption = 'Format:'
        end
        object OptionenSchnittpunktTrennzeichen_: TLabel
          Left = 8
          Top = 48
          Width = 78
          Height = 14
          Caption = 'Trennzeichen:'
        end
        object OptionenSchnittBildbreite_: TLabel
          Left = 10
          Top = 82
          Width = 54
          Height = 14
          Caption = 'Bildbreite:'
        end
        object SchnittFormatEdit: TEdit
          Left = 90
          Top = 20
          Width = 289
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 0
          OnContextPopup = EditBoxContextPopup
        end
        object SchnittpunktTrennzeichenEdit: TEdit
          Left = 90
          Top = 44
          Width = 75
          Height = 22
          TabOrder = 1
        end
        object SchnittBildbreiteSpinEdit: TSpinEdit
          Left = 90
          Top = 78
          Width = 75
          Height = 23
          Increment = 10
          MaxValue = 0
          MinValue = 0
          TabOrder = 2
          Value = 0
        end
        object OptionenSchnittBildAnfangBox: TCheckBox
          Left = 178
          Top = 82
          Width = 160
          Height = 17
          Caption = 'Bild vom Schnittanfang'
          TabOrder = 3
        end
        object OptionenSchnittBildEndeBox: TCheckBox
          Left = 352
          Top = 82
          Width = 160
          Height = 17
          Caption = 'Bild vom Schnittende'
          TabOrder = 4
        end
      end
      object OptionenSchnittlistenFarbeinstellung_: TGroupBox
        Left = 4
        Top = 132
        Width = 565
        Height = 61
        Caption = 'Farbeinstellung '
        TabOrder = 1
        object OptionenSchnittFormatberechnen_: TLabel
          Left = 8
          Top = 22
          Width = 106
          Height = 14
          Caption = 'Schnitt berechnen:'
        end
        object OptionenSchnittFormatnichtberechnen_: TLabel
          Left = 296
          Top = 22
          Width = 94
          Height = 14
          Caption = 'nicht berechnen:'
        end
        object SchnittFormatberechnenColorBox: TColorBox
          Left = 118
          Top = 17
          Width = 150
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
          ItemHeight = 16
          TabOrder = 0
        end
        object SchnittFormatnichtberechnenColorBox: TColorBox
          Left = 406
          Top = 17
          Width = 150
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
          ItemHeight = 16
          TabOrder = 1
        end
      end
      object OptionenSchnittlistenSonstiges_: TGroupBox
        Left = 4
        Top = 200
        Width = 565
        Height = 75
        Caption = 'Sonstiges '
        TabOrder = 2
        object OptionenSchnittFormatEinfuegen_: TLabel
          Left = 8
          Top = 22
          Width = 52
          Height = 14
          Caption = 'Einf'#252'gen:'
        end
        object SchnittFormatEinfuegenComboBox: TComboBox
          Left = 118
          Top = 17
          Width = 150
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          TabOrder = 0
          Items.Strings = (
            'vor der Markierung'
            'nach der Markierung'
            'am Ende')
        end
      end
    end
    object OptionenKapitellistenFormatseiteTab: TTabSheet
      Caption = 'Kapitelliste'
      ImageIndex = 13
      object OptionenKapitellistenformat_: TGroupBox
        Left = 4
        Top = 6
        Width = 565
        Height = 73
        Caption = 'Format '
        TabOrder = 0
        object OptionenKapitelTrennzeile: TLabel
          Left = 8
          Top = 46
          Width = 60
          Height = 14
          Caption = 'Trennzeile:'
        end
        object OptionenKapitelZahlenformat_: TLabel
          Left = 8
          Top = 22
          Width = 40
          Height = 14
          Caption = 'Zahlen:'
        end
        object KapitelFormatEdit: TEdit
          Left = 70
          Top = 18
          Width = 279
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 0
          OnContextPopup = EditBoxContextPopup
        end
        object OptionenSchnittlistenFormatuebernehmenBox: TCheckBox
          Left = 356
          Top = 18
          Width = 203
          Height = 17
          Caption = 'Schnittlistenformat '#252'bernehmen'
          TabOrder = 1
          OnClick = OptionenSchnittlistenFormatuebernehmenBoxClick
        end
        object KapitelTrennzeileEdit1: TEdit
          Left = 70
          Top = 42
          Width = 120
          Height = 22
          TabOrder = 2
          Text = '--'
        end
        object KapitelTrennzeileEdit2: TEdit
          Left = 192
          Top = 42
          Width = 120
          Height = 22
          TabOrder = 3
          Text = '--'
        end
        object KapitelTrennzeileEdit3: TEdit
          Left = 314
          Top = 42
          Width = 120
          Height = 22
          TabOrder = 4
          Text = '---------------------'
        end
        object KapitelTrennzeileEdit4: TEdit
          Left = 436
          Top = 42
          Width = 120
          Height = 22
          TabOrder = 5
          Text = 'Trennzeile'
        end
      end
      object OptionenKapitellistenFarbeinstellungen_: TGroupBox
        Left = 4
        Top = 84
        Width = 565
        Height = 99
        Caption = 'Farbeinstellungen '
        TabOrder = 1
        object OptionenKapitellistenMarkierungFarbeVG_: TLabel
          Left = 8
          Top = 48
          Width = 78
          Height = 14
          Caption = 'MarkierungVg:'
          Enabled = False
          WordWrap = True
        end
        object OptionenKapitellistenVerschiebeFarbeVG_: TLabel
          Left = 8
          Top = 74
          Width = 86
          Height = 14
          Caption = 'VerschiebenVg:'
          WordWrap = True
        end
        object OptionenKapitellistenFarbeHG_: TLabel
          Left = 297
          Top = 22
          Width = 69
          Height = 14
          Caption = 'Hintergrund:'
        end
        object OptionenKapitellistenFarbeVG_: TLabel
          Left = 8
          Top = 22
          Width = 73
          Height = 14
          Caption = 'Vordergrund:'
        end
        object OptionenKapitellistenMarkierungFarbeHG_: TLabel
          Left = 296
          Top = 48
          Width = 78
          Height = 14
          Caption = 'MarkierungHg:'
          Enabled = False
          WordWrap = True
        end
        object OptionenKapitellistenVerschiebeFarbeHG_: TLabel
          Left = 296
          Top = 74
          Width = 86
          Height = 14
          Caption = 'VerschiebenHg:'
          WordWrap = True
        end
        object KapitellistenVerschiebeFarbeVGColorBox: TColorBox
          Left = 110
          Top = 69
          Width = 150
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
          ItemHeight = 16
          TabOrder = 4
        end
        object KapitellistenVerschiebeFarbeHGColorBox: TColorBox
          Left = 406
          Top = 69
          Width = 150
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
          ItemHeight = 16
          TabOrder = 5
        end
        object KapitellistenMarkierungFarbeHGColorBox: TColorBox
          Left = 406
          Top = 43
          Width = 150
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
          ItemHeight = 16
          TabOrder = 3
        end
        object KapitellistenMarkierungFarbeVGColorBox: TColorBox
          Left = 110
          Top = 43
          Width = 150
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
          ItemHeight = 16
          TabOrder = 2
        end
        object KapitellistenFarbeVGColorBox: TColorBox
          Left = 110
          Top = 17
          Width = 150
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
          ItemHeight = 16
          TabOrder = 0
        end
        object KapitellistenFarbeHGColorBox: TColorBox
          Left = 406
          Top = 17
          Width = 150
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
          ItemHeight = 16
          TabOrder = 1
        end
      end
      object OptionenKapitellistenSonstiges_: TGroupBox
        Left = 4
        Top = 188
        Width = 565
        Height = 139
        Caption = 'Sonstiges '
        TabOrder = 2
        object OptionenKapitelFormatEinfuegen_: TLabel
          Left = 8
          Top = 22
          Width = 52
          Height = 14
          Caption = 'Einf'#252'gen:'
        end
        object KapitelFormatEinfuegenComboBox: TComboBox
          Left = 110
          Top = 17
          Width = 150
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          TabOrder = 0
          Items.Strings = (
            'vor der Markierung'
            'nach der Markierung'
            'am Ende'
            #228'ndern')
        end
      end
    end
    object OptionenMarkenlistenFormatseiteTab: TTabSheet
      Caption = 'Markenliste'
      ImageIndex = 14
      object OptionenMarkenlistenFormat_: TGroupBox
        Left = 4
        Top = 6
        Width = 565
        Height = 73
        Caption = 'Format '
        TabOrder = 0
        object OptionenMarkenZahlenformat_: TLabel
          Left = 8
          Top = 22
          Width = 42
          Height = 14
          Caption = 'Format:'
        end
        object MarkenFormatEdit: TEdit
          Left = 70
          Top = 18
          Width = 289
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 0
          OnContextPopup = EditBoxContextPopup
        end
      end
      object OptionenMarkenlistenSonstiges_: TGroupBox
        Left = 4
        Top = 84
        Width = 565
        Height = 245
        Caption = 'Sonstiges '
        TabOrder = 1
        object OptionenMarkenFormatEinfuegen_: TLabel
          Left = 8
          Top = 48
          Width = 52
          Height = 14
          Caption = 'Einf'#252'gen:'
        end
        object OptionenMarkenlistebearbeitenBox: TCheckBox
          Left = 8
          Top = 20
          Width = 265
          Height = 17
          Caption = 'Markenliste bearbeiten'
          TabOrder = 0
        end
        object MarkenFormatEinfuegenComboBox: TComboBox
          Left = 70
          Top = 44
          Width = 150
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          TabOrder = 1
          Items.Strings = (
            'vor der Markierung'
            'nach der Markierung'
            'am Ende')
        end
      end
    end
    object OptionenListenImportseiteTab: TTabSheet
      Caption = 'Listenimport'
      object OptionenSchnittlistenimport_: TGroupBox
        Left = 2
        Top = 8
        Width = 188
        Height = 323
        Caption = 'Schnittlistenimport'
        TabOrder = 0
        object OptionenSchnittImportTrennzeichenliste_: TLabel
          Left = 6
          Top = 60
          Width = 74
          Height = 14
          Caption = 'Trennzeichen'
        end
        object OptionenSchnittImportZeitTrennzeichenliste_: TLabel
          Left = 6
          Top = 92
          Width = 92
          Height = 14
          Caption = 'Zeittrennzeichen'
        end
        object SchnittImportTrennzeichenCombobox: TComboBox
          Left = 100
          Top = 56
          Width = 52
          Height = 22
          AutoComplete = False
          ItemHeight = 14
          PopupMenu = ComboBoxMenue
          TabOrder = 0
          OnContextPopup = ComboboxContextPopup
          OnKeyPress = ComboboxKeyPress
          OnSelect = ComboBoxSelect
        end
        object SchnittImportZeitTrennzeichenCombobox: TComboBox
          Left = 100
          Top = 88
          Width = 52
          Height = 22
          AutoComplete = False
          ItemHeight = 14
          PopupMenu = ComboBoxMenue
          TabOrder = 2
          OnContextPopup = ComboboxContextPopup
          OnKeyPress = ComboboxKeyPress
          OnSelect = ComboBoxSelect
        end
        object SchnittImportZeitTrennzeichenBitBtn: TBitBtn
          Left = 155
          Top = 88
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 3
          OnClick = ComboBoxBitBtnClick
        end
        object SchnittImportTrennzeichenBitBtn: TBitBtn
          Left = 155
          Top = 56
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 1
          OnClick = ComboBoxBitBtnClick
        end
      end
      object OptionenKapitellistenimport_: TGroupBox
        Left = 192
        Top = 8
        Width = 188
        Height = 323
        Caption = 'Kapitellistenimport'
        TabOrder = 1
        object OptionenKapitelImportTrennzeichenliste_: TLabel
          Left = 6
          Top = 60
          Width = 74
          Height = 14
          Caption = 'Trennzeichen'
        end
        object OptionenKapitelImportZeitTrennzeichenliste_: TLabel
          Left = 6
          Top = 92
          Width = 92
          Height = 14
          Caption = 'Zeittrennzeichen'
        end
        object OptionenSchnittlistenimportuebernehmenBox1: TCheckBox
          Left = 8
          Top = 20
          Width = 173
          Height = 27
          Caption = 'Schnittlistenimport '#252'bernehmen'
          TabOrder = 0
          WordWrap = True
          OnClick = OptionenSchnittlistenimportuebernehmenBox1Click
        end
        object KapitelImportTrennzeichenCombobox: TComboBox
          Left = 100
          Top = 56
          Width = 52
          Height = 22
          AutoComplete = False
          ItemHeight = 14
          PopupMenu = ComboBoxMenue
          TabOrder = 1
          OnContextPopup = ComboboxContextPopup
          OnKeyPress = ComboboxKeyPress
          OnSelect = ComboBoxSelect
        end
        object KapitelImportZeitTrennzeichenCombobox: TComboBox
          Left = 100
          Top = 88
          Width = 52
          Height = 22
          AutoComplete = False
          ItemHeight = 14
          PopupMenu = ComboBoxMenue
          TabOrder = 3
          OnContextPopup = ComboboxContextPopup
          OnKeyPress = ComboboxKeyPress
          OnSelect = ComboBoxSelect
        end
        object KapitelImportZeitTrennzeichenBitBtn: TBitBtn
          Left = 155
          Top = 88
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 4
          OnClick = ComboBoxBitBtnClick
        end
        object KapitelImportTrennzeichenBitBtn: TBitBtn
          Left = 155
          Top = 56
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 2
          OnClick = ComboBoxBitBtnClick
        end
      end
      object OptionenMarkenlistenimport_: TGroupBox
        Left = 382
        Top = 8
        Width = 188
        Height = 323
        Caption = 'Markenlistenimport'
        TabOrder = 2
        object OptionenMarkenImportTrennzeichenliste_: TLabel
          Left = 6
          Top = 60
          Width = 74
          Height = 14
          Caption = 'Trennzeichen'
        end
        object OptionenMarkenImportZeitTrennzeichenliste_: TLabel
          Left = 6
          Top = 92
          Width = 92
          Height = 14
          Caption = 'Zeittrennzeichen'
        end
        object OptionenSchnittlistenimportuebernehmenBox2: TCheckBox
          Left = 8
          Top = 20
          Width = 173
          Height = 27
          Caption = 'Schnittlistenimport '#252'bernehmen'
          TabOrder = 0
          WordWrap = True
          OnClick = OptionenSchnittlistenimportuebernehmenBox2Click
        end
        object MarkenImportTrennzeichenCombobox: TComboBox
          Left = 100
          Top = 56
          Width = 52
          Height = 22
          AutoComplete = False
          ItemHeight = 14
          PopupMenu = ComboBoxMenue
          TabOrder = 1
          OnContextPopup = ComboboxContextPopup
          OnKeyPress = ComboboxKeyPress
          OnSelect = ComboBoxSelect
        end
        object MarkenImportZeitTrennzeichenCombobox: TComboBox
          Left = 100
          Top = 88
          Width = 52
          Height = 22
          AutoComplete = False
          ItemHeight = 14
          PopupMenu = ComboBoxMenue
          TabOrder = 3
          OnContextPopup = ComboboxContextPopup
          OnKeyPress = ComboboxKeyPress
          OnSelect = ComboBoxSelect
        end
        object MarkenImportTrennzeichenBitBtn: TBitBtn
          Left = 155
          Top = 56
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 2
          OnClick = ComboBoxBitBtnClick
        end
        object MarkenImportZeitTrennzeichenBitBtn: TBitBtn
          Left = 155
          Top = 88
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 4
          OnClick = ComboBoxBitBtnClick
        end
      end
    end
    object OptionenListenExportseiteTab: TTabSheet
      Caption = 'Listenexport'
      ImageIndex = 1
      object OptionenKapitellistenexport_: TGroupBox
        Left = 192
        Top = 8
        Width = 188
        Height = 323
        Caption = 'Kapitellistenexport'
        TabOrder = 1
        object OptionenKapitelexportFormat_: TLabel
          Left = 8
          Top = 52
          Width = 42
          Height = 14
          Caption = 'Format:'
        end
        object OptionenKapitelexportOffset_: TLabel
          Left = 8
          Top = 102
          Width = 38
          Height = 14
          Caption = 'Offset:'
        end
        object KapitelexportFormatEdit: TEdit
          Left = 8
          Top = 72
          Width = 175
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 1
          OnContextPopup = EditBoxContextPopup
        end
        object KapitelexportOffsetEdit: TEdit
          Left = 106
          Top = 98
          Width = 75
          Height = 22
          TabOrder = 2
        end
        object OptionenSchnittlistenexportuebernehmenBox1: TCheckBox
          Left = 8
          Top = 20
          Width = 173
          Height = 27
          Caption = 'Schnittlistenformat '#252'bernehmen'
          TabOrder = 0
          WordWrap = True
          OnClick = OptionenSchnittlistenexportuebernehmenBox1Click
        end
      end
      object OptionenSchnittlistenexport_: TGroupBox
        Left = 2
        Top = 8
        Width = 188
        Height = 323
        Caption = 'Schnittlistenexport'
        TabOrder = 0
        object OptionenSchnittexportFormat_: TLabel
          Left = 8
          Top = 52
          Width = 42
          Height = 14
          Caption = 'Format:'
        end
        object OptionenSchnittexportOffset_: TLabel
          Left = 8
          Top = 102
          Width = 38
          Height = 14
          Caption = 'Offset:'
        end
        object SchnittexportFormatEdit: TEdit
          Left = 6
          Top = 70
          Width = 175
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 0
          OnContextPopup = EditBoxContextPopup
        end
        object SchnittexportOffsetEdit: TEdit
          Left = 106
          Top = 98
          Width = 75
          Height = 22
          TabOrder = 1
        end
      end
      object OptionenMarkenlistenexport_: TGroupBox
        Left = 382
        Top = 8
        Width = 188
        Height = 323
        Caption = 'Markenlistenexport'
        TabOrder = 2
        object OptionenMarkenexportFormat_: TLabel
          Left = 8
          Top = 52
          Width = 42
          Height = 14
          Caption = 'Format:'
        end
        object OptionenMarkenexportOffset_: TLabel
          Left = 8
          Top = 102
          Width = 38
          Height = 14
          Caption = 'Offset:'
        end
        object MarkenexportFormatEdit: TEdit
          Left = 6
          Top = 70
          Width = 175
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 1
          OnContextPopup = EditBoxContextPopup
        end
        object MarkenexportOffsetEdit: TEdit
          Left = 106
          Top = 98
          Width = 75
          Height = 22
          TabOrder = 2
        end
        object OptionenSchnittlistenexportuebernehmenBox2: TCheckBox
          Left = 8
          Top = 20
          Width = 173
          Height = 27
          Caption = 'Schnittlistenformat '#252'bernehmen'
          TabOrder = 0
          WordWrap = True
          OnClick = OptionenSchnittlistenexportuebernehmenBox2Click
        end
      end
    end
    object OptionenTastenbelegungseiteTab: TTabSheet
      Caption = 'Tastenbelegung'
      ImageIndex = 4
      object TastenbelegungGrid: TStringGrid
        Left = 0
        Top = 2
        Width = 401
        Height = 329
        ColCount = 2
        DefaultColWidth = 200
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 47
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goRowSelect, goThumbTracking]
        PopupMenu = TastenbelegungMenu
        ScrollBars = ssVertical
        TabOrder = 0
        OnClick = TastenbelegungGridClick
        OnDblClick = TastenbelegungGridDblClick
        OnDrawCell = TastenbelegungGridDrawCell
        OnKeyDown = TastenbelegungGridKeyDown
      end
      object OptionenEigeneTastenbelegung_: TGroupBox
        Left = 410
        Top = 2
        Width = 159
        Height = 135
        Caption = 'eigene Tastenbelegung'
        TabOrder = 1
        object OptionenInfofensterTastenCheckBox: TCheckBox
          Left = 10
          Top = 22
          Width = 145
          Height = 17
          Caption = 'Infofenster'
          TabOrder = 0
        end
        object OptionenSchnittlisteTastenCheckBox: TCheckBox
          Left = 10
          Top = 42
          Width = 145
          Height = 17
          Caption = 'Schnittliste'
          TabOrder = 1
        end
        object OptionenKapitellisteTastenCheckBox: TCheckBox
          Left = 10
          Top = 62
          Width = 145
          Height = 17
          Caption = 'Kapitelliste'
          TabOrder = 2
        end
        object OptionenMarkenlisteTastenCheckBox: TCheckBox
          Left = 10
          Top = 82
          Width = 145
          Height = 17
          Caption = 'Markenliste'
          TabOrder = 3
        end
        object OptionenDateienfensterTastenCheckBox: TCheckBox
          Left = 10
          Top = 102
          Width = 145
          Height = 17
          Caption = 'Dateienfenster'
          TabOrder = 4
        end
      end
      object OptionenSchrittweiten_: TGroupBox
        Left = 410
        Top = 144
        Width = 159
        Height = 129
        Caption = 'SchrittweiteTasten'
        TabOrder = 2
        object OptionenSchrittweite1_: TLabel
          Left = 10
          Top = 24
          Width = 78
          Height = 14
          Caption = 'Schrittweite 1'
        end
        object OptionenSchrittweite2_: TLabel
          Left = 10
          Top = 52
          Width = 78
          Height = 14
          Caption = 'Schrittweite 2'
        end
        object OptionenSchrittweite3_: TLabel
          Left = 10
          Top = 78
          Width = 78
          Height = 14
          Caption = 'Schrittweite 3'
        end
        object OptionenSchrittweite4_: TLabel
          Left = 10
          Top = 104
          Width = 78
          Height = 14
          Caption = 'Schrittweite 4'
        end
        object Schrittweite1Edit: TEdit
          Left = 92
          Top = 20
          Width = 63
          Height = 22
          TabOrder = 0
        end
        object Schrittweite2Edit: TEdit
          Left = 92
          Top = 46
          Width = 63
          Height = 22
          TabOrder = 1
        end
        object Schrittweite3Edit: TEdit
          Left = 92
          Top = 72
          Width = 63
          Height = 22
          TabOrder = 2
        end
        object Schrittweite4Edit: TEdit
          Left = 92
          Top = 98
          Width = 63
          Height = 22
          TabOrder = 3
        end
      end
    end
    object OptionenNavigationsseiteTab: TTabSheet
      Caption = 'Navigation'
      ImageIndex = 5
      object OptionenAbspielzeit_: TLabel
        Left = 22
        Top = 30
        Width = 61
        Height = 14
        Caption = 'Abspielzeit:'
      end
      object OptionenAbspielzeit_sek: TLabel
        Left = 200
        Top = 30
        Width = 55
        Height = 14
        Caption = 'Sekunden'
      end
      object AbspielzeitEdit: TEdit
        Left = 126
        Top = 26
        Width = 67
        Height = 22
        TabOrder = 0
      end
      object OptionenScrollradBox: TCheckBox
        Left = 22
        Top = 66
        Width = 297
        Height = 17
        Caption = 'Scrollrad f'#252'r Audiooffset benutzen'
        TabOrder = 1
      end
      object OptionenVAextraBox: TCheckBox
        Left = 22
        Top = 90
        Width = 297
        Height = 17
        Caption = 'Video und Audio getrennt '#246'ffnen'
        TabOrder = 2
      end
      object OptionenOutSchnittanzeigenBox: TCheckBox
        Left = 22
        Top = 114
        Width = 297
        Height = 17
        Caption = 'Out-Schnitt im zweiten Videofenster anzeigen'
        TabOrder = 3
      end
      object OptionenKlickBox: TCheckBox
        Left = 22
        Top = 138
        Width = 297
        Height = 17
        Caption = 'Klick startet/stopt Wiedergabe'
        TabOrder = 4
      end
      object OptionenDoppelKlickBox: TCheckBox
        Left = 22
        Top = 162
        Width = 297
        Height = 17
        Caption = 'Doppelklick schaltet auf Vollbild'
        TabOrder = 5
      end
    end
    object OptionenVorschauseiteTab: TTabSheet
      Caption = 'Vorschau'
      ImageIndex = 6
      object OptionenVorschauDauer_: TLabel
        Left = 22
        Top = 30
        Width = 85
        Height = 14
        Caption = 'Vorschaudauer:'
      end
      object OptionenVorschauDauerSek_: TLabel
        Left = 242
        Top = 30
        Width = 55
        Height = 14
        Caption = 'Sekunden'
      end
      object OptionenPlus_: TLabel
        Left = 290
        Top = 58
        Width = 8
        Height = 14
        Caption = '+'
      end
      object OptionenVorschauDauerSek_2: TLabel
        Left = 366
        Top = 58
        Width = 55
        Height = 14
        Caption = 'Sekunden'
      end
      object OptionenVorschaudateienloeschenBox: TCheckBox
        Left = 22
        Top = 102
        Width = 265
        Height = 17
        Caption = 'Vorschaudateien l'#246'schen'
        TabOrder = 2
      end
      object OptionenVorschauneuberechnenBox: TCheckBox
        Left = 22
        Top = 80
        Width = 265
        Height = 17
        Caption = 'Vorschau neu berechnen'
        TabOrder = 1
      end
      object VorschauDauer1Edit: TEdit
        Left = 126
        Top = 26
        Width = 47
        Height = 22
        TabOrder = 0
      end
      object OptionenVorschaudauererweiternBox: TCheckBox
        Left = 22
        Top = 58
        Width = 265
        Height = 17
        Caption = 'Vorschaudauer auf Effektl'#228'nge erweitern'
        TabOrder = 3
      end
      object VorschauDauer2Edit: TEdit
        Left = 184
        Top = 26
        Width = 47
        Height = 22
        TabOrder = 4
      end
      object VorschaudauerPlusEdit: TEdit
        Left = 308
        Top = 56
        Width = 47
        Height = 22
        TabOrder = 5
      end
    end
    object OptionenAusgabeseiteTab: TTabSheet
      Caption = 'externe Programme'
      ImageIndex = 10
      object OptionenEncoden_: TGroupBox
        Left = 2
        Top = 72
        Width = 567
        Height = 61
        Caption = 'Encoden'
        TabOrder = 1
        object OptionenEncoder_: TLabel
          Left = 8
          Top = 24
          Width = 49
          Height = 14
          Caption = 'Encoder:'
        end
        object EncoderBitBtn: TBitBtn
          Left = 434
          Top = 22
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 0
          OnClick = EditBoxBitBtnClick
        end
        object EncoderDateiEdit: TEdit
          Left = 180
          Top = 22
          Width = 252
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 1
          OnContextPopup = EditBoxContextPopup
          OnKeyPress = EditBoxKeyPress
        end
      end
      object OptionenAusgabe_: TGroupBox
        Left = 2
        Top = 140
        Width = 567
        Height = 61
        Caption = 'Ausgabe'
        TabOrder = 2
        object OptionenAusgabePr_: TLabel
          Left = 8
          Top = 24
          Width = 97
          Height = 14
          Caption = 'Nachbearbeitung:'
        end
        object AusgabeBitBtn: TBitBtn
          Left = 434
          Top = 22
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 0
          OnClick = EditBoxBitBtnClick
        end
        object AusgabeDateiEdit: TEdit
          Left = 180
          Top = 22
          Width = 252
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 1
          OnContextPopup = EditBoxContextPopup
          OnKeyPress = EditBoxKeyPress
        end
      end
      object OptionenDemuxen_: TGroupBox
        Left = 2
        Top = 4
        Width = 567
        Height = 61
        Caption = 'Demuxen'
        Enabled = False
        TabOrder = 0
        object OptionenDemuxer_: TLabel
          Left = 8
          Top = 24
          Width = 56
          Height = 14
          Caption = 'Demuxen:'
          Enabled = False
        end
        object DemuxerBitBtn: TBitBtn
          Left = 434
          Top = 22
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 0
          OnClick = EditBoxBitBtnClick
        end
        object DemuxerDateiEdit: TEdit
          Left = 180
          Top = 22
          Width = 252
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 1
          OnContextPopup = EditBoxContextPopup
          OnKeyPress = EditBoxKeyPress
        end
      end
    end
    object OptionenEffektseiteTab: TTabSheet
      Caption = 'Effekte'
      ImageIndex = 8
      object OptionenEffekt_bearbeiten_: TGroupBox
        Left = 4
        Top = 4
        Width = 567
        Height = 157
        Caption = 'Effektliste bearbeiten'
        TabOrder = 0
        object OptionenAudioEffekte_: TLabel
          Left = 8
          Top = 122
          Width = 75
          Height = 14
          Caption = 'Audioeffekte:'
        end
        object OptionenVideoEffekte_: TLabel
          Left = 8
          Top = 90
          Width = 75
          Height = 14
          Caption = 'Videoeffekte:'
        end
        object OptionenVideoEffektverz_: TLabel
          Left = 8
          Top = 30
          Width = 126
          Height = 14
          Caption = 'Videoeffektverzeichnis:'
        end
        object OptionenAudioEffektverz_: TLabel
          Left = 8
          Top = 60
          Width = 126
          Height = 14
          Caption = 'Audioeffektverzeichnis:'
        end
        object AudioEffektComboBox: TComboBox
          Left = 158
          Top = 118
          Width = 177
          Height = 22
          AutoComplete = False
          Style = csDropDownList
          ItemHeight = 14
          TabOrder = 2
        end
        object EffektAudioGroupBox: TGroupBox
          Left = 340
          Top = 110
          Width = 217
          Height = 33
          TabOrder = 4
          Visible = False
          object OptionenEffektePCMRadioButton: TRadioButton
            Left = 6
            Top = 10
            Width = 49
            Height = 17
            Caption = 'PCM'
            Enabled = False
            TabOrder = 0
          end
          object OptionenEffekteMP2RadioButton: TRadioButton
            Left = 60
            Top = 10
            Width = 49
            Height = 17
            Caption = 'MP2'
            Checked = True
            TabOrder = 1
            TabStop = True
          end
          object OptionenEffekteAC3RadioButton: TRadioButton
            Left = 114
            Top = 10
            Width = 51
            Height = 17
            Caption = 'AC3'
            TabOrder = 2
          end
          object OptionenAlleTypenRadioButton: TRadioButton
            Left = 168
            Top = 10
            Width = 47
            Height = 17
            Caption = 'Alle'
            TabOrder = 3
          end
        end
        object VideoEffektComboBox: TComboBox
          Left = 158
          Top = 86
          Width = 177
          Height = 22
          AutoComplete = False
          Style = csDropDownList
          ItemHeight = 14
          TabOrder = 0
        end
        object AudioEffektBitBtn: TBitBtn
          Left = 338
          Top = 118
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 3
          Visible = False
          OnClick = ComboBoxBitBtnClick
        end
        object VideoEffektBitBtn: TBitBtn
          Left = 338
          Top = 86
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 1
          Visible = False
          OnClick = ComboBoxBitBtnClick
        end
        object VideoEffektverzEdit: TEdit
          Left = 158
          Top = 26
          Width = 252
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 5
          OnContextPopup = EditBoxContextPopup
          OnKeyPress = EditBoxKeyPress
        end
        object VideoEffektdateiBitBtn: TBitBtn
          Left = 413
          Top = 26
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 6
          OnClick = EditBoxBitBtnClick
        end
        object AudioEffektverzEdit: TEdit
          Left = 158
          Top = 56
          Width = 252
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 7
          OnContextPopup = EditBoxContextPopup
          OnKeyPress = EditBoxKeyPress
        end
        object AudioEffektdateiBitBtn: TBitBtn
          Left = 413
          Top = 56
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 8
          OnClick = EditBoxBitBtnClick
        end
      end
      object OptionenEffekt_Voreinstellung_: TGroupBox
        Left = 4
        Top = 166
        Width = 567
        Height = 163
        Caption = 'Effektvoreinstellungen'
        TabOrder = 1
        object OptionenEffektvorgabenVideo_: TLabel
          Left = 8
          Top = 58
          Width = 119
          Height = 14
          Caption = 'Videoeffektvorgaben:'
        end
        object OptionenEffektvorgabenAudio_: TLabel
          Left = 8
          Top = 88
          Width = 119
          Height = 14
          Caption = 'Audioeffektvorgaben:'
        end
        object OptionenEffektvorgabedatei_: TLabel
          Left = 8
          Top = 30
          Width = 108
          Height = 14
          Caption = 'Effektvorgabedatei:'
        end
        object EffektvorgabeVideoComboBox: TComboBox
          Left = 158
          Top = 56
          Width = 177
          Height = 22
          AutoComplete = False
          ItemHeight = 14
          PopupMenu = ComboBoxMenue
          TabOrder = 0
          OnCloseUp = ComboBoxSelect
          OnContextPopup = ComboboxContextPopup
          OnKeyPress = ComboboxKeyPress
          OnSelect = ComboBoxSelect
        end
        object EffektvorgabeAudioComboBox: TComboBox
          Left = 158
          Top = 86
          Width = 177
          Height = 22
          AutoComplete = False
          ItemHeight = 14
          PopupMenu = ComboBoxMenue
          TabOrder = 2
          OnCloseUp = ComboBoxSelect
          OnContextPopup = ComboboxContextPopup
          OnKeyPress = ComboboxKeyPress
          OnSelect = ComboBoxSelect
        end
        object EffektvorgabeAudioBitBtn: TBitBtn
          Left = 338
          Top = 86
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 3
          OnClick = ComboBoxBitBtnClick
        end
        object EffektvorgabeVideoBitBtn: TBitBtn
          Left = 338
          Top = 56
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 1
          OnClick = ComboBoxBitBtnClick
        end
        object EffektvorgabedateiEdit: TEdit
          Left = 158
          Top = 26
          Width = 252
          Height = 22
          PopupMenu = EditBoxMenue
          TabOrder = 4
          OnContextPopup = EditBoxContextPopup
          OnKeyPress = EditBoxKeyPress
        end
        object EffektvorgabedateiBitBtn: TBitBtn
          Left = 413
          Top = 26
          Width = 25
          Height = 21
          Caption = '-->'
          TabOrder = 5
          OnClick = EditBoxBitBtnClick
        end
        object OptionenVorgabeeffekteverwendenBox: TCheckBox
          Left = 12
          Top = 112
          Width = 541
          Height = 17
          Caption = 'eingestellte Effektvorgaben im Effektdialog verwenden'
          TabOrder = 6
        end
      end
    end
    object OptionenGrobansichtSeiteTab: TTabSheet
      Caption = 'Film'#252'bersicht'
      ImageIndex = 16
      object OptionenSchrittweite_: TLabel
        Left = 20
        Top = 23
        Width = 120
        Height = 14
        Caption = 'Schrittweite in Bildern'
      end
      object OptionenBildbreite_: TLabel
        Left = 20
        Top = 49
        Width = 54
        Height = 14
        Caption = 'Bildbreite '
      end
      object OptionenWerbefarbe_: TLabel
        Left = 20
        Top = 102
        Width = 65
        Height = 14
        Caption = 'Werbefarbe'
      end
      object OptionenFilmfarbe_: TLabel
        Left = 20
        Top = 129
        Width = 48
        Height = 14
        Caption = 'Filmfarbe'
      end
      object OptionenAktivfarbe_: TLabel
        Left = 20
        Top = 76
        Width = 55
        Height = 14
        Caption = 'Aktivfarbe'
      end
      object OptionenSchrittweiteSpinEdit: TSpinEdit
        Left = 203
        Top = 20
        Width = 108
        Height = 23
        Increment = 25
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
      end
      object OptionenBildbreiteSpinEdit: TSpinEdit
        Left = 203
        Top = 47
        Width = 108
        Height = 23
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
      object OptionenWerbefarbeColorBox: TColorBox
        Left = 162
        Top = 100
        Width = 150
        Height = 22
        DefaultColorColor = clRed
        Selected = clRed
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
        ItemHeight = 16
        TabOrder = 2
      end
      object OptionenFilmfarbeColorBox: TColorBox
        Left = 162
        Top = 127
        Width = 150
        Height = 22
        DefaultColorColor = clGreen
        Selected = clGreen
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
        ItemHeight = 16
        TabOrder = 3
      end
      object OptionenAktivfarbeColorBox: TColorBox
        Left = 162
        Top = 74
        Width = 150
        Height = 22
        DefaultColorColor = clActiveCaption
        Selected = clActiveCaption
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
        ItemHeight = 16
        TabOrder = 4
      end
    end
  end
  object OptionenSpeichern: TBitBtn
    Left = 144
    Top = 413
    Width = 90
    Height = 35
    Hint = 'Einstellungen speichern'
    Anchors = [akLeft, akBottom]
    Caption = 'Speichern'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = SpeichernTasteClick
    NumGlyphs = 2
  end
  object OptionenSpeichernunter: TBitBtn
    Left = 242
    Top = 413
    Width = 99
    Height = 35
    Hint = 'Einstellungen unter neuem Namen speichern'
    Anchors = [akLeft, akBottom]
    Caption = 'Speichern unter'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = SpeichernunterTasteClick
    NumGlyphs = 2
  end
  object OptionenStandard: TBitBtn
    Left = 348
    Top = 413
    Width = 90
    Height = 35
    Hint = 'Einstellungen als Standard speichern'
    Anchors = [akLeft, akBottom]
    Caption = 'Standard'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = StandardTasteClick
    NumGlyphs = 2
  end
  object ComboBoxMenue: TPopupMenu
    OnPopup = ComboBoxMenuePopup
    Left = 40
    Top = 378
    object ListeneintragDateisuchen: TMenuItem
      Caption = 'Datei suchen'
      OnClick = ListeneintragDateisuchenClick
    end
    object Listeneintragneu: TMenuItem
      Caption = 'neuer Eintrag'
      OnClick = ListeneintragneuClick
    end
    object Listeneintragkopieren: TMenuItem
      Caption = 'Eintrag kopieren'
      OnClick = ListeneintragkopierenClick
    end
    object Listeneintrageinfuegen: TMenuItem
      Caption = 'Eintrag einf'#252'gen'
      OnClick = ListeneintrageinfuegenClick
    end
    object Listeneintragaendern: TMenuItem
      Caption = 'Eintrag '#228'ndern'
      OnClick = ListeneintragaendernClick
    end
    object Listeneintragbearbeiten: TMenuItem
      Caption = 'Eintrag bearbeiten'
      OnClick = ListeneintragbearbeitenClick
    end
    object Listeneintragloeschen: TMenuItem
      Caption = 'Eintrag l'#246'schen'
      OnClick = ListeneintragloeschenClick
    end
    object Trennlienie16: TMenuItem
      Caption = '-'
    end
    object ComboBoxAusschneidenClipboard: TMenuItem
      Caption = 'Ausschneiden'
      OnClick = ComboBoxAusschneidenClipboardClick
    end
    object ComboBoxKopierenClipboard: TMenuItem
      Caption = 'Kopieren'
      OnClick = ComboBoxKopierenClipboardClick
    end
    object ComboBoxEinfuegenClipboard: TMenuItem
      Caption = 'Einf'#252'gen'
      OnClick = ComboBoxEinfuegenClipboardClick
    end
    object ComboboxLoeschenClipboard: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = ComboboxLoeschenClipboardClick
    end
  end
  object EditBoxMenue: TPopupMenu
    OnPopup = EditBoxMenuePopup
    Left = 74
    Top = 378
    object EditBoxDateisuchen: TMenuItem
      Caption = 'Datei suchen'
      OnClick = EditBoxDateisuchenClick
    end
    object EditBoxVerzeichnissuchen: TMenuItem
      Caption = 'Verzeichnis suchen'
      OnClick = EditBoxVerzeichnissuchenClick
    end
    object EditBoxDateispeichern: TMenuItem
      Caption = 'Datei speichern'
      OnClick = EditBoxDateispeichernClick
    end
    object EditBoxDateispeichernunter: TMenuItem
      Caption = 'Datei speichern unter'
      OnClick = EditBoxDateispeichernunterClick
    end
    object EditBoxFormat1: TMenuItem
      Caption = 'F'
      OnClick = EditBoxFormatClick
    end
    object EditBoxFormat2: TMenuItem
      AutoHotkeys = maManual
      Caption = 'hh:mm:ss.mss'
      OnClick = EditBoxFormatClick
    end
    object EditBoxFormat3: TMenuItem
      AutoHotkeys = maManual
      Caption = 'hh:mm:ss:ff'
      OnClick = EditBoxFormatClick
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
  object TastenbelegungMenu: TPopupMenu
    Left = 108
    Top = 378
    object Tastenbelegungloeschen: TMenuItem
      Caption = 'Tastenbelegung l'#246'schen'
      OnClick = TastenbelegungloeschenClick
    end
  end
  object SchriftDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [fdForceFontExist, fdNoOEMFonts]
    Left = 8
    Top = 378
  end
end
