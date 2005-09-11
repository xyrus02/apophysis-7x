object frmPostProcess: TfrmPostProcess
  Left = 0
  Top = 0
  Width = 434
  Height = 320
  Caption = 'Post Render'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 426
    Height = 149
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      426
      149)
    object Label1: TLabel
      Left = 12
      Top = 12
      Width = 84
      Height = 13
      Caption = 'Background Color'
    end
    object Label2: TLabel
      Left = 12
      Top = 32
      Width = 24
      Height = 13
      Caption = 'Filter'
    end
    object Label3: TLabel
      Left = 12
      Top = 52
      Width = 35
      Height = 13
      Caption = 'Gamma'
    end
    object Label4: TLabel
      Left = 12
      Top = 72
      Width = 45
      Height = 13
      Caption = 'Vibrancy:'
    end
    object Label5: TLabel
      Left = 12
      Top = 92
      Width = 42
      Height = 13
      Caption = 'Contrast'
    end
    object Label6: TLabel
      Left = 12
      Top = 112
      Width = 50
      Height = 13
      Caption = 'Brightness'
    end
    object btnSave: TButton
      Left = 340
      Top = 36
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Save'
      TabOrder = 8
      OnClick = btnSaveClick
    end
    object pnlBackColor: TPanel
      Left = 104
      Top = 8
      Width = 97
      Height = 21
      BevelOuter = bvLowered
      TabOrder = 0
      OnClick = pnlBackColorClick
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 136
      Width = 424
      Height = 12
      Align = alBottom
      TabOrder = 1
    end
    object btnApply: TButton
      Left = 340
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Apply'
      Default = True
      TabOrder = 7
      OnClick = btnApplyClick
    end
    object txtFilterRadius: TEdit
      Left = 104
      Top = 28
      Width = 97
      Height = 21
      TabOrder = 2
    end
    object txtGamma: TEdit
      Left = 104
      Top = 48
      Width = 97
      Height = 21
      TabOrder = 3
    end
    object txtVib: TEdit
      Left = 104
      Top = 68
      Width = 97
      Height = 21
      TabOrder = 4
    end
    object txtContrast: TEdit
      Left = 104
      Top = 88
      Width = 97
      Height = 21
      TabOrder = 5
    end
    object txtBrightness: TEdit
      Left = 104
      Top = 108
      Width = 97
      Height = 21
      TabOrder = 6
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 149
    Width = 426
    Height = 137
    Align = alClient
    TabOrder = 1
    object Image: TImage
      Left = 0
      Top = 0
      Width = 105
      Height = 105
      AutoSize = True
    end
  end
  object ColorDialog: TColorDialog
    Left = 284
    Top = 4
  end
end
