object SavePresetForm: TSavePresetForm
  Left = 295
  Top = 331
  BorderStyle = bsDialog
  Caption = 'Save Preset'
  ClientHeight = 77
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 4
    Width = 62
    Height = 13
    Caption = 'Preset name:'
  end
  object txtPresetName: TEdit
    Left = 8
    Top = 20
    Width = 305
    Height = 21
    TabOrder = 0
  end
  object Button1: TButton
    Left = 88
    Top = 48
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 168
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
