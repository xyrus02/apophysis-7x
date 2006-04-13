object FullscreenForm: TFullscreenForm
  Left = 439
  Top = 325
  BorderStyle = bsNone
  Caption = 'FullscreenForm'
  ClientHeight = 131
  ClientWidth = 186
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
    Width = 186
    Height = 131
    OnDblClick = ImageDblClick
  end
end
