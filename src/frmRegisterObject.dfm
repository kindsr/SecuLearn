object RegisterObject: TRegisterObject
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'RegisterObject'
  ClientHeight = 435
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #45208#45588#44256#46357#53076#46377
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 287
    Top = 40
    Width = 178
    Height = 3
    Brush.Color = clWindowFrame
    Pen.Color = clWindowFrame
  end
  object btnAdd: TscGPButton
    Left = 287
    Top = 8
    Width = 98
    Height = 26
    TabOrder = 0
    TabStop = True
    OnClick = btnAddClick
    Animation = False
    Caption = 'Add/Update'
    CanFocused = True
    CustomDropDown = False
    Margin = -1
    Spacing = 1
    Layout = blGlyphLeft
    ImageIndex = -1
    ImageMargin = 0
    TransparentBackground = True
    Options.NormalColor = clBtnFace
    Options.HotColor = clBtnFace
    Options.PressedColor = clBtnShadow
    Options.FocusedColor = clBtnFace
    Options.DisabledColor = clBtnFace
    Options.NormalColorAlpha = 255
    Options.HotColorAlpha = 255
    Options.PressedColorAlpha = 255
    Options.FocusedColorAlpha = 255
    Options.DisabledColorAlpha = 255
    Options.FrameNormalColor = clBtnShadow
    Options.FrameHotColor = clHighlight
    Options.FramePressedColor = clHighlight
    Options.FrameFocusedColor = clHighlight
    Options.FrameDisabledColor = clBtnShadow
    Options.FrameWidth = 1
    Options.FrameNormalColorAlpha = 255
    Options.FrameHotColorAlpha = 255
    Options.FramePressedColorAlpha = 255
    Options.FrameFocusedColorAlpha = 255
    Options.FrameDisabledColorAlpha = 255
    Options.FontNormalColor = clBtnText
    Options.FontHotColor = clBtnText
    Options.FontPressedColor = clBtnText
    Options.FontFocusedColor = clBtnText
    Options.FontDisabledColor = clBtnShadow
    Options.ShapeFillGradientAngle = 90
    Options.ShapeFillGradientPressedAngle = -90
    Options.ShapeCornerRadius = 10
    Options.ShapeStyle = scgpRect
    Options.ArrowSize = 9
    Options.StyleColors = True
    HotImageIndex = -1
    FocusedImageIndex = -1
    PressedImageIndex = -1
    UseGalleryMenuImage = False
    UseGalleryMenuCaption = False
    ScaleMarginAndSpacing = False
    WidthWithCaption = 0
    WidthWithoutCaption = 0
    RepeatClick = False
    RepeatClickInterval = 100
    GlowEffect.Enabled = False
    GlowEffect.Color = clHighlight
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    GlowEffect.HotColor = clNone
    GlowEffect.PressedColor = clNone
    GlowEffect.FocusedColor = clNone
    GlowEffect.PressedGlowSize = 7
    GlowEffect.PressedAlphaValue = 255
    GlowEffect.States = [scsHot, scsPressed, scsFocused]
    ImageGlow = True
    ShowGalleryMenuFromTop = False
    ShowGalleryMenuFromRight = False
    ShowMenuArrow = True
    ShowFocusRect = True
    Down = False
    GroupIndex = 0
    AllowAllUp = False
  end
  object btnDelete: TscGPButton
    Left = 391
    Top = 8
    Width = 74
    Height = 26
    TabOrder = 1
    TabStop = True
    OnClick = btnDeleteClick
    Animation = False
    Caption = 'Delete'
    CanFocused = True
    CustomDropDown = False
    Margin = -1
    Spacing = 1
    Layout = blGlyphLeft
    ImageIndex = -1
    ImageMargin = 0
    TransparentBackground = True
    Options.NormalColor = clBtnFace
    Options.HotColor = clBtnFace
    Options.PressedColor = clBtnShadow
    Options.FocusedColor = clBtnFace
    Options.DisabledColor = clBtnFace
    Options.NormalColorAlpha = 255
    Options.HotColorAlpha = 255
    Options.PressedColorAlpha = 255
    Options.FocusedColorAlpha = 255
    Options.DisabledColorAlpha = 255
    Options.FrameNormalColor = clBtnShadow
    Options.FrameHotColor = clHighlight
    Options.FramePressedColor = clHighlight
    Options.FrameFocusedColor = clHighlight
    Options.FrameDisabledColor = clBtnShadow
    Options.FrameWidth = 1
    Options.FrameNormalColorAlpha = 255
    Options.FrameHotColorAlpha = 255
    Options.FramePressedColorAlpha = 255
    Options.FrameFocusedColorAlpha = 255
    Options.FrameDisabledColorAlpha = 255
    Options.FontNormalColor = clBtnText
    Options.FontHotColor = clBtnText
    Options.FontPressedColor = clBtnText
    Options.FontFocusedColor = clBtnText
    Options.FontDisabledColor = clBtnShadow
    Options.ShapeFillGradientAngle = 90
    Options.ShapeFillGradientPressedAngle = -90
    Options.ShapeCornerRadius = 10
    Options.ShapeStyle = scgpRect
    Options.ArrowSize = 9
    Options.StyleColors = True
    HotImageIndex = -1
    FocusedImageIndex = -1
    PressedImageIndex = -1
    UseGalleryMenuImage = False
    UseGalleryMenuCaption = False
    ScaleMarginAndSpacing = False
    WidthWithCaption = 0
    WidthWithoutCaption = 0
    RepeatClick = False
    RepeatClickInterval = 100
    GlowEffect.Enabled = False
    GlowEffect.Color = clHighlight
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    GlowEffect.HotColor = clNone
    GlowEffect.PressedColor = clNone
    GlowEffect.FocusedColor = clNone
    GlowEffect.PressedGlowSize = 7
    GlowEffect.PressedAlphaValue = 255
    GlowEffect.States = [scsHot, scsPressed, scsFocused]
    ImageGlow = True
    ShowGalleryMenuFromTop = False
    ShowGalleryMenuFromRight = False
    ShowMenuArrow = True
    ShowFocusRect = True
    Down = False
    GroupIndex = 0
    AllowAllUp = False
  end
  object lblName: TscGPLabel
    Left = 287
    Top = 56
    Width = 50
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    DragForm = False
    ContentMarginLeft = 5
    ContentMarginRight = 5
    ContentMarginTop = 5
    ContentMarginBottom = 5
    FrameWidth = 1
    FillColor = clBtnText
    FillColorAlpha = 20
    FrameColor = clBtnText
    FrameColorAlpha = 40
    FrameRadius = 5
    GlowEffect.Enabled = False
    GlowEffect.Color = clBtnShadow
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    AutoSize = False
    Alignment = taRightJustify
    Caption = 'Name'
  end
  object edtName: TscGPEdit
    Left = 343
    Top = 56
    Width = 122
    Height = 23
    AutoSize = False
    Options.NormalColor = clWindow
    Options.HotColor = clWindow
    Options.FocusedColor = clWindow
    Options.DisabledColor = clWindow
    Options.NormalColorAlpha = 200
    Options.HotColorAlpha = 255
    Options.FocusedColorAlpha = 255
    Options.DisabledColorAlpha = 150
    Options.FrameNormalColor = clBtnText
    Options.FrameHotColor = clHighlight
    Options.FrameFocusedColor = clHighlight
    Options.FrameDisabledColor = clBtnText
    Options.FrameWidth = 1
    Options.FrameNormalColorAlpha = 100
    Options.FrameHotColorAlpha = 255
    Options.FrameFocusedColorAlpha = 255
    Options.FrameDisabledColorAlpha = 50
    Options.FontNormalColor = clWindowText
    Options.FontHotColor = clWindowText
    Options.FontFocusedColor = clWindowText
    Options.FontDisabledColor = clGrayText
    Options.ShapeFillGradientAngle = 90
    Options.ShapeCornerRadius = 10
    Options.ShapeStyle = scgpessRect
    Options.ScaleFrameWidth = False
    Options.StyleColors = True
    ContentMarginLeft = 5
    ContentMarginRight = 5
    ContentMarginTop = 5
    ContentMarginBottom = 5
    PromptTextColor = clNone
    Transparent = True
    LeftButton.Kind = scgpebCustom
    LeftButton.Enabled = True
    LeftButton.Visible = False
    LeftButton.ImageIndex = -1
    LeftButton.ImageHotIndex = -1
    LeftButton.ImagePressedIndex = -1
    LeftButton.RepeatClick = False
    LeftButton.RepeatClickInterval = 200
    LeftButton.ShowHint = False
    LeftButton.GlyphColor = clWindowText
    LeftButton.GlyphColorAlpha = 180
    LeftButton.GlyphColorHotAlpha = 240
    LeftButton.GlyphColorPressedAlpha = 150
    LeftButton.GlyphThickness = 2
    RightButton.Kind = scgpebCustom
    RightButton.Enabled = True
    RightButton.Visible = False
    RightButton.ImageIndex = -1
    RightButton.ImageHotIndex = -1
    RightButton.ImagePressedIndex = -1
    RightButton.RepeatClick = False
    RightButton.RepeatClickInterval = 200
    RightButton.ShowHint = False
    RightButton.GlyphColor = clWindowText
    RightButton.GlyphColorAlpha = 180
    RightButton.GlyphColorHotAlpha = 240
    RightButton.GlyphColorPressedAlpha = 150
    RightButton.GlyphThickness = 2
    Text = ''
    Color = clBtnFace
    TabOrder = 3
    TextHint = 'Object Name Here'
  end
  object lblColor: TscGPLabel
    Left = 287
    Top = 85
    Width = 50
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    DragForm = False
    ContentMarginLeft = 5
    ContentMarginRight = 5
    ContentMarginTop = 5
    ContentMarginBottom = 5
    FrameWidth = 1
    FillColor = clBtnText
    FillColorAlpha = 20
    FrameColor = clBtnText
    FrameColorAlpha = 40
    FrameRadius = 5
    GlowEffect.Enabled = False
    GlowEffect.Color = clBtnShadow
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    AutoSize = False
    Alignment = taRightJustify
    Caption = 'Color'
  end
  object btnColorPicker: TscGPButton
    Left = 343
    Top = 85
    Width = 122
    Height = 23
    TabOrder = 5
    TabStop = True
    OnClick = btnColorPickerClick
    Animation = False
    CanFocused = True
    CustomDropDown = False
    Margin = -1
    Spacing = 1
    Layout = blGlyphLeft
    ImageIndex = -1
    ImageMargin = 0
    TransparentBackground = True
    Options.NormalColor = clBtnFace
    Options.HotColor = clBtnFace
    Options.PressedColor = clBtnShadow
    Options.FocusedColor = clBtnFace
    Options.DisabledColor = clBtnFace
    Options.NormalColorAlpha = 255
    Options.HotColorAlpha = 255
    Options.PressedColorAlpha = 255
    Options.FocusedColorAlpha = 255
    Options.DisabledColorAlpha = 255
    Options.FrameNormalColor = clBtnShadow
    Options.FrameHotColor = clHighlight
    Options.FramePressedColor = clHighlight
    Options.FrameFocusedColor = clHighlight
    Options.FrameDisabledColor = clBtnShadow
    Options.FrameWidth = 1
    Options.FrameNormalColorAlpha = 255
    Options.FrameHotColorAlpha = 255
    Options.FramePressedColorAlpha = 255
    Options.FrameFocusedColorAlpha = 255
    Options.FrameDisabledColorAlpha = 255
    Options.FontNormalColor = clBtnText
    Options.FontHotColor = clBtnText
    Options.FontPressedColor = clBtnText
    Options.FontFocusedColor = clBtnText
    Options.FontDisabledColor = clBtnShadow
    Options.ShapeFillGradientAngle = 90
    Options.ShapeFillGradientPressedAngle = -90
    Options.ShapeCornerRadius = 10
    Options.ShapeStyle = scgpRect
    Options.ArrowSize = 9
    Options.StyleColors = True
    HotImageIndex = -1
    FocusedImageIndex = -1
    PressedImageIndex = -1
    UseGalleryMenuImage = False
    UseGalleryMenuCaption = False
    ScaleMarginAndSpacing = False
    WidthWithCaption = 0
    WidthWithoutCaption = 0
    RepeatClick = False
    RepeatClickInterval = 100
    GlowEffect.Enabled = False
    GlowEffect.Color = clHighlight
    GlowEffect.AlphaValue = 255
    GlowEffect.GlowSize = 7
    GlowEffect.Offset = 0
    GlowEffect.Intensive = True
    GlowEffect.StyleColors = True
    GlowEffect.HotColor = clNone
    GlowEffect.PressedColor = clNone
    GlowEffect.FocusedColor = clNone
    GlowEffect.PressedGlowSize = 7
    GlowEffect.PressedAlphaValue = 255
    GlowEffect.States = [scsHot, scsPressed, scsFocused]
    ImageGlow = True
    ShowGalleryMenuFromTop = False
    ShowGalleryMenuFromRight = False
    ShowMenuArrow = True
    ShowFocusRect = True
    Down = False
    GroupIndex = 0
    AllowAllUp = False
  end
  object lbColorList: TListBox
    Left = 0
    Top = 0
    Width = 281
    Height = 435
    Style = lbOwnerDrawFixed
    Align = alLeft
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = #45208#45588#44256#46357#53076#46377
    Font.Style = []
    ItemHeight = 24
    ParentFont = False
    TabOrder = 6
    OnClick = lbColorListClick
    OnDrawItem = lbColorListDrawItem
  end
  object scColorDialog1: TscColorDialog
    Scaled = True
    AnimationOnControls = False
    Color = clBlack
    Left = 240
    Top = 32
  end
end
