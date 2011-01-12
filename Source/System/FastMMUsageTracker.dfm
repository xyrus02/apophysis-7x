object fFastMMUsageTracker: TfFastMMUsageTracker
  Left = 259
  Top = 93
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'FastMM4 Usage Tracker'
  ClientHeight = 566
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gbMemoryMap: TGroupBox
    Left = 8
    Top = 4
    Width = 301
    Height = 525
    Caption = 'Memory Map'
    TabOrder = 0
    object Label1: TLabel
      Left = 12
      Top = 496
      Width = 38
      Height = 13
      Caption = 'Address'
    end
    object Label2: TLabel
      Left = 148
      Top = 496
      Width = 25
      Height = 13
      Caption = 'State'
    end
    object dgMemoryMap: TDrawGrid
      Left = 16
      Top = 16
      Width = 277
      Height = 469
      ColCount = 32
      DefaultColWidth = 8
      DefaultRowHeight = 8
      FixedCols = 0
      RowCount = 2048
      FixedRows = 0
      GridLineWidth = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      ScrollBars = ssVertical
      TabOrder = 0
      OnDrawCell = dgMemoryMapDrawCell
      OnSelectCell = dgMemoryMapSelectCell
    end
    object eAddress: TEdit
      Left = 56
      Top = 492
      Width = 81
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = '$00000000'
    end
    object eState: TEdit
      Left = 184
      Top = 492
      Width = 105
      Height = 21
      Enabled = False
      TabOrder = 2
      Text = 'Unallocated'
    end
  end
  object gbBlockStats: TGroupBox
    Left = 320
    Top = 4
    Width = 465
    Height = 469
    Caption = 'Block Statistics'
    TabOrder = 1
    object sgBlockStatistics: TStringGrid
      Left = 12
      Top = 16
      Width = 441
      Height = 441
      DefaultColWidth = 83
      DefaultRowHeight = 17
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object bClose: TBitBtn
    Left = 708
    Top = 536
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = bCloseClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
      33333337777FF377FF3333993370739993333377FF373F377FF3399993000339
      993337777F777F3377F3393999707333993337F77737333337FF993399933333
      399377F3777FF333377F993339903333399377F33737FF33377F993333707333
      399377F333377FF3377F993333101933399377F333777FFF377F993333000993
      399377FF3377737FF7733993330009993933373FF3777377F7F3399933000399
      99333773FF777F777733339993707339933333773FF7FFF77333333999999999
      3333333777333777333333333999993333333333377777333333}
    NumGlyphs = 2
  end
  object GroupBox1: TGroupBox
    Left = 320
    Top = 480
    Width = 465
    Height = 49
    Caption = 'Address Space Usage'
    Enabled = False
    TabOrder = 3
    object Label3: TLabel
      Left = 12
      Top = 20
      Width = 199
      Height = 13
      Caption = 'Total Process Address Space In Use (MB)'
    end
    object eTotalAddressSpaceInUse: TEdit
      Left = 332
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
    end
  end
  object tTimer: TTimer
    OnTimer = tTimerTimer
    Left = 20
    Top = 24
  end
end
