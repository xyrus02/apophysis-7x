object ScriptRenderForm: TScriptRenderForm
  Left = 390
  Top = 391
  BorderStyle = bsDialog
  Caption = 'ScriptRenderForm'
  ClientHeight = 62
  ClientWidth = 268
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 96
    Top = 32
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 8
    Width = 249
    Height = 13
    TabOrder = 1
  end
end
