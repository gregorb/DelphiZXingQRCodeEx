unit QR_ISO88592;

// ISO 8859-2 (Latin 2) encoder class for TDelphiZXingQRCode

interface

uses
  DelphiZXIngQRCode;

const
  ENCODING_ISO88592 = 8;

type
  TIso88592Encoder = class(TEncoder)
  protected
    function FilterContent(const Content: WideString; Mode: TMode;
      EncodeOptions: Integer): WideString; override;
    procedure AppendBytes(const Content: WideString; Mode: TMode;
      Bits: TBitArray; EncodeOptions: Integer); override;
  end;

implementation

uses
  Windows;

function TIso88592Encoder.FilterContent(const Content: WideString; Mode: TMode;
  EncodeOptions: Integer): WideString;
var
  X: Integer;
  CanAdd: Boolean;

  function Is88592Char(Char: WideChar): Boolean;
  begin
    Result := TRUE;
    // just let anything through for now
    // any invalid chars will be replaced with question marks by cWideCharToMultiByte which
    // will make our string safe for QR
    // to-do?: do a proper ISO-8859-2 test anyway, as it appears that this library prefers
    //   removing invalid chars from string as opposed to replacing them with '?'  
  end;

begin
  if EncodeOptions = ENCODING_ISO88592
  then
  begin
    Result := '';
    for X := 1 to Length(Content) do
    begin
      CanAdd := Is88592Char(Content[X]);
      if CanAdd then
        Result := Result + Content[X];
    end;
  end
  else
    Result := inherited FilterContent(Content, Mode, EncodeOptions)
end;

procedure TIso88592Encoder.AppendBytes(const Content: WideString; Mode: TMode;
   Bits: TBitArray; EncodeOptions: Integer);
var
  I, X: Integer;
  Bytes: TByteArray;
begin
  if EncodeOptions = ENCODING_ISO88592
  then
  begin
{$WARNINGS OFF} // I hate these "Unsafe code @ operator" warnings but I never
// turn them off completely. Sometimes they are really useful
    X := WideCharToMultiByte(28592{iso-8859-2}, WC_COMPOSITECHECK or WC_DISCARDNS or
      WC_SEPCHARS or WC_DEFAULTCHAR, @Content[1], -1, nil, 0, nil, nil);
    SetLength(Bytes, X - 1);
    if X > 1 then
      WideCharToMultiByte(28592{iso-8859-2}, WC_COMPOSITECHECK or WC_DISCARDNS or
        WC_SEPCHARS or WC_DEFAULTCHAR, @Content[1], -1, @Bytes[0], X - 1, nil,
        nil);
{$WARNINGS ON}
    for I := 0 to Length(Bytes) - 1 do
      Bits.AppendBits(Bytes[I], 8);
  end
  else
    inherited AppendBytes(Content, Mode, Bits, EncodeOptions);
end;

end.
 