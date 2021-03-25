unit frmMachineImage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MRVCamView, Vcl.ExtCtrls, scControls, scModernControls,
  scGPControls, Vcl.AppEvnts, MRVType, MRVCamera, Vcl.StdCtrls;

type
  TMachineImage = class(TForm)
    Panel1: TPanel;
    RVCamView1: TRVCamView;
    btnFloat: TscGPGlyphButton;
    ApplicationEvents1: TApplicationEvents;
    procedure btnFloatClick(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    UndockedLeft: Integer;
    UndockedTop: Integer;
    { Private declarations }
  public
    procedure WMNCLButtonDown(var Message : TMessage); message WM_NCLBUTTONDOWN;
    { Public declarations }
  end;

function MachineImage: TMachineImage;

//var
//  MachineImage: TMachineImage;

implementation

{$R *.dfm}

var
  frm: TMachineImage;

function MachineImage: TMachineImage;
begin
  if(not Assigned(frm))then frm := TMachineImage.Create(Application);
  Result := frm;
end;

procedure TMachineImage.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  btnFloat.Visible := not Floating;
end;

procedure TMachineImage.btnFloatClick(Sender: TObject);
begin
  ManualFloat(Rect(UndockedTop, UndockedLeft, UndockedLeft + UndockWidth, UndockedTop + UndockHeight));
end;

procedure TMachineImage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TMachineImage.FormCreate(Sender: TObject);
begin
  UndockedLeft := Left;
  UndockedTop := Top;
end;

procedure TMachineImage.FormDestroy(Sender: TObject);
begin
  frm := nil;
end;

procedure TMachineImage.WMNCLButtonDown(var Message: TMessage);
begin
  inherited;
  UndockedLeft := Left;
  UndockedTop := Top;
end;

end.
