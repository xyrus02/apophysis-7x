object ScriptEditor: TScriptEditor
  Left = 312
  Top = 383
  Width = 539
  Height = 390
  Caption = 'Script Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShortCut = FormShortCut
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 250
    Width = 531
    Height = 4
    Cursor = crVSplit
    Align = alBottom
  end
  object ToolBar: TToolBar
    Left = 508
    Top = 0
    Width = 23
    Height = 250
    Align = alRight
    AutoSize = True
    Caption = 'ToolBar'
    Flat = True
    Images = MainForm.Buttons
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object btnNew: TToolButton
      Left = 0
      Top = 0
      Hint = 'New'
      Caption = 'btnNew'
      ImageIndex = 0
      Wrap = True
      OnClick = btnNewClick
    end
    object btnOpen: TToolButton
      Left = 0
      Top = 22
      Hint = 'Open'
      Caption = 'btnOpen'
      ImageIndex = 1
      Wrap = True
      OnClick = btnOpenClick
    end
    object btnSave: TToolButton
      Left = 0
      Top = 44
      Hint = 'Save'
      Caption = 'btnSave'
      ImageIndex = 2
      Wrap = True
      OnClick = btnSaveClick
    end
    object btnRun: TToolButton
      Left = 0
      Top = 66
      Hint = 'Run'
      Caption = 'btnRun'
      ImageIndex = 43
      Wrap = True
      OnClick = btnRunClick
    end
    object btnStop: TToolButton
      Left = 0
      Top = 88
      Hint = 'Stop'
      Caption = 'btnStop'
      Enabled = False
      ImageIndex = 36
      Wrap = True
      OnClick = btnStopClick
    end
    object btnBreak: TToolButton
      Left = 0
      Top = 110
      Hint = 'Break'
      Enabled = False
      ImageIndex = 37
      OnClick = btnBreakClick
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 343
    Width = 531
    Height = 19
    Anchors = [akLeft, akRight]
    Panels = <>
  end
  object BackPanel: TPanel
    Left = 0
    Top = 0
    Width = 508
    Height = 250
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Caption = 'BackPanel'
    TabOrder = 2
    object Editor: TAdvMemo
      Left = 2
      Top = 2
      Width = 504
      Height = 246
      Cursor = crIBeam
      PopupMenu = PopupMenu
      ActiveLineSettings.ShowActiveLine = False
      ActiveLineSettings.ShowActiveLineIndicator = False
      Align = alClient
      AutoCompletion.Font.Charset = DEFAULT_CHARSET
      AutoCompletion.Font.Color = clWindowText
      AutoCompletion.Font.Height = -11
      AutoCompletion.Font.Name = 'MS Sans Serif'
      AutoCompletion.Font.Style = []
      AutoCompletion.Height = 120
      AutoCompletion.Width = 400
      AutoCorrect.Active = True
      AutoHintParameterPosition = hpBelowCode
      BlockShow = False
      BlockColor = clWindow
      BlockLineColor = clGray
      BkColor = clWindow
      BorderStyle = bsNone
      Ctl3D = False
      DelErase = True
      EnhancedHomeKey = False
      Gutter.DigitCount = 4
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -13
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
      Gutter.LineNumberStart = 1
      Gutter.LineNumberTextColor = clBlack
      Gutter.ShowLineNumbers = True
      Gutter.Visible = True
      Gutter.ShowLeadingZeros = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'COURIER NEW'
      Font.Style = []
      HiddenCaret = False
      Lines.Strings = (
        '{ Rotate the reference triangle continuously }'
        '{ Hit any key to stop }'
        'Flame.SampleDensity := 1;'
        'while not Stopped do'
        'begin'
        '  RotateReference(3.6);'
        '  Preview;'
        'end;')
      MarkerList.UseDefaultMarkerImageIndex = False
      MarkerList.DefaultMarkerImageIndex = -1
      MarkerList.ImageTransparentColor = 33554432
      PrintOptions.MarginLeft = 0
      PrintOptions.MarginRight = 0
      PrintOptions.MarginTop = 0
      PrintOptions.MarginBottom = 0
      PrintOptions.PageNr = False
      PrintOptions.PrintLineNumbers = False
      RightMarginColor = 14869218
      ScrollHint = False
      SelColor = clWhite
      SelBkColor = clHighlight
      ShowRightMargin = True
      SmartTabs = False
      SyntaxStyles = PascalStyler
      TabOrder = 0
      TabSize = 4
      TabStop = True
      TrimTrailingSpaces = False
      UndoLimit = 100
      UrlAware = False
      UrlStyle.TextColor = clBlue
      UrlStyle.BkColor = clWhite
      UrlStyle.Style = [fsUnderline]
      UseStyler = True
      Version = '1.6.0.17'
      WordWrap = wwNone
      OnChange = EditorChange
    end
  end
  object Console: TMemo
    Left = 0
    Top = 254
    Width = 531
    Height = 89
    Align = alBottom
    Constraints.MinHeight = 20
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object MainOpenDialog: TOpenDialog
    DefaultExt = 'asc'
    Filter = 'Apophysis Script Files (*.asc)|*.asc|Text files (*.txt)|*.txt'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 456
    Top = 32
  end
  object MainSaveDialog: TSaveDialog
    DefaultExt = 'asc'
    Filter = 'Apophysis Script Files (*.asc)|*.asc|Text files (*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 424
    Top = 32
  end
  object PopupMenu: TPopupMenu
    Images = MainForm.Buttons
    Left = 392
    Top = 32
    object mnuUndo: TMenuItem
      Caption = 'Undo'
      ImageIndex = 4
      OnClick = mnuUndoClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuCut: TMenuItem
      Caption = 'Cut'
      ImageIndex = 6
      ShortCut = 16472
      OnClick = mnuCutClick
    end
    object mnuCopy: TMenuItem
      Caption = 'Copy'
      ImageIndex = 7
      OnClick = mnuCopyClick
    end
    object mnuPaste: TMenuItem
      Caption = 'Paste'
      ImageIndex = 8
      OnClick = mnuPasteClick
    end
  end
  object PascalStyler: TAdvPascalMemoStyler
    BlockStart = 'begin'
    BlockEnd = 'end'
    LineComment = '//'
    MultiCommentLeft = '{'
    MultiCommentRight = '}'
    CommentStyle.TextColor = clNavy
    CommentStyle.BkColor = clWindow
    CommentStyle.Style = [fsItalic]
    NumberStyle.TextColor = clNavy
    NumberStyle.BkColor = clWindow
    NumberStyle.Style = []
    AllStyles = <
      item
        KeyWords.Strings = (
          'and'
          'begin'
          'break'
          'class'
          'class'
          'const'
          'constructor'
          'continue'
          'default'
          'destructor'
          'do'
          'else'
          'end'
          'except'
          'finalise'
          'finally'
          'for'
          'function'
          'if'
          'implementation'
          'inherited'
          'initialise'
          'interface'
          'nil'
          'not'
          'or'
          'override'
          'private'
          'procedure'
          'property'
          'protected'
          'public'
          'published'
          'raise'
          'repeat'
          'stored'
          'then'
          'to'
          'try'
          'type'
          'unit'
          'until'
          'uses'
          'var'
          'virtual'
          'while'
          'with')
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        BGColor = clWindow
        StyleType = stKeyword
        BracketStart = #0
        BracketEnd = #0
        Info = 'Pascal Standard Default'
      end
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clWindow
        StyleType = stBracket
        BracketStart = #0
        BracketEnd = #0
        Info = 'Simple Quote'
      end
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clWindowText
        StyleType = stBracket
        BracketStart = #0
        BracketEnd = #0
        Info = 'Double Quote'
      end
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clWindow
        StyleType = stSymbol
        BracketStart = #0
        BracketEnd = #0
        Symbols = ' ,;:.(){}[]=-*/^%<>#'#13#10
        Info = 'Symbols Delimiters'
      end>
    AutoCompletion.Strings = (
      'ShowMessage'
      ''
      'RotateFlame'
      'RotateReference'
      'Rotate'
      'Multiply'
      'StoreFlame'
      'GetFlame'
      'LoadFlame'
      'Scale'
      'Translate'
      'ActiveTransform'
      'SetActiveTransform'
      'Transforms'
      'FileCount'
      'AddTransform'
      'DeleteTransform'
      'CopyTransform'
      'Clear'
      'Preview'
      'Render'
      'Print'
      'AddSymmetry'
      'Morph'
      'SetRenderBounds'
      'SetFlameFile'
      'ListFile'
      'SaveFlame'
      'GetFileName'
      'ShowStatus'
      'RandomFlame'
      'RandomGradient'
      'SaveGradient'
      'Variation'
      'SetVariation'
      'ProgramVersionString'
      'VariationIndex'
      'VariationName'
      'GetPivotMode'
      'SetPivotMode'
      'GetPivotX'
      'GetPivotY'
      'SetPivot'
      'ResetPivot'
      'CalculateScale'
      'CalculateBounds'
      'NormalizeVars'
      'GetSaveFileName'
      'CopyFile'
      ''
      'Renderer'
      ''
      'Filename'
      'Width'
      'Height'
      'MaxMemory'
      ''
      'Flame'
      ''
      'Gamma'
      'Brightness'
      'Vibrancy'
      'Time'
      'Zoom'
      'Width'
      'Height'
      'SampleDensity'
      'Quality'
      'Oversample'
      'FilterRadius'
      'Scale'
      'Gradient'
      'Background'
      'Name'
      'Batches'
      'FinalXformEnabled'
      ''
      'Transform'
      ''
      'coefs'
      'post'
      'Color'
      'Weight'
      'Symmetry'
      'Clear'
      'Rotate'
      'Scale'
      'RotateOrigin'
      'Variation'
      ''
      'Options'
      ''
      'JPEGQuality'
      'BatchSize'
      'ParameterFile'
      'SmoothPaletteFile'
      'NumTries'
      'TryLength'
      'ConfirmDelete'
      'FixedReference'
      'SampleDensity'
      'Gamma'
      'Brightness'
      'Vibrancy'
      'Oversample'
      'FilterRadius'
      'Transparency'
      'PreviewLowQuality'
      'PreviewMediumQuality'
      'PreviewHighQuality'
      'MinTransforms'
      'MaxTransforms'
      'MutateMinTransforms'
      'MutateMaxTransforms'
      'RandomPrefix'
      'KeepBackground'
      'SymmetryType'
      'SymmetryOrder'
      'Variations'
      'GradientOnRandom'
      'MinNodes'
      'MaxNodes'
      'MinHue'
      'MaxHue'
      'MinSaturation'
      'MaxSaturation'
      'MinLuminance'
      'MaxLuminance'
      'UPRSampleDensity'
      'UPRFilterRadius'
      'UPROversample'
      'UPRAdjustDensity'
      'UPRColoringIdent'
      'UPRColoringFile'
      'UPRFormulaFile'
      'UPRFormulaIdent'
      'UPRWidth'
      'UPRHeight'
      'ExportRenderer'
      ''
      'PI'
      'NVARS'
      'NXFORMS'
      'INSTALLPATH'
      'SYM_NONE'
      'SYM_BILATERAL'
      'SYM_ROTATIONAL'
      ''
      'V_LINEAR'
      'V_SINUSOIDAL'
      'V_SPHERICAL'
      'V_SWIRL'
      'V_HORSESHOE'
      'V_POLAR'
      'V_HANDKERCHIEF'
      'V_HEART'
      'V_DISC'
      'V_SPIRAL'
      'V_HYPERBOLIC'
      'V_DIAMOND'
      'V_EX'
      'V_JULIA'
      'V_BENT'
      'V_WAVES'
      'V_FISHEYE'
      'V_POPCORN'
      'V_EXPONENTIAL'
      'V_POWER'
      'V_COSINE'
      'V_RINGS'
      'V_FAN'
      'V_EYEFISH'
      'V_BUBBLE'
      'V_CYLINDER'
      'V_NOISE'
      'V_BLUR'
      'V_GAUSSIANBLUR'
      'V_RADIALBLUR'
      'V_RINGS2'
      'V_FAN2'
      'V_BLOB'
      'V_PDJ'
      'V_PERSPECTIVE'
      'V_JULIAN'
      'V_JULIASCOPE'
      'V_CURL'
      'V_RANDOM'
      '')
    HintParameter.TextColor = clBlack
    HintParameter.BkColor = clInfoBk
    HintParameter.HintCharStart = '('
    HintParameter.HintCharEnd = ')'
    HintParameter.HintCharDelimiter = ';'
    HintParameter.HintCharWriteDelimiter = ','
    HintParameter.Parameters.Strings = (
      'ShowMessage(const Msg: string);')
    HexIdentifier = '$'
    Description = 'Pascal'
    Filter = 'Pascal Files (*.pas,*.dpr,*.dpk,*.inc)|*.pas;*.dpr;*.dpk;*.inc'
    DefaultExtension = '.pas'
    StylerName = 'Pascal'
    Extensions = 'pas;dpr;dpk;inc'
    Left = 328
    Top = 32
  end
  object Scripter: TatPascalScripter
    SourceCode.Strings = (
      '')
    SaveCompiledCode = False
    EventSupport = False
    OnCompileError = ScripterCompileError
    ShortBooleanEval = False
    LibOptions.SearchPath.Strings = (
      '$(CURDIR)'
      '$(APPDIR)')
    LibOptions.SourceFileExt = '.psc'
    LibOptions.CompiledFileExt = '.pcu'
    LibOptions.UseScriptFiles = False
    CallExecHookEvent = False
    Left = 360
    Top = 32
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'fla'
    Filter = 
      'Flame files (*.flame)|*.flame|Apophysis 1.0 parameters (*.apo;*.' +
      'fla)|*.apo;*.fla|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 328
    Top = 64
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'flame'
    Filter = 'Flame files (*.flame)|*.flame'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 360
    Top = 64
  end
end
