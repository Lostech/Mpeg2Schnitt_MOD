object DVDForm: TDVDForm
  Left = 351
  Top = 26
  BorderStyle = bsToolWindow
  Caption = 'DVDForm'
  ClientHeight = 593
  ClientWidth = 601
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
  object Memo2: TMemo
    Left = 4
    Top = 4
    Width = 593
    Height = 277
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
    OnChange = Memo2Change
  end
  object Panel2: TPanel
    Left = 4
    Top = 388
    Width = 593
    Height = 201
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 564
      Top = 8
      Width = 23
      Height = 22
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      OnClick = SpeedButton1Click
    end
    object Label1: TLabel
      Left = 8
      Top = 36
      Width = 109
      Height = 13
      AutoSize = False
      Caption = 'DVD Name'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 264
      Top = 64
      Width = 97
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      BiDiMode = bdLeftToRight
      Caption = 'Anzahl Kapitel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 12
      Width = 109
      Height = 13
      AutoSize = False
      Caption = 'Arbeitsverzeichnis'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 264
      Top = 112
      Width = 96
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Multiplexer'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 264
      Top = 136
      Width = 97
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'DVD Rekorder'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object SpeedButton2: TSpeedButton
      Left = 564
      Top = 132
      Width = 23
      Height = 22
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF606060404040FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF3F3F3F404040404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF2020203F3F3FFFFFFF404040404040FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040606060404040AF
        AFAFFFFFFF404040808080808080404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF2020206F6F6FAFAFAFFFFFFFFFFFFFFFFFFFAFAFAF6F6F6F4040408080
        80606060FFFFFFFFFFFFFFFFFFFFFFFF3F3F3FEFEFEFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFEFEFEF5F5F5F808080606060FFFFFFFFFFFF5F5F5F
        FFFFFFFFFFFFFFFFFFFFBFBFFF7F7FFF7F7FFF7F7FFF7F7FFFFFFFFFFFFFFFFF
        FF5F5F5F808080404040404040EFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
        0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFEFEFEF404040808080AFAFAFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF6F6F6F808080BFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFF
        0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F808080BFBFBFFFFFFF
        FFFFFFFFFFFFFFFFFFFFBFBFFF3F3FFF0000FF0000FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF7F7F7F606060707070FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF505050202020202020CFCFCF
        FFFFFFFFFFFFFFFFFFFFFFFFEF3030FF0000EF3030FFFFFFFFFFFFFFFFFFFFFF
        FFAFAFAF000000FFFFFFFFFFFF202020DFDFDFFFFFFFFFFFFFFFFFFFEF3030FF
        0000EF3030FFFFFFFFFFFFFFFFFFBFBFBF000000FFFFFFFFFFFFFFFFFFFFFFFF
        202020AFAFAFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFAFAFAF2020
        20FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040707070BFBFBFBF
        BFBFBFBFBF707070404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Left = 564
      Top = 84
      Width = 23
      Height = 22
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      OnClick = SpeedButton3Click
    end
    object Label6: TLabel
      Left = 264
      Top = 88
      Width = 97
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      BiDiMode = bdLeftToRight
      Caption = 'Manuelle Kapitel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
    end
    object Button5: TButton
      Left = 368
      Top = 168
      Width = 113
      Height = 25
      Caption = 'Abbruch'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
      OnClick = Button5Click
    end
    object Edit1: TEdit
      Left = 124
      Top = 32
      Width = 113
      Height = 21
      AutoSize = False
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 15
      ParentFont = False
      TabOrder = 0
    end
    object JvSpinEdit1: TJvSpinEdit
      Left = 368
      Top = 60
      Width = 41
      Height = 21
      MaxValue = 50.000000000000000000
      MinValue = 1.000000000000000000
      Value = 10.000000000000000000
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = JvSpinEdit1Change
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 96
      Width = 245
      Height = 17
      Caption = 'ISO Image erstellen'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 112
      Width = 245
      Height = 17
      Caption = 'IFOs/VOBs nach ISO Image Erstellung l'#246'schen'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 64
      Width = 245
      Height = 17
      Caption = 'Kapitel automatisch erzeugen'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 4
      OnClick = CheckBox3Click
    end
    object Edit2: TEdit
      Left = 124
      Top = 8
      Width = 433
      Height = 21
      AutoSize = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object Button1: TButton
      Left = 8
      Top = 168
      Width = 113
      Height = 25
      Caption = 'TitleSet hinzuf'#252'gen'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 128
      Top = 168
      Width = 113
      Height = 25
      Caption = 'TitleSet entfernen'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 368
      Top = 168
      Width = 113
      Height = 25
      Caption = 'Beenden'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 248
      Top = 168
      Width = 113
      Height = 25
      Caption = 'DVD erstellen'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = Button4Click
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 128
      Width = 245
      Height = 17
      Caption = 'ISO Image brennen'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      OnClick = CheckBox4Click
    end
    object CheckBox5: TCheckBox
      Left = 8
      Top = 144
      Width = 245
      Height = 17
      Caption = 'ISO Image nach Brennvorgang l'#246'schen'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
    end
    object ComboBox1: TComboBox
      Left = 368
      Top = 108
      Width = 189
      Height = 21
      Style = csDropDownList
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      ItemIndex = 0
      ParentFont = False
      TabOrder = 12
      Text = 'MPLEX'
      Items.Strings = (
        'MPLEX'
        'TCMPLEX-PANTELTJE')
    end
    object JvDriveCombo1: TJvDriveCombo
      Left = 368
      Top = 132
      Width = 189
      Height = 22
      DriveTypes = [dtCDROM]
      Offset = 4
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 14
      OnChange = JvDriveCombo1Change
    end
    object CheckBox6: TCheckBox
      Left = 8
      Top = 80
      Width = 245
      Height = 17
      Caption = 'Kapitel manuell vorgeben'
      TabOrder = 15
      OnClick = CheckBox6Click
    end
    object ListBox1: TListBox
      Left = 368
      Top = 84
      Width = 189
      Height = 21
      AutoComplete = False
      ExtendedSelect = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 16
    end
  end
  object Panel1: TPanel
    Left = 4
    Top = 4
    Width = 593
    Height = 277
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 4
      Top = 4
      Width = 585
      Height = 269
      TabOrder = 0
    end
  end
  object Memo1: TMemo
    Left = 4
    Top = 284
    Width = 593
    Height = 101
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object OpenDialog1: TOpenDialog
    Left = 12
    Top = 252
  end
  object JvBrowseForFolderDialog1: TJvBrowseForFolderDialog
    Options = [odOnlyDirectory, odStatusAvailable, odEditBox, odNewDialogStyle]
    Left = 40
    Top = 252
  end
  object JvCreateProcess1: TJvCreateProcess
    StartupInfo.DefaultPosition = False
    StartupInfo.DefaultSize = False
    StartupInfo.ShowWindow = swHide
    StartupInfo.DefaultWindowState = False
    ConsoleOptions = [coRedirect]
    OnRawRead = JvCreateProcess1RawRead
    Left = 68
    Top = 252
  end
  object Timer1: TTimer
    Left = 124
    Top = 252
  end
  object JvCreateProcess2: TJvCreateProcess
    StartupInfo.ForceOnFeedback = True
    StartupInfo.ForceOffFeedback = True
    OnTerminate = JvCreateProcess2Terminate
    OnRawRead = JvCreateProcess1RawRead
    Left = 96
    Top = 252
  end
end
