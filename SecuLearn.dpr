program SecuLearn;

uses
  Windows,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  frmEditImage in 'src\frmEditImage.pas' {EditImage},
  frmMain in 'src\frmMain.pas' {Main},
  uConst in 'src\uConst.pas',
  uFunction in 'src\uFunction.pas',
  uVersionInfo in 'src\uVersionInfo.pas',
  frmSecuLearnProc in 'src\frmSecuLearnProc.pas' {SecuLeranProc},
  uHTTP in 'src\uHTTP.pas',
  AARotate in 'src\AARotate.pas',
  AARotate_Fast in 'src\AARotate_Fast.pas',
  uGDIUnit in 'src\uGDIUnit.pas',
  frmMachineImage in 'src\frmMachineImage.pas' {MachineImage},
  frmSnapshot in 'src\frmSnapshot.pas' {Snapshot},
  frmRegisterObject in 'src\frmRegisterObject.pas' {RegisterObject};

{$R *.res}

var
  hm: THandle;
begin
  hm := CreateMutex(Nil, False, 'SecuLearnMutex');
  if WaitforSingleObject(hm, 0) <> Wait_TimeOut then
  begin
    Application.Initialize;
    Application.CreateForm(TMain, Main);
    Application.Run;
  end;
end.
