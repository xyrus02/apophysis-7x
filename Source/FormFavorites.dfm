object FavoritesForm: TFavoritesForm
  Left = 457
  Top = 267
  BorderStyle = bsDialog
  Caption = 'Favorite Scripts'
  ClientHeight = 237
  ClientWidth = 303
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
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 289
    Height = 193
    TabOrder = 0
  end
  object ListView: TListView
    Left = 16
    Top = 16
    Width = 193
    Height = 177
    Columns = <
      item
        Caption = 'Name'
        Width = 189
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
    Left = 216
    Top = 16
    Width = 75
    Height = 25
    Caption = '&Add'
    TabOrder = 2
    TabStop = False
    OnClick = btnAddClick
  end
  object btnRemove: TButton
    Left = 216
    Top = 48
    Width = 75
    Height = 25
    Caption = '&Remove'
    TabOrder = 3
    TabStop = False
    OnClick = btnRemoveClick
  end
  object btnMoveUp: TButton
    Left = 216
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Move &Up'
    TabOrder = 4
    TabStop = False
    OnClick = btnMoveUpClick
  end
  object btnMoveDown: TButton
    Left = 216
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Move &Down'
    TabOrder = 5
    TabStop = False
    OnClick = btnMoveDownClick
  end
  object btnOK: TButton
    Left = 144
    Top = 208
    Width = 75
    Height = 25
    Caption = '&OK'
    TabOrder = 6
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 224
    Top = 208
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 7
    OnClick = btnCancelClick
  end
end
