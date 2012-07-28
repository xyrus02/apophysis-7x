object OptionsForm: TOptionsForm
  Left = 899
  Top = 428
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsSingle
  Caption = 'Options'
  ClientHeight = 438
  ClientWidth = 487
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  HelpFile = 'Apophysis 2.0.chm'
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000040040000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000007C75
    73FF4E4B4BFF544F4DFF544F4DFF544F4DFF56514DFF53504CFF524F4BFF524F
    4CFF524F4BFF514E4BFF544E46FF00000000000000000000000000000000D9CF
    C8FFFFFFFFFFFBFDFFFFFBFDFFFFFFFFF6FFFFFFF6FFFFFFF6FFFFF9ECFFFFF0
    E1FFFFEAD5FFFFEAD2FF544E46FF00000000000000000000000000000000D2C8
    C1FFFFFFFFFFC4AFA2FFC4AFA2FFFFFBF9FFC4AFA2FFC4AFA2FFC4AFA2FFC4AF
    A2FFC4AFA2FFFDDECBFF544E46FF00000000000000000000000000000000D2C8
    C1FFFFFFFFFFFBFDFFFFFBFDFFFFFFFEFCFFFDFAF8FFFBF4EFFFFBEEE6FFFAE9
    DEFFF8E2D2FFFFE2D0FF544E46FF00000000000000000000000000000000D3C9
    C2FFFFFFFFFFC4AFA2FFC4AFA2FFFFFFFEFFC4AFA2FFC4AFA2FFC4AFA2FFC4AF
    A2FFC4AFA2FFFFE5D6FF544E46FF00000000000000000000000000000000D1C7
    C0FFFFFFFFFFFBFDFFFFFBFDFFFFFFFFFFFFFEFEFDFFFEFBF8FFFDF6F2FFFCF0
    E8FFFCF0E8FFFFE9DCFF544E46FF00000000000000000000000000000000D1C8
    C1FFFFFFFFFFFBFDFFFFFBFDFFFFFFFFFFFFFFFFFFFFFEFEFCFFB0ADACFF415C
    72FFE3D9D3FFFFEDE3FF544E46FF00000000000000000000000000000000D1C8
    C1FFFFFFFFFFE2E9E9FF5E7584FFDFE4E5FFFFFFFFFFC2CACEFF4A6170FF2EA9
    D6FF0B101BFF5D5C60FFA49D96FF00000000000000001C6629791C6629FFDF9D
    7DFFF1CAB7FF8FA4ACFF86D3E5FF4B6170FFA79289FF4A6170FF61C1DEFF574D
    59FF1FD0FFFF152733FF10070AFF02212EFF4F5665FF59785BFF188C32FFDF9D
    7DFFFFC5A4FFE5C9B9FF8FA4ACFF83E1F6FF4B6170FF7ACDE2FF526067FF68ED
    FFFF413D50FF32B2DFFF1D99C8FF1593C4FF14628EFF406651FF29973FFFDF9D
    7DFFDF9D7DFFDF9D7DFFDABAAAFF8FA4ACFF7FE3F9FF538495FF68EDFFFF303A
    4FFF69DBF6FF58D2F3FF40C3EDFF31BBEAFF11A8ECFF50908CFF329E41FF0000
    0000000000000000000000000000869BA43341576FE168EDFFFF5898AEFF6EEB
    FFFF72E1F9FF6ADDF7FF56CFF2FF4BC7EDFF22BAFAFF5FA2A6FF41AC53FF0000
    0000000000000000000000000000A2AAB7A686E0F7A642566BDD6EEBFFFF6EEB
    FFFF6EEBFFFF72E2FAFF67D7F4FF54BDDCFF51728BFF699C89FF85CC85FF0000
    0000000000000000000096AAB005939EACDA86AEBCE06778854880A5B4FC8097
    A3FF8096A0FF7A8F99FF738593FF5B7080FE7A8B967A41AC538741AC53C00000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    0000000F0000000F0000000F0000000F0000000F0000000F0000000F0000000C
    0000000000000000000000000000F0000000F0000000E0000000FFFF0000}
  OldCreateOrder = True
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    487
    438)
  PixelsPerInch = 96
  TextHeight = 13
  object Label45: TLabel
    Left = 16
    Top = 600
    Width = 244
    Height = 26
    Caption = 
      'You must restart Apophysis when changed thumbnail size to see ef' +
      'fect!'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object GroupBox15: TGroupBox
    Left = 64
    Top = 108
    Width = 297
    Height = 69
    Caption = 'On render complete'
    TabOrder = 2
    object btnBrowseSound: TSpeedButton
      Left = 264
      Top = 41
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
      OnClick = btnBrowseSoundClick
    end
    object btnPlay: TSpeedButton
      Left = 264
      Top = 14
      Width = 24
      Height = 24
      Hint = 'Play'
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
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFDEEAE0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF096314DEEAE0FF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF11681B04600FDEEAE0FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1A6F2420732C04
        600FDEEAE0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF23752E2F833D20732C04600FDEEAE0FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF2E7C3750A25A2F
        833D20732C04600FDEEAE0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF3883415DB06850A25A2F833D20732C0B6618DEEAE0FF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF438A4C6BBF766B
        BF7650A25A2F7639D6EDD9FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF4B90536BBF76A3DAB02F7639D6EDD9FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF52945AA3DAB02F
        7639D6EDD9FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF5898602F7639D6EDD9FF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF589860D6EDD9FF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFD6EDD9FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = btnPlayClick
    end
    object Label44: TLabel
      Left = 10
      Top = 44
      Width = 49
      Height = 13
      Caption = 'File name:'
    end
    object txtSoundFile: TEdit
      Left = 64
      Top = 42
      Width = 193
      Height = 21
      HelpContext = 1000
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
    end
    object chkPlaysound: TCheckBox
      Left = 8
      Top = 18
      Width = 81
      Height = 17
      Caption = 'Play sound'
      TabOrder = 1
    end
  end
  object Tabs: TPageControl
    Left = 8
    Top = 8
    Width = 475
    Height = 396
    ActivePage = GeneralPage
    Anchors = [akLeft, akTop, akRight, akBottom]
    MultiLine = True
    TabOrder = 3
    TabStop = False
    object GeneralPage: TTabSheet
      HelpContext = 1
      Caption = 'General'
      DesignSize = (
        467
        368)
      object SpeedButton1: TSpeedButton
        Left = 437
        Top = 7
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
        OnClick = SpeedButton1Click
      end
      object pnlJPEGQuality: TPanel
        Left = 8
        Top = 36
        Width = 105
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'JPEG Quality'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
      end
      object chkConfirmDel: TCheckBox
        Left = 236
        Top = 143
        Width = 221
        Height = 17
        HelpContext = 1005
        Caption = 'Confirm delete'
        TabOrder = 0
      end
      object chkOldPaletteFormat: TCheckBox
        Left = 236
        Top = 92
        Width = 221
        Height = 13
        Caption = 'Save gradient in old file format'
        TabOrder = 1
        WordWrap = True
      end
      object chkConfirmExit: TCheckBox
        Left = 236
        Top = 169
        Width = 221
        Height = 17
        HelpContext = 1005
        Caption = 'Confirm exit'
        TabOrder = 2
      end
      object chkConfirmStopRender: TCheckBox
        Left = 236
        Top = 194
        Width = 221
        Height = 17
        Caption = 'Confirm stop render'
        TabOrder = 3
      end
      object cbUseTemplate: TCheckBox
        Left = 236
        Top = 40
        Width = 221
        Height = 17
        Caption = 'Always create blank flame'
        TabOrder = 4
      end
      object cbMissingPlugin: TCheckBox
        Left = 236
        Top = 65
        Width = 221
        Height = 17
        Caption = 'Warn when plugins are missing'
        TabOrder = 5
        WordWrap = True
      end
      object cbEmbedThumbs: TCheckBox
        Left = 236
        Top = 115
        Width = 221
        Height = 17
        Caption = 'Enable thumbnail embedding'
        TabOrder = 6
        WordWrap = True
      end
      object chkShowRenderStats: TCheckBox
        Left = 236
        Top = 219
        Width = 221
        Height = 17
        Caption = 'Show extended render statistics'
        TabOrder = 7
      end
      object pnlMultithreading: TPanel
        Left = 8
        Top = 92
        Width = 105
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'Multithreading'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
      end
      object cbNrTheads: TComboBox
        Left = 112
        Top = 92
        Width = 113
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 9
        Text = 'Off'
        Items.Strings = (
          'Off'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12')
      end
      object pnlPNGTransparency: TPanel
        Left = 8
        Top = 64
        Width = 105
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'PNG Transparency'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 12
      end
      object grpGuidelines: TGroupBox
        Left = 8
        Top = 124
        Width = 217
        Height = 141
        Anchors = [akLeft, akTop, akBottom]
        Caption = 'Guidelines'
        TabOrder = 14
        object cbGL: TCheckBox
          Left = 8
          Top = 23
          Width = 193
          Height = 17
          Caption = 'Enable'
          TabOrder = 0
          OnClick = cbGLClick
        end
        object pnlCenterLine: TPanel
          Left = 112
          Top = 48
          Width = 97
          Height = 21
          Cursor = crHandPoint
          BevelInner = bvRaised
          BevelOuter = bvLowered
          BorderStyle = bsSingle
          Color = clBlack
          TabOrder = 1
          OnClick = pnlCenterLineClick
          object shCenterLine: TShape
            Left = 2
            Top = 2
            Width = 89
            Height = 13
            Align = alClient
            OnMouseUp = shCenterLineMouseUp
          end
        end
        object pnlThirdsLine: TPanel
          Left = 112
          Top = 72
          Width = 97
          Height = 21
          Cursor = crHandPoint
          BevelInner = bvRaised
          BevelOuter = bvLowered
          BorderStyle = bsSingle
          Color = clBlack
          TabOrder = 2
          OnClick = pnlThirdsLineClick
          object shThirdsLine: TShape
            Left = 2
            Top = 2
            Width = 89
            Height = 13
            Align = alClient
            OnMouseUp = shThirdsLineMouseUp
          end
        end
        object pnlGRLine: TPanel
          Left = 112
          Top = 96
          Width = 97
          Height = 21
          Cursor = crHandPoint
          BevelInner = bvRaised
          BevelOuter = bvLowered
          BorderStyle = bsSingle
          Color = clBlack
          TabOrder = 3
          OnClick = pnlGRLineClick
          object shGRLine: TShape
            Left = 2
            Top = 2
            Width = 89
            Height = 13
            Align = alClient
            OnMouseUp = shGRLineMouseUp
          end
        end
        object pnlCenter: TPanel
          Left = 8
          Top = 48
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Center'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
        end
        object pnlThirds: TPanel
          Left = 8
          Top = 72
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Thirds'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
        object pnlGoldenRatio: TPanel
          Left = 8
          Top = 96
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Golden ratio'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
        end
      end
      object rgRotationMode: TRadioGroup
        Left = 5
        Top = 272
        Width = 220
        Height = 81
        Anchors = [akLeft, akBottom]
        Caption = 'Rotation Mode'
        Items.Strings = (
          'Rotate image'
          'Rotate frame')
        TabOrder = 15
      end
      object rgZoomingMode: TRadioGroup
        Left = 232
        Top = 272
        Width = 226
        Height = 81
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Zooming mode'
        Items.Strings = (
          'Preserve quality'
          'Preserve speed')
        TabOrder = 16
      end
      object Panel46: TPanel
        Left = 8
        Top = 8
        Width = 105
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'Language file'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 17
      end
      object txtLanguageFile: TComboBox
        Left = 112
        Top = 8
        Width = 323
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 18
      end
      object cbPNGTransparency: TComboBox
        Left = 112
        Top = 64
        Width = 113
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 13
        Text = 'Disabled'
        Items.Strings = (
          'Disabled'
          'Enabled')
      end
      object txtJPEGquality: TComboBox
        Left = 112
        Top = 36
        Width = 113
        Height = 21
        ItemIndex = 2
        TabOrder = 11
        Text = '100'
        Items.Strings = (
          '60'
          '80'
          '100'
          '120')
      end
      object cbSinglePrecision: TCheckBox
        Left = 236
        Top = 243
        Width = 193
        Height = 17
        Caption = 'Use single-precision buffers'
        TabOrder = 19
        Visible = False
      end
    end
    object EditorPage: TTabSheet
      Caption = 'Editor'
      ImageIndex = 8
      DesignSize = (
        467
        368)
      object GroupBox1: TGroupBox
        Left = 8
        Top = 4
        Width = 217
        Height = 61
        Caption = 'Editor Graph'
        TabOrder = 0
        object chkUseXFormColor: TCheckBox
          Left = 8
          Top = 16
          Width = 201
          Height = 17
          Caption = 'Use transform color'
          TabOrder = 0
        end
        object chkHelpers: TCheckBox
          Left = 8
          Top = 36
          Width = 201
          Height = 17
          Caption = 'Helper lines'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
      end
      object rgReferenceMode: TRadioGroup
        Left = 240
        Top = 96
        Width = 222
        Height = 105
        Anchors = [akTop, akRight]
        Caption = 'Reference Triangle'
        ItemIndex = 0
        Items.Strings = (
          'Normal'
          'Proportional'
          'Wandering (old-style)')
        TabOrder = 1
        Visible = False
      end
      object GroupBox21: TGroupBox
        Left = 240
        Top = 4
        Width = 222
        Height = 85
        Anchors = [akTop, akRight]
        Caption = 'Editor defaults'
        TabOrder = 2
        object chkAxisLock: TCheckBox
          Left = 8
          Top = 38
          Width = 209
          Height = 17
          Caption = 'Lock transform axis'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object chkExtendedEdit: TCheckBox
          Left = 8
          Top = 18
          Width = 209
          Height = 17
          Caption = 'Extended edit mode'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object chkXaosRebuild: TCheckBox
          Left = 8
          Top = 58
          Width = 209
          Height = 17
          Caption = 'Rebuild xaos links'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
      end
      object grpEditorColors: TGroupBox
        Left = 8
        Top = 72
        Width = 217
        Height = 129
        Caption = 'Editor colors'
        TabOrder = 3
        object pnlBackground: TPanel
          Left = 8
          Top = 24
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Background'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
        object pnlReferenceC: TPanel
          Left = 8
          Top = 48
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Reference'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
        end
        object pnlHelpers: TPanel
          Left = 8
          Top = 72
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Helpers'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
        end
        object pnlGrid: TPanel
          Left = 8
          Top = 96
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Grid'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 8
        end
        object pnlBackColor: TPanel
          Left = 112
          Top = 24
          Width = 97
          Height = 21
          Cursor = crHandPoint
          BevelOuter = bvLowered
          BorderStyle = bsSingle
          Color = clBlack
          TabOrder = 0
          OnClick = pnlBackColorClick
          object shBackground: TShape
            Left = 1
            Top = 1
            Width = 91
            Height = 15
            Align = alClient
            Pen.Style = psClear
            OnMouseUp = shBackgroundMouseUp
          end
        end
        object pnlReference: TPanel
          Left = 112
          Top = 48
          Width = 97
          Height = 21
          Cursor = crHandPoint
          BevelOuter = bvLowered
          BorderStyle = bsSingle
          Color = clGray
          TabOrder = 1
          OnClick = pnlReferenceClick
          object shRef: TShape
            Left = 1
            Top = 1
            Width = 91
            Height = 15
            Align = alClient
            Pen.Style = psClear
            OnMouseUp = shRefMouseUp
          end
        end
        object pnlHelpersColor: TPanel
          Left = 112
          Top = 72
          Width = 97
          Height = 21
          Cursor = crHandPoint
          BevelOuter = bvLowered
          BorderStyle = bsSingle
          Color = clGray
          TabOrder = 2
          OnClick = pnlHelpersColorClick
          object shHelpers: TShape
            Left = 1
            Top = 1
            Width = 91
            Height = 15
            Align = alClient
            Pen.Style = psClear
            OnMouseUp = shHelpersMouseUp
          end
        end
        object pnlGridColor1: TPanel
          Left = 112
          Top = 96
          Width = 49
          Height = 21
          Cursor = crHandPoint
          BevelOuter = bvLowered
          BorderStyle = bsSingle
          Color = clBlack
          TabOrder = 3
          OnClick = pnlGridColor1Click
          object shGC1: TShape
            Left = 1
            Top = 1
            Width = 43
            Height = 15
            Align = alClient
            Pen.Style = psClear
            OnMouseUp = shGC1MouseUp
          end
        end
        object pnlGridColor2: TPanel
          Left = 164
          Top = 96
          Width = 45
          Height = 21
          Cursor = crHandPoint
          BevelOuter = bvLowered
          BorderStyle = bsSingle
          Color = clBlack
          TabOrder = 4
          OnClick = pnlGridColor2Click
          object shGC2: TShape
            Left = 1
            Top = 1
            Width = 39
            Height = 15
            Align = alClient
            Pen.Style = psClear
            OnMouseUp = shGC2MouseUp
          end
        end
      end
      object chkShowAllXforms: TCheckBox
        Left = 8
        Top = 264
        Width = 454
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Always show both type of transforms'
        Checked = True
        State = cbChecked
        TabOrder = 4
        WordWrap = True
      end
      object chkEnableEditorPreview: TCheckBox
        Left = 8
        Top = 208
        Width = 449
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Enable editor preview'
        TabOrder = 5
        OnClick = chkEnableEditorPreviewClick
      end
      object Panel48: TPanel
        Left = 16
        Top = 232
        Width = 105
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'Transparency'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
      object tbEPTransparency: TTrackBar
        Left = 128
        Top = 230
        Width = 329
        Height = 25
        Anchors = [akLeft, akTop, akRight]
        LineSize = 4
        Max = 255
        PageSize = 32
        Frequency = 16
        TabOrder = 7
      end
    end
    object DisplayPage: TTabSheet
      Caption = 'Display'
      DesignSize = (
        467
        368)
      object GroupBox2: TGroupBox
        Left = 253
        Top = 84
        Width = 209
        Height = 109
        Anchors = [akTop, akRight]
        Caption = 'Preview density'
        TabOrder = 1
        object Panel8: TPanel
          Left = 8
          Top = 24
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Low quality'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
        object Panel9: TPanel
          Left = 8
          Top = 48
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Medium quality'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
        end
        object Panel10: TPanel
          Left = 8
          Top = 72
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'High quality'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
        object txtHighQuality: TEdit
          Left = 112
          Top = 72
          Width = 81
          Height = 21
          HelpContext = 1014
          TabOrder = 2
        end
        object txtMediumQuality: TEdit
          Left = 112
          Top = 48
          Width = 81
          Height = 21
          HelpContext = 1013
          TabOrder = 1
        end
        object txtLowQuality: TEdit
          Left = 112
          Top = 24
          Width = 81
          Height = 21
          HelpContext = 1012
          TabOrder = 0
        end
      end
      object grpRendering: TGroupBox
        Left = 8
        Top = 84
        Width = 217
        Height = 205
        Caption = 'Rendering'
        TabOrder = 0
        object Panel1: TPanel
          Left = 8
          Top = 24
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Density'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
        end
        object Panel2: TPanel
          Left = 8
          Top = 48
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Gamma'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 8
        end
        object Panel3: TPanel
          Left = 8
          Top = 72
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Brightness'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 9
        end
        object Panel4: TPanel
          Left = 8
          Top = 96
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Vibrancy'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 10
        end
        object Panel5: TPanel
          Left = 8
          Top = 120
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Gamma threshold'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 11
        end
        object Panel6: TPanel
          Left = 8
          Top = 144
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Oversample'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 12
        end
        object Panel7: TPanel
          Left = 8
          Top = 168
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Filter radius'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 13
        end
        object txtGammaThreshold: TEdit
          Left = 112
          Top = 120
          Width = 89
          Height = 21
          HelpContext = 1011
          TabOrder = 6
        end
        object txtFilterRadius: TEdit
          Left = 112
          Top = 168
          Width = 89
          Height = 21
          HelpContext = 1011
          TabOrder = 5
        end
        object txtOversample: TEdit
          Left = 112
          Top = 144
          Width = 89
          Height = 21
          HelpContext = 1010
          TabOrder = 4
        end
        object txtVibrancy: TEdit
          Left = 112
          Top = 96
          Width = 89
          Height = 21
          HelpContext = 1009
          TabOrder = 3
        end
        object txtBrightness: TEdit
          Left = 112
          Top = 72
          Width = 89
          Height = 21
          HelpContext = 1008
          TabOrder = 2
        end
        object txtGamma: TEdit
          Left = 112
          Top = 48
          Width = 89
          Height = 21
          HelpContext = 1007
          TabOrder = 1
        end
        object txtSampleDensity: TEdit
          Left = 112
          Top = 24
          Width = 89
          Height = 21
          HelpContext = 1006
          TabOrder = 0
        end
      end
      object GroupBox20: TGroupBox
        Left = 8
        Top = 8
        Width = 454
        Height = 73
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Main Window Preview'
        TabOrder = 2
        object Label48: TLabel
          Left = 424
          Top = 20
          Width = 11
          Height = 13
          Caption = '%'
        end
        object chkShowTransparency: TCheckBox
          Left = 8
          Top = 42
          Width = 233
          Height = 17
          Caption = 'Show Transparency'
          TabOrder = 2
        end
        object chkExtendMainPreview: TCheckBox
          Left = 8
          Top = 20
          Width = 225
          Height = 17
          Caption = 'Extend preview buffer'
          TabOrder = 0
        end
        object pnlExtension: TPanel
          Left = 244
          Top = 16
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Buffer extension'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
        object cbExtendPercent: TComboBox
          Left = 348
          Top = 16
          Width = 73
          Height = 21
          TabOrder = 1
          Items.Strings = (
            '0'
            '10'
            '25'
            '50'
            '100'
            '150'
            '200')
        end
      end
      object chkUseSmallThumbs: TCheckBox
        Left = 253
        Top = 202
        Width = 209
        Height = 31
        Anchors = [akTop, akRight]
        Caption = 'Use small thumbnails'
        TabOrder = 3
        WordWrap = True
        OnClick = chkUseSmallThumbsClick
      end
    end
    object RandomPage: TTabSheet
      Caption = 'Random'
      DesignSize = (
        467
        368)
      object gpNumberOfTransforms: TGroupBox
        Left = 8
        Top = 6
        Width = 209
        Height = 75
        Caption = 'Number of transforms'
        TabOrder = 0
        object udMinXforms: TUpDown
          Left = 189
          Top = 20
          Width = 12
          Height = 21
          Associate = txtMinXForms
          Min = 1
          Position = 2
          TabOrder = 2
        end
        object udMaxXForms: TUpDown
          Left = 189
          Top = 44
          Width = 12
          Height = 21
          Associate = txtMaxXforms
          Min = 2
          Position = 6
          TabOrder = 3
        end
        object Panel15: TPanel
          Left = 8
          Top = 20
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Minimum'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
        end
        object Panel16: TPanel
          Left = 8
          Top = 44
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Maximum'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
        object txtMaxXforms: TEdit
          Left = 112
          Top = 44
          Width = 77
          Height = 21
          HelpContext = 1018
          TabOrder = 1
          Text = '6'
          OnChange = txtMaxXformsChange
        end
        object txtMinXForms: TEdit
          Left = 112
          Top = 20
          Width = 77
          Height = 21
          HelpContext = 1017
          TabOrder = 0
          Text = '2'
          OnChange = txtMinXFormsChange
        end
      end
      object gpFlameTitlePrefix: TGroupBox
        Left = 232
        Top = 88
        Width = 217
        Height = 97
        Anchors = [akTop, akRight]
        Caption = 'Random batch'
        TabOrder = 1
        object udBatchSize: TUpDown
          Left = 195
          Top = 20
          Width = 13
          Height = 21
          Associate = txtBatchSize
          Min = 1
          Max = 300
          Position = 10
          TabOrder = 2
          Thousands = False
        end
        object chkKeepBackground: TCheckBox
          Left = 8
          Top = 72
          Width = 201
          Height = 17
          HelpContext = 1023
          Caption = 'Keep background color'
          TabOrder = 3
        end
        object Panel11: TPanel
          Left = 8
          Top = 20
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Batch size'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
        end
        object Panel12: TPanel
          Left = 8
          Top = 44
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Title prefix'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
        object txtBatchSize: TEdit
          Left = 112
          Top = 20
          Width = 83
          Height = 21
          HelpContext = 1004
          TabOrder = 1
          Text = '10'
        end
        object txtRandomPrefix: TEdit
          Left = 112
          Top = 44
          Width = 96
          Height = 21
          HelpContext = 1021
          TabOrder = 0
          Text = 'Apophysis'
        end
      end
      object gpMutationTransforms: TGroupBox
        Left = 232
        Top = 6
        Width = 214
        Height = 75
        Anchors = [akTop, akRight]
        Caption = 'Mutation transforms'
        TabOrder = 3
        object udMinMutate: TUpDown
          Left = 197
          Top = 20
          Width = 12
          Height = 21
          Associate = txtMinMutate
          Min = 2
          Max = 12
          Position = 2
          TabOrder = 2
        end
        object udMaxMutate: TUpDown
          Left = 197
          Top = 44
          Width = 12
          Height = 21
          Associate = txtMaxMutate
          Min = 2
          Max = 12
          Position = 6
          TabOrder = 3
        end
        object Panel13: TPanel
          Left = 8
          Top = 20
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Minimum'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
        end
        object Panel14: TPanel
          Left = 8
          Top = 44
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Maximum'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
        object txtMaxMutate: TEdit
          Left = 112
          Top = 44
          Width = 85
          Height = 21
          HelpContext = 1020
          TabOrder = 1
          Text = '6'
          OnChange = txtMaxMutateChange
        end
        object txtMinMutate: TEdit
          Left = 112
          Top = 20
          Width = 85
          Height = 21
          HelpContext = 1019
          TabOrder = 0
          Text = '2'
          OnChange = txtMinMutateChange
        end
      end
      object gpForcedSymmetry: TGroupBox
        Left = 8
        Top = 88
        Width = 209
        Height = 97
        Caption = 'Forced symmetry'
        TabOrder = 2
        object udSymOrder: TUpDown
          Left = 187
          Top = 43
          Width = 13
          Height = 21
          Associate = txtSymOrder
          Min = 2
          Max = 2000
          Position = 4
          TabOrder = 2
          Thousands = False
        end
        object udSymNVars: TUpDown
          Left = 187
          Top = 68
          Width = 13
          Height = 21
          Associate = txtSymNVars
          Min = 4
          Position = 12
          TabOrder = 4
          Thousands = False
        end
        object Panel17: TPanel
          Left = 8
          Top = 20
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Type'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
        object Panel18: TPanel
          Left = 8
          Top = 44
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Order'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
        end
        object Panel19: TPanel
          Left = 8
          Top = 68
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Limit'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
        end
        object txtSymNVars: TEdit
          Left = 112
          Top = 68
          Width = 75
          Height = 21
          TabOrder = 3
          Text = '12'
        end
        object txtSymOrder: TEdit
          Left = 112
          Top = 43
          Width = 75
          Height = 21
          HelpContext = 1025
          TabOrder = 1
          Text = '4'
        end
        object cmbSymType: TComboBox
          Left = 112
          Top = 20
          Width = 89
          Height = 21
          HelpContext = 1024
          Style = csDropDownList
          TabOrder = 0
          OnChange = cmbSymTypeChange
          Items.Strings = (
            'None'
            'Bilateral'
            'Rotational'
            'Dihedral')
        end
      end
      object grpGradient: TRadioGroup
        Left = 8
        Top = 192
        Width = 209
        Height = 121
        HelpContext = 1029
        Caption = 'On random flame'
        ItemIndex = 0
        Items.Strings = (
          'Use random preset'
          'Use default'
          'Use current'
          'Randomize'
          'Random from a file')
        TabOrder = 4
      end
      object GroupBox16: TGroupBox
        Left = 231
        Top = 192
        Width = 217
        Height = 49
        Caption = 'Random file to use'
        TabOrder = 5
        object btnGradientsFile: TSpeedButton
          Left = 185
          Top = 18
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
          OnClick = btnGradientsFileClick
        end
        object txtGradientsFile: TEdit
          Left = 11
          Top = 19
          Width = 174
          Height = 21
          TabOrder = 0
        end
      end
    end
    object VariationsPage: TTabSheet
      Caption = 'Variations'
      ImageIndex = 4
      DesignSize = (
        467
        368)
      object btnSetAll: TButton
        Left = 373
        Top = 4
        Width = 91
        Height = 25
        HelpContext = 1027
        Anchors = [akTop, akRight]
        Caption = 'Set All'
        TabOrder = 0
        OnClick = btnSetAllClick
      end
      object btnClearAll: TButton
        Left = 373
        Top = 32
        Width = 91
        Height = 25
        HelpContext = 1028
        Anchors = [akTop, akRight]
        Caption = 'Clear All'
        TabOrder = 1
        OnClick = btnClearAllClick
      end
      object clbVarEnabled: TCheckListBox
        Left = 0
        Top = 0
        Width = 366
        Height = 366
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = 2
        ItemHeight = 13
        TabOrder = 2
        TabWidth = 100
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Gradient'
      ImageIndex = 5
      DesignSize = (
        467
        368)
      object GroupBox13: TGroupBox
        Left = 8
        Top = 186
        Width = 209
        Height = 79
        Caption = 'Smooth palette'
        TabOrder = 0
        object Panel28: TPanel
          Left = 8
          Top = 20
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Number of tries'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
        object Panel29: TPanel
          Left = 8
          Top = 44
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Try length'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
        object txtTryLength: TEdit
          Left = 112
          Top = 44
          Width = 89
          Height = 21
          HelpContext = 1003
          TabOrder = 1
          Text = '10000'
        end
        object txtNumtries: TEdit
          Left = 112
          Top = 20
          Width = 89
          Height = 21
          HelpContext = 1002
          TabOrder = 0
          Text = '50'
        end
      end
      object GroupBox17: TGroupBox
        Left = 8
        Top = 8
        Width = 209
        Height = 81
        Caption = 'Hue range'
        TabOrder = 1
        object udMinHue: TUpDown
          Left = 185
          Top = 20
          Width = 15
          Height = 21
          HelpContext = 1032
          Associate = txtMinHue
          Max = 600
          TabOrder = 0
        end
        object Panel20: TPanel
          Left = 8
          Top = 44
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Maximum'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
        object Panel21: TPanel
          Left = 8
          Top = 20
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Minimum'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
        object udMaxHue: TUpDown
          Left = 185
          Top = 44
          Width = 15
          Height = 21
          HelpContext = 1033
          Associate = txtMaxHue
          Max = 600
          Position = 600
          TabOrder = 4
        end
        object txtMaxHue: TEdit
          Left = 112
          Top = 44
          Width = 73
          Height = 21
          HelpContext = 1033
          TabOrder = 5
          Text = '600'
          OnChange = txtMaxHueChange
        end
        object txtMinHue: TEdit
          Left = 112
          Top = 20
          Width = 73
          Height = 21
          HelpContext = 1032
          TabOrder = 1
          Text = '0'
          OnChange = txtMinHueChange
        end
      end
      object GroupBox18: TGroupBox
        Left = 229
        Top = 8
        Width = 209
        Height = 81
        Anchors = [akTop, akRight]
        Caption = 'Saturation range'
        TabOrder = 2
        object Panel22: TPanel
          Left = 8
          Top = 20
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Minimum'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object Panel23: TPanel
          Left = 8
          Top = 44
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Maximum'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object udMinSat: TUpDown
          Left = 185
          Top = 20
          Width = 15
          Height = 21
          HelpContext = 1034
          Associate = txtMinSat
          TabOrder = 2
        end
        object txtMinSat: TEdit
          Left = 112
          Top = 20
          Width = 73
          Height = 21
          HelpContext = 1034
          TabOrder = 3
          Text = '0'
          OnChange = txtMinSatChange
        end
        object udmaxSat: TUpDown
          Left = 185
          Top = 44
          Width = 15
          Height = 21
          HelpContext = 1035
          Associate = txtMaxSat
          Position = 100
          TabOrder = 4
        end
        object txtMaxSat: TEdit
          Left = 112
          Top = 44
          Width = 73
          Height = 21
          HelpContext = 1035
          TabOrder = 5
          Text = '100'
          OnChange = txtMaxSatChange
        end
      end
      object GroupBox22: TGroupBox
        Left = 8
        Top = 96
        Width = 209
        Height = 81
        Caption = 'Luminance range'
        TabOrder = 3
        object Panel24: TPanel
          Left = 8
          Top = 44
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Maximum'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object Panel25: TPanel
          Left = 8
          Top = 20
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Minimum'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object udMinLum: TUpDown
          Left = 185
          Top = 20
          Width = 15
          Height = 21
          HelpContext = 1036
          Associate = txtMinLum
          Min = 1
          Position = 1
          TabOrder = 2
        end
        object txtMinLum: TEdit
          Left = 112
          Top = 20
          Width = 73
          Height = 21
          HelpContext = 1036
          TabOrder = 3
          Text = '1'
          OnChange = txtMinLumChange
        end
        object udMaxLum: TUpDown
          Left = 185
          Top = 44
          Width = 15
          Height = 21
          HelpContext = 1037
          Associate = txtMaxLum
          Position = 100
          TabOrder = 4
        end
        object txtMaxLum: TEdit
          Left = 112
          Top = 44
          Width = 73
          Height = 21
          HelpContext = 1037
          TabOrder = 5
          Text = '100'
          OnChange = txtMaxLumChange
        end
      end
      object GroupBox23: TGroupBox
        Left = 229
        Top = 96
        Width = 209
        Height = 81
        Anchors = [akTop, akRight]
        Caption = 'Number of nodes'
        TabOrder = 4
        object Panel26: TPanel
          Left = 8
          Top = 20
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Minimum'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object Panel27: TPanel
          Left = 8
          Top = 44
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Maximum'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object udMinNodes: TUpDown
          Left = 185
          Top = 20
          Width = 15
          Height = 21
          HelpContext = 1030
          Associate = txtMinNodes
          Min = 2
          Max = 64
          Position = 2
          TabOrder = 2
        end
        object txtMinNodes: TEdit
          Left = 112
          Top = 20
          Width = 73
          Height = 21
          HelpContext = 1030
          TabOrder = 3
          Text = '2'
          OnChange = txtMinNodesChange
        end
        object udMaxNodes: TUpDown
          Left = 185
          Top = 44
          Width = 15
          Height = 21
          HelpContext = 1031
          Associate = txtMaxNodes
          Min = 2
          Max = 64
          Position = 2
          TabOrder = 4
        end
        object txtMaxNodes: TEdit
          Left = 112
          Top = 44
          Width = 73
          Height = 21
          HelpContext = 1031
          TabOrder = 5
          Text = '2'
          OnChange = txtMaxNodesChange
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'UPR'
      ImageIndex = 5
      DesignSize = (
        467
        368)
      object chkAdjustDensity: TCheckBox
        Left = 237
        Top = 264
        Width = 228
        Height = 33
        Anchors = [akTop, akRight]
        Caption = 'Adjust sample density'
        TabOrder = 5
        WordWrap = True
      end
      object UPRPage: TPageControl
        Left = 0
        Top = 4
        Width = 441
        Height = 249
        MultiLine = True
        Style = tsButtons
        TabOrder = 4
      end
      object GroupBox11: TGroupBox
        Left = 237
        Top = 184
        Width = 228
        Height = 81
        Anchors = [akTop, akRight]
        Caption = 'UPR size'
        TabOrder = 1
        object Panel37: TPanel
          Left = 8
          Top = 24
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Width'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
        object Panel38: TPanel
          Left = 8
          Top = 48
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Height'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
        object txtUPRHeight: TEdit
          Left = 112
          Top = 48
          Width = 105
          Height = 21
          TabOrder = 1
          Text = '480'
        end
        object txtUPRWidth: TEdit
          Left = 112
          Top = 24
          Width = 105
          Height = 21
          TabOrder = 0
          Text = '640'
        end
      end
      object GroupBox9: TGroupBox
        Left = 8
        Top = 182
        Width = 217
        Height = 107
        Caption = 'Parameter defaults'
        TabOrder = 0
        object Panel34: TPanel
          Left = 8
          Top = 24
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Sample density'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
        object Panel35: TPanel
          Left = 8
          Top = 48
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Filter radius'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
        end
        object Panel36: TPanel
          Left = 8
          Top = 72
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Oversample'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
        object txtUPROversample: TEdit
          Left = 112
          Top = 72
          Width = 97
          Height = 21
          TabOrder = 2
          Text = '3'
        end
        object txtUPRFilterRadius: TEdit
          Left = 112
          Top = 48
          Width = 97
          Height = 21
          TabOrder = 1
          Text = '0.7'
        end
        object txtFIterDensity: TEdit
          Left = 112
          Top = 24
          Width = 97
          Height = 21
          TabOrder = 0
          Text = '35'
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 6
        Width = 457
        Height = 83
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Coloring algorithm'
        TabOrder = 2
        object Panel30: TPanel
          Left = 8
          Top = 24
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Title'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
        object Panel31: TPanel
          Left = 8
          Top = 48
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'File name'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
        object txtFCFile: TEdit
          Left = 112
          Top = 48
          Width = 337
          Height = 21
          TabOrder = 1
          Text = 'apophysis.ucl'
        end
        object txtFCIdent: TEdit
          Left = 112
          Top = 24
          Width = 337
          Height = 21
          TabOrder = 0
          Text = 'enr-flame-a'
        end
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 95
        Width = 457
        Height = 82
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Fractal formula'
        TabOrder = 3
        object Panel32: TPanel
          Left = 8
          Top = 24
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Title'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
        object Panel33: TPanel
          Left = 8
          Top = 48
          Width = 105
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'File name'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
        object txtFFFile: TEdit
          Left = 112
          Top = 48
          Width = 337
          Height = 21
          TabOrder = 1
          Text = 'mt.ufm'
        end
        object txtFFIdent: TEdit
          Left = 112
          Top = 24
          Width = 337
          Height = 21
          TabOrder = 0
          Text = 'mt-pixel'
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Sheep'
      Enabled = False
      ImageIndex = 6
      TabVisible = False
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
    object PathsPage: TTabSheet
      Caption = 'Environment'
      ImageIndex = 7
      DesignSize = (
        467
        368)
      object btnDefGradient: TSpeedButton
        Left = 437
        Top = 7
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
        OnClick = btnDefGradientClick
      end
      object btnSmooth: TSpeedButton
        Left = 437
        Top = 31
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
        OnClick = btnSmoothClick
      end
      object SpeedButton2: TSpeedButton
        Left = 437
        Top = 55
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
        OnClick = SpeedButton2Click
      end
      object btnRenderer: TSpeedButton
        Left = 437
        Top = 79
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
        OnClick = btnRendererClick
      end
      object btnHelp: TSpeedButton
        Left = 437
        Top = 103
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
        OnClick = btnHelpClick
      end
      object Label49: TLabel
        Left = 245
        Top = 236
        Width = 37
        Height = 13
        Caption = 'minutes'
      end
      object btnFindDefaultSaveFile: TSpeedButton
        Left = 437
        Top = 207
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
        OnClick = btnFindDefaultSaveFileClick
      end
      object btnPluginPath: TSpeedButton
        Left = 437
        Top = 128
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
        OnClick = btnPluginPathClick
      end
      object chkRememberLastOpen: TCheckBox
        Left = 8
        Top = 160
        Width = 433
        Height = 17
        Caption = 'Remember last opened parameters'
        TabOrder = 0
        OnClick = chkRememberLastOpenClick
      end
      object Panel39: TPanel
        Left = 8
        Top = 8
        Width = 129
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'Default parameters'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object txtDefParameterFile: TEdit
        Left = 136
        Top = 8
        Width = 302
        Height = 21
        HelpContext = 1000
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = False
        TabOrder = 2
      end
      object Panel40: TPanel
        Left = 8
        Top = 32
        Width = 129
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'Smooth palette file'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
      end
      object txtDefSmoothFile: TEdit
        Left = 136
        Top = 32
        Width = 302
        Height = 21
        HelpContext = 1001
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
      end
      object Panel41: TPanel
        Left = 8
        Top = 56
        Width = 129
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'Function library'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
      end
      object Panel42: TPanel
        Left = 8
        Top = 80
        Width = 129
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'flam3'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
      end
      object Panel43: TPanel
        Left = 8
        Top = 104
        Width = 129
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'Help file'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
      end
      object txtLibrary: TEdit
        Left = 136
        Top = 56
        Width = 302
        Height = 21
        HelpContext = 1000
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = False
        TabOrder = 5
      end
      object txtRenderer: TEdit
        Left = 136
        Top = 80
        Width = 302
        Height = 21
        HelpContext = 1000
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = False
        TabOrder = 6
      end
      object txtHelp: TEdit
        Left = 136
        Top = 104
        Width = 302
        Height = 21
        HelpContext = 1000
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = False
        TabOrder = 7
      end
      object cbEnableAutosave: TCheckBox
        Left = 8
        Top = 184
        Width = 425
        Height = 17
        Caption = 'Enable autosave'
        TabOrder = 13
        OnClick = cbEnableAutosaveClick
      end
      object Panel44: TPanel
        Left = 24
        Top = 208
        Width = 113
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'File name'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 14
      end
      object txtDefaultSaveFile: TEdit
        Left = 136
        Top = 208
        Width = 302
        Height = 21
        HelpContext = 1000
        ParentShowHint = False
        ShowHint = False
        TabOrder = 12
      end
      object Panel45: TPanel
        Left = 24
        Top = 232
        Width = 113
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'Save frequency'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 15
      end
      object cbFreq: TComboBox
        Left = 136
        Top = 232
        Width = 105
        Height = 21
        Style = csDropDownList
        ItemIndex = 2
        TabOrder = 11
        Text = '5'
        Items.Strings = (
          '1'
          '2'
          '5'
          '10')
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 264
        Width = 457
        Height = 73
        Caption = 'Chaotica 0.45+'
        TabOrder = 16
        DesignSize = (
          457
          73)
        object btnChaotica: TSpeedButton
          Left = 425
          Top = 18
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
          OnClick = btnChaoticaClick
        end
        object btnChaotica64: TSpeedButton
          Left = 425
          Top = 98
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
          Visible = False
          OnClick = btnChaoticaClick
        end
        object Panel47: TPanel
          Left = 8
          Top = 20
          Width = 129
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'Location'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object cbC64: TCheckBox
          Left = 8
          Top = 48
          Width = 441
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Use x64-version if possible'
          TabOrder = 2
        end
        object txtChaotica: TEdit
          Left = 136
          Top = 20
          Width = 289
          Height = 21
          HelpContext = 1000
          Anchors = [akLeft, akTop, akRight]
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
        end
        object Panel49: TPanel
          Left = 8
          Top = 100
          Width = 129
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = 'File name (x64)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Visible = False
        end
        object txtChaotica64: TEdit
          Left = 136
          Top = 100
          Width = 289
          Height = 21
          HelpContext = 1000
          Anchors = [akLeft, akTop, akRight]
          ParentShowHint = False
          ShowHint = False
          TabOrder = 4
          Visible = False
        end
      end
      object Panel50: TPanel
        Left = 8
        Top = 130
        Width = 129
        Height = 21
        Cursor = crArrow
        BevelOuter = bvLowered
        Caption = 'Plugin folder'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 17
      end
      object txtPluginFolder: TEdit
        Left = 136
        Top = 130
        Width = 302
        Height = 21
        HelpContext = 1000
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = False
        TabOrder = 18
      end
    end
  end
  object btnOK: TButton
    Left = 304
    Top = 409
    Width = 86
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 397
    Top = 409
    Width = 86
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object OpenDialog: TOpenDialog
    Left = 8
    Top = 408
  end
end
