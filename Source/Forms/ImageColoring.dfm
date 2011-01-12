object frmImageColoring: TfrmImageColoring
  Left = 419
  Top = 408
  Width = 581
  Height = 365
  Caption = 'Image coloring'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 40
    Width = 54
    Height = 13
    Caption = 'First Palete'
  end
  object Label2: TLabel
    Left = 16
    Top = 168
    Width = 72
    Height = 13
    Caption = 'Second palette'
  end
  object Label3: TLabel
    Left = 296
    Top = 36
    Width = 30
    Height = 13
    Caption = 'Image'
  end
  object Label4: TLabel
    Left = 16
    Top = 107
    Width = 57
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'Preset'
  end
  object Label5: TLabel
    Left = 16
    Top = 235
    Width = 57
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'Preset'
  end
  object cbEnable: TCheckBox
    Left = 16
    Top = 8
    Width = 133
    Height = 17
    Caption = 'Enable image coloring'
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 16
    Top = 56
    Width = 258
    Height = 40
    BevelOuter = bvLowered
    TabOrder = 1
    object imgPal1: TImage
      Left = 1
      Top = 1
      Width = 256
      Height = 38
      Align = alClient
      Stretch = True
    end
  end
  object Panel2: TPanel
    Left = 16
    Top = 188
    Width = 258
    Height = 40
    BevelOuter = bvLowered
    TabOrder = 2
    object imgpal2: TImage
      Left = 1
      Top = 1
      Width = 256
      Height = 38
      Align = alClient
      Stretch = True
    end
  end
  object Panel3: TPanel
    Left = 292
    Top = 60
    Width = 258
    Height = 258
    BevelOuter = bvLowered
    TabOrder = 3
  end
  object cmbPalette1: TComboBox
    Left = 80
    Top = 106
    Width = 177
    Height = 19
    Style = csOwnerDrawFixed
    Color = clBlack
    DropDownCount = 20
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 4
    OnChange = cmbPalette1Change
    OnDrawItem = cmbPalette1DrawItem
    Items.Strings = (
      'south-sea-bather'
      'sky-flesh'
      'blue-bather'
      'no-name'
      'pillows'
      'mauve-splat'
      'facial-treescape 6'
      'fasion-bug'
      'leafy-face'
      'mouldy-sun'
      'sunny-harvest'
      'peach-tree'
      'fire-dragon'
      'ice-dragon'
      'german-landscape'
      'no-name'
      'living-mud-bomb'
      'cars'
      'unhealthy-tan'
      'daffodil'
      'rose'
      'healthy-skin'
      'orange'
      'white-ivy'
      'summer-makeup'
      'glow-buzz'
      'deep-water'
      'afternoon-beach'
      'dim-beach'
      'cloudy-brick'
      'burning-wood'
      'aquatic-garden'
      'no-name'
      'fall-quilt'
      'night-blue-sky'
      'shadow-iris'
      'solid-sky'
      'misty-field'
      'wooden-highlight'
      'jet-tundra'
      'pastel-lime'
      'hell'
      'indian-coast'
      'dentist-decor'
      'greenland'
      'purple-dress'
      'no-name'
      'spring-flora'
      'andi'
      'gig-o835'
      'rie02'
      'rie05'
      'rie11'
      'etretat.ppm'
      'the-hollow-needle-at-etretat.ppm'
      'rouen-cathedral-sunset.ppm'
      'the-houses-of-parliament.ppm'
      'starry-night.ppm'
      'water-lilies-sunset.ppm'
      'gogh.chambre-arles.ppm'
      'gogh.entrance.ppm'
      'gogh.the-night-cafe.ppm'
      'gogh.vegetable-montmartre.ppm'
      'matisse.bonheur-vivre.ppm'
      'matisse.flowers.ppm'
      'matisse.lecon-musique.ppm'
      'modigliani.nude-caryatid.ppm'
      'braque.instruments.ppm'
      'calcoast09.ppm'
      'dodge102.ppm'
      'ernst.anti-pope.ppm'
      'ernst.ubu-imperator.ppm'
      'fighting-forms.ppm'
      'fog25.ppm'
      'geyser27.ppm'
      'gris.josette.ppm'
      'gris.landscape-ceret.ppm'
      'kandinsky.comp-9.ppm'
      'kandinsky.yellow-red-blue.ppm'
      'klee.insula-dulcamara.ppm'
      'nile.ppm'
      'picasso.jfille-chevre.ppm'
      'pollock.lavender-mist.ppm'
      'yngpaint.ppm')
  end
  object cmbPalette2: TComboBox
    Left = 80
    Top = 234
    Width = 177
    Height = 19
    Style = csOwnerDrawFixed
    Color = clBlack
    DropDownCount = 20
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 5
    OnChange = cmbPalette2Change
    OnDrawItem = cmbPalette1DrawItem
    Items.Strings = (
      'south-sea-bather'
      'sky-flesh'
      'blue-bather'
      'no-name'
      'pillows'
      'mauve-splat'
      'facial-treescape 6'
      'fasion-bug'
      'leafy-face'
      'mouldy-sun'
      'sunny-harvest'
      'peach-tree'
      'fire-dragon'
      'ice-dragon'
      'german-landscape'
      'no-name'
      'living-mud-bomb'
      'cars'
      'unhealthy-tan'
      'daffodil'
      'rose'
      'healthy-skin'
      'orange'
      'white-ivy'
      'summer-makeup'
      'glow-buzz'
      'deep-water'
      'afternoon-beach'
      'dim-beach'
      'cloudy-brick'
      'burning-wood'
      'aquatic-garden'
      'no-name'
      'fall-quilt'
      'night-blue-sky'
      'shadow-iris'
      'solid-sky'
      'misty-field'
      'wooden-highlight'
      'jet-tundra'
      'pastel-lime'
      'hell'
      'indian-coast'
      'dentist-decor'
      'greenland'
      'purple-dress'
      'no-name'
      'spring-flora'
      'andi'
      'gig-o835'
      'rie02'
      'rie05'
      'rie11'
      'etretat.ppm'
      'the-hollow-needle-at-etretat.ppm'
      'rouen-cathedral-sunset.ppm'
      'the-houses-of-parliament.ppm'
      'starry-night.ppm'
      'water-lilies-sunset.ppm'
      'gogh.chambre-arles.ppm'
      'gogh.entrance.ppm'
      'gogh.the-night-cafe.ppm'
      'gogh.vegetable-montmartre.ppm'
      'matisse.bonheur-vivre.ppm'
      'matisse.flowers.ppm'
      'matisse.lecon-musique.ppm'
      'modigliani.nude-caryatid.ppm'
      'braque.instruments.ppm'
      'calcoast09.ppm'
      'dodge102.ppm'
      'ernst.anti-pope.ppm'
      'ernst.ubu-imperator.ppm'
      'fighting-forms.ppm'
      'fog25.ppm'
      'geyser27.ppm'
      'gris.josette.ppm'
      'gris.landscape-ceret.ppm'
      'kandinsky.comp-9.ppm'
      'kandinsky.yellow-red-blue.ppm'
      'klee.insula-dulcamara.ppm'
      'nile.ppm'
      'picasso.jfille-chevre.ppm'
      'pollock.lavender-mist.ppm'
      'yngpaint.ppm')
  end
end
