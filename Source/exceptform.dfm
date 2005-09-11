object frmException: TfrmException
  Left = 475
  Top = 337
  Width = 611
  Height = 453
  Caption = 'An exception occured'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    603
    419)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 148
    Top = 380
    Width = 263
    Height = 13
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'Please  mail this message to Ronald.Hordijk@gmail.com'
  end
  object Button1: TButton
    Left = 16
    Top = 376
    Width = 75
    Height = 25
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'Exit'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 585
    Height = 353
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
  end
end
