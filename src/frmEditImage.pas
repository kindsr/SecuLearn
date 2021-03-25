unit frmEditImage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  scControls, scGPControls, uGDIUnit, AARotate, AARotate_Fast, jpeg, uFunction,
  acImage, uConst, System.IniFiles, System.StrUtils;

type
  TDrawingTool = (dtLine, dtRectangle, dtEllipse, dtRoundRect);

  TPictureArray = array of TPicture;

  TEditImage = class(TForm)
    pnlEditImage: TPanel;
    btnInit: TButton;
    btnSaveAndClose: TButton;
    btnClose: TButton;
    lblMousePoint: TLabel;
    ScrollBox1: TScrollBox;
    lblOrigin: TLabel;
    imgEdit: TsImage;
    lbColorList: TListBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveAndCloseClick(Sender: TObject);
    procedure btnInitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgEditMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure imgEditMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure lbColorListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnObjInfoClick(Sender: TObject);
    procedure lbColorListClick(Sender: TObject);
  private
    procedure SavePicture;
    procedure UndoPicture;
    procedure SetImageSize;
    { Private declarations }
  public
    BrushStyle: TBrushStyle;
    PenStyle: TPenStyle;
    PenWide: Integer;
    Drawing: Boolean;
    Origin, MovePt: TPoint;
    DrawingTool: TDrawingTool;
    paPictures: TPictureArray;
    CropBeginPoint, CropEndPoint: TPoint;
    BoxBeginPoint, BoxEndPoint: TPoint;
    RotatedCount: Integer;
    procedure SaveStyles;
    procedure RestoreStyles;
    procedure DrawShape(TopLeft, BottomRight: TPoint; AMode: TPenMode);
    procedure SetImage(bmp: TBitmap); overload;
    procedure SetImage(bmp: TBitmap; BoxArray: TObjInfoArray); overload;
    procedure SetImage(jpg: TJPEGImage); overload;
    { Public declarations }
  end;

var
  EditImage: TEditImage;
  FSelectedObject: Boolean;
  FAddedObjectArray: TObjInfoArray;

implementation

{$R *.dfm}

procedure TEditImage.btnCloseClick(Sender: TObject);
begin
  if (Length(paPictures) = 0) or
     ((Length(paPictures) > 0) and (MessageDlg('The image has been changed. Do you really want to close this form?', mtConfirmation, mbYesNo, 0) = mrYes))  then
    ModalResult := mrCancel
  else
    Exit;
end;

procedure TEditImage.btnInitClick(Sender: TObject);
var
  i: Integer;
begin
  imgEdit.Picture.Assign(paPictures[0]);

  for i := Length(paPictures) - 1 downto 1 do
  begin
    paPictures[Length(paPictures) - 1].Free;
    SetLength(paPictures, Length(paPictures) - 1);
  end;
end;

procedure TEditImage.btnSaveAndCloseClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TEditImage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TEditImage.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  SetImageSize;
  Position := poScreenCenter;

  Self.DoubleBuffered := True; // to reduce flickering...
  imgEdit.Stretch := False;
  RotatedCount := 0;

  lbColorList.Items.BeginUpdate;
  for i := 0 to Length(FObjColorArray)-1 do
    lbColorList.Items.AddObject(FObjColorArray[i].ObjName, Pointer(FObjColorArray[i].ObjColor));
  lbColorList.Items.EndUpdate;

  FSelectedObject := False;
end;

procedure TEditImage.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) then
    case Key of
      90:
        UndoPicture;
      83:
        btnSaveAndClose.Click; // Ctrl+S
      73:
        btnInit.Click;         // Ctrl+i
    end;

//  if Key = 49 then btnCrop.OnClick(nil);
//  if Key = 50 then btnBox.OnClick(nil);
end;

procedure TEditImage.imgEditMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    SavePicture;
    with imgEdit, Canvas do
    begin
      Brush.Color := clBtnFace;
      Brush.Style := bsClear;
      Pen.Style := psSolid;
      Pen.Color := clBlack;
      Pen.Width := 2;
      BoxBeginPoint := Point(X, Y);
    end;
    DrawingTool := dtRectangle;

    Drawing := True;
    imgEdit.Canvas.MoveTo(X, Y);
    Origin := Point(X, Y);
    MovePt := Origin;
//    lblOrigin.Caption := Format('Origin: (%d, %d)', [X, Y]);
  end
  else if Button = mbRight then
  begin
    UndoPicture;
    SetImageSize;
  end;
end;

procedure TEditImage.imgEditMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  ARect: TRect;
begin
  lblMousePoint.Caption := Format('Point : (%d, %d)', [X, Y]);
  if Drawing then
  begin
    DrawShape(Origin, MovePt, pmNotXor);
    MovePt := Point(X, Y);
    DrawShape(Origin, MovePt, pmNotXor);
    lblOrigin.Caption := Format('Box W,H: (%d, %d)', [Abs(X-Origin.X), Abs(Y-Origin.Y)]);
  end;
end;

procedure TEditImage.imgEditMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  bmpCrop, bmpRotated: TBitmap;
  dwOffset: Integer;
begin
  if Button = mbLeft then
  begin
    if Drawing then
    begin
      DrawShape(Origin, Point(X, Y), pmCopy);
      Drawing := False;
    end;
    BoxEndPoint := Point(X, Y);

    // Added Object Info array
    SetLength(FAddedObjectArray, Length(FAddedObjectArray) + 1);
    FAddedObjectArray[Length(FAddedObjectArray)-1].Seq := Length(FObjInfoArray)+Length(FAddedObjectArray);
    if lbColorList.ItemIndex > -1 then
      FAddedObjectArray[Length(FAddedObjectArray)-1].ClassName := lbColorList.Items[lbColorList.ItemIndex];
    FAddedObjectArray[Length(FAddedObjectArray)-1].Xmin := Origin.X / ScrollBox1.Width;
    FAddedObjectArray[Length(FAddedObjectArray)-1].Ymin := Origin.Y / ScrollBox1.Height;
    FAddedObjectArray[Length(FAddedObjectArray)-1].Xmax := BoxEndPoint.X / ScrollBox1.Width;
    FAddedObjectArray[Length(FAddedObjectArray)-1].Ymax := BoxEndPoint.Y / ScrollBox1.Height;
    FAddedObjectArray[Length(FAddedObjectArray)-1].BoxVisible := True;
    if lbColorList.ItemIndex > -1 then
      FAddedObjectArray[Length(FAddedObjectArray)-1].ObjProp.ObjName := lbColorList.Items[lbColorList.ItemIndex];
    if lbColorList.ItemIndex > -1 then
      FAddedObjectArray[Length(FAddedObjectArray)-1].ObjProp.ObjColor := TColor(lbColorList.Items.Objects[lbColorList.ItemIndex]);
    if FAddedObjectArray[Length(FAddedObjectArray)-1].ObjProp.ObjName <> '' then
      FAddedObjectArray[Length(FAddedObjectArray)-1].IsNewObj := False
    else
      FAddedObjectArray[Length(FAddedObjectArray)-1].IsNewObj := True;

    SetLength(FObjInfoArray, Length(FObjInfoArray) + 1);
    FObjInfoArray[Length(FObjInfoArray)-1] := FAddedObjectArray[Length(FAddedObjectArray)-1];

    MakeButton(Self, pnlEditImage, alBottom, btnObjInfoClick, FAddedObjectArray[Length(FAddedObjectArray)-1].ClassName + '::' + IntToStr(FAddedObjectArray[Length(FAddedObjectArray)-1].Seq), FAddedObjectArray[Length(FAddedObjectArray)-1]);
  end;
end;

procedure TEditImage.lbColorListClick(Sender: TObject);
begin
  if not FSelectedObject then Exit;

end;

procedure TEditImage.lbColorListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with Control as TListBox do
  begin
//    Canvas.Brush.Style := bsSolid;
//    Canvas.Brush.Color := TColor(Items.Objects[Index]);
//    Canvas.Pen.Style := psClear;
//    Canvas.FillRect(Rect);
    Canvas.Font.Color := TColor(Items.Objects[Index]);
    Canvas.TextOut(Rect.Left + 2, Rect.Top, Items[Index]);
  end;
end;

procedure TEditImage.DrawShape(TopLeft, BottomRight: TPoint; AMode: TPenMode);
begin
  with imgEdit.Canvas do
  begin
    Pen.Mode := AMode;
    case DrawingTool of
      dtLine:
        begin
          imgEdit.Canvas.MoveTo(TopLeft.X, TopLeft.Y);
          imgEdit.Canvas.LineTo(BottomRight.X, BottomRight.Y);
        end;
      dtRectangle:
        begin
          imgEdit.Canvas.Rectangle(TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y);
        end;
      dtEllipse:
        imgEdit.Canvas.Ellipse(TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y);
      dtRoundRect:
        imgEdit.Canvas.RoundRect(TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y, (TopLeft.X - BottomRight.X) div 2, (TopLeft.Y - BottomRight.Y) div 2);
    end;
  end;
end;

procedure TEditImage.RestoreStyles;
begin
  with imgEdit.Canvas do
  begin
    BrushStyle := Brush.Style;
    PenStyle := Pen.Style;
    PenWide := Pen.Width;
  end;
end;

procedure TEditImage.SaveStyles;
begin
  with imgEdit.Canvas do
  begin
    Brush.Style := BrushStyle;
    Pen.Style := PenStyle;
    Pen.Width := PenWide;
  end;
end;

procedure TEditImage.SavePicture;
begin
  Setlength(paPictures, Length(paPictures) + 1);
  paPictures[Length(paPictures) - 1] := TPicture.Create;
  paPictures[Length(paPictures) - 1].Assign(imgEdit.Picture);
end;

procedure TEditImage.UndoPicture;
begin
  if Length(paPictures) <= 1 then
  begin
    imgEdit.Picture.Assign(paPictures[0]);
    Exit;
  end;

  SaveStyles;
  imgEdit.Picture.Assign(paPictures[Length(paPictures) - 1]);
  RestoreStyles;
  paPictures[Length(paPictures) - 1].Free;
  SetLength(paPictures, Length(paPictures) - 1);
end;

procedure TEditImage.SetImageSize;
begin
  ClientWidth := imgEdit.Picture.Width + pnlEditImage.Width + 5;
  ClientHeight := imgEdit.Picture.Height + 5;
  Invalidate;
end;

procedure TEditImage.SetImage(bmp: TBitmap);
begin
  imgEdit.Picture.Bitmap.Assign(bmp);
  SetImageSize;
end;

procedure TEditImage.SetImage(bmp: TBitmap; BoxArray: TObjInfoArray);
var
  i: Integer;
begin
  for i := 0 to Length(BoxArray)-1 do
  begin
    MakeButton(Self, pnlEditImage, alBottom, btnObjInfoClick, BoxArray[i].ClassName + '::' + IntToStr(BoxArray[i].Seq), BoxArray[i]);
  end;

  imgEdit.Picture.Bitmap.Assign(bmp);
  SetImageSize;
end;

procedure TEditImage.SetImage(jpg: TJPEGImage);
begin
  imgEdit.Picture.Assign(jpg);
  SetImageSize;
end;

// ObjInfo OnClick Event
procedure TEditImage.btnObjInfoClick(Sender: TObject);
var
  i, BtnNumber: Integer;
  BtnName: string;
  minPoint, maxPoint: TPoint;
  Selected, tmp2: Integer;
  ObjLabel: TComponent;
begin
  // Matching Button Number with FObjInfoArray
  BtnName := TscGPButton(Sender).Name;
  TryStrToInt(StringReplace(BtnName, 'btnObjInfo', '', [rfReplaceAll]), BtnNumber);
  for i := 0 to Length(FObjInfoArray)-1 do
  begin
    if FObjInfoArray[i].Seq = BtnNumber then Selected := i;
    ObjLabel := FindComponent('lblObjInfo'+ IntToStr(FObjInfoArray[i].Seq));
    if Assigned(ObjLabel) then ObjLabel.Free;
  end;

  // Get the point of Object for crop box
  MakeLabel(Self, ScrollBox1, nil, 'Selected', FObjInfoArray[Selected]);
end;


end.

