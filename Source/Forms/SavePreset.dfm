object SavePresetForm: TSavePresetForm
  Left = 295
  Top = 331
  BorderStyle = bsDialog
  Caption = 'Save Preset'
  ClientHeight = 66
  ClientWidth = 349
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    349
    66)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 190
    Top = 37
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 270
    Top = 37
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object pnlName: TPanel
    Left = 8
    Top = 8
    Width = 101
    Height = 21
    Cursor = crArrow
    BevelOuter = bvLowered
    Caption = 'Name'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object txtPresetName: TEdit
    Left = 104
    Top = 8
    Width = 239
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
end
