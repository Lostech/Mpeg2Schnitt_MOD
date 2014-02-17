{----------------------------------------------------------------------------------------------
Die VideoIndexUnit enthält alle Klassen und Funktionen zum erstellen der Mpeg2-Indexdateien.
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

 Aufbau der alten Indexdatei Video:

   3 Byte Zeichenkette 'idd'     (Indexdatei)
   1 Byte Versionsnummer
   Wiederholen bis Dateiende
     1 Byte Headertype           ($B3-Sequenzheader, $B8-Gruppenheader, $00-Bildheader)
     8 Byte (Int64) Adresse des Headers in der Datei (inclusive 4 Byte Startcode $00 00 01 xx)
     Wenn Bildheader dann
       2 Byte (Wort) temporäre Referenz
       1 Byte Bildtype           (1-IFrame, 2-PFrame, 3-BFrame)
   Wiederholen Ende
   1 Byte HeaderType             ($B7-Sequenzendcode)
   8 Byte Adresse                (wird zum kopieren des letzten Bildes gebraucht)

Aufbau der Indexdatei Video:

   3 Byte Zeichenkette 'idd'     (Indexdatei)
   1 Byte Versionsnummer         (3)
   8 Byte Adresse der Sequenzheaderliste
   Wiederholen für jedes Bild in der Videodatei
     7 Byte Adresse des Bilder
     1 Byte Bildtype             (1-IFrame, 2-PFrame, 3-BFrame)
   Wiederholen Ende
   Wiederholen für jeden Sequenzheader in der Videodatei
     8 Byte Adresse des Sequenzheaders  (nur unterschiedliche Header)
   Wiederholen Ende
   wenn Sequenzendeheader vorhanden
    7 Byte Adresse des Sequenzendheaders
    1 Byte B7
   ansonsten
    7 Byte Dateigröße
    1 Byte FF

 Aufbau der Indexdatei Audio (für alle Audiotypen):

   3 Byte Zeichenkette 'idd'     (Indexdatei)
   1 Byte Versionsnummer
   Wiederholen bis Dateiende
     8 Byte (Int64) Adresse des Headers in der Datei (inclusive SyncBytes)
            ---pro Audioframe eine Adresse---
   Wiederholen Ende
   8 Byte Adresse nach dem letzten Byte des letzten Audioframes (meist Dateigröße)

-------------------------------------------------------------------------------------- }
unit VideoIndexUnit;

interface

USES
  Windows, SysUtils, Classes,
  DateiStreamUnit,
  VideoHeaderUnit;

TYPE
  TFortschrittsanzeige = FUNCTION(Endwert, Fortschritt: Int64): Boolean;

FUNCTION Listenstreamerzeugen(Datei, Zielname: STRING): Integer;
FUNCTION Listenstreamumwandeln(Datei, Zielname, Videoname: STRING; SHneu: Boolean = False): Integer;

VAR Fortschrittsanzeige : TFortschrittsanzeige;

implementation

FUNCTION Listenstreamerzeugen(Datei, Zielname: STRING): Integer;

VAR DateiStream : TDateiPufferStream;
    Listenstream,
    Sequenzstream : TMemoryStream;
    SequenzHeader1,
    SequenzHeader2,
    HSequenzHeader : TSequenzHeader;
    BildHeader : TBildHeader;
    Adresse,
    BildPosition : Int64;
    groessteTempRef,
    Header : Integer;

BEGIN
  DateiStream := TDateiPufferStream.Create;
  TRY
    Result := DateiStream.Dateioeffnen(Datei);
    IF Result = 0 THEN
    BEGIN
      Listenstream := TMemoryStream.Create;
      Sequenzstream := TMemoryStream.Create;
      TRY
        SequenzHeader1 := TSequenzHeader.Create;
        SequenzHeader2 := TSequenzHeader.Create;
        BildHeader := TBildHeader.Create;
        TRY
          BildPosition := 0;
          groessteTempRef := -1;
          Header := $FF;
          Adresse := 56910953;                                                  // neue Version 3
          Listenstream.Write(Adresse, 4);                                       // "idd" + Version schreiben
          Adresse := 0;
          Listenstream.Write(Adresse, 8);                                       // Platzhalter für Adresse der Sequenzheader
          WHILE Result > -1 DO
          BEGIN
            Result := SequenzHeader2.SucheHeader(DateiStream, [SequenceStartCode, BildStartCode, SequenceEndeCode], -1, True);
            IF Result = SequenceStartCode THEN
            BEGIN
              Header := Result;
              Result := SequenzHeader2.LeseHeader(DateiStream);
              IF Result = 0 THEN
              BEGIN
                IF SequenzHeader1.Vergleichen(SequenzHeader2) < 0 THEN
                BEGIN
                  Sequenzstream.Write(SequenzHeader2.Adresse, 8);
                  HSequenzHeader := SequenzHeader1;
                  SequenzHeader1 := SequenzHeader2;
                  SequenzHeader2 := HSequenzHeader;
                END;
              END
              ELSE
                Result := Result - 20;
            END
            ELSE
              IF Result = BildStartCode THEN
              BEGIN
                Header := Result;
                Result := BildHeader.LeseHeader(DateiStream);
                IF Result = 0 THEN
                BEGIN
                  IF BildHeader.BildTyp = 1 THEN
                  BEGIN
                    BildPosition := BildPosition + groessteTempRef + 1;
                    groessteTempRef := 0;
                  END;
                  IF groessteTempRef < BildHeader.TempRefer THEN
                    groessteTempRef := BildHeader.TempRefer;
                  Listenstream.Seek(((BildPosition + BildHeader.TempRefer) * 8) + 12, soFromBeginning);
                  Adresse := (BildHeader.Adresse AND $FFFFFFFFFFFFFF) + (Int64(BildHeader.BildTyp) SHL 56);
                  Listenstream.Write(Adresse, 8);
                END
                ELSE
                  Result := Result - 30;
              END
              ELSE
                IF Result = SequenceEndeCode THEN
                BEGIN
                  Header := Result;
                  Adresse := (DateiStream.Position AND $FFFFFFFFFFFFFF) + (Int64(SequenceEndeCode) SHL 56);
                  DateiStream.Schieben(4);
                END
                ELSE
                  Result := Result - 10;
            IF Assigned(Fortschrittsanzeige) THEN
              IF Fortschrittsanzeige(DateiStream.Dateigroesse, DateiStream.Position) THEN
                Result := -1;
          END;
          IF Result = -13 THEN                                                  // Dateiende erreicht
          BEGIN
            Result := 0;
            IF NOT (Header = SequenceEndeCode) THEN
              Adresse := (DateiStream.Dateigroesse AND $FFFFFFFFFFFFFF) + $FF00000000000000;
            Sequenzstream.Write(Adresse, 8);
          END;
          Adresse := Listenstream.Size;                                         // Adresse der Sequenzheader
          Listenstream.Seek(4, soFromBeginning);
          Listenstream.Write(Adresse, 8);
          Listenstream.Seek(0, soFromEnd);
          Listenstream.Write(Sequenzstream.Memory^, Sequenzstream.Size);        // Sequenzheaderstream anhängen
          Listenstream.SaveToFile(Zielname);
        FINALLY
          SequenzHeader1.Free;
          SequenzHeader2.Free;
          BildHeader.Free;
        END;
      FINALLY
        Listenstream.Free;
        Sequenzstream.Free;
      END;
    END;
  FINALLY
    DateiStream.Free;
  END;
END;

FUNCTION Listenstreamumwandeln(Datei, Zielname, Videoname: STRING; SHneu: Boolean = False): Integer;

VAR AlterListenstream,
    Listenstream,
    Sequenzstream : TMemoryStream;
    Videodateistream : TDateiPufferStream;
    SequenzHeader1,
    SequenzHeader2,
    HSequenzHeader : TSequenzHeader;
    Adresse,
    SequenzHeaderAdresse,
    BildPosition : Int64;
    TempRef,
    groessteTempRef,
    SequenzHeaderZaehler : Integer;
    Headertyp,
    BildTyp : Byte;

BEGIN
  AlterListenstream := TMemoryStream.Create;
  TRY
    AlterListenstream.LoadFromFile(Datei);
    Result := AlterListenstream.Read(Adresse, 4);
    IF Result = 4 THEN
    BEGIN
      IF Adresse AND $FFFFFFFF = 40133737 THEN                                  // entspricht idd2
      BEGIN
        BildPosition := 0;
        groessteTempRef := -1;
        SequenzHeaderZaehler := 0;
        Listenstream := TMemoryStream.Create;
        Sequenzstream := TMemoryStream.Create;
        Videodateistream := TDateiPufferStream.Create;
        SequenzHeader1 := TSequenzHeader.Create;
        SequenzHeader2 := TSequenzHeader.Create;
        TRY
          Videodateistream.PufferGroesse := 256;
          Videodateistream.Dateioeffnen(Videoname);
          Adresse := 56910953;                                                  // neue Version 3
          Listenstream.Write(Adresse, 4);                                       // "idd" + Version schreiben
          Adresse := 0;
          Listenstream.Write(Adresse, 8);                                       // Platzhalter für Adresse der Sequenzheader
          WHILE Result > -1 DO
          BEGIN
            Result := AlterListenstream.Read(HeaderTyp, 1);
            IF Result = 1 THEN
            BEGIN
              Adresse := 0;
              Result := AlterListenstream.Read(Adresse, 8);
              IF Result = 8 THEN
              BEGIN
                IF HeaderTyp = SequenceStartCode THEN                           // Sequenzheader
                BEGIN
                  IF SHneu THEN
                  BEGIN
                    Result := SequenzHeader2.LeseHeader(Videodateistream, Adresse);
                    IF Result = 0 THEN
                    BEGIN
                      IF SequenzHeader1.Vergleichen(SequenzHeader2) < 0 THEN
                      BEGIN
                        Sequenzstream.Write(Adresse, 8);
                        HSequenzHeader := SequenzHeader1;
                        SequenzHeader1 := SequenzHeader2;
                        SequenzHeader2 := HSequenzHeader;
                      END;
                    END
                    ELSE
                      Result := Result - 20;
                  END
                  ELSE
                  BEGIN
                    IF Sequenzstream.Size = 0 THEN
                    BEGIN
                      Sequenzstream.Write(Adresse, 8);
                      SequenzHeaderAdresse := -1;
                    END
                    ELSE
                      SequenzHeaderAdresse := Adresse;
                    SequenzHeaderZaehler := 0;
                  END;
                END
                ELSE
                  IF HeaderTyp = BildStartCode THEN                             // Bildheader
                  BEGIN
                    TempRef := 0;
                    Result := AlterListenstream.Read(TempRef, 2);
                    IF Result = 2 THEN
                    BEGIN
                      Result := AlterListenstream.Read(BildTyp, 1);
                      IF Result = 1 THEN
                      BEGIN
                        IF BildTyp = 1 THEN                                     // I-Frame
                        BEGIN
                          BildPosition := BildPosition + groessteTempRef + 1;
                          groessteTempRef := 0;
                          IF NOT SHneu THEN
                          BEGIN
                            Inc(SequenzHeaderZaehler);
                            IF (SequenzHeaderZaehler = 2) AND (SequenzHeaderAdresse > -1) THEN
                              Sequenzstream.Write(SequenzHeaderAdresse, 8);
                          END;
                        END;
                        IF groessteTempRef < TempRef THEN
                          groessteTempRef := TempRef;
                        Listenstream.Seek(((BildPosition + TempRef) * 8) + 12, soFromBeginning);
                        Adresse := (Adresse AND $FFFFFFFFFFFFFF) + (Int64(BildTyp) SHL 56);
                        Listenstream.Write(Adresse, 8);
                      END
                      ELSE
                        Result := -13;                                          // Dateiende (Speicherende) erreicht
                    END
                    ELSE
                      IF Result < 0 THEN
                        Result := Result - 10
                      ELSE
                        Result := -14;
                  END
                  ELSE
                    IF HeaderTyp = SequenceEndeCode THEN
                    BEGIN
                      IF Adresse = VideodateiStream.Dateigroesse THEN
                        Adresse := (Adresse AND $FFFFFFFFFFFFFF) + $FF00000000000000
                      ELSE
                        Adresse := (Adresse AND $FFFFFFFFFFFFFF) + (Int64(SequenceEndeCode) SHL 56);
                      Sequenzstream.Write(Adresse, 8);
                    END;
              END
              ELSE
                IF Result < 0 THEN
                  Result := Result - 10
                ELSE
                  Result := -14;
            END
            ELSE
              Result := -13;                                                    // Dateiende (Speicherende) erreicht
            IF Assigned(Fortschrittsanzeige) THEN
              IF Fortschrittsanzeige(AlterListenstream.Size, AlterListenstream.Position) THEN
                Result := -1;
          END;
          IF Result = -13 THEN                                                  // Dateiende erreicht
            Result := 0;
          Adresse := Listenstream.Size;                                         // Adresse der Sequenzheader
          Listenstream.Seek(4, soFromBeginning);
          Listenstream.Write(Adresse, 8);
          Listenstream.Seek(0, soFromEnd);
          Listenstream.Write(Sequenzstream.Memory^, Sequenzstream.Size);        // Sequenzheaderstream anhängen
          Listenstream.SaveToFile(Zielname);
        FINALLY
          Listenstream.Free;
          Sequenzstream.Free;
          Videodateistream.Free;
          SequenzHeader1.Free;
          SequenzHeader2.Free;
        END;
      END
      ELSE
        Result := -1;
    END
    ELSE
      IF Result < 0 THEN
        Result := Result - 10
      ELSE
        Result := -14;
  FINALLY
    AlterListenstream.Free;
  END;
END;

end.
