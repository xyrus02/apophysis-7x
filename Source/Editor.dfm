object EditForm: TEditForm
  Left = 392
  Top = 208
  Width = 582
  Height = 471
  Caption = 'Editor'
  Color = clBtnFace
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
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GrphPnl: TPanel
    Left = 0
    Top = 0
    Width = 394
    Height = 422
    Align = alClient
    BevelOuter = bvLowered
    Color = clBlack
    TabOrder = 0
    object GraphImage: TImage
      Left = 1
      Top = 1
      Width = 392
      Height = 427
      Align = alClient
      PopupMenu = EditPopup
      OnDblClick = GraphImageDblClick
      OnMouseDown = GraphImageMouseDown
      OnMouseMove = GraphImageMouseMove
      OnMouseUp = GraphImageMouseUp
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 422
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
  object ControlPanel: TPanel
    Left = 394
    Top = 0
    Width = 180
    Height = 422
    Align = alRight
    Alignment = taLeftJustify
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      180
      422)
    object lblTransform: TLabel
      Left = 10
      Top = 128
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
    object PrevPnl: TPanel
      Left = 10
      Top = 0
      Width = 162
      Height = 122
      BevelOuter = bvLowered
      Caption = 'PrevPnl'
      Color = clBlack
      TabOrder = 0
      object PreviewImage: TImage
        Left = 1
        Top = 1
        Width = 160
        Height = 120
        Align = alClient
        IncrementalDisplay = True
        PopupMenu = QualityPopup
      end
    end
    object cbTransforms: TComboBox
      Left = 75
      Top = 125
      Width = 57
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 1
      OnChange = cbTransformsChange
    end
    object PageControl: TPageControl
      Left = 10
      Top = 148
      Width = 167
      Height = 277
      ActivePage = TabSheet1
      Anchors = [akLeft, akTop, akRight, akBottom]
      MultiLine = True
      TabOrder = 2
      TabStop = False
      object TabSheet1: TTabSheet
        Caption = 'Triangle'
        object TriangleScrollBox: TScrollBox
          Left = 0
          Top = 0
          Width = 159
          Height = 231
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
            Width = 155
            Height = 302
            BevelOuter = bvNone
            TabOrder = 0
            object Label9: TLabel
              Left = 6
              Top = 54
              Width = 16
              Height = 13
              Caption = 'Bx:'
            end
            object Label8: TLabel
              Left = 6
              Top = 30
              Width = 17
              Height = 13
              Caption = 'Ay:'
            end
            object Label7: TLabel
              Left = 6
              Top = 6
              Width = 17
              Height = 13
              Caption = 'Ax:'
            end
            object Label12: TLabel
              Left = 6
              Top = 126
              Width = 17
              Height = 13
              Caption = 'Cy:'
            end
            object Label11: TLabel
              Left = 6
              Top = 102
              Width = 17
              Height = 13
              Caption = 'Cx:'
            end
            object Label10: TLabel
              Left = 6
              Top = 78
              Width = 16
              Height = 13
              Caption = 'By:'
            end
            object btTrgRotateRight: TSpeedButton
              Left = 90
              Top = 184
              Width = 33
              Height = 24
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
              OnClick = btTrgRotateRightClick
            end
            object btTrgRotateLeft: TSpeedButton
              Left = 22
              Top = 184
              Width = 33
              Height = 24
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
              OnClick = btTrgRotateLeftClick
            end
            object btTrgMoveUp: TSpeedButton
              Left = 56
              Top = 226
              Width = 33
              Height = 24
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
              OnClick = btTrgMoveUpClick
            end
            object btTrgMoveRight: TSpeedButton
              Left = 90
              Top = 250
              Width = 33
              Height = 24
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
              OnClick = btTrgMoveRightClick
            end
            object btTrgMoveLeft: TSpeedButton
              Left = 22
              Top = 250
              Width = 33
              Height = 24
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
              OnClick = btTrgMoveLeftClick
            end
            object btTrgMoveDown: TSpeedButton
              Left = 56
              Top = 274
              Width = 33
              Height = 24
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
              OnClick = btTrgMoveDownClick
            end
            object txtTrgRotateValue: TEdit
              Left = 56
              Top = 184
              Width = 33
              Height = 24
              TabOrder = 7
              Text = '5'
            end
            object txtTrgMoveValue: TEdit
              Left = 56
              Top = 250
              Width = 33
              Height = 24
              TabOrder = 8
              Text = '0.05'
            end
            object txtCy: TEdit
              Left = 28
              Top = 122
              Width = 110
              Height = 21
              AutoSelect = False
              TabOrder = 5
              Text = '0'
              OnExit = CornerEditExit
              OnKeyPress = CornerEditKeyPress
            end
            object txtCx: TEdit
              Left = 28
              Top = 98
              Width = 110
              Height = 21
              AutoSelect = False
              TabOrder = 4
              Text = '0'
              OnExit = CornerEditExit
              OnKeyPress = CornerEditKeyPress
            end
            object txtBy: TEdit
              Left = 28
              Top = 74
              Width = 110
              Height = 21
              AutoSelect = False
              TabOrder = 3
              Text = '0'
              OnExit = CornerEditExit
              OnKeyPress = CornerEditKeyPress
            end
            object txtBx: TEdit
              Left = 28
              Top = 50
              Width = 110
              Height = 21
              AutoSelect = False
              TabOrder = 2
              Text = '0'
              OnExit = CornerEditExit
              OnKeyPress = CornerEditKeyPress
            end
            object txtAy: TEdit
              Left = 28
              Top = 26
              Width = 110
              Height = 21
              AutoSelect = False
              TabOrder = 1
              Text = '0'
              OnExit = CornerEditExit
              OnKeyPress = CornerEditKeyPress
            end
            object txtAx: TEdit
              Left = 28
              Top = 2
              Width = 110
              Height = 21
              AutoSelect = False
              TabOrder = 0
              Text = '0'
              OnExit = CornerEditExit
              OnKeyPress = CornerEditKeyPress
            end
            object chkPreserve: TCheckBox
              Left = 28
              Top = 152
              Width = 105
              Height = 17
              Caption = 'Preserve weights'
              Checked = True
              State = cbChecked
              TabOrder = 6
            end
          end
        end
      end
      object XForm: TTabSheet
        Caption = 'Transform'
        object lbla: TLabel
          Left = 9
          Top = 12
          Width = 10
          Height = 13
          Caption = 'a:'
        end
        object Label1: TLabel
          Left = 9
          Top = 36
          Width = 10
          Height = 13
          Caption = 'b:'
        end
        object Label2: TLabel
          Left = 9
          Top = 60
          Width = 9
          Height = 13
          Caption = 'c:'
        end
        object Label3: TLabel
          Left = 9
          Top = 84
          Width = 10
          Height = 13
          Caption = 'd:'
        end
        object Label4: TLabel
          Left = 9
          Top = 108
          Width = 10
          Height = 13
          Caption = 'e:'
        end
        object Label5: TLabel
          Left = 9
          Top = 132
          Width = 8
          Height = 13
          Caption = 'f:'
        end
        object Label6: TLabel
          Left = 9
          Top = 156
          Width = 38
          Height = 13
          Caption = 'Weight:'
        end
        object Label29: TLabel
          Left = 9
          Top = 180
          Width = 52
          Height = 13
          Caption = 'Symmetry:'
        end
        object txtA: TEdit
          Left = 32
          Top = 8
          Width = 110
          Height = 21
          TabOrder = 0
          Text = '0'
          OnExit = CoefExit
          OnKeyPress = CoefKeyPress
        end
        object txtB: TEdit
          Left = 32
          Top = 32
          Width = 110
          Height = 21
          TabOrder = 1
          Text = '0'
          OnExit = CoefExit
          OnKeyPress = CoefKeyPress
        end
        object txtC: TEdit
          Left = 32
          Top = 56
          Width = 110
          Height = 21
          TabOrder = 2
          Text = '0'
          OnExit = CoefExit
          OnKeyPress = CoefKeyPress
        end
        object txtD: TEdit
          Left = 32
          Top = 80
          Width = 110
          Height = 21
          TabOrder = 3
          Text = '0'
          OnExit = CoefExit
          OnKeyPress = CoefKeyPress
        end
        object txtE: TEdit
          Left = 32
          Top = 104
          Width = 110
          Height = 21
          TabOrder = 4
          Text = '0'
          OnExit = CoefExit
          OnKeyPress = CoefKeyPress
        end
        object txtF: TEdit
          Left = 32
          Top = 128
          Width = 110
          Height = 21
          TabOrder = 5
          Text = '0'
          OnExit = CoefExit
          OnKeyPress = CoefKeyPress
        end
        object txtP: TEdit
          Left = 72
          Top = 152
          Width = 70
          Height = 21
          TabOrder = 6
          Text = '0'
          OnExit = txtPExit
          OnKeyPress = txtPKeyPress
        end
        object txtSymmetry: TEdit
          Left = 72
          Top = 176
          Width = 70
          Height = 21
          TabOrder = 7
          Text = '0'
          OnExit = txtSymmetryExit
          OnKeyPress = txtSymmetryKeyPress
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Variations'
        object VEVars: TValueListEditor
          Left = 0
          Top = 0
          Width = 159
          Height = 231
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
          TitleCaptions.Strings = (
            'Variation'
            'Value')
          OnExit = VEVarsExit
          OnKeyPress = VEVarsKeyPress
          OnValidate = VEVarsValidate
          ColWidths = (
            93
            60)
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Colors'
        ImageIndex = 3
        object GroupBox1: TGroupBox
          Left = 8
          Top = 0
          Width = 145
          Height = 73
          Caption = 'Transform color'
          TabOrder = 0
          object scrlXFormColor: TScrollBar
            Left = 8
            Top = 48
            Width = 129
            Height = 13
            LargeChange = 10
            PageSize = 0
            TabOrder = 0
            OnChange = scrlXFormColorChange
            OnScroll = scrlXFormColorScroll
          end
          object pnlXFormColor: TPanel
            Left = 8
            Top = 16
            Width = 65
            Height = 25
            BevelOuter = bvLowered
            TabOrder = 1
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
        end
        object GroupBox2: TGroupBox
          Left = 8
          Top = 80
          Width = 145
          Height = 137
          Caption = 'Graph'
          TabOrder = 1
          object Label20: TLabel
            Left = 8
            Top = 56
            Width = 82
            Height = 13
            Caption = 'Background color'
          end
          object Label21: TLabel
            Left = 8
            Top = 96
            Width = 89
            Height = 13
            Caption = 'Reference triangle'
          end
          object pnlBackColor: TPanel
            Left = 8
            Top = 72
            Width = 129
            Height = 17
            BevelOuter = bvLowered
            Color = clBlack
            TabOrder = 0
            OnClick = pnlBackColorClick
          end
          object chkUseXFormColor: TCheckBox
            Left = 8
            Top = 16
            Width = 129
            Height = 17
            Caption = 'Use transform color'
            TabOrder = 1
            OnClick = chkUseXFormColorClick
          end
          object chkFlameBack: TCheckBox
            Left = 8
            Top = 36
            Width = 129
            Height = 17
            Caption = 'Use flame background'
            TabOrder = 2
            OnClick = chkFlameBackClick
          end
          object pnlReference: TPanel
            Left = 8
            Top = 112
            Width = 129
            Height = 17
            BevelOuter = bvLowered
            Color = clGray
            TabOrder = 3
            OnClick = pnlReferenceClick
          end
        end
      end
    end
  end
  object EditPopup: TPopupMenu
    Images = MainForm.Buttons
    Left = 312
    Top = 8
    object mnuAutoZoom: TMenuItem
      Caption = 'Auto Zoom'
      Hint = 'Zooms the triangle display to the best fit.'
      OnClick = mnuAutoZoomClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuDelete: TMenuItem
      Caption = 'Delete'
      Hint = 'Deletes the selected triangle.'
      ImageIndex = 9
      OnClick = mnuDeleteClick
    end
    object mnuDuplicate: TMenuItem
      Caption = 'Duplicate'
      Hint = 'Duplicates the selected triangle.'
      OnClick = mnuDupClick
    end
    object MenuItem2: TMenuItem
      Caption = '-'
    end
    object mnuAdd: TMenuItem
      Caption = 'Add'
      Hint = 'Adds a new triangle.'
      OnClick = mnuAddClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object mnuRotateRight: TMenuItem
      Caption = 'Rotate Right'
      OnClick = mnuRotateRightClick
    end
    object mnuRotateLeft: TMenuItem
      Caption = 'Rotate Left'
      OnClick = mnuRotateLeftClick
    end
    object mnuScaleUp: TMenuItem
      Caption = 'Scale Up'
      OnClick = mnuScaleUpClick
    end
    object mnuScaleDown: TMenuItem
      Caption = 'Scale Down'
      OnClick = mnuScaleDownClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnuFlipVertical: TMenuItem
      Caption = 'Flip Vertical'
      OnClick = mnuFlipVerticalClick
    end
    object mnuFlipHorizontal: TMenuItem
      Caption = 'Flip Horizontal'
      OnClick = mnuFlipHorizontalClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object mnuVerticalFlipAll: TMenuItem
      Caption = 'Flip All Vertical '
      OnClick = mnuVerticalFlipAllClick
    end
    object mnuHorizintalFlipAll: TMenuItem
      Caption = 'Flip All Horizontal'
      OnClick = mnuHorizintalFlipAllClick
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object mnuLockSel: TMenuItem
      Caption = 'Lock'
      OnClick = mnuLockClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object mnuUndo: TMenuItem
      Caption = 'Undo'
      Enabled = False
      ImageIndex = 4
      ShortCut = 16474
      OnClick = mnuUndoClick
    end
    object mnuRedo: TMenuItem
      Caption = 'Redo'
      Enabled = False
      ImageIndex = 5
      ShortCut = 16473
      OnClick = mnuRedoClick
    end
  end
  object QualityPopup: TPopupMenu
    Images = MainForm.Buttons
    Left = 344
    Top = 8
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
    object mnuResetLocation: TMenuItem
      Caption = 'Reset Location'
      Checked = True
      OnClick = mnuResetLocationClick
    end
  end
end
