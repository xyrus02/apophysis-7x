object CurvesForm: TCurvesForm
  Left = 197
  Top = 111
  BorderStyle = bsDialog
  Caption = 'Curves'
  ClientHeight = 492
  ClientWidth = 489
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 75
    Height = 13
    Caption = 'Selected curve:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object CurvesPanel: TPanel
    Left = 8
    Top = 68
    Width = 473
    Height = 414
    BevelOuter = bvNone
    Color = clBlack
    ParentBackground = False
    TabOrder = 0
  end
  object cbChannel: TComboBox
    Left = 8
    Top = 35
    Width = 185
    Height = 21
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemIndex = 0
    ParentFont = False
    TabOrder = 1
    Text = 'Overall'
    OnChange = cbChannelChange
    Items.Strings = (
      'Overall'
      'Red'
      'Green'
      'Blue')
  end
  object tbWeightLeft: TScrollBar
    Left = 326
    Top = 8
    Width = 155
    Height = 21
    Max = 160
    PageSize = 0
    Position = 80
    TabOrder = 2
    OnChange = tbWeightChange
    OnScroll = tbWeightScroll
  end
  object tbWeightRight: TScrollBar
    Left = 326
    Top = 35
    Width = 155
    Height = 21
    Max = 160
    PageSize = 0
    Position = 80
    TabOrder = 3
    OnChange = tbWeightChange
    OnScroll = tbWeightScroll
  end
  object Panel2: TPanel
    Left = 199
    Top = 8
    Width = 121
    Height = 21
    Cursor = crHandPoint
    BevelOuter = bvLowered
    Caption = ' First CP weight:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 199
    Top = 35
    Width = 121
    Height = 21
    Cursor = crHandPoint
    BevelOuter = bvLowered
    Caption = ' Second CP weight:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
  end
end
