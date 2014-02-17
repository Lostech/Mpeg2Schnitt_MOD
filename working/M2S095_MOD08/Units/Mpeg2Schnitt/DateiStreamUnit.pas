{----------------------------------------------------------------------------------------------
Mpeg2Unit enthält alle Klassen und Funktionen zum lesen und bearbeiten von Mpeg2 Dateien.
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
unit DateiStreamUnit;

interface

USES
  Windows, SysUtils, Classes;

TYPE
  TDateiStream = CLASS
  PRIVATE
    FDateiHandle : Integer;
    FDateiGroesse : Int64;
    FDateiname : STRING;
    FMode : LongWord;
    FFehler : Integer;
    Frueckwaerts : Boolean;
    PROCEDURE SetDateiname(Datei: STRING);
    FUNCTION LesePosition: Int64; VIRTUAL;
    PROCEDURE SetzePosition(Position: Int64); VIRTUAL;
    PROPERTY Mode: LongWord READ FMode WRITE FMode;
//    PROPERTY DateiHandle: Integer READ FDateiHandle;
  PUBLIC
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
    PROPERTY Dateiname: STRING READ FDateiname WRITE SetDateiname;
    PROPERTY Dateigroesse: Int64 READ FDateiGroesse;
    PROPERTY Fehler: Integer READ FFehler;
    PROPERTY rueckwaerts: Boolean READ Frueckwaerts WRITE Frueckwaerts;
    PROPERTY Position: Int64 READ LesePosition WRITE SetzePosition;
    FUNCTION Dateioeffnen(Datei: STRING; Mode: LongWord = fmOpenRead): Integer; DYNAMIC;
    PROCEDURE Dateischliessen; DYNAMIC;
    FUNCTION Schieben(Anzahl: Int64): Integer; VIRTUAL;
    FUNCTION LeseByte(Position: Int64): Byte; OVERLOAD;  DYNAMIC;
    FUNCTION LesePuffer(Position: Int64; VAR Puffer; Laenge: Int64): Integer; OVERLOAD;  DYNAMIC;
    FUNCTION LeseByte: Byte; OVERLOAD; VIRTUAL;
    FUNCTION LesePuffer(VAR Puffer; Laenge: Int64): Integer; OVERLOAD;  VIRTUAL;
    FUNCTION SchreibePuffer(CONST Puffer; Laenge: Integer): Integer;  VIRTUAL;
  END;

  TDateiFileStream = CLASS(TDateiStream)
  PRIVATE
    FUNCTION LesePosition: Int64; OVERRIDE;
    PROCEDURE SetzePosition(Position: Int64); OVERRIDE;
  PUBLIC
    PROPERTY Mode;
    FUNCTION Schieben(Anzahl: Int64): Integer; OVERRIDE;
    FUNCTION LeseByte: Byte; OVERLOAD; OVERRIDE;
    FUNCTION LesePuffer(VAR Puffer; Laenge: Int64): Integer; OVERLOAD; OVERRIDE;
    FUNCTION SchreibePuffer(CONST Puffer; Laenge: Integer): Integer; OVERRIDE;
  END;

  TDateiMapStream = CLASS(TDateiStream)
  PRIVATE
    DateiMapHandle : THandle;
    FDatenZeiger : Pointer;
    FPosition : Int64;
    FUNCTION LesePosition: Int64; OVERRIDE;
    PROCEDURE SetzePosition(Position: Int64); OVERRIDE;
//    PROPERTY Datenzeiger: Pointer READ FDatenZeiger;
  PUBLIC
    CONSTRUCTOR Create;
    FUNCTION Dateioeffnen(Datei: STRING; Mode: LongWord = fmOpenRead): Integer; OVERRIDE;
    PROCEDURE Dateischliessen; OVERRIDE;
    FUNCTION Schieben(Anzahl: Int64): Integer; OVERRIDE;
    FUNCTION LeseByte: Byte; OVERLOAD; OVERRIDE;
    FUNCTION LesePuffer(VAR Puffer; Laenge: Int64): Integer; OVERLOAD; OVERRIDE;
  END;

  TDateiPufferStream = CLASS(TDateiStream)
  PRIVATE
    FDatenZeiger : Pointer;
    FPosition : Int64;
    FPufferGroesse : Integer;
    PufferMin,
    PufferMax : Int64;
    FUNCTION LesePosition: Int64; OVERRIDE;
    PROCEDURE SetzePosition(Position: Int64); OVERRIDE;
    PROCEDURE SetzePufferGroesse(Groesse: Integer);
    FUNCTION Pufferfuellen: Integer;
//    PROPERTY Datenzeiger: Pointer READ FDatenZeiger;
  PUBLIC
    CONSTRUCTOR Create;
    PROCEDURE Dateischliessen; OVERRIDE;
    PROPERTY PufferGroesse : Integer READ FPufferGroesse WRITE SetzePufferGroesse;
    FUNCTION Schieben(Anzahl: Int64): Integer; OVERRIDE;
    FUNCTION LeseByte: Byte; OVERLOAD; OVERRIDE;
    FUNCTION LesePuffer(VAR Puffer; Laenge: Int64): Integer; OVERLOAD; OVERRIDE;
  END;

implementation

// --- TDateiStream ---

// interne Routinen

// Variablen initialisieren
// 1 : keine Datei geöffnet
CONSTRUCTOR TDateiStream.Create;
BEGIN
  INHERITED Create;
  FDateiHandle := -1;
  FDateiGroesse := 0;
  FDateiname := '';
  FMode := fmOpenRead;
  Frueckwaerts := False;
  FFehler := 1;
END;

DESTRUCTOR TDateiStream.Destroy;
BEGIN
  Dateischliessen;
  INHERITED Destroy;
END;

// siehe Dateioeffnen
PROCEDURE TDateiStream.SetDateiname(Datei: STRING);
BEGIN
  Dateioeffnen(Datei, FMode);
END;

// liest die aktuelle Dateiposition
// > 0 : Position
//  -1 : Fehler beim lesen
//  -2 : keine Datei geöffnet
FUNCTION TDateiStream.LesePosition: Int64;
BEGIN
  Result := 0;
  FFehler := -1;
END;

// setzt die Dateiposition
//   0 : Ok
//  -1 : Fehler beim setzten
//  -2 : keine Datei geöffnet
PROCEDURE TDateiStream.SetzePosition(Position: Int64);
BEGIN
  FFehler := -1;
END;

// öffnet eine Datei zum lesen oder schreiben
//  2 : Datei entspricht der geöffneten Datei
//  1 : keine Datei übergeben
//  0 : Ok
// -1 : Datei existiert nicht
// -2 : Fehler beim öffnen der Datei (Win - API)
// -3 : Dateigröße ist Null
FUNCTION TDateiStream.Dateioeffnen(Datei: STRING; Mode: LongWord = fmOpenRead): Integer;
BEGIN
  Result := 0;
  IF FDateiname <> Datei THEN
  BEGIN
    Dateischliessen;
    IF (Datei <> '') THEN
      IF (NOT (Mode = fmOpenRead)) OR FileExists(Datei) THEN
      BEGIN
        FDateiname := Datei;
        FMode := Mode;
        IF Mode = fmCreate THEN
          FDateiHandle := FileCreate(Datei)
        ELSE
          FDateiHandle := FileOpen(Datei, Mode);
        IF FDateiHandle > -1 THEN
        BEGIN
          FDateiGroesse := FileSeek(FDateiHandle, Int64(0), 2);
          FileSeek(FDateiHandle, Int64(0), 0);
          IF FDateiGroesse < 1 THEN
          BEGIN
            IF Mode = fmOpenRead THEN
              Dateischliessen;
            Result := -3;                         // Dateigröße ist Null
          END;
        END
        ELSE
        BEGIN
          Dateischliessen;
          Result := -2;                           // Datei öffnen ist fehlgeschlagen
        END;
      END
      ELSE
        Result := -1                              // Datei existiert nicht
    ELSE
      Result := 1;                                // keine Datei übergeben, geöffnete Datei wurde geschlossen
  END
  ELSE
    Result := 2;
  FFehler := Result;
END;

// schließt die Datei und setzt Variablen zurück
// 1 : keine Datei geöffnet
PROCEDURE TDateiStream.Dateischliessen;
BEGIN
  IF FDateiHandle <> 0 THEN
  BEGIN
    FileClose(FDateiHandle);
    FDateiHandle := 0;
  END;
  FDateiGroesse := 0;
  FDateiname := '';
  FMode := fmOpenRead;
  FFehler := 1;
END;

// verschiebt die Position um Anzahl Bytes
//   0 : Ok
//  -1 : Fehler (Datei am Ende oder Anfang)
//  -2 : keine Datei geöffnet
FUNCTION TDateiStream.Schieben(Anzahl: Int64): Integer;
BEGIN
  Result := -1;
  FFehler := -1;
END;

// liest ein Byte aus der Datei
// Rückgabewert ist das gelesene Byte
// $FF : Fehler beim lesen
//   0 : Ok
//  -1 : keine Datei geöffnet
//  -2 : Datei nicht zum lesen geöffnet
//  -3 : Fehler beim lesen (Datei zu klein)
FUNCTION TDateiStream.LeseByte(Position: Int64): Byte;
BEGIN
  SetzePosition(Position);
  Result := LeseByte;
END;

FUNCTION TDateiStream.LeseByte: Byte;
BEGIN
  Result := 0;
  FFehler := -1;
END;

// liest Daten aus der Datei in den Puffer, Laenge ist die Anzahl der Daten die gelesen werden sollen in Byte
// > 0 : Anzahl der tatsächlich gelesenen Bytes
//  -1 : keine Datei geöffnet
//  -2 : Datei nicht zum lesen geöffnet
//  -3 : Fehler beim lesen (Datei zu klein)
FUNCTION TDateiStream.LesePuffer(Position: Int64; VAR Puffer; Laenge: Int64): Integer;
BEGIN
  SetzePosition(Position);
  Result := LesePuffer(Puffer, Laenge);
END;

FUNCTION TDateiStream.LesePuffer(VAR Puffer; Laenge: Int64): Integer;
BEGIN
  Result := -1;
  FFehler := -1;
END;

// schreibt die Daten aus Puffer in die Datei, Laenge ist die Anzahl der Daten in Byte
// > 0 : Anzahl der tatsächlich geschriebenen Bytes
//  -1 : keine Datei geöffnet
//  -2 : Datei nicht zum schreiben geöffnet
//  -3 : Fehler beim schreiben (zu wenig Daten geschrieben)
FUNCTION TDateiStream.SchreibePuffer(CONST Puffer; Laenge: Integer): Integer;
BEGIN
  Result := -1;
  FFehler := -1;
END;

// --- TDateiFileStream ---

// liest die aktuelle Dateiposition
// > 0 : Position
//  -1 : Fehler beim lesen
//  -2 : keine Datei geöffnet
FUNCTION TDateiFileStream.LesePosition: Int64;
BEGIN
  IF FDateiHandle > -1 THEN
    Result := FileSeek(FDateiHandle, Int64(0), 1)
  ELSE
    Result := -2;
  IF Result < 0 THEN
    FFehler := Result
  ELSE
    FFehler := 0;
END;

// setzt die Dateiposition
//   0 : Ok
//  -1 : Fehler beim setzten
//  -2 : keine Datei geöffnet
PROCEDURE TDateiFileStream.SetzePosition(Position: Int64);
BEGIN
  IF FDateiHandle > -1 THEN
    IF FileSeek(FDateiHandle, Position, 0) < 0 THEN
      FFehler := -1
    ELSE
      FFehler := 0
  ELSE
    FFehler := -2;
END;

// verschiebt die Position um Anzahl Bytes
//   0 : Ok
//  -1 : Fehler (Datei am Ende oder Anfang)
//  -2 : keine Datei geöffnet
FUNCTION TDateiFileStream.Schieben(Anzahl: Int64): Integer;
BEGIN
  IF FDateiHandle > -1 THEN
    IF FileSeek(FDateiHandle, Anzahl, 1) < 0 THEN
      Result := -1
    ELSE
      Result := 0
  ELSE
    Result := -2;
  IF Result < 0 THEN
    FFehler := Result;
END;

// liest ein Byte aus der Datei
// Rückgabewert ist das gelesene Byte
// $FF : Fehler beim lesen
//   0 : Ok
//  -1 : keine Datei geöffnet
//  -2 : Datei nicht zum lesen geöffnet
//  -3 : Fehler beim lesen (Datei zu klein)
FUNCTION TDateiFileStream.LeseByte: Byte;

VAR Erg : Int64;

BEGIN
  FFehler := 0;
  Result := $FF;
  IF FDateiHandle > -1 THEN
    IF FMode = fmOpenRead THEN
    BEGIN
      Erg := 0;
      IF Frueckwaerts THEN
        Erg := FileSeek(FDateiHandle, Int64(-1), 1);
      IF Erg > -1 THEN
        FFehler := FileRead(FDateiHandle, Result, 1);
      IF FFehler < 1 THEN
      BEGIN
        FFehler := -3;
        Result := $FF;                 // Ergebnis ist ungültig
      END
      ELSE
        IF Frueckwaerts THEN
          FileSeek(FDateiHandle, Int64(-1), 1);
    END
    ELSE
      FFehler := -2
  ELSE
    FFehler := -1;
  IF FFehler = 1 THEN
    FFehler := 0;                      // 1 ist kein Fehler
END;

// liest Daten aus der Datei in den Puffer, Laenge ist die Anzahl der Daten die gelesen werden sollen in Byte
// > 0 : Anzahl der tatsächlich gelesenen Bytes
//  -1 : keine Datei geöffnet
//  -2 : Datei nicht zum lesen geöffnet
//  -3 : Fehler beim lesen (Datei zu klein)
FUNCTION TDateiFileStream.LesePuffer(VAR Puffer; Laenge: Int64): Integer;

VAR Erg : Int64;

BEGIN
  FFehler := 0;
  IF FDateiHandle > -1 THEN
    IF FMode = fmOpenRead THEN
    BEGIN
      Erg := 0;
      IF Frueckwaerts THEN
        Erg := FileSeek(FDateiHandle, -Laenge, 1);
      IF Erg > -1 THEN
        Result := FileRead(FDateiHandle, Puffer, Laenge)
      ELSE
        Result := 0;
      IF Result < Laenge THEN
      BEGIN
        IF Result < 0 THEN
          Result := -3;
      END
      ELSE
        IF Frueckwaerts THEN
          FileSeek(FDateiHandle, -Laenge, 1);
    END
    ELSE
      Result := -2
  ELSE
    Result := -1;
  IF Result < 0 THEN
    FFehler := Result;
END;

// schreibt die Daten aus Puffer in die Datei, Laenge ist die Anzahl der Daten in Byte
// > 0 : Anzahl der tatsächlich geschriebenen Bytes
//  -1 : keine Datei geöffnet
//  -2 : Datei nicht zum schreiben geöffnet
//  -3 : Fehler beim schreiben (zu wenig Daten geschrieben)
FUNCTION TDateiFileStream.SchreibePuffer(CONST Puffer; Laenge: Integer): Integer;
BEGIN
  FFehler := 0;
  IF FDateiHandle > -1 THEN
    IF (FMode = fmOpenWrite) OR (FMode = fmCreate) THEN
    BEGIN
      Result := FileWrite(FDateiHandle, Puffer, Laenge);
      IF Result < Laenge THEN
        IF Result < 0 THEN
          Result := -3;
    END
    ELSE
      Result := -2
  ELSE
    Result := -1;
  IF Result < 0 THEN
    FFehler := Result;
END;

// --- TDateiMapStream ---

// Variablen initialisieren
CONSTRUCTOR TDateiMapStream.Create;
BEGIN
  INHERITED Create;
  FDatenZeiger := NIL;
  DateiMapHandle := 0;
  FPosition := 0;
END;

// öffnet eine Datei zum lesen und mappt sie in den Speicher
// > -4 : siehe Rückmeldungen TDateiStream.Dateioeffnen
//   -4 : das Mappen ist fehlgeschlagen
//   -5 : es wurde kein Datenzeiger zurückgegeben
FUNCTION TDateiMapStream.Dateioeffnen(Datei: STRING; Mode: LongWord = fmOpenRead): Integer;
BEGIN
  Result := INHERITED Dateioeffnen(Datei, fmOpenRead);
  IF Result = 0 THEN
  BEGIN
    DateiMapHandle := CreateFileMapping(FDateiHandle, NIL, PAGE_READONLY, 0, 0, NIL);
    IF DateiMapHandle <> INVALID_HANDLE_VALUE THEN
    BEGIN
      FDatenZeiger := MapViewOfFile(DateiMapHandle, FILE_MAP_READ, 0, 0, 0);
      IF Assigned(FDatenZeiger) THEN
      ELSE
      BEGIN
        Dateischliessen;
        Result := -5;                     // kein Datenzeiger zurückgegeben
      END;
    END
    ELSE
    BEGIN
      Dateischliessen;
      Result := -4;                       // Mappen fehlgeschlagen
    END;
  END;
  FFehler := Result;
END;

// schließt die Datei und gibt den Speicher frei
PROCEDURE TDateiMapStream.Dateischliessen;
BEGIN
  IF Assigned(FDatenZeiger) THEN
  BEGIN
    UnmapViewOfFile(FDatenZeiger);
    FDatenZeiger := NIL;
  END;
  IF DateiMapHandle <> 0 THEN
  BEGIN
    CloseHandle(DateiMapHandle);
    DateiMapHandle := 0;
  END;
  INHERITED Dateischliessen;
END;

// liest die aktuelle Speicherposition
// > 0 : Position
//  -1 : Fehler beim lesen
//  -2 : keine Datei geöffnet
FUNCTION TDateiMapStream.LesePosition: Int64;
BEGIN
  IF Assigned(FDatenZeiger) THEN
    Result := FPosition
  ELSE
    Result := -2;
  IF Result < 0 THEN
    FFehler := Result
  ELSE
    FFehler := 0;
END;

// setzt die Speicherposition
//   0 : Ok
//  -1 : Fehler beim setzten
//  -2 : keine Datei geöffnet
PROCEDURE TDateiMapStream.SetzePosition(Position: Int64);
BEGIN
  IF Assigned(FDatenZeiger) THEN
  BEGIN
    IF (Position < 0) OR
       (Position > FDateiGroesse) THEN
      FFehler := -1
    ELSE
    BEGIN
      FPosition := Position;
      FFehler := 0;
    END;
  END
  ELSE
    FFehler := -2;
END;

// verschiebt die Position um Anzahl Bytes
//   0 : Ok
//  -1 : Fehler (Datei am Ende oder Anfang)
//  -2 : keine Datei geöffnet
FUNCTION TDateiMapStream.Schieben(Anzahl: Int64): Integer;
BEGIN
  IF Assigned(FDatenZeiger) THEN
  BEGIN
    IF (Anzahl + FPosition < 0) OR
       (Anzahl + FPosition > FDateiGroesse) THEN
      Result := -1
    ELSE
    BEGIN
      FPosition := FPosition + Anzahl;
      Result := 0;
    END;
  END
  ELSE
    Result := -2;
  FFehler := Result
END;

// liest ein Byte aus dem Speicher
// Rückgabewert ist das gelesene Byte
// $FF : Fehler beim lesen
//   0 : Ok
//  -1 : keine Datei geöffnet
//  -2 : Datei nicht zum lesen geöffnet
//  -3 : die Datei ist zu klein
FUNCTION TDateiMapStream.LeseByte: Byte;
BEGIN
  FFehler := 0;
  Result := $FF;
  IF Assigned(FDatenZeiger) THEN
    IF FMode = fmOpenRead THEN
      IF ((NOT Frueckwaerts) AND (FPosition < FDateiGroesse)) OR
         (Frueckwaerts AND (FPosition > 0)) THEN
      BEGIN
        IF Frueckwaerts THEN
          Dec(FPosition);
        Result := PByteArray(FDatenZeiger)[FPosition];
        IF NOT Frueckwaerts THEN
          Inc(FPosition);
      END
      ELSE
        FFehler := -3
    ELSE
      FFehler := -2
  ELSE
    FFehler := -1;
END;

// liest Daten aus dem Speicher in den Puffer, Laenge ist die Anzahl der Daten die gelesen werden sollen in Byte
// > 0 : Anzahl der tatsächlich gelesenen Bytes
//  -1 : keine Datei geöffnet
//  -2 : Datei nicht zum lesen geöffnet
//  -3 : die Datei ist zu klein
FUNCTION TDateiMapStream.LesePuffer(VAR Puffer; Laenge: Int64): Integer;
BEGIN
  Result := 0;
  FFehler := 0;
  IF Assigned(FDatenZeiger) THEN
    IF FMode = fmOpenRead THEN
    BEGIN
      WHILE (Result < Laenge) AND
            (Frueckwaerts OR (FPosition < FDateiGroesse)) AND
            ((NOT Frueckwaerts) OR (FPosition > 0)) DO
      BEGIN
        IF Frueckwaerts THEN
        BEGIN
          Dec(FPosition);
          TByteArray(Puffer)[Laenge - Result - 1] := PByteArray(FDatenZeiger)[FPosition];
        END
        ELSE
        BEGIN
          TByteArray(Puffer)[Result] := PByteArray(FDatenZeiger)[FPosition];
          Inc(FPosition);
        END;
        Inc(Result);
      END;
      IF Result < Laenge THEN
        FFehler := -3;
    END
    ELSE
      Result := -2
  ELSE
    Result := -1;
  IF Result < 0 THEN
    FFehler := Result;
END;

// --- TDateiPufferStream ---

// liest die aktuelle Speicherposition
// > 0 : Position
//  -1 : Fehler beim lesen
//  -2 : keine Datei geöffnet
FUNCTION TDateiPufferStream.LesePosition: Int64;
BEGIN
  IF FDateiHandle > -1 THEN
    Result := FPosition
  ELSE
    Result := -2;
  IF Result < 0 THEN
    FFehler := Result
  ELSE
    FFehler := 0;
END;

// setzt die Speicherposition
//   0 : Ok
//  -1 : Fehler beim setzten
//  -2 : keine Datei geöffnet
PROCEDURE TDateiPufferStream.SetzePosition(Position: Int64);
BEGIN
  IF FDateiHandle > -1 THEN
  BEGIN
    IF (Position < 0) OR
       (Position > FDateiGroesse) THEN
      FFehler := -1
    ELSE
    BEGIN
      FPosition := Position;
      FFehler := 0;
    END;
  END
  ELSE
    FFehler := -2;
END;

PROCEDURE TDateiPufferStream.SetzePufferGroesse(Groesse: Integer);
BEGIN
  IF Assigned(FDatenZeiger) THEN
  BEGIN
    FreeMem(FDatenZeiger, FPufferGroesse);
    FDatenZeiger := NIL;
  END;
  PufferMax := -1;                                                              // Puffer leer
  PufferMin := -1;                                                              // Puffer leer
  FPufferGroesse := Groesse;
END;

// füllt den Puffer mit Daten aus der Datei
// > 0 : Anzahl der tatsächlich gelesenen Bytes
//  -1 : Fehler beim lesen aus der Datei
//  -2 : Anfang der Datei erreicht (rückwärts lesen)
//  -3 : Ende der Datei erreicht
FUNCTION TDateiPufferStream.Pufferfuellen: Integer;
BEGIN
  Result := 0;
  IF Frueckwaerts THEN
    IF FPosition > 0 THEN
    BEGIN
      IF (FPosition - FPuffergroesse) < 0 THEN
        PufferMin := FileSeek(FDateiHandle, Int64(0), 0)
      ELSE
        PufferMin := FileSeek(FDateiHandle, FPosition - FPuffergroesse, 0);
      PufferMax := FileRead(FDateiHandle, FDatenZeiger^, FPuffergroesse);
    END
    ELSE
      Result := -2
  ELSE
    IF FPosition < FDateigroesse THEN
    BEGIN
      IF (FPosition + FPuffergroesse) > FDateigroesse THEN
        IF (FDateigroesse - FPuffergroesse) < 0 THEN
          PufferMin := FileSeek(FDateiHandle, Int64(0), 0)
        ELSE
          PufferMin := FileSeek(FDateiHandle, FDateigroesse - FPuffergroesse, 0)
      ELSE
        PufferMin := FileSeek(FDateiHandle, FPosition, 0);
      PufferMax := FileRead(FDateiHandle, FDatenZeiger^, FPuffergroesse);
    END
    ELSE
      Result := -3;
  IF Result = 0 THEN
    IF PufferMax < 1 THEN
    BEGIN
      Result := -1;
      PufferMax := -1;                                                          // Puffer leer
      PufferMin := -1;                                                          // Puffer leer
    END
    ELSE
      PufferMax := PufferMin + PufferMax - 1;
END;

// Variablen initialisieren
CONSTRUCTOR TDateiPufferStream.Create;
BEGIN
  INHERITED Create;
  FDatenZeiger := NIL;
  FPosition := 0;
  FPufferGroesse := 5120;                                                       // 5 kByte
  PufferMax := -1;                                                              // Puffer leer
  PufferMin := -1;                                                              // Puffer leer
END;

// schließt die Datei und gibt den Speicher frei
PROCEDURE TDateiPufferStream.Dateischliessen;
BEGIN
  INHERITED Dateischliessen;
  IF Assigned(FDatenZeiger) THEN
  BEGIN
    FreeMem(FDatenZeiger, FPufferGroesse);
    FDatenZeiger := NIL;
  END;
  FPosition := 0;
  PufferMax := -1;                                                              // Puffer leer
  PufferMin := -1;                                                              // Puffer leer
END;

// verschiebt die Position um Anzahl Bytes
//   0 : Ok
//  -1 : Fehler (Datei am Ende oder Anfang)
//  -2 : keine Datei geöffnet
FUNCTION TDateiPufferStream.Schieben(Anzahl: Int64): Integer;
BEGIN
  IF FDateiHandle > -1 THEN
  BEGIN
    IF (Anzahl + FPosition < 0) OR
       (Anzahl + FPosition > FDateiGroesse) THEN
      Result := -1
    ELSE
    BEGIN
      FPosition := FPosition + Anzahl;
      Result := 0;
    END;
  END
  ELSE
    Result := -2;
  FFehler := Result;
END;

// liest ein Byte aus dem Speicher
// Rückgabewert ist das gelesene Byte
// $FF : Fehler beim lesen
//   0 : Ok
//  -1 : keine Datei geöffnet
//  -2 : Datei nicht zum lesen geöffnet
//  -3 : Fehler beim lesen (Datei zu klein)
FUNCTION TDateiPufferStream.LeseByte: Byte;

VAR Erg : Integer;

BEGIN
  FFehler := 0;
  Result := $FF;
  IF FDateiHandle > -1 THEN
    IF FMode = fmOpenRead THEN
    BEGIN
      IF NOT Assigned(FDatenZeiger) THEN
        GetMem(FDatenZeiger, FPuffergroesse);
      IF ((NOT Frueckwaerts) AND ((FPosition < PufferMin) OR (FPosition > PufferMax))) OR
         (Frueckwaerts AND ((FPosition - 1 < PufferMin) OR (FPosition - 1 > PufferMax))) THEN
        Erg := Pufferfuellen
      ELSE
        Erg := 0;
      IF Erg > -1 THEN
      BEGIN
        IF Frueckwaerts THEN
          Dec(FPosition);
        Result := PByteArray(FDatenZeiger)[FPosition - PufferMin];
        IF NOT Frueckwaerts THEN
          Inc(FPosition);
      END
      ELSE
        FFehler := -3;
    END    
    ELSE
      FFehler := -2
  ELSE
    FFehler := -1;
END;

// liest Daten aus dem Speicher in den Puffer, Laenge ist die Anzahl der Daten die gelesen werden sollen in Byte
// > 0 : Anzahl der tatsächlich gelesenen Bytes
//  -1 : keine Datei geöffnet
//  -2 : Datei nicht zum lesen geöffnet
//  -3 : die Datei ist zu klein
FUNCTION TDateiPufferStream.LesePuffer(VAR Puffer; Laenge: Int64): Integer;

VAR Erg : Integer;

BEGIN
  Result := 0;
  FFehler := 0;
  IF FDateiHandle > -1 THEN
    IF FMode = fmOpenRead THEN
    BEGIN
      IF NOT Assigned(FDatenZeiger) THEN
        GetMem(FDatenZeiger, FPuffergroesse);
      Erg := 0;
      WHILE (Result < Laenge) AND
            (Erg > -1) DO
      BEGIN
        IF ((NOT Frueckwaerts) AND ((FPosition < PufferMin) OR (FPosition > PufferMax))) OR
           (Frueckwaerts AND ((FPosition - 1 < PufferMin) OR (FPosition - 1 > PufferMax))) THEN
          Erg := Pufferfuellen;
        IF Erg > -1 THEN
        BEGIN
          IF Frueckwaerts THEN
          BEGIN
            Dec(FPosition);
            TByteArray(Puffer)[Laenge - Result - 1] := PByteArray(FDatenZeiger)[FPosition - PufferMin];
          END
          ELSE
          BEGIN
            TByteArray(Puffer)[Result] := PByteArray(FDatenZeiger)[FPosition - PufferMin];
            Inc(FPosition);
          END;
          Inc(Result);
        END;
      END;
      IF Result < Laenge THEN
        FFehler := -3;
    END
    ELSE
      Result := -2
  ELSE
    Result := -1;
  IF Result < 0 THEN
    FFehler := Result;
END;

end.
