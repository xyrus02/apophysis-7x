object AdjustForm: TAdjustForm
  Left = 500
  Top = 182
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Adjust'
  ClientHeight = 374
  ClientWidth = 372
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
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000CD52
    08FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFF000000000000CD5208FFFFFFFFFFFFFFFFFFFFBD96000000
    FFFFFFFFFFFFFFFFFFFFBD96000000FFFFFFFFFFFFFFFFFF000000000000CD52
    08FFFFFFFFFFFFFFFFFFFFBD96000000FFFFFFFFFFFFFFFFFFFFBD96000000FF
    FFFFFFFFFFFFFFFF000000000000CD5208FFFFFFFFFFFFFFFFFFFFBD96000000
    FFFFFFFFFFFFFFFFFFFFBD96000000FFFFFFFFFFFFFFFFFF000000000000CD52
    08FFFFFFFFFFFFFFFFFFFFBD96000000FFFFFFFFFFFFFFFFFFFFBD96000000FF
    FFFFFFFFFFFFFFFF000000000000CD5208FFFFFFFFFFFFE2996DE2996DE2996D
    E2996DFFFFFFE2996DE2996DE2996DE2996DFFFFFFFFFFFF000000000000CD52
    08FFFFFFFFFFFFCD5208CD5208CD5208CD5208FFFFFFCD5208CD5208CD5208CD
    5208FFFFFFFFFFFF000000000000CD5208FFFFFFFFFFFFFFFFFFFFBD96000000
    FFFFFFFFFFFFFFFFFFFFBD96000000FFFFFFFFFFFFFFFFFF000000000000CD52
    08FFFFFFFFFFFFFFFFFFFFBD96000000FFFFFFFFFFFFFFFFFFFFBD96000000FF
    FFFFFFFFFFFFFFFF000000000000CD5208FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000CD52
    08CD5208CD5208CD5208CD5208CD5208CD5208CD5208CD5208CD5208CD5208CD
    5208CD5208CD5208000000000000CD5208FFFFFFFFBD96FFBD96FFBD96FFBD96
    FFBD96FFBD96FFBD96FFBD96FFBD96FFFFFFD25C15FFFFFF000000000000CD52
    08CD5208CD5208CD5208CD5208CD5208CD5208CD5208CD5208CD5208CD5208CD
    5208CD5208CD5208CD5208000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    0000000100000001000000010000000100000001000000010000000100000001
    0000000100000001000000010000000100000001000000010000FFFF0000}
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PrevPnl: TPanel
    Left = 105
    Top = 5
    Width = 162
    Height = 122
    BevelOuter = bvLowered
    Color = clAppWorkSpace
    TabOrder = 0
    object PreviewImage: TImage
      Left = 1
      Top = 1
      Width = 160
      Height = 120
      Anchors = []
      Center = True
      IncrementalDisplay = True
      PopupMenu = QualityPopup
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 128
    Width = 357
    Height = 129
    Caption = 'Rendering'
    TabOrder = 1
    object Label8: TLabel
      Left = 6
      Top = 24
      Width = 52
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Gamma:'
    end
    object Label9: TLabel
      Left = 6
      Top = 48
      Width = 52
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Brightness:'
    end
    object Label10: TLabel
      Left = 6
      Top = 72
      Width = 52
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Vibrancy:'
    end
    object lblContrast: TLabel
      Left = 56
      Top = 100
      Width = 101
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Background color:'
    end
    object scrollGamma: TScrollBar
      Left = 64
      Top = 24
      Width = 233
      Height = 13
      LargeChange = 10
      Max = 500
      Min = 100
      PageSize = 0
      Position = 100
      TabOrder = 0
      OnChange = scrollGammaChange
      OnScroll = scrollGammaScroll
    end
    object txtGamma: TEdit
      Left = 304
      Top = 20
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '0'
      OnExit = txtGammaExit
      OnKeyPress = txtGammaKeyPress
    end
    object scrollBrightness: TScrollBar
      Left = 64
      Top = 48
      Width = 233
      Height = 13
      LargeChange = 100
      Max = 10000
      PageSize = 0
      TabOrder = 2
      OnChange = scrollBrightnessChange
      OnScroll = scrollBrightnessScroll
    end
    object txtBrightness: TEdit
      Left = 304
      Top = 44
      Width = 41
      Height = 21
      TabOrder = 3
      Text = '0'
      OnExit = txtBrightnessExit
      OnKeyPress = txtBrightnessKeyPress
    end
    object scrollVibrancy: TScrollBar
      Left = 64
      Top = 72
      Width = 233
      Height = 13
      LargeChange = 10
      PageSize = 0
      TabOrder = 4
      OnChange = scrollVibrancyChange
      OnScroll = scrollVibrancyScroll
    end
    object txtVibrancy: TEdit
      Left = 304
      Top = 68
      Width = 41
      Height = 21
      TabOrder = 5
      Text = '0'
      OnExit = txtVibrancyExit
      OnKeyPress = txtVibrancyKeyPress
    end
    object ColorPanel: TPanel
      Left = 168
      Top = 96
      Width = 177
      Height = 25
      BevelOuter = bvLowered
      Color = clBlack
      TabOrder = 6
      OnClick = ColorPanelClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 264
    Width = 357
    Height = 105
    Caption = 'Camera'
    TabOrder = 2
    object Label5: TLabel
      Left = 8
      Top = 24
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Zoom:'
    end
    object Label6: TLabel
      Left = 24
      Top = 44
      Width = 10
      Height = 13
      Alignment = taRightJustify
      Caption = 'X:'
    end
    object Label1: TLabel
      Left = 24
      Top = 68
      Width = 10
      Height = 13
      Alignment = taRightJustify
      Caption = 'Y:'
    end
    object scrollZoom: TScrollBar
      Left = 48
      Top = 24
      Width = 249
      Height = 13
      LargeChange = 10
      Max = 300
      Min = -300
      PageSize = 0
      TabOrder = 0
      OnChange = scrollZoomChange
      OnScroll = scrollZoomScroll
    end
    object txtZoom: TEdit
      Left = 304
      Top = 20
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '0'
      OnExit = txtZoomExit
      OnKeyPress = txtZoomKeyPress
    end
    object scrollCenterX: TScrollBar
      Left = 48
      Top = 48
      Width = 249
      Height = 13
      LargeChange = 10
      Max = 1000
      Min = -1000
      PageSize = 0
      TabOrder = 2
      OnChange = scrollCenterXChange
      OnScroll = scrollCenterXScroll
    end
    object txtCenterX: TEdit
      Left = 304
      Top = 44
      Width = 41
      Height = 21
      TabOrder = 3
      Text = '0'
      OnExit = txtCenterXExit
      OnKeyPress = txtCenterXKeyPress
    end
    object scrollCenterY: TScrollBar
      Left = 48
      Top = 72
      Width = 249
      Height = 13
      LargeChange = 10
      Max = 1000
      Min = -1000
      PageSize = 0
      TabOrder = 4
      OnChange = scrollCenterYChange
      OnScroll = scrollCenterYScroll
    end
    object txtCenterY: TEdit
      Left = 304
      Top = 68
      Width = 41
      Height = 21
      TabOrder = 5
      Text = '0'
      OnExit = txtCenterYExit
      OnKeyPress = txtCenterYKeyPress
    end
  end
  object QualityPopup: TPopupMenu
    Images = MainForm.Buttons
    Left = 16
    Top = 16
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
  end
  object ColorDialog: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen]
    Left = 376
    Top = 8
  end
end
