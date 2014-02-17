object Hauptprogramm: THauptprogramm
  Left = 400
  Top = 205
  Width = 700
  Height = 570
  Color = clBtnFace
  Constraints.MinHeight = 570
  Constraints.MinWidth = 700
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = Hauptmenue
  OldCreateOrder = False
  Scaled = False
  ShowHint = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Tastenpanel: TPanel
    Left = 0
    Top = 439
    Width = 692
    Height = 77
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      692
      77)
    object Projektgroesse_: TLabel
      Left = 10
      Top = 5
      Width = 75
      Height = 14
      Anchors = [akLeft, akBottom]
      Caption = 'Projektgr'#246#223'e:'
    end
    object aktDateigroesse: TLabel
      Left = 92
      Top = 5
      Width = 84
      Height = 16
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = '0 MB'
    end
    object Zeit_: TLabel
      Left = 243
      Top = 5
      Width = 25
      Height = 14
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Zeit:'
    end
    object ZeitDatei: TLabel
      Left = 272
      Top = 5
      Width = 50
      Height = 14
      Anchors = [akLeft, akBottom]
      Caption = '00:00:00'
    end
    object Restzeit_: TLabel
      Left = 421
      Top = 5
      Width = 47
      Height = 14
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = 'Restzeit:'
    end
    object RestzeitDatei: TLabel
      Left = 472
      Top = 5
      Width = 50
      Height = 14
      Anchors = [akRight, akBottom]
      Caption = '00:00:00'
    end
    object Gesamtezeit_: TLabel
      Left = 562
      Top = 5
      Width = 64
      Height = 14
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = 'Gesamtzeit:'
    end
    object GesamtzeitDatei: TLabel
      Left = 630
      Top = 5
      Width = 50
      Height = 14
      Anchors = [akRight, akBottom]
      Caption = '00:00:00'
    end
    object GesamtzeitGesamt: TLabel
      Left = 630
      Top = 39
      Width = 50
      Height = 14
      Anchors = [akRight, akBottom]
      Caption = '00:00:00'
    end
    object Gesamtezeit_1: TLabel
      Left = 562
      Top = 39
      Width = 64
      Height = 14
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = 'Gesamtzeit:'
    end
    object RestzeitGesamt: TLabel
      Left = 472
      Top = 39
      Width = 50
      Height = 14
      Anchors = [akRight, akBottom]
      Caption = '00:00:00'
    end
    object Restzeit_1: TLabel
      Left = 421
      Top = 39
      Width = 47
      Height = 14
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = 'Restzeit:'
    end
    object ZeitGesamt: TLabel
      Left = 272
      Top = 39
      Width = 50
      Height = 14
      Anchors = [akLeft, akBottom]
      Caption = '00:00:00'
    end
    object Zeit_1: TLabel
      Left = 243
      Top = 39
      Width = 25
      Height = 14
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Zeit:'
    end
    object Gesamtgroesse: TLabel
      Left = 94
      Top = 39
      Width = 82
      Height = 16
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = '0 MB'
    end
    object Gesamtgroesse_: TLabel
      Left = 10
      Top = 39
      Width = 77
      Height = 14
      Anchors = [akLeft, akBottom]
      Caption = 'Gesamtgr'#246#223'e:'
    end
    object Dateien: TTreeView
      Left = 604
      Top = 28
      Width = 21
      Height = 21
      Anchors = [akTop, akRight]
      Indent = 19
      TabOrder = 0
      Visible = False
    end
    object Schnittliste: TListBox
      Left = 628
      Top = 28
      Width = 21
      Height = 21
      Anchors = [akTop, akRight]
      ItemHeight = 14
      TabOrder = 1
      Visible = False
    end
    object Kapitelliste: TStringGrid
      Tag = 1
      Left = 580
      Top = 28
      Width = 21
      Height = 21
      Anchors = [akTop, akRight]
      ColCount = 4
      DefaultRowHeight = 16
      FixedCols = 0
      RowCount = 2
      ScrollBars = ssNone
      TabOrder = 2
      Visible = False
    end
    object Markenliste: TMemo
      Left = 652
      Top = 28
      Width = 21
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 3
      Visible = False
    end
    object Fortschrittgesamt: TProgressBar
      Left = 9
      Top = 56
      Width = 673
      Height = 15
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 4
    end
    object FortschrittDatei: TProgressBar
      Left = 9
      Top = 22
      Width = 673
      Height = 15
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 5
    end
  end
  object aendereZahlEdit: TEdit
    Left = 498
    Top = 156
    Width = 121
    Height = 24
    TabStop = False
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 1
    Visible = False
    OnExit = aendereZahlEditExit
    OnKeyPress = aendereZahlEditKeyPress
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 692
    Height = 37
    ButtonHeight = 32
    ButtonWidth = 141
    Caption = 'ToolBar'
    TabOrder = 2
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Width = 8
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object ProjekteinfuegenBtn: TSpeedButton
      Left = 8
      Top = 2
      Width = 32
      Height = 32
      Hint = 'l'#228'dt ein oder mehrere Projekte in das Projektfenster'
      Caption = '+'
      OnClick = ProjekteinfuegenMenuItemClick
    end
    object ProjektentfernenBtn: TSpeedButton
      Left = 40
      Top = 2
      Width = 32
      Height = 32
      Hint = 'entfernt ein oder mehrere Projekte aus das Projektfenster'
      Caption = '-'
      OnClick = ProjektentfernenMenuItemClick
    end
    object ProgrammEndeBtn: TSpeedButton
      Left = 72
      Top = 2
      Width = 32
      Height = 32
      Hint = 'beendet das Programm'
      Caption = 'E'
      OnClick = ProgrammEndeClick
    end
    object ToolButton2: TToolButton
      Left = 104
      Top = 2
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object ProjektSchneidenBtn: TSpeedButton
      Left = 112
      Top = 2
      Width = 32
      Height = 32
      Hint = 'startet die Bearbeitung der markierten Projekte'
      Caption = 'Sch'
      OnClick = ProjektSchneidenMenuItemClick
    end
    object ProjekteSchneidenBtn: TSpeedButton
      Left = 144
      Top = 2
      Width = 32
      Height = 32
      Hint = 'startet die Bearbeitung aller Projekte'
      Caption = 'alle'
      OnClick = ProjekteschneidenMenuItemClick
    end
    object PauseBtn: TSpeedButton
      Left = 176
      Top = 2
      Width = 32
      Height = 32
      Hint = 'unterbricht die Bearbeitung des Projektes'
      AllowAllUp = True
      GroupIndex = 4
      Caption = 'Pa'
      Enabled = False
      OnClick = PauseMenuItemClick
    end
    object AbbrechenBtn: TSpeedButton
      Left = 208
      Top = 2
      Width = 32
      Height = 32
      Hint = 'bricht die Bearbeitung des Projektes ab'
      Caption = 'Ab'
      Enabled = False
      OnClick = AbbrechenMenuItemClick
    end
    object StoppenBtn: TSpeedButton
      Left = 240
      Top = 2
      Width = 32
      Height = 32
      Hint = 'stoppt die Bearbeitung der Projekte'
      AllowAllUp = True
      GroupIndex = 3
      Caption = 'Stop'
      Enabled = False
      OnClick = StoppenMenuItemClick
    end
    object ToolButton3: TToolButton
      Left = 272
      Top = 2
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object ProgrammschliessenBtn: TSpeedButton
      Left = 280
      Top = 2
      Width = 32
      Height = 32
      Hint = 'schlie'#223't das Programm nach Bearbeitung der Projekte'
      AllowAllUp = True
      GroupIndex = 1
      Caption = 'Pbe'
      OnClick = ProgrammschliessenMenuItemClick
    end
    object RechnerausschaltenBtn: TSpeedButton
      Left = 312
      Top = 2
      Width = 32
      Height = 32
      Hint = 'schaltet den Rechner nach Bearbeitung der Projekte aus'
      AllowAllUp = True
      GroupIndex = 2
      Caption = 'Ra'
      OnClick = RechnerausschaltenMenuItemClick
    end
    object ToolButton4: TToolButton
      Left = 344
      Top = 2
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object HilfeBtn: TSpeedButton
      Left = 352
      Top = 2
      Width = 32
      Height = 32
      Hint = #246'ffnet die Hilfedatei'
      Caption = '?'
      OnClick = Hilfe1Click
    end
    object ToolButton5: TToolButton
      Left = 0
      Top = 2
      Width = 141
      Caption = 'ToolButton5'
      ImageIndex = 2
      Wrap = True
      Style = tbsSeparator
    end
    object TestBtn1: TButton
      Left = 0
      Top = 128
      Width = 75
      Height = 32
      Caption = 'fertig'
      TabOrder = 0
      Visible = False
      OnClick = TestBtn1Click
    end
    object TestBtn2: TButton
      Left = 75
      Top = 128
      Width = 75
      Height = 32
      Caption = 'Fehler'
      TabOrder = 1
      Visible = False
      OnClick = TestBtn2Click
    end
    object Button1: TButton
      Left = 150
      Top = 128
      Width = 75
      Height = 32
      Caption = 'Button1'
      TabOrder = 2
      Visible = False
    end
  end
  object HauptfensterPanel: TPanel
    Left = 0
    Top = 37
    Width = 692
    Height = 402
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object ProtokollSplitter: TSplitter
      Left = 0
      Top = 222
      Width = 692
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      AutoSnap = False
      Color = cl3DLight
      MinSize = 60
      ParentColor = False
      OnCanResize = ProtokollSplitterCanResize
    end
    object ProtokollMemo: TMemo
      Left = 0
      Top = 227
      Width = 692
      Height = 175
      Align = alBottom
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      PopupMenu = MenuProtokollfenster
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
    object ProjektGrid: TStringGrid
      Left = 0
      Top = 0
      Width = 692
      Height = 222
      Align = alClient
      ColCount = 8
      Ctl3D = True
      DefaultColWidth = 100
      DefaultRowHeight = 16
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goThumbTracking]
      ParentCtl3D = False
      ParentShowHint = False
      PopupMenu = MenueProjektfenster
      ShowHint = True
      TabOrder = 1
      OnClick = ProjektGridClick
      OnDblClick = ProjektGridDblClick
      OnDrawCell = ProjektGridDrawCell
      OnMouseMove = ProjektGridMouseMove
      ColWidths = (
        100
        100
        100
        100
        100
        100
        100
        100)
    end
    object EigenschaftenPanel: TPanel
      Left = 0
      Top = 0
      Width = 692
      Height = 222
      Align = alClient
      TabOrder = 2
      Visible = False
      DesignSize = (
        692
        222)
      object Zieldateiname_: TLabel
        Left = 18
        Top = 32
        Width = 79
        Height = 14
        Caption = 'Zieldateiname:'
      end
      object ZieldateinameBtn: TSpeedButton
        Left = 664
        Top = 28
        Width = 17
        Height = 22
        Anchors = [akTop, akRight]
        Caption = '...'
        OnClick = EditBtnClick
      end
      object Projektdatei_: TLabel
        Left = 18
        Top = 8
        Width = 70
        Height = 14
        Caption = 'Projektdatei:'
      end
      object ProjektdateiLabel: TLabel
        Left = 194
        Top = 8
        Width = 94
        Height = 14
        Caption = 'ProjektdateiLabel'
      end
      object OKTaste: TBitBtn
        Left = 564
        Top = 178
        Width = 100
        Height = 35
        Anchors = [akTop, akRight]
        Caption = 'OK'
        ModalResult = 1
        TabOrder = 0
        OnClick = EigenschaftenBtnClick
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
        Left = 414
        Top = 178
        Width = 100
        Height = 35
        Anchors = [akTop, akRight]
        TabOrder = 1
        OnClick = EigenschaftenBtnClick
        Kind = bkCancel
      end
      object ZieldateinameEdit: TEdit
        Left = 192
        Top = 28
        Width = 471
        Height = 22
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        OnDblClick = EditBtnClick
        OnKeyPress = EditKeyPress
      end
      object EinstellungenGroupBox: TGroupBox
        Left = 4
        Top = 52
        Width = 380
        Height = 165
        Caption = 'Einstellungen'
        TabOrder = 3
        object IDDerstellenBox: TCheckBox
          Left = 7
          Top = 18
          Width = 180
          Height = 17
          Caption = 'IDD erstellen'
          TabOrder = 0
        end
        object D2VerstellenBox: TCheckBox
          Left = 7
          Top = 36
          Width = 180
          Height = 17
          Caption = 'D2V erstellen'
          TabOrder = 1
        end
        object IDXerstellenBox: TCheckBox
          Left = 7
          Top = 54
          Width = 180
          Height = 17
          Caption = 'IDX erstellen'
          TabOrder = 2
        end
        object KapitelerstellenBox: TCheckBox
          Left = 7
          Top = 72
          Width = 180
          Height = 17
          Caption = 'Kapitel erstellen'
          TabOrder = 3
        end
        object TimecodekorrigierenBox: TCheckBox
          Left = 7
          Top = 90
          Width = 180
          Height = 17
          Caption = 'Timecode korrigieren'
          TabOrder = 4
        end
        object BitratekorrigierenBox: TCheckBox
          Left = 7
          Top = 108
          Width = 180
          Height = 17
          Caption = 'Bitrate korrigieren'
          TabOrder = 5
        end
        object SchnittpunkteeinzelnBox: TCheckBox
          Left = 7
          Top = 144
          Width = 180
          Height = 17
          Caption = 'Schnitte einzeln schneiden'
          TabOrder = 6
        end
        object framegenauSchneidenBox: TCheckBox
          Left = 192
          Top = 18
          Width = 180
          Height = 17
          Caption = 'framegenau schneiden'
          TabOrder = 7
        end
        object AusgabenutzenBox: TCheckBox
          Left = 192
          Top = 36
          Width = 180
          Height = 17
          Caption = 'Nachbearbeitung'
          TabOrder = 8
        end
        object maxGOPLaengeBox: TCheckBox
          Left = 192
          Top = 54
          Width = 180
          Height = 17
          Caption = 'maximale GOP-L'#228'nge'
          TabOrder = 9
          OnClick = maxGOPLaengeBoxClick
        end
        object Bitrateim1Header: TComboBox
          Left = 192
          Top = 72
          Width = 180
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          TabOrder = 10
          OnCloseUp = Bitrateim1HeaderCloseUp
          OnSelect = Bitrateim1HeaderSelect
          Items.Strings = (
            'Bitrate nicht '#228'ndern'
            'Bitrate vom Orginal'
            'durchschnittliche Bitrate'
            'maximale Bitrate'
            'feste Bitrate')
        end
        object nurAudioBox: TCheckBox
          Left = 192
          Top = 144
          Width = 180
          Height = 17
          Caption = 'nur Audio schneiden'
          TabOrder = 11
        end
        object AspectRatio1Header: TComboBox
          Left = 192
          Top = 96
          Width = 180
          Height = 22
          Style = csDropDownList
          ItemHeight = 14
          TabOrder = 12
          OnCloseUp = AspectRatio1HeaderCloseUp
          OnSelect = AspectRatio1HeaderSelect
          Items.Strings = (
            'Aspectrato nicht '#228'ndern'
            'Aspectrato  vom Orginal'
            'Aspectrato 1/1'
            'Aspectrato 3/4'
            'Aspectrato 9/16'
            'Aspectrato 1/2,21'
            'Aspectrato nach ')
        end
        object ZusammenhaengendeSchnitteberechnenBox: TCheckBox
          Left = 7
          Top = 126
          Width = 180
          Height = 17
          Caption = 'zusammenh. Schnitte ber.'
          TabOrder = 13
        end
      end
      object ScripteGroupBox: TGroupBox
        Left = 388
        Top = 52
        Width = 299
        Height = 115
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Scripte'
        TabOrder = 4
        DesignSize = (
          299
          115)
        object AusgabedateiBtn: TSpeedButton
          Left = 274
          Top = 47
          Width = 17
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '...'
          OnClick = EditBtnClick
        end
        object EncoderdateiBtn: TSpeedButton
          Left = 274
          Top = 18
          Width = 17
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '...'
          OnClick = EditBtnClick
        end
        object OptionenEncoder_: TLabel
          Left = 6
          Top = 22
          Width = 100
          Height = 14
          AutoSize = False
          Caption = 'Encoder:'
        end
        object OptionenAusgabePr_: TLabel
          Left = 6
          Top = 52
          Width = 97
          Height = 14
          Caption = 'Nachbearbeitung:'
        end
        object EncoderdateiEdit: TEdit
          Left = 108
          Top = 18
          Width = 163
          Height = 22
          Anchors = [akLeft, akTop, akRight]
          ReadOnly = True
          TabOrder = 0
          OnDblClick = EditBtnClick
          OnKeyPress = EditKeyPress
        end
        object AusgabedateiEdit: TEdit
          Left = 108
          Top = 47
          Width = 163
          Height = 22
          Anchors = [akLeft, akTop, akRight]
          ReadOnly = True
          TabOrder = 1
          OnDblClick = EditBtnClick
          OnKeyPress = EditKeyPress
        end
      end
    end
  end
  object Hauptmenue: TMainMenu
    AutoLineReduction = maManual
    Left = 92
    Top = 328
    object Datei: TMenuItem
      Caption = '&Datei'
      OnClick = DateiClick
      object ProjekteinfuegenMenuItem: TMenuItem
        Caption = 'Projekt(e) hinzuf'#252'gen'
        OnClick = ProjekteinfuegenMenuItemClick
      end
      object ProjektentfernenMenuItem: TMenuItem
        Caption = 'Projekt(e) entfernen'
        OnClick = ProjektentfernenMenuItemClick
      end
      object Linie2: TMenuItem
        Caption = '-'
      end
      object ProgrammEnde: TMenuItem
        Caption = 'Ende'
        OnClick = ProgrammEndeClick
      end
    end
    object Aktionen: TMenuItem
      Caption = 'Aktionen'
      OnClick = AktionenClick
      object ProjektSchneidenMenuItem: TMenuItem
        Caption = 'Projekt schneiden'
        OnClick = ProjektSchneidenMenuItemClick
      end
      object ProjekteschneidenMenuItem: TMenuItem
        Caption = 'alle Projekte schneiden'
        OnClick = ProjekteschneidenMenuItemClick
      end
      object Linie1: TMenuItem
        Caption = '-'
      end
      object PauseMenuItem: TMenuItem
        Caption = 'Pause'
        OnClick = PauseMenuItemClick
      end
      object AbbrechenMenuItem: TMenuItem
        Caption = 'Abbrechen'
        OnClick = AbbrechenMenuItemClick
      end
      object StoppenMenuItem: TMenuItem
        Caption = 'Stoppen'
        OnClick = StoppenMenuItemClick
      end
    end
    object Protokoll: TMenuItem
      Caption = 'Protokoll'
      OnClick = ProtokollClick
      object ProtokollspeichernMenuItem: TMenuItem
        Caption = 'Protokoll speichern'
        OnClick = ProtokollspeichernMenuItemClick
      end
      object Trennlinie2: TMenuItem
        Caption = '-'
      end
      object ProtokolllevelMenuItem: TMenuItem
        Caption = 'Protokolllevel'
        RadioItem = True
        object Protokolllevel0MenuItem: TMenuItem
          Caption = 'Protokolllevel - 0'
          GroupIndex = 1
          RadioItem = True
          OnClick = Protokolllevel0MenuItemClick
        end
        object Protokolllevel1MenuItem: TMenuItem
          Caption = 'Protokolllevel - 1'
          GroupIndex = 1
          RadioItem = True
          OnClick = Protokolllevel1MenuItemClick
        end
        object Protokolllevel2MenuItem: TMenuItem
          Caption = 'Protokolllevel - 2'
          GroupIndex = 1
          RadioItem = True
          OnClick = Protokolllevel2MenuItemClick
        end
        object Protokolllevel3MenuItem: TMenuItem
          Caption = 'Protokolllevel - 3'
          GroupIndex = 1
          RadioItem = True
          OnClick = Protokolllevel3MenuItemClick
        end
        object Protokolllevel4MenuItem: TMenuItem
          Caption = 'Protokolllevel - 4'
          GroupIndex = 1
          RadioItem = True
          OnClick = Protokolllevel4MenuItemClick
        end
      end
      object Trennlinie1: TMenuItem
        Caption = '-'
      end
      object ProtokollEinMenuItem: TMenuItem
        Caption = 'Protokoll schreiben'
        OnClick = ProtokollEinMenuItemClick
      end
    end
    object Optionen: TMenuItem
      Caption = 'Optionen'
      OnClick = OptionenClick
      object ProgrammschliessenMenuItem: TMenuItem
        Caption = 'Programm schliessen'
        OnClick = ProgrammschliessenMenuItemClick
      end
      object RechnerausschaltenMenuItem: TMenuItem
        Caption = 'Rechner ausschalten'
        OnClick = RechnerausschaltenMenuItemClick
      end
    end
    object Hilfe: TMenuItem
      Caption = 'Hilfe'
      OnClick = HilfeClick
      object Hilfe1: TMenuItem
        Caption = 'Hilfe'
        OnClick = Hilfe1Click
      end
      object Lizenz: TMenuItem
        Caption = 'Lizenz'
        OnClick = LizenzClick
      end
      object Ueber: TMenuItem
        Caption = #220'ber...'
        OnClick = UeberClick
      end
    end
  end
  object MenueProjektfenster: TPopupMenu
    OnPopup = MenueProjektfensterPopup
    Left = 134
    Top = 326
    object ProjekteinfuegenMenuItem1: TMenuItem
      Caption = 'Projekt(e) hinzuf'#252'gen'
      OnClick = ProjekteinfuegenMenuItemClick
    end
    object ProjektentfernenMenuItem1: TMenuItem
      Caption = 'Projekt(e) entfernen'
      OnClick = ProjektentfernenMenuItemClick
    end
    object ProjekteneueinlesenMenuItem: TMenuItem
      Caption = 'Projekt(e) neu einlesen'
      Visible = False
      OnClick = ProjekteneueinlesenMenuItemClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ZielverzeichniswaehlenMenuItem: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Benutzerdefiniertes Zielverzeichnis'
      OnClick = ZielverzeichniswaehlenMenuItemClick
    end
    object BenutzerZiel: TMenuItem
      AutoHotkeys = maAutomatic
      Caption = 'Papierkorb  :-)'
      Enabled = False
      OnClick = BenutzerZielClick
    end
  end
  object MenuProtokollfenster: TPopupMenu
    OnPopup = MenueProjektfensterPopup
    Left = 178
    Top = 326
    object ProtokollspeichernMenuItem1: TMenuItem
      Caption = 'Protokoll speichern'
      OnClick = ProtokollspeichernMenuItemClick
    end
    object MenuItem4: TMenuItem
      Caption = '-'
    end
    object ProtokollKopierenMenuItem: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Kopieren       Strg-c'
      OnClick = ProtokollKopierenMenuItemClick
    end
    object ProtokollLoeschenMenuItem: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = ProtokollLoeschenMenuItemClick
    end
  end
end
