unit frmSecuLearnProc;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

uses
  {$IFNDEF FPC}
  jpeg, Windows,
  {$ELSE}
  LCLIntf, LCLType, LMessages,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, uHTTP,
  Dialogs, MRVCamera, StdCtrls, MRVCamView, ExtCtrls, MRVType, MRVImg, ComCtrls,
  Vcl.OleCtrls, SHDocVw, frmMain, IdMultipartFormData, uConst,
  scControls, scExtControls, RzPanel, RzSplit, scGPControls, scModernControls,
  frmMachineImage, frmSnapshot, uFunction, MRVCore, MRVBitmap, Vcl.Mask,
  scGPExtControls;

type
  TSecuLeranProc = class(TForm)
    RVCamera1: TRVCamera;
    RzSizePanel1: TRzSizePanel;
    pnlResult: TscExPanel;
    GroupBox1: TscGPGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lblDLServer: TLabel;
    btnOn: TButton;
    btnOff: TButton;
    btnSnapShot: TButton;
    cmbVideoResolution: TComboBox;
    cmbCamera: TComboBox;
    btnSendDLServer: TButton;
    btnMachineImageForm: TscGPButton;
    btnSnapshotForm: TscGPButton;
    btnCompareImage: TButton;
    CompareTimer: TTimer;
    seCompareDelay: TscGPSpinEdit;
    cbShowAll: TscGPCheckBox;
    Compare2Timer: TTimer;
    procedure btnOnClick(Sender: TObject);
    procedure btnOffClick(Sender: TObject);
    procedure btnSnapShotClick(Sender: TObject);
    procedure cmbVideoResolutionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmbCameraChange(Sender: TObject);
    procedure btnSendDLServerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSubFormClick(Sender: TObject);
    procedure btnObjInfoClick(Sender: TObject);
    procedure RVCamera1GetImage(Sender: TObject; img: TRVMBitmap);
    procedure btnCompareImageClick(Sender: TObject);
    procedure CompareTimerTimer(Sender: TObject);
    procedure Compare2TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SecuLeranProc: TSecuLeranProc;
  FBmpImage: TBitmap;
  FCount: Integer;
  FMinPoint, FMaxPoint: TPoint;
  FIsChanged: Boolean;

implementation

{$R *.dfm}

procedure TSecuLeranProc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not RVCamera1.IsVideoPlaying or RVCamera1.Aborting then
    Exit;

  if Assigned(FBmpImage) then FreeAndNil(FBmpImage);

  RVCamera1.Abort;
  RVCamera1.WaitForVideo;
end;

procedure TSecuLeranProc.FormCreate(Sender: TObject);
begin
  // Adding names of available webcams to cmbCamera
  RVCamera1.FillVideoDeviceList(cmbCamera.Items);
  if cmbCamera.Items.Count = 0 then
  begin
    // no webcam found
    Main.lblStatusText.Caption := 'No webcam detected';
    btnOn.Enabled := False;
    btnOff.Enabled := False;
    btnSnapShot.Enabled := False;
    cmbVideoResolution.Enabled := False;
    cmbCamera.Enabled := False;
    exit;
  end
  else
  begin
    // selecting the active webcam
    cmbCamera.ItemIndex := RVCamera1.VideoDeviceIndex;
    Main.lblStatusText.Caption := 'Camera: ' + cmbCamera.Text;
  end;

  MachineImage.ManualDock(RzSizePanel1);
  Snapshot.ManualDock(RzSizePanel1);

  MachineImage.Show;
  Snapshot.Show;

  MachineImage.Tag := 1;
  Snapshot.Tag := 1;

  FBmpImage := TBitmap.Create;

  LoadObjColorListFromFile(ExtractFilePath(Application.ExeName) + 'ObjColorList.ini', FObjColorArray);
end;

procedure TSecuLeranProc.RVCamera1GetImage(Sender: TObject; img: TRVMBitmap);
var
  i: Integer;
  minPoint, maxPoint: TPoint;
begin
  if Length(FObjInfoArray) = 0 then Exit;

  for i := 0 to Length(FObjInfoArray)-1 do
  begin
    if not FObjInfoArray[i].BoxVisible then Continue;
    // Get the point of Object for crop box
    minPoint.X := Round(img.GetBitmap.Width * FObjInfoArray[i].Xmin);
    minPoint.Y := Round(img.GetBitmap.Height * FObjInfoArray[i].Ymin);
    maxPoint.X := Round(img.GetBitmap.Width * FObjInfoArray[i].Xmax);
    maxPoint.Y := Round(img.GetBitmap.Height * FObjInfoArray[i].Ymax);

    // ObjColorArray의 색깔이 있을 경우 ObjColor 뿌려줌
    if FObjInfoArray[i].ObjProp.ObjName <> '' then
    begin
      // DrawShape the box on the Image component
      if not Snapshot.Showing then
        DrawShape(img.GetBitmap.Canvas, minPoint, maxPoint, dtRectangle, pmNotXor, FObjInfoArray[i].ObjProp.ObjColor)
      else
        DrawShape(Snapshot.imgSnapshot.Canvas, minPoint, maxPoint, dtRectangle, pmCopy, FObjInfoArray[i].ObjProp.ObjColor);
    end
    else
    begin
      // DrawShape the box on the Image component
      if not Snapshot.Showing then
        DrawShape(img.GetBitmap.Canvas, minPoint, maxPoint, dtRectangle, pmNotXor)
      else
        DrawShape(Snapshot.imgSnapshot.Canvas, minPoint, maxPoint, dtRectangle, pmCopy);
    end;
  end;
  img.UpdateData;
end;

// Starting playing video from the selected webcam
procedure TSecuLeranProc.btnOnClick(Sender: TObject);
begin
  RVCamera1.PlayVideoStream;
end;

// Stopping video from the selected webcam
procedure TSecuLeranProc.btnOffClick(Sender: TObject);
begin
  RVCamera1.Abort;
end;

// Changing webcam
procedure TSecuLeranProc.cmbCameraChange(Sender: TObject);
var
  i:            Integer;
  CamVideoMode: TRVCamVideoMode;
begin
  RVCamera1.VideoDeviceIndex := cmbCamera.ItemIndex;
  Main.lblStatusText.Caption := 'Camera: ' + cmbCamera.Text;
  // adding available webcam modes in cmbVideoResolution
  for i := 0 to RVCamera1.GetCamVideoModeCount - 1 do
  begin
    RVCamera1.GetCamVideoMode(i, CamVideoMode);
    cmbVideoResolution.Items.Append(IntToStr(CamVideoMode.Width) + 'x' +
      IntToStr(CamVideoMode.Height) + ' ' + IntToStr(CamVideoMode.ColorDepth)
      + 'bits '  + CamVideoMode.VideoFormat);
  end;
  // Selecting the current mode
  cmbVideoResolution.ItemIndex := RVCamera1.GetCamVideoModeIndex;
end;

// Changing video mode for the current webcam
procedure TSecuLeranProc.cmbVideoResolutionChange(Sender: TObject);
begin
  RVCamera1.SetCamVideoMode(cmbVideoResolution.ItemIndex);
  cmbVideoResolution.ItemIndex := RVCamera1.GetCamVideoModeIndex;
end;

procedure TSecuLeranProc.CompareTimerTimer(Sender: TObject);
var
  Img: TRVImageWrapper;
  bmp: TBitmap;
  i: Integer;
begin
  CompareTimer.Enabled := False;

  Img := RVCamera1.GetSnapShot;
  bmp := TBitmap.Create;
  try
    try
      bmp.Assign(Img.Bitmap.GetBitmap);
      Snapshot.SetCompareImage(bmp);
    finally
      bmp.Free;
    end;
  finally
    Img.Free;
  end;

  if Round(Snapshot.CompareImages * 100) >= 97 then
  begin
    btnSnapShot.Click;
    btnSendDLServer.Click;
  end
  else
  begin
    for i := 0 to Length(FObjInfoArray)-1 do
      FObjInfoArray[i].BoxVisible := False;
  end;

  CompareTimer.Interval := StrToInt(seCompareDelay.Value.ToString);
  CompareTimer.Enabled := True;
end;

procedure TSecuLeranProc.Compare2TimerTimer(Sender: TObject);
var
  Img: TRVImageWrapper;
  bmp: TBitmap;
begin
  Compare2Timer.Enabled := False;

  Img := RVCamera1.GetSnapShot;
  bmp := TBitmap.Create;
  try
    try
      bmp.Assign(Img.Bitmap.GetBitmap);
      Snapshot.SetCompare2Image(bmp);
    finally
      bmp.Free;
    end;
  finally
    Img.Free;
  end;

  Compare2Timer.Enabled := True;
end;

// Drawing a snapshot in pbSnapShot
procedure TSecuLeranProc.btnSnapShotClick(Sender: TObject);
var
  Img: TRVImageWrapper;
  i: Integer;
begin
  if not RVCamera1.IsVideoPlaying or RVCamera1.Aborting then
    Exit;

  btnSendDLServer.Tag := 0;
  for i := ComponentCount-1 downto 0 do
  begin
    if (Components[i].ClassType = TscGPButton) and (Pos('btnObjInfo', TscGPButton(Components[i]).Name) > 0) then
    begin
      TscGPButton(Components[i]).Parent := nil;
      TscGPButton(Components[i]).Free;
    end;
  end;
  SetLength(FObjInfoArray, 0);

  Img := RVCamera1.GetSnapShot;
  try
    try
      FBmpImage.Assign(Img.Bitmap.GetBitmap);
      Snapshot.SetImage(FBmpImage);
    finally
    end;
  finally
    Img.Free;
  end;
end;

// Send the snapshot to Deep Learning Server
procedure TSecuLeranProc.btnSendDLServerClick(Sender: TObject);
var
  ms: TMemoryStream;
  bmp: TBitmap;
  jpg: TJPEGImage;
  ResString: string;
  UriString, SubStr: string;
  PostStream: TIdMultiPartFormDataStream;
  Splitted: TArray<string>;
  ManCnt, BagCnt: Integer;
  i, j: Integer;
begin
  if (FBmpImage.Width <= 0) and (FBmpImage.Height <= 0) then Exit;
  if btnSendDLServer.Tag = 1 then Exit;
  
  UriString := GetURL;

  PostStream := TIdMultiPartFormDataStream.Create;
  jpg := TJPEGImage.Create;

  try
    jpg.Assign(FBmpImage);
    jpg.SaveToFile(IntToStr(FCount) + '.jpg');
    PostStream.AddFile('file',IntToStr(FCount) + '.jpg',sContentTypeFormData);

    // 전송하는 부분
    try
      ResString := HTTPUploadFile(UriString, PostStream);
    except
      on E: Exception do
      begin
        Exit;
      end;
    end;

    SubStr := ParseTextLogUrl(ResString);
    ParseTextLog(HTTPGet(UriString+SubStr), Self, pnlResult, btnObjInfoClick, cbShowAll.Checked, FObjInfoArray);

    // FObjColorArray 에서 Object색을 선택하여 PenColor에 사용할 Property를 넣어줌
    if Length(FObjColorArray) > 0 then
    begin
      i := 0;
      while i < Length(FObjInfoArray) do
      begin
        for j := 0 to Length(FObjColorArray)-1 do
        begin
          if FObjInfoArray[i].ClassName = FObjColorArray[j].ObjName then
          begin
            FObjInfoArray[i].ObjProp.ObjName := FObjColorArray[j].ObjName;
            FObjInfoArray[i].ObjProp.ObjColor := FObjColorArray[j].ObjColor;
            FObjInfoArray[i].IsNewObj := False;
          end;
        end;
        Inc(i);
      end;
    end;

    // 서버에서 분석된 이미지를 받는 부분..
    btnSendDLServer.Tag := 1;
//    SubStr := ParsePicUrl(ResString);
//    ms := TMemoryStream.Create;
//    bmp := TBitmap.Create;
//    try
//      HTTPGet(UriString+SubStr, ms);
//      if ms.Size > 0 then
//      begin
//        ms.Position := 0;
//        jpg.LoadFromStream(ms);
//        bmp.Assign(jpg);
//        Snapshot.SetImage(bmp);
////        jpg.SaveToFile(IntToStr(FCount) + '.jpg');
//      end;
//    finally
//      bmp.Free;
//      ms.Free;
//    end;
  finally
    PostStream.Free;
    jpg.Free;
  end;
end;

procedure TSecuLeranProc.btnCompareImageClick(Sender: TObject);
var
  Img: TRVImageWrapper;
  bmp: TBitmap;
begin
  if btnCompareImage.Tag = 0 then
  begin
    CompareTimer.Interval := StrToInt(seCompareDelay.Value.ToString);
    CompareTimer.Enabled := True;
    Compare2Timer.Enabled := True;
    btnCompareImage.Caption := 'Working';
    btnCompareImage.Tag := 1;
  end
  else
  begin
    CompareTimer.Enabled := False;
    Compare2Timer.Enabled := False;
    btnCompareImage.Caption := 'Compare Image';
    btnCompareImage.Tag := 0;
  end;

end;

procedure TSecuLeranProc.btnSubFormClick(Sender: TObject);
var
  frm: TForm;
begin
  if Pos('MachineImage', TscGPButton(Sender).Name) > 0 then
    frm := MachineImage
  else if Pos('Snapshot', TscGPButton(Sender).Name) > 0 then
    frm := Snapshot;

  if frm.Tag = 0 then
  begin
    frm.Show;
    frm.Tag := 1;
  end
  else
  begin
    frm.Hide;
    frm.Tag := 0;
  end;
end;

// ObjInfo OnClick Event
procedure TSecuLeranProc.btnObjInfoClick(Sender: TObject);
var
  i, BtnNumber: Integer;
  BtnName: string;
  minPoint, maxPoint: TPoint;
  tmp1, tmp2: Integer;
begin
  // Matching Button Number with FObjInfoArray
  BtnName := TscGPButton(Sender).Name;
  TryStrToInt(StringReplace(BtnName, 'btnObjInfo', '', [rfReplaceAll]), BtnNumber);
  for i := 0 to Length(FObjInfoArray)-1 do
    if FObjInfoArray[i].Seq = BtnNumber then Break;

  // Get the point of Object for crop box
  FObjInfoArray[i].BoxVisible := not FObjInfoArray[i].BoxVisible;
end;

end.
