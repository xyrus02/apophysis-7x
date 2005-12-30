object frmPostProcess: TfrmPostProcess
  Left = 38
  Top = 43
  Width = 640
  Height = 534
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
    Width = 632
    Height = 71
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      632
      71)
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
      Left = 172
      Top = 12
      Width = 35
      Height = 13
      Caption = 'Gamma'
    end
    object Label4: TLabel
      Left = 332
      Top = 32
      Width = 45
      Height = 13
      Caption = 'Vibrancy:'
    end
    object Label5: TLabel
      Left = 332
      Top = 12
      Width = 42
      Height = 13
      Caption = 'Contrast'
    end
    object Label6: TLabel
      Left = 172
      Top = 32
      Width = 50
      Height = 13
      Caption = 'Brightness'
    end
    object btnSave: TButton
      Left = 552
      Top = 30
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
      Width = 57
      Height = 21
      BevelOuter = bvLowered
      TabOrder = 0
      OnClick = pnlBackColorClick
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 58
      Width = 630
      Height = 12
      Align = alBottom
      TabOrder = 1
    end
    object btnApply: TButton
      Left = 552
      Top = 4
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
      Width = 57
      Height = 21
      TabOrder = 2
    end
    object txtGamma: TEdit
      Left = 264
      Top = 8
      Width = 57
      Height = 21
      TabOrder = 3
    end
    object txtVib: TEdit
      Left = 424
      Top = 28
      Width = 57
      Height = 21
      TabOrder = 4
    end
    object txtContrast: TEdit
      Left = 424
      Top = 8
      Width = 57
      Height = 21
      TabOrder = 5
    end
    object txtBrightness: TEdit
      Left = 264
      Top = 28
      Width = 57
      Height = 21
      TabOrder = 6
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 71
    Width = 632
    Height = 435
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
    Left = 508
    Top = 20
  end
end
