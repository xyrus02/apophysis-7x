object AdjustForm: TAdjustForm
  Left = 363
  Top = 245
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Adjust'
  ClientHeight = 263
  ClientWidth = 390
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
  object lblOffset: TLabel
    Left = 381
    Top = 120
    Width = 3
    Height = 13
    Alignment = taRightJustify
  end
  object btnUndo: TSpeedButton
    Left = 6
    Top = 5
    Width = 23
    Height = 22
    Flat = True
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF000000000000000000000000000000000000000000FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00
      FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00
      FF000000000000000000FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00
      FF0000000000FF00FF00FF00FF00FF00FF000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
      00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    ParentShowHint = False
    ShowHint = True
    OnClick = btnUndoClick
  end
  object btnRedo: TSpeedButton
    Left = 29
    Top = 5
    Width = 23
    Height = 22
    Flat = True
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
      000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0000000000FF00FF000000000000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00000000000000
      0000FF00FF00FF00FF00FF00FF0000000000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF0000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    ParentShowHint = False
    ShowHint = True
    OnClick = btnRedoClick
  end
  object PrevPnl: TPanel
    Left = 113
    Top = 5
    Width = 162
    Height = 122
    BevelOuter = bvLowered
    Color = clAppWorkSpace
    TabOrder = 0
    DesignSize = (
      162
      122)
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
  object PageControl: TPageControl
    Left = 0
    Top = 133
    Width = 390
    Height = 130
    ActivePage = TabSheet1
    Align = alBottom
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Camera'
      object btnZoom: TSpeedButton
        Left = 4
        Top = 4
        Width = 61
        Height = 21
        Hint = 'Reset value'
        Caption = 'Zoom'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = btnZoomClick
      end
      object btnXpos: TSpeedButton
        Left = 4
        Top = 28
        Width = 61
        Height = 21
        Hint = 'Reset value'
        Caption = 'X position'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = btnXposClick
      end
      object btnYpos: TSpeedButton
        Left = 4
        Top = 52
        Width = 61
        Height = 21
        Hint = 'Reset value'
        Caption = 'Y position'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = btnYposClick
      end
      object btnAngle: TSpeedButton
        Left = 4
        Top = 76
        Width = 61
        Height = 21
        Hint = 'Reset value'
        Caption = 'Rotation'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = btnAngleClick
      end
      object scrollZoom: TScrollBar
        Left = 72
        Top = 7
        Width = 257
        Height = 15
        LargeChange = 100
        Max = 3000
        Min = -3000
        PageSize = 0
        SmallChange = 10
        TabOrder = 0
        OnChange = scrollZoomChange
        OnScroll = scrollZoomScroll
      end
      object txtZoom: TEdit
        Left = 338
        Top = 4
        Width = 41
        Height = 21
        TabOrder = 1
        Text = '0'
        OnEnter = txtZoomEnter
        OnExit = txtZoomExit
        OnKeyPress = txtZoomKeyPress
      end
      object scrollCenterX: TScrollBar
        Left = 72
        Top = 31
        Width = 257
        Height = 15
        LargeChange = 100
        Max = 10000
        Min = -10000
        PageSize = 0
        SmallChange = 10
        TabOrder = 2
        OnChange = scrollCenterXChange
        OnScroll = scrollCenterXScroll
      end
      object txtCenterX: TEdit
        Left = 338
        Top = 28
        Width = 41
        Height = 21
        TabOrder = 3
        Text = '0'
        OnEnter = txtCenterXEnter
        OnExit = txtCenterXExit
        OnKeyPress = txtCenterXKeyPress
      end
      object scrollCenterY: TScrollBar
        Left = 72
        Top = 55
        Width = 257
        Height = 15
        LargeChange = 100
        Max = 10000
        Min = -10000
        PageSize = 0
        SmallChange = 10
        TabOrder = 4
        OnChange = scrollCenterYChange
        OnScroll = scrollCenterYScroll
      end
      object txtCenterY: TEdit
        Left = 338
        Top = 52
        Width = 41
        Height = 21
        TabOrder = 5
        Text = '0'
        OnEnter = txtCenterYEnter
        OnExit = txtCenterYExit
        OnKeyPress = txtCenterYKeyPress
      end
      object scrollAngle: TScrollBar
        Left = 72
        Top = 79
        Width = 257
        Height = 15
        LargeChange = 1500
        Max = 18000
        Min = -18000
        PageSize = 0
        SmallChange = 100
        TabOrder = 6
        OnChange = scrollAngleChange
        OnScroll = scrollAngleScroll
      end
      object txtAngle: TEdit
        Left = 338
        Top = 76
        Width = 41
        Height = 21
        TabOrder = 7
        Text = '0'
        OnEnter = txtAngleEnter
        OnExit = txtAngleExit
        OnKeyPress = txtAngleKeyPress
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Rendering'
      ImageIndex = 1
      object lblContrast: TLabel
        Left = 4
        Top = 80
        Width = 69
        Height = 13
        AutoSize = False
        Caption = 'Background'
      end
      object btnGamma: TSpeedButton
        Left = 4
        Top = 4
        Width = 61
        Height = 21
        Hint = 'Reset value'
        Caption = 'Gamma'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = btnGammaClick
      end
      object btnBritghtness: TSpeedButton
        Left = 4
        Top = 28
        Width = 61
        Height = 21
        Hint = 'Reset value'
        Caption = 'Brightness'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = btnBritghtnessClick
      end
      object btnVibrancy: TSpeedButton
        Left = 4
        Top = 52
        Width = 61
        Height = 21
        Hint = 'Reset value'
        Caption = 'Vibrancy'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = btnVibrancyClick
      end
      object Label1: TLabel
        Left = 236
        Top = 80
        Width = 62
        Height = 13
        Caption = 'Master Scale'
      end
      object scrollGamma: TScrollBar
        Left = 72
        Top = 7
        Width = 257
        Height = 15
        LargeChange = 10
        Max = 500
        Min = 100
        PageSize = 0
        Position = 500
        TabOrder = 0
        OnChange = scrollGammaChange
        OnScroll = scrollGammaScroll
      end
      object txtGamma: TEdit
        Left = 338
        Top = 4
        Width = 41
        Height = 21
        TabOrder = 1
        Text = '0'
        OnEnter = txtGammaEnter
        OnExit = txtGammaExit
        OnKeyPress = txtGammaKeyPress
      end
      object scrollBrightness: TScrollBar
        Left = 72
        Top = 31
        Width = 257
        Height = 15
        LargeChange = 100
        Max = 10000
        PageSize = 0
        TabOrder = 2
        OnChange = scrollBrightnessChange
        OnScroll = scrollBrightnessScroll
      end
      object txtBrightness: TEdit
        Left = 338
        Top = 28
        Width = 41
        Height = 21
        TabOrder = 3
        Text = '0'
        OnEnter = txtBrightnessEnter
        OnExit = txtBrightnessExit
        OnKeyPress = txtBrightnessKeyPress
      end
      object scrollVibrancy: TScrollBar
        Left = 72
        Top = 55
        Width = 257
        Height = 15
        LargeChange = 10
        PageSize = 0
        TabOrder = 4
        OnChange = scrollVibrancyChange
        OnScroll = scrollVibrancyScroll
      end
      object txtVibrancy: TEdit
        Left = 338
        Top = 52
        Width = 41
        Height = 21
        TabOrder = 5
        Text = '0'
        OnEnter = txtVibrancyEnter
        OnExit = txtVibrancyExit
        OnKeyPress = txtVibrancyKeyPress
      end
      object ColorPanel: TPanel
        Left = 72
        Top = 78
        Width = 65
        Height = 21
        Cursor = crHandPoint
        BevelOuter = bvLowered
        Color = clBlack
        TabOrder = 6
        OnClick = ColorPanelClick
      end
      object chkTransparent: TCheckBox
        Left = 144
        Top = 80
        Width = 81
        Height = 17
        Caption = 'Transparent'
        Enabled = False
        TabOrder = 7
        Visible = False
      end
      object editPPU: TEdit
        Left = 304
        Top = 76
        Width = 75
        Height = 21
        TabOrder = 8
        OnKeyPress = editPPUKeyPress
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Gradient'
      ImageIndex = 2
      object lblVal: TLabel
        Left = 358
        Top = 55
        Width = 6
        Height = 13
        Caption = '0'
      end
      object btnMenu: TSpeedButton
        Left = 4
        Top = 52
        Width = 61
        Height = 21
        Hint = 'Click for menu'
        Caption = 'Rotate'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = btnMenuClick
      end
      object btnOpen: TSpeedButton
        Left = 333
        Top = 78
        Width = 23
        Height = 22
        Hint = 'Open Gradient Browser'
        Flat = True
        Glyph.Data = {
          76030000424D7603000000000000360000002800000011000000100000000100
          18000000000040030000120B0000120B00000000000000000000FF00FFFF00FF
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000FF00FFFF00FF00FF00FFFF00FF000000FFF5F0FFF1E9FFEFE6
          FFEFE6FFF0E7FFF1E8FFF1E9FFF3EBFFF3ECFFF4EDFFF6F0000000FF00FFFF00
          FF00FF00FFFF00FF000000FFF4EDFFEEE4FFEBDFFFEBDFFFEBE0FFECE2FFEDE2
          FFEEE4FFEFE5FFEFE6FFF1EA000000FF00FFFF00FF00FF00FFFF00FF000000FF
          F1E9CD5208CD5208CD5208CD5208CD5208CD5208CD5208CD5208CD5208FFEDE3
          000000FF00FFFF00FF00FF00FFFF00FF000000FFEFE6CD5208E26518EB7A37FF
          A772FFD1B2FFF7EDC2E9FF42ADF7CD5208FFE9DC000000FF00FFFF00FF00FF00
          FFFF00FF000000FFEDE2CD5208E16519E97835FFA770FFD1B2FFF7ECC2E9FF40
          ADF7CD5208FFE5D6000000FF00FFFF00FF00FF00FFFF00FF000000FFEBDFCD52
          08E16518EB7836FFA770FFD1B2FFF7ECC2E9FF42ADF7CD5208FFE1D0000000FF
          00FFFF00FF00FF00FFFF00FF000000FFE9DBCD5208E16519EC7935FFA770FFD0
          B2FFF7ECC2E9FF40AEF7CD5208FFDFCD000000FF00FFFF00FF00FF00FFFF00FF
          000000FFE7D8CD5208E16519EB7935FFA570FFD1B2FFF7ECC2E9FF40ADF7CD52
          08FFE1D0000000FF00FFFF00FF00FF00FFFF00FF000000FFE4D5CD5208E3651A
          EB7A39FFA874FFD1B3FFF7ECC4E9FF44AEF7CD5208FFE9DC000000FF00FFFF00
          FF00FF00FFFF00FF000000FFE3D1CD5208ED7935F99457FFBC8DFFE1C5FFFFF9
          000000000000000000000000000000FF00FFFF00FF00FF00FFFF00FF000000FF
          E1CFCD5208CD5208CD5208CD5208CD5208CD5208000000E17D41EB925E000000
          FF00FFFF00FFFF00FF00FF00FFFF00FF000000FFE2D1FFD7BFFFD0B4FFCEB1FF
          CFB3FFD0B4FFD3B8000000F5A779000000FF00FFFF00FFFF00FFFF00FF00FF00
          FFFF00FF000000FFE7DAFFE2D0FFDECBFFDECAFFDDC9FFDECAFFDFCD00000000
          0000FF00FFFF00FFFF00FFFF00FFFF00FF00FF00FFFF00FF0000000000000000
          00000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00}
        ParentShowHint = False
        ShowHint = True
        OnClick = btnOpenClick
      end
      object btnSmoothPalette: TSpeedButton
        Left = 357
        Top = 78
        Width = 23
        Height = 22
        Hint = 'Smooth Palette'
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000FF00FFFF00FF000000
          374BA83A53AB3E5DB14368B74876BF4E84C65493CE5BA3D661B2DE67C0E66CCE
          EC71DAF3000000FF00FFFF00FF000000374BA83A53AB3E5DB14368B74876BF4E
          84C65593CE5BA2D661B2DE67C0E66CCEED71DAF3000000FF00FFFF00FF000000
          374BA83A52AC3E5DB14369B84876BE4F84C65593CE5BA3D661B1DE67C1E66CCD
          ED71D9F3000000FF00FFFF00FF000000374BA83A53AB3E5CB14369B74876BE4E
          84C65494CE5BA2D661B2DE66C1E56CCEEC71DAF3000000FF00FFFF00FF000000
          374BA83A53AC3E5DB14368B74975BE4F84C65593CE5AA2D661B2DE67C0E56CCE
          ED71D9F3000000FF00FFFF00FF000000374BA83A52AC3E5DB14368B84976BF4E
          84C65493CE5BA3D661B2DE66C0E56CCEEC71D9F3000000FF00FFFF00FF000000
          374BA83A52AC3E5CB14369B74975BE4F84C65494CD5BA2D661B1DE66C0E56CCE
          ED71DAF3000000FF00FFFF00FF000000374BA83A53AC3E5CB14368B74876BF4E
          84C65493CE5BA2D660B2DE67C0E56DCEEC71D9F3000000FF00FFFF00FF000000
          374BA83A52AC3E5CB24368B74975BE4E84C65594CE5AA3D661B2DE67C1E66DCE
          EC71D9F3000000FF00FFFF00FF000000374BA83A52AC3E5CB14369B74875BF4F
          84C65493CE5AA3D661B2DE66C0E66DCEEC71DAF3000000FF00FFFF00FF000000
          374BA83A52AC3E5DB14368B74976BF4F84C65593CE5BA3D660B2DE67C0E56CCD
          ED71D9F3000000FF00FFFF00FF000000374BA83A53AC3E5CB14268B74876BF4F
          84C65593CE5BA3D661B2DE67C1E66CCEED71DAF3000000FF00FFFF00FF000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuSmoothPaletteClick
      end
      object btnPaste: TSpeedButton
        Left = 309
        Top = 78
        Width = 23
        Height = 22
        Hint = 'Paste fradient from clipboard'
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000
          0000000000000000000000000000000000000000000000FF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF
          FFFFE39A6FFFFFFFE3996CE2996DE3996DFFFFFF000000FF00FFFF00FFFF00FF
          000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FF00FFFF00FF00000056B9F556B9F556B9F556B9F5000000FF
          FFFFE29566E39363FFFFFFE39262E29363FFFFFF000000FF00FFFF00FF000000
          56B9F556B9F556B9F556B9F5000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FF00FFFF00FF00000056B9F556B9F556B9F556B9F5000000FF
          FFFFE3915FE28C58FFFFFFFFFFFFE29364FFFFFF000000FF00FFFF00FF000000
          56B9F556B9F556B9F556B9F5000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000
          00000000000000FF00FFFF00FF00000056B9F556B9F556B9F556B9F5000000FF
          FFFFE29160FFFFFFFFFFFF000000FFFFFF000000FF00FFFF00FFFF00FF000000
          56B9F556B9F556B9F556B9F5000000FFFFFFFFFFFFFFFFFFFFFFFF0000000000
          00FF00FFFF00FFFF00FFFF00FF00000056B9F500000000000000000000000000
          0000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FF000000
          56B9F5000000BBE5F9BBE5F9BBE5F9BBE5F9BBE5F9BBE5F900000056B9F50000
          00FF00FFFF00FFFF00FFFF00FF00000056B9F556B9F5000000BBE5F900000000
          0000BBE5F900000056B9F556B9F5000000FF00FFFF00FFFF00FFFF00FFFF00FF
          000000000000000000000000BBE5F9BBE5F9000000000000000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000
          0000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        ParentShowHint = False
        ShowHint = True
        OnClick = btnPasteClick
      end
      object btnCopy: TSpeedButton
        Left = 285
        Top = 78
        Width = 23
        Height = 22
        Hint = 'Copy gradient to clipboard'
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000
          0000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFE39A6FFFFFFFE3996CE2
          996DE3996DFFFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          000000FFFFFFFFFFFFFFFFFF0000000000000000000000000000000000000000
          00000000000000FF00FFFF00FFFF00FF000000FFFFFFE29566E39363000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF00FFFF00FFFF00FF
          000000FFFFFFFFFFFFFFFFFF000000FFFFFFE39A6FFFFFFFE3996CE2996DE399
          6DFFFFFF000000FF00FFFF00FFFF00FF000000FFFFFFE3915FE28C58000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF00FFFF00FFFF00FF
          000000FFFFFFFFFFFFFFFFFF000000FFFFFFE29566E39363FFFFFFE39262E293
          63FFFFFF000000FF00FFFF00FFFF00FF000000FFFFFFE29160FFFFFF000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF00FFFF00FFFF00FF
          000000FFFFFFFFFFFFFFFFFF000000FFFFFFE3915FE28C58FFFFFFFFFFFFE293
          64FFFFFF000000FF00FFFF00FFFF00FF000000000000000000000000000000FF
          FFFFFFFFFFFFFFFFFFFFFF000000000000000000000000FF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FF000000FFFFFFE29160FFFFFFFFFFFF000000FFFF
          FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF
          FFFFFFFFFFFFFFFFFFFFFF000000000000FF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FF000000000000000000000000000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        ParentShowHint = False
        ShowHint = True
        OnClick = btnCopyClick
      end
      object btnColorPreset: TSpeedButton
        Left = 4
        Top = 78
        Width = 61
        Height = 21
        Hint = 'Click to choose random preset'
        Caption = 'Preset'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = btnColorPresetClick
      end
      object GradientPnl: TPanel
        Left = 0
        Top = 0
        Width = 382
        Height = 49
        Align = alTop
        BevelOuter = bvLowered
        Color = clAppWorkSpace
        TabOrder = 0
        object GradientImage: TImage
          Left = 1
          Top = 1
          Width = 380
          Height = 47
          Cursor = crHandPoint
          Align = alClient
          PopupMenu = GradientPopup
          Stretch = True
          OnDblClick = GradientImageDblClick
          OnMouseDown = GradImageMouseDown
          OnMouseMove = GradImageMouseMove
          OnMouseUp = GradImageMouseUp
        end
      end
      object ScrollBar: TScrollBar
        Left = 72
        Top = 55
        Width = 271
        Height = 15
        LargeChange = 16
        Max = 128
        Min = -128
        PageSize = 0
        TabOrder = 1
        OnChange = ScrollBarChange
        OnScroll = ScrollBarScroll
      end
      object cmbPalette: TComboBox
        Left = 72
        Top = 78
        Width = 206
        Height = 21
        BevelInner = bvLowered
        BevelOuter = bvRaised
        Style = csOwnerDrawFixed
        Color = clBlack
        DropDownCount = 20
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
        OnChange = cmbPaletteChange
        OnDrawItem = cmbPaletteDrawItem
        Items.Strings = (
          'south-sea-bather'
          'sky-flesh'
          'blue-bather'
          'no-name'
          'pillows'
          'mauve-splat'
          'facial-treescape 6'
          'fasion-bug'
          'leafy-face'
          'mouldy-sun'
          'sunny-harvest'
          'peach-tree'
          'fire-dragon'
          'ice-dragon'
          'german-landscape'
          'no-name'
          'living-mud-bomb'
          'cars'
          'unhealthy-tan'
          'daffodil'
          'rose'
          'healthy-skin'
          'orange'
          'white-ivy'
          'summer-makeup'
          'glow-buzz'
          'deep-water'
          'afternoon-beach'
          'dim-beach'
          'cloudy-brick'
          'burning-wood'
          'aquatic-garden'
          'no-name'
          'fall-quilt'
          'night-blue-sky'
          'shadow-iris'
          'solid-sky'
          'misty-field'
          'wooden-highlight'
          'jet-tundra'
          'pastel-lime'
          'hell'
          'indian-coast'
          'dentist-decor'
          'greenland'
          'purple-dress'
          'no-name'
          'spring-flora'
          'andi'
          'gig-o835'
          'rie02'
          'rie05'
          'rie11'
          'etretat.ppm'
          'the-hollow-needle-at-etretat.ppm'
          'rouen-cathedral-sunset.ppm'
          'the-houses-of-parliament.ppm'
          'starry-night.ppm'
          'water-lilies-sunset.ppm'
          'gogh.chambre-arles.ppm'
          'gogh.entrance.ppm'
          'gogh.the-night-cafe.ppm'
          'gogh.vegetable-montmartre.ppm'
          'matisse.bonheur-vivre.ppm'
          'matisse.flowers.ppm'
          'matisse.lecon-musique.ppm'
          'modigliani.nude-caryatid.ppm'
          'braque.instruments.ppm'
          'calcoast09.ppm'
          'dodge102.ppm'
          'ernst.anti-pope.ppm'
          'ernst.ubu-imperator.ppm'
          'fighting-forms.ppm'
          'fog25.ppm'
          'geyser27.ppm'
          'gris.josette.ppm'
          'gris.landscape-ceret.ppm'
          'kandinsky.comp-9.ppm'
          'kandinsky.yellow-red-blue.ppm'
          'klee.insula-dulcamara.ppm'
          'nile.ppm'
          'picasso.jfille-chevre.ppm'
          'pollock.lavender-mist.ppm'
          'yngpaint.ppm')
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Image Size'
      ImageIndex = 3
      object Bevel2: TBevel
        Left = 4
        Top = 4
        Width = 137
        Height = 93
        Shape = bsFrame
      end
      object Bevel1: TBevel
        Left = 148
        Top = 4
        Width = 148
        Height = 93
        Shape = bsFrame
      end
      object Label2: TLabel
        Left = 14
        Top = 15
        Width = 28
        Height = 13
        Caption = 'Width'
      end
      object Label3: TLabel
        Left = 14
        Top = 41
        Width = 31
        Height = 13
        Caption = 'Height'
      end
      object btnPreset1: TButton
        Left = 156
        Top = 12
        Width = 105
        Height = 25
        Caption = 'Preset 1'
        TabOrder = 0
        OnClick = btnPreset1Click
      end
      object btnPreset2: TButton
        Left = 156
        Top = 38
        Width = 105
        Height = 25
        Caption = 'Preset 2'
        TabOrder = 1
        OnClick = btnPreset2Click
      end
      object btnPreset3: TButton
        Left = 156
        Top = 64
        Width = 105
        Height = 25
        Caption = 'Preset 3'
        TabOrder = 2
        OnClick = btnPreset3Click
      end
      object btnSet1: TButton
        Left = 260
        Top = 12
        Width = 27
        Height = 25
        Caption = 'Set'
        TabOrder = 3
        OnClick = btnSet1Click
      end
      object btnSet2: TButton
        Left = 260
        Top = 38
        Width = 27
        Height = 25
        Caption = 'Set'
        TabOrder = 4
        OnClick = btnSet2Click
      end
      object btnSet3: TButton
        Left = 260
        Top = 64
        Width = 27
        Height = 25
        Caption = 'Set'
        TabOrder = 5
        OnClick = btnSet3Click
      end
      object btnApplySize: TBitBtn
        Left = 302
        Top = 72
        Width = 75
        Height = 25
        Caption = 'Apply'
        TabOrder = 6
        OnClick = btnApplySizeClick
      end
      object chkMaintain: TCheckBox
        Left = 14
        Top = 70
        Width = 121
        Height = 19
        Caption = 'Maintain aspect ratio'
        TabOrder = 7
        OnClick = chkMaintainClick
      end
      object txtWidth: TComboBox
        Left = 60
        Top = 12
        Width = 73
        Height = 21
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 8
        Text = '512'
        OnChange = txtWidthChange
        OnKeyPress = txtSizeKeyPress
        Items.Strings = (
          '512'
          '640'
          '800'
          '1024'
          '1280')
      end
      object txtHeight: TComboBox
        Left = 60
        Top = 38
        Width = 73
        Height = 21
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 9
        Text = '384'
        OnChange = txtHeightChange
        OnKeyPress = txtSizeKeyPress
        Items.Strings = (
          '384'
          '480'
          '512'
          '600'
          '768'
          '960'
          '1024')
      end
    end
  end
  object QualityPopup: TPopupMenu
    Images = MainForm.Buttons
    Left = 200
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
    object N8: TMenuItem
      Caption = '-'
    end
    object mnuInstantPreview: TMenuItem
      Caption = 'Instant Preview'
      OnClick = mnuInstantPreviewClick
    end
  end
  object ColorDialog: TColorDialog
    Options = [cdFullOpen]
    Left = 232
    Top = 16
  end
  object GradientPopup: TPopupMenu
    Images = MainForm.Buttons
    Left = 200
    Top = 56
    object mnuRandomize: TMenuItem
      Caption = 'Randomize'
      OnClick = mnuRandomizeClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object mnuInvert: TMenuItem
      Caption = 'Invert'
      OnClick = mnuInvertClick
    end
    object mnuReverse: TMenuItem
      Caption = '&Reverse'
      OnClick = mnuReverseClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mnuSmoothPalette: TMenuItem
      Caption = 'Smooth Palette...'
      ImageIndex = 34
      OnClick = mnuSmoothPaletteClick
    end
    object mnuGradientBrowser: TMenuItem
      Caption = 'Gradient Browser...'
      ImageIndex = 22
      OnClick = btnOpenClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object SaveGradient1: TMenuItem
      Caption = 'Save Gradient...'
      ImageIndex = 2
      OnClick = SaveGradient1Click
    end
    object SaveasMapfile1: TMenuItem
      Caption = 'Save as Map file...'
      OnClick = SaveasMapfile1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object mnuSaveasDefault: TMenuItem
      Caption = 'Save as Default'
      OnClick = mnuSaveasDefaultClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object mnuCopy: TMenuItem
      Caption = 'Copy'
      ImageIndex = 7
      OnClick = btnCopyClick
    end
    object mnuPaste: TMenuItem
      Caption = 'Paste'
      ImageIndex = 8
      OnClick = btnPasteClick
    end
  end
  object scrollModePopup: TPopupMenu
    AutoHotkeys = maManual
    AutoPopup = False
    Left = 232
    Top = 56
    object mnuRotate: TMenuItem
      Caption = 'Rotate'
      OnClick = mnuRotateClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuHue: TMenuItem
      Caption = 'Hue'
      OnClick = mnuHueClick
    end
    object mnuSaturation: TMenuItem
      Caption = 'Saturation'
      OnClick = mnuSaturationClick
    end
    object mnuBrightness: TMenuItem
      Caption = 'Brightness'
      OnClick = mnuBrightnessClick
    end
    object Contrast1: TMenuItem
      Caption = 'Contrast'
      OnClick = mnuContrastClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuBlur: TMenuItem
      Caption = 'Blur'
      OnClick = mnuBlurClick
    end
    object mnuFrequency: TMenuItem
      Caption = 'Frequency'
      OnClick = mnuFrequencyClick
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'map'
    Filter = 'Map files|*.map'
    Left = 200
    Top = 88
  end
  object ApplicationEvents: TApplicationEvents
    OnActivate = ApplicationEventsActivate
    Left = 232
    Top = 88
  end
end
