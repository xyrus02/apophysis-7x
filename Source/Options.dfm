object OptionsForm: TOptionsForm
  Left = 430
  Top = 204
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 296
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  HelpFile = 'Apophysis 2.0.chm'
  OldCreateOrder = True
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 304
    Top = 264
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 384
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object Tabs: TPageControl
    Left = 8
    Top = 8
    Width = 449
    Height = 249
    ActivePage = GeneralPage
    TabIndex = 0
    TabOrder = 0
    TabStop = False
    object GeneralPage: TTabSheet
      HelpContext = 1
      Caption = 'General'
      object chkConfirmDel: TCheckBox
        Left = 208
        Top = 8
        Width = 97
        Height = 17
        HelpContext = 1005
        Caption = 'Confirm delete'
        TabOrder = 2
      end
      object GroupBox13: TGroupBox
        Left = 8
        Top = 2
        Width = 193
        Height = 71
        Caption = 'Smooth palette'
        TabOrder = 0
        object Label8: TLabel
          Left = 10
          Top = 18
          Width = 78
          Height = 13
          Caption = 'Number of tries:'
        end
        object Label10: TLabel
          Left = 26
          Top = 42
          Width = 53
          Height = 13
          Caption = 'Try length:'
        end
        object txtNumtries: TEdit
          Left = 96
          Top = 16
          Width = 73
          Height = 21
          HelpContext = 1002
          TabOrder = 0
          Text = '50'
        end
        object txtTryLength: TEdit
          Left = 96
          Top = 40
          Width = 73
          Height = 21
          HelpContext = 1003
          TabOrder = 1
          Text = '10000'
        end
      end
      object JPEG: TGroupBox
        Left = 8
        Top = 74
        Width = 121
        Height = 57
        Caption = 'JPEG Quality'
        TabOrder = 1
        object txtJPEGQuality: TEdit
          Left = 16
          Top = 24
          Width = 73
          Height = 21
          HelpContext = 1004
          TabOrder = 0
          Text = '80'
        end
      end
      object chkFixedReference: TCheckBox
        Left = 208
        Top = 24
        Width = 145
        Height = 17
        Caption = 'Fixed reference triangle'
        TabOrder = 3
      end
      object GroupBox1: TGroupBox
        Left = 136
        Top = 74
        Width = 121
        Height = 57
        Caption = 'Batch size'
        TabOrder = 4
        object txtBatchSize: TEdit
          Left = 16
          Top = 24
          Width = 73
          Height = 21
          HelpContext = 1004
          TabOrder = 0
          Text = '100'
        end
        object udBatchSize: TUpDown
          Left = 89
          Top = 24
          Width = 13
          Height = 21
          Associate = txtBatchSize
          Min = 1
          Max = 300
          Position = 100
          TabOrder = 1
          Thousands = False
          Wrap = False
        end
      end
      object chkResize: TCheckBox
        Left = 208
        Top = 40
        Width = 169
        Height = 17
        Caption = 'Resize on load'
        TabOrder = 5
      end
    end
    object DisplayPage: TTabSheet
      Caption = 'Display'
      object GroupBox2: TGroupBox
        Left = 184
        Top = 8
        Width = 250
        Height = 97
        Caption = 'Preview density'
        TabOrder = 1
        object Label4: TLabel
          Left = 8
          Top = 19
          Width = 58
          Height = 13
          Caption = 'Low quality:'
        end
        object Label1: TLabel
          Left = 8
          Top = 43
          Width = 75
          Height = 13
          Caption = 'Medium quality:'
        end
        object Label30: TLabel
          Left = 8
          Top = 67
          Width = 60
          Height = 13
          Caption = 'High quality:'
        end
        object txtLowQuality: TEdit
          Left = 112
          Top = 16
          Width = 121
          Height = 21
          HelpContext = 1012
          TabOrder = 0
          Text = 'txtLowQuality'
        end
        object txtMediumQuality: TEdit
          Left = 112
          Top = 40
          Width = 121
          Height = 21
          HelpContext = 1013
          TabOrder = 1
          Text = 'txtMediumQuality'
        end
        object txtHighQuality: TEdit
          Left = 112
          Top = 64
          Width = 121
          Height = 21
          HelpContext = 1014
          TabOrder = 2
          Text = 'txtHighQuality'
        end
      end
      object grpRendering: TGroupBox
        Left = 8
        Top = 6
        Width = 169
        Height = 169
        Caption = 'Rendering'
        TabOrder = 0
        object lblSampleDensity: TLabel
          Left = 40
          Top = 19
          Width = 38
          Height = 13
          Caption = 'Quality:'
        end
        object lblGamma: TLabel
          Left = 40
          Top = 43
          Width = 39
          Height = 13
          Caption = 'Gamma:'
        end
        object lblBrightness: TLabel
          Left = 24
          Top = 67
          Width = 54
          Height = 13
          Caption = 'Brightness:'
        end
        object lblVibrancy: TLabel
          Left = 32
          Top = 91
          Width = 45
          Height = 13
          Caption = 'Vibrancy:'
        end
        object lblOversample: TLabel
          Left = 16
          Top = 115
          Width = 61
          Height = 13
          Caption = 'Oversample:'
        end
        object lblFilterRadius: TLabel
          Left = 16
          Top = 139
          Width = 63
          Height = 13
          Caption = 'Filter Radius:'
        end
        object txtSampleDensity: TEdit
          Left = 88
          Top = 16
          Width = 65
          Height = 21
          HelpContext = 1006
          TabOrder = 0
        end
        object txtGamma: TEdit
          Left = 88
          Top = 40
          Width = 65
          Height = 21
          HelpContext = 1007
          TabOrder = 1
        end
        object txtBrightness: TEdit
          Left = 88
          Top = 64
          Width = 65
          Height = 21
          HelpContext = 1008
          TabOrder = 2
        end
        object txtVibrancy: TEdit
          Left = 88
          Top = 88
          Width = 65
          Height = 21
          HelpContext = 1009
          TabOrder = 3
        end
        object txtOversample: TEdit
          Left = 88
          Top = 112
          Width = 65
          Height = 21
          HelpContext = 1010
          TabOrder = 4
        end
        object txtFilterRadius: TEdit
          Left = 88
          Top = 136
          Width = 65
          Height = 21
          HelpContext = 1011
          TabOrder = 5
        end
      end
    end
    object RandomPage: TTabSheet
      Caption = 'Random'
      object gpNumberOfTransforms: TGroupBox
        Left = 8
        Top = 6
        Width = 193
        Height = 75
        Caption = 'Number of transforms'
        TabOrder = 0
        object Label28: TLabel
          Left = 10
          Top = 19
          Width = 44
          Height = 13
          Caption = 'Minimum:'
        end
        object Label29: TLabel
          Left = 10
          Top = 45
          Width = 48
          Height = 13
          Caption = 'Maximum:'
        end
        object txtMinXForms: TEdit
          Left = 80
          Top = 16
          Width = 77
          Height = 21
          HelpContext = 1017
          TabOrder = 0
          Text = '2'
          OnChange = txtMinXFormsChange
        end
        object txtMaxXforms: TEdit
          Left = 80
          Top = 40
          Width = 77
          Height = 21
          HelpContext = 1018
          TabOrder = 1
          Text = '6'
          OnChange = txtMaxXformsChange
        end
        object udMinXforms: TUpDown
          Left = 157
          Top = 16
          Width = 12
          Height = 21
          Associate = txtMinXForms
          Min = 2
          Max = 12
          Position = 2
          TabOrder = 2
          Wrap = False
        end
        object udMaxXForms: TUpDown
          Left = 157
          Top = 40
          Width = 12
          Height = 21
          Associate = txtMaxXforms
          Min = 2
          Max = 12
          Position = 6
          TabOrder = 3
          Wrap = False
        end
      end
      object chkKeepBackground: TCheckBox
        Left = 208
        Top = 90
        Width = 161
        Height = 17
        HelpContext = 1023
        Caption = 'Keep background color'
        TabOrder = 4
      end
      object gpFlameTitlePrefix: TGroupBox
        Left = 8
        Top = 86
        Width = 193
        Height = 43
        Caption = 'Flame title prefix'
        TabOrder = 2
        object txtRandomPrefix: TEdit
          Left = 8
          Top = 16
          Width = 169
          Height = 21
          HelpContext = 1021
          TabOrder = 0
          Text = 'Apophysis'
        end
      end
      object gpMutationTransforms: TGroupBox
        Left = 208
        Top = 6
        Width = 193
        Height = 75
        Caption = 'Mutation transforms'
        TabOrder = 1
        object Label2: TLabel
          Left = 10
          Top = 19
          Width = 44
          Height = 13
          Caption = 'Minimum:'
        end
        object Label3: TLabel
          Left = 10
          Top = 45
          Width = 48
          Height = 13
          Caption = 'Maximum:'
        end
        object txtMinMutate: TEdit
          Left = 80
          Top = 16
          Width = 77
          Height = 21
          HelpContext = 1019
          TabOrder = 0
          Text = '2'
          OnChange = txtMinMutateChange
        end
        object txtMaxMutate: TEdit
          Left = 80
          Top = 40
          Width = 77
          Height = 21
          HelpContext = 1020
          TabOrder = 1
          Text = '6'
          OnChange = txtMaxMutateChange
        end
        object udMinMutate: TUpDown
          Left = 157
          Top = 16
          Width = 12
          Height = 21
          Associate = txtMinMutate
          Min = 2
          Max = 12
          Position = 2
          TabOrder = 2
          Wrap = False
        end
        object udMaxMutate: TUpDown
          Left = 157
          Top = 40
          Width = 12
          Height = 21
          Associate = txtMaxMutate
          Min = 2
          Max = 12
          Position = 6
          TabOrder = 3
          Wrap = False
        end
      end
      object gpForcedSymmetry: TGroupBox
        Left = 8
        Top = 136
        Width = 193
        Height = 72
        Caption = 'Forced symmetry'
        TabOrder = 3
        object Label7: TLabel
          Left = 8
          Top = 20
          Width = 32
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Type:'
        end
        object Label9: TLabel
          Left = 8
          Top = 48
          Width = 32
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Order:'
        end
        object cmbSymType: TComboBox
          Left = 48
          Top = 16
          Width = 137
          Height = 21
          HelpContext = 1024
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cmbSymTypeChange
          Items.Strings = (
            'None'
            'Bilateral'
            'Rotational'
            'Dihedral')
        end
        object txtSymOrder: TEdit
          Left = 48
          Top = 43
          Width = 121
          Height = 21
          HelpContext = 1025
          TabOrder = 1
          Text = '4'
        end
        object udSymOrder: TUpDown
          Left = 169
          Top = 43
          Width = 13
          Height = 21
          Associate = txtSymOrder
          Min = 2
          Max = 2000
          Position = 4
          TabOrder = 2
          Thousands = False
          Wrap = False
        end
      end
    end
    object VariationsPage: TTabSheet
      Caption = 'Variations'
      ImageIndex = 4
      object GroupBox17: TGroupBox
        Left = 8
        Top = 0
        Width = 341
        Height = 217
        HelpContext = 1026
        Caption = 'Enabled'
        TabOrder = 2
        object clbVarEnabled: TCheckListBox
          Left = 12
          Top = 16
          Width = 205
          Height = 189
          ItemHeight = 13
          TabOrder = 0
        end
      end
      object btnSetAll: TButton
        Left = 356
        Top = 160
        Width = 75
        Height = 25
        HelpContext = 1027
        Caption = 'Set All'
        TabOrder = 0
        OnClick = btnSetAllClick
      end
      object btnClearAll: TButton
        Left = 356
        Top = 192
        Width = 75
        Height = 25
        HelpContext = 1028
        Caption = 'Clear All'
        TabOrder = 1
        OnClick = btnClearAllClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Gradient'
      ImageIndex = 5
      object grpGradient: TRadioGroup
        Left = 8
        Top = 8
        Width = 137
        Height = 121
        HelpContext = 1029
        Caption = 'On random flame'
        ItemIndex = 0
        Items.Strings = (
          'Use random preset'
          'Use default'
          'Use current'
          'Randomize')
        TabOrder = 0
      end
      object GroupBox3: TGroupBox
        Left = 152
        Top = 8
        Width = 281
        Height = 193
        Caption = 'Randomize'
        TabOrder = 1
        object Label18: TLabel
          Left = 8
          Top = 24
          Width = 128
          Height = 13
          Caption = 'Minimum number of nodes:'
        end
        object Label19: TLabel
          Left = 8
          Top = 56
          Width = 128
          Height = 13
          Caption = 'Maximum number of nodes'
        end
        object Label31: TLabel
          Left = 8
          Top = 88
          Width = 64
          Height = 13
          Caption = 'Hue between'
        end
        object Label32: TLabel
          Left = 184
          Top = 88
          Width = 18
          Height = 13
          Caption = 'and'
        end
        object Label33: TLabel
          Left = 8
          Top = 120
          Width = 95
          Height = 13
          Caption = 'Saturation between'
        end
        object Label34: TLabel
          Left = 184
          Top = 120
          Width = 18
          Height = 13
          Caption = 'and'
        end
        object Label35: TLabel
          Left = 8
          Top = 152
          Width = 95
          Height = 13
          Caption = 'Luminance between'
        end
        object Label36: TLabel
          Left = 184
          Top = 152
          Width = 18
          Height = 13
          Caption = 'and'
        end
        object txtMinNodes: TEdit
          Left = 160
          Top = 24
          Width = 49
          Height = 21
          HelpContext = 1030
          TabOrder = 0
          Text = '2'
          OnChange = txtMinNodesChange
        end
        object txtMaxNodes: TEdit
          Left = 160
          Top = 56
          Width = 49
          Height = 21
          HelpContext = 1031
          TabOrder = 1
          Text = '2'
          OnChange = txtMaxNodesChange
        end
        object txtMinHue: TEdit
          Left = 112
          Top = 88
          Width = 49
          Height = 21
          HelpContext = 1032
          TabOrder = 2
          Text = '0'
          OnChange = txtMinHueChange
        end
        object txtMaxHue: TEdit
          Left = 208
          Top = 88
          Width = 49
          Height = 21
          HelpContext = 1033
          TabOrder = 3
          Text = '600'
          OnChange = txtMaxHueChange
        end
        object txtMinSat: TEdit
          Left = 112
          Top = 120
          Width = 49
          Height = 21
          HelpContext = 1034
          TabOrder = 4
          Text = '0'
          OnChange = txtMinSatChange
        end
        object txtMaxSat: TEdit
          Left = 208
          Top = 120
          Width = 49
          Height = 21
          HelpContext = 1035
          TabOrder = 5
          Text = '100'
          OnChange = txtMaxSatChange
        end
        object txtMinLum: TEdit
          Left = 112
          Top = 152
          Width = 49
          Height = 21
          HelpContext = 1036
          TabOrder = 6
          Text = '0'
          OnChange = txtMinLumChange
        end
        object txtMaxLum: TEdit
          Left = 208
          Top = 152
          Width = 49
          Height = 21
          HelpContext = 1037
          TabOrder = 7
          Text = '100'
          OnChange = txtMaxLumChange
        end
        object udMinNodes: TUpDown
          Left = 209
          Top = 24
          Width = 12
          Height = 21
          HelpContext = 1030
          Associate = txtMinNodes
          Min = 2
          Max = 64
          Position = 2
          TabOrder = 8
          Wrap = False
        end
        object udMaxNodes: TUpDown
          Left = 209
          Top = 56
          Width = 12
          Height = 21
          HelpContext = 1031
          Associate = txtMaxNodes
          Min = 2
          Max = 64
          Position = 2
          TabOrder = 9
          Wrap = False
        end
        object udMinHue: TUpDown
          Left = 161
          Top = 88
          Width = 12
          Height = 21
          HelpContext = 1032
          Associate = txtMinHue
          Min = 0
          Max = 600
          Position = 0
          TabOrder = 10
          Wrap = False
        end
        object udMaxHue: TUpDown
          Left = 257
          Top = 88
          Width = 12
          Height = 21
          HelpContext = 1033
          Associate = txtMaxHue
          Min = 0
          Max = 600
          Position = 600
          TabOrder = 11
          Wrap = False
        end
        object udMinSat: TUpDown
          Left = 161
          Top = 120
          Width = 12
          Height = 21
          HelpContext = 1034
          Associate = txtMinSat
          Min = 0
          Position = 0
          TabOrder = 12
          Wrap = False
        end
        object udmaxSat: TUpDown
          Left = 257
          Top = 120
          Width = 12
          Height = 21
          HelpContext = 1035
          Associate = txtMaxSat
          Min = 0
          Position = 100
          TabOrder = 13
          Wrap = False
        end
        object udMinLum: TUpDown
          Left = 161
          Top = 152
          Width = 12
          Height = 21
          HelpContext = 1036
          Associate = txtMinLum
          Min = 0
          Position = 0
          TabOrder = 14
          Wrap = False
        end
        object udMaxLum: TUpDown
          Left = 257
          Top = 152
          Width = 12
          Height = 21
          HelpContext = 1037
          Associate = txtMaxLum
          Min = 0
          Position = 100
          TabOrder = 15
          Wrap = False
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'UPR'
      ImageIndex = 5
      object UPRPage: TPageControl
        Left = 0
        Top = 4
        Width = 441
        Height = 249
        MultiLine = True
        Style = tsButtons
        TabOrder = 0
      end
      object GroupBox11: TGroupBox
        Left = 8
        Top = 112
        Width = 177
        Height = 73
        Caption = 'UPR size'
        TabOrder = 1
        object Label26: TLabel
          Left = 15
          Top = 21
          Width = 32
          Height = 13
          Caption = 'Width:'
        end
        object Label27: TLabel
          Left = 15
          Top = 49
          Width = 35
          Height = 13
          Caption = 'Height:'
        end
        object txtUPRWidth: TEdit
          Left = 96
          Top = 16
          Width = 69
          Height = 21
          TabOrder = 0
          Text = '640'
        end
        object txtUPRHeight: TEdit
          Left = 96
          Top = 40
          Width = 69
          Height = 21
          TabOrder = 1
          Text = '480'
        end
      end
      object GroupBox9: TGroupBox
        Left = 8
        Top = 6
        Width = 177
        Height = 99
        Caption = 'Parameter defaults'
        TabOrder = 2
        object Label20: TLabel
          Left = 10
          Top = 26
          Width = 76
          Height = 13
          Caption = 'Sample density:'
        end
        object Label21: TLabel
          Left = 10
          Top = 50
          Width = 60
          Height = 13
          Caption = 'Filter radius:'
        end
        object Label22: TLabel
          Left = 10
          Top = 74
          Width = 61
          Height = 13
          Caption = 'Oversample:'
        end
        object txtFIterDensity: TEdit
          Left = 96
          Top = 24
          Width = 67
          Height = 21
          TabOrder = 0
          Text = '35'
        end
        object txtUPRFilterRadius: TEdit
          Left = 96
          Top = 48
          Width = 67
          Height = 21
          TabOrder = 1
          Text = '0.7'
        end
        object txtUPROversample: TEdit
          Left = 96
          Top = 72
          Width = 67
          Height = 21
          TabOrder = 2
          Text = '3'
        end
      end
      object GroupBox4: TGroupBox
        Left = 192
        Top = 6
        Width = 245
        Height = 75
        Caption = 'Coloring algorithm'
        TabOrder = 3
        object Label11: TLabel
          Left = 10
          Top = 26
          Width = 48
          Height = 13
          Caption = 'Identifier:'
        end
        object Label12: TLabel
          Left = 10
          Top = 50
          Width = 20
          Height = 13
          Caption = 'File:'
        end
        object txtFCIdent: TEdit
          Left = 82
          Top = 24
          Width = 151
          Height = 21
          TabOrder = 0
          Text = 'enr-flame-a'
        end
        object txtFCFile: TEdit
          Left = 82
          Top = 48
          Width = 151
          Height = 21
          TabOrder = 1
          Text = 'apophysis.ucl'
        end
      end
      object GroupBox5: TGroupBox
        Left = 192
        Top = 87
        Width = 245
        Height = 82
        Caption = 'Fractal formula'
        TabOrder = 4
        object Label13: TLabel
          Left = 10
          Top = 26
          Width = 48
          Height = 13
          Caption = 'Identifier:'
        end
        object Label14: TLabel
          Left = 10
          Top = 50
          Width = 20
          Height = 13
          Caption = 'File:'
        end
        object txtFFIdent: TEdit
          Left = 82
          Top = 24
          Width = 151
          Height = 21
          TabOrder = 0
          Text = 'mt-pixel'
        end
        object txtFFFile: TEdit
          Left = 82
          Top = 48
          Width = 151
          Height = 21
          TabOrder = 1
          Text = 'mt.ufm'
        end
      end
      object chkAdjustDensity: TCheckBox
        Left = 192
        Top = 170
        Width = 169
        Height = 17
        Caption = 'Adjust sample density'
        TabOrder = 5
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Sheep'
      ImageIndex = 6
      object GroupBox6: TGroupBox
        Left = 8
        Top = 6
        Width = 245
        Height = 99
        Caption = 'Credit'
        TabOrder = 0
        object Label5: TLabel
          Left = 10
          Top = 18
          Width = 23
          Height = 13
          Caption = 'Nick:'
        end
        object Label6: TLabel
          Left = 10
          Top = 42
          Width = 23
          Height = 13
          Caption = 'URL:'
        end
        object Label15: TLabel
          Left = 10
          Top = 66
          Width = 50
          Height = 13
          Caption = 'Password:'
          Visible = False
        end
        object txtNick: TEdit
          Left = 82
          Top = 16
          Width = 151
          Height = 21
          TabOrder = 0
        end
        object txtURL: TEdit
          Left = 82
          Top = 40
          Width = 151
          Height = 21
          TabOrder = 1
        end
        object txtPassword: TEdit
          Left = 82
          Top = 64
          Width = 151
          Height = 21
          Enabled = False
          TabOrder = 2
          Visible = False
        end
      end
      object GroupBox8: TGroupBox
        Left = 8
        Top = 106
        Width = 425
        Height = 51
        Caption = 'Server'
        TabOrder = 1
        object Label17: TLabel
          Left = 10
          Top = 20
          Width = 43
          Height = 13
          Caption = 'Address:'
        end
        object txtServer: TEdit
          Left = 67
          Top = 19
          Width = 310
          Height = 21
          HelpContext = 1000
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
        end
      end
    end
    object Paths: TTabSheet
      Caption = 'Paths'
      ImageIndex = 7
      object GroupBox10: TGroupBox
        Left = 8
        Top = 0
        Width = 425
        Height = 51
        Caption = 'Default parameter file'
        TabOrder = 0
        object btnDefGradient: TSpeedButton
          Left = 392
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
          OnClick = btnDefGradientClick
        end
        object Label25: TLabel
          Left = 10
          Top = 20
          Width = 49
          Height = 13
          Caption = 'File name:'
        end
        object txtDefParameterFile: TEdit
          Left = 67
          Top = 19
          Width = 310
          Height = 21
          HelpContext = 1000
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
        end
      end
      object GroupBox12: TGroupBox
        Left = 8
        Top = 54
        Width = 425
        Height = 51
        Caption = 'Smooth palette file'
        TabOrder = 1
        object Label23: TLabel
          Left = 10
          Top = 20
          Width = 49
          Height = 13
          Caption = 'File name:'
        end
        object btnSmooth: TSpeedButton
          Left = 392
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
          OnClick = btnSmoothClick
        end
        object txtDefSmoothFile: TEdit
          Left = 67
          Top = 16
          Width = 310
          Height = 21
          HelpContext = 1001
          TabOrder = 0
        end
      end
      object GroupBox7: TGroupBox
        Left = 8
        Top = 162
        Width = 425
        Height = 51
        Caption = 'Export renderer'
        TabOrder = 2
        object btnRenderer: TSpeedButton
          Left = 392
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
          OnClick = btnRendererClick
        end
        object Label16: TLabel
          Left = 10
          Top = 20
          Width = 49
          Height = 13
          Caption = 'File name:'
        end
        object txtRenderer: TEdit
          Left = 67
          Top = 19
          Width = 310
          Height = 21
          HelpContext = 1000
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
        end
      end
      object GroupBox14: TGroupBox
        Left = 8
        Top = 108
        Width = 425
        Height = 51
        Caption = 'Function library'
        TabOrder = 3
        object SpeedButton2: TSpeedButton
          Left = 392
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
          OnClick = SpeedButton2Click
        end
        object Label37: TLabel
          Left = 10
          Top = 20
          Width = 49
          Height = 13
          Caption = 'File name:'
        end
        object txtLibrary: TEdit
          Left = 67
          Top = 19
          Width = 310
          Height = 21
          HelpContext = 1000
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
        end
      end
    end
  end
  object OpenDialog: TOpenDialog
    Left = 16
    Top = 264
  end
end
