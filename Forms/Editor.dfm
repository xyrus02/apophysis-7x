object EditForm: TEditForm
  Left = 509
  Top = 87
  Caption = 'Transform Editor'
  ClientHeight = 772
  ClientWidth = 765
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 200
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000040040000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000282728AC010101BC020202880000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000979697FA5E5B5E57010101EF02020286000000000000001E0000
    0000000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000005B5B5BBF010101F200000000131313DC0605
    06D002000269010101E4020102F5090707E30000000000000000000000000000
    000000000000000000000000000073737385020102FF02020281000000000000
    00002B292BC0020102FF010101AC1212091D0000000000000000000000000000
    000000000000000000000000000080808022504E50FF010101BF000000006059
    5928575557A2242324FF010101EA000000000000000000000000000000000000
    000000000000000000000000000000000000717171F2010101E9000000007B77
    76D0919090EB565656832D2D2D7D010101DD010101C300000000000000000000
    000000000000000000000000000000000000646464CC020102FF0000000D0000
    0000747474216767673E00000000505050201717173700000000000000000000
    0000000000000000000000000000000000006C6C6C95181718FF020202810000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000898887C7B1AFAEFF817F7EFF0E0B0AFF0A08
    07F8000000000000000000000000000000000000000000000000000000000000
    00000000000000000000000000000000000000000000969496ED060506DA0000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000009090908E646364FF0000
    001D090606CF0A0707AB00000000000000000000000000000000000000000000
    00000000000000000000000000000000000000000000000000009D9C9DCB6E6B
    6BF50A0707F3070505BB00000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000008080
    80224D4D4D3C0000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    0000FFFF0000C7FF0000C2FF0000F2070000F1870000F10F0000F9030000F893
    0000F8FF0000F07F0000FCFF0000FC1F0000FE1F0000FF3F0000FFFF0000}
  KeyPreview = True
  OldCreateOrder = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = EditKeyDown
  OnKeyPress = EditKeyPress
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 757
    Width = 765
    Height = 15
    Panels = <
      item
        Width = 60
      end
      item
        Width = 60
      end
      item
        Width = 150
      end>
  end
  object topPnl: TPanel
    Left = 0
    Top = 0
    Width = 765
    Height = 24
    Align = alTop
    BevelOuter = bvSpace
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    object EditorToolBar: TToolBar
      Left = 1
      Top = 1
      Width = 763
      Height = 22
      Align = alClient
      ButtonHeight = 23
      Caption = 'EditorToolBar'
      Color = clBtnFace
      Images = EditorTB
      ParentColor = False
      TabOrder = 0
      object tbResetAll: TToolButton
        Left = 0
        Top = 0
        Hint = 'New blank flame'
        Caption = 'New blank flame'
        ImageIndex = 0
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuResetAllClick
      end
      object tbAdd: TToolButton
        Left = 23
        Top = 0
        Hint = 'Adds a new triangle'
        Caption = 'Add'
        ImageIndex = 1
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuAddClick
      end
      object tbDuplicate: TToolButton
        Left = 46
        Top = 0
        Hint = 'Duplicates the selected triangle'
        Caption = 'Duplicate'
        ImageIndex = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuDupClick
      end
      object tbDelete: TToolButton
        Left = 69
        Top = 0
        Hint = 'Deletes the selected triangle'
        Caption = 'Delete'
        ImageIndex = 3
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuDeleteClick
      end
      object ToolButton4: TToolButton
        Left = 92
        Top = 0
        Width = 8
        Caption = 'ToolButton4'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object tbUndo: TToolButton
        Left = 100
        Top = 0
        Hint = 'Undo (Ctrl+Z)'
        Caption = 'Undo'
        ImageIndex = 4
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuUndoClick
      end
      object tbRedo: TToolButton
        Left = 123
        Top = 0
        Hint = 'Redo (Ctrl+Y)'
        Caption = 'Redo'
        ImageIndex = 5
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuRedoClick
      end
      object ToolButton11: TToolButton
        Left = 146
        Top = 0
        Width = 8
        Caption = 'ToolButton11'
        ImageIndex = 32
        Style = tbsSeparator
      end
      object ToolButton9: TToolButton
        Left = 154
        Top = 0
        Hint = 'Copy triangle'
        Caption = 'ToolButton9'
        ImageIndex = 26
        OnClick = btnCopyTriangleClick
      end
      object ToolButton10: TToolButton
        Left = 177
        Top = 0
        Hint = 'Paste triangle'
        Caption = 'ToolButton10'
        ImageIndex = 27
        OnClick = btnPasteTriangleClick
      end
      object ToolButton1: TToolButton
        Left = 200
        Top = 0
        Width = 8
        Caption = 'ToolButton1'
        ImageIndex = 5
        Style = tbsSeparator
      end
      object tbSelect: TToolButton
        Left = 208
        Top = 0
        Hint = 'Select mode'
        Caption = 'Select'
        Down = True
        ImageIndex = 6
        ParentShowHint = False
        ShowHint = True
        OnClick = tbSelectClick
      end
      object tbMove: TToolButton
        Left = 231
        Top = 0
        Hint = 'Move triangle'
        Caption = 'Move'
        Down = True
        Grouped = True
        ImageIndex = 7
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbEditModeClick
      end
      object tbRotate: TToolButton
        Left = 254
        Top = 0
        Hint = 'Rotate triangle'
        Caption = 'Rotate'
        Grouped = True
        ImageIndex = 8
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbEditModeClick
      end
      object tbScale: TToolButton
        Left = 277
        Top = 0
        Hint = 'Scale triangle'
        Caption = 'Scale'
        Grouped = True
        ImageIndex = 9
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbEditModeClick
      end
      object tbPivotMode: TToolButton
        Left = 300
        Top = 0
        Hint = 'Toggle world pivot mode'
        Caption = 'tbPivotMode'
        ImageIndex = 15
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = btnPivotModeClick
      end
      object ToolButton6: TToolButton
        Left = 323
        Top = 0
        Width = 8
        Caption = 'ToolButton6'
        ImageIndex = 16
        Style = tbsSeparator
      end
      object tbRotate90CCW: TToolButton
        Left = 331
        Top = 0
        Hint = 'Rotate triangle 90'#176' counter-clockwise'
        Caption = 'tbRotate90CCW'
        ImageIndex = 17
        ParentShowHint = False
        ShowHint = True
        OnClick = btTrgRotateLeft90Click
      end
      object tbRotate90CW: TToolButton
        Left = 354
        Top = 0
        Hint = 'Rotate triangle 90'#176' clockwise'
        Caption = 'tbRotate90CW'
        ImageIndex = 18
        ParentShowHint = False
        ShowHint = True
        OnClick = btTrgRotateRight90Click
      end
      object tbFlipHorz: TToolButton
        Left = 377
        Top = 0
        Hint = 'Flip triangle horizontal'
        Caption = 'Flip Horizontal'
        ImageIndex = 10
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuFlipHorizontalClick
      end
      object tbFlipVert: TToolButton
        Left = 400
        Top = 0
        Hint = 'Flip triangle vertical'
        Caption = 'Flip Vertical'
        ImageIndex = 11
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuFlipVerticalClick
      end
      object ToolButton2: TToolButton
        Left = 423
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 14
        Style = tbsSeparator
      end
      object tbVarPreview: TToolButton
        Left = 431
        Top = 0
        Hint = 'Show/hide variation preview'
        Caption = 'Variation Preview'
        ImageIndex = 14
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbVarPreviewClick
      end
      object ToolButton3: TToolButton
        Left = 454
        Top = 0
        Width = 8
        Caption = 'ToolButton3'
        ImageIndex = 16
        Style = tbsSeparator
      end
      object tbPostXswap: TToolButton
        Left = 462
        Top = 0
        Hint = 'Enable post-triangle editing'
        Caption = 'tbPostXswap'
        ImageIndex = 29
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbPostXswapClick
      end
      object tbEnableFinalXform: TToolButton
        Left = 485
        Top = 0
        Hint = 'Enable final transform'
        Caption = 'Show Final Xform'
        ImageIndex = 24
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbEnableFinalXformClick
      end
      object ToolButton8: TToolButton
        Left = 508
        Top = 0
        Width = 8
        Caption = 'ToolButton8'
        ImageIndex = 32
        Style = tbsSeparator
      end
      object ToolButton7: TToolButton
        Left = 516
        Top = 0
        Hint = 'Adds a new linked triangle'
        Caption = 'ToolButton7'
        ImageIndex = 31
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuLinkPostxformClick
      end
      object ToolButton5: TToolButton
        Left = 539
        Top = 0
        Width = 8
        Caption = 'ToolButton5'
        ImageIndex = 32
        Style = tbsSeparator
      end
      object ToolButton12: TToolButton
        Left = 547
        Top = 0
        Caption = 'ToolButton12'
        ImageIndex = 32
        Visible = False
        OnClick = ToolButton12Click
      end
      object ToolButton13: TToolButton
        Left = 570
        Top = 0
        Caption = 'ToolButton13'
        ImageIndex = 33
        Visible = False
      end
      object ToolButton14: TToolButton
        Left = 593
        Top = 0
        Caption = 'ToolButton14'
        ImageIndex = 34
        Visible = False
      end
    end
  end
  object EditPnl: TPanel
    Left = 0
    Top = 24
    Width = 765
    Height = 733
    Align = alClient
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 454
      Top = 1
      Width = 10
      Height = 731
      Align = alRight
      AutoSnap = False
      Beveled = True
      MinSize = 300
      OnMoved = splitterMoved
    end
    object GrphPnl: TPanel
      Left = 1
      Top = 1
      Width = 453
      Height = 731
      Align = alClient
      BevelOuter = bvNone
      Color = clAppWorkSpace
      TabOrder = 0
      object ImgTemp: TImage
        Left = 0
        Top = 0
        Width = 273
        Height = 233
        Proportional = True
      end
    end
    object RightPanel: TPanel
      Left = 464
      Top = 1
      Width = 300
      Height = 731
      Align = alRight
      Alignment = taLeftJustify
      BevelOuter = bvNone
      TabOrder = 1
      object Splitter2: TSplitter
        Left = 0
        Top = 177
        Width = 300
        Height = 8
        Cursor = crVSplit
        Align = alTop
        AutoSnap = False
        Beveled = True
        MinSize = 177
        Visible = False
        OnMoved = splitterMoved
      end
      object ControlPanel: TPanel
        Left = 0
        Top = 185
        Width = 300
        Height = 546
        Align = alClient
        TabOrder = 0
        OnResize = ControlPanelResize
        DesignSize = (
          300
          546)
        object PageControl: TPageControl
          Left = 1
          Top = 71
          Width = 298
          Height = 466
          ActivePage = tabVariations
          Anchors = [akLeft, akTop, akRight, akBottom]
          MultiLine = True
          TabOrder = 3
          TabStop = False
          object TriangleTab: TTabSheet
            Caption = 'Triangle'
            object TriangleScrollBox: TScrollBox
              Left = 0
              Top = 0
              Width = 290
              Height = 420
              HorzScrollBar.Visible = False
              VertScrollBar.Smooth = True
              VertScrollBar.Style = ssFlat
              VertScrollBar.Tracking = True
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              TabOrder = 0
              DesignSize = (
                290
                420)
              object TrianglePanel: TPanel
                Left = 1
                Top = 0
                Width = 284
                Height = 321
                Anchors = [akLeft, akTop, akRight]
                BevelOuter = bvNone
                TabOrder = 0
                OnResize = TrianglePanelResize
                object ToolBar1: TToolBar
                  Left = 64
                  Top = 218
                  Width = 145
                  Height = 28
                  Align = alNone
                  ButtonWidth = 24
                  Caption = 'ToolBar1'
                  EdgeInner = esNone
                  EdgeOuter = esNone
                  Images = EditorTB
                  TabOrder = 3
                  object tbCopyTriangle: TToolButton
                    Left = 0
                    Top = 0
                    Hint = 'Copy triangle coordinates'
                    ImageIndex = 26
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btnCopyTriangleClick
                  end
                  object tbPasteTriangle: TToolButton
                    Left = 24
                    Top = 0
                    Hint = 'Paste triangle coordinates'
                    ImageIndex = 27
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btnPasteTriangleClick
                  end
                  object tbExtendedEdit: TToolButton
                    Left = 48
                    Top = 0
                    Hint = 'Enable extended edit mode'
                    Caption = 'tbExtendedEdit'
                    ImageIndex = 25
                    ParentShowHint = False
                    ShowHint = True
                    Style = tbsCheck
                    OnClick = tbExtendedEditClick
                  end
                  object tbAxisLock: TToolButton
                    Left = 72
                    Top = 0
                    Hint = 'Lock transform axes'
                    Caption = 'tbAxisLock'
                    ImageIndex = 16
                    ParentShowHint = False
                    ShowHint = True
                    Style = tbsCheck
                    OnClick = tbAxisLockClick
                  end
                  object tbAutoWeights: TToolButton
                    Left = 96
                    Top = 0
                    Hint = 'Auto-balance weights'
                    Caption = 'tbAutoWeights'
                    ImageIndex = 28
                    ParentShowHint = False
                    ShowHint = True
                    Style = tbsCheck
                  end
                  object tb2PostXswap: TToolButton
                    Left = 120
                    Top = 0
                    Hint = 'Enable post-triangle editing'
                    Caption = 'tb2PostXswap'
                    ImageIndex = 29
                    ParentShowHint = False
                    ShowHint = True
                    Style = tbsCheck
                    OnClick = tbPostXswapClick
                  end
                end
                object GroupBox5: TGroupBox
                  Left = 20
                  Top = 112
                  Width = 177
                  Height = 97
                  TabOrder = 1
                  object btTrgRotateLeft90: TSpeedButton
                    Left = 8
                    Top = 17
                    Width = 23
                    Height = 24
                    Hint = 'Rotate triangle 90'#176' counter-clockwise'
                    Flat = True
                    Glyph.Data = {
                      36050000424D3605000000000000360400002800000010000000100000000100
                      08000000000000010000C40E0000C40E00000001000000000000000000000000
                      8000008000000080800080000000800080008080000080808000C0C0C0000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
                      0000000000000000000000000000000000000000000000000000000000000000
                      0000000000000000000000000000000000000000000000000000000000000000
                      0000000000000000000000000000000000000000000000000000000000003300
                      00006600000099000000CC000000FF0000000033000033330000663300009933
                      0000CC330000FF33000000660000336600006666000099660000CC660000FF66
                      000000990000339900006699000099990000CC990000FF99000000CC000033CC
                      000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
                      0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
                      330000333300333333006633330099333300CC333300FF333300006633003366
                      33006666330099663300CC663300FF6633000099330033993300669933009999
                      3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
                      330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
                      66006600660099006600CC006600FF0066000033660033336600663366009933
                      6600CC336600FF33660000666600336666006666660099666600CC666600FF66
                      660000996600339966006699660099996600CC996600FF99660000CC660033CC
                      660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
                      6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
                      990000339900333399006633990099339900CC339900FF339900006699003366
                      99006666990099669900CC669900FF6699000099990033999900669999009999
                      9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
                      990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
                      CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
                      CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
                      CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
                      CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
                      CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
                      FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
                      FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
                      FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
                      FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF000F0F0F0F0F0F
                      0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                      0F0F0F0F070000070F0F0F0F0F0F0F0F0F0F0F0F070000070F0F0F0F0F0F0F0F
                      0F0F0F0F070000070F0F0F0F0F0F0FD40F0F0F0F070000070F0F0F0F0F0FD47E
                      0F0F0F0F070000070F0F0F0F0FD453530F0F0F0F070000070F0F0F0FD4530053
                      0F0F0F0F070000070F0F0FD45300000007070707070000070F0F0F5300000000
                      00000000000000070F0F08070000000000000000000000070F0F0F0807000000
                      07070707070707070F0F0F0F080700000F0F0F0F0F0F0F0F0F0F0F0F0F080700
                      0F0F0F0F0F0F0F0F0F0F0F0F0F0F08000F0F0F0F0F0F0F0F0F0F}
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btTrgRotateLeft90Click
                  end
                  object btTrgRotateRight90: TSpeedButton
                    Left = 146
                    Top = 17
                    Width = 23
                    Height = 24
                    Hint = 'Rotate triangle 90'#176' clockwise'
                    Flat = True
                    Glyph.Data = {
                      36050000424D3605000000000000360400002800000010000000100000000100
                      08000000000000010000C40E0000C40E00000001000000000000000000000000
                      8000008000000080800080000000800080008080000080808000C0C0C0000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
                      0000000000000000000000000000000000000000000000000000000000000000
                      0000000000000000000000000000000000000000000000000000000000000000
                      0000000000000000000000000000000000000000000000000000000000003300
                      00006600000099000000CC000000FF0000000033000033330000663300009933
                      0000CC330000FF33000000660000336600006666000099660000CC660000FF66
                      000000990000339900006699000099990000CC990000FF99000000CC000033CC
                      000066CC000099CC0000CCCC0000FFCC000000FF000033FF000066FF000099FF
                      0000CCFF0000FFFF000000003300330033006600330099003300CC003300FF00
                      330000333300333333006633330099333300CC333300FF333300006633003366
                      33006666330099663300CC663300FF6633000099330033993300669933009999
                      3300CC993300FF99330000CC330033CC330066CC330099CC3300CCCC3300FFCC
                      330000FF330033FF330066FF330099FF3300CCFF3300FFFF3300000066003300
                      66006600660099006600CC006600FF0066000033660033336600663366009933
                      6600CC336600FF33660000666600336666006666660099666600CC666600FF66
                      660000996600339966006699660099996600CC996600FF99660000CC660033CC
                      660066CC660099CC6600CCCC6600FFCC660000FF660033FF660066FF660099FF
                      6600CCFF6600FFFF660000009900330099006600990099009900CC009900FF00
                      990000339900333399006633990099339900CC339900FF339900006699003366
                      99006666990099669900CC669900FF6699000099990033999900669999009999
                      9900CC999900FF99990000CC990033CC990066CC990099CC9900CCCC9900FFCC
                      990000FF990033FF990066FF990099FF9900CCFF9900FFFF99000000CC003300
                      CC006600CC009900CC00CC00CC00FF00CC000033CC003333CC006633CC009933
                      CC00CC33CC00FF33CC000066CC003366CC006666CC009966CC00CC66CC00FF66
                      CC000099CC003399CC006699CC009999CC00CC99CC00FF99CC0000CCCC0033CC
                      CC0066CCCC0099CCCC00CCCCCC00FFCCCC0000FFCC0033FFCC0066FFCC0099FF
                      CC00CCFFCC00FFFFCC000000FF003300FF006600FF009900FF00CC00FF00FF00
                      FF000033FF003333FF006633FF009933FF00CC33FF00FF33FF000066FF003366
                      FF006666FF009966FF00CC66FF00FF66FF000099FF003399FF006699FF009999
                      FF00CC99FF00FF99FF0000CCFF0033CCFF0066CCFF0099CCFF00CCCCFF00FFCC
                      FF0000FFFF0033FFFF0066FFFF0099FFFF00CCFFFF00FFFFFF000F0F0F0F0F0F
                      0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F07000007
                      0F0F0F0F0F0F0F0F0F0F0F0F070000070F0F0F0F0F0F0F0F0F0F0F0F07000007
                      0F0F0F0F0F0F0F0F0F0F0F0F070000070F0F0F0FD40F0F0F0F0F0F0F07000007
                      0F0F0F0F7ED40F0F0F0F0F0F070000070F0F0F0F5353D40F0F0F0F0F07000007
                      0F0F0F0F530053D40F0F0F0F070000070707070700000053D40F0F0F07000000
                      0000000000000000530F0F0F07000000000000000000000007080F0F07070707
                      0707070700000007080F0F0F0F0F0F0F0F0F0F0F000007080F0F0F0F0F0F0F0F
                      0F0F0F0F0007080F0F0F0F0F0F0F0F0F0F0F0F0F00080F0F0F0F}
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btTrgRotateRight90Click
                  end
                  object btTrgScaleDown: TSpeedButton
                    Left = 32
                    Top = 65
                    Width = 23
                    Height = 24
                    Hint = 'Scale triangle down'
                    Flat = True
                    Glyph.Data = {
                      F6000000424DF600000000000000760000002800000010000000100000000100
                      0400000000008000000000000000000000001000000000000000000000000000
                      8000008000000080800080000000800080008080000080808000C0C0C0000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000
                      0FFFF000000000000FFFFF0000FFFFF00FFFFFF0000FFFF00FFFFFFFF000FFF0
                      0FFFFFFFFF000FF00FFFFFFFFFF000000FFFFFFFFFFF00000FFFFFFFFFFFFF00
                      0FFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btTrgScaleDownClick
                  end
                  object btTrgScaleUp: TSpeedButton
                    Left = 122
                    Top = 65
                    Width = 23
                    Height = 24
                    Hint = 'Scale triangle up'
                    Flat = True
                    Glyph.Data = {
                      F6000000424DF600000000000000760000002800000010000000100000000100
                      0400000000008000000000000000000000001000000000000000000000000000
                      8000008000000080800080000000800080008080000080808000C0C0C0000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
                      FFFFF00000000000000FF00000000000000FFF000FFFFFFFF00FFFF000FFFFFF
                      F00FFFFF000FFFFFF00FFFFFF000FFFFF00FFFFFFF000FFFF00FFFFFFFF000FF
                      F00FFFFFFFFF000FF00FFFFFFFFFF000F00FFFFFFFFFFF00000FFFFFFFFFFFF0
                      000FFFFFFFFFFFFF000FFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFF}
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btTrgScaleUpClick
                  end
                  object btTrgMoveDown: TSpeedButton
                    Left = 32
                    Top = 41
                    Width = 23
                    Height = 24
                    Hint = 'Move triangle down'
                    Flat = True
                    Glyph.Data = {
                      36030000424D3603000000000000360000002800000010000000100000000100
                      18000000000000030000130B0000130B00000000000000000000FFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080FFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
                      0000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFF808080000000000000FFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000
                      0000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFF808080000000000000000000000000FFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000
                      0000000000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFF808080000000000000000000000000000000000000FFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000
                      0000000000000000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFF808080000000808080808080000000000000C0C0C0404040000000FFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040FFFFFFFFFFFF80808000
                      0000000000FFFFFFFFFFFFC0C0C0808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFF808080000000000000FFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80808000
                      0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFF808080000000000000FFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80808000
                      0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFF808080000000000000FFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C000
                      0000404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btTrgMoveDownClick
                  end
                  object btTrgMoveLeft: TSpeedButton
                    Left = 122
                    Top = 41
                    Width = 23
                    Height = 24
                    Hint = 'Move triangle left'
                    Flat = True
                    Glyph.Data = {
                      36030000424D3603000000000000360000002800000010000000100000000100
                      18000000000000030000130B0000130B00000000000000000000FFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFF808080404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFF808080000000000000FFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80808000000000000000
                      0000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      8080800000000000000000000000000000008080808080808080808080808080
                      80808080808080C0C0C080808000000000000000000000000000000000000000
                      0000000000000000000000000000000000000000000000000000FFFFFF808080
                      0000000000000000000000000000000000000000000000000000000000000000
                      00000000000000404040FFFFFFFFFFFFFFFFFF80808000000000000000000000
                      0000C0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFF808080000000000000404040FFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80
                      8080000000C0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080FFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btTrgMoveLeftClick
                  end
                  object btTrgMoveRight: TSpeedButton
                    Left = 146
                    Top = 41
                    Width = 23
                    Height = 24
                    Hint = 'Move triangle right'
                    Flat = True
                    Glyph.Data = {
                      36030000424D3603000000000000360000002800000010000000100000000100
                      18000000000000030000130B0000130B00000000000000000000FFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF40404080
                      8080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000808080FFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80
                      8080000000000000000000808080FFFFFFFFFFFFFFFFFFFFFFFFC0C0C0808080
                      8080808080808080808080808080808080800000000000000000000000000000
                      00808080FFFFFFFFFFFF00000000000000000000000000000000000000000000
                      0000000000000000000000000000000000000000000000808080404040000000
                      0000000000000000000000000000000000000000000000000000000000000000
                      00000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
                      C0C0000000000000000000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040000000000000808080FFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C000
                      0000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFF808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btTrgMoveRightClick
                  end
                  object btTrgMoveUp: TSpeedButton
                    Left = 8
                    Top = 41
                    Width = 23
                    Height = 24
                    Hint = 'Move triangle up'
                    Flat = True
                    Glyph.Data = {
                      36030000424D3603000000000000360000002800000010000000100000000100
                      18000000000000030000130B0000130B00000000000000000000FFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040000000C0C0C0FFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
                      0000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000808080FFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
                      0000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000808080FFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
                      0000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFF808080C0C0C0FFFFFFFFFFFF000000000000808080FFFFFFFFFFFF4040
                      40FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000404040C0C0C000
                      0000000000808080808080000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFF808080000000000000000000000000000000000000000000FFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000
                      0000000000000000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFF808080000000000000000000000000000000FFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000
                      0000000000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFF808080000000000000000000FFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
                      0000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080000000FFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFF808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btTrgMoveUpClick
                  end
                  object btTrgRotateLeft: TSpeedButton
                    Left = 32
                    Top = 17
                    Width = 23
                    Height = 24
                    Hint = 'Rotate triangle counter clockwise'
                    Flat = True
                    Glyph.Data = {
                      36030000424D3603000000000000360000002800000010000000100000000100
                      18000000000000030000130B0000130B00000000000000000000FFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080808080FFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFF000000404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0000000404040FFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FF404040000000404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE0E0E0FFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFF808080000000000000808080FFFFFFFFFFFF
                      FFFFFFFFFFFFE0E0E0606060FFFFFFFFFFFFFFFFFFFFFFFFE0E0E08080800000
                      00000000000000E0E0E0FFFFFFFFFFFFFFFFFFE0E0E0202020404040FFFFFFE0
                      E0E0C0C0C0A0A0A0404040000000000000000000404040FFFFFFFFFFFFFFFFFF
                      E0E0E02020200000004040408080804040404040400000000000000000000000
                      00000000C0C0C0FFFFFFFFFFFFE0E0E020202000000000000000000000000000
                      0000000000000000000000000000404040404040FFFFFFFFFFFFFFFFFF202020
                      0000000000000000000000000000000000000000000000000000004040408080
                      80FFFFFFFFFFFFFFFFFFC0C0C080808000000000000000000000000000000000
                      0000000000404040808080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0
                      808080000000000000404040808080808080808080808080C0C0C0FFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0808080000000202020808080C0
                      C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFC0C0C0808080404040FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0808080FFFFFFFF
                      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btTrgRotateLeftClick
                  end
                  object btTrgRotateRight: TSpeedButton
                    Left = 122
                    Top = 17
                    Width = 23
                    Height = 24
                    Hint = 'Rotate triangle clockwise'
                    Flat = True
                    Glyph.Data = {
                      F6000000424DF600000000000000760000002800000010000000100000000100
                      04000000000080000000130B0000130B00001000000000000000000000000000
                      8000008000000080800080000000800080008080000080808000C0C0C0000000
                      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
                      FFFF77FFFFFFFFFFFFFF70FFFFFFFFFFFFFF708FFFFFFFFFFFFF707FFFFFFFFF
                      FFFF7007FFFFFFFFFFFFF0007FFFFF7FFFFFF7000788FF70FFFFF80000077770
                      0FFFFF770000000000FFFFF770000000000FFFFF777000000078FFFFF8777770
                      078FFFFFFFFF870078FFFFFFFFFFFF778FFFFFFFFFFFFF78FFFF}
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btTrgRotateRightClick
                  end
                  object txtTrgScaleValue: TComboBox
                    Left = 56
                    Top = 66
                    Width = 65
                    Height = 21
                    AutoComplete = False
                    ItemIndex = 1
                    TabOrder = 2
                    Text = '125'
                    OnExit = txtValidateValue
                    OnKeyPress = txtValKeyPress
                    OnSelect = txtValidateValue
                    Items.Strings = (
                      '110'
                      '125'
                      '150'
                      '175'
                      '200')
                  end
                  object txtTrgRotateValue: TComboBox
                    Left = 56
                    Top = 18
                    Width = 65
                    Height = 21
                    AutoComplete = False
                    TabOrder = 0
                    Text = '15'
                    OnExit = txtValidateValue
                    OnKeyPress = txtValKeyPress
                    OnSelect = txtValidateValue
                    Items.Strings = (
                      '5'
                      '15'
                      '30'
                      '45'
                      '60'
                      '90'
                      '120'
                      '180')
                  end
                  object txtTrgMoveValue: TComboBox
                    Left = 56
                    Top = 42
                    Width = 65
                    Height = 21
                    AutoComplete = False
                    ItemIndex = 3
                    TabOrder = 1
                    Text = '0.1'
                    OnExit = txtValidateValue
                    OnKeyPress = txtValKeyPress
                    OnSelect = txtValidateValue
                    Items.Strings = (
                      '1'
                      '0.5'
                      '0.25'
                      '0.1'
                      '0.05'
                      '0.025'
                      '0.01')
                  end
                end
                object GroupBox6: TGroupBox
                  Left = 6
                  Top = 0
                  Width = 209
                  Height = 105
                  Ctl3D = True
                  ParentCtl3D = False
                  TabOrder = 0
                  DesignSize = (
                    209
                    105)
                  object LabelC: TLabel
                    Left = 8
                    Top = 48
                    Width = 10
                    Height = 13
                    Caption = 'Y:'
                  end
                  object LabelA: TLabel
                    Left = 8
                    Top = 24
                    Width = 10
                    Height = 13
                    Caption = 'X:'
                  end
                  object LabelB: TLabel
                    Left = 8
                    Top = 72
                    Width = 12
                    Height = 13
                    Caption = 'O:'
                  end
                  object txtAx: TEdit
                    Left = 28
                    Top = 20
                    Width = 83
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 0
                    Text = '0'
                    OnExit = CornerEditExit
                    OnKeyPress = CornerEditKeyPress
                  end
                  object txtAy: TEdit
                    Left = 117
                    Top = 20
                    Width = 86
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 1
                    Text = '0'
                    OnExit = CornerEditExit
                    OnKeyPress = CornerEditKeyPress
                  end
                  object txtBx: TEdit
                    Left = 28
                    Top = 68
                    Width = 83
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 4
                    Text = '0'
                    OnExit = CornerEditExit
                    OnKeyPress = CornerEditKeyPress
                  end
                  object txtBy: TEdit
                    Left = 117
                    Top = 68
                    Width = 86
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 5
                    Text = '0'
                    OnExit = CornerEditExit
                    OnKeyPress = CornerEditKeyPress
                  end
                  object txtCx: TEdit
                    Left = 28
                    Top = 44
                    Width = 83
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 2
                    Text = '0'
                    OnExit = CornerEditExit
                    OnKeyPress = CornerEditKeyPress
                  end
                  object txtCy: TEdit
                    Left = 117
                    Top = 44
                    Width = 86
                    Height = 21
                    Anchors = [akLeft, akTop, akRight]
                    TabOrder = 3
                    Text = '0'
                    OnExit = CornerEditExit
                    OnKeyPress = CornerEditKeyPress
                  end
                end
                object GroupBox3: TGroupBox
                  Left = 6
                  Top = 248
                  Width = 209
                  Height = 65
                  Caption = 'Pivot Point'
                  TabOrder = 2
                  object btnResetPivot: TSpeedButton
                    Left = 6
                    Top = 40
                    Width = 17
                    Height = 17
                    Hint = 'Reset pivot point to (0, 0)'
                    Caption = 'R'
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btnResetPivotClick
                  end
                  object btnPickPivot: TSpeedButton
                    Left = 184
                    Top = 40
                    Width = 16
                    Height = 17
                    Hint = 'Pick pivot point using mouse'
                    Caption = 'P'
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btnPickPivotClick
                  end
                  object btnPivotMode: TSpeedButton
                    Left = 24
                    Top = 40
                    Width = 160
                    Height = 17
                    Hint = 'Toggle pivot point mode'
                    Caption = 'Local Pivot'
                    ParentShowHint = False
                    ShowHint = True
                    OnClick = btnPivotModeClick
                  end
                  object editPivotY: TEdit
                    Left = 111
                    Top = 13
                    Width = 93
                    Height = 21
                    Hint = 'Pivot point coordinates in chosen coordinate system'
                    ParentShowHint = False
                    ShowHint = True
                    TabOrder = 1
                    Text = '0'
                    OnExit = PivotValidate
                    OnKeyPress = PivotKeyPress
                  end
                  object editPivotX: TEdit
                    Left = 6
                    Top = 16
                    Width = 99
                    Height = 21
                    Hint = 'Pivot point coordinates in chosen coordinate system'
                    ParentShowHint = False
                    ShowHint = True
                    TabOrder = 0
                    Text = '0'
                    OnExit = PivotValidate
                    OnKeyPress = PivotKeyPress
                  end
                end
              end
            end
          end
          object tabXForm: TTabSheet
            Caption = 'Transform'
            object ScrollBox1: TScrollBox
              Left = 0
              Top = 0
              Width = 290
              Height = 420
              HorzScrollBar.Visible = False
              Align = alClient
              BorderStyle = bsNone
              TabOrder = 0
              OnResize = ScrollBox1Resize
              DesignSize = (
                290
                420)
              object GroupBox9: TGroupBox
                Left = 8
                Top = 4
                Width = 225
                Height = 113
                TabOrder = 0
                object btnXcoefs: TSpeedButton
                  Left = 8
                  Top = 12
                  Width = 25
                  Height = 21
                  Hint = 'Reset vector X'
                  Caption = 'X'
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                  ParentShowHint = False
                  ShowHint = True
                  OnClick = btnXcoefsClick
                end
                object btnYcoefs: TSpeedButton
                  Left = 8
                  Top = 36
                  Width = 25
                  Height = 21
                  Hint = 'Reset vector Y'
                  Caption = 'Y'
                  ParentShowHint = False
                  ShowHint = True
                  OnClick = btnYcoefsClick
                end
                object btnOcoefs: TSpeedButton
                  Left = 8
                  Top = 60
                  Width = 25
                  Height = 21
                  Hint = 'Reset vector O'
                  Caption = 'O'
                  ParentShowHint = False
                  ShowHint = True
                  OnClick = btnOcoefsClick
                end
                object btnResetCoefs: TSpeedButton
                  Left = 8
                  Top = 84
                  Width = 209
                  Height = 22
                  Hint = 'Reset all vectors to default position'
                  Caption = 'Reset transform'
                  ParentShowHint = False
                  ShowHint = True
                  OnClick = btnResetCoefsClick
                end
                object txtA: TEdit
                  Left = 36
                  Top = 12
                  Width = 85
                  Height = 21
                  TabOrder = 0
                  Text = '0'
                  OnExit = CoefValidate
                  OnKeyPress = CoefKeyPress
                end
                object txtB: TEdit
                  Left = 128
                  Top = 12
                  Width = 89
                  Height = 21
                  TabOrder = 1
                  Text = '0'
                  OnExit = CoefValidate
                  OnKeyPress = CoefKeyPress
                end
                object txtC: TEdit
                  Left = 36
                  Top = 36
                  Width = 85
                  Height = 21
                  TabOrder = 2
                  Text = '0'
                  OnExit = CoefValidate
                  OnKeyPress = CoefKeyPress
                end
                object txtD: TEdit
                  Left = 128
                  Top = 36
                  Width = 89
                  Height = 21
                  TabOrder = 3
                  Text = '0'
                  OnExit = CoefValidate
                  OnKeyPress = CoefKeyPress
                end
                object txtE: TEdit
                  Left = 36
                  Top = 60
                  Width = 85
                  Height = 21
                  TabOrder = 4
                  Text = '0'
                  OnExit = CoefValidate
                  OnKeyPress = CoefKeyPress
                end
                object txtF: TEdit
                  Left = 127
                  Top = 63
                  Width = 89
                  Height = 21
                  TabOrder = 5
                  Text = '0'
                  OnExit = CoefValidate
                  OnKeyPress = CoefKeyPress
                end
              end
              object GroupBox7: TGroupBox
                Left = 8
                Top = 229
                Width = 225
                Height = 37
                TabOrder = 1
                object btnCoefsPolar: TSpeedButton
                  Left = 112
                  Top = 12
                  Width = 105
                  Height = 17
                  Hint = 'Show vectors in polar coordinates'
                  GroupIndex = 1
                  Caption = 'Polar (deg)'
                  ParentShowHint = False
                  ShowHint = True
                  OnClick = btnCoefsModeClick
                end
                object btnCoefsRect: TSpeedButton
                  Left = 10
                  Top = 12
                  Width = 103
                  Height = 17
                  Hint = 'Show vectors in rectangular (cartesian) coordinates'
                  GroupIndex = 1
                  Down = True
                  Caption = 'Rectangular'
                  ParentShowHint = False
                  ShowHint = True
                  OnClick = btnCoefsModeClick
                end
              end
              object GroupBox8: TGroupBox
                Left = 8
                Top = 116
                Width = 225
                Height = 113
                TabOrder = 2
                object btnXpost: TSpeedButton
                  Left = 8
                  Top = 12
                  Width = 25
                  Height = 21
                  Hint = 'Reset vector X'
                  Caption = 'X'
                  ParentShowHint = False
                  ShowHint = True
                  OnClick = btnXpostClick
                end
                object btnYpost: TSpeedButton
                  Left = 8
                  Top = 36
                  Width = 25
                  Height = 21
                  Hint = 'Reset vector Y'
                  Caption = 'Y'
                  ParentShowHint = False
                  ShowHint = True
                  OnClick = btnYpostClick
                end
                object btnOpost: TSpeedButton
                  Left = 8
                  Top = 60
                  Width = 25
                  Height = 21
                  Hint = 'Reset vector O'
                  Caption = 'O'
                  ParentShowHint = False
                  ShowHint = True
                  OnClick = btnOpostClick
                end
                object btnResetPostCoefs: TSpeedButton
                  Left = 8
                  Top = 84
                  Width = 213
                  Height = 22
                  Hint = 'Reset post-transform vectors to defaults'
                  Caption = 'Reset post-transform'
                  ParentShowHint = False
                  ShowHint = True
                  OnClick = btnResetPostCoefsClick
                end
                object txtPost00: TEdit
                  Left = 36
                  Top = 12
                  Width = 85
                  Height = 21
                  TabOrder = 0
                  Text = '0'
                  OnExit = PostCoefValidate
                  OnKeyPress = PostCoefKeypress
                end
                object txtPost01: TEdit
                  Left = 128
                  Top = 12
                  Width = 89
                  Height = 21
                  TabOrder = 1
                  Text = '0'
                  OnExit = PostCoefValidate
                  OnKeyPress = PostCoefKeypress
                end
                object txtPost10: TEdit
                  Left = 36
                  Top = 36
                  Width = 85
                  Height = 21
                  TabOrder = 2
                  Text = '0'
                  OnExit = PostCoefValidate
                  OnKeyPress = PostCoefKeypress
                end
                object txtPost11: TEdit
                  Left = 128
                  Top = 36
                  Width = 89
                  Height = 21
                  TabOrder = 3
                  Text = '0'
                  OnExit = PostCoefValidate
                  OnKeyPress = PostCoefKeypress
                end
                object txtPost20: TEdit
                  Left = 36
                  Top = 60
                  Width = 85
                  Height = 21
                  TabOrder = 4
                  Text = '0'
                  OnExit = PostCoefValidate
                  OnKeyPress = PostCoefKeypress
                end
                object txtPost21: TEdit
                  Left = 128
                  Top = 60
                  Width = 89
                  Height = 21
                  TabOrder = 5
                  Text = '0'
                  OnExit = PostCoefValidate
                  OnKeyPress = PostCoefKeypress
                end
              end
              object chkAutoZscale: TCheckBox
                Left = 8
                Top = 273
                Width = 275
                Height = 17
                Anchors = [akLeft, akTop, akRight]
                Caption = 'Auto calculate pre_zscale'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 3
                OnClick = chkAutoZscaleClick
              end
            end
          end
          object tabColors: TTabSheet
            Caption = 'Colors'
            ImageIndex = 3
            object GroupBox4: TGroupBox
              Left = 8
              Top = 336
              Width = 225
              Height = 65
              Caption = 'Transform visibility'
              TabOrder = 0
              Visible = False
              object chkXformInvisible: TCheckBox
                Left = 8
                Top = 32
                Width = 209
                Height = 17
                Caption = 'Invisible'
                TabOrder = 0
                OnClick = chkPlotModeClick
              end
            end
            object ScrollBox2: TScrollBox
              Left = 0
              Top = 0
              Width = 290
              Height = 420
              HorzScrollBar.Visible = False
              Align = alClient
              BorderStyle = bsNone
              TabOrder = 1
              OnResize = ScrollBox2Resize
              DesignSize = (
                290
                420)
              object GroupBox1: TGroupBox
                Left = 6
                Top = 2
                Width = 281
                Height = 199
                Anchors = [akLeft, akTop, akRight]
                Caption = 'Transform color'
                TabOrder = 0
                DesignSize = (
                  281
                  199)
                object pnlSymmetry: TPanel
                  Left = 8
                  Top = 78
                  Width = 97
                  Height = 21
                  Cursor = crHandPoint
                  Hint = 'Click and drag to change value'
                  BevelOuter = bvLowered
                  Caption = ' Color speed:'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 7
                  OnDblClick = DragPanelDblClick
                  OnMouseDown = DragPanelMouseDown
                  OnMouseMove = DragPanelMouseMove
                  OnMouseUp = DragPanelMouseUp
                end
                object pnlXFormColor: TPanel
                  Left = 8
                  Top = 16
                  Width = 73
                  Height = 21
                  Cursor = crHandPoint
                  Hint = 'Click and drag to change value'
                  BevelInner = bvRaised
                  BevelOuter = bvLowered
                  BorderStyle = bsSingle
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 6
                  OnDblClick = DragPanelDblClick
                  OnMouseDown = DragPanelMouseDown
                  OnMouseMove = DragPanelMouseMove
                  OnMouseUp = DragPanelMouseUp
                  object shColor: TShape
                    Left = -1
                    Top = -1
                    Width = 75
                    Height = 25
                    OnMouseDown = shColorMouseDown
                    OnMouseMove = shColorMouseMove
                    OnMouseUp = shColorMouseUp
                  end
                end
                object txtXFormColor: TEdit
                  Left = 80
                  Top = 16
                  Width = 192
                  Height = 21
                  Anchors = [akLeft, akTop, akRight]
                  TabOrder = 0
                  OnExit = txtXFormColorExit
                  OnKeyPress = txtXFormColorKeyPress
                end
                object txtSymmetry: TEdit
                  Left = 104
                  Top = 78
                  Width = 168
                  Height = 21
                  Anchors = [akLeft, akTop, akRight]
                  TabOrder = 2
                  Text = '0'
                  OnExit = txtSymmetrySet
                  OnKeyPress = txtSymmetrKeyPress
                end
                object ColorBar: TPanel
                  Left = 8
                  Top = 40
                  Width = 264
                  Height = 17
                  Anchors = [akLeft, akTop, akRight]
                  BevelOuter = bvLowered
                  BorderStyle = bsSingle
                  Color = clAppWorkSpace
                  TabOrder = 8
                  OnMouseUp = ColorBarMouseUp
                  object ColorBarPicture: TImage
                    Left = 1
                    Top = 1
                    Width = 258
                    Height = 11
                    Align = alClient
                    Stretch = True
                    OnMouseUp = ColorBarMouseUp
                  end
                end
                object scrlXFormColor: TScrollBar
                  Left = 9
                  Top = 54
                  Width = 263
                  Height = 15
                  Anchors = [akLeft, akTop, akRight]
                  LargeChange = 10
                  Max = 1000
                  PageSize = 0
                  TabOrder = 1
                  OnChange = scrlXFormColorChange
                  OnScroll = scrlXFormColorScroll
                end
                object pnlOpacity: TPanel
                  Left = 8
                  Top = 108
                  Width = 97
                  Height = 21
                  Cursor = crHandPoint
                  Hint = 'Click and drag to change value'
                  BevelOuter = bvLowered
                  Caption = ' Opacity:'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 9
                  OnDblClick = DragPanelDblClick
                  OnMouseDown = DragPanelMouseDown
                  OnMouseMove = DragPanelMouseMove
                  OnMouseUp = DragPanelMouseUp
                end
                object txtOpacity: TEdit
                  Left = 104
                  Top = 108
                  Width = 168
                  Height = 21
                  Anchors = [akLeft, akTop, akRight]
                  TabOrder = 3
                  Text = '1'
                  OnExit = txtOpacitySet
                  OnKeyPress = txtOpacityKeyPress
                end
                object chkXformSolo: TCheckBox
                  Left = 8
                  Top = 176
                  Width = 264
                  Height = 17
                  Anchors = [akLeft, akTop, akRight]
                  Caption = 'Solo'
                  TabOrder = 5
                  OnClick = chkXformSoloClick
                end
                object pnlDC: TPanel
                  Left = 8
                  Top = 140
                  Width = 97
                  Height = 21
                  Cursor = crHandPoint
                  Hint = 'Click and drag to change value'
                  BevelOuter = bvLowered
                  Caption = ' Direct color:'
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 10
                  OnDblClick = DragPanelDblClick
                  OnMouseDown = DragPanelMouseDown
                  OnMouseMove = DragPanelMouseMove
                  OnMouseUp = DragPanelMouseUp
                end
                object txtDC: TEdit
                  Left = 104
                  Top = 140
                  Width = 168
                  Height = 21
                  Anchors = [akLeft, akTop, akRight]
                  TabOrder = 4
                  Text = '1'
                  OnExit = txtDCSet
                  OnKeyPress = txtDCKeyPress
                end
              end
              object GroupBox2: TGroupBox
                Left = 6
                Top = 207
                Width = 281
                Height = 121
                Anchors = [akLeft, akTop, akRight]
                Caption = 'Variation preview'
                TabOrder = 1
                DesignSize = (
                  281
                  121)
                object Label1: TLabel
                  Left = 8
                  Top = 24
                  Width = 31
                  Height = 13
                  Caption = 'Range'
                end
                object Label2: TLabel
                  Left = 8
                  Top = 56
                  Width = 29
                  Height = 13
                  Caption = 'Depth'
                end
                object Label3: TLabel
                  Left = 8
                  Top = 88
                  Width = 36
                  Height = 13
                  Caption = 'Density'
                end
                object trkVarPreviewDensity: TTrackBar
                  Left = 88
                  Top = 88
                  Width = 184
                  Height = 25
                  Anchors = [akLeft, akTop, akRight]
                  Max = 5
                  Min = 1
                  ParentShowHint = False
                  PageSize = 1
                  Position = 2
                  ShowHint = True
                  TabOrder = 2
                  ThumbLength = 15
                  OnChange = trkVarPreviewDensityChange
                end
                object trkVarPreviewRange: TTrackBar
                  Left = 88
                  Top = 24
                  Width = 184
                  Height = 25
                  Anchors = [akLeft, akTop, akRight]
                  Max = 5
                  Min = 1
                  ParentShowHint = False
                  PageSize = 1
                  Position = 2
                  ShowHint = True
                  TabOrder = 0
                  ThumbLength = 15
                  OnChange = trkVarPreviewRangeChange
                end
                object trkVarPreviewDepth: TTrackBar
                  Left = 88
                  Top = 56
                  Width = 184
                  Height = 25
                  Anchors = [akLeft, akTop, akRight]
                  Max = 5
                  Min = 1
                  ParentShowHint = False
                  PageSize = 1
                  Position = 1
                  ShowHint = True
                  TabOrder = 1
                  ThumbLength = 15
                  OnChange = trkVarPreviewDepthChange
                end
              end
            end
          end
          object tabVariations: TTabSheet
            Caption = 'Variations'
            DesignSize = (
              290
              420)
            object Label4: TLabel
              Left = 2
              Top = 8
              Width = 37
              Height = 13
              Caption = 'Search:'
            end
            object SpeedButton1: TSpeedButton
              Left = 268
              Top = 7
              Width = 17
              Height = 17
              Caption = 'r'
              Flat = True
              Font.Charset = SYMBOL_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Marlett'
              Font.Style = []
              ParentFont = False
              OnClick = btnResetSearchClick
            end
            object btnLoadVVAR: TButton
              Left = 0
              Top = 392
              Width = 97
              Height = 25
              Anchors = [akLeft, akBottom]
              Caption = 'Load variation...'
              Enabled = False
              TabOrder = 4
              Visible = False
              OnClick = btnLoadVVARClick
            end
            object VEVars: TValueListEditor
              Left = 0
              Top = 32
              Width = 290
              Height = 335
              Anchors = [akLeft, akTop, akRight, akBottom]
              DefaultColWidth = 90
              ScrollBars = ssVertical
              TabOrder = 1
              TitleCaptions.Strings = (
                'Variation'
                'Value')
              OnDblClick = VEVarsDblClick
              OnDrawCell = VEVarsDrawCell
              OnExit = VEVarsChange
              OnKeyPress = VEVarsKeyPress
              OnMouseDown = VEVarsMouseDown
              OnMouseMove = VEVarsMouseMove
              OnMouseUp = VEVarsMouseUp
              OnValidate = VEVarsValidate
              ColWidths = (
                90
                194)
            end
            object chkCollapseVariations: TCheckBox
              Left = 1
              Top = 373
              Width = 291
              Height = 17
              Anchors = [akLeft, akRight, akBottom]
              Caption = 'Hide non-used variations'
              TabOrder = 2
              OnClick = chkCollapseVariationsClick
            end
            object bClear: TBitBtn
              Left = 0
              Top = 392
              Width = 289
              Height = 25
              Anchors = [akLeft, akRight, akBottom]
              Caption = 'Clear'
              TabOrder = 3
              OnClick = bClearClick
            end
            object txtSearchBox: TEdit
              Left = 45
              Top = 5
              Width = 217
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              OnChange = txtSearchBoxChange
            end
          end
          object TabSheet4: TTabSheet
            Caption = 'Variables'
            ImageIndex = 4
            DesignSize = (
              290
              420)
            object vleVariables: TValueListEditor
              Left = 0
              Top = 0
              Width = 290
              Height = 396
              Align = alTop
              Anchors = [akLeft, akTop, akRight, akBottom]
              ScrollBars = ssVertical
              TabOrder = 0
              TitleCaptions.Strings = (
                'Variable'
                'Value')
              OnDblClick = VEVarsDblClick
              OnExit = vleVariablesExit
              OnKeyPress = vleVariablesKeyPress
              OnMouseDown = VEVarsMouseDown
              OnMouseMove = VEVarsMouseMove
              OnMouseUp = VEVarsMouseUp
              OnValidate = vleVariablesValidate
              ColWidths = (
                93
                191)
            end
            object chkCollapseVariables: TCheckBox
              Left = 0
              Top = 399
              Width = 291
              Height = 17
              Anchors = [akLeft, akRight, akBottom]
              Caption = 'Show all variables'
              TabOrder = 1
              OnClick = chkCollapseVariablesClick
            end
          end
          object TabChaos: TTabSheet
            Caption = 'Xaos'
            ImageIndex = 5
            DesignSize = (
              290
              420)
            object vleChaos: TValueListEditor
              Left = 0
              Top = 0
              Width = 290
              Height = 375
              Align = alCustom
              Anchors = [akLeft, akTop, akRight, akBottom]
              PopupMenu = ChaosPopup
              ScrollBars = ssVertical
              TabOrder = 0
              TitleCaptions.Strings = (
                'Path'
                'Weight modifier')
              OnDblClick = VEVarsDblClick
              OnDrawCell = VleChaosDrawCell
              OnExit = vleChaosExit
              OnKeyPress = vleChaosKeyPress
              OnMouseDown = VEVarsMouseDown
              OnMouseMove = VEVarsMouseMove
              OnMouseUp = VEVarsMouseUp
              OnValidate = vleChaosValidate
              ColWidths = (
                93
                191)
            end
            object optFrom: TRadioButton
              Left = 0
              Top = 398
              Width = 291
              Height = 17
              Anchors = [akLeft, akRight, akBottom]
              Caption = 'View links as "from"'
              TabOrder = 2
              TabStop = True
              OnClick = mnuChaosViewFromClick
            end
            object optTo: TRadioButton
              Left = 0
              Top = 382
              Width = 291
              Height = 17
              Anchors = [akLeft, akRight, akBottom]
              Caption = 'View links as "to"'
              Checked = True
              TabOrder = 1
              TabStop = True
              OnClick = mnuChaosViewToClick
            end
          end
        end
        object pnlWeight: TPanel
          Left = 8
          Top = 47
          Width = 121
          Height = 21
          Cursor = crHandPoint
          Hint = 'Click and drag to change value'
          BevelOuter = bvLowered
          Caption = ' Weight:'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnDblClick = DragPanelDblClick
          OnMouseDown = DragPanelMouseDown
          OnMouseMove = DragPanelMouseMove
          OnMouseUp = DragPanelMouseUp
        end
        object Panel1: TPanel
          Left = 8
          Top = 6
          Width = 121
          Height = 21
          Cursor = crArrow
          BevelOuter = bvLowered
          Caption = ' Transform:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
        end
        object Panel2: TPanel
          Left = 8
          Top = 26
          Width = 121
          Height = 21
          Cursor = crHandPoint
          BevelOuter = bvLowered
          Caption = ' Name:'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
        end
        object txtName: TEdit
          Left = 128
          Top = 26
          Width = 163
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          OnExit = txtNameExit
          OnKeyPress = txtNameKeyPress
        end
        object txtP: TEdit
          Left = 128
          Top = 47
          Width = 163
          Height = 21
          Hint = '"Weight" is the probability of this transform to be applied'
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          Text = '0'
          OnExit = txtPExit
          OnKeyPress = txtPKeyPress
        end
        object cbTransforms: TComboBox
          Left = 128
          Top = 6
          Width = 163
          Height = 19
          BevelEdges = []
          BevelOuter = bvNone
          Style = csOwnerDrawFixed
          Anchors = [akLeft, akTop, akRight]
          Color = clBlack
          Ctl3D = False
          DropDownCount = 12
          ItemHeight = 13
          ParentCtl3D = False
          TabOrder = 0
          OnChange = cbTransformsChange
          OnDrawItem = cbTransformsDrawItem
        end
      end
      object PrevPnl: TPanel
        Left = 0
        Top = 0
        Width = 300
        Height = 177
        Align = alTop
        BevelOuter = bvLowered
        Color = clAppWorkSpace
        TabOrder = 1
        Visible = False
        object PreviewImage: TImage
          Left = 1
          Top = 1
          Width = 298
          Height = 175
          PopupMenu = QualityPopup
          Proportional = True
        end
      end
    end
  end
  object EditPopup: TPopupMenu
    Images = EditorTB
    Left = 400
    Top = 112
    object mnuUndo: TMenuItem
      Caption = 'Undo'
      Enabled = False
      Hint = 'Undo'
      ImageIndex = 4
      ShortCut = 16474
      OnClick = mnuUndoClick
    end
    object mnuRedo: TMenuItem
      Caption = 'Redo'
      Enabled = False
      Hint = 'Redo'
      ImageIndex = 5
      ShortCut = 16473
      OnClick = mnuRedoClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object mnuAdd: TMenuItem
      Caption = 'Add transform'
      Hint = 'Add new triangle'
      ImageIndex = 1
      OnClick = mnuAddClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuAutoZoom: TMenuItem
      Caption = 'Auto Zoom'
      Hint = 'Zoom to fit all triangles'
      ImageIndex = 19
      OnClick = mnuAutoZoomClick
    end
    object mnuShowVarPreview: TMenuItem
      Caption = 'Show Variation Preview'
      Hint = 'Show/hide variation preview'
      ImageIndex = 14
      OnClick = tbVarPreviewClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object mnuSelectmode: TMenuItem
      Caption = 'Select mode'
      ImageIndex = 6
      OnClick = tbSelectClick
    end
    object mnuExtendedEdit: TMenuItem
      Caption = 'Extended edit mode'
      Hint = 'Toggle extended edit mode'
      ImageIndex = 25
      OnClick = tbExtendedEditClick
    end
    object mnuAxisLock: TMenuItem
      Caption = 'Lock transform axes'
      ImageIndex = 16
      OnClick = tbAxisLockClick
    end
    object oggleposttriangleediting1: TMenuItem
      Caption = 'Toggle post-triangle editing'
      ImageIndex = 29
      OnClick = tbPostXswapClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object mnuFlipAllV: TMenuItem
      Caption = 'Flip All Vertical '
      Hint = 'Flip all triangles vertical'
      ImageIndex = 13
      OnClick = mnuFlipAllVClick
    end
    object mnuFlipAllH: TMenuItem
      Caption = 'Flip All Horizontal'
      Hint = 'Flip all triangles horizontal'
      ImageIndex = 12
      OnClick = mnuFlipAllHClick
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object mnuEHighQuality: TMenuItem
      Caption = 'High quality'
      RadioItem = True
      OnClick = mnuHighQualityClick
    end
    object mnuEMediumQuality: TMenuItem
      Caption = 'Medium quality'
      Checked = True
      RadioItem = True
      OnClick = mnuMediumQualityClick
    end
    object mnuELowQuality: TMenuItem
      Caption = 'Low quality'
      RadioItem = True
      OnClick = mnuLowQualityClick
    end
  end
  object QualityPopup: TPopupMenu
    Images = MainForm.Buttons
    Left = 384
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
    object mnuResetLoc: TMenuItem
      Caption = 'Auto reset location'
      OnClick = mnuResetLocClick
    end
  end
  object EditorTB: TImageList
    Left = 313
    Top = 40
    Bitmap = {
      494C010120003000200010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000009000000001002000000000000090
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000707070007070700070707000707070007070700070707000707070007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000707070007070700070707000707070007070700070707000707070007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007070700070707000707070007070700070707000707070007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007070700070707000707070007070700070707000707070007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007070700070707000FED2B900FED1B800FDD0B700FCCF
      B500FCCEB4007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007070700070707000FED2B900FED1B800FDD0B700FCCF
      B500FCCEB4007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007070700070707000FED2B900FDD1B800FDD0
      B600FCCEB5007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070707000707070007070
      7000707070007070700070707000707070007070700070707000707070007070
      7000FCCEB5007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007070700070707000FED1B900FDD0
      B700FCCFB6007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000707070007070
      7000707070007070700070707000707070007070700070707000707070007070
      7000FCCFB6007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007070700070707000FDD1
      B800FDD0B7007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007070
      700070707000FEFEFE00FAF7F500F5EDE900EFE3DC00EAD9D100707070007070
      7000FDD0B7007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000707070007070
      7000FDD0B8007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007070700070707000FDFCFB00F8F3F000F2E9E300EDDFD800707070007070
      7000FDD0B8007070700070707000000000005A5A5A0000000000000000000000
      00005A5A5A0000000000000000000000000000000000000000005A5A5A000000
      000000000000000000005A5A5A000000000000000000B9530000000000000000
      0000BA520200B9530000000000000000000000000000B9530000000000007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007070700070707000FBF8F700F6EFEB00F0E5DF00707070007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B9530000000000000000
      000000000000B95300000000000000000000B953000000000000000000000000
      0000707070007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A5A5A5000000000000000000000000000000000000000000000000000000
      000000000000000000007070700070707000F9F5F200F4EBE600707070007070
      700070707000707070007070700000000000000000005A5A5A00000000005A5A
      5A00000000000000000000000000000000000000000000000000000000005A5A
      5A00000000005A5A5A00000000000000000000000000B9530000000000000000
      00000000000000000000B9530000B95300000000000000000000000000000000
      0000000000007070700070707000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A5A5
      A5000000000000000000000000000000000000000000000000008E7A17006B53
      17000000000000000000000000007070700070707000F7F1EE00707070007070
      7000000000007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B9530000B9530000B953
      0000B953000000000000B9530000B95300000000000000000000000000000000
      0000000000000000000070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A5A5A5000000
      00000000000000000000000000000000000000000000000000008FBC49007E6D
      1200000000000000000000000000000000007070700070707000707070007070
      70000000000000000000707070000000000000000000000000005A5A5A000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005A5A5A0000000000000000000000000000000000B9530000000000000000
      0000B9530000000000000000000000000000B953000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A5A5A500000000000000
      00000000000000000000000000000000000096C66200A6D17C00BBE1A20091C4
      520089771400624D170000000000000000000000000070707000707070007070
      7000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B9530000B9530000B953
      0000B953000000000000000000000000000000000000B9530000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A5A5A50000000000000000000000
      000000000000000000000000000000000000B0D88900CFE9BB00D6EFCD00C0E4
      AA008FBE4B008E7D140000000000000000000000000000000000707070007070
      7000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CEE9BB00B1D7
      8D00000000000000000000000000000000000000000000000000000000007070
      7000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B1D98B00A0CD
      7500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000707070007070700070707000707070007070700070707000707070007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000081685500262F3800262F3800262F3800262F3800262F
      3800262F3800262F3800262F3800262F38000000000000000000000000000000
      0000000000007070700070707000707070007070700070707000707070007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BA6E4700AA542900AA542900A25027009B4C25009648
      23008F4622008A4321008641200000000000BCCCD200647E8E004F5E6F004552
      610037414D00262F380089715E00E8DCD300B7A29300B7A29300B7A29300B7A2
      9300B7A29300B7A29300B7A29300262F38000000000000000000000000000000
      0000000000000000000070707000707070001FDC6F001EDB6E001EDA6C001DD8
      6B001CD769007070700070707000000000000000000000000000000000000000
      0000000000000000000042636300000000004263630000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C1795500FDF9F600CEB09C00CCAF9B00CAAD9A00C7AC
      9900C6AB9800C4A997008943210000000000717F8B0022B6EC00008FCD00008F
      CD00008FCD00008FCD0091796600EFE6E100E8DBD300E0D0C600DAC6BC00D4BF
      B200CFB9AB00CCB6A800B7A29300262F38000000000000000000000000000000
      000000000000000000000000000070707000707070001FDB6E001EDA6D001DD9
      6C001DD86A007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C9856400FFFFFF00DA8C5C00D1835100D1835100D183
      5100D1835100C6AB98008E452200000000007584900068C8EA0010B5F00008AC
      EB0003A4E3000096D4009A826F00F7F1EF00C3AE9E00C3AE9E00BDA89800B7A2
      9300D4BFB200B7A29300B7A29300262F38000000000000000000000000000000
      00000000000000000000000000000000000070707000707070001FDB6E001EDA
      6D001DD96B007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B7A2930063493500634935006349
      35006349350063493500D1927300FFFFFF00FEFDFB00FBEFEA00F5DED300F0CE
      BE00EDC3AF00C7AC990092472300000000007989940074D0ED0028BDF10011B5
      F00007ABEA00009DDC00A28A7800FDFBFA00F7F2EE00EFE6E100E8DBD300E0D0
      C600705A4A0061524600504842003F3D3E000000000000000000000000000000
      0000000000000000000000000000000000000000000070707000707070001EDB
      6D001ED96C007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B7A29300F8F3F000EADFD700E6D9
      CF00E1D2C700DDCBBF00D89F8200FFFFFF00F3A77F00E7976E00DA8C5C00D183
      5100D1835100CAAE9A00984A2500000000007E8E9A0083D9F00046C9F2002DBF
      F20016B7F10000A0E200A9928000FFFFFF00C3AE9E00C3AE9E00BDA89900E8DC
      D3007A604D00D4C5BA0061524700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000707070007070
      70001EDA6D007070700070707000000000000000000000000000426363000000
      0000000000000000000000000000000000000000000000000000000000000000
      000042636300000000000000000000000000B7A29300FBF8F700E5AE8100DEA1
      7300DA9C6E00D5976800E0AA9000FFFFFF00FFFFFF00FFFFFF00FBF4F000F7E4
      DB00F2D3C500CCAE9A009D4D25000000000082949E0091E2F30066D5F4004CCB
      F30032C2F20015AFE900B0998800FFFFFF00FFFFFF00FCFBF900F7F1EF00EFE7
      E100816856007A604D0000000000000000000000000000B93400000000000000
      000002B8360000B9340000000000000000000000000000B93400000000007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BBA69700FEFDFC00FBF6F500F6EF
      EB00F1E6E000ECDED600E7B59C00FFFFFF00FCAE8A00FCAE8A00F1DBD200E78E
      6000B3572A00AC542900A4502700000000008699A2009FEAF60083E1F6006BD8
      F50053CEF4000EB3F000B6A08E00B0998800A9928000A28A78009A8270009179
      670089715E000000000000000000000000000000000000B93400000000000000
      00000000000000B93400000000000000000000B9340000000000000000000000
      0000707070007070700070707000000000000000000000000000426363000000
      0000000000000000000000000000000000000000000000000000000000000000
      000042636300000000000000000000000000C1AB9C00FFFFFF00FAC59F00F0B8
      8E00E5AE8100DEA17300ECBDA600FFFFFF00FFFFFF00FFFFFF00FFFFFF00EA9A
      7200F0C9B200B1572B00EDD7CD00000000008A9EA600A9F0F80099EAF80088E3
      F5006DD1EA0013A1D40013A1D40012A0D3000D97CF000791CA00008FCD00008F
      CD00303944000000000000000000000000000000000000B93400000000000000
      0000000000000000000000B9340000B934000000000000000000000000000000
      0000000000007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C7B2A300FFFFFF00FFFFFF00FCFA
      F900F8F2F000F3EAE600F0C4AE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00EBA7
      8500C5653500F1DBCF0000000000000000008DA1AA00AAF1F900A7F0F9005E7D
      8A0058737F00566D7A00526977004F6673004C617000445A6800236F9000008F
      CD003E4A58000000000000000000000000000000000000B9340000B9340000B9
      340000B934000000000000B9340000B934000000000000000000000000000000
      0000000000000000000070707000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CFB9A900FFFFFF00FFDABA00FFD0
      AE00F0DED200B7A29300F0C4AE00EFC2AB00EFC1AA00EFB9A000EDB09200EDB0
      9200F9E4D9000000000000000000000000008FA4AC00AAF1F900A8F1F9005D86
      96008CC6CF0093E4F0007AD5E70062C6DE004F9AB2003E5A67001C7DA500008F
      CD004B5969000000000000000000000000000000000000B93400000000000000
      00000000000000000000000000000000000000B9340000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D4BEAF00FFFFFF00FFFFFF00FFFF
      FF00FEFDFC00BBA69600D4C5BA008F725B00E2DDD90000000000000000000000
      0000000000000000000000000000000000008FA4AC00ABF0F700AAF1F900A6EF
      F7007397A200A1ECF500667D8A0078C5D6004C6C7C00346178005FC3E80022B6
      EC004E5E6F000000000000000000000000000000000000B9340000B9340000B9
      340000B9340000B9340000000000000000000000000000B93400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000042636300000000004263630000000000000000000000
      000000000000000000000000000000000000D8C2B200FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C7B1A200A5826600E2DDD9000000000000000000000000000000
      000000000000000000000000000000000000B7CACF008FA4AC008FA4AC008FA4
      AC005B8D9F00A5E8EF009BE8F4008CD5E2004666760073858F007A8A95007585
      9100BDCED3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D8C2B200D8C2B200D4BFAE00D4BF
      AE00CEB8A900C8B2A300E9E2DE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000086B3C30082ADBD00799FB000BCCED30000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000630000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000630000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000630000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006300000000000000630000000000000063000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000063000000630000006300000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000630000000000
      0000630000000000000063000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006300
      0000000000000000000000000000630000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006300
      0000630000006300000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006300000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630000000000000063000000630000006300000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000063000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006300000063000000630000006300
      0000630000006300000063000000FFFFFF006300000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000630000006300000063000000630000006300
      0000630000006300000063000000630000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005252
      5200000000000000000000000000000000000000000000000000000000000000
      0000630000000000000063000000630000006300000000000000000000005252
      5200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005252
      5200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000630000000000000000000000000000005252
      5200000000000000000063000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000525252000000
      0000000000000000000000000000000000000000000000000000000000006300
      0000000000000000000000000000000000000000000000000000525252000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000525252000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000630000000000000000000000525252000000
      0000000000006300000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000052525200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000052525200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630000000000000000000000000000000000000052525200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000630000000000000052525200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005252520000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005252520000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006300000000000000000000005252520000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000630000005252520000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006300000063000000630000006300
      0000630000006300000063000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000630000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006300000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006300000000000000630000000000000063000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000063000000630000006300000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000630000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000063000000630000006300
      0000630000006300000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000063000000FFFFFF00FFFF
      FF00FFFFFF006300000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000063000000FFFFFF00FFFF
      FF00FFFFFF0063000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BE724D00C77B5500CC80
      5B00D78B6500D68A650000000000000000000000000000000000D68A6500D78B
      6500CC805B00C77B5500BE724D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000063000000FFFFFF00FFFF
      FF00FFFFFF006300000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B0694700BC724E00BA66
      3C00C47D5E00DE926C0000000000000000000000000000000000DE926C00FBC3
      A600FBC3A600FDBE9E00B0694700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000063000000630000006300
      0000630000006300000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D1B3CA0096492400000000000000000000000000A75F3C00BC724E00BA66
      3C00C47D5E00DE926C0000000000000000000000000000000000DE926C00FBC3
      A600FBC3A600FDBE9E00A75F3C0000000000000000000000000096492400ECC5
      D700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D1B3
      CA009D4E28009D4D25000000000000000000000000009D543000BC724E00BA66
      3C00C47D5E00E296700000000000000000000000000000000000E2967000FBC3
      A600FBC3A600FDBE9E009D5430000000000000000000000000009D4D25009D4E
      2800ECC5D7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000052525200000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D1B3CA00A050
      2A00D2754700AB542900A24F27009A4B25009247230092472300BC724E00BA66
      3C00C47D5E00E296700000000000000000000000000000000000E2967000FBC3
      A600FBC3A600FDBE9E0092472300924723009A4B2500A24F2700AB542900BF6A
      3F00A0502A00ECC5D70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005252520000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D1B3CA00A2563100E186
      5800F68F5B00E9865500D97B4D00C8704400B7653B00AA5B3300BD704A00B667
      4000BE775500E296700000000000000000000000000000000000E2967000FBC3
      A600FBC3A600FDBE9E00FCB99700FDB08900F7905C00EC885600DE7F4F00D176
      4800C46E4200A2563100ECC5D700000000000000000000000000000000000000
      0000000000000000000000000000525252000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E2956E00FBC0A100FFB3
      8C00FF9E6D00F68F5B00E9865500D97B4D00C8704400C8704400CF7F5700CB79
      5000C47A5700E296700000000000000000000000000000000000E2967000FBC3
      A600FBC3A600FDBE9E00FDBE9E00FCB99700FDA57800FC935E00F28C5900E584
      5300D87B4C00C66E4100AE582B00000000000000000000000000000000000000
      0000000000000000000052525200000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E0BDCC00E89C7600FBC0
      A100FFB38B00FFB38D00F8A87F00EEA17A00E1987400E1987400E1987400D98B
      6500D1896500E296700000000000000000000000000000000000E2967000FBC3
      A600FBC3A600FBC3A600FBC3A600FDBE9E00FDBE9E00FEAE8500FFA87D00F89D
      6F00E5835100AE582B00F5CEE400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DFBFCF00E89C
      7600FBBFA000CE673300E7946C00E68E6200E5875800E28B5E00E28B6100E28F
      6500E2916800E296700000000000000000000000000000000000E2967000E296
      7000E2967000E2967000E2967000E2967000DA8E6800D1855F00DB906A00F79A
      6B00AE582B00F5CEE40000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DFBF
      CF00E79A7300D2703E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E5997300C576
      4E00F4CFE2000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000DFBFCF00E79A730000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E89C7600F9D3
      EB00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B971
      44000000000000000000AD6538000000000000000000A55C2E00000000000000
      0000A1582A00000000000000000000000000000000000000000000000000BB74
      460000000000000000000000000000000000000000000000000000000000A158
      2A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BB75
      48000000000000000000B16B3C000000000000000000A75F3200000000000000
      0000A1582A00000000000000000000000000000000000000000000000000BB74
      460000000000000000000000000000000000000000000000000000000000A158
      2A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C7815400C37D5000BF79
      4C00BD754800B9714200B56D4000B1693C00AE663700AB623400A85F3100A65B
      2E00A35A2C00A1582A00A1582A0000000000000000000000000000000000C079
      4C0000000000000000000000000000000000000000000000000000000000A158
      2A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C37D
      52000000000000000000B97144000000000000000000AE663900000000000000
      0000A55C2E00000000000000000000000000CD875A00CD875A00C9835600C57E
      5100C07A4C00BC754800B8714300B46C3F00B0683A00A9603300A65D2F00A35A
      2C00A1582A00A1582A00A1582A00000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C783
      54000000000000000000BD7546000000000000000000B1693C00000000000000
      0000A85F3100000000000000000000000000000000000000000000000000C983
      560000000000000000000000000000000000000000000000000000000000A65E
      3000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D48C5F00CF895C00CB85
      5800C7815400C37D5000C1794C00BB754800B9714400B56B4000B2693B00AE65
      3700AA623500A85F3100A55B3000000000000000000000000000000000003E39
      370048403B0039322F0028231F001B171400070605000000000000000000AA61
      3300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CE8A
      5D000000000000000000C37D50000000000000000000B9714200000000000000
      0000AD6738000000000000000000000000000000000000000000000000008976
      6C00D1B9AC00CAAD9B00C8A89500C7A39000C7A08D000706050000000000B26A
      3C00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000008400840084008400840084008400
      8400000000000000000084008400840084008400840084008400840084008400
      840084008400840084008400840084008400000000000000000000000000D28E
      61000000000000000000C78154000000000000000000BB754800000000000000
      0000B1693C000000000000000000000000008A4625000000000000000000897D
      7600F8E9E000F6E3D900F4DED100F2D9CC00C7A391001814120000000000B66F
      4100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DB976800D8946800D591
      6400D28E6100CF895C00CB875800C7815400C37D5000C1794C00BD754600B770
      4400B56D3E00B1693C00AE66390000000000975433008A462500000000008980
      7900FAEEE700F8E8DF00F5E3D800F4DED100C8A89800231E1B0000000000BB74
      4600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D894
      67000000000000000000CF895C000000000000000000C47D5100000000000000
      0000B97144000000000000000000000000009754330000000000000000008980
      7C00FCF2EC00FAEDE600F8E9DF00F5E3D800CBAE9F00322C290000000000C079
      4C00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DB95
      6A000000000000000000D28E61000000000000000000C7835400000000000000
      0000BB7548000000000000000000000000000000000000000000000000008880
      7C00FCF4EE00FCF2EC00FAEFE800F9EAE100D6BFB3003F38350000000000C57E
      5100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DF9B6E00DF9B6E00DE98
      6B00DB976800D8946700D5916400D28E6100CE8A5D00CB855800C9815400C57D
      5000C1794C00BD754800B771440000000000DF9B6E00DF9B6E00DF9B6E00887F
      7A0089807C0089807C0089807900887D770089766C0035312E00CD885B00C983
      5600C57F5200C17A4D00C17A4D00000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DF9B
      6E000000000000000000D99366000000000000000000CF895C00000000000000
      0000C57D5000000000000000000000000000000000000000000000000000DF9B
      6E0000000000000000000000000000000000000000000000000000000000CE88
      5B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DF9B
      6E000000000000000000DB976A000000000000000000D28E5F00000000000000
      0000C9815400000000000000000000000000000000000000000000000000DF9B
      6E0000000000000000008A46250000000000000000000000000000000000D28D
      6000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DF9B
      6E000000000097543300975433008A462500000000000000000000000000D28D
      6000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A27760006349
      3500634935006349350063493500634935006349350063493500634935006349
      3500634935005C42300062483400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F0E1D900CB9E8700AE7050009956330099563300B1725200D1A28A00F4E5
      DE00000000000000000000000000000000000000000000000000A3786200EDED
      ED00E0E0E000D9D9D900D1D1D100C9C9C900C2C2C200B9B9B900B4B4B400B1B1
      B100928884003A1C0E0060473300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F8F1F100D5B2BB008A3C
      5A0078344C00000000000000000000000000000000000000000000000000E2C8
      BB00B5785700A7562D00B45C2E00B65C2E00B55C2D00B55C2D00BB5F3300D38D
      6A00F1D5C7000000000000000000000000000000000000000000A3796300EEEE
      EE00EEEEEE00ECECEC00EBEBEB00E9E9E900E8E8E800E5E5E500DFDFDF00B6AB
      A7002F160C0094888200634935000000000000000000B29E90007C6F63006D5D
      520068574A00635143005E4C3E000000000000000000C05D8000A94065008B2B
      5100872B4F0079254300701F3D00000000000000000000000000000000000000
      0000000000000000000000000000F9F4F400D3B6BD008E445F008B445D008940
      5B00853954000000000000000000000000000000000000000000F1E2DA00B778
      5700B35B2E00DF835300F29A6C00F1996E00EE966900E78D5E00DC7D4D00D476
      4800E09C7900F9EAE30000000000000000000000000000000000A37A6500EEEE
      EE00EDEDED00EDEDED00EBEBEB00EAEAEA00EAEAEA0043211000BCB2AE002A14
      0A00B5A9A300ADADAD00634935000000000000000000C1B3AA00D3D2D100BAB4
      B1009C948C0092877F00605042000000000000000000C2628300B9748900A44B
      68009F416200943758009D315800000000000000000000000000000000000000
      000000000000F7EFEF00D8BCC30090466000924E6500A1607500A35D75009E54
      6F0092405E000000000000000000000000000000000000000000CE9F8700AA57
      2D00DF835300FBAD8700FECBB000FDE9DF00FBE7DD00F1BCA100DC885D00D87A
      4A00E58D5F00F3C4AD0000000000000000000000000000000000AE8A7700EDED
      ED00EDEDED00ECECEC00EBEBEB00E9E9E900E9E9E900361A0D002D160B00BCB0
      A900DEDEDE00B1B1B10063493500000000000000000000000000BAA59600C7C3
      C100A69F9800988E8800604F42000000000000000000C4678600BD809200AD5D
      7600A54B6A00A3436600CE8F9B00000000000000000000000000FFFEFE00F3E6
      E800CEA8AF00A1597400A4647A00B9839400C18D9A00BD829300B7778A00AD6B
      80009B4564000000000000000000000000000000000000000000B5745300B85C
      2F00F0966800FDC8AE0000000000000000000000000000000000DCA58900CB6D
      3F00ED946500F4B29100000000000000000000000000A48F8000E4DBD5008871
      5F00D2CCC800765D4B00D1CBC6006F564300CFC9C4003D241700381B0D004220
      1000E2E2E200B8B8B800634935000000000000000000FEFEFE00C1B3AA00D1D0
      CE00B7B1AC00A0989100635244000000000000000000C66E8A00C28B9B00B570
      8400AC5F7800A8436800F9F0F100000000000000000000000000E9D5DC00BC85
      9700BF8C9A00D0A5AF00D5A9B600D3A8B300D2A3AF00CD9EAA00C692A000BC82
      9300AF5072000000000000000000000000000000000000000000A0583400BA5E
      3100EC946600FBE7DC0000000000000000000000000000000000EFDAD000BF65
      3600EE956600F3A9850000000000000000000000000000000000A38E80009680
      6F0087705E007A614F006F56430069503D00674D3A00D2CDC900E9E9E900E8E8
      E800E5E5E500C1C1C10063493500000000000000000000000000FEFEFE00BAA5
      9600C5C0BE00ADA6A30067554A000000000000000000C9748E00C7949F00BB7D
      8F00AB5B7600CE919A0000000000000000000000000000000000D3909F00D291
      A100D18FA000D0899B00CE819600CB7A9200C8738E00C56C8900C2638400C05C
      8000BE577C000000000000000000000000000000000000000000A0583400B65C
      2E00DE825300F7E3D80000000000D4886200FEFCFC0000000000EFDAD000BD60
      3300ED956700F3AB8700000000000000000000000000B7A39600AE9A8C00F9F3
      EE00F2E5DC00F1E1D800EFDDD100EDD8CC006A513E006E554100EAEAEA00E9E9
      E900E8E8E800CBCBCB0063493500000000000000000000000000FEFEFE00C1B3
      AA00D1D0CF00C1BEBC006D5C50000000000000000000CB7B9100CB9DA900C38D
      9D00AA4C6E00F9F2F20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B6765500B65C
      2E00CE6E3D00E5AE9100E9C2AE00DC926D000000000000000000CE997E00BF63
      3500EF976C00F5B6940000000000000000000000000000000000B7A39600FCFD
      FB00FCF8F600F7F2EC00F5E7DE00EFDED20070564300D5D0CC00EDEDED00ECEC
      EC00EAEAEA00D0D0D0006349350000000000000000000000000000000000FEFE
      FE00BAA59600C9C7C60075675D000000000000000000CE819500D4B0B900C177
      9200D2949D000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D5A58C00BE62
      3300D06B3800DB7C4D00DE855600E8A17D000000000000000000A65E3A00CB6F
      4300F6A37800FACCB300000000000000000000000000C3B0A300BEAA9D00FDFE
      FC00FCFDFB00FCFAF900F9F4EF00F0E1D70079604E00745C4900EEEEEE00EEEE
      EE00ECECEC00DADADA006349350000000000000000000000000000000000FFFF
      FF00C1B3AA00D2CFCE00807267000000000000000000D0889900D4AAB500C062
      8400F5E9E9000000000000000000000000000000000000000000BFB2AB00A598
      8E0091847A0084766B00796B61006D5C500067554A0063524400604F42006050
      42005E4C3E000000000000000000000000000000000000000000F5E6DF00D48F
      6A00DB784600F18E5C00F69E7000F4AF8C000000000000000000BE7A5500E48F
      6500FDBC9E00FEEFE80000000000000000000000000000000000C3B0A300FDFE
      FD00FDFEFD00FCFDFB00FCFBF900F2E5DD00856E5C00D6D1CC00EEEEEE00EEEE
      EE00EEEEEE00E0E0E00063493500000000000000000000000000000000000000
      000000000000BAA59600877A70000000000000000000D28D9C00CA849A00E1BA
      BE00000000000000000000000000000000000000000000000000F9F8F700CEC3
      BC00BCA99C00CFCAC800C7C5C400C1BEBC00ADA6A300A0989100988E88009287
      7F0063514300000000000000000000000000000000000000000000000000E2AF
      9400E68E6100FAA27600FFB08800FCB997000000000000000000FBF2ED00F6BF
      A400FEE3D50000000000000000000000000000000000C9B7AB00C6B4A800FDFE
      FD00FDFEFD00FDFEFD00FCFDFB00F7EEE900937D6D00866E5C00EEEEEE00EEEE
      EE00EEEEEE00EDEDED0063493500000000000000000000000000000000000000
      000000000000C1B3AA0092867C000000000000000000D4929F00D28B9E00FBF6
      F600000000000000000000000000000000000000000000000000000000000000
      0000FAF9F900CEC3BC00BCA99C00CFCDCA00C5C0BE00B7B1AC00A69F98009C94
      8C006A5A4D000000000000000000000000000000000000000000DA8F6A00E39A
      7600EDA78300F6B28F00FCB99700FCB997000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C9B7AB00C6B4
      A800C3B0A300BEAA9D00B6A39500AC988A00A18B7C00DED3CC00BCA19200A37A
      6500A3796300A3786200A2776000000000000000000000000000000000000000
      000000000000FEFEFE00AC9D96000000000000000000D595A100E1BECB000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FEFEFE00F8F6F500CABEB600BCA99C00CFCDCB00C7C3C100BAB4
      B10075665B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CCBAAE0000000000C9B7
      AB0000000000C3B0A30000000000B6A2950000000000A08A7C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FEFEFD00F4F2F100D3C9C200BCA99C00D2CF
      CE00817468000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFDFD00F4F1EF00CEC3
      BC00B2A195000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000745A4600694F3B00CAC2BB000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FBD7C500F8D5C3000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F8D5C300FBD7C500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BBADA10081685400CAB2A400684E3A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F8DCCF00F38A5700E195
      7100000000000000000000000000000000000000000000000000000000000000
      0000E1957100F38A5700F8DCCF00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000967C
      69000000000000000000000000008C735F00DFCABE00BDA79800705743000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005A5A5A00000000005A5A5A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EECBBA00F085
      5000DA865E00000000000000000000000000000000000000000000000000DA86
      5E00F0855000EECBBA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C83
      70007F655200CEC6BF00CABEB50091796600E9D7CE007C634F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CA80
      5C00F0885500EAC8B70000000000000000000000000000000000EAC8B700F088
      5500CA805C000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A38A
      7700DCD1CB006D533F0091796600DDCEC500D6C5BB00856C5900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E1CD
      C300DB784700EF93670000000000000000000000000000000000EF936700DB78
      4700E1CDC3000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000AA91
      7F00F9F4F100DDD4CD00856C5800F3EAE500947C6900DCD4CE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008A46
      2500954C2800A4542E00B65F3400C7693A00D672400000000000000000000000
      0000AE5C3600EC865200F2CFBD000000000000000000F2CFBD00EC865200AE5C
      3600000000000000000000000000D6724000C7693A00B65F3400A4542E00954C
      28008A462500000000000000000000000000000000000000000000000000B098
      8600FCFAF900FBF7F600F9F5F200F7F2EE00896F5C00664C38006A503C00765C
      49000000000000000000000000000000000000000000000000005A5A5A000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005A5A5A00000000000000000000000000000000000000000000000000954C
      2800DF733600EA824900F39A6A00F5B594000000000000000000000000000000
      0000A3664800E9845200F7C2A7000000000000000000F7C2A700E9845200A366
      480000000000000000000000000000000000F5B59400F39A6A00EA824900DF73
      3600954C2800000000000000000000000000000000000000000000000000B79F
      8D00FFFFFE00FEFDFC00FDFBFA00FBF8F700FAF6F300DFD5CE00886E5B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A355
      2E00EC824B00F38D5B00EC9C7600B6866F00E9D5CB0000000000000000000000
      0000A9745900E1825400F7BE9E000000000000000000F7BE9E00E1825400A974
      5900000000000000000000000000E9D5CB00B6866F00EC9C7600F38D5B00EC82
      4B00A3552E00000000000000000000000000000000000000000000000000BDA6
      9400FFFFFF00FFFFFF00FFFFFF00FEFDFD00E2DAD5009A826F00000000000000
      00000000000000000000000000000000000000000000000000005A5A5A000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005A5A5A00000000000000000000000000000000000000000000000000B55F
      3400F39A6A00F49C7100F29465009D533000AA613B00DAB8A70000000000F6C5
      AE009D644600DE805100F7BDA1000000000000000000F7BDA100DE8051009D64
      4600F6C5AE0000000000DAB8A700AA613B009D533000F2946500F49C7100F39A
      6A00B55F3400000000000000000000000000000000000000000000000000C3AC
      9900FFFFFF00FFFFFF00FFFFFF00ECE7E300AB93810000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C769
      3B00F7CAAE00FBDDCB00F4A37600F3946400B4623900B0643E00BF816200BB84
      6000A15E3900EE8B5A00F6C8B0000000000000000000F6C8B000EE8B5A00A15E
      3900BB846000BF816200B0643E00B4623900F3946400F4A37600FBDDCB00F7CA
      AE00C7693B00000000000000000000000000000000000000000000000000C8B0
      9E00FFFFFF00FFFFFF00F6F2F000BDA593000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D672
      40000000000000000000FBDECF00F5A57E00F49D7200C9734700B7663C00B665
      3D00E2815300F6BCA100F6CBB7000000000000000000F6CBB700F6BCA100E281
      5300B6653D00B7663C00C9734700F49D7200F5A57E00FBDECF00000000000000
      0000D6724000000000000000000000000000000000000000000000000000CBB4
      A200FFFFFF00F7F4F100CAB3A100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FBDACA00F5A67E00F6B69600F5B28F00F6B0
      9100F6C1A800F6C5AE0000000000000000000000000000000000F6C5AE00F6C1
      A800F6B09100F5B28F00F6B69600F5A67E00FBDACA0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CBB4
      A200F6F3F000CBB4A20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005A5A5A00000000005A5A5A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FBE0D200F6C3A900F7CF
      BB00F9DBCD00000000000000000000000000000000000000000000000000F9DB
      CD00F7CFBB00F6C3A900FBE0D200000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CBB4
      A200CBB4A2000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CBB4
      A200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B7A293006349
      3500634935006349350063493500634935006349350063493500634935006349
      3500634935000000000000000000000000000000000000000000000000000000
      0000707070007070700070707000707070007070700070707000707070007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000707070007070700070707000707070007070700070707000707070007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000707070007070700070707000707070007070700070707000707070007070
      7000707070007070700070707000000000000000000000000000B7A29300FFFF
      FF00B7A29300B7A29300B7A29300B7A29300B7A29300B7A29300B7A29300B7A2
      9300634935000000000000000000000000000000000000000000000000000000
      0000000000007070700070707000707070007070700070707000707070007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000000000007070700070707000707070007070700070707000707070007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000000000007070700070707000707070007070700070707000707070007070
      7000707070007070700070707000000000000000000000000000B7A29300FFFF
      FF00FFFFFF00FCFAF900F7F1EE00F1E7E100ECDDD500E6D3C900E1CABD00B7A2
      9300634935000000000000000000000000000000000000000000000000000000
      000000000000000000007070700070707000FEFEFE00FAF7F500F5EDE900EFE3
      DC00EAD9D1007070700070707000000000000000000000000000000000000000
      000000000000000000007070700070707000FEFEFE00FAF7F500F5EDE900EFE3
      DC00EAD9D1007070700070707000000000000000000000000000000000000000
      000000000000000000007070700070707000FEFEFE00FAF7F500F5EDE900EFE3
      DC00EAD9D1007070700070707000000000000000000000000000B7A29300FFFF
      FF00FFFFFF00F5F5F500F1EEEC00ECE4E000E6DBD400E1D1C900E4CFC400B7A2
      9300634935000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007070700070707000FDFCFB00F8F3F000F2E9
      E300EDDFD8007070700070707000000000000000000070707000707070007070
      7000707070007070700070707000707070007070700070707000707070007070
      7000EDDFD8007070700070707000000000000000000000000000000000000000
      00000000000000000000000000007070700070707000FDFCFB00F8F3F000F2E9
      E300EDDFD8007070700070707000000000000000000000000000B7A29300FFFF
      FF00C1C1C100ACACAC00ABAAA900A7A4A200A39D9900A0969200B4A69F00B7A2
      9300634935000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007070700070707000FBF8F700F6EF
      EB00F0E5DF007070700070707000000000000000000000000000707070007070
      7000707070007070700070707000707070007070700070707000707070007070
      7000F0E5DF007070700070707000000000000000000000000000000000000000
      0000000000000000000000000000000000007070700070707000FBF8F700F6EF
      EB00F0E5DF007070700070707000000000000000000000000000BAA59600FFFF
      FF00B6B6B600ECECEC00FFFFFF00FBF8F700EEE7E4009C959100E8D8D000B7A2
      9300634935000000000000000000000000000000000000000000000000000000
      0000088A450008623200095B2E0000000000000000007070700070707000F9F5
      F200F4EBE6007070700070707000000000000000000000000000000000007070
      700070707000FEFEFE00FAF7F500F5EDE900EFE3DC00EAD9D100707070007070
      7000F4EBE60070707000707070000000000000000000000000005656FF000A0A
      FF00000000000000000000000000000000007D7DFF009F9FFF0070707000F9F5
      F200F4EBE6007070700070707000000000000000000000000000BEA99A00FFFF
      FF00B6B6B600ECECEC00FFFFFF00F8F7F600ACAAA700E7DEDA00EEE1DA00B7A2
      9300634935000000000000000000000000000000000000000000000000000000
      00000CA650000BB05600074D2600000000000000000000000000707070007070
      7000F7F1EE007070700070707000000000000000000000000000000000000000
      00007070700070707000FDFCFB00F8F3F000F2E9E300EDDFD800707070007070
      7000F7F1EE0070707000707070000000000000000000000000006363FF000101
      75004C4CFF0000000000000000008484FF003333FF0000000000707070007070
      7000F7F1EE007070700070707000000000000000000000000000C3AE9E00FFFF
      FF00B6B6B600ECECEC00FCFCFC00B9B9B900CCCBCA00F7F1EE00F1E7E100B7A2
      9300634935000000000000000000000000000000000000000000000000000000
      00000EC15D0048E8A800075B2D00000000000000000000000000000000007070
      7000707070007070700070707000000000000000000000000000000000000000
      0000000000007070700070707000FBF8F700F6EFEB00F0E5DF00707070007070
      7000707070007070700070707000000000000000000000000000000000000101
      DD000101C3008383FF009797FF001616FF007070FF0000000000000000007070
      7000707070007070700070707000000000000000000000000000C8B2A300FFFF
      FF00B5B5B500EDEDED00C1C1C100CBCBCB00FEFEFE00FAF7F500F5EDE900B7A2
      930063493500000000000000000000000000000000000CD06A0016D66D001BD6
      670027DB78006AEFC00010AF5600096B360008562C0007512B00000000000000
      0000707070007070700070707000000000000000000000000000000000000000
      000000000000000000007070700070707000F9F5F200F4EBE600707070007070
      7000707070007070700070707000000000000000000000000000000000000000
      00000101EB000101F8000101F5002323FF000000000000000000000000000000
      0000707070007070700070707000000000000000000000000000CCB6A700FFFF
      FF00B0B0B000C7C7C700C7C7C700FFFFFF00FFFFFF00FDFCFB00B7A29300B7A2
      9300644A3600000000000000000000000000000000002DDB7F0082EDBC00C3FA
      EC00A0F6DA008DF6D70070F0C50058EBB3000FB35600085D2E00000000000000
      0000000000007070700070707000000000000000000000000000000000000000
      00000000000000000000000000007070700070707000F7F1EE00707070007070
      7000000000007070700070707000000000000000000000000000000000000000
      00007979FF000101BC000101BC007C7CFF000000000000000000000000000000
      0000000000007070700070707000000000000000000000000000D1BBAB00FFFF
      FF00B6B6B600C1C1C100FFFFFF00FFFFFF00FFFFFF00B7A29300644A3600644A
      3600644A3600000000000000000000000000000000004ADF950066E4A50069E8
      A70062EAA8009CF6DB0039E088000EC55C000AA44F00098F4700000000000000
      0000000000000000000070707000000000000000000000000000000000000000
      0000000000000000000000000000000000007070700070707000707070007070
      7000000000000000000070707000000000000000000000000000000000006868
      FF000000FF004747FF004F4FFF001515FF008787FF0000000000000000000000
      0000000000000000000070707000000000000000000000000000D5BFAF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B9A49500D4C5BA00644A
      3600E1D5CD000000000000000000000000000000000000000000000000000000
      000060E6A100C6FCEF003ADE8500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000070707000707070007070
      70000000000000000000000000000000000000000000000000004141FF000101
      D7005151FF0000000000000000006D6DFF003939FF006363FF00000000000000
      0000000000000000000000000000000000000000000000000000D8C2B200FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0AB9C00644A3600E2D6
      CD00000000000000000000000000000000000000000000000000000000000000
      000064E4A30089EDBF0032DD8400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000707070007070
      70000000000000000000000000000000000000000000000000002A2AFF006060
      FF00000000000000000000000000000000008787FF005656FF00000000000000
      0000000000000000000000000000000000000000000000000000D8C2B200D8C2
      B200D8C2B200D8C2B200D8C2B200D4BEAE00CFB9A900C9B3A400E2D6CD000000
      0000000000000000000000000000000000000000000000000000000000000000
      000052E099002FDB7F0017D77200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007070
      7000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000900000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFF0012AA9F001
      F01FF8017EFDF801F83FFC01FEFFFC01FEFFFE017EFD80018EE3FF01FEFFC001
      06C1FF817EFDE001FEFFFFC1FEFFF00176DDB3A10001F801FEFFBB71FEF3FC01
      AEEBBCF97EE5CE09FEFF84FDFECFCF0DDEF7B77F7E9D038FE00F87BFFE3F03CF
      FEFFFFFF7E7DCFEFFFFFFFFF2AA9CFFFFFFFFFFFFFFFFFFFF0010EE1FFFFFC00
      F8017C7DFC010000FC01783DFC010000FE017EFDFC010000FF01FEFF00010000
      FF81DEF700010001FFC19EF300010003B3A1000100010007BB719EF300010007
      BCF9DEF70003000784FDFEFF00070007BF7F7EFD007F000783BF783D00FF0007
      FFFF7C7D01FFF87FFFFF0EE1FFFFFFFFFFFFFEFFFFF7FFFFFEFFFEFFFEF7FEFF
      FFFFFEFFFFF7FFFFFEFFFABFFEF7FEFFFFFFFC7FFFD5FFFFFEFFEEFFFEE3FEFB
      FFFFF47FFFF7FFFDAA020002AA02AA00FEE7F467FEE7FEE5FECFEECFFECFFECB
      FE9FFE9FF69FFE9FFE3FFE3FFA3FFE3FFE7FFE7F007FFE7FFEFFFEFFFAFFFABF
      FFFFFFFFF7FFFC7FFEFFFEFFFEFFFEFFFFFFFFFFFFFFFFFF83FFFFFFFFFFAAAB
      8001FFFFFFFFFFFD8001FF83C1FFBFFF8001FF83C1FFFFFD83FBF383C1CFB80F
      C7F7E383C1C7FB9DC7EFC003C003BB3FC7DF8003C001FA7DC7BF8003C001B8FF
      C77F8003C001F9FDC6FFC003C003BBFFC5FFE3FFFFC7FFFDC3FFF3FFFFCFBFFF
      C7FFFFFFFFFFD555FFFFFFFFFFFFFFFFFF7FFFFFFFFFFFFFFF7FFFFFEDB7EFEF
      FF7FFFFFEDB7EFEFE00FF3E78001EFEFE007E1E7EDB70001FF63C0E7EDB7EFEF
      FF73F3E78001E02FFF73F3E7EDB7E02FFB730000EDB7602FF363F3E78001202F
      E007F3E7EDB7602FE00FF1C7EDB7E02FF37FF80F80010001FB7FFC1FEDB7EFEF
      FF7FFFFFEDB7EDEFFF7FFFFFFFFFE8EFFFFFFFFFFFFFFFFFFFFFC001FFFFFFFF
      F00FC001FFFFFF87E007C0018181FE07C003C0018181F807C003C001C181C007
      C3C380018181C007C3C3C001C183C007C2438001C183FFFFC0C3C001E187FFFF
      C0C38001E187C007C0C3C001F98FC007E0C78001F98FF007C0FFC001F99FF807
      FFFFAABFFFFFFE07FFFFFFFFFFFFFF87FFFFFFFFFFFFFFFFFFFFFFFFFF1FFEFF
      FF9FF9FFFE1FFC7FFF8FF1FFEE1FF83FFFC7E3FFE03FFEFFFFE3C7FFE03FFEFF
      FFE3C7FFE03FDEF7E0718E07E00F9EF3E0F18F07E01F0001E0718E07E03F9EF3
      E0218407E07FDEF7E0018007E0FFFEFFEC018037E1FFFEFFFE03C07FE3FFF83F
      FF87E1FFE7FFFC7FFFFFFFFFEFFFFEFFFFFFFFFFFFFFFFFFC007F001F001F001
      C007F801F801F801C007FC01FC01FC01C007FE018001FE01C007FF01C001FF01
      C007F181E001CF01C007F1C1F001C641C007F1E1F801E061C0078031FC01F0F1
      C0078039FE09F0F9C007803DFF0DE07DC007F1FFFF8FC63FC00FF1FFFFCFCF3F
      C01FF1FFFFEFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object TrianglePopup: TPopupMenu
    AutoPopup = False
    Images = EditorTB
    Left = 329
    Top = 129
    object mnuReset: TMenuItem
      Caption = 'Reset triangle'
      Hint = 'Reset triangle'
      ImageIndex = 20
      OnClick = mnuResetTriangleClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object mnuDuplicate: TMenuItem
      Caption = 'Duplicate'
      Hint = 'Duplicate selected triangle'
      ImageIndex = 2
      OnClick = mnuDupClick
    end
    object mnuDelete: TMenuItem
      Caption = 'Delete'
      Hint = 'Delete selected triangle'
      ImageIndex = 3
      OnClick = mnuDeleteClick
    end
    object mnuAdd1: TMenuItem
      Caption = 'Add'
      Hint = 'Add new triangle'
      ImageIndex = 1
      OnClick = mnuAddClick
    end
    object N21: TMenuItem
      Caption = '-'
    end
    object mnuCopyTriangle: TMenuItem
      Caption = 'Copy triangle coordinates'
      ImageIndex = 26
      OnClick = btnCopyTriangleClick
    end
    object mnuPasteTriangle: TMenuItem
      Caption = 'Paste triangle coordinates'
      ImageIndex = 27
      OnClick = btnPasteTriangleClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Rotatetriangle90CCW1: TMenuItem
      Caption = 'Rotate triangle 90'#176' CCW'
      ImageIndex = 17
      OnClick = btTrgRotateLeft90Click
    end
    object Rotatetriangle90CCW2: TMenuItem
      Caption = 'Rotate triangle 90'#176' CW'
      ImageIndex = 18
      OnClick = btTrgRotateRight90Click
    end
    object mnuFlipHorizontal: TMenuItem
      Caption = 'Flip Horizontal'
      Hint = 'Flip triangle horizontal'
      ImageIndex = 10
      OnClick = mnuFlipHorizontalClick
    end
    object mnuFlipVertical: TMenuItem
      Caption = 'Flip Vertical'
      Hint = 'Flip triangle vertical'
      ImageIndex = 11
      OnClick = mnuFlipVerticalClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object mnuResetTrgPosition: TMenuItem
      Caption = 'Reset position'
      ImageIndex = 21
      OnClick = btnOcoefsClick
    end
    object mnuResetTrgRotation: TMenuItem
      Caption = 'Reset rotation'
      ImageIndex = 22
      OnClick = mnuResetTrgRotationClick
    end
    object mnuResetTrgScale: TMenuItem
      Caption = 'Reset scale'
      ImageIndex = 23
      OnClick = mnuResetTrgScaleClick
    end
  end
  object ChaosPopup: TPopupMenu
    Left = 353
    Top = 241
    object mnuChaosViewTo: TMenuItem
      Caption = 'View as "&to"'
      Checked = True
      RadioItem = True
      OnClick = mnuChaosViewToClick
    end
    object mnuChaosViewFrom: TMenuItem
      Caption = 'View as "&from"'
      RadioItem = True
      OnClick = mnuChaosViewFromClick
    end
    object mnuChaosRebuild: TMenuItem
      Caption = 'Rebuild xaos links'
      Checked = True
      Hint = 'Rebuild xaos links when deleting transforms'
      Visible = False
      OnClick = mnuChaosRebuildClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object mnuChaosClearAll: TMenuItem
      Caption = '&Clear all'
      OnClick = mnuChaosClearAllClick
    end
    object mnuChaosSetAll: TMenuItem
      Caption = '&Set all'
      OnClick = mnuChaosSetAllClick
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object mnuLinkPostxform: TMenuItem
      Caption = 'Add linked xform'
      OnClick = mnuLinkPostxformClick
    end
  end
end
