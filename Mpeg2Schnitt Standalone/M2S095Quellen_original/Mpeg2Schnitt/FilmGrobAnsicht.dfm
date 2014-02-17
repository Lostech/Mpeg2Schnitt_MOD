object FilmGrobAnsichtFrm: TFilmGrobAnsichtFrm
  Left = 363
  Top = 382
  Width = 800
  Height = 404
  BorderStyle = bsSizeToolWin
  Caption = 'Film'#252'bersicht'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poDefault
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 792
    Height = 1
    Align = alTop
    TabOrder = 0
  end
  object FensterPanel: TPanel
    Left = 0
    Top = 1
    Width = 792
    Height = 369
    Align = alClient
    BevelOuter = bvNone
    Caption = 'FensterPanel'
    TabOrder = 1
    object GrobansichtScrollBox: TScrollBox
      Left = 0
      Top = 38
      Width = 792
      Height = 331
      HorzScrollBar.Tracking = True
      VertScrollBar.Tracking = True
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      PopupMenu = FensterPopup
      TabOrder = 0
      object BildPanel: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 237
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
    object GrossansichtSymbolleistePanel: TPanel
      Left = 0
      Top = 0
      Width = 792
      Height = 38
      Align = alTop
      Color = clActiveBorder
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object AuffrischenBtn: TSpeedButton
        Left = 3
        Top = 3
        Width = 32
        Height = 32
        Hint = 'Bilder der Gro'#223'ansicht neu laden'
        Caption = 'A'
        OnClick = AuffrischenBtnClick
      end
      object bSuchesetzenBtn: TSpeedButton
        Left = 40
        Top = 3
        Width = 32
        Height = 32
        Hint = 'bin'#228're Suche zur'#252'cksetzen'
        Caption = 'R'
        OnClick = bSuchesetzenBtnClick
      end
      object binaereSucheBtn1: TBitBtn
        Left = 144
        Top = 3
        Width = 90
        Height = 32
        Caption = '00:00:00:00'
        Enabled = False
        TabOrder = 0
        OnClick = binaereSucheBtnClick
      end
      object binaereSucheBtn2: TBitBtn
        Left = 240
        Top = 3
        Width = 90
        Height = 32
        Caption = '00:00:00:00'
        Enabled = False
        TabOrder = 1
        OnClick = binaereSucheBtnClick
      end
    end
  end
  object FensterPopup: TPopupMenu
    Left = 730
    Top = 44
    object AuffrischenItemIndex: TMenuItem
      Caption = 'Bildanzeige auffrischen'
      OnClick = AuffrischenBtnClick
    end
    object bSuchesetzenItemIndex: TMenuItem
      Caption = 'bin'#228're Suche zur'#252'cksetzen'
      OnClick = bSuchesetzenBtnClick
    end
    object Trennlinie1: TMenuItem
      Caption = '-'
    end
    object FensterSchliessen: TMenuItem
      Caption = 'Fenster schliessen'
      OnClick = FensterSchliessenClick
    end
    object FensterimVordergrund: TMenuItem
      Caption = 'immer im Vordergrund'
      OnClick = FensterimVordergrundClick
    end
    object FenstermitRahmen: TMenuItem
      Caption = 'Fenster mit Rahmen'
      Checked = True
      OnClick = FenstermitRahmenClick
    end
    object FensterSymbolleiste: TMenuItem
      Caption = 'Symbolleiste'
      Checked = True
      OnClick = FensterSymbolleisteClick
    end
  end
  object Dummy: TPopupMenu
    Left = 762
    Top = 45
  end
end
