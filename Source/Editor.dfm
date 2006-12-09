object EditForm: TEditForm
  Left = 380
  Top = 304
  Width = 582
  Height = 575
  Caption = 'Transform Editor'
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 200
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Icon.Data = {
    0000010001001010000000000000680300001600000028000000100000002000
    0000010018000000000040030000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
    FFFF00FFFF00FFFF00000000000000000000000000000000000000FFFF000000
    00000000000000000000000000000000000000000000FFFF0000000000000000
    0000000000000000000000000000FFFF00000000000000000000000000000000
    000000000000FFFF0000000000000000000000000000000000FF0000FF0000FF
    00FFFF0000FF0000FF0000FF0000FF0000FF00000000FFFF0000000000000000
    000000000000000000FF00000000000000000000FFFF0000000000000000FF00
    000000000000FFFF0000000000000000000000000000000000FF000000000000
    00000000000000FFFF0000FF00000000000000000000FFFF0000000000000000
    000000000000000000FF0000000000000000000000000000FF00FFFF00000000
    000000000000FFFF0000000000000000000000000000000000FF000000000000
    0000000000FF00000000000000FFFF00000000000000FFFF0000000000000000
    000000000000000000FF0000000000000000FF00000000000000000000000000
    FFFF00000000FFFF0000000000000000000000000000000000FF0000000000FF
    00000000000000000000000000000000000000FFFF00FFFF0000000000000000
    000000000000000000FF0000FF00000000000000000000000000000000000000
    000000000000FFFF0000000000000000000000000000000000FF000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    0000800100008001000080010000800100008001000080010000800100008001
    0000800100008001000080010000800100008001000080010000FFFF0000}
  KeyPreview = True
  OldCreateOrder = True
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
    Top = 532
    Width = 574
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
    Width = 574
    Height = 24
    Align = alTop
    BevelOuter = bvSpace
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    object EditorToolBar: TToolBar
      Left = 1
      Top = 1
      Width = 560
      Height = 22
      Align = alLeft
      ButtonWidth = 25
      Caption = 'EditorToolBar'
      Color = clBtnFace
      EdgeBorders = []
      Flat = True
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
        Left = 25
        Top = 0
        Hint = 'Adds a new triangle'
        Caption = 'Add'
        ImageIndex = 1
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuAddClick
      end
      object tbDuplicate: TToolButton
        Left = 50
        Top = 0
        Hint = 'Duplicates the selected triangle'
        Caption = 'Duplicate'
        ImageIndex = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuDupClick
      end
      object tbDelete: TToolButton
        Left = 75
        Top = 0
        Hint = 'Deletes the selected triangle'
        Caption = 'Delete'
        ImageIndex = 3
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuDeleteClick
      end
      object ToolButton4: TToolButton
        Left = 100
        Top = 0
        Width = 8
        Caption = 'ToolButton4'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object tbUndo: TToolButton
        Left = 108
        Top = 0
        Hint = 'Undo (Ctrl+Z)'
        Caption = 'Undo'
        ImageIndex = 4
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuUndoClick
      end
      object tbRedo: TToolButton
        Left = 133
        Top = 0
        Hint = 'Redo (Ctrl+Y)'
        Caption = 'Redo'
        ImageIndex = 5
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuRedoClick
      end
      object ToolButton1: TToolButton
        Left = 158
        Top = 0
        Width = 8
        Caption = 'ToolButton1'
        ImageIndex = 5
        Style = tbsSeparator
      end
      object tbSelect: TToolButton
        Left = 166
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
        Left = 191
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
        Left = 216
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
        Left = 241
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
      object ToolButton6: TToolButton
        Left = 266
        Top = 0
        Width = 8
        Caption = 'ToolButton6'
        ImageIndex = 16
        Style = tbsSeparator
      end
      object tbPivotMode: TToolButton
        Left = 274
        Top = 0
        Hint = 'Toggle world pivot mode'
        Caption = 'tbPivotMode'
        ImageIndex = 15
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = btnPivotModeClick
      end
      object ToolButton5: TToolButton
        Left = 299
        Top = 0
        Width = 8
        Caption = 'ToolButton5'
        ImageIndex = 7
        Style = tbsSeparator
        Visible = False
      end
      object tbRotate90CCW: TToolButton
        Left = 307
        Top = 0
        Hint = 'Rotate triangle 90'#176' counter-clockwise'
        Caption = 'tbRotate90CCW'
        ImageIndex = 17
        ParentShowHint = False
        ShowHint = True
        OnClick = btTrgRotateLeft90Click
      end
      object tbRotate90CW: TToolButton
        Left = 332
        Top = 0
        Hint = 'Rotate triangle 90'#176' clockwise'
        Caption = 'tbRotate90CW'
        ImageIndex = 18
        ParentShowHint = False
        ShowHint = True
        OnClick = btTrgRotateRight90Click
      end
      object tbFlipHorz: TToolButton
        Left = 357
        Top = 0
        Hint = 'Flip triangle horizontal'
        Caption = 'Flip Horizontal'
        ImageIndex = 10
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuFlipHorizontalClick
      end
      object tbFlipVert: TToolButton
        Left = 382
        Top = 0
        Hint = 'Flip triangle vertical'
        Caption = 'Flip Vertical'
        ImageIndex = 11
        ParentShowHint = False
        ShowHint = True
        OnClick = mnuFlipVerticalClick
      end
      object ToolButton2: TToolButton
        Left = 407
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 14
        Style = tbsSeparator
      end
      object tbVarPreview: TToolButton
        Left = 415
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
        Left = 440
        Top = 0
        Width = 8
        Caption = 'ToolButton3'
        ImageIndex = 16
        Style = tbsSeparator
      end
      object tbPostXswap: TToolButton
        Left = 448
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
        Left = 473
        Top = 0
        Hint = 'Enable final transform'
        Caption = 'Show Final Xform'
        ImageIndex = 24
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbEnableFinalXformClick
      end
    end
  end
  object EditPnl: TPanel
    Left = 0
    Top = 24
    Width = 574
    Height = 508
    Align = alClient
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 392
      Top = 1
      Width = 9
      Height = 506
      Align = alRight
      AutoSnap = False
      Beveled = True
      MinSize = 172
      OnMoved = splitterMoved
    end
    object GrphPnl: TPanel
      Left = 1
      Top = 1
      Width = 391
      Height = 506
      Align = alClient
      BevelOuter = bvNone
      Color = clAppWorkSpace
      TabOrder = 0
    end
    object RightPanel: TPanel
      Left = 401
      Top = 1
      Width = 172
      Height = 506
      Align = alRight
      Alignment = taLeftJustify
      BevelOuter = bvNone
      TabOrder = 1
      object Splitter2: TSplitter
        Left = 0
        Top = 130
        Width = 172
        Height = 8
        Cursor = crVSplit
        Align = alTop
        AutoSnap = False
        Beveled = True
        MinSize = 130
        OnMoved = splitterMoved
      end
      object PrevPnl: TPanel
        Left = 0
        Top = 0
        Width = 172
        Height = 130
        Align = alTop
        BevelOuter = bvLowered
        Color = clAppWorkSpace
        TabOrder = 1
        object PreviewImage: TImage
          Left = 1
          Top = 1
          Width = 170
          Height = 130
          Center = True
          PopupMenu = QualityPopup
          Proportional = True
        end
      end
      object ControlPanel: TPanel
        Left = 0
        Top = 138
        Width = 172
        Height = 368
        Align = alClient
        TabOrder = 0
        object lblTransform: TLabel
          Left = 28
          Top = 10
          Width = 59
          Height = 13
          Caption = 'Transform'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object cbTransforms: TComboBox
          Left = 92
          Top = 8
          Width = 57
          Height = 19
          Style = csOwnerDrawFixed
          Color = clBlack
          DropDownCount = 12
          ItemHeight = 13
          TabOrder = 0
          OnChange = cbTransformsChange
          OnDrawItem = cbTransformsDrawItem
        end
        object PageControl: TPageControl
          Left = 1
          Top = 36
          Width = 170
          Height = 331
          ActivePage = TriangleTab
          Align = alBottom
          Anchors = [akLeft, akTop, akRight, akBottom]
          MultiLine = True
          TabOrder = 1
          TabStop = False
          object TriangleTab: TTabSheet
            Caption = 'Triangle'
            object TriangleScrollBox: TScrollBox
              Left = 0
              Top = 0
              Width = 162
              Height = 285
              HorzScrollBar.Visible = False
              VertScrollBar.Smooth = True
              VertScrollBar.Style = ssFlat
              VertScrollBar.Tracking = True
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              TabOrder = 0
              object TrianglePanel: TPanel
                Left = 0
                Top = 0
                Width = 162
                Height = 281
                BevelOuter = bvNone
                TabOrder = 0
                object LabelB: TLabel
                  Left = 4
                  Top = 56
                  Width = 12
                  Height = 13
                  Caption = 'O:'
                end
                object LabelA: TLabel
                  Left = 4
                  Top = 8
                  Width = 10
                  Height = 13
                  Caption = 'X:'
                end
                object LabelC: TLabel
                  Left = 4
                  Top = 32
                  Width = 10
                  Height = 13
                  Caption = 'Y:'
                end
                object btTrgRotateRight: TSpeedButton
                  Left = 106
                  Top = 78
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
                object btTrgRotateLeft: TSpeedButton
                  Left = 32
                  Top = 78
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
                object btTrgMoveUp: TSpeedButton
                  Left = 8
                  Top = 106
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
                object btTrgMoveRight: TSpeedButton
                  Left = 130
                  Top = 106
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
                object btTrgMoveLeft: TSpeedButton
                  Left = 106
                  Top = 106
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
                object btTrgMoveDown: TSpeedButton
                  Left = 32
                  Top = 106
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
                object btTrgScaleUp: TSpeedButton
                  Left = 106
                  Top = 134
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
                object btTrgScaleDown: TSpeedButton
                  Left = 32
                  Top = 134
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
                object btTrgRotateRight90: TSpeedButton
                  Left = 130
                  Top = 78
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
                object btTrgRotateLeft90: TSpeedButton
                  Left = 8
                  Top = 78
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
                object txtCy: TEdit
                  Left = 88
                  Top = 28
                  Width = 65
                  Height = 21
                  AutoSelect = False
                  TabOrder = 3
                  Text = '0'
                  OnExit = CornerEditExit
                  OnKeyPress = CornerEditKeyPress
                end
                object txtCx: TEdit
                  Left = 20
                  Top = 28
                  Width = 65
                  Height = 21
                  AutoSelect = False
                  TabOrder = 2
                  Text = '0'
                  OnExit = CornerEditExit
                  OnKeyPress = CornerEditKeyPress
                end
                object txtBy: TEdit
                  Left = 88
                  Top = 52
                  Width = 65
                  Height = 21
                  AutoSelect = False
                  TabOrder = 5
                  Text = '0'
                  OnExit = CornerEditExit
                  OnKeyPress = CornerEditKeyPress
                end
                object txtBx: TEdit
                  Left = 20
                  Top = 52
                  Width = 65
                  Height = 21
                  AutoSelect = False
                  TabOrder = 4
                  Text = '0'
                  OnExit = CornerEditExit
                  OnKeyPress = CornerEditKeyPress
                end
                object txtAy: TEdit
                  Left = 88
                  Top = 4
                  Width = 65
                  Height = 21
                  AutoSelect = False
                  TabOrder = 1
                  Text = '0'
                  OnExit = CornerEditExit
                  OnKeyPress = CornerEditKeyPress
                end
                object txtAx: TEdit
                  Left = 20
                  Top = 4
                  Width = 65
                  Height = 21
                  AutoSelect = False
                  TabOrder = 0
                  Text = '0'
                  OnExit = CornerEditExit
                  OnKeyPress = CornerEditKeyPress
                end
                object txtTrgMoveValue: TComboBox
                  Left = 56
                  Top = 108
                  Width = 49
                  Height = 21
                  AutoComplete = False
                  ItemHeight = 13
                  ItemIndex = 3
                  TabOrder = 7
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
                object txtTrgRotateValue: TComboBox
                  Left = 56
                  Top = 80
                  Width = 49
                  Height = 21
                  AutoComplete = False
                  ItemHeight = 13
                  TabOrder = 6
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
                object txtTrgScaleValue: TComboBox
                  Left = 56
                  Top = 136
                  Width = 49
                  Height = 21
                  AutoComplete = False
                  ItemHeight = 13
                  ItemIndex = 1
                  TabOrder = 8
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
                object ToolBar1: TToolBar
                  Left = 9
                  Top = 162
                  Width = 145
                  Height = 28
                  Align = alNone
                  ButtonWidth = 24
                  Caption = 'ToolBar1'
                  EdgeInner = esNone
                  EdgeOuter = esNone
                  Flat = True
                  Images = EditorTB
                  TabOrder = 9
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
              end
              object GroupBox3: TGroupBox
                Left = 8
                Top = 188
                Width = 146
                Height = 65
                Caption = 'Pivot Point'
                TabOrder = 1
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
                  Left = 122
                  Top = 40
                  Width = 17
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
                  Width = 97
                  Height = 17
                  Hint = 'Toggle pivot point mode'
                  Caption = 'Local Pivot'
                  ParentShowHint = False
                  ShowHint = True
                  OnClick = btnPivotModeClick
                end
                object editPivotY: TEdit
                  Left = 74
                  Top = 16
                  Width = 65
                  Height = 21
                  Hint = 'Pivot point coordinates in chosen coordinate system'
                  AutoSelect = False
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
                  Width = 65
                  Height = 21
                  Hint = 'Pivot point coordinates in chosen coordinate system'
                  AutoSelect = False
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
          object tabXForm: TTabSheet
            Caption = 'Transform'
            object bvlPostCoefs: TBevel
              Left = 4
              Top = 152
              Width = 154
              Height = 103
              Shape = bsFrame
            end
            object bvlCoefs: TBevel
              Left = 4
              Top = 2
              Width = 154
              Height = 103
              Shape = bsFrame
            end
            object btnResetCoefs: TSpeedButton
              Left = 8
              Top = 78
              Width = 145
              Height = 22
              Hint = 'Reset all vectors to default position'
              Caption = 'Reset transform'
              ParentShowHint = False
              ShowHint = True
              OnClick = btnResetCoefsClick
            end
            object btnXcoefs: TSpeedButton
              Left = 8
              Top = 6
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
              Top = 30
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
              Top = 54
              Width = 25
              Height = 21
              Hint = 'Reset vector O'
              Caption = 'O'
              ParentShowHint = False
              ShowHint = True
              OnClick = btnOcoefsClick
            end
            object btnCoefsRect: TSpeedButton
              Left = 8
              Top = 107
              Width = 71
              Height = 17
              Hint = 'Show vectors in rectangular (cartesian) coordinates'
              GroupIndex = 1
              Down = True
              Caption = 'Rectangular'
              ParentShowHint = False
              ShowHint = True
              OnClick = btnCoefsModeClick
            end
            object btnCoefsPolar: TSpeedButton
              Left = 82
              Top = 107
              Width = 71
              Height = 17
              Hint = 'Show vectors in polar coordinates'
              GroupIndex = 1
              Caption = 'Polar (deg)'
              ParentShowHint = False
              ShowHint = True
              OnClick = btnCoefsModeClick
            end
            object btnXpost: TSpeedButton
              Left = 8
              Top = 180
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
              Top = 204
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
              Top = 228
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
              Top = 156
              Width = 145
              Height = 22
              Hint = 'Reset post-transform vectors to defaults'
              Caption = 'Reset post-transform'
              ParentShowHint = False
              ShowHint = True
              OnClick = btnResetPostCoefsClick
            end
            object pnlWeight: TPanel
              Left = 8
              Top = 128
              Width = 88
              Height = 21
              Cursor = crHandPoint
              Hint = 'Click and drag to change value'
              Alignment = taLeftJustify
              BevelOuter = bvLowered
              Caption = ' Weight:'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 13
              OnDblClick = DragPanelDblClick
              OnMouseDown = DragPanelMouseDown
              OnMouseMove = DragPanelMouseMove
              OnMouseUp = DragPanelMouseUp
            end
            object txtA: TEdit
              Left = 36
              Top = 6
              Width = 57
              Height = 21
              TabOrder = 0
              Text = '0'
              OnExit = CoefValidate
              OnKeyPress = CoefKeyPress
            end
            object txtB: TEdit
              Left = 96
              Top = 6
              Width = 57
              Height = 21
              TabOrder = 1
              Text = '0'
              OnExit = CoefValidate
              OnKeyPress = CoefKeyPress
            end
            object txtC: TEdit
              Left = 36
              Top = 30
              Width = 57
              Height = 21
              TabOrder = 2
              Text = '0'
              OnExit = CoefValidate
              OnKeyPress = CoefKeyPress
            end
            object txtD: TEdit
              Left = 96
              Top = 30
              Width = 57
              Height = 21
              TabOrder = 3
              Text = '0'
              OnExit = CoefValidate
              OnKeyPress = CoefKeyPress
            end
            object txtE: TEdit
              Left = 36
              Top = 54
              Width = 57
              Height = 21
              TabOrder = 4
              Text = '0'
              OnExit = CoefValidate
              OnKeyPress = CoefKeyPress
            end
            object txtF: TEdit
              Left = 96
              Top = 54
              Width = 57
              Height = 21
              TabOrder = 5
              Text = '0'
              OnExit = CoefValidate
              OnKeyPress = CoefKeyPress
            end
            object txtP: TEdit
              Left = 96
              Top = 128
              Width = 57
              Height = 21
              Hint = '"Weight" is the probability of this transform to be applied'
              TabOrder = 6
              Text = '0'
              OnExit = txtPExit
              OnKeyPress = txtPKeyPress
            end
            object txtPost00: TEdit
              Left = 36
              Top = 180
              Width = 57
              Height = 21
              TabOrder = 7
              Text = '0'
              OnExit = PostCoefValidate
              OnKeyPress = PostCoefKeypress
            end
            object txtPost01: TEdit
              Left = 96
              Top = 180
              Width = 57
              Height = 21
              TabOrder = 8
              Text = '0'
              OnExit = PostCoefValidate
              OnKeyPress = PostCoefKeypress
            end
            object txtPost10: TEdit
              Left = 36
              Top = 204
              Width = 57
              Height = 21
              TabOrder = 9
              Text = '0'
              OnExit = PostCoefValidate
              OnKeyPress = PostCoefKeypress
            end
            object txtPost11: TEdit
              Left = 96
              Top = 204
              Width = 57
              Height = 21
              TabOrder = 10
              Text = '0'
              OnExit = PostCoefValidate
              OnKeyPress = PostCoefKeypress
            end
            object txtPost20: TEdit
              Left = 36
              Top = 228
              Width = 57
              Height = 21
              TabOrder = 11
              Text = '0'
              OnExit = PostCoefValidate
              OnKeyPress = PostCoefKeypress
            end
            object txtPost21: TEdit
              Left = 96
              Top = 228
              Width = 57
              Height = 21
              TabOrder = 12
              Text = '0'
              OnExit = PostCoefValidate
              OnKeyPress = PostCoefKeypress
            end
            object chkPreserve: TCheckBox
              Left = 8
              Top = 257
              Width = 145
              Height = 17
              Hint = 
                'Keep this checked if you don'#39't want all weights to be recalculat' +
                'ed to screw up all your flame :-)'
              Alignment = taLeftJustify
              Caption = 'Preserve weights'
              Checked = True
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 14
              Visible = False
            end
          end
          object tabVariations: TTabSheet
            Caption = 'Variations'
            object VEVars: TValueListEditor
              Left = 0
              Top = 0
              Width = 162
              Height = 287
              Align = alClient
              ScrollBars = ssVertical
              TabOrder = 0
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
                93
                63)
            end
          end
          object TabSheet4: TTabSheet
            Caption = 'Variables'
            ImageIndex = 4
            object vleVariables: TValueListEditor
              Left = 0
              Top = 0
              Width = 162
              Height = 287
              Align = alClient
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
                63)
            end
          end
          object tabColors: TTabSheet
            Caption = 'Colors'
            ImageIndex = 3
            object GroupBox1: TGroupBox
              Left = 8
              Top = 2
              Width = 145
              Height = 95
              Caption = 'Transform color'
              TabOrder = 0
              object pnlSymmetry: TPanel
                Left = 8
                Top = 62
                Width = 73
                Height = 21
                Cursor = crHandPoint
                Hint = 'Click and drag to change value'
                Alignment = taLeftJustify
                BevelOuter = bvLowered
                Caption = ' Symmetry:'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 3
                OnDblClick = DragPanelDblClick
                OnMouseDown = DragPanelMouseDown
                OnMouseMove = DragPanelMouseMove
                OnMouseUp = DragPanelMouseUp
              end
              object scrlXFormColor: TScrollBar
                Left = 9
                Top = 38
                Width = 128
                Height = 15
                LargeChange = 10
                Max = 1000
                PageSize = 0
                TabOrder = 0
                OnChange = scrlXFormColorChange
                OnScroll = scrlXFormColorScroll
              end
              object pnlXFormColor: TPanel
                Left = 8
                Top = 16
                Width = 73
                Height = 21
                Cursor = crHandPoint
                Hint = 'Click and drag to change value'
                BevelOuter = bvLowered
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                OnDblClick = DragPanelDblClick
                OnMouseDown = DragPanelMouseDown
                OnMouseMove = DragPanelMouseMove
                OnMouseUp = DragPanelMouseUp
              end
              object txtXFormColor: TEdit
                Left = 80
                Top = 16
                Width = 57
                Height = 21
                TabOrder = 2
                OnExit = txtXFormColorExit
                OnKeyPress = txtXFormColorKeyPress
              end
              object txtSymmetry: TEdit
                Left = 80
                Top = 62
                Width = 57
                Height = 21
                TabOrder = 4
                Text = '0'
                OnExit = txtSymmetrySet
                OnKeyPress = txtSymmetrKeyPress
              end
            end
            object GroupBox2: TGroupBox
              Left = 8
              Top = 100
              Width = 145
              Height = 77
              Caption = 'Variation preview'
              TabOrder = 1
              object trkVarPreviewDensity: TTrackBar
                Left = 8
                Top = 48
                Width = 65
                Height = 25
                Max = 5
                Min = 1
                ParentShowHint = False
                PageSize = 1
                Position = 2
                ShowHint = True
                TabOrder = 0
                TabStop = False
                ThumbLength = 15
                OnChange = trkVarPreviewDensityChange
              end
              object trkVarPreviewRange: TTrackBar
                Left = 8
                Top = 16
                Width = 129
                Height = 25
                Min = 1
                ParentShowHint = False
                PageSize = 1
                Position = 2
                ShowHint = True
                TabOrder = 1
                TabStop = False
                ThumbLength = 15
                OnChange = trkVarPreviewRangeChange
              end
              object trkVarPreviewDepth: TTrackBar
                Left = 72
                Top = 48
                Width = 65
                Height = 25
                Max = 5
                Min = 1
                ParentShowHint = False
                PageSize = 1
                Position = 1
                ShowHint = True
                TabOrder = 2
                TabStop = False
                ThumbLength = 15
                OnChange = trkVarPreviewDepthChange
              end
            end
          end
        end
      end
    end
  end
  object EditPopup: TPopupMenu
    Images = EditorTB
    Left = 352
    Top = 40
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
    object mnuVerticalFlipAll: TMenuItem
      Caption = 'Flip All Vertical '
      Hint = 'Flip all triangles vertical'
      ImageIndex = 13
      OnClick = mnuVerticalFlipAllClick
    end
    object mnuHorizintalFlipAll: TMenuItem
      Caption = 'Flip All Horizontal'
      Hint = 'Flip all triangles horizontal'
      ImageIndex = 12
      OnClick = mnuHorizintalFlipAllClick
    end
  end
  object QualityPopup: TPopupMenu
    Images = MainForm.Buttons
    Left = 424
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
      494C01011F002200040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF0000000000000000000000000000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF00000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005C5C5C0000000000000000000000
      00005C5C5C0000000000000000000000000000000000000000005C5C5C000000
      000000000000000000005C5C5C00000000000000000000000000000000000000
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
      0000A1A1A1000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005C5C5C00000000005C5C
      5C00000000000000000000000000000000000000000000000000000000005C5C
      5C00000000005C5C5C0000000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A1A1
      A100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A1A1A1000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005C5C5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005C5C5C000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000000000008000000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A1A1A100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A1A1A10000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000F8F2F000F8F2F000F8F2F000F8F2F000F8F2
      F000F8F2F000F8F2F00080000000000000000000000000000000000000000000
      0000000000000000000080000000F8F2F000F8F2F000F8F2F000F8F2F000F8F2
      F000F8F2F000F8F2F00080000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000F8F2F0000000000000000000000000000000
      000000000000F8F2F00080000000000000000000000000000000000000000000
      0000000000000000000080000000F8F2F0000000000000000000000000000000
      000000000000F8F2F00080000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000040606000000000004060600000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000F8F2F00000000000F8F2F000F8F2F0000000
      0000F8F2F000F8F2F00080000000000000000000000020404000204040002040
      4000204040002040400080000000F8F2F00000000000F8F2F000F8F2F0000000
      0000F8F2F000F8F2F00080000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000F8F2F00000000000F8F2F00000000000F8F2
      F000F8F2F000F8F2F00080000000000000000000000020404000204040002040
      4000204040002040400080000000F8F2F00000000000F8F2F00000000000F8F2
      F000F8F2F000F8F2F00080000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000F8F2F0000000000000000000F8F2F000F8F2
      F000F8F2F000F8F2F00080000000000000000000000020404000204040002040
      4000204040002040400080000000F8F2F0000000000000000000F8F2F000F8F2
      F000F8F2F000F8F2F00080000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F8F2F000F8F2F000F8F2
      F000F8F2F000F8F2F00080000000F8F2F00000000000F8F2F000F8F2F0008000
      0000800000008000000080000000000000000000000020404000204040002040
      4000204040002040400080000000F8F2F00000000000F8F2F000F8F2F0008000
      0000800000008000000080000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000406060000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004060600000000000000000000000000000000000F8F2F000404040004040
      4000404040004040400080000000F8F2F000F8F2F000F8F2F000F8F2F0008000
      0000F8F2F0008000000000000000000000000000000020404000204040002040
      4000204040002040400080000000F8F2F000F8F2F000F8F2F000F8F2F0008000
      0000F8F2F0008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F8F2F00040404000F8F2
      F000F8F2F0004040400080000000F8F2F000F8F2F000F8F2F000F8F2F0008000
      0000800000000000000000000000000000000000000020404000204040002040
      4000204040002040400080000000F8F2F000F8F2F000F8F2F000F8F2F0008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000406060000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004060600000000000000000000000000000000000F8F2F00040404000F8F2
      F00040404000F8F2F00080000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000020404000204040002040
      4000204040002040400080000000800000008000000080000000800000008000
      0000204040000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008000000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F8F2F000404040004040
      4000F8F2F000F8F2F000F8F2F000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000020404000204040002040
      4000204040002040400020404000204040002040400020404000204040002040
      4000204040000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008000000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F8F2F00040404000F8F2
      F000F8F2F0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000020404000204040000000
      0000000000000000000000000000000000000000000000000000000000002040
      4000204040000000000000000000000000000000000000000000000000000000
      0000000000000080000000800000008000000080000000800000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F8F2F000F8F2F000F8F2
      F000F8F2F00000000000F8F2F000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000020404000204040000000
      0000000000000000000000000000000000000000000000000000000000002040
      4000204040000000000000000000000000000000000000000000000000000000
      0000000000000080000000800000008000000080000000800000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000040606000000000004060600000000000000000000000
      00000000000000000000000000000000000000000000F8F2F000F8F2F000F8F2
      F000F8F2F0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000020404000204040002040
      40000000000000FFFF00000000000000000000FFFF0000000000204040002040
      4000204040000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008000000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008000000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000600000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000600000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000600000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006000000000000000600000000000000060000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000060000000600000006000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000600000000000
      0000600000000000000060000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006000
      0000000000000000000000000000600000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006000
      0000600000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000000000000060000000600000006000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000060000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006000000060000000600000006000
      0000600000006000000060000000FFFFFF006000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000600000006000000060000000600000006000
      0000600000006000000060000000600000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005454
      5400000000000000000000000000000000000000000000000000000000000000
      0000600000000000000060000000600000006000000000000000000000005454
      5400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005454
      5400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000600000000000000000000000000000005454
      5400000000000000000060000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000545454000000
      0000000000000000000000000000000000000000000000000000000000006000
      0000000000000000000000000000000000000000000000000000545454000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000545454000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000600000000000000000000000545454000000
      0000000000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000054545400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000054545400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000000000000000000000000000000000000054545400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000600000000000000054545400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005454540000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005454540000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006000000000000000000000005454540000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000600000005454540000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006000000060000000600000006000
      0000600000006000000060000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000600000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006000000000000000600000000000000060000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000060000000600000006000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000600000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000060000000600000006000
      0000600000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000060000000FFFFFF00FFFF
      FF00FFFFFF006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006000
      0000600000006000000000000000000000000000000000000000600000006000
      0000600000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000060000000FFFFFF00FFFF
      FF00FFFFFF0060000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006000
      0000000000006000000000000000000000000000000000000000600000000000
      0000600000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000060000000FFFFFF00FFFF
      FF00FFFFFF006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006000
      0000000000006000000000000000000000000000000000000000600000000000
      0000600000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000060000000600000006000
      0000600000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006000
      0000000000006000000000000000000000000000000000000000600000000000
      0000600000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006000000000000000000000000000000000000000000000006000
      0000000000006000000000000000000000000000000000000000600000000000
      0000600000000000000000000000000000000000000000000000600000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000054545400000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000006000000000000000000000000000000000000000000000006000
      0000000000006000000000000000000000000000000000000000600000000000
      0000600000000000000000000000000000000000000000000000600000006000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005454540000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006000
      0000000000006000000000000000000000000000000000000000000000006000
      0000000000006000000000000000000000000000000000000000600000000000
      0000600000000000000000000000000000000000000000000000600000000000
      0000600000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000545454000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000600000000000
      0000000000006000000060000000600000006000000060000000600000006000
      0000000000006000000000000000000000000000000000000000600000000000
      0000600000006000000060000000600000006000000060000000600000000000
      0000000000006000000000000000000000000000000000000000000000000000
      0000000000000000000054545400000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000060000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006000000000000000000000000000000000000000600000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000060000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000600000000000
      0000000000006000000060000000600000006000000060000000600000006000
      0000600000006000000000000000000000000000000000000000600000006000
      0000600000006000000060000000600000006000000060000000600000000000
      0000000000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006000
      0000000000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000600000000000
      0000600000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000600000006000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000600000000000
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
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000049004B00000000000000000049004B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004900
      4B00000000000000000000000000000000000000000000000000000000000000
      000049004B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000049004B0000000000000000000000
      0000000000000000000049004B00000000000000000049004B00000000000000
      000000000000000000000000000049004B000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000049004B000000000000000000000000000000000000000000000000004900
      4B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000049004B000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000049004B0000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000049004B0000000000000000000000
      00000000000000000000EBEBEB00A0A0A000A0A0A000EBEBEB00000000000000
      000000000000000000000000000049004B000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EBEBEB00EBEBEB00EBEBEB000000000000000000EBEBEB00EBEBEB00EBEB
      EB0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000008000800080008000800080008000
      8000000000000000000080008000800080008000800080008000800080008000
      8000800080008000800080008000800080000000000000000000000000000000
      0000EBEBEB00EBEBEB00EBEBEB000000000000000000EBEBEB00EBEBEB00EBEB
      EB000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000049004B0000000000000000000000
      00000000000000000000EBEBEB00A0A0A000A0A0A000EBEBEB00000000000000
      000000000000000000000000000049004B000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000049004B000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000049004B0000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000049004B000000000000000000000000000000000000000000000000004900
      4B00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000FFFFFF00FFFFFF000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000049004B0000000000000000000000
      0000000000000000000049004B00000000000000000049004B00000000000000
      000000000000000000000000000049004B000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004900
      4B00000000000000000000000000000000000000000000000000000000000000
      000049004B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000049004B00000000000000000049004B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000800000000000000000000000
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
      0000000000000000000000000000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005C5C5C00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005C5C5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005C5C
      5C00000000000000000000000000000000000000000000000000000000005C5C
      5C00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005C5C5C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005C5C
      5C00000000005C5C5C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000000000000000000000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005C5C5C0000000000000000000000000000000000000000005C5C5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000006000000000000000000000005C5C5C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005C5C5C00000000005C5C5C00000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080606000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005C5C5C0000000000000000000000000000000000000000000000
      0000000000005C5C5C000000000000000000000000005C5C5C00000000000000
      0000000000000000000000000000000000000000000000000000000000006000
      000000000000000000000000000000000000000000005C5C5C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005C5C5C00000000005C5C5C000000000000000000000000000000
      0000000000000000000000000000000000008000000000000000806060008000
      0000000000000000000000000000800080000000000000000000000000000000
      00005C5C5C000000000000000000000000000000000000000000000000000000
      000000000000000000005C5C5C00000000005C5C5C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006000
      00000000000000000000000000000000000000000000000000005C5C5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005C5C5C00000000005C5C5C0000000000000000000000
      0000000000000000000000000000000000008000000000000000000000008060
      6000800000000000000000000000000000000000000000000000000000005C5C
      5C00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005C5C5C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000600000000000
      0000000000000000000000000000000000000000000000000000000000005C5C
      5C00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005C5C5C00000000005C5C5C00000000000000
      0000000000000000000000000000000000008000000000000000000000000000
      00008060600080000000000000008000800000000000000000005C5C5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000600000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005C5C5C00000000005C5C5C000000
      0000000000000000000000000000000000008000000000000000000000000000
      000000000000806060008000000000000000000000005C5C5C00000000000000
      0000000000000000000000000000000000008000800000000000800080000000
      0000800080000000000080008000000000008000800000000000800080000000
      0000800080000000000080008000000000000000000000000000600000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005C5C5C00000000005C5C
      5C00000000000000000000000000000000008000000000000000000000000000
      00008060600080000000000000008000800000000000000000005C5C5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000600000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005C5C5C000000
      00005C5C5C000000000000000000000000008000000000000000000000008060
      6000800000000000000000000000000000000000000000000000000000005C5C
      5C00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000806060008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006000
      0000000000000000000000000000000000000000000000000000600000006000
      0000600000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005C5C
      5C00000000000000000000000000000000008000000000000000806060008000
      0000000000000000000000000000800080000000000000000000000000000000
      00005C5C5C000000000000000000000000000000000000000000000000000000
      0000000000008000000080606000000000008060600080000000000000000000
      0000000000000000000000000000000000000000000000000000000000006000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005C5C5C000000000000000000000000008000000080606000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005C5C5C0000000000000000000000000000000000000000000000
      0000800000008060600000000000000000000000000080606000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000600000006000000000000000000000000000000000000000600000006000
      0000000000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005C5C5C0000000000000000008000000080000000000000000000
      0000000000000000000000000000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000806060000000000000000000000000000000000000000000806060008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000060000000600000006000000060000000000000000000
      0000000000006000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008060
      6000000000000000000000000000000000000000000000000000000000008060
      6000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800080000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005C5C5C00000000005C5C5C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000000000005C5C5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005C5C5C000000000000000000000000000000000000000000800000008000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000800000008000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000000000005C5C5C000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005C5C5C000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005C5C5C00000000005C5C5C0000000000000000000000
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
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000005C5C5C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005C5C5C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005C5C5C00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFDFB00FFFDFB00FFFDFB00FFFDFB00FFFDFB00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005C5C5C000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      00000000000000000000000000000000000000000000000000000000C0000000
      00000000000000000000000000005C5C5C0000000000000000000000C0000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFDFB008080800080808000808080008080800080808000808080008080
      8000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005C5C5C0000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000000000000000000000000000000000000000000000000C0000000C0000000
      C000000000000000000000000000000000005C5C5C000000C0000000C0000000
      C00000000000000000000000000000000000000000000000000000000000FFFD
      FB00FFFDFB0080808000FFFDFB00FFFDFB00FFFDFB00BFBFBF0080808000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000800000008000000000000000000000000000005C5C5C00000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      000080000000000000000000000000000000000000005C5C5C00800000008000
      00000000000000000000000000000000000000000000000000000000C0000000
      C0000000C0000000000000000000000000000000C0000000C0000000C0000000
      000000000000000000000000000000000000000000000000000000000000FFFD
      FB00FFFFFF0080808000FFFFFF00FFFFFF00BFBFBF0080808000FFFDFB00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      00000080000000800000000000000000000000000000000000005C5C5C000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000000000000000000000000000000000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      C0000000C0000000C000000000000000C0000000C0000000C0005C5C5C000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0080808000FFFFFF00BFBFBF0080808000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000000000000000005C5C
      5C00000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000000000000000000000000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000C0000000C0000000C0000000C0000000C00000000000000000005C5C
      5C0000000000000000000000000000000000000000000000000000000000FFFD
      FB00FFFFFF0080808000BFBFBF0080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000000000000000000000
      00005C5C5C000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000000000000000000000800000008000
      00005C5C5C000000000000000000000000000000000000000000000000000000
      0000000000000000C0000000C0000000C0000000000000000000000000000000
      00005C5C5C00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF008080800080808000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000080000000800000008000000080
      0000008000000080000000800000008000000080000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000000000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000C0000000C0000000C0000000C0000000C00000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0080808000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000080000000800000008000000080
      0000008000000080000000800000008000000080000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      C0000000C0000000C000000000000000C0000000C0000000C000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      00000000000000000000000000000000000000000000000000000000C0000000
      C0000000C0000000000000000000000000000000C0000000C0000000C0000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      000000000000000000000000000000000000000000000000C0000000C0000000
      C00000000000000000000000000000000000000000000000C0000000C0000000
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      00000000000000000000000000000000000000000000000000000000C0000000
      00000000000000000000000000000000000000000000000000000000C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000900000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF8F11FFFF0000FFFF8F112AA90000
      F01F8F117EFD0000F83F8383FEFF0000FEFF81C77EFD00008EE38183FEFF0000
      06C181117EFD0000FEFF8111FEFF000076DD831100010000FEFFFFFFFEF30000
      AEEBF81F7EE50000FEFFF81FFECF0000DEF7F93F7E9D0000E00FF87FFE3F0000
      FEFFF8FF7E7D0000FFFFF9FF2AA900008F11FFFFFC01FC018F110EE1FC01FC01
      8F117C7DFC0180018383783DFC01000183C77EFDFC0100018383FEFF00010001
      8111DEF70001000181119EF3000300038111000100070003FFFF9EF3000F0003
      FE7FDEF700FF0003FE7FFEFF00FF0003F81F7EFD00FF0FC3F81F783D01FF0003
      FE7F7C7D03FF8007FE7F0EE1FFFFF87FFFFFFEFFFFF7FFFFFEFFFEFFFEF7FEFF
      FFFFFEFFFFF7FFFFFEFFFABFFEF7FEFFFFFFFC7FFFD5FFFFFEFFEEFFFEE3FEFB
      FFFFF47FFFF7FFFDAA020002AA02AA00FEE7F467FEE7FEE5FECFEECFFECFFECB
      FE9FFE9FF69FFE9FFE3FFE3FFA3FFE3FFE7FFE7F007FFE7FFEFFFEFFFAFFFABF
      FFFFFFFFF7FFFC7FFEFFFEFFFEFFFEFFFFFFFFFFFFFFFFFF83FFFFFFFFFFAAAB
      8001FFE3C7FFFFFD8001FFE3C7FFBFFF8001FFE3C7FFFFFD83FBFFE3C7FFB80F
      C7F7FBE3C7DFFB9DC7EFF3E3C7CFBB3FC7DFE3E3C7C7FA7DC7BFC003C003B8FF
      C77F8003C001F9FDC6FFC003C003BBFFC5FFE3FFFFC7FFFDC3FFF3FFFFCFBFFF
      C7FFFBFFFFDFD555FFFFFFFFFFFFFFFFFF7FFFFFFFFFFFFFFF7FFFFFFDBFFEFF
      FF7FFFFFEFF7FC7FE00FF3E77DBEFC7FE007E1E7F7EFE82FFF63C0E7DC3BF01F
      FF73F3E7700EE00FFF73F3E7E0078003FB730000E0070001F363F3E7700E8003
      E007F3E7DC3BE00FE00FF1C7F7EFF01FF37FF80F7DBEE82FFB7FFC1FEFF7FC7F
      FF7FFFFFFDBFFC7FFF7FFFFFFFFFFEFFFFFFFFFFFFFFFFFFF0070001FEFF8003
      F9F79FFD7FFDCFE7FCF7C8053EF9E7CFF277E4F51FF1F39FEF37F2754EE5F93F
      EF97F93567CDFC7FDFC7FC95729DFEFFDFE7FE45793D5555DFF7FF25729DFEFF
      DFFFFF9567CDFC7FEFC3FFCD4EE5F93FEFF3FFE51FF1F39FF3CBFFF13EF9E7CF
      FC3BFFF97FFDCFE7FFFFFFFDFEFF8003FFFFFFFFFFCFFFFFFFFFFFFFFF87FEFF
      FFFFFFFFF787FC7FFFFFFFFFF30FF83FFFF7EFFFF00FFEFFC1F7EF83F01FFEFF
      C3FBDFC3F003DEF7C7FBDFE3F0079EF3CBFBDFD3F00F0001DCF7EF3BF01F9EF3
      FF0FF0FFF03FDEF7FFFFFFFFF07FFEFFFFFFFFFFF0FFFEFFFFFFFFFFF1FFF83F
      FFFFFFFFF3FFFC7FFFFFFFFFF7FFFEFFFFFFFFFFFFFFFFFFC003C001C001C001
      C003E001E001E001C003F1F9F1F9F1F9C003F8F90009D8D9C003FC7980098C09
      C003F239C609C619C003F319E309E219C003F389F189F009C003F3C1F8C1F8C1
      C0030021FC41F061C0070031FE01E231C00FF3F9FF09C719C01FF3FDFF8D8F8D
      C03FF3FFFFCFDFDFFFFFF3FFFFEFFFFF00000000000000000000000000000000
      000000000000}
  end
  object TrianglePopup: TPopupMenu
    AutoPopup = False
    Images = EditorTB
    Left = 353
    Top = 73
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
end
