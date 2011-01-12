object ExportDialog: TExportDialog
  Left = 313
  Top = 276
  BorderStyle = bsDialog
  Caption = 'Export Flame'
  ClientHeight = 392
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    496
    392)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 398
    Top = 182
    Width = 89
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 398
    Top = 210
    Width = 89
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 5
    Width = 481
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    Caption = '  Destination  '
    TabOrder = 2
    DesignSize = (
      481
      57)
    object btnBrowse: TSpeedButton
      Left = 448
      Top = 19
      Width = 24
      Height = 24
      Hint = 'Browse...'
      Anchors = [akTop, akRight]
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
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
      OnClick = btnBrowseClick
    end
    object Label10: TPanel
      Left = 8
      Top = 20
      Width = 105
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'File name'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object txtFilename: TEdit
      Left = 112
      Top = 20
      Width = 337
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 256
    Top = 66
    Width = 233
    Height = 105
    Anchors = [akTop, akRight]
    Caption = '  Quality  '
    TabOrder = 3
    DesignSize = (
      233
      105)
    object udOversample: TUpDown
      Left = 212
      Top = 68
      Width = 12
      Height = 21
      Anchors = [akTop, akRight]
      Associate = txtOversample
      Min = 1
      Max = 4
      Position = 2
      TabOrder = 3
    end
    object Label4: TPanel
      Left = 8
      Top = 20
      Width = 113
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'Density'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object txtDensity: TEdit
      Left = 120
      Top = 20
      Width = 105
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = txtDensityChange
    end
    object Label5: TPanel
      Left = 8
      Top = 44
      Width = 113
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'Filter radius'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object txtFilterRadius: TEdit
      Left = 120
      Top = 44
      Width = 105
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnChange = txtFilterRadiusChange
    end
    object Label3: TPanel
      Left = 8
      Top = 68
      Width = 113
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'Oversample'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
    end
    object txtOversample: TEdit
      Left = 120
      Top = 68
      Width = 92
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 2
      Text = '2'
      OnChange = txtOversampleChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 66
    Width = 241
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = '  Size  '
    TabOrder = 4
    DesignSize = (
      241
      105)
    object Label13: TLabel
      Left = 184
      Top = 36
      Width = 26
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = 'pixels'
      Visible = False
    end
    object Label16: TLabel
      Left = 168
      Top = 22
      Width = 15
      Height = 36
      Anchors = [akLeft, akTop, akRight]
      Caption = '}'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object chkMaintain: TCheckBox
      Left = 8
      Top = 76
      Width = 225
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Maintain aspect ratio'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = chkMaintainClick
    end
    object Label1: TPanel
      Left = 8
      Top = 20
      Width = 105
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'Width'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object Label2: TPanel
      Left = 8
      Top = 44
      Width = 105
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'Height'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object cbHeight: TComboBox
      Left = 112
      Top = 44
      Width = 121
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 2
      OnChange = txtHeightChange
      Items.Strings = (
        '200'
        '240'
        '480'
        '600'
        '768'
        '1024'
        '1200'
        '2048'
        '2400')
    end
    object cbWidth: TComboBox
      Left = 112
      Top = 20
      Width = 121
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
      OnChange = txtWidthChange
      Items.Strings = (
        '320'
        '640'
        '800'
        '1024'
        '1280'
        '1600'
        '1920'
        '2048'
        '2560'
        '3200')
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 176
    Width = 377
    Height = 113
    Anchors = [akLeft, akTop, akRight]
    Caption = '  Parameters  '
    TabOrder = 5
    DesignSize = (
      377
      113)
    object udStrips: TUpDown
      Left = 172
      Top = 52
      Width = 12
      Height = 21
      Associate = txtStrips
      Min = 1
      Max = 512
      Position = 1
      TabOrder = 2
    end
    object Label7: TPanel
      Left = 8
      Top = 20
      Width = 105
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'Buffer depth'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
    end
    object Label8: TPanel
      Left = 8
      Top = 52
      Width = 105
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'Strips'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
    end
    object Label9: TPanel
      Left = 8
      Top = 84
      Width = 105
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'DE Radius'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
    end
    object txtEstimator: TEdit
      Left = 112
      Top = 84
      Width = 73
      Height = 21
      TabOrder = 3
      Text = '5'
      OnChange = txtEstimatorChange
    end
    object txtStrips: TEdit
      Left = 112
      Top = 52
      Width = 60
      Height = 21
      TabOrder = 1
      Text = '1'
      OnChange = txtBatchesChange
    end
    object cmbDepth: TComboBox
      Left = 112
      Top = 20
      Width = 73
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cmbDepthChange
      Items.Strings = (
        '16-bit'
        '32-bit'
        '32-bit float'
        '64-bit')
    end
    object Label14: TPanel
      Left = 192
      Top = 20
      Width = 105
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'Gamma threshold'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
    end
    object Label12: TPanel
      Left = 192
      Top = 52
      Width = 105
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'DE Curve'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
    end
    object Label11: TPanel
      Left = 192
      Top = 84
      Width = 105
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'DE Minimum'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
    end
    object txtGammaTreshold: TEdit
      Left = 296
      Top = 20
      Width = 73
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 6
      Text = '0.01'
      OnChange = txtGammaTresholdChange
    end
    object txtEstimatorCurve: TEdit
      Left = 296
      Top = 52
      Width = 73
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 5
      Text = '0.6'
      OnChange = txtEstimatorCurveChange
    end
    object txtEstimatorMin: TEdit
      Left = 296
      Top = 84
      Width = 73
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      Text = '0'
      OnChange = txtEstimatorMinChange
    end
  end
  object chkRender: TCheckBox
    Left = 400
    Top = 246
    Width = 89
    Height = 43
    Anchors = [akTop, akRight]
    Caption = 'Render'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object Panel1: TPanel
    Left = 8
    Top = 296
    Width = 481
    Height = 89
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelKind = bkSoft
    BevelOuter = bvNone
    Color = clInfoBk
    TabOrder = 7
    OnResize = Panel1Resize
    DesignSize = (
      477
      85)
    object Label6: TLabel
      Left = 8
      Top = 4
      Width = 453
      Height = 24
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'WARNING!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInfoText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label15: TLabel
      Left = 8
      Top = 25
      Width = 447
      Height = 26
      Alignment = taCenter
      Anchors = [akLeft, akRight]
      Caption = 
        'Fractals created with this version of Apophysis are not supporte' +
        'd by the external renderer! To render 2D-only fractals, download' +
        ' the latest version of FLAM3 from http://www.flam3.com'
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInfoText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      WordWrap = True
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'jpg'
    Filter = 
      'JPEG Image (*.jpg)|*.jpg|PPM Image (*.ppm)|*.ppm|PNG Images (*.p' +
      'ng)|*.png'
    Left = 464
    Top = 264
  end
end
