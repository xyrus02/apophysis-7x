object frmPostProcess: TfrmPostProcess
  Left = 421
  Top = 359
  Width = 709
  Height = 575
  Caption = 'Post Render'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 700
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    701
    548)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 701
    Height = 81
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      701
      81)
    object pnlFilter: TPanel
      Left = 8
      Top = 32
      Width = 121
      Height = 21
      Cursor = crHandPoint
      BevelOuter = bvLowered
      Caption = 'Filter Radius'
      TabOrder = 11
      OnDblClick = DragPanelDblClick
      OnMouseDown = DragPanelMouseDown
      OnMouseMove = DragPanelMouseMove
      OnMouseUp = DragPanelMouseUp
    end
    object pnlVibrancy: TPanel
      Left = 360
      Top = 32
      Width = 105
      Height = 21
      Cursor = crHandPoint
      BevelOuter = bvLowered
      Caption = 'Vibrancy'
      TabOrder = 10
      OnDblClick = DragPanelDblClick
      OnMouseDown = DragPanelMouseDown
      OnMouseMove = DragPanelMouseMove
      OnMouseUp = DragPanelMouseUp
    end
    object pnlBrightness: TPanel
      Left = 192
      Top = 32
      Width = 105
      Height = 21
      Cursor = crHandPoint
      BevelOuter = bvLowered
      Caption = 'Brightness'
      TabOrder = 8
      OnDblClick = DragPanelDblClick
      OnMouseDown = DragPanelMouseDown
      OnMouseMove = DragPanelMouseMove
      OnMouseUp = DragPanelMouseUp
    end
    object pnlContrast: TPanel
      Left = 360
      Top = 8
      Width = 105
      Height = 21
      Cursor = crHandPoint
      BevelOuter = bvLowered
      Caption = 'Contrast'
      TabOrder = 9
      OnDblClick = DragPanelDblClick
      OnMouseDown = DragPanelMouseDown
      OnMouseMove = DragPanelMouseMove
      OnMouseUp = DragPanelMouseUp
    end
    object pnlGamma: TPanel
      Left = 192
      Top = 8
      Width = 105
      Height = 21
      Cursor = crHandPoint
      BevelOuter = bvLowered
      Caption = 'Gamma'
      TabOrder = 7
      OnDblClick = DragPanelDblClick
      OnMouseDown = DragPanelMouseDown
      OnMouseMove = DragPanelMouseMove
      OnMouseUp = DragPanelMouseUp
    end
    object ProgressBar1: TProgressBar
      Left = 8
      Top = 61
      Width = 690
      Height = 20
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 1
    end
    object txtFilterRadius: TEdit
      Left = 128
      Top = 32
      Width = 57
      Height = 21
      TabOrder = 2
    end
    object txtGamma: TEdit
      Left = 296
      Top = 8
      Width = 57
      Height = 21
      TabOrder = 3
    end
    object txtVibrancy: TEdit
      Left = 464
      Top = 32
      Width = 57
      Height = 21
      TabOrder = 6
    end
    object txtContrast: TEdit
      Left = 464
      Top = 8
      Width = 57
      Height = 21
      TabOrder = 5
    end
    object txtBrightness: TEdit
      Left = 296
      Top = 32
      Width = 57
      Height = 21
      TabOrder = 4
    end
    object pnlBackground: TPanel
      Left = 8
      Top = 8
      Width = 121
      Height = 21
      Cursor = crArrow
      BevelOuter = bvLowered
      Caption = 'Background'
      TabOrder = 12
      OnDblClick = DragPanelDblClick
      OnMouseDown = DragPanelMouseDown
      OnMouseMove = DragPanelMouseMove
      OnMouseUp = DragPanelMouseUp
    end
    object pnlBackColor: TPanel
      Left = 128
      Top = 8
      Width = 57
      Height = 21
      Cursor = crHandPoint
      BevelInner = bvRaised
      BevelOuter = bvLowered
      BorderStyle = bsSingle
      TabOrder = 0
      OnClick = pnlBackColorClick
      object shBack: TShape
        Left = 2
        Top = 2
        Width = 49
        Height = 13
        Align = alClient
        Brush.Color = clBlack
        Pen.Color = clWindow
        Pen.Style = psClear
        Pen.Width = 0
        OnMouseUp = shBackMouseUp
      end
    end
    object btnApply: TButton
      Left = 597
      Top = 16
      Width = 97
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Apply'
      Default = True
      TabOrder = 13
      OnClick = btnApplyClick
    end
  end
  object ScrollBox1: TScrollBox
    Left = 8
    Top = 88
    Width = 689
    Height = 417
    Align = alCustom
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    BevelKind = bkSoft
    BorderStyle = bsNone
    Color = clAppWorkSpace
    ParentColor = False
    TabOrder = 1
    object Image: TImage
      Left = 0
      Top = 0
      Width = 687
      Height = 415
      Align = alClient
      AutoSize = True
      Center = True
      Proportional = True
      Stretch = True
    end
  end
  object btnSave: TButton
    Left = 599
    Top = 516
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Save'
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object chkFitToWindow: TCheckBox
    Left = 8
    Top = 520
    Width = 490
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Fit to window'
    Checked = True
    State = cbChecked
    TabOrder = 3
    Visible = False
    OnClick = chkFitToWindowClick
  end
  object ColorDialog: TColorDialog
    Left = 612
    Top = 76
  end
end
