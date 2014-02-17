{----------------------------------------------------------------------------------------------
Die VideoIndexObjUnit enthält alle Klassen und Funktionen zum lesen der Mpeg2-Indexdateien.
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

-------------------------------------------------------------------------------------- }
unit IndexObjUnit;

interface

USES
  SysUtils, Forms,
  DateiStreamUnit,
  AllgFunktionen;

TYPE
  TIndexObj = CLASS
  PRIVATE
    FFehler : Integer;
    FVersion : Integer;
    FGroesse : Int64;
    FDateigroesse : Int64;
    FEndunganhaengen : Boolean;
    FIndexendung : STRING;
    DateiStream : TDateiMapStream;
    PROCEDURE SetzeDateiname(Datei: STRING);
    FUNCTION LeseDateiname: STRING;
    FUNCTION Indexstreamerzeugen(Datei: STRING): Integer;
    FUNCTION Indexstreampruefen(Datei: STRING): Integer; VIRTUAL;
    FUNCTION IndexdateiEigenschaftenlesen : Integer;  VIRTUAL;
  PUBLIC
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
    PROPERTY Fehler : Integer READ FFehler;
    PROPERTY Version : Integer WRITE FVersion;
    PROPERTY Dateiname: STRING READ LeseDateiname WRITE SetzeDateiname;
    PROPERTY Groesse: Int64 READ FGroesse;
    PROPERTY Dateigroesse: Int64 READ FDateigroesse;
    FUNCTION Dateioeffnen(Datei: STRING): Integer;
    PROCEDURE Dateischliessen;
    FUNCTION Adresse(Position: Int64): Int64;  VIRTUAL;
    FUNCTION Teilgroesse(Anfang, Ende: Int64): Int64;  VIRTUAL;
  END;

  TVideoIndex = CLASS(TIndexObj)
  PRIVATE
    FIndexgroesse : Int64;
    FUNCTION IndexdateiEigenschaftenlesen : Integer; OVERRIDE;
  PUBLIC
    CONSTRUCTOR Create;
    FUNCTION Bildtyp(Position: Int64): Byte;
    FUNCTION BildtypChar(Position: Int64): Char;
    FUNCTION NaechstesBild(Bild: Byte; Position: Int64): Int64;
    FUNCTION VorherigesBild(Bild: Byte; Position: Int64): Int64;
    FUNCTION Bildsuchen(Bild: Byte; Position: Int64): Int64;
    FUNCTION Adresse(Position: Int64): Int64; OVERRIDE;
    FUNCTION Teilgroesse(Anfang, Ende: Int64): Int64; OVERRIDE;
    FUNCTION LangeGOPsuchen(Anfang, Ende: Int64; VAR Frame1, Frame2: Int64; maxGOPLaenge: Integer): Integer;
  END;

  TAudioIndex = CLASS(TIndexObj)
  PRIVATE
//    FAudioversatz : Int64;
    FUNCTION IndexdateiEigenschaftenlesen : Integer; OVERRIDE;
  PUBLIC
    CONSTRUCTOR Create;
    FUNCTION Adresse(Position: Int64): Int64; OVERRIDE;
    FUNCTION Teilgroesse(Anfang, Ende: Int64): Int64; OVERRIDE;
  END;

implementation

// ---------------- TIndexObj --------------------------------------------------

CONSTRUCTOR TIndexObj.Create;
BEGIN
  INHERITED Create;
  FFehler := 1;                                                                 // keine Datei geöffnet
  FVersion := 0;
  FGroesse := 0;
  FDateigroesse := 0;
  FEndunganhaengen := True;
  FIndexendung := '.idd';
  DateiStream := TDateiMapStream.Create;
END;

DESTRUCTOR TIndexObj.Destroy;
BEGIN
  DateiStream.Free;
  FFehler := 1;
  INHERITED Destroy;
END;

// öffnet, prüft und erzeugt bei Bedarf eine neue Indexdatei
//  1 und 2 siehe Indexstreampruefen
//  0 : Ok
// -1 : Datei existiert nicht
// -11 ... siehe Indexstreamerzeugen
// -21 ... siehe Indexstreampruefen
FUNCTION TIndexObj.Dateioeffnen(Datei: STRING): Integer;

VAR Indexdatei : STRING;

BEGIN
  IF FEndunganhaengen THEN
    Indexdatei := Datei + FIndexendung
  ELSE
    Indexdatei := ChangeFileExt(Datei, FIndexendung);
  IF FileExists(Datei) THEN
  BEGIN
    IF FileExists(Indexdatei) THEN
    BEGIN
      Result := Indexstreampruefen(Indexdatei);
      IF Result < 0 THEN
      BEGIN
        DeleteFile(Datei);                                                   // fehlerhafte oder falsche Indexdatei löschen
        Result := -2;
      END;
    END
    ELSE
      Result := -2;                                                          // keine Indexdatei vorhanden
    IF Result < 0 THEN
    BEGIN
      Result := Indexstreamerzeugen(Datei);                                  // Indexdatei erzeugen
      IF Result = 0 THEN
      BEGIN
        Result := Indexstreampruefen(Indexdatei);                            // neu erzeugte Indexdatei prüfen
        IF Result < 0 THEN
          Result := Result - 20;
      END
      ELSE
        Result := Result - 10;
    END;
    IF Result = 0 THEN
      Result := IndexdateiEigenschaftenlesen;
  END
  ELSE
    Result := -1;
  IF Result < 0 THEN
    FFehler := Result
  ELSE
    FFehler := 0;
END;

PROCEDURE TIndexObj.Dateischliessen;
BEGIN
  FFehler := 1;
  DateiStream.Dateischliessen;
END;

PROCEDURE TIndexObj.SetzeDateiname(Datei: STRING);
BEGIN
  Dateioeffnen(Datei);
END;

FUNCTION TIndexObj.LeseDateiname: STRING;
BEGIN
  Result := DateiStream.Dateiname;
END;

FUNCTION TIndexObj.Indexstreamerzeugen(Datei: STRING): Integer;
BEGIN
  IF Unterprogramm_starten(ExtractFilePath(Application.ExeName) + 'IndexToolCL.exe "' + Datei + '"', True) THEN
    Result := 0
  ELSE
    Result := -1;
END;

// prüft die Indexdatei
//  0 : Ok
// -1 .. -6 : siehe TDateiMapStream.Dateioeffnen
// -6 .. -7 : siehe TDateiMapStream.LesePuffer
// -8 : Indexdatei zu kurz
// -9 : falsche Indexdatei
FUNCTION TIndexObj.Indexstreampruefen(Datei: STRING): Integer;

VAR Puffer : ARRAY[0..3] OF Byte;

BEGIN
  Result := DateiStream.Dateioeffnen(Datei);
  IF Result = 0 THEN
  BEGIN
    Result := DateiStream.LesePuffer(0, Puffer, 4);
    IF Result = 4 THEN
      IF (Puffer[0] = Ord('i')) AND
         (Puffer[1] = Ord('d')) AND
         (Puffer[2] = Ord('d')) AND
         (Puffer[3] = FVersion) THEN
        Result := 0
      ELSE
        Result := -9
    ELSE
      IF Result < 0 THEN
        Result := Result - 5
      ELSE
        Result := -8;
    IF Result < 0 THEN
      DateiStream.Dateischliessen;
  END;
  FFehler := Result;
END;

// liest die Eigenschaften der Datei aus der Indexdatei aus
// Fehler siehe DateiStream.LesePuffer
FUNCTION TIndexObj.IndexdateiEigenschaftenlesen : Integer;
BEGIN
  Result := -1;
END;

// gibt die Adresse in der Datei zurück
// > -1 : Ok
//   -1 : Position ausserhalb des Audiobereiches
// - 2 ... siehe TDateiMapStream.LesePuffer - 1
FUNCTION TIndexObj.Adresse(Position: Int64): Int64;
BEGIN
  Result := -1;
  FFehler := -1;
END;

// gibt die Grösse des Dateiteils zurück
// > -1 : Ok
//   -1 : Anfang ausserhalb des Dateibereiches
//   -2 : Ende kleiner Null
//   -3 : Anfang ist größer als Ende
FUNCTION TIndexObj.Teilgroesse(Anfang, Ende: Int64): Int64;
BEGIN
  IF (Anfang > -1) AND (Anfang < FGroesse) THEN
    IF Ende > -1 THEN
      IF Anfang < Ende +  1 THEN
      BEGIN
        Result := 0;
      END
      ELSE
        Result := -3                                                            // Anfang ist größer als Ende
    ELSE
      Result := -2                                                              // Ende kleiner Null
  ELSE
    Result := -1;                                                               // Anfang ausserhalb des Audiobereiches
END;

// ---------------- TVideoIndex ------------------------------------------------

CONSTRUCTOR TVideoIndex.Create;
BEGIN
  INHERITED Create;
  FIndexgroesse := 0;
  FVersion := 3;
//  FEndunganhaengen := False;
//  FIndexendung := '.idd-neu';
END;

// liest die Eigenschaften der Videodatei aus der Indexdatei aus
// Fehler siehe DateiStream.LesePuffer
FUNCTION TVideoIndex.IndexdateiEigenschaftenlesen : Integer;
BEGIN
  Result := DateiStream.LesePuffer(4, FIndexgroesse, 8);
  IF Result > -1 THEN
  BEGIN
    FGroesse := (FIndexgroesse - 12) DIV 8;
    Result := DateiStream.LesePuffer(DateiStream.Dateigroesse - 8, FDateigroesse, 8);
    IF Result > -1 THEN
      IF FDateigroesse AND $FF00000000000000 = $B700000000000000 THEN
        FDateigroesse := FDateigroesse AND $FFFFFFFFFFFFFF + 4                  // Datei mit Sequenzendeheader
      ELSE
        FDateigroesse := FDateigroesse AND $FFFFFFFFFFFFFF
    ELSE
      FDateigroesse := -1;
  END;
  IF Result < 0 THEN
    FFehler := Result
  ELSE
    Result := 0;
END;

// gibt den Bildtype zurück
// $FF : Fehler
// -1 : Position ausserhalb des Videobereiches
// - 2 ... siehe TDateiMapStream.LeseByte - 1
FUNCTION TVideoIndex.Bildtyp(Position: Int64): Byte;
BEGIN
  Result := $FF;
  IF (Position > -1) AND (Position < FGroesse) THEN
  BEGIN
    Result := DateiStream.LeseByte(Position * 8 + 7 + 12);
    FFehler := DateiStream.Fehler;
    IF FFehler < 0 THEN
      FFehler := FFehler - 1;
  END
  ELSE
    FFehler := -1;
END;

// gibt den Bildtype als Zeichen zurück
// "?" : unbekannt
FUNCTION TVideoIndex.BildtypChar(Position: Int64): Char;
BEGIN
  CASE Bildtyp(Position) OF
    1 : Result := 'I';
    2 : Result := 'P';
    3 : Result := 'B';
  ELSE
    Result := '?';
  END;
END;

// gibt die Position des nächsten Bildes vom Type "Bild" zurück
// > -1 : Ok
//   -1 : Position ausserhalb des Videobereiches
//   -2 : Bildtype nicht gefunden
// - 3 ... siehe Bildtyp - 2
FUNCTION TVideoIndex.NaechstesBild(Bild: Byte; Position: Int64): Int64;

VAR Bildtype : Byte;

BEGIN
  FFehler := 0;
  IF (Position > -1) AND (Position < FGroesse) THEN
  BEGIN
//    Inc(Position);                                                            // nächstes Bild suchen
    Bildtype := Bildtyp(Position);
    WHILE (FFehler = 0) AND (Position < FGroesse) AND (Bildtype > Bild) DO
    BEGIN
      Inc(Position);
      Bildtype := Bildtyp(Position);
    END;
    IF FFehler < 0 THEN
      Result := FFehler - 2
    ELSE
      IF Bildtype > Bild THEN
        Result := -2                                                            // Bildtype nicht gefunden
      ELSE
        Result := Position;
  END
  ELSE
    Result := -1;                                                               // Position ausserhalb des Videobereiches
  IF Result < 0 THEN
    FFehler := Result;
END;

// gibt die Position des vorherigen Bildes vom Type "Bild" zurück
// > -1 : Ok
//   -1 : Position ausserhalb des Videobereiches
//   -2 : Bildtype nicht gefunden
// - 3 ... siehe Bildtyp - 2
FUNCTION TVideoIndex.VorherigesBild(Bild: Byte; Position: Int64): Int64;

VAR Bildtype : Byte;

BEGIN
  FFehler := 0;
  IF (Position > -1) AND (Position < FGroesse) THEN
  BEGIN
//    Dec(Position);                                                            // vorheriges Bild suchen
    Bildtype := Bildtyp(Position);
    WHILE (FFehler = 0) AND (Position > -1) AND (Bildtype > Bild) DO
    BEGIN
      Dec(Position);
      Bildtype := Bildtyp(Position);
    END;
    IF FFehler < 0 THEN
      Result := FFehler - 2
    ELSE
      IF Bildtype > Bild THEN
        Result := -2                                                            // Bildtype nicht gefunden
      ELSE
        Result := Position;
  END
  ELSE
    Result := -1;                                                               // Position ausserhalb des Videobereiches
  IF Result < 0 THEN
    FFehler := Result;
END;

// gibt die Position des nächstgelegnen Bildes vom Type "Bild" zurück
// > -1 : Ok
//   -1 : Position ausserhalb des Videobereiches
//   -2 : Bildtype nicht gefunden
// - 3 ... siehe Bildtyp - 2
FUNCTION TVideoIndex.Bildsuchen(Bild: Byte; Position: Int64): Int64;

VAR BildVor,
    BildRueck : Int64;

BEGIN
  IF (Position > -1) AND (Position < FGroesse) THEN
  BEGIN
    BildVor := NaechstesBild(Bild, Position);
    BildRueck := VorherigesBild(Bild, Position);
    IF FFehler > -3 THEN
    BEGIN
      FFehler := 0;
      IF BildVor < 0 THEN
        IF BildRueck < 0 THEN
        BEGIN
          Result := -2;
          FFehler := -2;
        END
        ELSE
          Result := BildRueck
      ELSE
        IF BildRueck < 0 THEN
          Result := BildVor
        ELSE
          IF Position - BildRueck < BildVor - Position THEN
            Result := BildRueck
          ELSE
            Result := BildVor;
    END
    ELSE
      Result := FFehler;
  END
  ELSE
  BEGIN
    Result := -1;
    FFehler := -1;
  END;
END;

// gibt die Adresse des Bildes in der Videodatei zurück
// > -1 : Ok
//   -1 : Position ausserhalb des Videobereiches
// - 2 ... siehe TDateiMapStream.LesePuffer - 1
FUNCTION TVideoIndex.Adresse(Position: Int64): Int64;
BEGIN
  IF (Position > -1) AND (Position < FGroesse) THEN
  BEGIN
    DateiStream.LesePuffer(Position * 8 + 12, Result, 8);
    FFehler := DateiStream.Fehler;
    IF FFehler < 0 THEN
    BEGIN
      FFehler := FFehler - 1;
      Result := FFehler;
    END
    ELSE
      Result := Result AND $FFFFFFFFFFFFFF;
  END
  ELSE
  BEGIN
    Result := -1;
    FFehler := -1;
  END;
END;

// gibt die Grösse des Videoteils zurück
// > -1 : Ok
//   -1 : Anfang ausserhalb des Videobereiches
//   -2 : Ende kleiner Null
//   -3 : Anfang ist größer als Ende
FUNCTION TVideoIndex.Teilgroesse(Anfang, Ende: Int64): Int64;

VAR I, J : Integer;
    HAnfang, HEnde : Int64;

BEGIN
  Result := INHERITED Teilgroesse(Anfang, Ende);
  IF Result > -1 THEN
  BEGIN
    IF Ende > FGroesse - 1 THEN
      Ende := FGroesse - 1;
    HAnfang := NaechstesBild(1, Anfang);                                        // nächstes I-Frame suchen
    HEnde := VorherigesBild(2, Ende);                                           // vorheriges P- oder I-Frame suchen
    Result := 0;
    IF (HAnfang > -1) AND (HEnde > -1) AND (HAnfang < HEnde +  1) THEN
    BEGIN
      I := 1;
      WHILE (HAnfang - I > -1) AND (Bildtyp(HAnfang - I) > 2) DO                // B-Frames rückwärts überspringen
        Inc(I);
      Dec(I);
      IF I > 0 THEN
      BEGIN                                                                     // B-Frames vorhanden
        Result := Adresse(HAnfang - I) - Adresse(HAnfang);                      // Größe des I-Frames
        I := 1;
        WHILE (HAnfang + I < FGroesse) AND (Bildtyp(HAnfang + I) > 2) DO        // B-Frames vorwärts überspringen
          Inc(I);
      END;
      J := 1;
      WHILE (HEnde + J < FGroesse) AND (Bildtyp(HEnde + J) > 2) DO              // B-Frames vorwärts überspringen
        Inc(J);
      IF HEnde + J > FGroesse - 1 THEN
        Result := Result + FDateigroesse - Adresse(HAnfang + I)                 // Ende = letztes Bild
      ELSE
        Result := Result + Adresse(HEnde + J) - Adresse(HAnfang + I);
      Result := Round((Ende - Anfang) * Result / (HEnde - HAnfang));            // Größe für neu zu berechnednen Teil dazurechnen
    END;
  END;
END;


//
FUNCTION TVideoIndex.LangeGOPsuchen(Anfang, Ende: Int64; VAR Frame1, Frame2: Int64; maxGOPLaenge: Integer): Integer;

VAR GOPAnfang, IFrame, GOPEnde : Int64;

BEGIN
  Result := 0;
  IFrame := Anfang;
  GOPEnde := VorherigesBild(2, Anfang - 1);                                     // vorheriges I- oder P-Frame suchen
  IF GOPEnde < 0 THEN
    GOPEnde := -1;                                                              // Filmanfang
  REPEAT
    GOPAnfang := GOPEnde + 1;
    IFrame := NaechstesBild(1, IFrame + 1);                                     // nächstes I-Frame suchen
    IF IFrame < 0 THEN
      IFrame := FGroesse;                                                       // Filmende
    GOPEnde := VorherigesBild(2, IFrame - 1);                                   // vorheriges I- oder P-Frame suchen
    IF GOPEnde > Ende THEN
      GOPEnde := Ende;
  UNTIL (GOPEnde = Ende) OR (GOPEnde - GOPAnfang + 1 > maxGOPLaenge);
  IF GOPEnde - GOPAnfang + 1 > maxGOPLaenge THEN
  BEGIN
    Frame1 := VorherigesBild(2, GOPAnfang + maxGOPLaenge);
    Frame2 := IFrame - 1;
  END
  ELSE
  BEGIN
    Frame1 := Ende;
    Frame2 := Ende;
  END;
END;
// ---------------- TAudioIndex ------------------------------------------------

CONSTRUCTOR TAudioIndex.Create;
BEGIN
  INHERITED Create;
//  FAudioversatz := 0;
  FVersion := 3;
END;

// liest die Eigenschaften der Audiodatei aus der Indexdatei aus
// Fehler siehe DateiStream.LesePuffer
FUNCTION TAudioIndex.IndexdateiEigenschaftenlesen : Integer;
BEGIN
  FGroesse := ((DateiStream.Dateigroesse - 4) DIV 8) - 1;
  Result := DateiStream.LesePuffer(DateiStream.Dateigroesse - 8, FDateigroesse, 8);
  IF Result < 0 THEN
  BEGIN
    FDateigroesse := -1;
    FFehler := Result;
  END
  ELSE
    Result := 0;
END;

// gibt die Adresse des Bildes in der Audiodatei zurück
// > -1 : Ok
//   -1 : Position ausserhalb des Audiobereiches
// - 2 ... siehe TDateiMapStream.LesePuffer - 1
FUNCTION TAudioIndex.Adresse(Position: Int64): Int64;
BEGIN
  IF (Position > -1) AND (Position < FGroesse) THEN
  BEGIN
    DateiStream.LesePuffer(Position * 8 + 4, Result, 8);
    FFehler := DateiStream.Fehler;
    IF FFehler < 0 THEN
    BEGIN
      FFehler := FFehler - 1;
      Result := FFehler;
    END  
    ELSE
      Result := Result AND $FFFFFFFFFFFFFF;
  END
  ELSE
  BEGIN
    Result := -1;
    FFehler := -1;
  END;
END;

// gibt die Grösse des Audioteils zurück
// > -1 : Ok
//   -1 : Anfang ausserhalb des Audiobereiches
//   -2 : Ende kleiner Null
//   -3 : Anfang ist größer als Ende
FUNCTION TAudioIndex.Teilgroesse(Anfang, Ende: Int64): Int64;
BEGIN
  Result := INHERITED Teilgroesse(Anfang, Ende);
  IF Result > -1 THEN
  BEGIN
    IF Ende > FGroesse - 1 THEN
      Ende := FGroesse - 1;
    Result := Adresse(Ende + 1) - Adresse(Anfang);
  END;
END;

end.

