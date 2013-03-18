object FavoritesForm: TFavoritesForm
  Left = 493
  Top = 541
  BorderStyle = bsDialog
  Caption = 'Favorite Scripts'
  ClientHeight = 275
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    352
    275)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 338
    Height = 231
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object ListView: TListView
    Left = 16
    Top = 16
    Width = 218
    Height = 215
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        AutoSize = True
        Caption = 'Name'
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ShowColumnHeaders = False
    TabOrder = 1
    ViewStyle = vsReport
    OnChange = ListViewChange
  end
  object btnAdd: TButton
    Left = 241
    Top = 16
    Width = 99
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Add'
    TabOrder = 2
    TabStop = False
    OnClick = btnAddClick
  end
  object btnRemove: TButton
    Left = 241
    Top = 48
    Width = 99
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Remove'
    TabOrder = 3
    TabStop = False
    OnClick = btnRemoveClick
  end
  object btnMoveUp: TButton
    Left = 241
    Top = 80
    Width = 99
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Move &Up'
    TabOrder = 4
    TabStop = False
    OnClick = btnMoveUpClick
  end
  object btnMoveDown: TButton
    Left = 241
    Top = 112
    Width = 99
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Move &Down'
    TabOrder = 5
    TabStop = False
    OnClick = btnMoveDownClick
  end
  object btnOK: TButton
    Left = 193
    Top = 246
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    TabOrder = 6
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 273
    Top = 246
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    TabOrder = 7
    OnClick = btnCancelClick
  end
end
