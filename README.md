DelphiZXingQRCodeEx
===================

DelphiZXingQRCodeEx is a Delphi port of the QR Code functionality from ZXing, an open source barcode image processing
library.

The code was initially ported to Delphi by Senior Debenu Developer, Kevin Newman (project *DelphiZXingQRCode,* see links
below). Then it was changed by Michael Demidov. The changes are listed in CHANGELOG.md.

**The most fundamental differences are:**

1. Error correction level has been fixed.
2. Support for programmer-defined charsets. As an example, I implemented Win-1251 Russian charset and URL encoding (when
non-Latin characters are represented as %-codes).
3. Exception handling has been added. There is no more Access Violation when input string is too long.
4. New *QRGraphics.pas* unit has been added that contains several functions to draw the QR Code on a given canvas (*TCanvas*) and
to generate either a bitmap or a metafile.
5. Still compatible with older versions of Delphi (at least Delphi 6). Compatible with Lazarus (1.2.6, for Windows),
see CHANGELOG.md (section 5).

The port retains the original Apache License (v2.0).

# This fork's changes in regards to MichaelDemidov/DelphiZXingQRCodeEx #

**Made this control ready for banking type applications, which require forced version 15 QR codes with optional ECI record**

1. Added property "Version" which when set gives an ability to force a version instead of autimatically finding the smallest one. 
This is needed for example by banking applications as they require the version to be 15.
2. Added property "ECI" which when set adds ECI record to the QR code (e.g. .ECI=4 for ISO-8859-2). 
3. Added support for ISO 8859-2 (Latin 2) character set (unit QR_ISO88592.pas) as encoding with index 8. 


# Links #

1. Original DelphiZXingQRCode project
  1. [Debenu site](http://www.debenu.com/open-source/delphizxingqrcode-open-source-delphi-qr-code-generator/)
  2. [GitHub Mirror](https://github.com/debenu/DelphiZXingQRCode/)
2. ZXing
  1. [Google Code](https://code.google.com/p/zxing/)
  2. [GitHub](https://github.com/zxing/zxing)
3. [Michael Demidov's blog](http://mik-demidov.blogspot.ru) (in Russian only, sorry)

# Software Requirements #

Delphi 6 or newer (I tested with Delphi 6 and XE3).

# Getting Started #

A sample Delphi project is provided in the TestApp folder to demonstrate how to use DelphiZXingQRCode.

And an example for a banking application would be:
<pre><code>var
  QRCode    : TDelphiZXingQRCode;
  QRBitmap  : tBitmap;
    
QRCode := TDelphiZXingQRCode.Create;
QRBitmap := tBitmap.Create;
try

  // QR ISO 18004 ver 15 (77x77 mandatory), byte data, ECC Level M, ISO 8859-2, ECI 000004, 32.6 x 32.6 mm
  QRCode.BeginUpdate;
  QRCode.Data := 'your data as required by your bank';
  QRCode.Version := 15;
  QRCode.ErrorCorrectionOrdinal := ecoM;
  QRCode.Encoding := ENCODING_ISO88592;
  QRCode.ECI := 4;  // 4 = ISO-8859-2
  QRCode.RegisterEncoder(ENCODING_ISO88592, TIso88592Encoder);
  QRCode.EndUpdate(TRUE);

  QRBitmap.Width := QRCode.Rows;
  QRBitmap.Height := QRCode.Columns;
  for x := 0 to QRCode.Rows - 1 do
    for y := 0 to QRCode.Columns - 1 do
      if QRCode.IsBlack[y, x] then
        QRBitmap.Canvas.Pixels[y, x] := clBlack
	  else
        QRBitmap.Canvas.Pixels[y, x] := clWhite;
	  
  // at this point QR code is in QRBitmap and you can display or print it as you like

finally
  FreeAndNil(QRCode);
  FreeAndNil(QRBitmap);
end;

</code></pre>
