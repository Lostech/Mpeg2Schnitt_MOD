object ProjectXForm: TProjectXForm
  Left = 233
  Top = 125
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'ProjectX Import'
  ClientHeight = 317
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 4
    Top = 280
    Width = 625
    Height = 33
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Button7: TButton
      Left = 308
      Top = 4
      Width = 73
      Height = 25
      Caption = 'Abbruch'
      TabOrder = 6
      OnClick = Button7Click
    end
    object Button3: TButton
      Left = 68
      Top = 4
      Width = 73
      Height = 25
      Caption = 'Liste l'#246'schen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 148
      Top = 4
      Width = 73
      Height = 25
      Caption = 'Import'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 228
      Top = 4
      Width = 73
      Height = 25
      Caption = 'Umwandlung'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 308
      Top = 4
      Width = 73
      Height = 25
      Caption = 'Beenden'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Button6Click
    end
    object Button1: TButton
      Left = 4
      Top = 4
      Width = 25
      Height = 25
      Caption = '+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 36
      Top = 4
      Width = 25
      Height = 25
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = Button2Click
    end
  end
  object Memo1: TMemo
    Left = 412
    Top = 284
    Width = 157
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    OnChange = Memo1Change
  end
  object ListView1: TListView
    Left = 4
    Top = 84
    Width = 577
    Height = 193
    Columns = <
      item
        AutoSize = True
        Caption = 'Datei'
      end
      item
        Caption = 'Typ'
        MaxWidth = 100
        MinWidth = 100
      end
      item
        AutoSize = True
        Caption = 'Pfad'
      end
      item
        AutoSize = True
        Caption = 'Gr'#246#223'e'
        MaxWidth = 100
        MinWidth = 100
      end>
    FlatScrollBars = True
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnCompare = ListView1Compare
  end
  object Panel2: TPanel
    Left = 4
    Top = 4
    Width = 625
    Height = 77
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 125
      Height = 13
      Cursor = crHandPoint
      AutoSize = False
      Caption = 'ProjectX Pfad:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
      OnClick = Label1Click
    end
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 125
      Height = 13
      Cursor = crHandPoint
      AutoSize = False
      Caption = 'JAVA Runtime Pfad:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
      OnClick = Label2Click
    end
    object Label3: TLabel
      Left = 8
      Top = 56
      Width = 125
      Height = 13
      Cursor = crHandPoint
      AutoSize = False
      Caption = 'ProjectX Ausgabe Ordner:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
      OnClick = Label3Click
    end
    object Label4: TLabel
      Left = 140
      Top = 24
      Width = 481
      Height = 13
      Cursor = crHandPoint
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label5: TLabel
      Left = 140
      Top = 40
      Width = 481
      Height = 13
      Cursor = crHandPoint
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label6: TLabel
      Left = 140
      Top = 56
      Width = 481
      Height = 13
      Cursor = crHandPoint
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object Label7: TLabel
      Left = 8
      Top = 4
      Width = 125
      Height = 13
      AutoSize = False
      Caption = 'Einstellungen:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      Transparent = True
    end
  end
  object Panel3: TPanel
    Left = 584
    Top = 84
    Width = 45
    Height = 193
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    object Button8: TButton
      Left = 4
      Top = 4
      Width = 37
      Height = 25
      Caption = 'hoch'
      Enabled = False
      TabOrder = 0
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 4
      Top = 32
      Width = 37
      Height = 25
      Caption = 'runter'
      Enabled = False
      TabOrder = 1
      OnClick = Button9Click
    end
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 308
    Top = 172
  end
  object JvCreateProcess1: TJvCreateProcess
    StartupInfo.DefaultSize = False
    StartupInfo.ShowWindow = swHide
    StartupInfo.DefaultWindowState = False
    OnTerminate = JvCreateProcess1Terminate
    OnRead = JvCreateProcess1Read
    OnRawRead = JvCreateProcess1RawRead
    Left = 364
    Top = 172
  end
  object Timer1: TTimer
    Left = 392
    Top = 172
  end
  object JvBrowseForFolderDialog1: TJvBrowseForFolderDialog
    Left = 336
    Top = 172
  end
  object JvSearchFiles1: TJvSearchFiles
    OnFindFile = JvSearchFiles1FindFile
    Left = 420
    Top = 172
  end
end
