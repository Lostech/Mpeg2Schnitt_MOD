{-----------------------------------------------------------------------------------
Diese Unit implementiert verschiedene Algorithmen zum einblenden von Bildern
mit Alphakanal auf Speedbuttons.

Copyright (C) 2005  Thomas Urlings
 Homepage: n/a
 E-Mail:

Es gelten die Lizenzbestimmungen von Mpeg2Schnitt.

Diese Unit ist Teil des Programms Mpeg2Schnitt.

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
Unit:         Alphablend

Kommentar:    Die Unit 'AlphaBlend' bietet Methoden 32Bit Bitmaps mit
              AlphaChanel (RGBA) zu überblenden. Dazu wird aus dem Windows-Api
              die Funktion AlphaBlend benutzt, die seit Windows98 bzw.
              Windows2000 verfügbar ist. Unter Windows 95 und NT müßte man eine
              selbst programmierte AlphaBlending Routine eingesetzt.
              Verfahren:
              F,B,R = FrontPixel, BackPixel, ResultPixel (Jeweils RGB-Tripel)
              a = AlphaChannel, 0, FrontPixel ist total durchsichtig, 255,
              FrontPixel ist opak
              Formel:
              aus Literatur, a Factor zwischen 0.0 und 1.0
              => R = aF + (1-a)B = aF + B - aB
              da a [0 .. 255]
              => R = (aF + (255-a)B) / 255 = aF/255 + B - aB/255
              aF/255 wird immer vorberechnet, weil dieser Teil für jeden
              Hintergrund gleich ist. (Premultiply)
              AlphaBlend erledigt den + B - aB/255 Teil und gleichzeitig auch
              noch StrechBlt (!).

Description:  This unit provides AlphaBlend methods and the TAlphaSpeedBtn, a
              descendant of TSpeedButton. This is a Speedbutton with a different
              Bitmap-Handling, allowing the use of RGBA-Bitmaps. GrayBitmaps for
              disabled appearance are calculated automatically.

Author:       Thomas Urlings
Datum:        29.08.2005
Version:      0.2.3.2
History:
0.1.0.0 - ??.07.2005
  Zusammenstellung der Funktionen zu einer Klasse
0.2.0.0 - 09.08.2005
  Nun sollten auch Bitmaps mit PixelFormat >= pf15bit gehandelt werden können.
  DoBitBlit wird dann anstelle von DoAlphaBlend genutzt
0.2.1.0 - 11.08.2005
  Bilder mit PixelFormat < pf32bit waren nicht transparent. Durch die Änderung
  sollten alle möglichen Bitmaps nutzbar sein. (Werden nach 24Bit konvertiert).
  Grayscale kann jetzt auch mit 24Bit Bitmaps arbeiten. Die Trennung von
  Glyph und AlphaGlyph habe ich aufgelöst. Das wird nun transparent klassen-
  intern erledigt. Nach aussen hat ein TAlphaSpeedBtn nun nur ein Glyph und
  eine NumGlyphs-Property. Das erfordert einige Anpassungen am Hauptfenster.
  ActiveAlphaGlyph muß durch ActiveGlyph ersetzt werden. (Bei der Auswahl andere
  Bitmaps.)
0.2.2.0 - 12.08.2005
  Bilder werden nun in einer speziellen Klasse verwaltet. TAlphaBitmap, abge-
  leitet von TBitmap. Diese Klasse hat eine DoDraw Methode, die in Abhängigkeit
  vom Bildformat die entsprechende Ausgaberoutine aufruft. Damit können nun
  AlphaBlend-taugliche Bitmaps erzeugen, die nicht auf Buttons genutzt werden
  sollen. (z.B. Icons in der Schnittliste). Vereinfacht den AlphaSpeedBtn, der
  hat jetzt statt eines Bitmaps eine AlphaBitmap.
0.2.3.0 - 15.08.2005
  2 Bugs beseitigt. SetActiveGlyph machte nichts und SetGlyph zeigte veränderte
  Glyphs erst nach einem erzwungenen repaint an. Spacing und Margin werden von
  CalcBitmapPos nicht mehr verändert.
  Es gibt nun die Möglichkeit den Caption-Text zu verstecken.
  (property CaptionHidden: Boolean read IsCaptionHidden write SetCaptionHidden;)
  AlphaBitmap hat nun eine Funktion IsEmpty, die prüft, ob das ganz Image nur
  in der Hintergrundfarbe bzw. mit der Transparenz-Farbe gefüllt ist.
  (Der Bildpunkt unten links bestimmt die Transparenz-Farbe eines Bildes.)
  //The lower left pixel of the bitmap is reserved for the “transparent” color.
  //Any pixel in the bitmap which matches that lower left pixel will be
  //transparent.
0.2.3.1 - 19.08.2005
  CaptionHidden funktionierte nur, wenn Caption ein Wert zugewiesen war, deshalb
  neue Variable capHidden, die nun direkt den Status enthält
0.2.3.2 - 29.08.2005
  neue Procedure PixelInc in AlphaBitmap. Die Procedure liefert den folgenden
  Pixelpointer in Abhängigkeit vom aktuellen Pixel-Format. (nur 32/24 Format)
}
unit AlphaBlend;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, CommCtrl, ImgList;

type
  TPixelRec32 = packed record   {variant record to access whole pixels or color parts easily}
    case integer of
      0: (I: Cardinal);
      1: (B: Byte; G: Byte; R: Byte; A: Byte);
  end; { TPixelRec32 }

  PPixelRec32 = ^TPixelRec32;

  TPixelRec24 = packed record
    B: Byte; G: Byte; R: Byte;
  end; { TPixelRec24 }

  PPixelRec24 = ^TPixelRec24;

{ TAlphaBitmap }

  TAlphaBitmap = class(TBitmap)
  private
    ImgCount: Cardinal;
    ImgWidth: Cardinal;
    ImgList: TImageList;  // used to show Bitmaps < 32bit
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DoDraw(destCanvas: TCanvas; X, Y, Index: Integer);
    procedure SetNumGlyphs(i: Cardinal);
    function IsEmpty: Boolean;
    procedure PixelInc(var p: PPixelRec32; const offset: Integer = 1);

    property NumGlyphs: Cardinal read ImgCount write SetNumGlyphs;
    property GlyphWidth: Cardinal read ImgWidth;
  end; { TAlphaBitmap }

{ TAlphaSpeedBtn }

  // TAlphaSpeedBtn, ersetzt TSpeedButton.
  // Bitmaps werden per AlphaBlending angezeigt
  // In üblicher Manie können mehrere Bitmaps übergeben werden.
  // Das disabledIcon folgt immer direkt auf das Icon in Normaldarstellung
  // disable => ActiveAlphaGlyph++, enable => ActiveAlphaGlyph--
  // 0: Normal
  // 1: Disabled
  // 2: Down
  // 3: Down&Disabled   // leer -> 1
  // ..
  // das aktive Icon kann über ActiveAlphaGlyph gewählt werden
  TAlphaSpeedBtn = class(TSpeedButton)
  private
    aGlyph: TAlphaBitmap;  // Pseudo AlphaImageList
    GlyphIx: Cardinal;
    capHidden: Boolean;
    hiddenCaption: TCaption;

    procedure CalcGlyphPos(const Client: TRect; const Offset: TPoint;
                           Margin, Spacing: Integer; Caption: String;
                           var GlyphPos: TPoint; BiDiFlags: Longint);
    procedure SetGlyph(bmp:TAlphaBitmap);
    procedure SetActiveGlyph(no:Cardinal);
    procedure SetNumGlyphs(no:Cardinal);
    function GetNumGlyphs: Cardinal;
    procedure SetCaptionHidden(hide: Boolean = True);
    function GetCaption: TCaption;
    procedure SetCaption(text: TCaption);

  protected
    procedure Paint; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    procedure Assign(Source: TPersistent); override;
    function Replace(sb: TSpeedButton): TAlphaSpeedBtn;

  published
    property ActiveGlyph: Cardinal read GlyphIx write SetActiveGlyph default 0;
    property NumGlyphs: Cardinal read GetNumGlyphs write SetNumGlyphs;
    property Glyph: TAlphaBitmap read aGlyph write SetGlyph;
    property CaptionHidden: Boolean read capHidden write SetCaptionHidden;
    property Caption: TCaption read GetCaption write SetCaption;
  end; { TAlphaSpeedBtn }

// Prepare bitmap for AlphaBlending
function Premultiply(bmp:TBitmap): TBitmap;

// calculate grayscaled Bitmap
function GrayScaleBitmap(bmp:TBitmap): TBitmap;

// caluclates the smallest rectangle around an image
function CropImageRect(bmp:TBitmap; rect:TRect): TRect;

// Blend sourceCanvas on destCanvas with an additional sourceConstantAlpha value
// sourceConstantAlpha applies to all pixels.
// 0: whole bitmap transparent, 255: only use per-pixel alpha values.
function DoAlphaBlend(destCanvas: TCanvas; dLeft, dTop, dWidth, dHeight: Integer;
                      sourceCanvas: TCanvas; sLeft, sTop, sWidth, sHeigth: Integer;
                      sourceConstantAlpha: Byte): Boolean;

implementation

uses Themes;

{B-}  // ist zwar default, aber man weiß ja nie...

{ TAlphaBitmap ]

{------------------------------------------------------------------------------}
{- TAlphaBitmap ---------------------------------------------------------------}
{------------------------------------------------------------------------------}
constructor TAlphaBitmap.Create;
begin
  inherited;
  ImgList := nil;
  ImgCount := 0;
  ImgWidth := 0;
end;

destructor TAlphaBitmap.Destroy;
begin
  if ImgList <> nil then ImgList.Free;
  inherited;
end;

procedure TAlphaBitmap.SetNumGlyphs(i: Cardinal);
begin
  if i <> ImgCount then begin
    if ImgList <> nil then begin ImgList.Free; ImgList := nil end;
    ImgCount := i;
    if (ImgCount > 0) and (Width > 0) and (Height > 0) then begin
      ImgWidth := Cardinal(Width) div ImgCount;
      if PixelFormat < pf32bit then begin
        ImgList := TImageList.CreateSize(ImgWidth, Height);
        ImgList.BkColor := clNone;
        ImgList.AddMasked(Self, clDefault); // Pixel unten links
      end;
    end;
  end;
end;

procedure TAlphaBitmap.DoDraw(destCanvas: TCanvas; X, Y, Index: Integer);
begin
  if PixelFormat = pf32bit then
    DoAlphaBlend(
      destCanvas, X, Y, ImgWidth, Height,
      Canvas, ImgWidth * Cardinal(Index), 0, ImgWidth, Height,
      $FF
    )
  else
    ImgList.Draw(destCanvas, X, Y, Index);
end;

function TAlphaBitmap.IsEmpty: Boolean;
var
  pix:PPixelRec32;
  cmpcol:Cardinal;
  bgrcol:Cardinal;
  x,y:Integer;
begin
  result := True;
  if Height = 0 then exit;
  bgrcol := ColorToRGB(Canvas.Pixels[0, Height - 1]);
  for y := 0 to Height-1 do
  begin
    pix := ScanLine[y];
    for x := 0 to Width-1 do
    begin
      if PixelFormat = pf32bit then cmpcol := pix.I
      else cmpcol := pix.I and $00FFFFFF;
      PixelInc(pix);
      if cmpcol <> bgrcol then begin result := false; exit end;
    end;
  end;
end;

procedure TAlphaBitmap.PixelInc(var p: PPixelRec32; const offset: Integer = 1);
begin
  if PixelFormat = pf32bit then
    inc(p,offset)
  else
    inc(PPixelRec24(p),offset);
end;


{ TAlphaSpeedBtn }

{------------------------------------------------------------------------------}
{- TAlphaSpeedBtn Implementation ----------------------------------------------}
{------------------------------------------------------------------------------}
constructor TAlphaSpeedBtn.Create(AOwner: TComponent);
begin
  inherited;
  aGlyph := nil;
  hiddenCaption := '';
  inherited NumGlyphs := 2    // immer 2
end;

destructor TAlphaSpeedBtn.Destroy;
begin
  if aGlyph <> nil then aGlyph.Free;
  inherited;
end;

procedure TAlphaSpeedBtn.SetCaptionHidden(hide: Boolean = True);
begin
  if capHidden = hide then exit;
  capHidden := hide;
  if hide then begin
    hiddenCaption := inherited Caption;
    inherited Caption := ''
  end else begin
    inherited Caption := hiddenCaption;
    hiddenCaption := '';
  end;
end;

function TAlphaSpeedBtn.GetCaption;
begin
  if capHidden then
    result := hiddenCaption
  else
    result := inherited Caption;
end;

procedure TAlphaSpeedBtn.SetCaption(Text: TCaption);
begin
  if capHidden then
    hiddenCaption := Text
  else
    inherited Caption := Text;
end;


procedure TAlphaSpeedBtn.SetNumGlyphs(no:Cardinal);
begin
  if (aGlyph <> nil) and (aGlyph.NumGlyphs <> no) then
  begin
    aGlyph.NumGlyphs := no;
  end;
end;

function TAlphaSpeedBtn.GetNumGlyphs: Cardinal;
begin
  if (aGlyph = nil) then Result := 0
  else Result := aGlyph.NumGlyphs;
end;

procedure TAlphaSpeedBtn.SetGlyph(bmp:TAlphaBitmap);

begin
  if bmp <> aGlyph then begin
    if aGlyph <> nil then aGlyph.Free;  // altes Bitmap muß also gelöscht werden
    if bmp <> nil then begin
      aGlyph := bmp;
      inherited Glyph.Width := aGlyph.GlyphWidth * 2;
      inherited Glyph.Height := aGlyph.Height
    end else begin
      aGlyph := nil;
      inherited Glyph.Width := 0;
      inherited Glyph.Height := 0;
//      inherited Glyph := nil;
      SetCaptionHidden(False);
    end;
    Invalidate;       // von Martin: Bei Bildänderung nötig
  end;
end;

procedure TAlphaSpeedBtn.SetActiveGlyph(no:Cardinal);
begin
  if (aGlyph = nil) then no := 0    // von Martin: war <> nil => = nil.
  else if no >= aGlyph.NumGlyphs then no := aGlyph.NumGlyphs -1;
  if no <> GlyphIx then
  begin
    GlyphIx := no;
    Invalidate;
  end;
end;

// Idee: das original Paint von SpeedButton malt den Button mit Text und einem
// leeren Bitmap. Danach wird von der überschrieben Paint-Routine das gewünschte
// Bitmap überblendet. Blöd nur, das man die Icon Position dann noch einmal
// berechnen muß, aber es geht ...
// besser vielleicht nur noch den Button selbst von der original-routine
// malen zu lassen und dann Icon und Text selbst zu malen.
procedure TAlphaSpeedBtn.Paint;
var
  glyphpos : TPoint;
  PaintRect : TRect;
  r: TRect;
  Details: TThemedElementDetails;
  ToolButton: TThemedToolBar;
  Button: TThemedButton;
  Offset : TPoint;
  oldGlyphIx : Integer;
begin
  inherited;  // paint with invisible icon (Glyph of TSpeedButton)
  if (aGlyph = nil) or (aGlyph.Width = 0) or (aGlyph.Height = 0) then exit;
  oldGlyphIx := GlyphIx;
  if Down AND (aGlyph.NumGlyphs > 3) then GlyphIx := 2; // Downposition
  if NOT Enabled then inc(GlyphIx);
  // calculate Icon-Position
  Offset := Point(0,0);
  glyphpos := Point(0,0);
  if ThemeServices.ThemesEnabled then
  begin
    if not Enabled then
      Button := tbPushButtonDisabled
    else
      if FState in [bsDown, bsExclusive] then
        Button := tbPushButtonPressed
      else
        if MouseInControl then
          Button := tbPushButtonHot
        else
          Button := tbPushButtonNormal;
    ToolButton := ttbToolbarDontCare;
    if Flat then
    begin
      case Button of
        tbPushButtonDisabled:   Toolbutton := ttbButtonDisabled;
        tbPushButtonPressed:    Toolbutton := ttbButtonPressed;
        tbPushButtonHot:        Toolbutton := ttbButtonHot;
        tbPushButtonNormal:     Toolbutton := ttbButtonNormal;
      end;
    end;
    PaintRect := ClientRect;
    if ToolButton = ttbToolbarDontCare then
    begin
      Details := ThemeServices.GetElementDetails(Button);
      PaintRect := ThemeServices.ContentRect(Canvas.Handle, Details, PaintRect);
    end
    else
    begin
      Details := ThemeServices.GetElementDetails(ToolButton);
      PaintRect := ThemeServices.ContentRect(Canvas.Handle, Details, PaintRect);
    end;
    if Button = tbPushButtonPressed then
      Offset.X := 1;
  end
  else
  begin
    PaintRect := Rect(0, 0, Width, Height);
    if Flat then InflateRect(PaintRect, -1, -1);
    if FState in [bsDown, bsExclusive] then
    begin
      Offset.X := 1;
      Offset.Y := 1;
    end;
  end;
  CalcGlyphPos(
    PaintRect, Offset, Margin, Spacing, inherited Caption, glyphpos,
    DrawTextBiDiModeFlags(0)
  );
  with glyphpos do
  begin
    if ThemeServices.ThemesEnabled then
    begin
      R.TopLeft := GlyphPos;
      R.Right := R.Left + Integer(aGlyph.GlyphWidth);
      R.Bottom := R.Top + aGlyph.Height;
      aGlyph.DoDraw(Canvas,R.Left,R.Top, GlyphIx);
    end
  end;
  aGlyph.DoDraw(Canvas, glyphpos.X, glyphpos.Y, GlyphIx);
  GlyphIx := oldGlyphIx;
end;

function TAlphaSpeedBtn.Replace(sb: TSpeedButton): TAlphaSpeedBtn;
var sbName : ShortString;
begin
  Assign(sb);
  sbName := sb.Name;
  sb.Free;
  Name := sbName;
  Result := self;
end;

procedure TAlphaSpeedBtn.Assign(Source: TPersistent);
var spd : TSpeedButton;
begin
  if Source <> nil then
  begin
    if Source.ClassName <> 'TSpeedButton' then inherited Assign(Source)
    else
    begin
      spd := Source As TSpeedButton;
      // TSpeedButton Properties
      Action := spd.Action;
      AllowAllUp := spd.AllowAllUp;
      Anchors := spd.Anchors;
      BiDiMode := spd.BiDiMode;
      Constraints := spd.Constraints;
      GroupIndex := spd.GroupIndex;
      Down := spd.Down;
      Caption := spd.Caption;
      Enabled := spd.Enabled;
      Flat := spd.Flat;
      Font := spd.Font;
//    Glyph := spd.Glyph; // assignment of glyph does not work!
      Layout := spd.Layout;
      Margin := spd.Margin;
//    NumGlyphs := spd.NumGlyphs; // therefore assignment of num is not valid either
      ParentFont := spd.ParentFont;
      ParentShowHint := spd.ParentShowHint;
      ParentBiDiMode := spd.ParentBiDiMode;
      PopupMenu := spd.PopupMenu;
      ShowHint := spd.ShowHint;
      Spacing := spd.Spacing;
      Transparent := spd.Transparent;
      Visible := spd.Visible;
      OnClick := spd.OnClick;
      OnDblClick := spd.OnDblClick;
      OnMouseDown := spd.OnMouseDown;
      OnMouseMove := spd.OnMouseMove;
      OnMouseUp := spd.OnMouseUp;

      // TControl Properties;
      Left := spd.Left;
      Top := spd.Top;
      Width := spd.Width;
      Height := spd.Height;
      Cursor := spd.Cursor;
      Hint := spd.Hint;
      HelpType := spd.HelpType;
      HelpKeyword := spd.HelpKeyword;
      HelpContext := spd.HelpContext;
      Parent := spd.Parent;
    end;
  end;
end;

procedure TAlphaSpeedBtn.CalcGlyphPos(const Client: TRect; const Offset: TPoint;
                                      Margin, Spacing: Integer; Caption: String;
                                      var GlyphPos: TPoint; BiDiFlags: Longint);
var
  TextPos: TPoint;
  ClientSize, GlyphSize, TextSize: TPoint;
  TotalSize: TPoint;
  TextBounds: TRect;

begin
  if (BiDiFlags and DT_RIGHT) = DT_RIGHT then
    if Layout = blGlyphLeft then Layout := blGlyphRight
    else
      if Layout = blGlyphRight then Layout := blGlyphLeft;

  { text und glyph größen berechnen }
  ClientSize := Point(Client.Right - Client.Left, Client.Bottom -
    Client.Top);

  if aGlyph <> nil then
    GlyphSize := Point(aGlyph.GlyphWidth, aGlyph.Height)
  else
    GlyphSize := Point(0, 0);

  if Length(Caption) > 0 then
  begin
    TextBounds := Rect(0, 0, Client.Right - Client.Left, 0);
    DrawText(Canvas.Handle, PChar(Caption), Length(Caption), TextBounds,
      DT_CALCRECT or BiDiFlags);
    TextSize := Point(TextBounds.Right - TextBounds.Left, TextBounds.Bottom -
      TextBounds.Top);
  end
  else
  begin
    TextBounds := Rect(0, 0, 0, 0);
    TextSize := Point(0,0);
  end;

  { Wenn Glyph rechts oder links vom Text ist, werden beide vertikal zentriert.
    Wenn Glyph über oder runter dem Text ist, werden beide horizontal zentriert.}
  if Layout in [blGlyphLeft, blGlyphRight] then
  begin
    GlyphPos.Y := (ClientSize.Y - GlyphSize.Y + 1) div 2;
    TextPos.Y := (ClientSize.Y - TextSize.Y + 1) div 2;
  end
  else
  begin
    GlyphPos.X := (ClientSize.X - GlyphSize.X + 1) div 2;
    TextPos.X := (ClientSize.X - TextSize.X + 1) div 2;
  end;

  { kein Text, kein Glyph => kein Spacing.}
  if (TextSize.X = 0) or (GlyphSize.X = 0) then
    Spacing := 0;

  { Margin und Spacing berechnen }
  if Margin = -1 then
  begin
    if Spacing = -1 then
    begin
      TotalSize := Point(GlyphSize.X + TextSize.X, GlyphSize.Y + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then
        Margin := (ClientSize.X - TotalSize.X) div 3
      else
        Margin := (ClientSize.Y - TotalSize.Y) div 3;
//      Spacing := Margin;
    end
    else
    begin
      TotalSize := Point(GlyphSize.X + Spacing + TextSize.X, GlyphSize.Y +
        Spacing + TextSize.Y);
      if Layout in [blGlyphLeft, blGlyphRight] then
        Margin := (ClientSize.X - TotalSize.X + 1) div 2
      else
        Margin := (ClientSize.Y - TotalSize.Y + 1) div 2;
    end;
  end
  else
  begin
    if Spacing = -1 then
    begin
      TotalSize := Point(ClientSize.X - (Margin + GlyphSize.X), ClientSize.Y -
        (Margin + GlyphSize.Y));
//      if Layout in [blGlyphLeft, blGlyphRight] then
//        Spacing := (TotalSize.X - TextSize.X) div 2
//      else
//        Spacing := (TotalSize.Y - TextSize.Y) div 2;
    end;
  end;

  case Layout of
    blGlyphLeft:    GlyphPos.X := Margin;
    blGlyphRight:   GlyphPos.X := ClientSize.X - Margin - GlyphSize.X;
    blGlyphTop:     GlyphPos.Y := Margin;
    blGlyphBottom:  GlyphPos.Y := ClientSize.Y - Margin - GlyphSize.Y;
  end;

  { GlyphPos ausrichten}
  with GlyphPos do
  begin
    Inc(X, Client.Left + Offset.X);
    Inc(Y, Client.Top + Offset.Y);
  end;
end;

{------------------------------------------------------------------------------}
{- Global AlphaBlending Functions ---------------------------------------------}
{------------------------------------------------------------------------------}
var OSAlphaBlend : Boolean; // wahr, wenn AlphaBlend-Funktion im OS integriert ist.

function DoAlphaBlend(destCanvas: TCanvas; dLeft, dTop, dWidth, dHeight: Integer;
                      sourceCanvas: TCanvas; sLeft, sTop, sWidth, sHeigth: Integer;
                      sourceConstantAlpha: Byte): Boolean;
var
  bf : BLENDFUNCTION;      // structure for alpha blending
begin
  if OSAlphaBlend then begin
    bf.BlendOp := AC_SRC_OVER;
    bf.BlendFlags := 0;
    bf.SourceConstantAlpha := sourceConstantAlpha;
    bf.AlphaFormat := AC_SRC_ALPHA;
    Result := Windows.AlphaBlend(destCanvas.Handle,dLeft,dTop,dWidth,dHeight,
                                     sourceCanvas.Handle,sLeft,sTop,sWidth,sHeigth,bf
    );
  end
  else
    Result := False;
    // here should be a self written AlphaBlend-function. But I doubt that
    // anyone needs it, because it only would be used by Win95/NT4 users.
end;

function Premultiply(bmp:TBitmap): TBitmap;
var
  pix : PPixelRec32;
  x,y : Integer;
begin
  ASSERT(bmp.PixelFormat = pf32bit,'PixelFormat must be pf32bit');
  for y := 0 to bmp.Height-1 do
  begin
    pix := bmp.ScanLine[y];
    for x := 0 to bmp.Width-1 do
    begin
      if pix.A = 0 then pix.I := $00000000 // transparent
      else if pix.A < 255 then
      begin
        pix.R := (pix.R * pix.A) div 255;
        pix.G := (pix.G * pix.A) div 255;
        pix.B := (pix.B * pix.A) div 255;
      end;
      inc(pix);
    end;
  end;
  Result := bmp;
end;

function GrayScaleBitmap(bmp:TBitmap): TBitmap;
var
  pix : PPixelRec32;
  x,y : Integer;
  gray: Byte;
begin
  for y := 0 to bmp.Height-1 do
  begin
    pix := bmp.ScanLine[y];
    for x := 0 to bmp.Width-1 do
    begin
      gray := Round(0.30 * pix.R + 0.59 * pix.G + 0.11 * pix.B);
      pix.R := gray; pix.G := gray; pix.B := gray;
      if bmp.PixelFormat = pf32bit then inc(pix)
      else inc(PPixelRec24(pix)); // just skip 3 bytes
    end;
  end;
  Result := bmp;
end;

// nicht besonders elegant, aber geht...
function CropImageRect(bmp:TBitmap; rect:TRect): TRect;
var
  pix : PPixelRec32;
  x,y : Integer;
begin
  ASSERT(bmp.PixelFormat = pf32bit,'PixelFormat must be pf32bit');
  // nach Premultiply enthalten alle unwesentlichen Pixel 0
  while rect.Top < rect.Bottom do
  begin
    pix := bmp.ScanLine[rect.Top];
    inc(pix,rect.Left);
    for x:=rect.Left to rect.Right do
    begin
      if pix.I <> $00000000 then break; // oberer Rand gefunden
      inc(pix);
    end; {for}
    if (x < rect.Right) then break; // break in for-loop
    inc(rect.Top);
  end; {while}
  while rect.Top < rect.Bottom do
  begin
    pix := bmp.Scanline[rect.Bottom];
    inc(pix,rect.Left);
    for x:=rect.Left to rect.Right do
    begin
      if pix.I <> $00000000 then break; // untere Rand gefunden
      inc(pix);
    end; {for}
    if (x < bmp.Width-1) then break;
    dec(rect.Top);
  end; {while}
  // die Top und die Bottom Zeile enthält nun Daten, wenn nicht Bottom=Top
  while rect.Left < rect.Right do
  begin
    for y:=rect.Top to rect.Bottom do
    begin
      pix := bmp.ScanLine[y];
      inc(pix,rect.Left);
      if pix.I <> $00000000 then break; // linker Rand gefunden
    end; {for}
    if y < rect.Bottom then break;
    inc(rect.Left);
  end; {while}
  while rect.Left < rect.Right do
  begin
    for y:=rect.Top to rect.Bottom do
    begin
      pix := bmp.ScanLine[y];
      inc(pix,rect.Right);
      if pix.I <> $00000000 then break; // rechter Rand gefunden
    end; {for}
    if y < rect.Bottom then break;
    dec(rect.Right);
  end; {while}
  Result := rect;
end;

procedure SetOSAlphaBlend;
var
  v : TOSVERSIONINFO;
begin
  OSAlphaBlend := True;
  ZeroMemory(@v,SizeOf(v));
  v.dwOSVersionInfoSize := sizeof(TOSVERSIONINFO);
  GetVersionEx(v);
  case v.dwPlatformId of
    VER_PLATFORM_WIN32_NT:
    begin
      if(v.dwMajorVersion <= 4) then
        OSAlphaBlend := False;  // Windows NT
    end;
    VER_PLATFORM_WIN32_WINDOWS:
    begin
      if(v.dwMajorVersion = 4) and (v.dwMinorVersion = 0) then
        OSAlphaBlend := False;  // Windows 95
    end;
  else                          // Win32s (Windows 3.11 (unlikely))
    OSAlphaBlend := False;
  end;
end;

initialization
  SetOSAlphaBlend;

end.
