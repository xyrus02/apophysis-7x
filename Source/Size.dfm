object SizeTool: TSizeTool
  Left = 330
  Top = 199
  BorderStyle = bsDialog
  Caption = 'Image Size'
  ClientHeight = 113
  ClientWidth = 152
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 23
    Width = 28
    Height = 13
    Caption = '&Width'
    FocusControl = txtWidth
  end
  object Bevel: TBevel
    Left = 8
    Top = 8
    Width = 137
    Height = 97
    Shape = bsFrame
  end
  object Label2: TLabel
    Left = 18
    Top = 47
    Width = 34
    Height = 13
    Caption = '&Height:'
    FocusControl = txtHeight
  end
  object txtWidth: TEdit
    Left = 64
    Top = 20
    Width = 70
    Height = 21
    TabOrder = 0
    OnChange = txtWidthChange
    OnKeyPress = txtWidthKeyPress
  end
  object txtHeight: TEdit
    Left = 64
    Top = 44
    Width = 70
    Height = 21
    TabOrder = 1
    OnChange = txtHeightChange
    OnKeyPress = txtHeightKeyPress
  end
  object chkMaintain: TCheckBox
    Left = 16
    Top = 76
    Width = 121
    Height = 17
    Caption = '&Maintain aspect ratio'
    TabOrder = 2
    OnClick = chkMaintainClick
  end
end
