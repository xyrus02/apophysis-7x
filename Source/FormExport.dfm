object ExportDialog: TExportDialog
  Left = 313
  Top = 276
  BorderStyle = bsDialog
  Caption = 'Export Flame'
  ClientHeight = 382
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 326
    Top = 182
    Width = 89
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 326
    Top = 210
    Width = 89
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 5
    Width = 408
    Height = 57
    Caption = '  Destination  '
    TabOrder = 2
    object btnBrowse: TSpeedButton
      Left = 368
      Top = 16
      Width = 24
      Height = 24
      Hint = 'Browse...'
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
        FFFF00FFFF00FFFF00FF00000000000000000000000000000000000000000000
        0000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FF000000000000
        9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF000000FF00
        FFFF00FFFF00FFFF00FF0000009FFFFF0000009FCFFF9FCFFF9FCFFF9FCFFF9F
        CFFF9FCFFF9FCFFF9FCFFF9FCFFF000000FF00FFFF00FFFF00FF0000009FFFFF
        9FFFFF0000009FCFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCF
        FF000000FF00FFFF00FF0000009FFFFF9FFFFF9FFFFF0000009FCFFF9FCFFF9F
        CFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF9FCFFF000000FF00FF0000009FFFFF
        9FFFFF9FFFFF9FFFFF0000000000000000000000000000000000000000000000
        00000000000000FF00FF0000009FFFFF9FFFFF9FFFFF9FFFFF9FFFFF9FFFFF9F
        FFFF9FFFFF9FFFFF000000FF00FFFF00FFFF00FFFF00FFFF00FF0000009FFFFF
        9FFFFF9FFFFF9FFFFF9FFFFF9FFFFF9FFFFF9FFFFF9FFFFF000000FF00FFFF00
        FFFF00FFFF00FFFF00FF0000009FFFFF9FFFFF9FFFFF00000000000000000000
        0000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
        000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000
        00000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0C0C0CFF00FFFF00FFFF00FF0000
        00FF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FF0B0B0B020202000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = btnBrowseClick
    end
    object Label10: TLabel
      Left = 10
      Top = 23
      Width = 48
      Height = 13
      Caption = 'File name:'
    end
    object txtFilename: TEdit
      Left = 72
      Top = 20
      Width = 281
      Height = 21
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 216
    Top = 66
    Width = 200
    Height = 105
    Caption = '  Quality  '
    TabOrder = 3
    object Label3: TLabel
      Left = 10
      Top = 71
      Width = 59
      Height = 13
      Caption = 'Oversample:'
    end
    object Label5: TLabel
      Left = 10
      Top = 47
      Width = 61
      Height = 13
      Caption = 'Filter Radius:'
    end
    object Label4: TLabel
      Left = 10
      Top = 23
      Width = 35
      Height = 13
      Caption = 'Quality:'
    end
    object txtOversample: TEdit
      Left = 112
      Top = 68
      Width = 57
      Height = 21
      ReadOnly = True
      TabOrder = 2
      Text = '2'
      OnChange = txtOversampleChange
    end
    object txtFilterRadius: TEdit
      Left = 112
      Top = 44
      Width = 57
      Height = 21
      TabOrder = 1
      OnChange = txtFilterRadiusChange
    end
    object txtDensity: TEdit
      Left = 112
      Top = 20
      Width = 57
      Height = 21
      TabOrder = 0
      OnChange = txtDensityChange
    end
    object udOversample: TUpDown
      Left = 169
      Top = 68
      Width = 12
      Height = 21
      Associate = txtOversample
      Min = 1
      Max = 4
      Position = 2
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 66
    Width = 200
    Height = 105
    Caption = '  Size  '
    TabOrder = 4
    object Label1: TLabel
      Left = 10
      Top = 23
      Width = 28
      Height = 13
      Caption = 'Width'
    end
    object Label2: TLabel
      Left = 10
      Top = 47
      Width = 34
      Height = 13
      Caption = 'Height:'
    end
    object chkMaintain: TCheckBox
      Left = 8
      Top = 76
      Width = 161
      Height = 17
      Caption = 'Maintain aspect ratio'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = chkMaintainClick
    end
    object cbWidth: TComboBox
      Left = 112
      Top = 20
      Width = 73
      Height = 21
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
    object cbHeight: TComboBox
      Left = 112
      Top = 44
      Width = 73
      Height = 21
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
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 176
    Width = 313
    Height = 113
    Caption = '  flam3 parameters  '
    TabOrder = 5
    object Label7: TLabel
      Left = 8
      Top = 23
      Width = 31
      Height = 26
      Caption = 'Buffer depth:'
      WordWrap = True
    end
    object Label8: TLabel
      Left = 8
      Top = 55
      Width = 29
      Height = 13
      Caption = 'Strips:'
    end
    object Label9: TLabel
      Left = 8
      Top = 80
      Width = 46
      Height = 26
      Caption = 'Estimator radius'
      WordWrap = True
    end
    object Label11: TLabel
      Left = 160
      Top = 80
      Width = 46
      Height = 26
      Caption = 'Estimator min.'
      WordWrap = True
    end
    object Label12: TLabel
      Left = 160
      Top = 48
      Width = 46
      Height = 26
      Caption = 'Estimator curve'
      WordWrap = True
    end
    object Label14: TLabel
      Left = 160
      Top = 16
      Width = 39
      Height = 26
      Caption = 'Gamma threshold'
      WordWrap = True
    end
    object cmbDepth: TComboBox
      Left = 64
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
    object txtStrips: TEdit
      Left = 64
      Top = 52
      Width = 57
      Height = 21
      TabOrder = 1
      Text = '1'
      OnChange = txtBatchesChange
    end
    object udStrips: TUpDown
      Left = 121
      Top = 52
      Width = 12
      Height = 21
      Associate = txtStrips
      Min = 1
      Max = 512
      Position = 1
      TabOrder = 2
    end
    object txtEstimator: TEdit
      Left = 64
      Top = 84
      Width = 57
      Height = 21
      TabOrder = 3
      Text = '5'
      OnChange = txtEstimatorChange
    end
    object txtEstimatorMin: TEdit
      Left = 224
      Top = 84
      Width = 57
      Height = 21
      TabOrder = 4
      Text = '0'
      OnChange = txtEstimatorMinChange
    end
    object txtEstimatorCurve: TEdit
      Left = 224
      Top = 52
      Width = 57
      Height = 21
      TabOrder = 5
      Text = '0.6'
      OnChange = txtEstimatorCurveChange
    end
    object txtGammaTreshold: TEdit
      Left = 224
      Top = 20
      Width = 57
      Height = 21
      TabOrder = 6
      Text = '0.01'
      OnChange = txtGammaTresholdChange
    end
  end
  object chkRender: TCheckBox
    Left = 328
    Top = 270
    Width = 65
    Height = 17
    Caption = 'Render'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object Panel1: TPanel
    Left = 8
    Top = 296
    Width = 409
    Height = 81
    BevelInner = bvLowered
    Color = clBackground
    TabOrder = 7
    DesignSize = (
      409
      81)
    object Label6: TLabel
      Left = 152
      Top = 4
      Width = 104
      Height = 24
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      Caption = 'WARNING!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label15: TLabel
      Left = 8
      Top = 28
      Width = 393
      Height = 45
      Alignment = taCenter
      Anchors = [akLeft, akRight]
      AutoSize = False
      Caption = 
        'Fractals created with this 3D-hacked version of Apophysis are no' +
        't supported by the external renderer! To render 2D-only fractals' +
        ', download the latest version of FLAM3 from http://www.flam3.com'
      Color = clBackground
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
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
    Left = 376
    Top = 48
  end
end
