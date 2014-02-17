object SchnittsucheFenster: TSchnittsucheFenster
  Left = 544
  Top = 252
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Schnittsuche'
  ClientHeight = 349
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl: TPageControl
    Left = 0
    Top = 2
    Width = 455
    Height = 347
    ActivePage = Logo
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Logo: TTabSheet
      Caption = 'Pixel-Vergleiche'
      ImageIndex = 2
      OnShow = LogoWertePruefen
      object Logo_Suchprofile_: TLabel
        Left = 320
        Top = 8
        Width = 60
        Height = 14
        Caption = 'SuchProfile'
      end
      object Logo_vglPixel_: TLabel
        Left = 192
        Top = 48
        Width = 108
        Height = 14
        Caption = 'VergleichsPixel-Liste'
      end
      object Logo_ProfilName_: TLabel
        Left = 192
        Top = 8
        Width = 61
        Height = 14
        Caption = 'Profil Name'
      end
      object Logo_Min_: TLabel
        Left = 8
        Top = 56
        Width = 51
        Height = 14
        Caption = 'Min. Grau'
      end
      object Logo_PosY_: TLabel
        Left = 8
        Top = 32
        Width = 31
        Height = 14
        Caption = 'Y-Pos'
      end
      object Logo_PosX_: TLabel
        Left = 8
        Top = 8
        Width = 30
        Height = 14
        Caption = 'X-Pos'
      end
      object Logo_Max_: TLabel
        Left = 8
        Top = 80
        Width = 54
        Height = 14
        Caption = 'Max. Grau'
      end
      object Logo_Schnittlaenge_: TLabel
        Left = 8
        Top = 136
        Width = 94
        Height = 14
        Caption = 'Min. Schnittl'#228'nge'
      end
      object Logo_Schrittweite_: TLabel
        Left = 8
        Top = 160
        Width = 67
        Height = 14
        Caption = 'Schrittweite'
      end
      object Logo_Sekunden1_: TLabel
        Left = 164
        Top = 136
        Width = 20
        Height = 14
        Caption = 'Sek'
      end
      object Logo_Sekunden2_: TLabel
        Left = 164
        Top = 160
        Width = 20
        Height = 14
        Caption = 'Sek'
      end
      object Logo_INkorrektur_: TLabel
        Left = 8
        Top = 184
        Width = 67
        Height = 14
        Caption = 'IN Korrektur'
      end
      object Logo_OUTkorrektur_: TLabel
        Left = 8
        Top = 208
        Width = 80
        Height = 14
        Caption = 'OUT Korrektur'
      end
      object Logo_Bilder1_: TLabel
        Left = 164
        Top = 184
        Width = 29
        Height = 14
        Caption = 'Bilder'
      end
      object Logo_Bilder2_: TLabel
        Left = 164
        Top = 208
        Width = 29
        Height = 14
        Caption = 'Bilder'
      end
      object Logo_Verfeinern_: TLabel
        Left = 8
        Top = 240
        Width = 57
        Height = 14
        Caption = 'Verfeinern'
      end
      object Logo_Profilliste: TListBox
        Left = 320
        Top = 24
        Width = 121
        Height = 257
        DragMode = dmAutomatic
        ItemHeight = 14
        MultiSelect = True
        PopupMenu = logo_ProfilListeMenue
        TabOrder = 0
        OnClick = LogoProfileWertePruefen
        OnDblClick = Logo_ProfillisteDblClick
        OnDragDrop = Logo_ProfillisteDragDrop
        OnDragOver = Logo_ProfillisteDragOver
        OnEndDrag = Logo_ProfillisteEndDrag
        OnMouseUp = Logo_ProfillisteMouseUp
        OnStartDrag = Logo_ProfillisteStartDrag
      end
      object Logo_PixelListe: TListBox
        Left = 192
        Top = 64
        Width = 113
        Height = 97
        ItemHeight = 14
        PopupMenu = Logo_PixelListeMenue
        TabOrder = 1
        OnClick = LogoWertePruefen
        OnDblClick = Logo_PixelListeDblClick
      end
      object Logo_suchen: TButton
        Left = 176
        Top = 270
        Width = 129
        Height = 41
        Caption = 'Suchen'
        TabOrder = 2
        OnClick = Logo_suchenClick
      end
      object Logo_Abbrechen: TButton
        Left = 8
        Top = 270
        Width = 145
        Height = 41
        Caption = 'Abbrechen'
        TabOrder = 3
        OnClick = Audio_AbbrechenClick
      end
      object Logo_posy: TEdit
        Left = 64
        Top = 32
        Width = 49
        Height = 22
        TabOrder = 5
        Text = '575'
        OnChange = LogoWertePruefen
      end
      object Logo_mingrau: TEdit
        Left = 64
        Top = 56
        Width = 49
        Height = 22
        TabOrder = 6
        Text = '0'
        OnChange = LogoWertePruefen
      end
      object Logo_maxgrau: TEdit
        Left = 64
        Top = 80
        Width = 49
        Height = 22
        TabOrder = 7
        Text = '255'
        OnChange = LogoWertePruefen
      end
      object Logo_posx: TEdit
        Left = 64
        Top = 8
        Width = 49
        Height = 22
        TabOrder = 4
        Text = '719'
        OnChange = LogoWertePruefen
      end
      object Logo_Profilname: TEdit
        Left = 192
        Top = 24
        Width = 113
        Height = 22
        TabOrder = 14
        Text = 'Profil'
        OnChange = LogoProfileWertePruefen
      end
      object Logo_Neu: TButton
        Left = 120
        Top = 96
        Width = 65
        Height = 25
        Caption = 'Neu -->'
        TabOrder = 13
        OnClick = Logo_NeuClick
      end
      object Logo_Farbwert: TButton
        Left = 120
        Top = 16
        Width = 65
        Height = 25
        Caption = 'Grauwert'
        TabOrder = 12
        OnClick = Logo_FarbwertClick
      end
      object Logo_len: TEdit
        Left = 110
        Top = 136
        Width = 49
        Height = 22
        TabOrder = 8
        Text = '90'
        OnChange = LogoProfileWertePruefen
      end
      object Logo_seek: TEdit
        Left = 110
        Top = 160
        Width = 49
        Height = 22
        TabOrder = 9
        Text = '30'
        OnChange = LogoProfileWertePruefen
      end
      object Logo_Invertiert: TCheckBox
        Left = 8
        Top = 104
        Width = 105
        Height = 17
        Caption = 'Invertierte Suche'
        TabOrder = 15
      end
      object Logo_Aendern: TButton
        Left = 120
        Top = 64
        Width = 65
        Height = 25
        Caption = #196'ndern -->'
        TabOrder = 16
        OnClick = Logo_AendernClick
      end
      object LogoProfil_Aendern: TButton
        Left = 232
        Top = 168
        Width = 73
        Height = 25
        Caption = #196'ndern -->'
        TabOrder = 17
        OnClick = LogoProfil_AendernClick
      end
      object LogoProfil_neu: TButton
        Left = 232
        Top = 200
        Width = 73
        Height = 25
        Caption = 'Neu -->'
        TabOrder = 18
        OnClick = LogoProfil_neuClick
      end
      object Logo_INkorrektur: TEdit
        Left = 110
        Top = 184
        Width = 49
        Height = 22
        TabOrder = 10
        Text = '0'
        OnChange = LogoProfileWertePruefen
      end
      object Logo_OUTkorrektur: TEdit
        Left = 110
        Top = 208
        Width = 49
        Height = 22
        TabOrder = 11
        Text = '0'
        OnChange = LogoProfileWertePruefen
      end
      object Logo_Profile_testen: TButton
        Left = 328
        Top = 286
        Width = 113
        Height = 25
        Caption = 'Profile testen'
        TabOrder = 19
        OnClick = Logo_Profile_testenClick
      end
      object logo_verf_lin: TRadioButton
        Left = 80
        Top = 240
        Width = 57
        Height = 17
        Caption = 'linear'
        TabOrder = 20
      end
      object logo_verf_bin: TRadioButton
        Left = 136
        Top = 240
        Width = 57
        Height = 17
        Caption = 'bin'#228'r'
        Checked = True
        TabOrder = 21
        TabStop = True
      end
      object logo_verf_aus: TRadioButton
        Left = 192
        Top = 240
        Width = 57
        Height = 17
        Caption = 'aus'
        TabOrder = 22
      end
    end
    object Letterboxed: TTabSheet
      Caption = 'Letterboxed Video'
      ImageIndex = 1
      OnShow = LetterboxedWertePruefen
      object Letterboxed_Schnittlaenge_: TLabel
        Left = 8
        Top = 136
        Width = 94
        Height = 14
        Caption = 'Min. Schnittl'#228'nge'
      end
      object Letterboxed_Schrittweite_: TLabel
        Left = 8
        Top = 160
        Width = 67
        Height = 14
        Caption = 'Schrittweite'
      end
      object Letterboxed_INkorrektur_: TLabel
        Left = 8
        Top = 184
        Width = 67
        Height = 14
        Caption = 'IN Korrektur'
      end
      object Letterboxed_OUTkorrektur_: TLabel
        Left = 8
        Top = 208
        Width = 80
        Height = 14
        Caption = 'OUT Korrektur'
      end
      object Letterboxed_Sekunden1_: TLabel
        Left = 164
        Top = 136
        Width = 20
        Height = 14
        Caption = 'Sek'
      end
      object Letterboxed_Sekunden2_: TLabel
        Left = 164
        Top = 160
        Width = 20
        Height = 14
        Caption = 'Sek'
      end
      object Letterboxed_Bilder1_: TLabel
        Left = 164
        Top = 184
        Width = 29
        Height = 14
        Caption = 'Bilder'
      end
      object Letterboxed_Bilder2_: TLabel
        Left = 164
        Top = 208
        Width = 29
        Height = 14
        Caption = 'Bilder'
      end
      object Letterboxed_ZeilenIgnorieren_: TLabel
        Left = 8
        Top = 56
        Width = 92
        Height = 14
        Caption = 'Zeilen Ignorieren'
      end
      object Letterboxed_SpaltenIgnorieren_: TLabel
        Left = 8
        Top = 80
        Width = 101
        Height = 14
        Caption = 'Spalten Ignorieren'
      end
      object Letterboxed_MinGrau_: TLabel
        Left = 8
        Top = 8
        Width = 77
        Height = 14
        Caption = 'Grauwert Min.'
      end
      object Letterboxed_MaxGrau_: TLabel
        Left = 8
        Top = 32
        Width = 80
        Height = 14
        Caption = 'Grauwert Max.'
      end
      object Letterboxed_Analysebereich_: TLabel
        Left = 352
        Top = 8
        Width = 71
        Height = 14
        Caption = 'Such Bereich'
      end
      object Letterboxed_Profilname_: TLabel
        Left = 200
        Top = 120
        Width = 61
        Height = 14
        Caption = 'Profil Name'
      end
      object Letterboxed_SuchProfile_: TLabel
        Left = 320
        Top = 120
        Width = 60
        Height = 14
        Caption = 'SuchProfile'
      end
      object Letterboxed_Suchen: TButton
        Left = 176
        Top = 270
        Width = 129
        Height = 41
        Caption = 'Suchen'
        TabOrder = 19
        OnClick = Letterboxed_SuchenClick
      end
      object Letterboxed_Abbrechen: TButton
        Left = 8
        Top = 270
        Width = 145
        Height = 41
        Caption = 'Abbrechen'
        TabOrder = 23
        OnClick = Audio_AbbrechenClick
      end
      object Letterboxed_ZeilenOben: TEdit
        Left = 236
        Top = 8
        Width = 33
        Height = 22
        TabOrder = 9
        OnChange = LetterboxedWertePruefen
        OnClick = Letterboxed_ZeilenObenClick
      end
      object Letterboxed_ZeilenUnten: TEdit
        Left = 236
        Top = 91
        Width = 33
        Height = 22
        TabOrder = 10
        OnChange = LetterboxedWertePruefen
        OnClick = Letterboxed_ZeilenUntenClick
      end
      object Letterboxed_SpaltenLinks: TEdit
        Left = 176
        Top = 48
        Width = 33
        Height = 22
        TabOrder = 11
        OnChange = LetterboxedWertePruefen
        OnClick = Letterboxed_SpaltenLinksClick
      end
      object Letterboxed_SpaltenRechts: TEdit
        Left = 296
        Top = 48
        Width = 33
        Height = 22
        TabOrder = 12
        OnChange = LetterboxedWertePruefen
        OnClick = Letterboxed_SpaltenRechtsClick
      end
      object Letterboxed_Analysieren: TButton
        Left = 216
        Top = 40
        Width = 73
        Height = 41
        Caption = 'Analysieren'
        TabOrder = 13
        OnClick = Letterboxed_AnalysierenClick
      end
      object Letterboxed_Schnittlaenge: TEdit
        Left = 110
        Top = 136
        Width = 49
        Height = 22
        TabOrder = 5
        Text = '90'
        OnChange = LetterboxedWertePruefen
      end
      object Letterboxed_Schrittweite: TEdit
        Left = 110
        Top = 160
        Width = 49
        Height = 22
        TabOrder = 6
        Text = '30'
        OnChange = LetterboxedWertePruefen
      end
      object Letterboxed_INkorrektur: TEdit
        Left = 110
        Top = 184
        Width = 49
        Height = 22
        TabOrder = 8
        Text = '0'
        OnChange = LetterboxedWertePruefen
      end
      object Letterboxed_OUTkorrektur: TEdit
        Left = 110
        Top = 208
        Width = 49
        Height = 22
        TabOrder = 7
        Text = '0'
        OnChange = LetterboxedWertePruefen
      end
      object Letterboxed_invertiert: TCheckBox
        Left = 8
        Top = 104
        Width = 121
        Height = 17
        Caption = 'Invertierte Suche'
        TabOrder = 4
      end
      object Letterboxed_ZeilenIgnorieren: TEdit
        Left = 110
        Top = 56
        Width = 49
        Height = 22
        TabOrder = 2
        Text = '0'
        OnChange = LetterboxedWertePruefen
      end
      object Letterboxed_MaxGrau: TEdit
        Left = 110
        Top = 32
        Width = 49
        Height = 22
        TabOrder = 1
        Text = '20'
        OnChange = LetterboxedWertePruefen
      end
      object Letterboxed_MinGrau: TEdit
        Left = 110
        Top = 8
        Width = 49
        Height = 22
        TabOrder = 0
        Text = '0'
        OnChange = LetterboxedWertePruefen
      end
      object Letterboxed_SpaltenIgnorieren: TEdit
        Left = 110
        Top = 80
        Width = 49
        Height = 22
        TabOrder = 3
        Text = '0'
        OnChange = LetterboxedWertePruefen
      end
      object rb_oben: TRadioButton
        Left = 376
        Top = 32
        Width = 25
        Height = 17
        Checked = True
        TabOrder = 14
        TabStop = True
        OnClick = LetterboxedWertePruefen
      end
      object rb_unten: TRadioButton
        Left = 376
        Top = 80
        Width = 25
        Height = 17
        TabOrder = 15
        OnClick = LetterboxedWertePruefen
      end
      object rb_links: TRadioButton
        Left = 352
        Top = 56
        Width = 25
        Height = 17
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 16
        OnClick = LetterboxedWertePruefen
      end
      object rb_rechts: TRadioButton
        Left = 400
        Top = 56
        Width = 25
        Height = 17
        TabOrder = 17
        OnClick = LetterboxedWertePruefen
      end
      object Letterboxed_Profilliste: TListBox
        Left = 320
        Top = 136
        Width = 121
        Height = 177
        DragMode = dmAutomatic
        ItemHeight = 14
        MultiSelect = True
        PopupMenu = Letterboxed_ProfilListeMenue
        TabOrder = 22
        OnClick = LetterboxedWertePruefen
        OnDblClick = Letterboxed_ProfillisteDblClick
        OnDragDrop = Letterboxed_ProfillisteDragDrop
        OnDragOver = Letterboxed_ProfillisteDragOver
        OnEndDrag = Letterboxed_ProfillisteEndDrag
        OnMouseUp = Letterboxed_ProfillisteMouseUp
        OnStartDrag = Letterboxed_ProfillisteStartDrag
      end
      object Letterboxed_AendernBtn: TButton
        Left = 232
        Top = 168
        Width = 73
        Height = 25
        Caption = #196'ndern -->'
        TabOrder = 20
        OnClick = Letterboxed_AendernBtnClick
      end
      object Letterboxed_NeuBtn: TButton
        Left = 232
        Top = 200
        Width = 73
        Height = 25
        Caption = 'Neu -->'
        TabOrder = 21
        OnClick = Letterboxed_NeuBtnClick
      end
      object Letterboxed_Profilname: TEdit
        Left = 200
        Top = 136
        Width = 105
        Height = 22
        TabOrder = 18
        Text = 'Profil'
        OnChange = LetterboxedWertePruefen
      end
      object lb_verf_panel: TPanel
        Left = 8
        Top = 240
        Width = 297
        Height = 25
        BevelOuter = bvNone
        TabOrder = 24
        object lb_verfeinern_: TLabel
          Left = 0
          Top = 0
          Width = 57
          Height = 14
          Caption = 'Verfeinern'
        end
        object lb_verf_lin: TRadioButton
          Left = 72
          Top = 0
          Width = 65
          Height = 17
          Caption = 'linear'
          TabOrder = 0
        end
        object lb_verf_bin: TRadioButton
          Left = 128
          Top = 0
          Width = 65
          Height = 17
          Caption = 'bin'#228'r'
          Checked = True
          TabOrder = 1
          TabStop = True
        end
        object lb_verf_aus: TRadioButton
          Left = 184
          Top = 0
          Width = 65
          Height = 17
          Caption = 'aus'
          TabOrder = 2
        end
      end
    end
    object Framevergleiche: TTabSheet
      Caption = 'Framevergleiche im Audio'
      object Audio_INKorrektur_: TLabel
        Left = 8
        Top = 104
        Width = 67
        Height = 14
        Caption = 'IN Korrektur'
      end
      object Audio_Bilder2_: TLabel
        Left = 192
        Top = 108
        Width = 29
        Height = 14
        Caption = 'Bilder'
      end
      object Audio_Minuten_: TLabel
        Left = 190
        Top = 172
        Width = 44
        Height = 14
        Caption = 'Minuten'
      end
      object Audio_Schnittlaenge_: TLabel
        Left = 8
        Top = 168
        Width = 124
        Height = 14
        Caption = 'Minimale Schnittlaenge'
      end
      object Audio_Bilder1_: TLabel
        Left = 192
        Top = 140
        Width = 29
        Height = 14
        Caption = 'Bilder'
      end
      object Audio_OUTKorrektur_: TLabel
        Left = 8
        Top = 136
        Width = 80
        Height = 14
        Caption = 'OUT Korrektur'
      end
      object Audio_SuchProfile_: TLabel
        Left = 320
        Top = 8
        Width = 60
        Height = 14
        Caption = 'SuchProfile'
      end
      object Audio_ProfilName_: TLabel
        Left = 8
        Top = 8
        Width = 61
        Height = 14
        Caption = 'Profil Name'
      end
      object Audio_vglIN_: TLabel
        Left = 8
        Top = 40
        Width = 102
        Height = 14
        Caption = 'Vergleichsframe IN'
      end
      object Audio_vglOUT_: TLabel
        Left = 8
        Top = 72
        Width = 115
        Height = 14
        Caption = 'Vergleichsframe OUT'
      end
      object Audio_INkorrektur: TEdit
        Left = 136
        Top = 104
        Width = 49
        Height = 22
        TabOrder = 1
        Text = '380'
        OnChange = WertePruefen
      end
      object Audio_OUTkorrektur: TEdit
        Left = 136
        Top = 136
        Width = 49
        Height = 22
        TabOrder = 2
        Text = '0'
        OnChange = WertePruefen
      end
      object Audio_Laenge: TEdit
        Left = 136
        Top = 168
        Width = 49
        Height = 22
        TabOrder = 3
        Text = '20'
        OnChange = WertePruefen
      end
      object Audio_Abbrechen: TButton
        Left = 8
        Top = 270
        Width = 145
        Height = 41
        Caption = 'Abbrechen'
        ModalResult = 2
        TabOrder = 4
        OnClick = Audio_AbbrechenClick
      end
      object Audio_Suchen: TButton
        Left = 176
        Top = 270
        Width = 129
        Height = 41
        Caption = 'Suchen'
        ModalResult = 1
        TabOrder = 5
        OnClick = Audio_SuchenClick
      end
      object Audio_Profilname: TEdit
        Left = 128
        Top = 8
        Width = 105
        Height = 22
        TabOrder = 0
        Text = 'Profil'
        OnChange = WertePruefen
      end
      object Audio_frameINdatei: TEdit
        Left = 128
        Top = 40
        Width = 105
        Height = 22
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 8
        OnClick = vglFrameINClick
      end
      object Audio_frameOUTdatei: TEdit
        Left = 128
        Top = 72
        Width = 105
        Height = 22
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 7
        OnClick = vglFrameOUTClick
      end
      object Audio_ProfilListe: TListBox
        Left = 320
        Top = 24
        Width = 121
        Height = 289
        DragMode = dmAutomatic
        ItemHeight = 14
        MultiSelect = True
        PopupMenu = Audio_ProfilMenue
        TabOrder = 6
        OnClick = WertePruefen
        OnDblClick = SuchProfileSelect
        OnDragDrop = Audio_ProfilListeDragDrop
        OnDragOver = Audio_ProfilListeDragOver
        OnEndDrag = Audio_ProfilListeEndDrag
        OnMouseUp = Audio_ProfilListeMouseUp
        OnStartDrag = Audio_ProfilListeStartDrag
      end
      object Audio_Aendernbtn: TButton
        Left = 240
        Top = 80
        Width = 75
        Height = 25
        Caption = #196'ndern -->'
        TabOrder = 9
        OnClick = AudioMenue_AendernClick
      end
      object Audio_neubtn: TButton
        Left = 240
        Top = 112
        Width = 75
        Height = 25
        Caption = 'Neu -->'
        TabOrder = 10
        OnClick = AudioMenue_NeuClick
      end
      object Audio_Analysieren: TButton
        Left = 8
        Top = 208
        Width = 145
        Height = 41
        Caption = 'Audio Analysieren'
        TabOrder = 11
        OnClick = Audio_AnalysierenClick
      end
    end
    object AudioAnalyse: TTabSheet
      Caption = 'Audio Analysieren'
      ImageIndex = 3
      object Analyse_Ergebnisliste_: TLabel
        Left = 320
        Top = 8
        Width = 103
        Height = 14
        Caption = 'Analyse Ergebnisse'
      end
      object Analyse_Datei1_: TLabel
        Left = 64
        Top = 48
        Width = 39
        Height = 14
        Caption = 'Datei 1'
      end
      object Analyse_Datei2_: TLabel
        Left = 64
        Top = 104
        Width = 39
        Height = 14
        Caption = 'Datei 2'
      end
      object Analyse_Ergebnisliste2_: TLabel
        Left = 320
        Top = 22
        Width = 87
        Height = 14
        Caption = '(Framenummer,'
      end
      object Analyse_Ergebnisliste3_: TLabel
        Left = 320
        Top = 38
        Width = 40
        Height = 14
        Caption = 'Anzahl)'
      end
      object Analyse_Zurueck: TButton
        Left = 8
        Top = 208
        Width = 145
        Height = 41
        Caption = 'Zur'#252'ck'
        TabOrder = 0
        OnClick = Analyse_ZurueckClick
      end
      object Analyse_Ergebnisliste: TListBox
        Left = 320
        Top = 56
        Width = 121
        Height = 257
        ItemHeight = 14
        PopupMenu = Analyse_Menu
        TabOrder = 1
      end
      object Analyse_Suchen: TButton
        Left = 176
        Top = 270
        Width = 129
        Height = 41
        Caption = 'Vergleich Starten'
        Enabled = False
        TabOrder = 2
        OnClick = Analyse_SuchenClick
      end
      object Analyse_datei1: TEdit
        Left = 144
        Top = 48
        Width = 137
        Height = 22
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnChange = Analyse_ListeLeerenClick
        OnClick = Analyse_datei1Click
      end
      object Analyse_datei2: TEdit
        Left = 144
        Top = 104
        Width = 137
        Height = 22
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = Analyse_datei2Click
      end
      object Analyse_Abbrechenbtn: TButton
        Left = 8
        Top = 270
        Width = 145
        Height = 41
        Caption = 'Abbrechen'
        TabOrder = 5
        OnClick = Audio_AbbrechenClick
      end
    end
  end
  object Audio_ProfilMenue: TPopupMenu
    OnPopup = WertePruefen
    Left = 416
    Top = 168
    object AudioMenue_Loeschen: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = AudioMenue_LoeschenClick
    end
    object AudioMenue_Aendern: TMenuItem
      Caption = #196'ndern'
      OnClick = AudioMenue_AendernClick
    end
    object AudioMenue_Neu: TMenuItem
      Caption = 'Neu'
      OnClick = AudioMenue_NeuClick
    end
  end
  object DateiLadenDialog: TOpenDialog
    Left = 416
    Top = 200
  end
  object Logo_PixelListeMenue: TPopupMenu
    OnPopup = LogoWertePruefen
    Left = 328
    Top = 232
    object LogoPixelMenue_ListeLeeren: TMenuItem
      Caption = 'Liste Leeren'
      OnClick = LogoPixelMenue_ListeLeerenClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object LogoPixelMenue_Loeschen: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = LogoPixelMenue_LoeschenClick
    end
    object LogoPixelMenue_Aendern: TMenuItem
      Caption = #196'ndern'
      OnClick = Logo_AendernClick
    end
    object LogoPixelMenue_Neu: TMenuItem
      Caption = 'Neu'
      OnClick = Logo_NeuClick
    end
    object SliceInfo1: TMenuItem
      Caption = 'Slice Info'
      Visible = False
      OnClick = SliceInfo1Click
    end
  end
  object logo_ProfilListeMenue: TPopupMenu
    OnPopup = LogoProfileWertePruefen
    Left = 360
    Top = 232
    object LogoMenue_Loeschen: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = logoProfil_LoeschenClick
    end
    object LogoMenue_Aendern: TMenuItem
      Caption = #196'ndern'
      OnClick = LogoProfil_AendernClick
    end
    object LogoMenue_Neu: TMenuItem
      Caption = 'Neu'
      OnClick = LogoProfil_neuClick
    end
  end
  object Letterboxed_ProfilListeMenue: TPopupMenu
    OnPopup = LetterboxedWertePruefen
    Left = 336
    Top = 168
    object LetterboxedMenue_Loeschen: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = LetterboxedMenue_LoeschenClick
    end
    object LetterboxedMenue_Aendern: TMenuItem
      Caption = #196'ndern'
      OnClick = Letterboxed_AendernBtnClick
    end
    object LetterboxedMenue_Neu: TMenuItem
      Caption = 'Neu'
      OnClick = Letterboxed_NeuBtnClick
    end
  end
  object Analyse_Menu: TPopupMenu
    OnPopup = AnalyseWertePruefen
    Left = 328
    Top = 96
    object Analyse_ListeLeeren: TMenuItem
      Caption = 'Liste leeren'
      OnClick = Analyse_ListeLeerenClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Analyse_speichern: TMenuItem
      Caption = 'speichern'
      OnClick = Analyse_speichernClick
    end
  end
  object DateiSpeichernDialog: TSaveDialog
    Left = 416
    Top = 96
  end
end
