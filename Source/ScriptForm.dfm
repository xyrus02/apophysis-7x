object ScriptEditor: TScriptEditor
  Left = 312
  Top = 383
  Width = 539
  Height = 390
  Caption = 'Default Animation'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 244
    Width = 531
    Height = 4
    Cursor = crVSplit
    Align = alBottom
  end
  object ToolBar: TToolBar
    Left = 508
    Top = 0
    Width = 23
    Height = 244
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
      ImageIndex = 38
      OnClick = btnBreakClick
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 337
    Width = 531
    Height = 19
    Anchors = [akLeft, akRight]
    Panels = <>
    SimplePanel = False
  end
  object BackPanel: TPanel
    Left = 0
    Top = 0
    Width = 508
    Height = 244
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Caption = 'BackPanel'
    TabOrder = 2
    object Editor: TAdvMemo
      Left = 2
      Top = 2
      Width = 504
      Height = 240
      Cursor = crIBeam
      PopupMenu = PopupMenu
      Align = alClient
      AutoCompletion.Active = False
      AutoCompletion.Font.Charset = DEFAULT_CHARSET
      AutoCompletion.Font.Color = clWindowText
      AutoCompletion.Font.Height = -11
      AutoCompletion.Font.Name = 'MS Sans Serif'
      AutoCompletion.Font.Style = []
      AutoHintParameterPosition = hpBelowCode
      AutoIndent = True
      BlockShow = False
      BlockColor = clWindow
      BlockLineColor = clGray
      BkColor = clWindow
      BorderStyle = bsNone
      Ctl3D = False
      DelErase = True
      GutterColorTo = clBtnFace
      GutterWidth = 35
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'COURIER NEW'
      Font.Style = []
      HiddenCaret = False
      LineNumbers = True
      LineNumberStart = 1
      Lines.Strings = (
        '{ Rotate the reference triangle continuously }'
        '{ Hit any key to stop }'
        'Flame.SampleDensity := 1;'
        'while not Stopped do'
        'begin'
        '  RotateReference(3.6);'
        '  Preview;'
        'end;')
      PrintOptions.MarginLeft = 0
      PrintOptions.MarginRight = 0
      PrintOptions.MarginTop = 0
      PrintOptions.MarginBottom = 0
      PrintOptions.PageNr = False
      RightMarginColor = 14869218
      SelColor = clWhite
      SelBkColor = clHighlight
      SyntaxStyles = PascalStyler
      TabOrder = 0
      TabSize = 4
      TabStop = True
      UndoLimit = 100
      UrlAware = False
      UrlStyle.TextColor = clBlue
      UrlStyle.BkColor = clWhite
      UrlStyle.Style = [fsUnderline]
      Version = '1.5.0.8'
      WordWrap = wwNone
      OnChange = EditorChange
    end
  end
  object Console: TMemo
    Left = 0
    Top = 248
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
    NumberStyle.TextColor = clWindowText
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
        Bracket = #0
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
        Bracket = #39
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
        Bracket = '"'
        Info = 'Double Quote'
      end
      item
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        BGColor = clWindow
        StyleType = stSymbol
        Bracket = #0
        Symbols = ' ,;:.(){}[]=-*/^%<>#'#13#10
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
    Left = 328
    Top = 32
  end
  object Scripter: TatPascalScripter
    SourceCode.Strings = (
      '')
    Compiled = True
    EventSupport = False
    OnCompileError = ScripterCompileError
    ShortBooleanEval = False
    Left = 360
    Top = 32
    PCode = {
      1B010000617450617363616C2045786563757461626C652046696C651A040F01
      0000000000000000790000000000000000000000000000000000000000000000
      0000000000000000545046300D546174536372697074496E666F025F3108526F
      7574696E65730E01044E616D6506044D41494E095661726961626C65730E000A
      497346756E6374696F6E0808417267436F756E7402000C42795265664172674D
      61736B02000B526573756C74496E6465780200000007476C6F62616C730E0000
      001C0000000000000003000000010000000000000000000000000000004D4149
      4E1E000000330000000200000000000000000000000000000000000000526573
      756C7418000000410000000200000000000000000000000000000000000000}
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
