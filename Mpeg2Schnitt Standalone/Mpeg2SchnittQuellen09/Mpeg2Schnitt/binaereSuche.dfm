object binaereSucheForm: TbinaereSucheForm
  Left = 1047
  Top = 505
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'bin'#228're Suche'
  ClientHeight = 57
  ClientWidth = 202
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PopupMenu = binaereSuchePopup
  PixelsPerInch = 96
  TextHeight = 13
  object FensterPanel: TPanel
    Left = 0
    Top = 0
    Width = 202
    Height = 57
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      202
      57)
    object FilmPosition_: TLabel
      Left = 23
      Top = 5
      Width = 57
      Height = 13
      Hint = 'aktuelle Videoposition'
      Caption = '00:00:00:00'
    end
    object binaereSucheFilm: TSpeedButton
      Left = 8
      Top = 20
      Width = 86
      Height = 29
      Hint = 'das angezeigte Bild gek'#246'rt zum Film'
      AllowAllUp = True
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'Film'
      Enabled = False
      NumGlyphs = 2
      OnClick = binaereSucheClick
    end
    object WerbePosition_: TLabel
      Left = 123
      Top = 5
      Width = 57
      Height = 13
      Hint = 'aktuelle Videoposition'
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = '00:00:00:00'
    end
    object binaereSucheWerbung: TSpeedButton
      Left = 108
      Top = 20
      Width = 86
      Height = 29
      Hint = 'das angezeigte Bild ist Werbung'
      AllowAllUp = True
      Anchors = [akTop, akRight, akBottom]
      Caption = 'Werbung'
      Enabled = False
      NumGlyphs = 2
      OnClick = binaereSucheClick
    end
  end
  object binaereSuchePopup: TPopupMenu
    Left = 100
    Top = 10
    object binaereSucheSchliessen: TMenuItem
      Caption = 'Fenster schliessen'
      OnClick = binaereSucheSchliessenClick
    end
    object FensterimVordergrund: TMenuItem
      Caption = 'immer im Vordergrund'
      OnClick = FensterimVordergrundClick
    end
    object FenstermitRahmen: TMenuItem
      Caption = 'Fenster mit Rahmen'
      OnClick = FenstermitRahmenClick
    end
  end
end
