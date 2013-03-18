object ScriptRenderForm: TScriptRenderForm
  Left = 390
  Top = 391
  BorderStyle = bsDialog
  Caption = 'ScriptRenderForm'
  ClientHeight = 58
  ClientWidth = 285
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    285
    58)
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 96
    Top = 28
    Width = 95
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = '&Cancel'
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 8
    Width = 271
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
end
