unit frmSnapshot;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.AppEvnts, scControls, scModernControls,
  scGPControls, MRVCamView, jpeg, acImage, uFunction, ieview, imageenview, Vcl.StdCtrls, hyiedefs,
  uConst;

type
  TSnapshot = class(TForm)
    ApplicationEvents1: TApplicationEvents;
    Panel1: TPanel;
    btnFloat: TscGPGlyphButton;
    imgSnapshot: TsImage;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFloatClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgSnapshotClick(Sender: TObject);
  private
    UndockedLeft: Integer;
    UndockedTop: Integer;
    { Private declarations }
  public
    procedure SetImage(bmp: TBitmap); overload;
    procedure SetImage(jpg: TJPEGImage); overload;
    procedure SetCompareImage(bmp: TBitmap);
    procedure SetCompare2Image(bmp: TBitmap);
    procedure WMNCLButtonDown(var Message : TMessage); message WM_NCLBUTTONDOWN;
    function CompareImages: Double;
    { Public declarations }
  end;

function Snapshot: TSnapshot;

//var
//  Snapshot: TSnapshot;

implementation

uses frmSecuLearnProc, frmEditImage;

{$R *.dfm}

var
  frm: TSnapshot;
  CompareImage, CompareImage2: TImageEnView;

function Snapshot: TSnapshot;
begin
  if(not Assigned(frm))then frm := TSnapshot.Create(Application);
  Result := frm;
end;

procedure TSnapshot.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  btnFloat.Visible := not Floating;
end;

procedure TSnapshot.btnFloatClick(Sender: TObject);
begin
  ManualFloat(Rect(UndockedTop, UndockedLeft, UndockedLeft + UndockWidth, UndockedTop + UndockHeight));
end;

procedure TSnapshot.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSnapshot.FormCreate(Sender: TObject);
begin
  UndockedLeft := Left;
  UndockedTop := Top;
  CompareImage := TImageEnView.Create(Self);
  CompareImage.Parent := Self;
  CompareImage.Visible := False;
  CompareImage.AutoFit := True;
  CompareImage.ScrollBars := ssNone;
  CompareImage.Width := 420;
  CompareImage.Height := 340;

  CompareImage2 := TImageEnView.Create(Self);
  CompareImage2.Parent := Self;
  CompareImage2.Visible := False;
  CompareImage2.AutoFit := True;
  CompareImage2.ScrollBars := ssNone;
  CompareImage2.Width := 420;
  CompareImage2.Height := 340;
end;

procedure TSnapshot.FormDestroy(Sender: TObject);
begin
  frm := nil;
  if Assigned(CompareImage) then CompareImage.Free;
end;

procedure TSnapshot.imgSnapshotClick(Sender: TObject);
begin
  if ((Sender as TsImage).Picture.Width = 0) and ((Sender as TsImage).Picture.Height = 0) then
    Exit;

  SecuLeranProc.CompareTimer.Enabled := False;
  SecuLeranProc.Compare2Timer.Enabled := False;
  SecuLeranProc.btnCompareImage.Caption := 'Compare Image';
  SecuLeranProc.btnCompareImage.Tag := 0;

  EditImage := TEditImage.Create(Self);

  try
    with EditImage do
    begin
//      imgEdit.Picture := (Sender as TsImage).Picture;
      EditImage.SetImage((Sender as TsImage).Picture.Bitmap, FObjInfoArray);
      WaitSleep(1000);
      if ShowModal = mrOk then
      begin
        (Sender as TsImage).Picture.Bitmap := imgEdit.Picture.Bitmap;

        if (Sender as TsImage).Name = 'imgSnapshot' then
        begin
//          ptLeftBegin := CropBeginPoint;
//          ptLeftEnd := CropEndPoint;
//          ptLeftBoxBegin := BoxBeginPoint;
//          ptLeftBoxEnd := BoxEndPoint;
//          iRotatedCntLeft := RotatedCount;
//          sLog := '정면이미지 Crop: Begin(%d,%d) End(%d,%d) :: Box: Begin(%d,%d) End(%d,%d)';
//          if RotatedCount > 0 then
//            sLog := sLog + ' :: Rotated.';
//          mmLog.Lines.Add(Format(sLog, [CropBeginPoint.X, CropBeginPoint.Y, CropEndPoint.X, CropEndPoint.Y, BoxBeginPoint.X, BoxBeginPoint.Y, BoxEndPoint.X, BoxEndPoint.Y]));
        end;
      end;
    end;
  finally
    EditImage.Free;
  end;
end;

procedure TSnapshot.SetImage(bmp: TBitmap);
begin
//  imgSnapshot.Bitmap.Assign(bmp);
//  imgSnapshot.Update;
  imgSnapshot.Picture.Bitmap.Assign(bmp);
end;

procedure TSnapshot.SetImage(jpg: TJPEGImage);
begin
//  imgSnapshot.Assign(jpg);
//  imgSnapshot.Update;
  imgSnapshot.Picture.Assign(jpg);
end;

procedure TSnapshot.SetCompareImage(bmp: TBitmap);
begin
  CompareImage.Bitmap.Assign(bmp);
  CompareImage.Update;
//  imgSnapshot.Picture.Bitmap.Assign(bmp);
end;

procedure TSnapshot.SetCompare2Image(bmp: TBitmap);
begin
  CompareImage2.Bitmap.Assign(bmp);
  CompareImage2.Update;
//  imgSnapshot.Picture.Bitmap.Assign(bmp);
end;

procedure TSnapshot.WMNCLButtonDown(var Message: TMessage);
begin
  inherited;
  UndockedLeft := Left;
  UndockedTop := Top;
end;

function TSnapshot.CompareImages : Double;
var
  ww, hh: integer;
begin
  // adjust sizes (make ImageEnView1=ImageEnView2)
  ww := CompareImage2.Bitmap.Width;
  hh := CompareImage2.Bitmap.Height;
  if (ww <> CompareImage.Bitmap.Width) or (hh <> CompareImage.Bitmap.Height) then
    CompareImage.Proc.Resample(ww, hh, rfNone);
  Result := CompareImage2.Proc.CompareWith(CompareImage.IEBitmap, nil);
end;

end.
