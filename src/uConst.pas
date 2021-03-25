unit uConst;

interface

uses
  DB, Graphics;

const
  FORM_MI = 'TMachineImage';
  FORM_SS = 'TSnapshot';

type
  TClearArea = (caAll, caAction, caLog, caImage, caUpload);
  TActFunction = (afCount, afPreCount, afMoveFile, afResize, afResizeAll,
                  afRenameOnly, afSeperate, afPackage, afUploadImage, afDevide,
                  afCompWH, afProgressCount, afLoadImage);

type
  TColumnInfo = record
    colName: string;
    colType: TFieldType;
    colLength: Integer;
    blobFinish: Boolean;
  end;

  TInfoTable = record
    tableName: string;
    colInfo: array of TColumnInfo;
    colCount: Integer;
    blobCount: Integer;
  end;

type
  TConfigInfo = record
    OverlayMode: Boolean;
    Animation: Boolean;
    CompactWidth: Integer;
    SkinComboIndex: Integer;
    Maximize: Boolean;
    Sizable: Boolean;
    StayOnTop: Boolean;
  end;

type
  TObjectColor = record
    ObjName: string;
    ObjColor: TColor;
  end;
  TObjectColorArray = array of TObjectColor;

type
  TObjInfo = record
    Seq: Integer;
    ClassName: string;
    ClassAccuracy: Integer;
    Xmin: Double;
    Xmax: Double;
    Ymin: Double;
    Ymax: Double;
    Score: Double;
    BoxVisible: Boolean;
    ObjProp: TObjectColor;
    IsNewObj: Boolean;
  end;
  TObjInfoArray = array of TObjInfo;

var
  FObjColorArray: TObjectColorArray;
  FObjInfoArray: TObjInfoArray;

implementation

end.
