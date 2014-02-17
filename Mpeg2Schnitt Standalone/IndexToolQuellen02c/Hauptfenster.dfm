object IndexTool: TIndexTool
  Left = 723
  Top = 171
  Width = 504
  Height = 450
  Caption = 'IndexTool'
  Color = clBtnFace
  Constraints.MinHeight = 450
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = Hauptmenue
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 196
    Top = 8
    Width = 55
    Height = 13
    Caption = 'Gesamtzeit:'
  end
  object Label2: TLabel
    Left = 260
    Top = 8
    Width = 27
    Height = 13
    Caption = '00:00'
  end
  object Tastenpanel: TPanel
    Left = 0
    Top = 232
    Width = 496
    Height = 172
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      496
      172)
    object Gesamtgroesse_: TLabel
      Left = 8
      Top = 60
      Width = 128
      Height = 13
      Caption = 'Gesamtgr'#246#223'e aller Dateien:'
    end
    object Gesamtgroesse: TLabel
      Left = 140
      Top = 60
      Width = 25
      Height = 13
      Caption = '0 MB'
    end
    object aktDateigroesse_: TLabel
      Left = 8
      Top = 8
      Width = 95
      Height = 13
      Caption = 'aktuelle Dateigr'#246#223'e:'
    end
    object aktDateigroesse: TLabel
      Left = 140
      Top = 8
      Width = 25
      Height = 13
      Caption = '0 MB'
    end
    object Gesamtzeit_: TLabel
      Left = 384
      Top = 8
      Width = 55
      Height = 13
      Caption = 'Gesamtzeit:'
    end
    object GesamtzeitDatei: TLabel
      Left = 440
      Top = 8
      Width = 42
      Height = 13
      Caption = '00:00:00'
    end
    object Restzeit: TLabel
      Left = 292
      Top = 8
      Width = 41
      Height = 13
      Caption = 'Restzeit:'
    end
    object RestzeitDatei: TLabel
      Left = 332
      Top = 8
      Width = 42
      Height = 13
      Caption = '00:00:00'
    end
    object Zeit_: TLabel
      Left = 216
      Top = 8
      Width = 21
      Height = 13
      Caption = 'Zeit:'
    end
    object ZeitDatei: TLabel
      Left = 236
      Top = 8
      Width = 42
      Height = 13
      Caption = '00:00:00'
    end
    object Zeit__: TLabel
      Left = 216
      Top = 60
      Width = 21
      Height = 13
      Caption = 'Zeit:'
    end
    object ZeitGesamt: TLabel
      Left = 236
      Top = 60
      Width = 42
      Height = 13
      Caption = '00:00:00'
    end
    object Restzeit__: TLabel
      Left = 292
      Top = 60
      Width = 41
      Height = 13
      Caption = 'Restzeit:'
    end
    object RestzeitGesamt: TLabel
      Left = 332
      Top = 60
      Width = 42
      Height = 13
      Caption = '00:00:00'
    end
    object Gesamtzeit__: TLabel
      Left = 384
      Top = 60
      Width = 55
      Height = 13
      Caption = 'Gesamtzeit:'
    end
    object GesamtzeitGesamt: TLabel
      Left = 440
      Top = 60
      Width = 42
      Height = 13
      Caption = '00:00:00'
    end
    object Start: TBitBtn
      Left = 337
      Top = 124
      Width = 150
      Height = 40
      Anchors = [akTop, akRight]
      Caption = 'Start/Ende'
      TabOrder = 0
      OnClick = StartClick
    end
    object Abbrechen: TBitBtn
      Left = 8
      Top = 124
      Width = 150
      Height = 40
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = AbbrechenClick
    end
    object FortschrittDatei: TProgressBar
      Left = 9
      Top = 24
      Width = 476
      Height = 30
      Min = 0
      Max = 100
      TabOrder = 2
    end
    object Fortschrittgesamt: TProgressBar
      Left = 9
      Top = 76
      Width = 476
      Height = 30
      Min = 0
      Max = 100
      TabOrder = 3
    end
    object Ausschalten: TCheckBox
      Left = 180
      Top = 148
      Width = 133
      Height = 17
      Caption = 'Rechner ausschalten'
      TabOrder = 4
    end
    object Fenster_schliessen: TCheckBox
      Left = 180
      Top = 124
      Width = 117
      Height = 17
      Caption = 'Fenster schlie'#223'en'
      TabOrder = 5
    end
  end
  object DateienGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 496
    Height = 232
    Align = alClient
    ColCount = 3
    DefaultColWidth = 100
    DefaultRowHeight = 16
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    PopupMenu = MenueDateienfenster
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Hauptmenue: TMainMenu
    Left = 160
    object Datei: TMenuItem
      Caption = '&Datei'
      object Dateiladen: TMenuItem
        Caption = 'Audio/Video hinzuf'#252'gen'
        OnClick = DateiladenClick
      end
      object Ende: TMenuItem
        Caption = 'Ende'
        OnClick = AbbrechenClick
      end
    end
    object Ueber: TMenuItem
      Caption = 'Information'
      OnClick = UeberClick
    end
  end
  object Dateiladendialog: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 124
  end
  object MenueDateienfenster: TPopupMenu
    Left = 196
    object Dateihinzufuegen: TMenuItem
      Caption = 'Audio/Video hinzuf'#252'gen'
      OnClick = DateiladenClick
    end
    object Dateientfernen: TMenuItem
      Caption = 'Datei entfernen'
      OnClick = DateientfernenClick
    end
  end
end
