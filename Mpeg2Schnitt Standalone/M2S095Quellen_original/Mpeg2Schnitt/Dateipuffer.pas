{----------------------------------------------------------------------------------------------
Dateipuffer enthält alle Klassen und Funktionen zum gepufferten lesen und schreiben von Dateien.
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

unit Dateipuffer;

interface

USES SysUtils,        // Dateiroutinen
     Math,            // Power-Funktion
     Classes;         // fmCreate

TYPE
  TDateiPuffer = CLASS
    DateiName : STRING;
    DateiMode : Integer;
    Dateigroesse : Int64;
    DateiHandle : Integer;
    DateiPuffer : PChar;
    Puffergroesse : Integer;
    PufferMax : Integer;
    PufferZaehler : Int64;
    PufferPosition : Int64;
    Dateigelesen : Boolean;
    DateiEnde : Boolean;
    CONSTRUCTOR Create(Name: STRING; Mode: LongWord);
    DESTRUCTOR Destroy; OVERRIDE;
    PROCEDURE Pufferfreigeben;
    PROCEDURE PufferInitialisieren;
    PROCEDURE SetPufferGroesse(Groesse: Integer);
    FUNCTION GetPufferGroesse: Integer;
    FUNCTION Dateioeffnen(Name: STRING; Mode: LongWord): Boolean;
    PROCEDURE Dateischliessen;
    FUNCTION GetDateigroesse: Int64;
    FUNCTION Pufferfuellen: Boolean;
    FUNCTION Lesen(VAR Byte1: Byte): Boolean;
    FUNCTION LesenX(VAR Puffer: ARRAY OF Byte; Laenge: Integer): Boolean;
    FUNCTION LesenY(VAR Puffer: ARRAY OF Byte; Laenge: Integer): Boolean;
    FUNCTION LesenDirekt(VAR Puffer; Laenge: Integer): Integer;
    FUNCTION SchreibenDirekt(CONST Puffer; Laenge: Integer): Integer;
    FUNCTION Vor(Schritte: Int64): Boolean;
    FUNCTION Zurueck(Schritte: Int64): Boolean;
    FUNCTION NeuePosition(Pos: Int64): Boolean;
    FUNCTION AktuelleAdr: Int64;
    FUNCTION Finden(Gesucht, Laenge: Word): Boolean;
  END;
                                         
implementation

CONSTRUCTOR TDateiPuffer.Create(Name: STRING; Mode: LongWord);
BEGIN
  INHERITED Create;
  DateiHandle := -1;
  Puffergroesse := 5120;          // 5 kByte
  DateiPuffer := NIL;             // kein Pufferspeicher
  DateiMode := -1;
  DateiName := '';
  IF NOT (Name = '') THEN
    Dateioeffnen(Name, Mode);
END;

DESTRUCTOR TDateiPuffer.Destroy;
BEGIN
  Pufferfreigeben;
  IF DateiHandle > - 1 THEN
    FileClose(DateiHandle);
  INHERITED;
END;

PROCEDURE TDateiPuffer.Pufferfreigeben;
BEGIN
  IF DateiPuffer <> NIL THEN
  BEGIN
    FreeMem(DateiPuffer, Puffergroesse);
    DateiPuffer := NIL;
//    PufferZaehler := PufferZaehler + PufferMax;
    IF DateiHandle > - 1 THEN
      PufferZaehler := FileSeek(DateiHandle, PufferZaehler + PufferPosition, 0)
    ELSE                                                       // ab der aktuellen Position neu gefüllt,
      PufferZaehler := 0;                                      // ansonsten ist der Puffer als leer zu betrachten.
    PufferPosition := 0;
  END;
END;

PROCEDURE TDateiPuffer.PufferInitialisieren;
BEGIN
  Pufferfreigeben;
  IF DateiMode = fmOpenRead THEN                               // Ist die Datei zum lesen geöffnet
  BEGIN                                                        // und die Puffergöße größer 0
    IF Puffergroesse > 0 THEN                                  // wird Speicher besorgt und
      GetMem(DateiPuffer, Puffergroesse);                      // der Puffer mit dem Inhalt der Datei
{    IF DateiHandle > - 1 THEN
      PufferZaehler := FileSeek(DateiHandle, PufferZaehler + PufferPosition, 0)
    ELSE                                                       // ab der aktuellen Position neu gefüllt,
      PufferZaehler := 0;                                      // ansonsten ist der Puffer als leer zu betrachten.
    PufferPosition := 0;   }
    PufferMax := 0;
    Dateigelesen := False;
    DateiEnde := False;
    Pufferfuellen;
  END;
END;

PROCEDURE TDateiPuffer.SetPufferGroesse(Groesse: Integer);
BEGIN
  IF (Puffergroesse <> Groesse)THEN
  BEGIN
    Pufferfreigeben;
    IF Groesse > 1048576 THEN                                    // Puffer nicht größer 1 MByte
      Puffergroesse := 1048576
    ELSE
      Puffergroesse := Groesse;
    PufferInitialisieren;  
  END;
END;

FUNCTION TDateiPuffer.GetPufferGroesse: Integer;
BEGIN
  Result := Puffergroesse;
END;

FUNCTION TDateiPuffer.Dateioeffnen(Name: STRING; Mode: LongWord): Boolean;

VAR Offset : Int64;

BEGIN
  DateiMode := Mode;
  DateiName := Name;
  PufferMax := 0;
  PufferZaehler := 0;
  PufferPosition := 0;
  Dateigelesen := False;
  DateiEnde := False;
  IF DateiHandle > -1 THEN
    FileClose(DateiHandle);
  CASE Mode OF
  fmCreate :
    BEGIN
      DateiHandle := FileCreate(DateiName);
      Dateigroesse := 0;
    END;
  fmOpenWrite :
    BEGIN
      DateiHandle := FileOpen(DateiName, Mode OR fmShareDenyWrite);
      IF DateiHandle > -1 THEN
      BEGIN
        Dateigroesse := FileSeek(DateiHandle, 0, 2);
        FileSeek(DateiHandle, 0, 0);
      END
      ELSE
        Dateigroesse := 0;
    END;
  fmOpenRead :
    BEGIN
      DateiHandle := FileOpen(DateiName, Mode OR fmShareDenyWrite);
      IF DateiHandle > -1 THEN
      BEGIN
        Offset := 0;
        Dateigroesse := FileSeek(DateiHandle, Offset, 2);
        FileSeek(DateiHandle, 0, 0);
      END
      ELSE
        Dateigroesse := 0;
      PufferInitialisieren;
    END;
  END;
  IF DateiHandle > -1 THEN
  BEGIN
    DateiEnde := False;
    Result := True;
  END
  ELSE
  BEGIN
    DateiEnde := True;
    Result := False;
    DateiMode := -1;
  END;
END;

PROCEDURE TDateiPuffer.Dateischliessen;
BEGIN
  DateiMode := -1;
  DateiName := '';
  IF DateiHandle > -1 THEN
    FileClose(DateiHandle);
  DateiHandle := -1;
END;

FUNCTION TDateiPuffer.GetDateigroesse: Int64;

VAR Position : Int64;

BEGIN
  IF DateiHandle > -1 THEN
  BEGIN
    Position := FileSeek(DateiHandle, 0, 1);
    Result := FileSeek(DateiHandle, 0, 2);     
    FileSeek(DateiHandle, Position, 0);
  END
  ELSE
    Result := -1;
END;

FUNCTION TDateiPuffer.Pufferfuellen: Boolean;
BEGIN
  Result := False;
  IF (DateiPuffer <> NIL) AND (DateiMode = fmOpenRead) THEN
  BEGIN
    PufferPosition := 0;
    IF DateiHandle > -1 THEN
    BEGIN
      Result := True;
      PufferZaehler := PufferZaehler + PufferMax;
      PufferMax := FileRead(DateiHandle, DateiPuffer^, Puffergroesse);
      IF PufferMax < Puffergroesse THEN
        Dateigelesen := True;
      IF PufferMax <= 0 THEN
        DateiEnde := True;
    END;
  END;
END;

FUNCTION TDateiPuffer.Lesen(VAR Byte1: Byte): Boolean;
BEGIN
  IF (DateiPuffer <> NIL) AND (DateiMode = fmOpenRead) THEN
  BEGIN
    IF PufferPosition < PufferMax THEN
    BEGIN
      Byte1 := Byte(DateiPuffer[PufferPosition]);
      Result := True;
      Inc(PufferPosition);
    END
    ELSE
      Result := False;
    IF PufferPosition > PufferMax - 1 THEN
      IF Dateigelesen THEN
        DateiEnde := True
      ELSE
        Pufferfuellen;
  END
  ELSE
    Result := False;
END;

FUNCTION TDateiPuffer.LesenX(VAR Puffer: ARRAY OF Byte; Laenge: Integer): Boolean;

VAR I : Integer;

BEGIN
  Result := True;
  I := 0;
  WHILE (NOT DateiEnde) AND Result AND (I < Laenge) DO
  BEGIN
   Result := Lesen(Puffer[I]);
   Inc(I);
  END;
  IF I < Laenge THEN
    Result := False;
END;

FUNCTION TDateiPuffer.LesenY(VAR Puffer: ARRAY OF Byte; Laenge: Integer): Boolean;     // liest rückwärts

VAR I : Integer;

BEGIN
  Result := True;
  I := Laenge - 1;
  WHILE (NOT DateiEnde) AND Result AND (I > - 1) DO
  BEGIN
   Result := Lesen(Puffer[I]);
   Dec(I);
  END;
  IF I > - 1 THEN
    Result := False;
END;

FUNCTION TDateiPuffer.LesenDirekt(VAR Puffer; Laenge: Integer): Integer;
BEGIN
  IF (DateiMode = fmOpenRead) AND (DateiHandle > -1) AND (DateiPuffer = NIL) THEN
  BEGIN
    Result := FileRead(DateiHandle, Puffer, Laenge);
    IF Result > - 1 THEN
      PufferZaehler := PufferZaehler + Result;
  END
  ELSE
    Result := - 1;
END;

FUNCTION TDateiPuffer.SchreibenDirekt(CONST Puffer; Laenge: Integer): Integer;
BEGIN
  IF ((DateiMode = fmOpenWrite) OR (Dateimode = fmCreate)) AND
     (DateiHandle > -1)  AND (DateiPuffer = NIL) THEN
  BEGIN
    Result := FileWrite(DateiHandle, Puffer, Laenge);
    IF Result > - 1 THEN
      PufferZaehler := PufferZaehler + Result;
    IF PufferZaehler > Dateigroesse THEN
      Dateigroesse := PufferZaehler;
  END
  ELSE
    Result := - 1;
END;

FUNCTION TDateiPuffer.Vor(Schritte: Int64): Boolean;
BEGIN
  Result := NeuePosition(PufferZaehler + PufferPosition + Schritte);
END;

FUNCTION TDateiPuffer.Zurueck(Schritte: Int64): Boolean;       
BEGIN
  Result := NeuePosition(PufferZaehler + PufferPosition - Schritte);
END;

FUNCTION TDateiPuffer.NeuePosition(Pos: Int64): Boolean;
BEGIN
  IF (Pos >= PufferZaehler) AND (Pos < PufferZaehler + PufferMax) AND (DateiPuffer <> NIL) THEN
  BEGIN
    PufferPosition := Pos - PufferZaehler;
    Result := True;
    DateiEnde := False;
  END
  ELSE
  BEGIN
    IF (Pos > -1) AND (((DateiMode = fmOpenRead) AND (Pos < Dateigroesse)) OR
       (((DateiMode = fmOpenWrite) OR (Dateimode = fmCreate)) AND (Pos < Dateigroesse + 1))) AND
       (DateiHandle > -1) THEN
    BEGIN
      PufferZaehler := FileSeek(DateiHandle, Pos, 0);
      PufferMax := 0;
      PufferPosition := 0;
      Dateigelesen := False;
      DateiEnde := False;
      Pufferfuellen;
      IF PufferZaehler = Pos THEN
        Result := True
      ELSE
        Result := False;
    END
    ELSE
      Result := False;
  END;
END;

FUNCTION TDateiPuffer.AktuelleAdr: Int64;
BEGIN
  Result := PufferZaehler + PufferPosition;
END;

FUNCTION TDateiPuffer.Finden(Gesucht, Laenge: Word): Boolean;

VAR Byte1 : Byte;
    Byte4 : Longword;
    Maske : Longword;
    Gefunden : Boolean;

BEGIN
  Byte4 :=  NOT Gesucht;
  Maske := Trunc(Power(2, Laenge) - 1);
  Gefunden := False;
  Result := False;
  WHILE (NOT DateiEnde) AND (NOT Gefunden) DO
  BEGIN
    IF NOT Lesen(Byte1) THEN
      Exit;
    Byte4 := (Byte4 SHL 8) OR Byte1;
    IF (Byte4 AND Maske) = Gesucht THEN
      Gefunden := True;
  END;
END;

end.
