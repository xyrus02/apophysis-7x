object RenderForm: TRenderForm
  Left = 431
  Top = 336
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Render to Disk'
  ClientHeight = 449
  ClientWidth = 434
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
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000000000000000005F97013B5500000000000000
    0000000000000000000000000000000000000000000000005F97013B55000000
    000000005F97181818000000000000005F971818180000000000000000000000
    00000000000000005F97013B55005F97005F97005F971818181A0155005F9700
    5F97181818000000000000000000000000000000005F97E4F2FB0088D9005F97
    1A015537BBFD0088D91A0155005F970088D90088D91818180000000000000000
    00000000005F97005F97E4F2FB0088D985E8FF85E8FF85E8FF37BBFD0088D9E4
    F2FB181818005F97000000000000000000000000005F97013B55005F9785E8FF
    37BBFD005F97005F9737BBFD85E8FF0088D9005F97005F970000000000000000
    00000000013B5585E8FF85E8FF85E8FF005F9737BBFD0088D9005F9785E8FF85
    E8FFE4F2FB005F97000000000000000000000000000000005F970088D9005F97
    005F9785E8FF0088D9005F97005F970088D9005F970000000000000000000000
    00000000000000005F97E8E8E80088D9005F9785E8FF0088D9005F970088D9E4
    F2FB005F970000000000000000000000000000000000000088D9005F97000000
    005F9785E8FF0088D9005F970000000088D90088D90000000000000000000000
    00000000000000000000000000000000005F97E4F2FBE4F2FB005F9700000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000005F97005F970000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    0000FFFF0000FE7F0000E6670000E0070000C0030000C0030000C0030000C003
    0000E0070000E0070000E4270000FC3F0000FE7F0000FFFF0000FFFF0000}
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar: TProgressBar
    Left = 0
    Top = 417
    Width = 434
    Height = 13
    Align = alBottom
    TabOrder = 0
  end
  object btnRender: TButton
    Left = 264
    Top = 388
    Width = 75
    Height = 23
    Caption = 'Render'
    Default = True
    TabOrder = 1
    OnClick = btnRenderClick
  end
  object btnCancel: TButton
    Left = 352
    Top = 386
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnPause: TButton
    Left = 176
    Top = 386
    Width = 75
    Height = 25
    Caption = 'Pause'
    TabOrder = 3
    OnClick = btnPauseClick
  end
  object chkSave: TCheckBox
    Left = 8
    Top = 358
    Width = 113
    Height = 17
    Caption = 'Save parameters'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 430
    Width = 434
    Height = 19
    Panels = <
      item
        Width = 161
      end
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object chkShutdown: TCheckBox
    Left = 8
    Top = 396
    Width = 137
    Height = 17
    Caption = 'Shutdown on complete'
    TabOrder = 6
  end
  object chkPostProcess: TCheckBox
    Left = 8
    Top = 377
    Width = 121
    Height = 17
    Caption = 'Postprocess render'
    TabOrder = 5
  end
  object chkSaveIncompleteRenders: TCheckBox
    Left = 288
    Top = 358
    Width = 137
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Save incomplete renders'
    TabOrder = 8
    OnClick = chkSaveIncompleteRendersClick
  end
  object PageCtrl: TPageControl
    Left = 0
    Top = 0
    Width = 433
    Height = 353
    ActivePage = TabSettings
    Images = MainForm.Buttons
    TabOrder = 9
    object TabSettings: TTabSheet
      Caption = 'Settings'
      ImageIndex = 18
      object GroupBox5: TGroupBox
        Left = 8
        Top = 8
        Width = 408
        Height = 57
        Caption = 'Preset'
        TabOrder = 0
        object btnSavePreset: TSpeedButton
          Left = 344
          Top = 18
          Width = 24
          Height = 24
          Hint = 'Save Preset'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = btnSavePresetClick
        end
        object btnDeletePreset: TSpeedButton
          Left = 368
          Top = 18
          Width = 24
          Height = 24
          Hint = 'Delete Preset'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = btnDeletePresetClick
        end
        object cmbPreset: TComboBox
          Left = 10
          Top = 20
          Width = 327
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cmbPresetChange
        end
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 69
        Width = 408
        Height = 57
        Caption = 'Destination'
        TabOrder = 1
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
          OnChange = txtFilenameChange
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 130
        Width = 200
        Height = 105
        Caption = 'Size'
        TabOrder = 2
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
          BiDiMode = bdRightToLeftNoAlign
          Enabled = False
          ItemHeight = 13
          ParentBiDiMode = False
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
          BiDiMode = bdRightToLeftNoAlign
          Enabled = False
          ItemHeight = 13
          ParentBiDiMode = False
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
            '1920'
            '2048'
            '2400')
        end
      end
      object GroupBox3: TGroupBox
        Left = 216
        Top = 130
        Width = 200
        Height = 105
        Caption = 'Rendering'
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
          BiDiMode = bdRightToLeft
          Enabled = False
          ParentBiDiMode = False
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
          BiDiMode = bdRightToLeft
          ParentBiDiMode = False
          TabOrder = 1
          OnChange = txtFilterRadiusChange
        end
        object udOversample: TUpDown
          Left = 169
          Top = 68
          Width = 13
          Height = 21
          Associate = txtOversample
          Min = 1
          Max = 16
          Position = 2
          TabOrder = 3
        end
        object txtDensity: TComboBox
          Left = 112
          Top = 20
          Width = 57
          Height = 21
          AutoComplete = False
          ItemHeight = 13
          TabOrder = 0
          OnChange = txtDensityChange
          OnCloseUp = txtDensityChange
          Items.Strings = (
            '200'
            '500'
            '1000'
            '2000'
            '4000')
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 238
        Width = 409
        Height = 81
        Caption = 'Memory usage'
        TabOrder = 4
        object lblApproxMem: TLabel
          Left = 359
          Top = 52
          Width = 42
          Height = 13
          Alignment = taRightJustify
          Caption = '0000 Mb'
        end
        object lblPhysical: TLabel
          Left = 359
          Top = 32
          Width = 42
          Height = 13
          Alignment = taRightJustify
          Caption = '0000 Mb'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label6: TLabel
          Left = 216
          Top = 32
          Width = 126
          Height = 13
          Caption = 'Available physical memory:'
        end
        object Label7: TLabel
          Left = 216
          Top = 52
          Width = 119
          Height = 13
          Caption = 'Approx. memory required:'
        end
        object Label8: TLabel
          Left = 12
          Top = 24
          Width = 61
          Height = 13
          Caption = 'Buffer depth:'
        end
        object lblMaxbits: TLabel
          Left = 368
          Top = 12
          Width = 33
          Height = 13
          Hint = '- No render stats -'
          Alignment = taRightJustify
          Caption = '99.999'
          ParentShowHint = False
          ShowHint = True
        end
        object Label9: TLabel
          Left = 216
          Top = 12
          Width = 96
          Height = 13
          Hint = '- No render stats -'
          Caption = 'Max bits per sample:'
          ParentShowHint = False
          ShowHint = True
        end
        object cbMaxMemory: TComboBox
          Left = 144
          Top = 48
          Width = 57
          Height = 21
          BiDiMode = bdRightToLeftNoAlign
          Enabled = False
          ItemHeight = 13
          ParentBiDiMode = False
          TabOrder = 1
          Items.Strings = (
            '32'
            '64'
            '128'
            '256'
            '512'
            '1024'
            '1536')
        end
        object chkLimitMem: TCheckBox
          Left = 12
          Top = 52
          Width = 125
          Height = 17
          Caption = 'Limit memory usage to:'
          TabOrder = 0
          OnClick = chkLimitMemClick
        end
        object cbBitsPerSample: TComboBox
          Left = 88
          Top = 20
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          OnSelect = cbBitsPerSampleSelect
          Items.Strings = (
            '32-bit integer'
            '32-bit floating-point'
            '48-bit integer')
        end
      end
    end
    object TabOutput: TTabSheet
      Caption = 'Output'
      ImageIndex = 38
      object Output: TMemo
        Left = 8
        Top = 8
        Width = 409
        Height = 309
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object chkThreadPriority: TCheckBox
    Left = 176
    Top = 358
    Width = 73
    Height = 17
    Caption = 'Low priority'
    TabOrder = 10
    OnClick = chkThreadPriorityClick
  end
  object SaveDialog: TSaveDialog
    Left = 136
    Top = 360
  end
end
