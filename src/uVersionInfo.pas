unit uVersionInfo;

interface

uses
  Windows, Forms, SysUtils;

type
  TVerKind = (
    tvComments,         // �ڸ�Ʈ
    tvCompanyName,      // ȸ���
    tvFileDescription,  // ����
    tvFileVersion,      // ���Ϲ���
    tvInternalName,     // ���θ�
    tvLegalCopyright,   // ���۱�
    tvLegalTrademarks,  // ��ǥ
    tvOriginalFilename, // �������ϸ�
    tvPrivateBuild,     // Private Build
    tvProductName,      // ��ǰ��
    tvProductVersion,   // ��ǰ����
    tvSpecialBuild);    // Special Build

    function fnGetVersionInfo(KeyWord: TVerKind): string;

const
  csVerKey: array [TVerKind] of String = (
        'Comments',
        'CompanyName',
        'FileDescription',
        'FileVersion',
        'InternalName',
        'LegalCopyright',
        'LegalTrademarks',
        'OriginalFilename',
        'PrivateBuild',
        'ProductName',
        'ProductVersion',
        'SpecialBuild');

implementation

// ���� ���� ���
function fnGetVersionInfo(KeyWord: TVerKind): string;
const
  cTranslation = '\VarFileInfo\Translation';
  cFileInfo = '\StringFileInfo\%0.4s%0.4s\';
var
  dBufSize    : DWORD;
  dHWnd       : DWORD;
  pVerInfoBuf : Pointer;
  pVerData    : Pointer;
  lVerDataLen : Longword;
  sPath       : String;
begin

  // �ʿ��� ���� ������ ���
  dBufSize := GetFileVersionInfoSize(PChar(Application.ExeName), dHWnd);

  if dBufSize <> 0 then
  begin
    // �޸�Ȯ��
    GetMem(pVerInfoBuf, dBufSize);

    try
      GetFileVersionInfo(PChar(Application.ExeName), 0, dBufSize, pVerInfoBuf);

      // �������� ������ ��ȯ ���̺� ����
      VerQueryValue(pVerInfoBuf, PChar(cTranslation), pVerData, lVerDataLen);

      if not (lVerDataLen > 0) then
        raise Exception.Create('���� ���� ����');

      // 8�ڸ� 16������ ��ȯ
      // ��'\StringFileInfo\027382\FileDescription'
      sPath := Format(cFileInfo + csVerKey[KeyWord],
                      [IntToHex(Integer(pVerData^) and $FFFF, 4),
                      IntToHex((Integer(pVerData^) shr 16) and $FFFF, 4)]);
      VerQueryValue(pVerInfoBuf, PChar(sPath), pVerData, lVerDataLen);

      if lVerDataLen > 0 then
      begin
        // VerData�� ���η� ������ ���ڿ��� �ƴ� �Ϳ� ����
        result := '';
        SetLength(result, lVerDataLen);
        StrLCopy(PChar(result), pVerData, lVerDataLen);
      end;
    finally
      // ����
      FreeMem(pVerInfoBuf);
    end;
  end;
end;

end.
