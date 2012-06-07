object ScriptEditor: TScriptEditor
  Left = 312
  Top = 383
  Caption = 'Script Editor'
  ClientHeight = 485
  ClientWidth = 583
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000040040000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000006349
    35146349352E927A69FF8C7563FF87705EFF6349352E7F6654FF7A624FFF755D
    4AFF6349352E6E5441FF6A513EFF674E3AFF6349352E00000000000000006349
    352EAE9888FFEFE3DDFFF2E7E1FFEDDFD7FF836B59FFB79B8BFFDBBDADFFD9B7
    A6FF725946FFAE8B77FFD0A692FFCC9E87FF654B38FF6349352E00000000B7A2
    93FFFBF8F7FFF9F4F2FFF7F0ECFFF4EBE6FFF1E5DFFF7F6754FF7A624FFF765D
    4AFF735946FF6E5542FF6B523EFF674E3AFF654B38FF634935FF00000000B7A2
    93FFFDFCFBFFFBF9F7FFFAF5F2FFF7EFEDFFF4EAE6FFF2E5DFFFDDDCD7FFDFD7
    CEFFDECDC0FFDEC5B6FFDEBFACFFDBBAA6FFD8B5A3FF634935FF00000000B7A2
    93FFFFFFFFFFB47F65FFB47F64FFEDDDD5FFB37E63FFF4EBE6FFF1E5DFFFEFDF
    D7FFEBD9D1FFE8D3C9FFE5CDC1FFE1C6B9FFD6B3A1FF634A35FF00000000B9A4
    95FFFFFFFFFFFFFFFFFFFDFCFCFFFCF9F7FFFAF4F2FFF6F0ECFFF4EBE5FFF2E5
    DFFFEEDFD8FFEBD9D0FFE8D3C8FFE5CCC1FFDBBDADFF634A36FF00000000BDA7
    98FFFFFFFFFF968E88FFEEDED7FF968E87FFEDDDD6FF968D86FF958C85FFF4EB
    E6FFF2E5DFFFEFDFD8FFECD9D0FFE8D3C9FFE0C7BAFF634A35FF00000000C1AB
    9CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFCFCFFFBF8F7FFFAF4F2FFF7F0
    ECFFF4EAE6FFF1E5DFFFEEDFD7FFEBD9D0FFE6D1C6FF634A35FF00000000C5AF
    A0FFFFFFFFFFB48065FFB48065FF968E88FFC2B0A3FF968E87FF968E86FFF9F4
    F2FFF7EFECFFF4EBE6FFF2E5DFFFEFDFD8FFEADBD1FF634936FF00000000C8B2
    A3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFCFCFFFCF8
    F7FFF9F5F2FFF7F0ECFFF4EBE6FFF1E5DFFFEEE2DAFF644A36FF00000000C9B4
    A5FFFFFFFFFFFFFFFFFF66A365FF66A365FF66A365FFC0B4ADFF66A365FF66A3
    65FF66A264FFFAF5F2FFF7F0ECFFF4EBE6FFEEE2DAFF644A36FF00000000C8B2
    A3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFEFCFBFFFBF9F7FFFAF4F2FFF7F0EDFFF3EAE4FF644A36FF00000000C8B2
    A3FFCAB4A5FFCBB5A6FFCAB4A5FFC9B3A4FFC7B2A3FFC6B0A1FFC3AE9FFFC1AC
    9DFFBFAA9BFFBDA899FFBBA697FFB9A495FFB8A394FFB7A293FF000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    0000FFFF00000003000000010000000100000001000000010000000100000001
    0000000100000001000000010000000100000001000000010000FFFF0000}
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
    Top = 373
    Width = 583
    Height = 4
    Cursor = crVSplit
    Align = alBottom
  end
  object ToolBar: TToolBar
    Left = 560
    Top = 0
    Width = 23
    Height = 373
    Align = alRight
    AutoSize = True
    Caption = 'ToolBar'
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
    Top = 466
    Width = 583
    Height = 19
    Anchors = [akLeft, akRight]
    Panels = <>
  end
  object BackPanel: TPanel
    Left = 0
    Top = 0
    Width = 560
    Height = 373
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Caption = 'BackPanel'
    TabOrder = 2
    object Editor: TAdvMemo
      Left = 2
      Top = 2
      Width = 556
      Height = 369
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
      AutoCompletion.StartToken = '(.'
      AutoCompletion.Width = 400
      AutoCorrect.Active = True
      AutoHintParameterPosition = hpBelowCode
      BlockShow = False
      BlockColor = clWindow
      BlockLineColor = clGray
      BkColor = clWindow
      BorderStyle = bsNone
      ClipboardFormats = [cfText]
      CodeFolding.Enabled = False
      CodeFolding.LineColor = clGray
      Ctl3D = False
      DelErase = True
      EnhancedHomeKey = False
      Gutter.DigitCount = 4
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -13
      Gutter.Font.Name = 'Courier New'
      Gutter.Font.Style = []
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
      SyntaxStyles = Styler
      TabOrder = 0
      TabSize = 4
      TabStop = True
      TrimTrailingSpaces = False
      UrlAware = False
      UrlStyle.TextColor = clBlue
      UrlStyle.BkColor = clWhite
      UrlStyle.Style = [fsUnderline]
      UseStyler = True
      Version = '2.3.7.6'
      WordWrap = wwNone
      OnChange = EditorChange
    end
  end
  object Console: TMemo
    Left = 0
    Top = 377
    Width = 583
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
    Left = 472
    Top = 64
  end
  object MainSaveDialog: TSaveDialog
    DefaultExt = 'asc'
    Filter = 'Apophysis Script Files (*.asc)|*.asc|Text files (*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 344
    Top = 32
  end
  object PopupMenu: TPopupMenu
    Images = MainForm.Buttons
    Left = 280
    Top = 112
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
    Left = 480
    Top = 200
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'fla'
    Filter = 
      'Flame files (*.flame)|*.flame|Apophysis 1.0 parameters (*.apo;*.' +
      'fla)|*.apo;*.fla|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 416
    Top = 200
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'flame'
    Filter = 'Flame files (*.flame)|*.flame'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 440
    Top = 128
  end
  object Styler: TAdvPascalMemoStyler
    BlockStart = 'begin,try,case,class,record'
    BlockEnd = 'end'
    LineComment = '//'
    MultiCommentLeft = '{'
    MultiCommentRight = '}'
    CommentStyle.TextColor = clNavy
    CommentStyle.BkColor = clWhite
    CommentStyle.Style = [fsItalic]
    NumberStyle.TextColor = clFuchsia
    NumberStyle.BkColor = clWhite
    NumberStyle.Style = [fsBold]
    AllStyles = <
      item
        KeyWords.Strings = (
          'absolute'
          'abstract'
          'and'
          'array'
          'as'
          'asm'
          'assembler'
          'automated'
          'begin'
          'break'
          'case'
          'cdecl'
          'class'
          'class'
          'const'
          'constructor'
          'continue'
          'default'
          'deprecated'
          'destructor'
          'dispid'
          'dispinterface'
          'div'
          'do'
          'downto'
          'dynamic'
          'else'
          'end'
          'except'
          'exports'
          'external'
          'far'
          'file'
          'finalise'
          'finally'
          'for'
          'forward'
          'function'
          'if'
          'implementation'
          'in'
          'inherited'
          'initialise'
          'inline'
          'interface'
          'is'
          'label'
          'library'
          'message'
          'mod'
          'near'
          'nil'
          'not'
          'object'
          'of'
          'or'
          'out'
          'overload'
          'override'
          'packed'
          'pascal'
          'platform'
          'private'
          'procedure'
          'program'
          'program'
          'property'
          'protected'
          'public'
          'published'
          'raise'
          'record'
          'register'
          'reintroduce'
          'repeat'
          'resourcestring'
          'safecall'
          'set'
          'shl'
          'shr'
          'stdcall'
          'stored'
          'string'
          'then'
          'threadvar'
          'to'
          'try'
          'type'
          'unit'
          'until'
          'uses'
          'var'
          'virtual'
          'while'
          'with'
          'xor')
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        BGColor = clWhite
        StyleType = stKeyword
        BracketStart = #0
        BracketEnd = #0
        Info = 'Pascal Standard Default'
      end
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clWhite
        StyleType = stBracket
        BracketStart = #39
        BracketEnd = #39
        Info = 'Simple Quote'
      end
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clWhite
        StyleType = stBracket
        BracketStart = '"'
        BracketEnd = '"'
        Info = 'Double Quote'
      end
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clWhite
        StyleType = stSymbol
        BracketStart = #0
        BracketEnd = #0
        Symbols = ' ,;:.(){}[]=+-*/^%<>#'#13#10
        Info = 'Symbols Delimiters'
      end>
    AutoCompletion.Strings = (
      'ShowMessage'
      'MessageDlg')
    HintParameter.TextColor = clBlack
    HintParameter.BkColor = clInfoBk
    HintParameter.HintCharStart = '('
    HintParameter.HintCharEnd = ')'
    HintParameter.HintCharDelimiter = ';'
    HintParameter.HintCharWriteDelimiter = ','
    HintParameter.Parameters.Strings = (
      'ShowMessage(const Msg: string);'
      
        'MessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMs' +
        'gDlgButtons; HelpCtx: Longint): Integer);')
    HexIdentifier = '$'
    Description = 'Pascal'
    Filter = 'Pascal Files (*.pas,*.dpr,*.dpk,*.inc)|*.pas;*.dpr;*.dpk;*.inc'
    DefaultExtension = '.pas'
    StylerName = 'Pascal'
    Extensions = 'pas;dpr;dpk;inc'
    RegionDefinitions = <
      item
        Identifier = 'procedure'
        RegionStart = 'begin'
        RegionEnd = 'end'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'constructor'
        RegionStart = 'begin'
        RegionEnd = 'end'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'destructor'
        RegionStart = 'begin'
        RegionEnd = 'end'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = 'interface'
        RegionStart = 'interface'
        RegionType = rtOpen
        ShowComments = False
      end
      item
        Identifier = 'unit'
        RegionStart = 'unit'
        RegionType = rtFile
        ShowComments = False
      end
      item
        Identifier = 'implementation'
        RegionStart = 'implementation'
        RegionType = rtOpen
        ShowComments = False
      end
      item
        Identifier = 'case'
        RegionStart = 'case'
        RegionEnd = 'end'
        RegionType = rtIgnore
        ShowComments = False
      end
      item
        Identifier = 'try'
        RegionStart = 'try'
        RegionEnd = 'end'
        RegionType = rtIgnore
        ShowComments = False
      end
      item
        Identifier = 'function'
        RegionStart = 'begin'
        RegionEnd = 'end'
        RegionType = rtClosed
        ShowComments = False
      end
      item
        Identifier = '{$region'
        RegionStart = '{$region'
        RegionEnd = '{$endregion'
        RegionType = rtClosed
        ShowComments = False
      end>
    Left = 288
    Top = 208
  end
end
