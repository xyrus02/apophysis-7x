object MutateForm: TMutateForm
  Left = 589
  Top = 326
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Mutation'
  ClientHeight = 398
  ClientWidth = 422
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000040040000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000003E3937FF48403BFF39322FFF28231FFF1B1714FF000000FF0000
    00003E3937FF48403BFF39322FFF28231FFF1B1714FF000000FF000000000000
    00000000000089766CFFFCF7F3FFFBECDDFFE5D7C8FFD3C5B6FF181412FF0000
    000089766CFFFCF7F3FFFBECDDFFE5D7C8FFD3C5B6FF181412FF000000000000
    000000000000898079FFFCF7F3FFE27239FFC8622FFFE5D7C8FF231E1BFF0000
    0000898079FFFCF7F3FFE27239FFC8622FFFE5D7C8FF231E1BFF000000000000
    00000000000089807CFFFEFBFAFFF58250FFCD6531FFFBECDDFF322C29FF0000
    000089807CFFFEFBFAFFF58250FFCD6531FFFBECDDFF322C29FF000000000000
    00000000000088807CFFFFFFFFFFFDFBFAFFFCF7F3FFFCF7F3FF3F3835FF0000
    000088807CFFFFFFFFFFFDFBFAFFFCF7F3FFFCF7F3FF3F3835FF000000000000
    000000000000887F7AFF89807CFF89807CFF898079FF89766CFF35312EFF0000
    0000887F7AFF89807CFF89807CFF898079FF89766CFF35312EFF000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000003E3937FF48403BFF39322FFF28231FFF1B1714FF000000FF0000
    00003E3937FF48403BFF39322FFF28231FFF1B1714FF000000FF000000000000
    00000000000089766CFFFCF7F3FFFBECDDFFE5D7C8FFD3C5B6FF181412FF0000
    000089766CFFFCF7F3FFFBECDDFFE5D7C8FFD3C5B6FF181412FF000000000000
    000000000000898079FFFCF7F3FFE27239FFC8622FFFE5D7C8FF231E1BFF0000
    0000898079FFFCF7F3FFE27239FFC8622FFFE5D7C8FF231E1BFF000000000000
    00000000000089807CFFFEFBFAFFF58250FFCD6531FFFBECDDFF322C29FF0000
    000089807CFFFEFBFAFFF58250FFCD6531FFFBECDDFF322C29FF000000000000
    00000000000088807CFFFFFFFFFFFDFBFAFFFCF7F3FFFCF7F3FF3F3835FF0000
    000088807CFFFFFFFFFFFDFBFAFFFCF7F3FFFCF7F3FF3F3835FF000000000000
    000000000000887F7AFF89807CFF89807CFF898079FF89766CFF35312EFF0000
    0000887F7AFF89807CFF89807CFF898079FF89766CFF35312EFF000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    0000FFFF0000C0810000C0810000C0810000C0810000C0810000C0810000FFFF
    0000C0810000C0810000C0810000C0810000C0810000C0810000FFFF0000}
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    422
    398)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 409
    Height = 273
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Directions'
    TabOrder = 0
    DesignSize = (
      409
      273)
    object Panel10: TPanel
      Left = 12
      Top = 20
      Width = 384
      Height = 238
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      TabOrder = 0
      OnResize = Panel10Resize
      object Panel6: TPanel
        Left = 112
        Top = 168
        Width = 108
        Height = 80
        BevelOuter = bvLowered
        Caption = 'PrevPnl3'
        Color = clBlack
        TabOrder = 0
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
      object Panel7: TPanel
        Left = 0
        Top = 168
        Width = 108
        Height = 80
        BevelOuter = bvLowered
        Caption = 'PrevPnl3'
        Color = clBlack
        TabOrder = 1
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
      object Panel4: TPanel
        Left = 224
        Top = 84
        Width = 108
        Height = 80
        BevelOuter = bvLowered
        Caption = 'PrevPnl3'
        Color = clBlack
        TabOrder = 2
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
      object Panel0: TPanel
        Left = 112
        Top = 84
        Width = 108
        Height = 80
        HelpContext = 2003
        BevelOuter = bvLowered
        Caption = 'PrevPnl3'
        Color = clBlack
        TabOrder = 3
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
      object Panel8: TPanel
        Left = 0
        Top = 84
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
      object Panel3: TPanel
        Left = 224
        Top = 0
        Width = 108
        Height = 80
        BevelOuter = bvLowered
        Caption = 'PrevPnl3'
        Color = clBlack
        TabOrder = 5
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
      object Panel2: TPanel
        Left = 112
        Top = 0
        Width = 108
        Height = 80
        BevelOuter = bvLowered
        Caption = 'PrevPnl3'
        Color = clBlack
        TabOrder = 6
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
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 108
        Height = 80
        BevelOuter = bvLowered
        Caption = 'PrevPnl3'
        Color = clBlack
        TabOrder = 7
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
      object Panel5: TPanel
        Left = 224
        Top = 168
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
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 288
    Width = 409
    Height = 105
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    DesignSize = (
      409
      105)
    object scrollTime: TScrollBar
      Left = 120
      Top = 20
      Width = 202
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      LargeChange = 5
      Max = 50
      Min = 1
      PageSize = 0
      Position = 1
      TabOrder = 0
      OnChange = scrollTimeChange
    end
    object cmbTrend: TComboBox
      Left = 119
      Top = 48
      Width = 282
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 16
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
      Left = 12
      Top = 78
      Width = 389
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Same no. of transforms'
      TabOrder = 2
      OnClick = chkSameNumClick
    end
    object pnlSpeed: TPanel
      Left = 12
      Top = 20
      Width = 101
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'Speed'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object txtTime: TEdit
      Left = 328
      Top = 20
      Width = 73
      Height = 21
      Anchors = [akTop, akRight]
      ReadOnly = True
      TabOrder = 4
      Text = '0'
    end
    object pnlTrend: TPanel
      Left = 12
      Top = 48
      Width = 101
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'Trend'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 168
    Top = 80
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
