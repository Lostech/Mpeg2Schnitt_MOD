{-----------------------------------------------------------------------------------
Diese Unit implementiert das Handling von Skin-Dateien. Das sind große Bitmaps,
die an definierten Positition Bilder für die Buttons enthalten.

Copyright (C) 2005  Thomas Urlings
 Homepage: n/a
 E-Mail:

Es gelten die Lizenzbestimmungen von Mpeg2Schnitt.

Das Programm Mpeg2Schnitt ist ein einfaches Schnittprogramm (nur harte Schnitte) für
Mpeg2Video-Dateien und Mpeg2- und AC3Ton-Dateien.

Copyright (C) 2003  Martin Dienert
 Homepage: http:www.mdienert.de/mpeg2schnitt/
 E-Mail:   m.dienert@gmx.de

This program is free software; you can redistribute it and/or modify it under the terms
of the GNU General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program;
if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.


Auf Deutsch:
Dieses Programm ist freie Software. Sie können es unter den Bedingungen
der GNU General Public License, wie von der Free Software Foundation veröffentlicht,
weitergeben und/oder modifizieren, entweder gemäß Version 2 der Lizenz oder
(nach Ihrer Option) jeder späteren Version.

Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, daß es Ihnen von Nutzen
sein wird, aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE
oder der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK. Details finden Sie in der
GNU General Public License.

Sie sollten eine Kopie der GNU General Public License zusammen mit diesem Programm erhalten haben.
Falls nicht, schreiben Sie an die Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.

--------------------------------------------------------------------------------------
Unit:         Skins
Description:  This unit handles the usage of the so called "Skin"-Files. These
              are simple images that contain all images used in M2S in a
              specific format. The automatic distribution algorithm requires
              that the images are stored in a predefined order. The skin must be
              a Windows-BMP file. RGBA-Bitmaps are supported as well.
Author:       Thomas Urlings
Datum:        04.10.2005
Version:      0.1.2.2
History:
0.1.2.2 - 04.10.2005
  Winzige Änderung, AddToMapping kann jetzt auch ohne Counter aufgerufen werden.
0.1.2.1 - 29.09.2005
  Für neues Bitmap-Format habe ich eine Working Area erzeugt und dann nicht
  gebraucht. Altes Row-Schema tat es doch noch eínmal. D.h. der Verteilungs-
  Algorithmus ist immer noch unverändert.
0.1.1.1 - 14.09.2005
  CopySkinBitmap funktionierte nicht. Ist nicht aufgefallen, weil die
  konvertierung der alten Vorlagen mit der alten Methode durchgeführt wurden.
  _targetFormat wurde nicht initialisiert, wenn ein Bitmap mit 24 oder 32 Bits
  geladen wurde.
0.1.1.0 - 29.08.2005
  An TAlphaBitmap.PixelInc angepasst, verschiedene Pixel-Formate über
  _targetFormat implementiert. Alles was < 24bit ist wird nach 24bit
  konvertiert. Beim abspeichern eines Skins wird wieder das gewünschte Format
  erzeugt (SaveSkin(FileName)). Einige Bugs im 24bit/32bit Handling beseitigt.
  Skin kann nun aus dem Programm-Resourcen gelesen werden. (Für Default-Skins,
  die an das Programm gelinkt werden).
  Wichtigste Änderung, Mapping eingeführt, bevor ein Skin genutzt werden kann
  muß ein Mapping durchgeführt werden. Danach kann auf jedes Symbol über den
  entsprechenden Index zugegriffen werden. Interessant für automatische-
  Skin-Update mit verschiedenen Icon-Position in neuen Skin-Versionen.
0.1.0.2 - 15.08.2005
  An TAlphaBitmap.IsEmpty angepasst
0.1.0.1 - 12.08.2005
  Now all Bitmap-Types should be supported.
0.1.0.0 - 01.08.2005
  Methods moved from TMpegEdit and assembled into a new class.
  Distribution-Alogrithm remains untouched.
--------------------------------------------------------------------------------------}

unit Skins;

interface

uses Windows, AlphaBlend, SysUtils, Types, Graphics, Buttons, Controls, Classes;

type
  TSkinErrors = (seNone, seBMPFormat, seFileError, seResourceError);

  TImagePos = record
    offset : TPoint;
    size : TPoint;
  end; { TImagePos }

  TSkinFactory = class(TObject)
  private               // _ indicates member var
    _workRect: TRect;   // contains current row
    _row: TRect;        // area that contains the current image
    _offset: TPoint;    // current offset in row
    _skin: TAlphaBitmap;     // skin
    _gr_skin: TAlphaBitmap;  // grayscaled Bitmap
    _error: TSkinErrors;// errorCode
    _targetFormat: TPixelFormat;

    _mapping: Array of TImagePos;
    _iconCount : Cardinal;

    procedure SetPixel(const pix: PPixelRec32; value: Cardinal);

  protected
    procedure NextBitmapOffset(const size: TPoint);
    procedure ValidateBitmapOffset(const size: TPoint);
    procedure AppendMapping(const offset, size: TPoint);
    procedure DrawBorder(const offset, size: TPoint);
    procedure SetWorkRect(const value: TRect);
    procedure SetRow(const value: TRect);

  public
    procedure NextBitmapCol;
    procedure NextBitmapRow;
    procedure TextOut(text: String);
    procedure SetSkinBitmap(const bmp: TAlphaBitmap);
    procedure CopySkinBitmap(destI: Cardinal; const sourceSkin: TSkinFactory;
                             sourceI: Cardinal);
    constructor Create(); overload;
    constructor Create(FileName: String); overload;
    constructor Create(FileName: String; const offset: TPoint); overload;
    constructor CreateFromResource(ResName: String); overload;
    constructor CreateFromResource(ResName: String;
                                   const offset: TPoint); overload;
    constructor CreateTemplate(PixelFormat: TPixelFormat;
                               Width, Height:Integer);
    destructor Destroy(); override;
    function LoadSkin(FileName: String; offset: TPoint): Boolean;
    function LoadSkinFromResource(ResName: String; offset: TPoint): Boolean;
    procedure Init(Offset: TPoint); overload;
    procedure Init; overload;
    procedure InitSkin; overload;
    procedure Premultiply;
    function SaveSkin(FileName: String): Boolean;

  // Mapping Handling
    procedure AddToMapping(const ctrl: TControl; count: Integer = 1); overload;
    procedure AddToMapping(const size: TPoint; count: Integer = 1); overload;
    procedure ClearMapping;
    procedure MappingDone;
    procedure DrawBorders;
    Function GetBitmap(A: Array of Cardinal;
                       disabled: Boolean = True): TAlphaBitmap; overload;
    Function GetBitmap(I: Cardinal; disabled: Boolean = True): TAlphaBitmap; overload;

    property Skin: TAlphaBitmap read _skin;  // readonly property
    property ErrorCode: TSkinErrors read _error;
    property Row: TRect read _row write SetRow; // manipulate row for special handling
    property Area: TRect read _workRect write SetWorkRect;
    property Offset: TPoint read _offset write _offset;
    property PixelFormat: TPixelFormat read _targetFormat;
    property Count: Cardinal read _iconCount;

  published
  end; {TSkinFactory}

implementation

{ TSkinFactory }

procedure TSkinFactory.Premultiply;
begin
  if _skin.PixelFormat = pf32bit then begin
    AlphaBlend.Premultiply(_skin);
    AlphaBlend.Premultiply(_gr_skin)
  end
end;

procedure TSkinFactory.TextOut(text: String);
begin
  _skin.Canvas.TextOut(_offset.X,_offset.Y,text);
end;

procedure TSkinFactory.ClearMapping;
begin
  _mapping := nil;
  _iconCount := 0;
end;

procedure TSkinFactory.MappingDone;
begin
  AppendMapping(Point(0,0),Point(0,0)); // Terminator
  dec(_iconCount);
end;

procedure TSkinFactory.AppendMapping(const offset, size: TPoint);
begin
    if Integer(_iconCount) > High(_mapping) then
      SetLength(_mapping, Length(_mapping) + 16);
    _mapping[_iconCount].offset := _offset;
    _mapping[_iconCount].size := size;
    inc(_iconCount);
end;

procedure TSkinFactory.AddToMapping(const size:TPoint; count: Integer = 1);
var
  I: Integer;
begin
  for I:=1 to count do
  begin
    ValidateBitmapOffset(size);
    AppendMapping(_offset, size);
    NextBitmapOffset(size)
  end
end;

procedure TSkinFactory.AddToMapping(const ctrl: TControl; count: Integer = 1);
begin
  AddToMapping(Point(ctrl.Width-4, ctrl.Height-4), count);
end;

procedure TSkinFactory.SetPixel(const pix: PPixelRec32; value: Cardinal);
var
  p: PPixelRec32;
begin
  if _skin.PixelFormat = pf32bit then
    pix.I := value
  else begin
    p := @value;
    pix.R := p.R;
    pix.G := p.G;
    pix.B := p.B;
  end;
end;

// malt einen Rahmen von 1px um die von Offset und Size definierte region
procedure TSkinFactory.DrawBorder(const offset, size: TPoint);
var
  p:PPixelRec32;
  x,y:Integer;
  r:TRect;
begin
  // rahmen berechnen
  r := RECT(-1,-1,size.X,size.Y);
  offsetRect(r,offset.X,offset.Y);
  // rahmen zeichen. (undurchsichtig und schwarz)
  for y:=r.Top to r.Bottom do
    if (y>=0) and (y<_workRect.Bottom) then
    begin
      p := _skin.ScanLine[y];
      //linken Rahmen zeichnen
      if r.Left>=0 then // left kann < 0 sein
      begin
        _skin.PixelInc(p,r.Left);
        SetPixel(p, $FF000000); // Schwarz / Schwarz opak
      end;
      // evtl. oberen oder unteren Rahmen zeichnen
      if (y=r.Top) or (y=r.Bottom) then
      begin
        if r.Left>=0 then _skin.PixelInc(p); // nur wenn left nicht -1
        for x:=r.Left+1 to r.Right do
        begin
          SetPixel(p, $FF000000); // Schwarz / Schwarz opak
          _skin.PixelInc(p);
        end;
      end
      else
      begin
        if r.Right < _workRect.Right then
        begin      // rechten Rahmen zeichnen
          if r.Left >= 0 THEN _skin.PixelInc(p,r.Right-r.Left)
          else _skin.PixelInc(p,r.Right);
          SetPixel(p, $FF000000); // Schwarz / Schwarz opak
        end;
      end
    end;
end;

procedure TSkinFactory.DrawBorders;
var
  I: Cardinal;
begin
  for I:=0 to _iconCount-1 do
    DrawBorder(_mapping[I].offset, _mapping[i].size);
end;

procedure TSkinFactory.SetSkinBitmap(const bmp: TAlphaBitmap);
var
  source, dest: TRect;
  size : TPoint;
begin
  Assert(
    _skin.PixelFormat <> bmp.PixelFormat,
    'TSkinFactory.SetBitmap: PixelFormat does not match'
  );
  source := RECT(0,0,bmp.Width, bmp.Height);
  size := POINT(bmp.Width, bmp.Height);
  ValidateBitmapOffset(size);
  dest := source;
  offsetRect(dest, _offset.X, _offset.Y);
  _skin.Canvas.CopyRect(dest,bmp.Canvas, source);
  NextBitmapOffset(size);
end;


procedure TSkinFactory.CopySkinBitmap(destI: Cardinal;
                             const sourceSkin: TSkinFactory; sourceI: Cardinal);
var
  source, dest: TRect;
begin
  if (sourceSkin._mapping[sourceI].size.X <> _mapping[destI].size.X) or
     (sourceSkin._mapping[sourceI].size.Y <> _mapping[destI].size.Y) then Exit;

  // same Size
  dest := RECT(POINT(0,0), _mapping[destI].size);
  source := dest;
  offsetRect(
    dest, _mapping[destI].offset.X, _mapping[destI].offset.Y
  );
  offsetRect(
    source,
    sourceSkin._mapping[sourceI].offset.X,
    sourceSkin._mapping[sourceI].offset.Y
  );
  _skin.Canvas.CopyRect(dest, sourceSkin._skin.Canvas, source);
end;

Function TSkinFactory.GetBitmap(I:Cardinal;
                                disabled: Boolean = True): TAlphaBitmap;
begin
  result := GetBitmap([I], disabled);
end;

Function TSkinFactory.GetBitmap(A: Array of Cardinal;
                                disabled: Boolean = True): TAlphaBitmap;
var
  bmp: TAlphaBitmap;
  source, dest: TRect;
  I: Integer;
  validCount: Integer;
  valids: Array of Cardinal;
begin
  Result := nil;
  validCount := 0;
  SetLength(valids,Length(A));

  for I:=0 to High(A) do  // anzahl der gültigen Einträge zählen
    if (A[I] < _iconCount) and
      ((validCount = 0) or
        ((_mapping[A[I]].size.X = _mapping[valids[0]].size.X) and
         (_mapping[A[I]].size.Y = _mapping[valids[0]].size.Y))) then
    begin
      valids[validCount] := A[I];
      inc(validCount);
    end;

  if validCount = 0 then exit;

  bmp := TAlphaBitmap.Create;
  with bmp do
  begin
    PixelFormat := _skin.PixelFormat;
    Height := _mapping[valids[0]].size.Y;
    if disabled then Width := _mapping[valids[0]].size.X * validCount * 2
    else             Width := _mapping[valids[0]].size.X * validCount;
  end;
  dest := RECT(0, 0, _mapping[valids[0]].size.X, _mapping[valids[0]].size.Y);
  source := dest;
  for I:=0 to validCount-1 do begin
    offsetRect(
      source,
      _mapping[valids[I]].offset.X,
      _mapping[valids[I]].offset.Y
    );
    with bmp do
    begin
      Canvas.CopyRect(dest, _skin.Canvas, Source);
      offsetRect(dest, _mapping[valids[0]].size.X, 0);
      if disabled then begin
        Canvas.CopyRect(dest, _gr_skin.Canvas, Source);
        offsetRect(dest, _mapping[valids[0]].size.X, 0);
      end
    end;
    offsetRect(
      source,
      -_mapping[valids[I]].offset.X,
      -_mapping[valids[I]].offset.Y
    ); // zurück auf 0 für nächstes Bild
  end;
  if bmp.IsEmpty then bmp.Free
  else begin
    if disabled then bmp.NumGlyphs := validCount * 2
    else             bmp.NumGlyphs := validCount;
    Result := bmp
  end
end;

procedure TSkinFactory.SetRow(const value: TRect);
begin
  _row := value;
  _offset := _row.TopLeft;
end;

procedure TSkinFactory.SetWorkRect(const value: TRect);
begin
  _workRect := value;
  with _workRect do
  begin
    if Left < 0 then Left := 0;
    if Top < 0 then Top := 0;
    if Right > _skin.Width then Right := _skin.Width;
    if Bottom > _skin.Height then Bottom := _skin.Height
  end;
  _offset := _workRect.TopLeft;
end;

// setze row auf nächste Columne. row enthält immer die Dimensionen der aktuellen
// Spalte.
procedure TSkinFactory.NextBitmapCol;
begin
  with _row do begin
    Left := Right;
    Bottom := _workRect.Top;
    Top := Bottom;
    _offset.X := left;
    _offset.Y := _workRect.Top;
  end
end;

// setzte row und offset auf die nächste Spalte
procedure TSkinFactory.NextBitmapRow;
begin
  with _row do begin
    Top := Bottom + 1 ;
    Bottom := Top;
    _offset.X := Left;
    _offset.Y := Top
  end
end;

// setzt die nächste Icon-Position abhängig vom zuletzt gezeichneten Icon (size)
procedure TskinFactory.NextBitmapOffset(const size: TPoint);
begin
  _offset.X := _offset.X + size.X + 1;
end;

// wird vor dem abrufen/einfügen eines Icons aufgerufen, vergrößert, wenn
// möglich 'row', so das das Icon in den Rahmen passt. Wenn das nicht geht, wird
// offset auf die nächst gültige Position verschoben und row entsprechend
// angepasst
procedure TSkinFactory.ValidateBitmapOffset(const size: TPoint);
begin
  while (_offset.Y + size.Y > _row.Bottom) OR // solang bis alles passt
        (_offset.X + size.X > _row.Right) do
  begin
    if _offset.X + size.X > _row.Right then // zu schmal
    begin
      if _offset.X = _row.Left then // verbreitern
        _row.Right := _offset.X + size.X + 1
      else
        NextBitmapRow;
    end else if _offset.Y + size.Y > _row.Bottom then
    begin
      _row.Bottom := _offset.Y + size.Y;  // +1 ?
      if _row.Bottom > _workRect.Bottom then
        NextBitmapCol;
    end;
  end;
end;

procedure TSkinFactory.Init;
begin
  Init(POINT(0,0));
end;

procedure TSkinFactory.Init(Offset: TPoint);
begin
  _workRect := RECT(0,0,_skin.Width, _skin.Height);
  dec(_workRect.Right, offset.X);
  dec(_workRect.Bottom,offset.Y);
  offsetRect(_workRect,offset.X, offset.Y);
  _offset := offset;    // init start punkt
  _row := RECT(0,0,0,0);// int row;
end;

procedure TSkinFactory.InitSkin;
begin
  _targetFormat := _skin.PixelFormat;
  if _skin.PixelFormat < pf24bit then begin
    skin.PixelFormat := pf24bit;  // force at least 24 bit.
  end;
//  if _skin.PixelFormat = pf32bit then Premultiply(_skin); // alphabitmap
  // create grayscaled bitmap
  _gr_skin := TAlphaBitmap.Create;
  _gr_skin.Assign(_skin);
  GrayScaleBitmap(_gr_skin);
end;

function TSkinFactory.LoadSkinFromResource(ResName: String; offset: TPoint): boolean;
var
  RStream: TResourceStream;
begin
  Result := True;
  if _skin <> nil then _skin.Free;
  if _gr_skin <> nil then _gr_skin.Free;
  try
    _skin := TAlphaBitmap.Create;
    RStream := nil;
    try
      RStream := TResourceStream.Create(hInstance, ResName, RT_RCDATA);
      _skin.LoadFromStream(RStream);
    finally
      if RStream <> nil then RStream.Free
    end;
    Init(offset);
    InitSkin;
  except
    if skin <> nil then _skin.Free;
    _skin := nil;
    Result := False;
    _error := seResourceError;
  end;
end;

function TSkinFactory.LoadSkin(FileName: String; offset: TPoint): Boolean;
begin
  Result := True;
  if _skin <> nil then _skin.Free;
  if _gr_skin <> nil then _gr_skin.Free;
  try
    _skin := TAlphaBitmap.Create;
    _skin.LoadFromFile(FileName);
    Init(Offset);
    InitSkin;
  except
    if skin <> nil then _skin.Free;
    _skin := nil;
    Result := false;
    _error := seFileError;
  end;
end;

function TSkinFactory.SaveSkin(FileName: String): Boolean;
var
  bmp: TAlphaBitmap;
begin
  bmp := TAlphaBitmap.Create;
  bmp.Assign(_skin);
  bmp.PixelFormat:=_targetFormat;
  try
    bmp.SaveToFile(FileName);
    Result := True;
  except
    Result := False;
  end;
  bmp.Free;
end;

{------------------------------------------------------------------------------}
{- Constructors / Destructors -------------------------------------------------}
{------------------------------------------------------------------------------}
constructor TSkinFactory.Create;
begin
  inherited;
  _offset := Point(0,0); _row := RECT(0,0,0,0);
  _skin := nil; _gr_skin := nil;
  _error := seNone;
  ClearMapping;
end;

constructor TSkinFactory.Create(FileName: String);
begin
  Create(FileName, Point(0,0));
end;

constructor TSkinFactory.Create(FileName: String; const offset: TPoint);
begin
  Create;
  if not LoadSkin(FileName, offset) then
    raise Exception.Create('Skin failed to load');
end;

constructor TSkinFactory.CreateFromResource(ResName: String);
begin
  CreateFromResource(ResName, Point(0,0));
end;

constructor TSkinFactory.CreateFromResource(ResName: String; const offset: TPoint);
begin
  Create;
  if not LoadSkinFromResource(ResName, offset) then
    raise Exception.Create('Skin failed to load from resource');
end;

constructor TSkinFactory.CreateTemplate(PixelFormat: TPixelFormat;
                                        Width, Height: Integer);
var
  x,y: Integer;
  p:PPixelRec32;
begin
  Create;
  _targetFormat := PixelFormat;
  _skin := TAlphaBitmap.Create;
  if PixelFormat < pf24bit then
    _skin.PixelFormat := pf24bit  // creation with 24 bit
  else
    _skin.PixelFormat := PixelFormat;
  _skin.Width := Width;
  _skin.Height := Height;
  // alles weis und durchsichtig, wenn 32bit Format
  if PixelFormat = pf32bit then begin
    for y:=0 to Height-1 do
    begin
      p := _skin.ScanLine[y];
      for x:=0 to _skin.Width-1 do
      begin
        p.I := $00FFFFFF;
        inc(p)
      end
    end
  end;
  Init(Offset);
end;

destructor TSkinFactory.Destroy;
begin
  if _skin <> nil then _skin.Free;
  if _gr_skin <> nil then _gr_skin.Free;
  inherited Destroy;
end;

end.
