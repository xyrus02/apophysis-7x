object frmConfig: TfrmConfig
  Left = 676
  Top = 276
  BorderStyle = bsToolWindow
  Caption = 'Configure'
  ClientHeight = 330
  ClientWidth = 201
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 299
    Width = 201
    Height = 31
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    object btnOk: TButton
      Left = 40
      Top = 5
      Width = 75
      Height = 21
      Caption = '&Ok'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOkClick
    end
    object btnCancel: TButton
      Left = 120
      Top = 5
      Width = 75
      Height = 21
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 200
    Width = 201
    Height = 99
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 10
      Width = 92
      Height = 13
      Caption = 'Oversample <1 - 3>'
    end
    object Label2: TLabel
      Left = 8
      Top = 30
      Width = 76
      Height = 13
      Caption = 'Filter <0.2 - 2.0>'
    end
    object Label3: TLabel
      Left = 8
      Top = 50
      Width = 62
      Height = 13
      Caption = 'Filter in pixels'
    end
    object Label4: TLabel
      Left = 8
      Top = 70
      Width = 71
      Height = 13
      Caption = 'Sample density'
    end
    object edtOversample: TEdit
      Left = 152
      Top = 8
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '1'
      OnExit = edtOversampleExit
    end
    object edtFiltersize: TEdit
      Left = 152
      Top = 28
      Width = 41
      Height = 21
      TabOrder = 1
      Text = '0.1'
      OnExit = edtFiltersizeExit
    end
    object edtDensity: TEdit
      Left = 152
      Top = 68
      Width = 41
      Height = 21
      TabOrder = 2
      Text = '10'
      OnExit = edtDensityExit
    end
    object pnlFilterpixels: TPanel
      Left = 152
      Top = 48
      Width = 41
      Height = 21
      Alignment = taLeftJustify
      BevelOuter = bvLowered
      BorderWidth = 2
      Caption = '1'
      TabOrder = 3
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 201
    Height = 153
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 2
    object chkSave: TCheckBox
      Left = 8
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Save images'
      TabOrder = 0
    end
    object chkShowOtherImages: TCheckBox
      Left = 8
      Top = 24
      Width = 177
      Height = 17
      Caption = 'Show previous rendered images'
      TabOrder = 1
    end
    object rgQuality: TRadioGroup
      Left = 8
      Top = 64
      Width = 185
      Height = 81
      Caption = 'Quality'
      Items.Strings = (
        'Low'
        'Medium'
        'High'
        'User defined')
      TabOrder = 2
      OnClick = rgQualityClick
    end
    object chkShowRndInfo: TCheckBox
      Left = 8
      Top = 40
      Width = 169
      Height = 17
      Caption = 'Show on-screen rendering info'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
end
