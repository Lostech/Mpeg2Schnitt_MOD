object MpegEdit: TMpegEdit
  Left = 452
  Top = 150
  ActiveControl = Pos0Panel
  Anchors = [akLeft, akBottom]
  AutoScroll = False
  ClientHeight = 526
  ClientWidth = 792
  Color = clBtnFace
  Constraints.MinHeight = 570
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = Hauptmenue
  OldCreateOrder = True
  Scaled = False
  ShowHint = True
  SnapBuffer = 0
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    792
    526)
  PixelsPerInch = 96
  TextHeight = 14
  object VideoImage: TImage
    Left = 38
    Top = 18
    Width = 105
    Height = 105
    Stretch = True
  end
  object StandbildPositionZeit: TLabel
    Left = 19
    Top = 175
    Width = 80
    Height = 17
    Hint = 'aktuelle Videoposition'
    Anchors = []
    AutoSize = False
    Caption = '00:00:00:00'
    OnDblClick = StandbildPositionZeitDblClick
  end
  object StandbildPositionFrame: TLabel
    Left = 99
    Top = 175
    Width = 47
    Height = 17
    Hint = 'aktuelle Bildnummer'
    Alignment = taRightJustify
    Anchors = []
    AutoSize = False
    Caption = '0'
    OnDblClick = StandbildPositionZeitDblClick
  end
  object Schieberegler: TTrackBar
    Left = 30
    Top = 411
    Width = 749
    Height = 28
    Anchors = [akLeft, akRight, akBottom]
    LineSize = 0
    Max = 1000
    PageSize = 0
    Frequency = 10
    TabOrder = 2
    TabStop = False
    TickStyle = tsNone
    OnEnter = SchiebereglerEnter
  end
  object Audioplayer: TMediaPlayer
    Left = 56
    Top = 74
    Width = 29
    Height = 30
    VisibleButtons = [btPlay]
    AutoRewind = False
    TabOrder = 0
    TabStop = False
  end
  object Listen: TPageControl
    Left = 578
    Top = 0
    Width = 215
    Height = 373
    ActivePage = KapitellistenTab
    Anchors = [akLeft, akTop, akBottom]
    MultiLine = True
    TabOrder = 3
    TabPosition = tpBottom
    TabStop = False
    OnMouseDown = ListenMouseDown
    OnMouseMove = ListenMouseMove
    OnMouseUp = ListenMouseUp
    object SchnittlistenTab: TTabSheet
      Caption = 'Schnitte'
      object Schnittliste: TListBox
        Left = 0
        Top = 0
        Width = 207
        Height = 327
        TabStop = False
        Style = lbOwnerDrawFixed
        Align = alClient
        ItemHeight = 16
        MultiSelect = True
        PopupMenu = SchnittlisteMenue
        TabOrder = 0
        OnClick = SchnittListeClick
        OnDblClick = SchnittListeDblClick
        OnDragDrop = SchnittListeDragDrop
        OnDragOver = SchnittListeDragOver
        OnDrawItem = SchnittlisteDrawItem
        OnEndDrag = SchnittListeEndDrag
        OnEnter = SchnittlisteEnter
        OnExit = SchnittlisteExit
        OnMouseDown = SchnittlisteMouseDown
        OnMouseUp = SchnittListeMouseUp
        OnStartDrag = SchnittListeStartDrag
      end
    end
    object KapitellistenTab: TTabSheet
      Caption = 'Kapitel'
      ImageIndex = 2
      DesignSize = (
        207
        327)
      object KapitelListeGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 207
        Height = 327
        TabStop = False
        Align = alClient
        ColCount = 4
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing]
        PopupMenu = KapitellistePopupMenu
        TabOrder = 0
        OnClick = KapitelListeGridClick
        OnDblClick = KapitelListeGridDblClick
        OnDragDrop = KapitelListeGridDragDrop
        OnDragOver = KapitelListeGridDragOver
        OnDrawCell = KapitelListeGridDrawCell
        OnEndDrag = KapitelListeGridEndDrag
        OnEnter = KapitelListeGridEnter
        OnExit = KapitelListeGridExit
        OnKeyDown = KapitelListeGridKeyDown
        OnKeyUp = KapitelListeGridKeyUp
        OnStartDrag = KapitelListeGridStartDrag
        ColWidths = (
          64
          64
          107
          64)
      end
      object KapitelnameEdit: TEdit
        Left = 0
        Top = 306
        Width = 207
        Height = 21
        Anchors = [akLeft, akRight, akBottom]
        AutoSize = False
        TabOrder = 1
        Visible = False
        OnEnter = KapitelnameEditEnter
        OnExit = KapitelnameEditExit
        OnKeyPress = KapitelnameEditKeyPress
      end
    end
    object MarkenlistenTab: TTabSheet
      Caption = 'Marken'
      ImageIndex = 1
      object MarkenListe: TMemo
        Left = 0
        Top = 0
        Width = 207
        Height = 327
        TabStop = False
        Align = alClient
        PopupMenu = MarkenListePopupMenu
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
        OnChange = MarkenListeChange
        OnClick = MarkenListeClick
        OnDblClick = MarkenListeDblClick
        OnEnter = MarkenListeEnter
        OnExit = MarkenListeExit
      end
    end
    object InformationenTab: TTabSheet
      Caption = 'Info'
      ImageIndex = 3
      object Informationen: TMemo
        Left = 0
        Top = 0
        Width = 207
        Height = 327
        TabStop = False
        Align = alClient
        Lines.Strings = (
          '')
        PopupMenu = InfoPopupMenu
        ScrollBars = ssVertical
        TabOrder = 0
        WantReturns = False
        WordWrap = False
        OnEnter = InformationenEnter
        OnExit = InformationenExit
      end
    end
    object DateienTab: TTabSheet
      Caption = 'Dateien'
      ImageIndex = 4
    end
  end
  object SymbolleistePanel: TPanel
    Left = 94
    Top = 208
    Width = 105
    Height = 38
    Anchors = [akLeft, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    PopupMenu = AllgemeinPopupMenu
    TabOrder = 4
    Visible = False
    object ProjektNeuBtn: TSpeedButton
      Left = 4
      Top = 3
      Width = 32
      Height = 32
      Hint = 'neues Projekt'
      AllowAllUp = True
      Caption = 'N'
      OnClick = ProjektNeuClick
    end
    object ProjektLadenBtn: TSpeedButton
      Left = 36
      Top = 3
      Width = 32
      Height = 32
      Hint = 'Projekt '#246'ffnen'
      AllowAllUp = True
      Caption = 'O'
      OnClick = ProjektLadenClick
    end
    object ProjektSpeichernBtn: TSpeedButton
      Left = 68
      Top = 3
      Width = 32
      Height = 32
      Hint = 'Projekt speichern'
      AllowAllUp = True
      Caption = 'S'
      Enabled = False
      OnClick = ProjektspeichernClick
    end
  end
  object Pos0Panel: TPanel
    Left = 0
    Top = 413
    Width = 18
    Height = 18
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    TabOrder = 7
    DesignSize = (
      18
      18)
    object Pos0Btn: TSpeedButton
      Left = 0
      Top = 0
      Width = 18
      Height = 18
      Hint = 'Sprung zum Anfang'
      Anchors = [akLeft, akBottom]
      Caption = '|<'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = Pos0BtnClick
    end
  end
  object EndePanel: TPanel
    Left = 774
    Top = 413
    Width = 18
    Height = 18
    Anchors = [akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 8
    DesignSize = (
      18
      18)
    object EndeBtn: TSpeedButton
      Left = 0
      Top = 0
      Width = 18
      Height = 18
      Hint = 'Sprung zum Ende'
      Anchors = [akLeft, akBottom]
      Caption = '>|'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = EndeBtnClick
    end
  end
  object AudiooffseteinPanel: TPanel
    Left = 576
    Top = 394
    Width = 215
    Height = 17
    Hint = 'Audiooffsetfenster einblenden'
    Anchors = [akRight, akBottom]
    BevelOuter = bvLowered
    TabOrder = 9
    object Audiooffsetein_: TLabel
      Left = 1
      Top = 1
      Width = 213
      Height = 15
      Align = alClient
      Alignment = taCenter
      Caption = 'Audiooffset'
      OnClick = Audiooffsetein_Click
      OnMouseEnter = Audiooffsetein_MouseEnter
      OnMouseLeave = Audiooffsetein_MouseLeave
    end
  end
  object DateifenstereinPanel: TPanel
    Left = 0
    Top = 394
    Width = 575
    Height = 17
    Hint = 'Dateienfenster einblenden'
    Anchors = [akLeft, akBottom]
    BevelOuter = bvLowered
    TabOrder = 10
    object Dateifensterein_: TLabel
      Left = 1
      Top = 1
      Width = 573
      Height = 15
      Align = alClient
      Alignment = taCenter
      Caption = 'Dateifenster'
      OnClick = Dateifensterein_Click
      OnMouseEnter = Dateifensterein_MouseEnter
      OnMouseLeave = Dateifensterein_MouseLeave
    end
  end
  object AudioSkewPanel: TPanel
    Left = 580
    Top = 206
    Width = 214
    Height = 110
    Anchors = [akLeft, akBottom]
    TabOrder = 5
    Visible = False
    OnClick = AudioSkewPanelClick
    OnDblClick = AudiooffsetfensterkleinBtnClick
    DesignSize = (
      214
      110)
    object AS10th_: TLabel
      Left = 146
      Top = 23
      Width = 47
      Height = 17
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = '0'
      OnDblClick = AudiooffsetfensterkleinBtnClick
    end
    object AS1000th_: TLabel
      Left = 146
      Top = 41
      Width = 47
      Height = 17
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = '0'
      OnDblClick = AudiooffsetfensterkleinBtnClick
    end
    object AS1000thms_: TLabel
      Left = 194
      Top = 41
      Width = 19
      Height = 17
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'ms'
      OnDblClick = AudiooffsetfensterkleinBtnClick
    end
    object AS10thms_: TLabel
      Left = 194
      Top = 23
      Width = 19
      Height = 17
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'ms'
      OnDblClick = AudiooffsetfensterkleinBtnClick
    end
    object Audiooffset_: TLabel
      Left = 2
      Top = 87
      Width = 79
      Height = 17
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = 'Audiooffset:'
      OnDblClick = AudiooffsetfensterkleinBtnClick
    end
    object AudioOffsetms_: TLabel
      Left = 156
      Top = 87
      Width = 53
      Height = 17
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'ms'
      OnDblClick = AudiooffsetfensterkleinBtnClick
    end
    object AudiooffsetfensterausBtn: TSpeedButton
      Left = 191
      Top = 4
      Width = 17
      Height = 17
      Hint = 'Audiooffsetfenster ausblenden'
      Anchors = [akTop, akRight]
      Caption = '---'
      Spacing = -1
      OnClick = AudiooffsetfensterausBtnClick
    end
    object AS1000th: TTrackBar
      Left = 3
      Top = 39
      Width = 150
      Height = 30
      Hint = 'Audiooffset in Millisekundenschritten '#228'ndern'
      Anchors = [akLeft, akRight, akBottom]
      Max = 50
      Min = -50
      PageSize = 10
      Frequency = 10
      TabOrder = 1
      OnChange = ASChange
    end
    object AS10th: TTrackBar
      Left = 3
      Top = 11
      Width = 150
      Height = 30
      Hint = 'Audiooffset in 0,1 Sekundenschritten '#228'ndern'
      Anchors = [akLeft, akRight, akBottom]
      Max = 50
      Min = -50
      PageSize = 10
      Frequency = 10
      TabOrder = 0
      TickMarks = tmTopLeft
      OnChange = ASChange
    end
    object GrobPanel: TPanel
      Left = 2
      Top = 2
      Width = 150
      Height = 17
      Anchors = [akLeft, akRight, akBottom]
      BevelOuter = bvNone
      TabOrder = 2
      OnDblClick = AudiooffsetfensterkleinBtnClick
      object Grob1: TLabel
        Left = 0
        Top = 0
        Width = 32
        Height = 17
        Align = alLeft
        Caption = '-5000'
        Transparent = True
        OnDblClick = AudiooffsetfensterkleinBtnClick
      end
      object Grob2: TLabel
        Left = 114
        Top = 0
        Width = 36
        Height = 17
        Align = alRight
        Caption = '+5000'
        Transparent = True
        OnDblClick = AudiooffsetfensterkleinBtnClick
      end
    end
    object FeinPanel: TPanel
      Left = 2
      Top = 63
      Width = 150
      Height = 17
      Anchors = [akLeft, akRight, akBottom]
      BevelOuter = bvNone
      TabOrder = 3
      OnDblClick = AudiooffsetfensterkleinBtnClick
      object Fein1: TLabel
        Left = 0
        Top = 0
        Width = 18
        Height = 17
        Align = alLeft
        Caption = '-50'
        Transparent = True
        OnDblClick = AudiooffsetfensterkleinBtnClick
      end
      object Fein2: TLabel
        Left = 128
        Top = 0
        Width = 22
        Height = 17
        Align = alRight
        Caption = '+50'
        Transparent = True
        OnDblClick = AudiooffsetfensterkleinBtnClick
      end
    end
    object AudioOffsetEdit: TEdit
      Left = 84
      Top = 85
      Width = 66
      Height = 21
      Hint = 'Offset der aktuellen Audiodatei in Millisekunden'
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = False
      TabOrder = 4
      OnEnter = AudioOffsetEditEnter
      OnExit = AudioOffsetEditExit
      OnKeyPress = AudioOffsetEditKeyPress
    end
  end
  object DateienfensterausPanel: TPanel
    Left = 0
    Top = 305
    Width = 575
    Height = 97
    TabOrder = 11
    DesignSize = (
      575
      97)
    object Dateienfensteraus_: TLabel
      Left = 1
      Top = 1
      Width = 573
      Height = 16
      Align = alTop
      AutoSize = False
      Caption = 'Dateien:'
      PopupMenu = AllgemeinPopupMenu
      OnClick = DateienfensterausBtnClick
    end
    object DateienfensterausBtn: TSpeedButton
      Left = 554
      Top = 2
      Width = 17
      Height = 14
      Hint = 'Dateienfenster ausblenden'
      Anchors = [akTop, akRight]
      Caption = '---'
      Spacing = -1
      OnClick = DateienfensterausBtnClick
    end
    object Dateien: TTreeView
      Left = 1
      Top = 17
      Width = 573
      Height = 79
      Align = alClient
      DragMode = dmAutomatic
      HideSelection = False
      Indent = 19
      MultiSelectStyle = []
      PopupMenu = DateienMenue
      TabOrder = 0
      TabStop = False
      OnDblClick = DateienClick
      OnDragDrop = DateienDragDrop
      OnDragOver = DateienDragOver
      OnEdited = DateienEdited
      OnEditing = DateienEditing
      OnEndDrag = DateienEndDrag
      OnEnter = DateienEnter
      OnExit = DateienExit
      OnKeyDown = DateienKeyDown
      OnStartDrag = DateienStartDrag
    end
  end
  object Anzeige: TPanel
    Left = 0
    Top = 263
    Width = 575
    Height = 38
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    PopupMenu = AllgemeinPopupMenu
    TabOrder = 1
    OnClick = AnzeigeClick
    OnDblClick = ProjektLadenClick
    DesignSize = (
      575
      38)
    object aktuellerBildtyp: TLabel
      Left = 442
      Top = 3
      Width = 39
      Height = 17
      Hint = 'aktueller Bildtyp'
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'X'
      OnDblClick = ProjektLadenClick
    end
    object Videoposition: TLabel
      Left = 315
      Top = 3
      Width = 80
      Height = 17
      Hint = 'aktuelle Videoposition'
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = '00:00:00:00'
      OnDblClick = ProjektLadenClick
    end
    object Audioposition: TLabel
      Left = 315
      Top = 17
      Width = 80
      Height = 17
      Hint = 'aktuelle Audioposition'
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = '00:00:00:000'
      OnDblClick = ProjektLadenClick
    end
    object Videolaenge: TLabel
      Left = 494
      Top = 3
      Width = 80
      Height = 17
      Hint = 'gesamte Videol'#228'nge'
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = '00:00:00:00'
      OnDblClick = ProjektLadenClick
    end
    object Audiolaenge: TLabel
      Left = 494
      Top = 17
      Width = 80
      Height = 17
      Hint = 'gesamte Audiol'#228'nge'
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = '00:00:00:000'
      OnDblClick = ProjektLadenClick
    end
    object Videodatei: TLabel
      Left = 58
      Top = 3
      Width = 255
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = '???'
      OnDblClick = ProjektLadenClick
    end
    object Audiodatei: TLabel
      Left = 58
      Top = 17
      Width = 255
      Height = 14
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = '???'
      OnDblClick = ProjektLadenClick
    end
    object BildNr: TLabel
      Left = 395
      Top = 3
      Width = 47
      Height = 17
      Hint = 'aktuelle Bildnummer'
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = '0'
      OnDblClick = ProjektLadenClick
    end
    object aktVideoknotenNr_: TLabel
      Left = 38
      Top = 3
      Width = 17
      Height = 17
      Hint = 'Videodateinummer'
      Alignment = taRightJustify
      AutoSize = False
      Caption = '00'
      OnDblClick = ProjektLadenClick
    end
    object aktAudioknotenNr_: TLabel
      Left = 38
      Top = 17
      Width = 17
      Height = 17
      Hint = 'Audiodateinummer'
      Alignment = taRightJustify
      AutoSize = False
      Caption = '00'
      OnDblClick = ProjektLadenClick
    end
    object Audiooffsetms: TLabel
      Left = 395
      Top = 17
      Width = 47
      Height = 17
      Hint = 'Audio Offset in Millisekunden'
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'X'
      OnDblClick = ProjektLadenClick
    end
    object AudiooffsetBilder: TLabel
      Left = 442
      Top = 17
      Width = 39
      Height = 17
      Hint = 'Audio Offset in Bilder'
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = 'X'
      OnDblClick = ProjektLadenClick
    end
    object BtnVideoAdd: TSpeedButton
      Left = 3
      Top = 3
      Width = 35
      Height = 32
      Hint = 'Video/Audio '#246'ffnen'
      AllowAllUp = True
      Anchors = [akLeft, akBottom]
      Caption = 'V/A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      NumGlyphs = 2
      ParentFont = False
      PopupMenu = VideoAudioPopupMenu
      OnClick = Video_oeffnenClick
    end
  end
  object SchiebereglermittePanel: TPanel
    Left = 388
    Top = 433
    Width = 15
    Height = 5
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    TabOrder = 12
    object SchiebereglermitteImage: TImage
      Left = 0
      Top = 0
      Width = 15
      Height = 5
      Picture.Data = {
        07544269746D617086040000424D860400000000000036040000280000000F00
        0000050000000100080000000000500000000000000000000000000100000000
        000000000000000080000080000000808000800000008000800080800000C0C0
        C000C0DCC000F0CAA6000020400000206000002080000020A0000020C0000020
        E00000400000004020000040400000406000004080000040A0000040C0000040
        E00000600000006020000060400000606000006080000060A0000060C0000060
        E00000800000008020000080400000806000008080000080A0000080C0000080
        E00000A0000000A0200000A0400000A0600000A0800000A0A00000A0C00000A0
        E00000C0000000C0200000C0400000C0600000C0800000C0A00000C0C00000C0
        E00000E0000000E0200000E0400000E0600000E0800000E0A00000E0C00000E0
        E00040000000400020004000400040006000400080004000A0004000C0004000
        E00040200000402020004020400040206000402080004020A0004020C0004020
        E00040400000404020004040400040406000404080004040A0004040C0004040
        E00040600000406020004060400040606000406080004060A0004060C0004060
        E00040800000408020004080400040806000408080004080A0004080C0004080
        E00040A0000040A0200040A0400040A0600040A0800040A0A00040A0C00040A0
        E00040C0000040C0200040C0400040C0600040C0800040C0A00040C0C00040C0
        E00040E0000040E0200040E0400040E0600040E0800040E0A00040E0C00040E0
        E00080000000800020008000400080006000800080008000A0008000C0008000
        E00080200000802020008020400080206000802080008020A0008020C0008020
        E00080400000804020008040400080406000804080008040A0008040C0008040
        E00080600000806020008060400080606000806080008060A0008060C0008060
        E00080800000808020008080400080806000808080008080A0008080C0008080
        E00080A0000080A0200080A0400080A0600080A0800080A0A00080A0C00080A0
        E00080C0000080C0200080C0400080C0600080C0800080C0A00080C0C00080C0
        E00080E0000080E0200080E0400080E0600080E0800080E0A00080E0C00080E0
        E000C0000000C0002000C0004000C0006000C0008000C000A000C000C000C000
        E000C0200000C0202000C0204000C0206000C0208000C020A000C020C000C020
        E000C0400000C0402000C0404000C0406000C0408000C040A000C040C000C040
        E000C0600000C0602000C0604000C0606000C0608000C060A000C060C000C060
        E000C0800000C0802000C0804000C0806000C0808000C080A000C080C000C080
        E000C0A00000C0A02000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0
        E000C0C00000C0C02000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0
        A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
        FF00070707000000000000000000070707000707070700000000000000070707
        0700070707070700000000000707070707000707070707070000000707070707
        070007070707070707000707070707070700}
      Transparent = True
    end
  end
  object TastenGrundPanel: TPanel
    Left = 0
    Top = 439
    Width = 792
    Height = 87
    Align = alBottom
    BevelOuter = bvNone
    PopupMenu = AllgemeinPopupMenu
    TabOrder = 13
  end
  object ListenTrennXPanel: TPanel
    Left = 500
    Top = 0
    Width = 3
    Height = 461
    TabOrder = 15
    Visible = False
  end
  object ListenTrennPanel: TPanel
    Left = 564
    Top = 0
    Width = 3
    Height = 461
    Cursor = crHSplit
    TabOrder = 14
    OnMouseDown = ListenTrennPanelMouseDown
    OnMouseMove = ListenverschiebePanelMouseMove
    OnMouseUp = ListenverschiebePanelMouseUp
  end
  object DateienTrennPanel: TPanel
    Left = 0
    Top = 354
    Width = 575
    Height = 3
    Cursor = crVSplit
    TabOrder = 16
    OnMouseDown = DateienTrennPanelMouseDown
    OnMouseMove = DateienTrennPanelMouseMove
    OnMouseUp = DateienTrennPanelMouseUp
  end
  object DateienTrennXPanel: TPanel
    Left = 0
    Top = 346
    Width = 575
    Height = 3
    TabOrder = 17
    Visible = False
  end
  object TastenPanel: TPanel
    Left = 0
    Top = 439
    Width = 792
    Height = 87
    Anchors = [akLeft, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    PopupMenu = AllgemeinPopupMenu
    TabOrder = 18
    OnDblClick = ProjektLadenClick
    DesignSize = (
      792
      87)
    object Play: TSpeedButton
      Left = 7
      Top = 6
      Width = 55
      Height = 55
      Hint = 'Wiedergabe/Pause'
      AllowAllUp = True
      GroupIndex = 50
      Caption = 'Play'
      Layout = blGlyphTop
      NumGlyphs = 4
      OnClick = PlayClick
    end
    object Spieleab: TSpeedButton
      Left = 62
      Top = 6
      Width = 40
      Height = 37
      Hint = '2 Sekunden Wiedergabe ab der aktuellen Position'
      AllowAllUp = True
      GroupIndex = 51
      Caption = '|-->'
      Layout = blGlyphTop
      NumGlyphs = 2
      OnClick = SpieleabClick
    end
    object Spielebis: TSpeedButton
      Left = 62
      Top = 44
      Width = 40
      Height = 37
      Hint = '2 Sekunden Wiedergabe bis zur aktuellen Position'
      AllowAllUp = True
      GroupIndex = 52
      Caption = '-->|'
      Layout = blGlyphTop
      NumGlyphs = 2
      OnClick = SpielebisClick
    end
    object VorherigesI: TSpeedButton
      Left = 112
      Top = 6
      Width = 45
      Height = 25
      Hint = 'Sprung zum vorherigen I-Frame (n'#228'chstm'#246'gliche IN-Position)'
      AllowAllUp = True
      Caption = '<--'
      NumGlyphs = 2
      OnClick = VorherigesIClick
    end
    object NaechstesI: TSpeedButton
      Left = 157
      Top = 6
      Width = 45
      Height = 25
      Hint = 'Sprung zum n'#228'chsten I-Frame (n'#228'chstm'#246'gliche IN-Position)'
      AllowAllUp = True
      Caption = '-->'
      NumGlyphs = 2
      OnClick = NaechstesIClick
    end
    object CutIn: TSpeedButton
      Left = 207
      Top = 6
      Width = 59
      Height = 25
      Hint = 'IN-Position f'#252'r Schnitt festlegen'
      AllowAllUp = True
      Caption = 'IN'
      Enabled = False
      NumGlyphs = 2
      OnClick = CutInClick
    end
    object GehezuIn: TSpeedButton
      Left = 270
      Top = 6
      Width = 117
      Height = 25
      Hint = 'Sprung zur aktuellen IN-Position'
      AllowAllUp = True
      Caption = '-->'
      Margin = 2
      NumGlyphs = 2
      OnClick = GehezuInClick
    end
    object VorherigesP: TSpeedButton
      Left = 112
      Top = 31
      Width = 45
      Height = 25
      Hint = 
        'Sprung zum vorherigen P- oder I-Frame (n'#228'chstm'#246'gliche OUT-Positi' +
        'on)'
      AllowAllUp = True
      Caption = '<--'
      NumGlyphs = 2
      OnClick = VorherigesPClick
    end
    object NaechstesP: TSpeedButton
      Left = 157
      Top = 31
      Width = 45
      Height = 25
      Hint = 
        'Sprung zum n'#228'chsten P- oder I-Frame (n'#228'chstm'#246'gliche OUT-Position' +
        ')'
      AllowAllUp = True
      Caption = '-->'
      NumGlyphs = 2
      OnClick = NaechstesPClick
    end
    object CutOut: TSpeedButton
      Left = 207
      Top = 31
      Width = 59
      Height = 25
      Hint = 'OUT-Position f'#252'r Schnitt festlegen'
      AllowAllUp = True
      Caption = 'OUT'
      Enabled = False
      NumGlyphs = 2
      OnClick = CutOutClick
    end
    object GehezuOut: TSpeedButton
      Left = 270
      Top = 31
      Width = 117
      Height = 25
      Hint = 'Sprung zur aktuellen OUT-Position'
      AllowAllUp = True
      Caption = '-->'
      Margin = 2
      NumGlyphs = 2
      OnClick = GehezuOutClick
    end
    object Schnittuebernehmen: TSpeedButton
      Left = 207
      Top = 56
      Width = 180
      Height = 25
      Hint = 
        'Aktuellen Schnitt in die Schnittliste '#252'bernehmen (Optionen mit r' +
        'echter Maustaste)'
      AllowAllUp = True
      Caption = '      EINF'#220'GEN:'
      Enabled = False
      Margin = 2
      NumGlyphs = 2
      PopupMenu = DummyPopupMenu
      OnClick = SchnittpunkteinfuegenClick
      OnMouseUp = SchnittuebernehmenMouseUp
    end
    object SchrittVor: TSpeedButton
      Left = 157
      Top = 56
      Width = 45
      Height = 25
      Hint = 'Ein Einzelbild weiter'
      AllowAllUp = True
      Caption = '-->'
      NumGlyphs = 2
      OnClick = SchrittVorClick
    end
    object SchrittZurueck: TSpeedButton
      Left = 112
      Top = 56
      Width = 45
      Height = 25
      Hint = 'Ein Einzelbild zur'#252'ck'
      AllowAllUp = True
      Caption = '<--'
      NumGlyphs = 2
      OnClick = SchrittZurueckClick
    end
    object Kapitel: TSpeedButton
      Left = 400
      Top = 6
      Width = 48
      Height = 37
      Hint = 'Kapitel an aktueller Position setzen'
      AllowAllUp = True
      Caption = 'Kapitel'
      Enabled = False
      PopupMenu = KapiteltastenMenue
      OnClick = KapitelClick
    end
    object Marke: TSpeedButton
      Left = 400
      Top = 43
      Width = 48
      Height = 37
      Hint = 'Marke an aktueller Position setzen'
      AllowAllUp = True
      Caption = 'Marke'
      PopupMenu = MarkentastePopupMenu
      OnClick = MarkeClick
    end
    object Video_: TLabel
      Left = 462
      Top = 6
      Width = 38
      Height = 14
      Anchors = [akTop, akRight]
      Caption = 'Video:'
    end
    object VideoGr: TLabel
      Left = 558
      Top = 6
      Width = 51
      Height = 14
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = '0,00 MB'
      ParentShowHint = False
      ShowHint = True
    end
    object AudioGr: TLabel
      Left = 558
      Top = 25
      Width = 51
      Height = 14
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = '0,00 MB'
    end
    object GesamtGr: TLabel
      Left = 558
      Top = 45
      Width = 51
      Height = 14
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = '0,00 MB'
    end
    object Gesamt_: TLabel
      Left = 462
      Top = 45
      Width = 49
      Height = 14
      Anchors = [akTop, akRight]
      Caption = 'Gesamt:'
    end
    object Audio_: TLabel
      Left = 462
      Top = 25
      Width = 40
      Height = 14
      Anchors = [akTop, akRight]
      Caption = 'Audio:'
    end
    object Gesamtzeit_: TLabel
      Left = 462
      Top = 65
      Width = 41
      Height = 14
      Anchors = [akTop, akRight]
      Caption = 'L'#228'nge:'
    end
    object GesamtZeit: TLabel
      Left = 532
      Top = 65
      Width = 76
      Height = 14
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = '00:00:00:00'
    end
    object Reserve: TSpeedButton
      Left = 517
      Top = 20
      Width = 23
      Height = 22
      Caption = 'R'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -10
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object Vorschau: TSpeedButton
      Left = 621
      Top = 6
      Width = 64
      Height = 75
      Hint = 'Vorschau des gew'#228'hlten Schnitts'
      AllowAllUp = True
      Anchors = [akTop, akRight]
      GroupIndex = 60
      Caption = 'Vorschau'
      Enabled = False
      Layout = blGlyphTop
      NumGlyphs = 4
      PopupMenu = Vorschaumenue
      OnClick = VorschauClick
    end
    object Schnittpunkteeinzelnschneiden: TSpeedButton
      Left = 695
      Top = 6
      Width = 25
      Height = 25
      Hint = 'Jeden Schnitt separat in einer eigenen Datei speichern'
      AllowAllUp = True
      Anchors = [akTop, akRight]
      GroupIndex = 100
      Caption = 'E'
    end
    object MarkierteSchnittpunkte: TSpeedButton
      Left = 695
      Top = 31
      Width = 25
      Height = 25
      Hint = 'Nur die in der Schnittliste markierten Schnitte '#252'bernehmen'
      AllowAllUp = True
      Anchors = [akTop, akRight]
      GroupIndex = 101
      Caption = 'M'
      OnClick = SchnittoptionenClick
    end
    object nurAudiospeichern: TSpeedButton
      Left = 695
      Top = 56
      Width = 25
      Height = 25
      Hint = 'Nur die Audiospur(en) '#252'bernehmen'
      AllowAllUp = True
      Anchors = [akTop, akRight]
      GroupIndex = 102
      Caption = 'A'
      OnClick = SchnittoptionenClick
    end
    object Schneiden: TSpeedButton
      Left = 723
      Top = 6
      Width = 64
      Height = 75
      Hint = 'Video/Audio-Dateien laut Schnittliste erzeugen'
      AllowAllUp = True
      Anchors = [akTop, akRight]
      Caption = 'Cut'
      Enabled = False
      NumGlyphs = 2
      PopupMenu = CutPopupMenu
      OnClick = SchneidenClick
    end
    object TempoPlusBtn: TSpeedButton
      Left = 47
      Top = 62
      Width = 15
      Height = 19
      Hint = 'Abspielgeschwindigkeit erh'#246'hen'
      Caption = '+'
      OnClick = TempoPlusBtnClick
    end
    object TempoMinusBtn: TSpeedButton
      Left = 7
      Top = 62
      Width = 15
      Height = 19
      Hint = 'Abspielgeschwindigkeit verringern'
      Caption = '-'
      OnClick = TempoMinusBtnClick
    end
    object Tempoanzeige_: TLabel
      Left = 22
      Top = 64
      Width = 25
      Height = 13
      Hint = 
        'Aktuelle Wiedergabegeschwindigkeit (hier klicken f'#252'r Normalgesch' +
        'windigkeit)'
      Alignment = taCenter
      AutoSize = False
      Caption = '1'
      OnClick = Tempoanzeige_Click
    end
    object TastenTrenner1Panel: TPanel
      Left = 106
      Top = 1
      Width = 2
      Height = 85
      BevelOuter = bvLowered
      TabOrder = 0
    end
    object TastenTrenner2Panel: TPanel
      Left = 393
      Top = 1
      Width = 2
      Height = 85
      BevelOuter = bvLowered
      TabOrder = 1
    end
    object TastenTrenner3Panel: TPanel
      Left = 453
      Top = 1
      Width = 2
      Height = 85
      BevelOuter = bvLowered
      TabOrder = 2
    end
    object TastenTrenner4Panel: TPanel
      Left = 614
      Top = 1
      Width = 2
      Height = 85
      Anchors = [akTop, akRight]
      BevelOuter = bvLowered
      TabOrder = 3
    end
  end
  object SchnittuebernehmenPanel: TPanel
    Left = 263
    Top = 378
    Width = 118
    Height = 117
    Anchors = [akLeft, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    Visible = False
    object SchnitteinfuegenvorMarkierungBtn: TSpeedButton
      Left = 6
      Top = 4
      Width = 105
      Height = 25
      Hint = 
        'Aktuellen Schnitt vor der Markierung in die Schnittliste einf'#252'ge' +
        'n'
      Caption = 'vorher'
      OnClick = SchnitteinfuegenvorMarkierungBtnClick
    end
    object SchnitteinfuegennachMarkierungBtn: TSpeedButton
      Left = 6
      Top = 32
      Width = 105
      Height = 25
      Hint = 
        'Aktuellen Schnitt nach der Markierung in die Schnittliste einf'#252'g' +
        'en'
      Caption = 'nachher'
      OnClick = SchnitteinfuegennachMarkierungBtnClick
    end
    object SchnitteinfuegenamEndeBtn: TSpeedButton
      Left = 6
      Top = 60
      Width = 105
      Height = 25
      Hint = 'Aktuellen Schnitt am Ende der Schnittliste einf'#252'gen'
      Caption = 'am Ende'
      OnClick = SchnitteinfuegenamEndeBtnClick
    end
    object SchnittaendernBtn: TSpeedButton
      Left = 6
      Top = 88
      Width = 105
      Height = 25
      Hint = 
        'Markierung in der Schnittliste mit dem aktuellen Schnitt '#252'bersch' +
        'reiben'
      Caption = #228'ndern'
      OnClick = SchnittaendernBtnClick
    end
  end
  object EndePanel1: TPanel
    Left = 18
    Top = 413
    Width = 18
    Height = 18
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    TabOrder = 19
    DesignSize = (
      18
      18)
    object EndeBtn1: TSpeedButton
      Left = 0
      Top = 0
      Width = 18
      Height = 18
      Hint = 'Sprung zum Ende'
      Anchors = [akLeft, akBottom]
      Caption = '>|'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = EndeBtnClick
    end
  end
  object Oeffnen: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Left = 385
    Top = 18
  end
  object Hauptmenue: TMainMenu
    AutoLineReduction = maManual
    Left = 355
    Top = 18
    object Datei: TMenuItem
      AutoHotkeys = maAutomatic
      AutoLineReduction = maManual
      Caption = 'Datei'
      OnClick = DateiClick
      object Video_Audio_oeffnen: TMenuItem
        AutoHotkeys = maAutomatic
        AutoLineReduction = maManual
        Caption = 'Video/Audio '#246'ffnen'
        OnClick = Video_oeffnenClick
      end
      object Datei_hinzufuegen: TMenuItem
        Caption = 'Audio hinzuf'#252'gen'
        OnClick = DateihinzufuegenClick
      end
      object letzteVerzeichnisse: TMenuItem
        Caption = 'letzte Verzeichnisse'
        OnClick = letzteVerzeichnisseClick
        object letztesVerzeichnis: TMenuItem
          Caption = '???'
          OnClick = letztesVerzeichnisClick
        end
      end
      object Indexerstellen: TMenuItem
        AutoHotkeys = maAutomatic
        Caption = 'Indexdateien erstellen'
        OnClick = IndexerstellenClick
      end
      object ProjektNeu: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = 'Projekt neu'
        OnClick = ProjektNeuClick
      end
      object ProjektLaden: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = 'Projekt laden'
        OnClick = ProjektLadenClick
      end
      object letzteProjekte: TMenuItem
        Caption = 'letzte Projekte'
        OnClick = letzteProjekteClick
        object letztesProjekt: TMenuItem
          Caption = '???'
          OnClick = letztesProjektClick
        end
      end
      object ProjektEinfuegen: TMenuItem
        Caption = 'Projekt einf'#252'gen'
        OnClick = ProjektEinfuegenClick
      end
      object Projektspeichern_: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = 'Projekt speichern'
        OnClick = Projektspeichern_Click
        object Projektspeichern: TMenuItem
          Caption = 'Projekt speichern'
          OnClick = ProjektspeichernClick
        end
        object Projektspeichernunter: TMenuItem
          Caption = 'Projekt speichern unter'
          OnClick = ProjektspeichernunterClick
        end
        object ProjektspeichernPlus: TMenuItem
          Caption = 'Projekt speichern + 1'
          OnClick = ProjektspeichernPlusClick
        end
        object Trennlinie8: TMenuItem
          Caption = '-'
        end
        object Projektspeichernspezial: TMenuItem
          Caption = 'Projekt speichern spezial'
          OnClick = ProjektspeichernspezialClick
        end
        object Schnittpunkteeinzelnspeichern: TMenuItem
          Caption = '    Schnitte einzeln speichern'
          OnClick = SchnittpunkteeinzelnspeichernClick
        end
        object MarkierteSchnittpunktespeichern: TMenuItem
          Caption = '    Markierte Schnitte speichern'
          OnClick = MarkierteSchnittpunktespeichernClick
        end
      end
      object ProgrammEnde: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = 'Ende'
        OnClick = ProgrammEndeClick
      end
    end
    object Bearbeiten: TMenuItem
      Caption = 'Bearbeiten'
      OnClick = BearbeitenClick
      object RueckgaengigMenuIntem: TMenuItem
        Caption = 'r'#252'ckg'#228'ngig'
        OnClick = RueckgaengigMenuIntemClick
      end
      object WiederherstellenMenuItem: TMenuItem
        Caption = 'wiederherstellen'
        OnClick = WiederherstellenMenuItemClick
      end
    end
    object Optionen: TMenuItem
      Caption = 'Optionen'
      object Allgemeinseite: TMenuItem
        Caption = 'Allgemein'
        OnClick = OptionenfensterClick
      end
      object Oberflaechenseite: TMenuItem
        Caption = 'Oberfl'#228'che'
        OnClick = OptionenfensterClick
      end
      object Verzeichnisseite: TMenuItem
        Caption = 'Verzeichnisse'
        OnClick = OptionenfensterClick
      end
      object DateinamenEndungenseite: TMenuItem
        Caption = 'Dateinamen/Dateiendungen'
        OnClick = OptionenfensterClick
      end
      object Wiedergabeseite: TMenuItem
        Caption = 'Anzeige/Wiedergabe'
        OnClick = OptionenfensterClick
      end
      object VideoAudioSchnittseite: TMenuItem
        Caption = 'Video/Audioschnitt'
        OnClick = OptionenfensterClick
      end
      object SchnittlistenFormatseiteMenuItem: TMenuItem
        Caption = 'Schnittliste'
        OnClick = OptionenfensterClick
      end
      object KapitellistenFormatseiteMenuItem: TMenuItem
        Caption = 'Kapitelliste'
        OnClick = OptionenfensterClick
      end
      object MarkenlistenFormatseiteMenuItem: TMenuItem
        Caption = 'Markenliste'
        OnClick = OptionenfensterClick
      end
      object ListenImportseiteMenuItem: TMenuItem
        Caption = 'Listenimport'
        OnClick = OptionenfensterClick
      end
      object ListenExportseiteMenuItem: TMenuItem
        Caption = 'Listenexport'
        OnClick = OptionenfensterClick
      end
      object TastenbelegungSeite: TMenuItem
        Caption = 'Tastenbelegung'
        OnClick = OptionenfensterClick
      end
      object NavigationsSeite: TMenuItem
        Caption = 'Navigation'
        OnClick = OptionenfensterClick
      end
      object VorschauSeite: TMenuItem
        Caption = 'Vorschau'
        OnClick = OptionenfensterClick
      end
      object AusgabeSeite: TMenuItem
        Caption = 'externe Programme'
        OnClick = OptionenfensterClick
      end
      object EffekteSeite: TMenuItem
        Caption = 'Effekte'
        OnClick = OptionenfensterClick
      end
      object GrobansichtSeite: TMenuItem
        Caption = 'Film'#252'bersicht'
        OnClick = OptionenfensterClick
      end
    end
    object Arbeitsumgebungenmenue: TMenuItem
      Caption = 'Arbeitsumgebungen'
      OnClick = ArbeitsumgebungenMenueClick
      object Arbeitsumgebungenbearbeiten: TMenuItem
        Caption = 'Arbeitsumgebungen bearbeiten'
        OnClick = ArbeitsumgebungenbearbeitenClick
      end
      object Trennlinie21: TMenuItem
        Caption = '-'
      end
    end
    object Sprachmenue: TMenuItem
      Caption = 'Sprachen'
      OnClick = SprachenMenueClick
      object Trennlinie22: TMenuItem
        Caption = '-'
      end
    end
    object ZusatzFunktionenmenue: TMenuItem
      Caption = 'Zusatzfunktionen'
      OnClick = ZusatzFunktionenmenueClick
      object Schnittesuchen: TMenuItem
        Caption = 'Schnitte suchen'
        OnClick = SchnittesuchenClick
      end
      object aktuellesBildspeichern: TMenuItem
        Caption = 'aktuelles Bild speichern'
        OnClick = aktuellesBildspeichernClick
      end
      object aktuellesBildkopieren: TMenuItem
        Caption = 'aktuelles Bild kopieren'
        OnClick = aktuellesBildkopierenClick
      end
      object aktAudioFramespeichern: TMenuItem
        Caption = 'aktuellen Audioframe speichern'
        OnClick = aktAudioFramespeichernClick
      end
      object FilmGrobansichtMenuItem: TMenuItem
        Caption = 'Grobansicht zur Schnittsuche'
        Visible = False
        OnClick = FilmGrobansichtMenuItemClick
      end
    end
    object Fenstermenue: TMenuItem
      Caption = 'Ansicht'
      OnClick = FenstermenueClick
      object ZweiFensterMenuItem: TMenuItem
        Caption = 'zwei Videofenster'
        OnClick = ZweiFensterMenuItemClick
      end
      object AudiooffsetMenuItem: TMenuItem
        Caption = 'Audiooffset'
        OnClick = Audiooffsetein_Click
      end
      object binaereSucheMenue: TMenuItem
        Caption = 'bin'#228're Suche'
        Visible = False
        OnClick = binaereSucheMenueClick
      end
      object GrobansichtMenuItem: TMenuItem
        Caption = 'Film'#252'bersicht'
        OnClick = GrobansichtMenuItemClick
      end
    end
    object Hilfemenu: TMenuItem
      AutoLineReduction = maManual
      Caption = 'Hilfe'
      OnClick = HilfemenuClick
      object Hilfe: TMenuItem
        Caption = 'Hilfe'
        OnClick = HilfeClick
      end
      object Lizenz: TMenuItem
        Caption = 'Lizenz'
        OnClick = UeberClick
      end
      object Ueber: TMenuItem
        Caption = #220'ber ...'
        OnClick = UeberClick
      end
    end
  end
  object Speichern: TSaveDialog
    DefaultExt = 'm2e'
    Filter = 'Mpegvideo-Dateien|*.mpv'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 418
    Top = 20
  end
  object DateienMenue: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    OnPopup = DateienfensterMenuePopup
    Left = 323
    Top = 18
    object VideoAudiooeffnen: TMenuItem
      AutoHotkeys = maManual
      AutoLineReduction = maManual
      Caption = 'Video/Audio '#246'ffnen (Strg o)'
      OnClick = Video_oeffnenClick
    end
    object Dateihinzufuegen: TMenuItem
      AutoHotkeys = maManual
      AutoLineReduction = maManual
      Caption = 'Audio hinzuf'#252'gen (Strg a)'
      OnClick = DateihinzufuegenClick
    end
    object Dateiaendern: TMenuItem
      Caption = 'Video/Audio '#228'ndern (Strg n)'
      OnClick = DateiaendernClick
    end
    object Dateiloeschen: TMenuItem
      AutoHotkeys = maManual
      AutoLineReduction = maManual
      Caption = 'Video/Audio l'#246'schen (Strg Entf)'
      OnClick = DateiloeschenClick
    end
  end
  object SchnittlisteMenue: TPopupMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    OnPopup = SchnittlisteMenuePopup
    Left = 293
    Top = 19
    object Schnittlisteimportieren: TMenuItem
      Caption = 'Schnittliste importieren'
      OnClick = SchnittlisteimportierenClick
    end
    object SchnitteausDateienMenuItem: TMenuItem
      Caption = 'Schnitte aus Dateiliste erstellen'
      OnClick = SchnitteausDateienMenuItemClick
    end
    object Trennlinie15: TMenuItem
      Caption = '-'
    end
    object MarkierteSchnittpunkteloeschen: TMenuItem
      Caption = 'markierte Schnittpunkte l'#246'schen'
      OnClick = MarkierteSchnittpunkteloeschenClick
    end
    object Schnittlisteloeschen: TMenuItem
      Caption = 'Schnittliste l'#246'schen'
      OnClick = SchnittlisteloeschenClick
    end
    object Trennlinie5: TMenuItem
      Caption = '-'
    end
    object VideoEffekt: TMenuItem
      Caption = 'Videoeffekt'
      OnClick = VideoEffektClick
    end
    object AudioEffekt: TMenuItem
      Caption = 'Audioeffekt'
      OnClick = AudioEffektClick
    end
    object Trennlinie19: TMenuItem
      Caption = '-'
      Visible = False
    end
    object ProjektNeu1: TMenuItem
      Caption = 'Projekt neu'
      Visible = False
      OnClick = ProjektNeuClick
    end
    object ProjektLaden1: TMenuItem
      Caption = 'Projekt laden'
      Visible = False
      OnClick = ProjektLadenClick
    end
    object ProjektEinfuegen1: TMenuItem
      Caption = 'Projekt einf'#252'gen'
      Visible = False
      OnClick = ProjektEinfuegenClick
    end
    object Projektspeichern1: TMenuItem
      Caption = 'Projekt speichern'
      Visible = False
      OnClick = ProjektspeichernClick
    end
    object Projektspeichernunter1: TMenuItem
      Caption = 'Projekt speichern unter'
      Visible = False
      OnClick = ProjektspeichernunterClick
    end
    object ProjektspeichernPlus1: TMenuItem
      Caption = 'Projekt speichern + 1'
      Visible = False
      OnClick = ProjektspeichernPlusClick
    end
    object Trennlinie6: TMenuItem
      Caption = '-'
      Visible = False
    end
    object Projektspeichernspezial1: TMenuItem
      Caption = 'Projekt speichern spezial'
      Visible = False
      OnClick = ProjektspeichernspezialClick
    end
    object Schnittpunkteeinzelnspeichern1: TMenuItem
      Caption = '    Schnittpunkte einzeln speichern'
      Visible = False
      OnClick = SchnittpunkteeinzelnspeichernClick
    end
    object MarkierteSchnittpunktespeichern1: TMenuItem
      Caption = '    Markierte Schnittpunkte speichern'
      Visible = False
      OnClick = MarkierteSchnittpunktespeichernClick
    end
    object Trennlinie7: TMenuItem
      Caption = '-'
    end
    object Markierungenaufheben1: TMenuItem
      Caption = 'Markierungen aufheben'
      OnClick = MarkierungaufhebenClick
    end
    object Trennlinie12: TMenuItem
      Caption = '-'
    end
    object Schnittpunktformatanpassen: TMenuItem
      Caption = 'Schnittformat anpassen'
      OnClick = SchnittpunktformatanpassenClick
    end
    object SchnittlistenFormatseiteMenuItem1: TMenuItem
      Caption = 'Listenformat einstellen'
      OnClick = OptionenfensterClick
    end
    object Trennlinie17: TMenuItem
      Caption = '-'
    end
    object SchnittpktAnfangkopieren: TMenuItem
      Caption = 'IN-Schnittpunkt kopieren'
      OnClick = SchnittpktAnfangkopierenClick
    end
    object SchnittpktEndekopieren: TMenuItem
      Caption = 'OUT-Schnittpunkt kopieren'
      OnClick = SchnittpktEndekopierenClick
    end
  end
  object Anzeigefenstermenue: TPopupMenu
    OnPopup = AnzeigefenstermenuePopup
    Left = 259
    Top = 19
    object NurIFrames: TMenuItem
      Caption = 'nur I-Frames abspielen'
      GroupIndex = 3
      OnClick = NurIFramesClick
    end
    object keinVideo: TMenuItem
      Caption = 'kein Video abspielen'
      GroupIndex = 3
      OnClick = keinVideoClick
    end
    object Trennlinie2: TMenuItem
      Caption = '-'
      GroupIndex = 3
    end
    object Stop1: TMenuItem
      Caption = 'Stop'
      GroupIndex = 3
      OnClick = StopClick
    end
    object Trennlinie26: TMenuItem
      Caption = '-'
      GroupIndex = 3
    end
    object Vollbild: TMenuItem
      Caption = 'Vollbild'
      GroupIndex = 3
      OnClick = VollbildClick
    end
    object Trennlinie4: TMenuItem
      Caption = '-'
      GroupIndex = 3
    end
    object Doppelt: TMenuItem
      Caption = '200 %'
      GroupIndex = 3
      RadioItem = True
      OnClick = DoppeltClick
    end
    object EinsFuenfzuEins: TMenuItem
      Caption = '150 %'
      GroupIndex = 3
      RadioItem = True
      OnClick = EinsFuenfzuEinsClick
    end
    object EinszuEins: TMenuItem
      Caption = '100 %'
      GroupIndex = 3
      RadioItem = True
      OnClick = EinszuEinsClick
    end
    object EinszuEinsFuenf: TMenuItem
      Caption = '75 %'
      GroupIndex = 3
      RadioItem = True
      OnClick = EinszuEinsFuenfClick
    end
    object EinszuZwei: TMenuItem
      Caption = '50 %'
      GroupIndex = 3
      RadioItem = True
      OnClick = EinszuZweiClick
    end
    object EinszuVier: TMenuItem
      Caption = '25 %'
      GroupIndex = 3
      RadioItem = True
      OnClick = EinszuVierClick
    end
    object Maximal: TMenuItem
      Caption = 'maximal'
      GroupIndex = 3
      RadioItem = True
      OnClick = MaximalClick
    end
    object Trennlinie3: TMenuItem
      Caption = '-'
      GroupIndex = 3
    end
    object Videoanzeigegroesse1: TMenuItem
      Caption = 'Videogr'#246#223'e einrasten'
      GroupIndex = 3
      OnClick = Videoanzeigegroesse1Click
    end
  end
  object Vorschaumenue: TPopupMenu
    OnPopup = VorschaumenuePopup
    Left = 227
    Top = 19
    object Vorschau_beenden: TMenuItem
      Caption = 'Vorschau beenden'
      OnClick = Vorschau_beendenClick
    end
    object Vorschau_neu: TMenuItem
      Caption = 'Vorschau neu berechnen'
      OnClick = Vorschau_neuClick
    end
  end
  object KapiteltastenMenue: TPopupMenu
    OnPopup = KapiteltastenMenuePopup
    Left = 482
    Top = 20
    object KapitelvorhereinfuegenMenuItem: TMenuItem
      Caption = 'vorher einf'#252'gen'
      OnClick = KapitelvorhereinfuegenMenuItemClick
    end
    object KapitelnachhereinfuegenMenuItem: TMenuItem
      Caption = 'nachher einf'#252'gen'
      OnClick = KapitelnachhereinfuegenMenuItemClick
    end
    object KapitelamEndeeinfuegenMenuItem: TMenuItem
      Caption = 'am Ende einf'#252'gen'
      OnClick = KapitelamEndeeinfuegenMenuItemClick
    end
    object Kapitelaendern: TMenuItem
      Caption = 'Kapitel '#228'ndern'
      OnClick = KapitelaendernClick
    end
  end
  object KapitellistePopupMenu: TPopupMenu
    OnPopup = KapitellistePopupMenuPopup
    Left = 452
    Top = 20
    object KapitelListeloeschenMenuItem: TMenuItem
      Caption = 'Kapitelliste l'#246'schen'
      OnClick = KapitelListeloeschenMenuItemClick
    end
    object KapitelListeimportierenMenuItem: TMenuItem
      Caption = 'Kapitelliste importieren'
      OnClick = KapitelListeimportierenMenuItemClick
    end
    object KapitelListeexportierenMenuItem: TMenuItem
      Caption = 'Kapitelliste exportieren'
      OnClick = KapitelListeexportierenMenuItemClick
    end
    object KapitelexportierenMenuItem: TMenuItem
      Caption = 'Kapitel exportieren'
      OnClick = KapitelexportierenMenuItemClick
    end
    object Trennlinie16: TMenuItem
      Caption = '-'
    end
    object KapitelListeSchnitteimportierenMenuItem: TMenuItem
      Caption = 'Schnittpunkte importieren'
      OnClick = KapitelListeSchnitteimportierenMenuItemClick
    end
    object KapitelListeberechnenexportierenMenuItem: TMenuItem
      Caption = 'Kapitelliste berechnen/exportieren'
      OnClick = KapitelberechnenexportierenMenuItemClick
    end
    object KapitelberechnenexportierenMenuItem: TMenuItem
      Caption = 'Kapitel berechnen/exportieren'
      OnClick = KapitelberechnenexportierenMenuItemClick
    end
    object Trennlinie24: TMenuItem
      Caption = '-'
    end
    object KapitelverschiebenMenuItem: TMenuItem
      Caption = 'Kapitel verschieben (Strg)'
      OnClick = KapitelverschiebenMenuItemClick
    end
    object Trennlinie14: TMenuItem
      Caption = '-'
    end
    object KapitelausschneidenMenuItem: TMenuItem
      Caption = 'Kapitel ausschneiden (Strg x)'
      OnClick = KapitelausschneidenMenuItemClick
    end
    object KapitelkopierenMenuItem: TMenuItem
      Caption = 'Kapitel kopieren (Strg c)'
      OnClick = KapitelkopierenMenuItemClick
    end
    object KapiteleinfuegenMenuItem: TMenuItem
      Caption = 'Kapitel einf'#252'gen (Strg v)'
      OnClick = KapiteleinfuegenMenuItemClick
    end
    object KapitelloeschenMenuItem: TMenuItem
      Caption = 'Kapitel l'#246'schen (Strg Entf)'
      OnClick = KapitelloeschenMenuItemClick
    end
    object KapiteleinfuegenClpbrdMenuItem: TMenuItem
      Caption = 'Clipboard einf'#252'gen (Strg Shift v)'
      OnClick = KapiteleinfuegenClpbrdMenuItemClick
    end
    object Trennlinie20: TMenuItem
      Caption = '-'
    end
    object KapitelListeMarkierungenaufhebenMenuItem: TMenuItem
      Caption = 'Markierungen aufheben'
      OnClick = KapitelListeMarkierungenaufhebenMenuItemClick
    end
    object MenuItem24: TMenuItem
      Caption = '-'
    end
    object KapitelListeTrennzeileeinfuegenMenuItem: TMenuItem
      Caption = 'Trennzeile einf'#252'gen (Strg t)'
      OnClick = KapitelListeTrennzeileeinfuegenMenuItemClick
    end
    object Trennlinie25: TMenuItem
      Caption = '-'
    end
    object KapitelListeZeitformataendernMenuItem: TMenuItem
      Caption = 'Zeitformat umrechnen'
      OnClick = KapitelListeZeitformataendernMenuItemClick
    end
    object KapitellistenFormatseiteMenuItem1: TMenuItem
      Caption = 'Listenformat einstellen'
      OnClick = OptionenfensterClick
    end
  end
  object MarkentastePopupMenu: TPopupMenu
    OnPopup = MarkentastePopupMenuPopup
    Left = 165
    Top = 87
    object MarkevorhereinfuegenMenuItem: TMenuItem
      Caption = 'vorher einf'#252'gen'
      OnClick = MarkevorhereinfuegenMenuItemClick
    end
    object MarkenachhereinfuegenMenuItem: TMenuItem
      Caption = 'nachher einf'#252'gen'
      OnClick = MarkenachhereinfuegenMenuItemClick
    end
    object MarkeamEndeeinfuegenMenuItem: TMenuItem
      Caption = 'am Ende einf'#252'gen'
      OnClick = MarkeamEndeeinfuegenMenuItemClick
    end
    object MarkeaendernMenuItem: TMenuItem
      Caption = 'Marke '#228'ndern'
      OnClick = MarkeaendernMenuItemClick
    end
  end
  object MarkenListePopupMenu: TPopupMenu
    OnPopup = MarkenListePopupMenuPopup
    Left = 195
    Top = 19
    object MarkenListeloeschenMenuItem: TMenuItem
      Caption = 'Markenliste l'#246'schen'
      OnClick = MarkenListeloeschenMenuItemClick
    end
    object MarkenListeimportierenMenuItem: TMenuItem
      Caption = 'Markenliste importieren'
      OnClick = MarkenListeimportierenMenuItemClick
    end
    object MarkenListeexportierenMenuItem: TMenuItem
      Caption = 'Markenliste exportieren'
      OnClick = MarkenListeexportierenMenuItemClick
    end
    object MarkenexportierenMenuItem: TMenuItem
      Caption = 'Marken exportieren'
      OnClick = MarkenexportierenMenuItemClick
    end
    object MarkenListeladenMenuItem: TMenuItem
      Caption = 'Markenliste laden'
      OnClick = MarkenListeladenMenuItemClick
    end
    object MarkenListespeichernMenuItem: TMenuItem
      Caption = 'Markenliste speichern'
      OnClick = MarkenListespeichernMenuItemClick
    end
    object Trennlinie9: TMenuItem
      Caption = '-'
    end
    object MarkenlisteSchnittpunkteimportierenMenuItem: TMenuItem
      Caption = 'Schnittpunkte importieren'
      OnClick = MarkenlisteSchnittpunkteimportierenMenuItemClick
    end
    object MarkenListeberechnenexportierenMenuItem: TMenuItem
      Caption = 'Markenliste berechnen/exp.'
      OnClick = MarkenListeberechnenexportierenMenuItemClick
    end
    object MarkenberechnenexportierenMenuItem: TMenuItem
      Caption = 'Marken berechnen/exp.'
      OnClick = MarkenberechnenexportierenMenuItemClick
    end
    object Trennlinie13: TMenuItem
      Caption = '-'
    end
    object MarkeloeschenMenuItem: TMenuItem
      Caption = 'Marken l'#246'schen (Zeilen)'
      OnClick = MarkeloeschenMenuItemClick
    end
    object Trennlinie28: TMenuItem
      Caption = '-'
    end
    object GOPssuchenMenuItem: TMenuItem
      Caption = 'lange Gops suchen'
      OnClick = GOPssuchenMenuItemClick
    end
    object Trennlinie23: TMenuItem
      Caption = '-'
    end
    object MarkenListeRueckgaengigMenuItem: TMenuItem
      Caption = 'R'#252'ckg'#228'ngig'
      OnClick = MarkenListeRueckgaengigMenuItemClick
    end
    object MarkenListeAusschneidenMenuItem: TMenuItem
      Caption = 'Ausschneiden'
      OnClick = MarkenListeAusschneidenMenuItemClick
    end
    object MarkenListeKopierenMenuItem: TMenuItem
      Caption = 'Kopieren'
      OnClick = MarkenListeKopierenMenuItemClick
    end
    object MarkenListeEinfuegenMenuItem: TMenuItem
      Caption = 'Einf'#252'gen'
      OnClick = MarkenListeEinfuegenMenuItemClick
    end
    object MarkenListeMarkierungLoeschenMenuItem: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = MarkenListeMarkierungLoeschenMenuItemClick
    end
    object Trennlinie10: TMenuItem
      Caption = '-'
    end
    object MarkenListeMarkierungenaufhebenMenuItem: TMenuItem
      Caption = 'Markierungen aufheben'
      OnClick = MarkenListeMarkierungenaufhebenMenuItemClick
    end
    object Trennlinie11: TMenuItem
      Caption = '-'
    end
    object MarkenListeZeitformataendernMenuItem: TMenuItem
      Caption = 'Zeitformat umrechnen'
      OnClick = MarkenListeZeitformataendernMenuItemClick
    end
    object MarkenlistenFormatseiteMenuItem1: TMenuItem
      Caption = 'Listenformat einstellen'
      OnClick = OptionenfensterClick
    end
  end
  object AllgemeinPopupMenu: TPopupMenu
    OnPopup = AllgemeinPopupMenuPopup
    Left = 278
    Top = 86
    object Projektneu2: TMenuItem
      Action = ProjektneuAction
    end
    object Projektladen2: TMenuItem
      Action = ProjektladenAction
    end
    object letzteProjekte2: TMenuItem
      Caption = 'letzte Projekte'
      OnClick = letzteProjekteClick
      object letztesProjekt2: TMenuItem
        Caption = '???'
        OnClick = letztesProjektClick
      end
    end
    object Projekteinfuegen2: TMenuItem
      Action = ProjekteinfuegenAction
    end
    object Projektspeichern2: TMenuItem
      Action = ProjektspeichernAction
    end
    object Projektspeichernunter2: TMenuItem
      Action = ProjektspeichernunterAction
    end
    object Projektspeichernplus2: TMenuItem
      Action = ProjektspeichernpluseinsAction
    end
  end
  object HauptActionList: TActionList
    Left = 332
    Top = 86
    object VideoAudiooeffnenAction: TAction
      Category = 'Datei'
      Caption = 'Video/Audio '#246'ffnen'
    end
    object DateihinzufuegenAction: TAction
      Category = 'Datei'
      Caption = 'Datei hinzuf'#252'gen'
    end
    object DateiaendernAction: TAction
      Category = 'Datei'
      Caption = 'Datei '#228'ndern'
    end
    object ProjektneuAction: TAction
      Category = 'Projekt'
      Caption = 'Projekt neu'
      Hint = 'neues Projekt'
      ImageIndex = 0
      OnExecute = ProjektNeuClick
    end
    object ProjektspeichernAction: TAction
      Category = 'Projekt'
      Caption = 'Projekt speichern'
      ImageIndex = 2
      OnExecute = ProjektspeichernClick
    end
    object ProjektspeichernunterAction: TAction
      Category = 'Projekt'
      Caption = 'Projekt speichern unter'
      OnExecute = ProjektspeichernunterClick
    end
    object ProjektspeichernpluseinsAction: TAction
      Category = 'Projekt'
      Caption = 'Projekt speichern + 1'
      OnExecute = ProjektspeichernPlusClick
    end
    object ProjektspeichernspezialAction: TAction
      Category = 'Projekt'
      Caption = 'Projekt speichern spezial'
    end
    object ProjektladenAction: TAction
      Category = 'Projekt'
      Caption = 'Projekt laden'
      ImageIndex = 1
      OnExecute = ProjektLadenClick
    end
    object ProjekteinfuegenAction: TAction
      Category = 'Projekt'
      Caption = 'Projekt einf'#252'gen'
      OnExecute = ProjektEinfuegenClick
    end
  end
  object DummyPopupMenu: TPopupMenu
    Left = 412
    Top = 86
  end
  object InfoPopupMenu: TPopupMenu
    OnPopup = InfoPopupMenuPopup
    Left = 198
    Top = 86
    object InfoAktualisierenMenuItem: TMenuItem
      Caption = 'Aktualisieren'
      OnClick = InfoAktualisierenMenuItemClick
    end
    object Trennlinie27: TMenuItem
      Caption = '-'
    end
    object InfoRueckgaengigMenuItem: TMenuItem
      Caption = 'R'#252'ckg'#228'ngig'
      OnClick = InfoRueckgaengigMenuItemClick
    end
    object InfoAusschneidenMenuItem: TMenuItem
      Caption = 'Ausschneiden'
      OnClick = InfoAusschneidenMenuItemClick
    end
    object InfoKopierenMenuItem: TMenuItem
      Caption = 'Kopieren'
      OnClick = InfoKopierenMenuItemClick
    end
    object InfoEinfuegenMenuItem: TMenuItem
      Caption = 'Einf'#252'gen'
      OnClick = InfoEinfuegenMenuItemClick
    end
    object InfoLoeschenMenuItem: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = InfoLoeschenMenuItemClick
    end
  end
  object CutPopupMenu: TPopupMenu
    Left = 240
    Top = 86
    object CutItemIndex: TMenuItem
      Caption = 'Cut'
      OnClick = SchneidenClick
    end
    object SchnittToolItemIndex: TMenuItem
      Caption = 'zum SchnittTool hinzuf'#252'gen'
      Enabled = False
      OnClick = SchnittToolItemIndexClick
    end
    object Cut1ItemIndex: TMenuItem
      Caption = 'Cut alt (ohne Audioeffekte)'
      OnClick = Cut1ItemIndexClick
    end
  end
  object VideoAudioPopupMenu: TPopupMenu
    Left = 370
    Top = 86
    object Video_Audio_oeffnen1: TMenuItem
      Caption = 'Video/Audio '#246'ffnen'
      OnClick = Video_oeffnenClick
    end
    object Datei_hinzufuegen1: TMenuItem
      Caption = 'Audio hinzuf'#252'gen'
      OnClick = DateihinzufuegenClick
    end
    object letzteVerzeichnisse1: TMenuItem
      Caption = 'letzte Verzeichnisse'
      OnClick = letzteVerzeichnisseClick
      object letztesVerzeichnis1: TMenuItem
        Caption = '???'
        OnClick = letztesVerzeichnisClick
      end
    end
  end
end
