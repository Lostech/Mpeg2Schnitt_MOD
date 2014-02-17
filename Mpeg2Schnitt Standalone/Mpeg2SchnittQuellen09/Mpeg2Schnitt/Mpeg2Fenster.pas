{----------------------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------------}

unit Mpeg2Fenster;

interface

USES Mpeg2decoder,    // Funktionen zur Mpeg2-Decodierung
     SysUtils,        // für PByteArray, ExtractFilePath
     Windows,         // für Bibliothekfunktionen
     Types,           // für Bounds
     Forms,           // für Application.ProcessMessages
     DirectDraw,      // DirectDraw Funktionen
     Dialogs,         // für ShowMessage
     Sprachen,        // zum übersetzen der Meldungen
     Classes,         // für TList
     Graphics,        // für TBitMap
     DateUtils,       // Zeitfunktionen
     Mpeg2Unit,       // für THeaderklein ...
{0.7.2.1q6+}
     SyncObjs,        // für TEvent
     Protokoll,
     mmsystem,        // Multimediatimer
     AllgFunktionen,  // Meldungsfenster
     AllgVariablen,   // alllgemeine Variablen
     StdCtrls,        // Für TLabel
     DatenTypen;      // Typdefinitionen


type
  TAbspielmode = (mpNotReady, mpStopped, mpPlaying, mpRecording, mpSeeking, mpPaused, mpOpen);

  TRGBRec = packed record
             Blau,
             Gruen,
             Rot : Byte;
           end;
  PRGBRec = ^TRGBRec;

  TVideoPositionuebergeben = PROCEDURE(VAR Position: LongInt) OF OBJECT;
  TAudioplayersynchronisieren = FUNCTION: Boolean OF OBJECT;
  TAudioplayerPositionholen = FUNCTION: LongInt OF OBJECT;
  TStoppen = PROCEDURE OF OBJECT;

{0.7.2.1q6b - Änderungen ab hier ----------------------------------------------}
  TVideoThread = class(TThread)
  private
    restartEvent: TSimpleEvent;
    anhalten: Boolean;
    PlayerPosition : LongInt;
    Audiovorhanden : Boolean;
    Takt,
    StartZeit : Int64;
    Tempo1 : Real;
    procedure VideoAnhalten;
    procedure VideoStarten;
    PROCEDURE Audiosynchronisieren;
    PROCEDURE AudioPositionholen;
    PROCEDURE StartZeitsetzen;
    PROCEDURE VideoPositionholen;
    PROCEDURE VideoBildPositionuebergeben;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute; override;
  end;
{0.7.2.1q6b - Änderungen bis hier ---------------------------------------------}

VAR
  VideoThread : TVideoThread;
{0.7.2.1q6b - Thread war immer noch nicht perfekt}
  csThreadProtect: TCriticalSection;  // schützt verschiedene Functionen gegen
    // gleichzeitige aufrufe aus verschiedenen Threads. Das mag die Mpeg2lib.dll
    // nicht...

//  BildBreite : Integer;
//  BildHoehe : Integer;
  Framerate : Double;
  Tempo : Real = 1;
  PositionAnfang,
  VideoBildPosition : LongInt;
// ---------- Direct Draw Variablen -------------------
  DirectDrawObjekt : IDirectDraw7;       // DirectDraw Objekt
  ErstesFenster : IDirectDrawSurface7;   // Surface 1
  ZweitesFenster : IDirectDrawSurface7;  // Surface 2
  Clipper : IDirectDrawClipper;          // Clippbereich
//  PaintFX : TDDBLTFX;
// ---------- Abspieler Variablen ---------------------
  Videoabspieler_OK : Boolean;
  Dateiname : STRING;
  anhalten : Boolean;
  AnzeigefensterX,
  AnzeigefensterY,
  AnzeigefensterBreite,
  AnzeigefensterHoehe : Integer;
  AnzeigefensterHandle : HWND;
  VideoPositionuebergeben : TVideoPositionuebergeben;
  Audioplayersynchronisieren : TAudioplayersynchronisieren;
  AudioplayerPositionholen : TAudioplayerPositionholen;
  Grau : Boolean;
  VideoabspielerMode : TAbspielmode;
  Fenster : TForm;
  StartBild : LongInt;
//  StartZeit : TDateTime;
  Stoppen : TStoppen;
  VideoListe,
  VideoIndexListe : TListe;
  NurIFrames : Boolean;
  Framefehleranzeige : TLabel;
  Bild : PByteArray;

//================= Mpeg2 - Programme =============================
PROCEDURE Bildeigenschaften_feststellen;
// -- lädt die Bildeigenschaften der Mpeg2-Datei in die Variablen

//================= Direct Draw - Programme =============================
FUNCTION DirectDrawObjekt_erzeugen(Handle: THandle; Breite, Hoehe, Farben: Longword): HResult;
// -- Erzeugt ein DirectDraw Objekt im Speicher
FUNCTION ErstesSurface_erzeugen: HResult;
// -- Erzeugt das primäre Fenster
FUNCTION ZweitesSurface_erzeugen(Breite, Hoehe: Longword): HResult;
// -- Erzeugt das sekundäre Fenster (Hintergrundfenster)
FUNCTION Clipper_erzeugen(AnzeigefensterHandle: HWND): HResult;
// -- Erzeugt ein Clipperobjekt
FUNCTION Bild_kopieren(Bild: PByteArray; AnzeigeFenster: IDirectDrawSurface7): HResult;
// -- kopiert das Bild aus der Mpeg2-Datei in das Surface
FUNCTION Bild_anzeigen(X, Y, Breite, Hoehe: Integer): HResult;
// -- Blittet das Zweite auf das Erste Fenster
FUNCTION Bild_aktualisieren: HResult;
// -- aktualisiert die Bildanzeige mit neuen Anzeigefensterwerten
PROCEDURE Surface_freigeben(VAR Surface: IDirectDrawSurface7);
// -- das übergebene Surface wird freigegeben
PROCEDURE ZweitesSurface_freigeben;
// -- das Zweite (Hintergrund) Surface wird freigegeben
PROCEDURE DirectDrawObjekt_freigeben;
// -- gibt alles wieder frei

//================= Abspiel - Programme =============================
FUNCTION Videoabspieler_erzeugen: Boolean;
PROCEDURE Videoabspieler_freigeben;
PROCEDURE VideoFarbeeinstellen(Farbe: Integer);
FUNCTION Videodatei_laden(Name: STRING; Liste, IndexListe: TListe): Boolean;
PROCEDURE Videodatei_freigeben;
PROCEDURE VideoPlay;
// -- Video abspielen
{0.7.2.1q6c}
{PROCEDURE VideoStop;}
// -- Video stoppen
PROCEDURE VideoPause;

{0.7.2.1q6+ - zusätzliche Routine, um Aufruf zu vereinheitlichen }
PROCEDURE VideoThreadInit;
{----------}

FUNCTION Ein_Bild_anzeigen: Boolean;
FUNCTION BildPosition(IBildNr, BildPos: LongInt; Position: Int64): Boolean;

// ========= Proceduren und Funktionen von Igor Feldhaus =============
//procedure aktuellesBildzuBitmap(var bmp:Tbitmap; Liste, Indexliste: TList);
//function BildErneutEinlesen(Pixelformat: byte; Liste, Indexliste: TList) : pbytearray;

// ========= Bild als PByteArray oder BMP einlesen =============
function GrauPalette() : hpalette;
FUNCTION Positionieren(Position: LongInt; IFrame: Boolean = False): Integer;
FUNCTION Bildlesen(Position: LongInt; IFrame: Boolean): PByteArray;
FUNCTION BMPBildlesen(Position: LongInt; Weite: Integer; Positionwiederherstellen, IFrame: Boolean): TBitmap; OVERLOAD;
FUNCTION BMPBildlesen1(Datei: STRING; Liste, IndexListe: TListe; Position: LongInt; Weite: Integer; Positionwiederherstellen, IFrame: Boolean): TBitmap; OVERLOAD;

implementation

//================= Mpeg2 - Programme =============================

PROCEDURE Bildeigenschaften_feststellen;

VAR Bildeigenschaften : TBildeigenschaften;

BEGIN
  GetMPEG2FrameInfo(Bildeigenschaften);         // Eigenschaften des Videos lesen
  BildBreite := Bildeigenschaften.Breite;
  BildHoehe := Bildeigenschaften.Hoehe;
  Framerate := Bildeigenschaften.FrameRate;
END;

//================= Direct Draw - Programme =============================

FUNCTION DirectDrawObjekt_erzeugen(Handle: THandle; Breite, Hoehe, Farben: Longword): HResult;

VAR Erg : HResult;

BEGIN
//  PaintFX.dwSize := SizeOf(PaintFX);
  Result := 0;
  Erg := 0;
  IF DirektDraw_OK THEN
  BEGIN
    TRY
      TRY
        Erg :=DirectDrawCreateEx(nil, DirectDrawObjekt, IID_IDirectDraw7, nil);
      FINALLY
        IF Failed(Erg) THEN
        BEGIN
          DirectDrawObjekt := NIL;
          Result := 2;                 // DirectDrawObjekt erzeugen fehlgeschlagen
        END
        ELSE
        BEGIN
          TRY
            Erg := DirectDrawObjekt.SetCooperativeLevel(Handle, DDSCL_NORMAL);
          FINALLY
            IF Failed(Erg) THEN
            BEGIN
              DirectDrawObjekt := NIL;
              Result := 3;             // Kooperativlevel läst sich nicht setzen
            END
            ELSE
            BEGIN
              TRY
                DirectDrawObjekt.SetDisplayMode(Breite, Hoehe, Farben, 0, 0);
              FINALLY
                IF Failed(Erg) THEN
                BEGIN
                  DirectDrawObjekt := NIL;
                  Result := 4;         // Displaymode läst sich nicht einstellen
                END;
              END;
            END;
          END;
        END;
      END;
    EXCEPT
    END;
  END
  ELSE
  BEGIN
    DirectDrawObjekt := NIL;
    Result := 1;                     // DDraw.dll nicht gefunden
  END;
END;

FUNCTION ErstesSurface_erzeugen: HResult;

VAR SurfaceDesc: TDDSurfaceDesc2;
    Erg : HResult;

BEGIN
  Result := 0;
  Erg := 0;
  IF ErstesFenster <> NIL THEN
  BEGIN
    ErstesFenster._Restore;
    ErstesFenster := NIL;
  END;
  IF Assigned(DirectDrawObjekt) THEN
  BEGIN
    FillChar(SurfaceDesc, SizeOf(SurfaceDesc), 0); // alles mit 0 initialisieren
    SurfaceDesc.dwSize := SizeOf(SurfaceDesc);     // Größe setzen
    SurfaceDesc.dwFlags := DDSD_CAPS;
    SurfaceDesc.ddsCaps.dwCaps := DDSCAPS_PRIMARYSURFACE;      // Primärsurface erzeugen
    TRY
      TRY
        Erg := DirectDrawObjekt.CreateSurface(SurfaceDesc, ErstesFenster, NIL);
      FINALLY
        IF Failed(Erg) THEN
        BEGIN
          ErstesFenster := NIL;
          Result := 2;            // Surface erzeugen fehlgeschlagen
        END;
      END;
    EXCEPT
    END;
  END
  ELSE
    Result := 1;              // kein DirectDrawObjekt vorhanden
END;

FUNCTION ZweitesSurface_erzeugen(Breite, Hoehe: Longword): HResult;

VAR SurfaceDesc: TDDSurfaceDesc2;
    Erg : HResult;

BEGIN
  Result := 0;
  Erg := 0;
  IF Assigned(ZweitesFenster) THEN
    ZweitesSurface_freigeben;
  IF DirectDrawObjekt <> NIL THEN
  BEGIN
    FillChar(SurfaceDesc, SizeOf(SurfaceDesc), 0); // alles mit 0 initialisieren
    SurfaceDesc.dwSize := SizeOf(SurfaceDesc);     // Größe setzen
    SurfaceDesc.dwFlags := DDSD_CAPS or DDSD_WIDTH or DDSD_HEIGHT;
    SurfaceDesc.ddsCaps.dwCaps := DDSCAPS_OFFSCREENPLAIN;      // Hintergrundsurface erzeugen
    SurfaceDesc.dwWidth:=Breite;                               // Videogröße
    SurfaceDesc.dwHeight:=Hoehe;
    TRY
      TRY
        Erg := DirectDrawObjekt.CreateSurface(SurfaceDesc, ZweitesFenster, NIL);
      FINALLY
        IF Failed(Erg) THEN
        BEGIN
          ZweitesSurface_freigeben;
          Result := 2;            // Surface erzeugen fehlgeschlagen
        END;
      END;
    EXCEPT
    END;
  END
  ELSE
    Result := 1;              // kein DirectDrawObjekt vorhanden
END;

FUNCTION Clipper_erzeugen(AnzeigefensterHandle: HWND): HResult;

VAR Erg : HResult;

BEGIN
  Result := 0;
  Erg := 0;
  IF Assigned(Clipper) THEN
    Clipper := NIL;
  IF Assigned(DirectDrawObjekt) THEN
  BEGIN
    TRY
      TRY
        Erg := DirectDrawObjekt.CreateClipper(0, Clipper, NIL);
      FINALLY
        IF Failed(Erg) THEN
        BEGIN
          Clipper := NIL;
          Result := 2;          // Clipper erzeugen fehlgeschlagen
        END
        ELSE
        BEGIN
          Clipper.SetHWnd(0, AnzeigefensterHandle);
          IF Assigned(ErstesFenster) THEN
            ErstesFenster.SetClipper(Clipper)
          ELSE
            Result := 3;        // kein erstes Fenster vorhanden
 //         Clipper := NIL;
        END;
      END;
    EXCEPT
    END;
  END
  ELSE
    Result := 1;                // kein DirectDrawObjekt vorhanden
END;

// -------- die folgenden Programmzeilen wurden mir zur Verfügung gestellt ------------
// -------- diese Funktionen sind für die Anzeige bei 16 Bit Farbtiefe nötig ----------

function GetColorBits(dwMask:DWord):byte;
var i,shlval:DWord;
begin
  result:=0;
  shlval:=1;
  for i:=0 to 31 do begin
    if dwMask and shlval<>0 then inc(result);
    shlval:=shlval shl 1;
  end;
end;

function GetColorPos(dwMask:DWord):byte;
var shlval:DWord;
begin
  result:=0;
  shlval:=1;
  while(dwMask and shlval=0) do begin
    inc(result);
    shlval:=shlval shl 1;
  end;
end;

// ---------------------- Ende 16 Bit Farbtiefe ---------------------------------------

FUNCTION Bild_kopieren(Bild: PByteArray; AnzeigeFenster: IDirectDrawSurface7): HResult;

VAR  SurfaceDesc: TDDSurfaceDesc2;
     X, Y : Integer;
     BildpunktRGB : PRGBRec;
     Bildpunkt32 : PDWord;
     BildpunktGrau : PByte;
     Erg : HResult;
     Farbtiefe : LongWord;
     Bildpunkt16 : PWord;                                       // für 16 Bit Farbtiefe
     RBits, GBits, BBits,
     RPos, GPos, BPos : Byte;

BEGIN
  Result := 0;
  IF Assigned(DirectDrawObjekt) THEN
  BEGIN
    IF Assigned(AnzeigeFenster) THEN
    BEGIN
      FillChar(SurfaceDesc, SizeOf(SurfaceDesc), 0);
      SurfaceDesc.dwSize := SizeOf(SurfaceDesc);
      TRY
        TRY
          Erg := AnzeigeFenster.Lock(NIL, SurfaceDesc, DDLOCK_WAIT OR DDLOCK_WRITEONLY, 0);
          IF NOT Failed(Erg) THEN
          BEGIN
            Farbtiefe := SurfaceDesc.ddpfPixelFormat.dwRGBBitCount + (Word(Grau) * 100);
            CASE Farbtiefe OF
// -------- diese Funktionen sind für die Anzeige bei 16 Bit Farbtiefe nötig ----------
             16: BEGIN
                    with SurfaceDesc.ddpfPixelFormat do begin
                      RBits:=8-GetColorBits(dwRBitMask);
                      GBits:=8-GetColorBits(dwGBitMask);
                      BBits:=8-GetColorBits(dwBBitMask);
                      RPos:=GetColorPos(dwRBitMask);
                      GPos:=GetColorPos(dwGBitMask);
                      BPos:=GetColorPos(dwBBitMask);
                    end;
                    BildpunktRGB:=Pointer(Bild);
                    for Y := SurfaceDesc.dwHeight - 1 DOWNTO 0 DO
                    BEGIN
                      Bildpunkt16 := Pointer(Integer(SurfaceDesc.lpSurface) + Y * SurfaceDesc.lPitch);
                      FOR X := 1 TO SurfaceDesc.dwWidth DO
                      BEGIN
                        Bildpunkt16^:=(BildpunktRGB.Blau shr BBits shl BPos) OR
                                      (BildpunktRGB.Gruen shr GBits shl GPos) OR
                                      (BildpunktRGB.Rot shr RBits shl RPos);
                        Inc(BildpunktRGB);
                        Inc(Bildpunkt16);
                      END;
                    END;
                  END;
             116: BEGIN
                    with SurfaceDesc.ddpfPixelFormat do begin
                      RBits:=8-GetColorBits(dwRBitMask);
                      GBits:=8-GetColorBits(dwGBitMask);
                      BBits:=8-GetColorBits(dwBBitMask);
                      RPos:=GetColorPos(dwRBitMask);
                      GPos:=GetColorPos(dwGBitMask);
                      BPos:=GetColorPos(dwBBitMask);
                    end;
                    BildpunktGrau:=Pointer(Bild);
                    for Y := 0 TO SurfaceDesc.dwHeight - 1 DO
                    BEGIN
                      Bildpunkt16 := Pointer(Integer(SurfaceDesc.lpSurface) + Y * SurfaceDesc.lPitch);
                      FOR X := 1 TO SurfaceDesc.dwWidth DO
                      BEGIN
                        Bildpunkt16^:=(BildpunktGrau^ shr BBits shl BPos) OR
                                      (BildpunktGrau^ shr GBits shl GPos) OR
                                      (BildpunktGrau^ shr RBits shl RPos);
                        Inc(BildpunktGrau);
                        Inc(Bildpunkt16);
                      END;
                    END;
                  END;
// ---------------------- Ende 16 Bit Farbtiefe ---------------------------------------
              32: BEGIN
                    BildpunktRGB:=Pointer(Bild);
                    FOR Y := SurfaceDesc.dwHeight - 1 DOWNTO 0 DO
                    BEGIN
                      Bildpunkt32:=Pointer(Integer(SurfaceDesc.lpSurface) + Y * SurfaceDesc.lPitch);
                      FOR X := 1 TO SurfaceDesc.dwWidth DO
                      BEGIN
                        Bildpunkt32^ := PDWord(BildpunktRGB)^;
                        Inc(BildpunktRGB);
                        Inc(Bildpunkt32);
                      END;
                    END;
                  END;
              24: BEGIN
                    BildpunktRGB:=Pointer(Bild);
                    X := SurfaceDesc.dwWidth * 3;
                    FOR Y := SurfaceDesc.dwHeight - 1 DOWNTO 0 DO
                    BEGIN
                      Move(BildpunktRGB^, Pointer(Integer(SurfaceDesc.lpSurface) + Y * SurfaceDesc.lPitch)^, X);
                      Inc(PByte(BildpunktRGB), X);
                    END;
                  END;
             132: BEGIN
                    BildpunktGrau:=Pointer(Bild);
                    FOR Y := 0 TO SurfaceDesc.dwHeight - 1 DO
                    BEGIN
                      Bildpunkt32 := Pointer(Integer(SurfaceDesc.lpSurface) + Y * SurfaceDesc.lPitch);
                      FOR X := 1 TO SurfaceDesc.dwWidth DO
                      BEGIN
                        Bildpunkt32^:=BildpunktGrau^ OR (BildpunktGrau^ SHL 8) OR (BildpunktGrau^ SHL 16);
                        Inc(BildpunktGrau);
                        Inc(Bildpunkt32);
                      END;
                    END;
                  END;
             124: BEGIN
                    BildpunktGrau:=Pointer(Bild);
                    FOR Y := 0 TO SurfaceDesc.dwHeight - 1 DO
                    BEGIN
                      BildpunktRGB:=Pointer(Integer(SurfaceDesc.lpSurface)+Y*SurfaceDesc.lPitch);
                      FOR X:=1 TO SurfaceDesc.dwWidth DO
                      BEGIN
                        BildpunktRGB^.Blau := BildpunktGrau^;
                        BildpunktRGB^.Gruen := BildpunktGrau^;
                        BildpunktRGB^.Rot := BildpunktGrau^;
                        Inc(BildpunktGrau);
                        Inc(BildpunktRGB);
                      END;
                    END;
                  END;
            END;
          END
          ELSE
            Result := 3;   // Anzeigefenster läst sich nicht Locken
        FINALLY
          AnzeigeFenster.UnLock(NIL);
        END;
      EXCEPT
      END;
    END
    ELSE
      Result := 2;             // Anzeigefenster ungültig
  END
  ELSE
    Result := 1;     // kein DirectDrawObjekt vorhanden
END;

FUNCTION Bild_anzeigen(X, Y, Breite, Hoehe: Integer): HResult;

VAR Anzeigebereich : TRect;
    Erg : HResult;

BEGIN
  Result := 0;
  Erg := 0;
  IF DirectDrawObjekt <> NIL THEN
  BEGIN
    Anzeigebereich := Bounds(X, Y, Breite, Hoehe);
    IF ZweitesFenster = NIL THEN
    BEGIN
      Result := 2;
    END
    ELSE
    BEGIN
      TRY
        Erg := ErstesFenster.Blt(@Anzeigebereich, ZweitesFenster, NIL, DDBLT_WAIT, NIL); //@PaintFX);
      EXCEPT
      END;
      IF Failed(Erg) THEN
      BEGIN
        Result := 3;   // Umkopieren des Fensterbereiches fehlgeschlagen
      END;
    END;
  END
  ELSE
    Result := 1;     // kein DirectDrawObjekt vorhanden
END;

FUNCTION Bild_aktualisieren: HResult;

VAR Rand,
    Randoben : Integer;

BEGIN
  Rand := Round((Fenster.Width - Fenster.ClientWidth) / 2);
  Randoben := Fenster.Height - Fenster.ClientHeight - Rand;
//  Anzeigenfenster
  Result := Bild_anzeigen(AnzeigefensterX + Fenster.Left + Rand, AnzeigefensterY + Fenster.Top + Randoben, AnzeigefensterBreite, AnzeigefensterHoehe);
//  Bild_anzeigen(AnzeigefensterX + Fenster.Left, AnzeigefensterY + Fenster.Top, AnzeigefensterBreite, AnzeigefensterHoehe);
END;

PROCEDURE Surface_freigeben(VAR Surface: IDirectDrawSurface7);
BEGIN
  IF Surface <> NIL THEN
  BEGIN
    TRY
      TRY
        Surface._Restore;
      FINALLY
        Surface := NIL;
      END;
    EXCEPT
    END;
  END;
END;

PROCEDURE ZweitesSurface_freigeben;
BEGIN
  Surface_freigeben(ZweitesFenster);
END;

PROCEDURE DirectDrawObjekt_freigeben;
BEGIN
  IF DirectDrawObjekt <> NIL THEN
  BEGIN
    TRY
      TRY
        DirectDrawObjekt.RestoreAllSurfaces;
      FINALLY
        Clipper := NIL;
        Surface_freigeben(ErstesFenster);
        Surface_freigeben(ZweitesFenster);
        DirectDrawObjekt := NIL;
      END;
    EXCEPT
    END;
  END;
END;

//================= Abspiel - Programme =============================

FUNCTION Videoabspieler_erzeugen: Boolean;

VAR Nachricht : STRING;

BEGIN
  Videoabspieler_freigeben;
  Result := False;
  Nachricht := '';
  IF DirectDrawObjekt_erzeugen(Application.Handle, 0, 0, 0) = 0 THEN
  BEGIN
    IF ErstesSurface_erzeugen = 0 THEN
    BEGIN
      IF Clipper_erzeugen(AnzeigefensterHandle) = 0 THEN
      BEGIN
        IF Mpeg2Decoder_OK THEN
        BEGIN
          Videoabspieler_OK := True;
          Result := True;
        END
        ELSE
        BEGIN
          Nachricht := Wortlesen(NIL, 'Meldung73', 'Die Datei "mpeg2lib.dll" muß sich im Programmverzeichnis oder in einem Verzeichnis befinden das durch die Pathvariable erreichbar ist.');
        END;
      END
      ELSE
      BEGIN
        Nachricht := Wortlesen(NIL, 'Meldung68', 'Probleme beim erzeugen des Clipperobjektes.');
      END;
    END
    ELSE
    BEGIN
      Nachricht := Wortlesen(NIL, 'Meldung76', 'Probleme beim initialisieren der Videoanzeige.');
    END;
  END
  ELSE
  BEGIN
    Nachricht := Wortlesen(NIL, 'Meldung74', 'Ist DirectX 7 installiert? Die Datei "DDraw.dll" muß sich in einem Verzeichnis befinden das durch die Pathvariable erreichbar ist.');
  END;
  IF Nachricht <> '' THEN
    Meldungsfenster(Nachricht);
  VideoabspielerMode := mpStopped;
END;

PROCEDURE Videoabspieler_freigeben;
BEGIN
  IF Videoabspieler_OK THEN
  BEGIN
{0.7.2.1q6}
//    anhalten := True; // wird nicht mehr gebraucht
    DirectDrawObjekt_freigeben;
    IF Mpeg2Decoder_OK THEN
      CloseMPEG2File;
    Videoabspieler_OK := False;
    VideoListe := NIL;
    VideoIndexListe := NIL;
    Dateiname := '';
  END;
END;

PROCEDURE VideoFarbeeinstellen(Farbe: Integer);

VAR Mode : TAbspielmode;

BEGIN
  IF NOT(Grau = (Farbe = VideoFormatGray8)) THEN
    IF Mpeg2Decoder_OK THEN
    BEGIN
      Mode := VideoabspielerMode;
      IF Mode = mpPlaying THEN
        VideoPause;
      IF Farbe = VideoFormatGray8 THEN
        Grau := True;
      IF Farbe = VideoFormatRGB24 THEN
        Grau := False;
      SetMPEG2PixelFormat(Farbe);
      IF Mode = mpPlaying THEN
        VideoPlay;
    END;
END;

FUNCTION Videodatei_laden(Name: STRING; Liste, IndexListe: TListe): Boolean;
BEGIN
  IF Mpeg2Decoder_OK AND Videoabspieler_OK THEN
  BEGIN
    VideoListe := NIL;
    VideoIndexListe := NIL;
    IF OpenMPEG2File(PChar(Name)) THEN
    BEGIN
      Dateiname := Name;
      Bildeigenschaften_feststellen;
      Result := ZweitesSurface_erzeugen(BildBreite, BildHoehe) = 0;
      IF Result THEN
      BEGIN
        PositionAnfang := 0;
        VideoBildPosition := -1;
{        IF Ein_Bild_anzeigen THEN
        BEGIN
          IF Assigned(VideoPositionuebergeben) THEN
            VideoPositionuebergeben(VideoBildPosition);
          VideoListe := Liste;
          VideoIndexListe := IndexListe;
        END
        ELSE
        BEGIN
          Meldungsfenster(Wortlesen(NIL, 'Meldung77', 'Probleme bei der  Videodarstellung.'));
          Result := False;
        END;  }
          VideoListe := Liste;
          VideoIndexListe := IndexListe;
      END
      ELSE
      BEGIN
        Meldungsfenster(Wortlesen(NIL, 'Meldung76', 'Probleme beim initialisieren der Videoanzeige.'));
        Result := False;
      END;
    END
    ELSE
    BEGIN
      Dateiname := '';
      BildBreite := 0;
      BildHoehe := 0;
      Framerate := 0;
      Meldungsfenster(Meldunglesen(NIL, 'Meldung114', Name, 'Die Datei $Text1# läßt sich nicht öffnen.'));
      Result := False;
    END;
  END
  ELSE
    Result := False;
END;

PROCEDURE Videodatei_freigeben;
BEGIN
  IF Mpeg2Decoder_OK THEN
    CloseMPEG2File;
  IF Videoabspieler_OK THEN
    ZweitesSurface_freigeben;
  VideoListe := NIL;
  VideoIndexListe := NIL;
  Dateiname := '';
END;

FUNCTION Ein_Bild_anzeigen: Boolean;

VAR Dateieigenschaften : TDateieigenschaften;

BEGIN
  IF Mpeg2Decoder_OK AND Videoabspieler_OK THEN
  BEGIN
{0.7.2.1q6b ThreadProtection start}
    csThreadProtect.Acquire;
    GetMPEG2FileInfo(Dateieigenschaften);
    Bild := GetMPEG2Frame;
    csThreadProtect.Release;
{0.7.2.1q6b ThreadProtection ende}
    VideoBildPosition := PositionAnfang + LongInt(Dateieigenschaften.Frame) - 2;
    IF Assigned(Bild) THEN
    BEGIN
      IF Bild_kopieren(Bild, ZweitesFenster) = 0 THEN
      BEGIN
        IF Bild_aktualisieren = 0 THEN
//        IF Bild_anzeigen(AnzeigefensterX + Fenster.Left, AnzeigefensterY + Fenster.Top, AnzeigefensterBreite, AnzeigefensterHoehe) = 0 THEN
          Result := True
        ELSE
          Result := False;
      END
      ELSE
        Result := False;
    END
    ELSE
      Result := False;
  END
  ELSE
    Result := False;
END;

FUNCTION Bilder_weiter(Bilder: Integer): Boolean;

//VAR Dateieigenschaften : TDateieigenschaften;

BEGIN
  IF Mpeg2Decoder_OK AND Videoabspieler_OK THEN
  BEGIN
//    Result := True;
{0.7.2.1q6b ThreadProtection start}
    csThreadProtect.Acquire;
    SkipMPEG2Frames(Bilder);
//    GetMPEG2FileInfo(Dateieigenschaften);
    csThreadProtect.Release;
{0.7.2.1q6b ThreadProtection ende}
//    VideoBildPosition := PositionAnfang + Dateieigenschaften.Frame - 2;
    Result := Ein_Bild_anzeigen;
  END
  ELSE
    Result := False;
END;

FUNCTION BildPosition(IBildNr, BildPos: LongInt; Position: Int64): Boolean;
BEGIN
  IF Mpeg2Decoder_OK THEN
  BEGIN
    IF BildPos = VideoBildPosition THEN
    BEGIN
      Result := True;
      Exit;
    END;
{0.7.2.1q6b - Thread protect start}
    csThreadProtect.Acquire;
    IF (VideoBildPosition >= IBildNr) AND (BildPos > VideoBildPosition) THEN
    BEGIN
      IF (BildPos - VideoBildPosition) > 1 THEN
        SkipMPEG2Frames(BildPos - VideoBildPosition - 1);
    END
    ELSE
    BEGIN
      PositionAnfang := IBildNr;
      MPEG2Seek(Position);
      IF (BildPos - IBildNr) > 0 THEN
        SkipMPEG2Frames(BildPos - IBildNr);
    END;
    csThreadProtect.Release;
{0.7.2.1q6b - Thread protect end}
    Result := Ein_Bild_anzeigen;
  END
  ELSE
    Result := False;
END;

FUNCTION IFramePlay(Bilder: Integer = 1): Boolean;

VAR Eintrag : TBildIndex;
    Position : Integer;

BEGIN
  IF Assigned(VideoListe) AND
     Assigned(VideoIndexListe) THEN
  BEGIN
    IF Bilder < 1 THEN
      Bilder := 1;
    Position := VideoBildPosition + Bilder;
    IF Position < VideoIndexListe.Count - 1 THEN
    BEGIN
      Eintrag := VideoIndexListe.Items[Position];
      WHILE (Position < VideoIndexListe.Count - 1) AND (Eintrag.BildTyp > 1) DO
      BEGIN
        Inc(Position);
        Eintrag := VideoIndexListe.Items[Position];
      END;
      IF Eintrag.BildTyp = 1 THEN
        Result := BildPosition(Position, Position, THeaderklein(VideoListe.Items[Eintrag.BildIndex]).Adresse)
      ELSE
        Result := False;
    END
    ELSE
      Result := False;    
  END
  ELSE
    Result := False;
END;

{0.7.2.1q6c - VideoThread noch einmal umprogrammiert --------------------------}

{------------------------------------------------------------------------------}
{- TVideoThread Implementation ------------------------------------------------}
{------------------------------------------------------------------------------}

{0.7.2.1q6 VideoPlay muss in einem Thread stattfinden, da einige Events in
 Application.ProcessMessages nicht ausgeführt werden. Insbesondere OnMouseEnter/
 OnMouseLeave. Ursache dafür ist, das ProcessMessages nicht 'Application.Idle'
 aufruft. Dort werden solche Maus-Events generiert. Das Problem äußert sich
 dadurch, das SpeedButtons im Flat-Mode zwar einen Rand bekommen, wenn man mit
 der Maus über ihnen steht, der Rand aber aktiviert bleibt, wenn der
 Button wieder verlassen wird. (Nur wenn sich MPeg2Schnitt im VideoPlay-Loop
 befindet). Wenn VideoPlay aber in einem Thread ausgeführt wird, dann bleibt
 der Hauptfenster Msg-Loop aktiv und arbeitet alles Nachrichten wie gewohntab.
 (Info@: http://groups.google.de/groups?q=processMessages%20Speedbutton )

 Ich habe einfach die VideoPlay Routine in die Thread Execute Procedure über-
 führt (mit den nötigen Anpassungen) und es scheint zu funktionieren.
 ...
 Die Enschätzung war wohl ein wenig optimistisch. Die Mpeg2Lib mag es nicht,
 wenn sie gleichzeitig aus verschiedenen Threads angesprochen wird, daher waren
 zusätzlich Anpassungen zur Synchronisation der Mpeg2Lib-Funktionen nötig.
 (csThreadProtect aquire/release umklammert nun die kritischen Bereicht. Seitdem
 kein Absturz mehr.
}
constructor TVideoThread.Create;
begin
  anhalten := TRUE;
  restartEvent := TSimpleEvent.Create;
  inherited Create(False);
end;

destructor TVideoThread.Destroy;
begin
  restartEvent.Free;
  inherited Destroy;
end;

PROCEDURE TVideoThread.Audiosynchronisieren;
BEGIN
  IF Assigned(Audioplayersynchronisieren) THEN
    Audiovorhanden := Audioplayersynchronisieren
  ELSE
    Audiovorhanden := False;
END;

PROCEDURE TVideoThread.AudioPositionholen;
BEGIN
  IF Assigned(AudioplayerPositionholen) THEN
    Playerposition := AudioplayerPositionholen
  ELSE
    Playerposition := -1;
END;

PROCEDURE TVideoThread.StartZeitsetzen;
BEGIN
  Tempo1 := Tempo;
  QueryPerformanceCounter(StartZeit);
  Startzeit := Startzeit - Round((VideoBildPosition + 1) * Takt / Framerate / Tempo1);
END;

PROCEDURE TVideoThread.VideoPositionholen;

VAR aktZeit : Int64;

BEGIN
  IF Tempo <> Tempo1 THEN
    StartZeitsetzen;
  QueryPerformanceCounter(aktZeit);
  Playerposition := Round((aktZeit - StartZeit) * 1000 / Takt * Tempo1);
END;

PROCEDURE TVideoThread.VideoBildPositionuebergeben;
BEGIN
  IF Assigned(VideoPositionuebergeben) THEN
    VideoPositionuebergeben(VideoBildPosition);
END;

procedure TVideoThread.Execute; // playThread

VAR AufAudiowarten : Boolean;
//    BildanzeigeZeit : Integer;
    VideoBildPositionMillisek : LongInt;
    Playerdifferenz : Integer;
    aktZeit : Int64;
    Fehler : Boolean;

begin
  QueryPerformanceFrequency(Takt);
  while not Terminated do begin
    VideoabspielerMode := mpPaused; // Status, wenn Thread anhält
    restartEvent.WaitFor(INFINITE); // Wird von VideoStarten ausgelöst
    restartEvent.ResetEvent;
    VideoabspielerMode := mpPlaying;
    while not anhalten do begin
//      StartBild := VideoBildPosition;
//      StartZeit := Time;
//      QueryPerformanceFrequency(Takt);
//      QueryPerformanceCounter(Start);
//      Sartzeitsetzen;
      Fehler := False;
      Synchronize(Audiosynchronisieren);
      IF Audiovorhanden THEN
      BEGIN
        Synchronize(AudioPositionholen);
        IF Playerposition > -1 THEN
          Playerdifferenz := Round(Playerposition * Framerate / 1000) - VideoBildPosition
        ELSE
          Playerdifferenz := 0;
      END
      ELSE
      BEGIN
        Synchronize(VideoPositionholen);
        Playerdifferenz := Round(Playerposition * Framerate / 1000) - VideoBildPosition;
      END;
      IF Playerdifferenz > 0 THEN
        IF Playerdifferenz > 6 THEN
        BEGIN
          IF NOT IFramePlay(Playerdifferenz) THEN
            Fehler := True;
//          Framefehleranzeige.Font.Color := clFuchsia;
        END
        ELSE
        BEGIN
          IF NOT Bilder_weiter(Playerdifferenz) THEN
            Fehler := True;
//          Framefehleranzeige.Font.Color := clBlue;
        END
      ELSE
      BEGIN
        IF NurIFrames THEN
        BEGIN
          IF NOT IFramePlay THEN
            Fehler := True;
        END
        ELSE
          IF NOT Ein_Bild_anzeigen THEN
            Fehler := True;
//        Framefehleranzeige.Font.Color := clWindowText;
      END;
      IF NOT Fehler THEN
      BEGIN
//        BildanzeigeZeit := Round((VideoBildPosition - StartBild) * 1000 / (Framerate));
        VideoBildPositionMillisek := Round(VideoBildPosition * 1000 / Framerate);
        Synchronize(VideoBildPositionuebergeben);
        Synchronize(Audiosynchronisieren);
//        QueryPerformanceCounter(Ende);
//        IF (BildanzeigeZeit - Round((Ende - Start) * 1000 / Takt)) > 5 THEN
//          Sleep(BildanzeigeZeit - Round((Ende - Start) * 1000 / Takt) - 5);
        REPEAT                                // Video und Audio synchronisieren
//          QueryPerformanceCounter(Ende);
          IF Audiovorhanden THEN
          BEGIN
            Synchronize(AudioPositionholen);
            IF Playerposition > -1 THEN
              AufAudiowarten := VideoBildPositionMillisek <= PlayerPosition
            ELSE
              AufAudiowarten := True;
//              AufAudiowarten := BildanzeigeZeit < MilliSecondsBetween(StartZeit, Time);
//              AufAudiowarten := BildanzeigeZeit < Round((Ende - Start) * 1000 / Takt) + 1;
          END
          ELSE
          BEGIN
            QueryPerformanceCounter(aktZeit);
            AufAudiowarten := VideoBildPositionMillisek <= Round((aktZeit - StartZeit) * 1000 / Takt * Tempo1);
//            VideoPositionholen;
//            AufAudiowarten := VideoBildPositionMillisek <= PlayerPosition;
//            AufAudiowarten := BildanzeigeZeit < MilliSecondsBetween(StartZeit, Time);
           // AufAudiowarten := BildanzeigeZeit < Round((Ende - Start) * 1000 / Takt) + 1;
          END;
//          IF (BildanzeigeZeit + 5) < MilliSecondsBetween(StartZeit, Time) THEN
//          IF (BildanzeigeZeit + 4) < Round((Ende - Start) * 1000 / Takt) THEN
//            AufAudiowarten := True;           // Schleife zwangsweise verlassen
          Sleep(0);  
        UNTIL AufAudiowarten OR anhalten; 
//        Protokoll_schreiben(Inttostr(Zeitdauerlesen));
      END;
    END;
  END;
end;

// wird aus beiden Threads aufgerufen
procedure TVideoThread.VideoAnhalten;
begin
  anhalten := true;
end;

// wird aus dem HauptThread aufgerufen
procedure TVideoThread.VideoStarten;
begin
{0.7.2.1q6c - nicht starten, wenn der Thread noch läuft}
  if not anhalten then exit;
  anhalten := false;
  Synchronize(StartZeitsetzen);
  restartEvent.SetEvent;  // notify Execute
end;
{- TVideoThread Implementation Ende -------------------------------------------}

procedure VideoThreadInit;
begin
  VideoThread := TVideoThread.Create;
end;

PROCEDURE VideoPlay;
begin
  VideoThread.VideoStarten;
end;

{0.7.2.1q6c}
{PROCEDURE VideoStop;
BEGIN
  VideoThread.VideoAnhalten;
  VideoabspielerMode := mpStopped;
END;}

PROCEDURE VideoPause;
BEGIN
//  VideoabspielerMode := mpPaused;
  VideoThread.VideoAnhalten;
END;
{0.7.2.1q6b - Änderungen bis hier ---------------------------------------------}

// ------- Proceduren und Funktionen von Igor Feldhaus -------------------

{procedure aktuellesBildzuBitmap(var bmp:Tbitmap; Liste, Indexliste: TList);
var
  bild:pbytearray;
  i,j:Integer;
  r,g,b:byte;
  p:pbyte;
  bildinfo:TBildeigenschaften;
begin
  IF Assigned(bmp) THEN
    bmp.Free;
  bmp := BMPBildlesen(VideoBildPosition, True, False);

  IF Grau THEN
    bild:=Bilderneuteinlesen(VideoFormatGray8, Liste, Indexliste)
  ELSE
    bild:=Bilderneuteinlesen(VideoFormatRGB24, Liste, Indexliste);
  getMpeg2FrameInfo(bildinfo);
  p:=pointer(bild);
  with bmp do
  begin
    HandleType := bmDIB;
    Width:=bildinfo.Breite;
    Height:=bildinfo.Hoehe;
    if (Grau) THEN
    begin
      PixelFormat := pf8Bit;
      Palette:=GrauPalette();
      for i:=0 to (bildinfo.Hoehe-1) do
      begin
        for j:=0 to (bildinfo.Breite-1) do
        begin
          Canvas.Pixels[j,i]:=(p^ shl 16) or (p^ shl 8) or p^;
          inc(p);
        end;
      end;
    end
    else
    begin
      PixelFormat := pf24Bit;
      for i:=0 to (bildinfo.Hoehe-1) do
      begin
        for j:=0 to (bildinfo.Breite-1) do
        begin
          r:=p^; inc(p);
          g:=p^; inc(p);
          b:=p^; inc(p);
          Canvas.Pixels[j,bildinfo.Hoehe-i-1]:=(R shl 16) or (G shl 8) or B;
        end;
      end;
    end;
  end;
end; }

{function BildErneutEinlesen(Pixelformat: byte; Liste, Indexliste: TList):pbytearray;
VAR I : LongInt;
    Listenpunkt : THeaderklein;
    IndexListenpunkt : TBildIndex;
begin
  IF Integer(VideoBildPosition) < Indexliste.Count THEN
  BEGIN
    SetMPEG2PixelFormat(PixelFormat);
    I := VideoBildPosition;
    IndexListenpunkt := IndexListe.Items[I];
    WHILE (I > 0)  AND (IndexListenpunkt.BildTyp <> 1) DO
    BEGIN
      Dec(I);
      IndexListenpunkt := IndexListe.Items[I];
    END;
    Listenpunkt := Liste[IndexListenpunkt.BildIndex];
    mpeg2seek(Listenpunkt.Adresse);
    IF ((VideoBildPosition - I) > 0) THEN
      SkipMPEG2Frames(VideoBildPosition - I );
    result:=getMpeg2Frame;
  END
  ELSE
    result := NIL;
end;  }

// ========= Bild als PByteArray oder BMP einlesen =============

function GrauPalette():hpalette;                // Funktion von Igor Feldhaus
VAR
  MaxLogPalette  : TMaxLogPalette;
  PLogPalette : ^TLogPalette;
  gPalette    : hPalette;
  i:Integer;
begin
  with MaxLogPalette do
  begin
    palVersion:=$0300;
    palNumEntries:=256;
    for i:=0 to 255 do
      with palPalEntry[i] do
      begin
        peRed  :=i;
        peGreen:=i;
        peBlue :=i;
        peFlags:=0;
      end;
  end;
  pLogPalette:=@MaxLogPalette;
  gPalette:=CreatePalette(pLogPalette^);
  result:=gpalette;
end;

FUNCTION Positionieren(Position: LongInt; IFrame: Boolean = False): Integer;

VAR I : LongInt;
    Listenpunkt : THeaderklein;
    IndexListenpunkt : TBildIndex;

BEGIN
  IF Position = -1 THEN
    Position := VideoBildPosition;
  IF Assigned(VideoListe) AND
     Assigned(VideoIndexListe) THEN
    IF Integer(Position) < VideoIndexListe.Count THEN
      IF Assigned(VideoListe) AND Assigned(VideoIndexListe) THEN
      BEGIN
        Result := 0;
        I := Position;
        IndexListenpunkt := VideoIndexListe.Items[I];
        WHILE (I > 0)  AND (IndexListenpunkt.BildTyp <> 1) DO                     // vorheriges I-Frame suchen
        BEGIN
          Dec(I);
          IndexListenpunkt := VideoIndexListe.Items[I];
        END;
        Listenpunkt := VideoListe[IndexListenpunkt.BildIndex];
        MPEG2Seek(Listenpunkt.Adresse);
        IF (NOT IFrame) AND ((Position - I) > 0) THEN
          SkipMPEG2Frames(Position - I );
      END
      ELSE
        Result := -3
    ELSE
      Result := -2
  ELSE
    Result := -1;
END;

FUNCTION Bildlesen(Position: LongInt; IFrame: Boolean): PByteArray;
BEGIN
  IF (Position = -2) AND Assigned(Bild) THEN
    Result := Bild
  ELSE
    IF Positionieren(Position, IFrame) = 0 THEN
      Result := GetMPEG2Frame
    ELSE
      Result := NIL;
end;

FUNCTION BMPBildlesen(Position: LongInt; Weite: Integer; Positionwiederherstellen, IFrame: Boolean): TBitmap; OVERLOAD;

VAR Bild : PByteArray;
    P : PByte;
    I, J : Integer;
    R, G, B : Byte;
    Hoehe, HoeheX,
    BreiteX, BreiteY : Integer;

BEGIN
  IF NOT (VideoabspielerMode = mpPlaying) THEN
  BEGIN
    IF (Position = VideoBildPosition) OR
       (Position = -1) THEN
      Positionwiederherstellen := False;
    IF Weite = -1 THEN
      Weite := Bildbreite;
    IF Weite = -2 THEN
      Weite := Bildbreite DIV 2;  
    Bild := Bildlesen(Position, IFrame);
    IF Assigned(Bild) THEN
    BEGIN
      Result := TBitmap.Create;                // ab hier nach Ideen von Igor Feldhaus
      P:= Pointer(Bild);
      WITH Result DO
      BEGIN
        HandleType := bmDIB;
        Hoehe := Weite * BildHoehe DIV BildBreite;
        Width := Weite;
        Height := Hoehe;
        IF Grau THEN
        BEGIN
          PixelFormat := pf8Bit;
          Palette := GrauPalette();
          BreiteX := ((BildBreite DIV Weite) - 1);
          BreiteY := (BildBreite - ((BildBreite DIV Weite) * Weite));
          HoeheX := ((BildHoehe DIV Hoehe) - 1) * BildBreite;
          FOR I := 0 TO (Hoehe - 1) DO
          BEGIN
            FOR J := 0 TO (Weite - 1) DO
            BEGIN
              Canvas.Pixels[J, I] := (P^ SHL 16) OR (P^ SHL 8) OR P^;
              Inc(P);
              Inc(P, BreiteX);                                                    // Pixel überspringen
            END;
            Inc(P, BreiteY);                                                      // restliche Pixel der Zeile überspringen
            Inc(P, HoeheX);                                                       // Zeilen überspringen
          END;
        END
        else
        BEGIN
          PixelFormat := pf24Bit;
          BreiteX := ((BildBreite DIV Weite) - 1) * 3;
          BreiteY := (BildBreite - ((BildBreite DIV Weite) * Weite)) * 3;
          HoeheX := ((BildHoehe DIV Hoehe) - 1) * BildBreite * 3;
          FOR I := 0 TO ((Hoehe) - 1) DO
          BEGIN
            FOR J := 0 TO ((Weite) - 1) DO
            BEGIN
              R := P^;
              Inc(P);
              G := P^;
              Inc(P);
              B := P^;
              Inc(P);
              Canvas.Pixels[J, Hoehe - I - 1] := (R SHL 16) OR (G SHL 8) OR B;
              Inc(P, BreiteX);                                                    // Pixel überspringen
            END;
            Inc(P, BreiteY);                                                      // restliche Pixel der Zeile überspringen
            Inc(P, HoeheX);                                                       // Zeilen überspringen
          END;
        END;
      END;
    END                                        // bis hier nach Ideen von Igor Feldhaus
    ELSE
      Result := NIL;
    IF Positionwiederherstellen THEN
      Positionieren(VideoBildPosition + 1);
  END
  ELSE
    Result := NIL;
END;

FUNCTION BMPBildlesen1(Datei: STRING; Liste, IndexListe: TListe; Position: LongInt; Weite: Integer; Positionwiederherstellen, IFrame: Boolean): TBitmap; OVERLOAD;

VAR HDateiname : STRING;
    HListe,
    HIndexListe : TListe;
    Videoabspielererzeugt : Boolean;

BEGIN
  IF (Datei <> '') THEN
    IF (Datei = Dateiname) THEN
      Result := BMPBildlesen(Position, Weite, Positionwiederherstellen, IFrame)
    ELSE
    BEGIN
      HDateiname := Dateiname;
      HListe := VideoListe;
      HIndexListe := VideoIndexListe;
      IF Videoabspieler_OK THEN
        Videoabspielererzeugt := False
      ELSE
      BEGIN
        Videoabspieler_erzeugen;
        Videoabspielererzeugt := True;
      END;
      IF Videodatei_laden(Datei, Liste, IndexListe) THEN
        Result := BMPBildlesen(Position, Weite, Positionwiederherstellen, IFrame)
      ELSE
        Result := NIL;
      IF Videoabspielererzeugt THEN
        Videoabspieler_freigeben;
      Videodatei_laden(HDateiname, HListe, HIndexListe);
    END
  ELSE
    Result := NIL;
END;

{0.7.2.1q6 Initialisierung hinzugefügt um VideoThread zu erzeugen}
initialization
begin
  VideoThreadInit;
  csThreadProtect := TCriticalSection.Create;
end;
{---------}
end.

