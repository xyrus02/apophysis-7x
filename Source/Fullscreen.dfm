object FullscreenForm: TFullscreenForm
  Left = 438
  Top = 324
  BorderStyle = bsNone
  Caption = 'FullscreenForm'
  ClientHeight = 133
  ClientWidth = 188
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage
    Left = 0
    Top = 0
    Width = 188
    Height = 133
    Align = alClient
    OnDblClick = ImageDblClick
  end
end
