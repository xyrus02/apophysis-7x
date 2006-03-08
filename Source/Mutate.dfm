object MutateForm: TMutateForm
  Left = 407
  Top = 207
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Mutation'
  ClientHeight = 381
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010000000000000680300001600000028000000100000002000
    0000010018000000000040030000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000056B9F5000000
    00000000000000000056B9F500000000000000000000000056B9F50000000000
    0000000000000000000056B9F500000000000000000000000056B9F500000000
    000000000000000056B9F500000000000000000000000000000056B9F5000000
    00000000000000000056B9F500000000000000000000000056B9F50000000000
    0056B9F556B9F556B9F556B9F500000056B9F556B9F556B9F556B9F500000056
    B9F556B9F556B9F556B9F5000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000056B9F500000000000000000000000056B9F500000000
    000000000000000056B9F500000000000000000000000000000056B9F5000000
    00000000000000000056B9F500000000000000000000000056B9F50000000000
    0000000000000000000056B9F500000000000000000000000056B9F500000000
    000000000000000056B9F500000000000056B9F556B9F556B9F556B9F5000000
    56B9F556B9F556B9F556B9F500000056B9F556B9F556B9F556B9F50000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000056B9F5000000
    00000000000000000056B9F500000000000000000000000056B9F50000000000
    0000000000000000000056B9F500000000000000000000000056B9F500000000
    000000000000000056B9F500000000000000000000000000000056B9F5000000
    00000000000000000056B9F500000000000000000000000056B9F50000000000
    0056B9F556B9F556B9F556B9F500000056B9F556B9F556B9F556B9F500000056
    B9F556B9F556B9F556B9F5000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    000084210000842100008421000084210000FFFF000084210000842100008421
    000084210000FFFF000084210000842100008421000084210000FFFF0000}
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 357
    Height = 283
    Caption = 'Directions'
    TabOrder = 0
    object Panel1: TPanel
      Left = 12
      Top = 20
      Width = 108
      Height = 80
      BevelOuter = bvLowered
      Caption = 'PrevPnl3'
      Color = clBlack
      TabOrder = 1
      object Image1: TImage
        Left = 1
        Top = 1
        Width = 106
        Height = 78
        Align = alClient
        PopupMenu = QualityPopup
        Stretch = True
        OnClick = MutantClick
      end
    end
    object Panel2: TPanel
      Left = 124
      Top = 20
      Width = 108
      Height = 80
      BevelOuter = bvLowered
      Caption = 'PrevPnl3'
      Color = clBlack
      TabOrder = 2
      object Image2: TImage
        Left = 1
        Top = 1
        Width = 106
        Height = 78
        Align = alClient
        PopupMenu = QualityPopup
        Stretch = True
        OnClick = MutantClick
      end
    end
    object Panel3: TPanel
      Left = 236
      Top = 20
      Width = 108
      Height = 80
      BevelOuter = bvLowered
      Caption = 'PrevPnl3'
      Color = clBlack
      TabOrder = 3
      object Image3: TImage
        Left = 1
        Top = 1
        Width = 106
        Height = 78
        Align = alClient
        PopupMenu = QualityPopup
        Stretch = True
        OnClick = MutantClick
      end
    end
    object Panel8: TPanel
      Left = 12
      Top = 104
      Width = 108
      Height = 80
      BevelOuter = bvLowered
      Caption = 'PrevPnl3'
      Color = clBlack
      TabOrder = 4
      object Image8: TImage
        Left = 1
        Top = 1
        Width = 106
        Height = 78
        Align = alClient
        PopupMenu = QualityPopup
        Stretch = True
        OnClick = MutantClick
      end
    end
    object Panel0: TPanel
      Left = 124
      Top = 104
      Width = 108
      Height = 80
      HelpContext = 2003
      BevelOuter = bvLowered
      Caption = 'PrevPnl3'
      Color = clBlack
      TabOrder = 0
      object Image0: TImage
        Left = 1
        Top = 1
        Width = 106
        Height = 78
        Align = alClient
        PopupMenu = QualityPopup
        Stretch = True
        OnClick = Image0Click
      end
    end
    object Panel4: TPanel
      Left = 236
      Top = 104
      Width = 108
      Height = 80
      BevelOuter = bvLowered
      Caption = 'PrevPnl3'
      Color = clBlack
      TabOrder = 5
      object Image4: TImage
        Left = 1
        Top = 1
        Width = 106
        Height = 78
        Align = alClient
        PopupMenu = QualityPopup
        Stretch = True
        OnClick = MutantClick
      end
    end
    object Panel7: TPanel
      Left = 12
      Top = 188
      Width = 108
      Height = 80
      BevelOuter = bvLowered
      Caption = 'PrevPnl3'
      Color = clBlack
      TabOrder = 6
      object Image7: TImage
        Left = 1
        Top = 1
        Width = 106
        Height = 78
        Align = alClient
        PopupMenu = QualityPopup
        Stretch = True
        OnClick = MutantClick
      end
    end
    object Panel6: TPanel
      Left = 124
      Top = 188
      Width = 108
      Height = 80
      BevelOuter = bvLowered
      Caption = 'PrevPnl3'
      Color = clBlack
      TabOrder = 7
      object Image6: TImage
        Left = 1
        Top = 1
        Width = 106
        Height = 78
        Align = alClient
        PopupMenu = QualityPopup
        Stretch = True
        OnClick = MutantClick
      end
    end
    object Panel5: TPanel
      Left = 236
      Top = 188
      Width = 108
      Height = 80
      BevelOuter = bvLowered
      Caption = 'PrevPnl3'
      Color = clBlack
      TabOrder = 8
      object Image5: TImage
        Left = 1
        Top = 1
        Width = 106
        Height = 78
        Align = alClient
        PopupMenu = QualityPopup
        Stretch = True
        OnClick = MutantClick
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 296
    Width = 357
    Height = 81
    Caption = 'Controls'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 52
      Width = 31
      Height = 13
      Caption = 'Trend:'
    end
    object Label2: TLabel
      Left = 8
      Top = 23
      Width = 34
      Height = 13
      Caption = 'Speed:'
    end
    object lblTime: TLabel
      Left = 320
      Top = 23
      Width = 6
      Height = 13
      Caption = '0'
    end
    object scrollTime: TScrollBar
      Left = 48
      Top = 24
      Width = 265
      Height = 13
      LargeChange = 5
      Max = 50
      Min = 1
      PageSize = 0
      Position = 1
      TabOrder = 0
      OnChange = scrollTimeChange
    end
    object cmbTrend: TComboBox
      Left = 56
      Top = 48
      Width = 145
      Height = 21
      Style = csDropDownList
      DropDownCount = 16
      ItemHeight = 13
      TabOrder = 1
      OnChange = cmbTrendChange
      Items.Strings = (
        'Random'
        'Linear'
        'Sinusoidal'
        'Spherical'
        'Swirl'
        'Horseshoe'
        'Polar'
        'Handkerchief'
        'Heart'
        'Disc'
        'Spiral'
        'Hyperbolic'
        'Diamond'
        'Ex'
        'Julia'
        'Bent'
        'Waves'
        'Fisheye'
        'Popcorn')
    end
    object chkSameNum: TCheckBox
      Left = 208
      Top = 50
      Width = 129
      Height = 17
      Caption = 'Same no. of transforms'
      TabOrder = 2
      OnClick = chkSameNumClick
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 80
    Top = 40
  end
  object QualityPopup: TPopupMenu
    Images = MainForm.Buttons
    Left = 144
    Top = 40
    object mnuLowQuality: TMenuItem
      Caption = 'Low Quality'
      RadioItem = True
      OnClick = mnuLowQualityClick
    end
    object mnuMediumQuality: TMenuItem
      Caption = 'Medium Quality'
      Checked = True
      RadioItem = True
      OnClick = mnuMediumQualityClick
    end
    object mnuHighQuality: TMenuItem
      Caption = 'High Quality'
      RadioItem = True
      OnClick = mnuHighQualityClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mnuBack: TMenuItem
      Caption = 'Previous'
      Enabled = False
      ImageIndex = 4
      OnClick = mnuBackClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuMaintainSym: TMenuItem
      Caption = 'Maintain Symmetry'
      Checked = True
      OnClick = mnuMaintainSymClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuResetLocation: TMenuItem
      Caption = 'Reset Location'
      Checked = True
      OnClick = mnuResetLocationClick
    end
  end
end
