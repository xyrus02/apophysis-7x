object FullscreenForm: TFullscreenForm
  Left = 439
  Top = 325
  BorderStyle = bsNone
  Caption = 'FullscreenForm'
  ClientHeight = 131
  ClientWidth = 186
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = FullscreenPopup
  OnClose = FormClose
  OnCreate = FormCreate
  OnDblClick = ImageDblClick
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage
    Left = 0
    Top = 0
    Width = 186
    Height = 131
    PopupMenu = FullscreenPopup
    OnDblClick = ImageDblClick
  end
  object Timelimiter: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = TimelimiterOnTimer
    Left = 8
    Top = 8
  end
  object FullscreenPopup: TPopupMenu
    Left = 40
    Top = 8
    object RenderStop: TMenuItem
      Caption = '&Stop Render'
      OnClick = RenderStopClick
    end
    object RenderMore: TMenuItem
      Caption = 'Render &More'
      ShortCut = 114
      OnClick = RenderMoreClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Exit1: TMenuItem
      Caption = '&Close'
      OnClick = ImageDblClick
    end
  end
end
