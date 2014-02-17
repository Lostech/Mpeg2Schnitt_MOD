object Textfenster: TTextfenster
  Left = 575
  Top = 167
  Width = 655
  Height = 558
  ActiveControl = OkTaste
  Caption = 'Textfenster'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    647
    531)
  PixelsPerInch = 96
  TextHeight = 14
  object OkTaste: TButton
    Left = 287
    Top = 496
    Width = 78
    Height = 26
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Text: TMemo
    Left = 0
    Top = 0
    Width = 648
    Height = 481
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WantReturns = False
    WordWrap = False
  end
end
