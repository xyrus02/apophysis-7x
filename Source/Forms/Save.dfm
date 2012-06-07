object SaveForm: TSaveForm
  Left = 434
  Top = 432
  BorderStyle = bsDialog
  Caption = 'Save Parameters'
  ClientHeight = 153
  ClientWidth = 517
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    517
    153)
  PixelsPerInch = 120
  TextHeight = 16
  object btnDefGradient: TSpeedButton
    Left = 480
    Top = 9
    Width = 30
    Height = 29
    Hint = 'Browse...'
    Anchors = [akTop, akRight]
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF75848F66808F
      607987576E7B4E626F4456613948522E3A43252E351B222914191E0E12160E13
      18FF00FFFF00FFFF00FF77879289A1AB6AB2D4008FCD008FCD008FCD048CC708
      88BE0F82B4157CA91B779F1F7296224B5C87A2ABFF00FFFF00FF7A8A957EBED3
      8AA4AE7EDCFF5FCFFF55CBFF4CC4FA41BCF537B3F02EAAEB24A0E5138CD42367
      805E696DFF00FFFF00FF7D8E9879D2EC8BA4AD89C2CE71D8FF65D3FF5CCEFF51
      C9FE49C1FA3FB9F534B0EE29A8E91085CD224B5B98B2BAFF00FF80919C81D7EF
      7DC5E08CA6B080DDFE68D3FF67D4FF62D1FF58CDFF4EC7FC46BEF73BB6F231AC
      EC2569817A95A1FF00FF83959F89DCF18CE2FF8DA8B18CBAC774D8FF67D4FF67
      D4FF67D4FF5FD0FF54CDFF4BC5FC41BBF72EA2DB51677498B2BA869AA392E1F2
      98E8FD80C4DE8EA7B081DEFD84E0FF84E0FF84E0FF84E0FF81DFFF7BDDFF74D8
      FF6BD6FF56A9D18F9BA4889CA59AE6F39FEBFB98E8FE8BACB98BACB98AAAB788
      A6B386A3AF839FAA819AA67F95A17C919D7A8E99798B957788938BA0A8A0EAF6
      A6EEF99FEBFB98E8FE7ADAFF67D4FF67D4FF67D4FF67D4FF67D4FF67D4FF7788
      93FF00FFFF00FFFF00FF8EA2ABA7EEF6ABF0F7A6EEF99FEBFB98E8FD71D4FB89
      9EA78699A382949F7E909A7A8C97778893FF00FFFF00FFFF00FF8FA4ACA0D2DA
      ABF0F7ABF0F7A6EEF99FEBFB8DA1AAB5CBD0FF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFBDCED48FA4AC8FA4AC8FA4AC8FA4AC8FA4ACB5CBD0FF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = btnDefGradientClick
  end
  object btnSave: TButton
    Left = 322
    Top = 116
    Width = 93
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = '&Save'
    Default = True
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 421
    Top = 116
    Width = 92
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object pnlTarget: TPanel
    Left = 10
    Top = 10
    Width = 124
    Height = 26
    Cursor = crArrow
    BevelOuter = bvLowered
    Caption = 'Destination'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object pnlName: TPanel
    Left = 10
    Top = 39
    Width = 124
    Height = 26
    Cursor = crArrow
    BevelOuter = bvLowered
    Caption = 'Name'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
  end
  object txtFilename: TEdit
    Left = 128
    Top = 10
    Width = 353
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'txtFilename'
  end
  object txtTitle: TEdit
    Left = 128
    Top = 39
    Width = 383
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'txtTitle'
  end
  object optUseOldFormat: TRadioButton
    Left = 10
    Top = 79
    Width = 304
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Use classic flame format'
    Checked = True
    TabOrder = 6
    TabStop = True
  end
  object optUseNewFormat: TRadioButton
    Left = 10
    Top = 101
    Width = 304
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Use new flame format'
    Enabled = False
    TabOrder = 7
  end
end
