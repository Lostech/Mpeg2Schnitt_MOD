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

Aufbau der Mpeg AudioHeader:  (kein Anspruch auf Vollständigkeit)

SyncWort: FF E    (11111111 111)   (4 Byte)
     2 Bit Version   (0, 2, 3)
     2 Bit Layer;    (1, 2, 3)
     1 Bit Protection  (0 - CRC, 1 - kein CRC)
     4 Bit Bitrate   (1 - 14)
     2 Samplerate    (0, 1, 2)
     1 Bit Padding
     1 Bit Privat
     2 Bit Mode
     2 Bit ModeErweiterung
     1 Bit Copyright
     1 Bit Orginal
     2 Bit Emphasis

Aufbau der AC3 AudioHeader:  (kein Anspruch auf Vollständigkeit)

SyncWort: 0B 77    (00001011 01110111)   (mindestens 7 Byte)
    16 Bit Prüfsumme
     2 Bit Samplerate                    (0, 1, 2)
     6 Bit Bitrate                       (0 - 37)
     5 Bit Stream Identification         (01000 = 8)
     3 Bit Mode                          (bsmode)
     3 Bit ModeErweiterung               (acmode)
     2 Bit Mixlevel/Surroundmode         (cmixlev, surmixlev, dsurmod)
     1 Bit LowFrequenzEffects            (lfeon)

--------------------------------------------------------------------------------------}

unit AudioIndexUnit;

interface

USES
  Dialogs,                  // Showmessage
  Classes,                  // Klassen
  SysUtils,                 // Dateioperationen, Stringfunktionen ...
  DateUtils,                // zum messen der Zeit die einige Funktionen benötigen
  ComCtrls,                 // für TTreeNode
  StrUtils,                 // für AnsiReplaceText
  Dateipuffer,              // Schreib- und Lesefunktionen mit Pufferung
  ProtokollUnit,            // zum protokollieren :-)
  Sprachen,                 // zum übersetzen der Meldungen
  AllgFunktionen,           // Zeit messen, Meldungsfenster
//  Optfenster,               // Effekttypen
  DatenTypen,               // für verwendete Datentypen
  SchnittTypenUnit;

TYPE
  TAudioHeaderklein = CLASS
    Adresse : Int64;
  END;

  TAudioIndex = CLASS(TObject)
  PRIVATE
    Listenstream : TDateiPuffer;
    IndexdateiVersion : Integer;
    FDateiname : STRING;
    FFortschrittsEndwert : PInt64;
    FFortschrittsanzeige : TFortschrittsanzeige;
    FTextanzeige : TTextanzeige;
//    FProtokollschreibenFehlerNr : TProtokollschreibenFehlerNr;
    Anhalten : Boolean;
    FAudioDateiType : Byte;
    FUNCTION Audiotyplesen: Byte;
    // Audiotype
    FUNCTION Audiotypsuchen: Byte;
    // Audiotype
    FUNCTION AudioDateiTypesuchen: Byte;
    // Audiotype
    FUNCTION Mpegheaderlesen(Audioheader: TAudioHeader; zumNaechstenHeader: Boolean; VAR AdrFehler: Integer): Integer;
    //  0 = weitere Daten vorhanden, 1 = letztes Frame vollständig
    //  2 = letztes Frame unvollständig, -1 = Fehler im Header
    // -2 = kein Syncbyte gefunden
    FUNCTION AC3_headerlesen(Audioheader: TAudioHeader; zumNaechstenHeader: Boolean; VAR AdrFehler: Integer): Integer;
    //  0 = weitere Daten vorhanden, 1 = letztes Frame vollständig
    //  2 = letztes Frame unvollständig, -1 = Fehler im Header
    // -2 = kein Syncbyte gefunden
    FUNCTION HeaderIndexdateiSchreiben(VAR Header: TAudioheaderklein): Integer;
    //  0 = schreiben erfolgreich, -1 = Schreibfehler
    FUNCTION HeaderIndexdateiLesen(VAR Header: TAudioheaderklein): Integer;
    //  0 = lesen erfolgreich, -1 = Lesefehler Adresse, -2 = Listenstream zu kurz
    FUNCTION AudioDateiTypelesen: Byte;
    FUNCTION Dateigroesselesen: Int64;
    PROCEDURE PufferGroesseschreiben(Puffer: LongInt);
  PUBLIC
    DateiStream : TDateiPuffer;
    PROPERTY Dateiname : STRING READ FDateiname WRITE FDateiname;
    PROPERTY AudioDateiType : Byte READ AudioDateiTypelesen;
    PROPERTY Dateigroesse : Int64 READ Dateigroesselesen;
    PROPERTY FortschrittsEndwert : PInt64 WRITE FFortschrittsEndwert;
    PROPERTY Fortschrittsanzeige : TFortschrittsanzeige WRITE FFortschrittsanzeige;
    PROPERTY Textanzeige : TTextanzeige WRITE FTextanzeige;
//    PROPERTY ProtokollschreibenFehlerNr : TProtokollschreibenFehlerNr WRITE FProtokollschreibenFehlerNr;
    PROPERTY PufferGroesse : LongInt WRITE PufferGroesseschreiben;
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
    FUNCTION DateiOeffnen(Name: STRING): Integer;
    //  0 = Datei geöffnet, -1 = Datei läßt sich nicht öffnen
    // -2 = Datei existiert nicht
    PROCEDURE Dateischliessen;
    FUNCTION IndexdateiNeu: Integer;
    //  0 = Indexdatei angelegt und zum schreiben geöffnet
    // -1 = Indexdatei läßt sich nicht anlegen, -2 = kein Dateiname vorhanden
    FUNCTION IndexdateiOeffnen: Integer;
    //  0 = Indexdatei zum lesen geöffnet
    //  1 = Indexdatei zum schreiben geöffnet
    // -1 = Indexdatei läßt sich nicht anlegen/öffnen
    // -2 = kein Dateiname vorhanden
    PROCEDURE Indexdateischliessen;
    PROCEDURE Indexdateiloeschen;
    FUNCTION DateiInformationLesen(VAR AudioHeader: TAudioHeader): Integer;
    //  0 = weitere Daten vorhanden, 1 = letztes Frame vollständig
    //  2 = letztes Frame unvollständig, -1 = Fehler im Header
    // -2 = kein Syncbyte gefunden, -3 = falscher Audiotype
    // -4 = Dateistream nicht zum lesen geöffnet
    FUNCTION DateiBereichLesen(Adresse: Int64; VAR Laenge: Integer; Puffer: ARRAY OF Byte; Adressenichtaendern: Boolean): Integer;
    //  0 = Dateibereich gelesen, -1 = gelesener Bereich kürzer (neue Länge in Laenge),
    // -2 = Adresse größer als Dateigröße, -3 = Fehler beim lesen der Datei
    // -4 = Dateistream nicht zum lesen geöffnet
    FUNCTION Framelesen(VAR Laenge: Integer; VAR Puffer: ARRAY OF Byte; Adressenichtaendern: Boolean): Integer;
    //  0 = Dateibereich gelesen, -1 = gelesener Bereich kürzer (neue Länge in Laenge),
    // -2 = Adresse größer als Dateigröße, -3 = Fehler beim lesen der Datei
    // -4 = Dateistream nicht zum lesen geöffnet, -5 = kein weiteres Syncbyte gefunden
    FUNCTION Indexdateipruefen: Integer;
    //  0 = Indexdatei Ok, -1 = falsche Indexdatei
    // -2 = Listenstream nicht zum lesen geöffnet, -3 = Dateistream nicht zum lesen geöffnet
    // -4 = Listenstream läßt sich nicht lesen, -5 = Dateistrem läßt sich nicht lesen
    FUNCTION Indexlistenerzeugen(Liste, AudiotypeListe: TListe): Integer;
    //  0 = Dateiende erreicht, 1 = letztes Frame nicht vollständig,
    // -1 = falscher Audiotype, -4 = Dateistream nicht zum lesen geöffnet
    // -5 = Abbruch durch Benutzer
    FUNCTION Indexdateierzeugen(Liste, AudiotypeListe: TListe): Integer;
    //  0 = Indexdatei geschrieben, -1 = Listenstream ist nicht leer
    // -2 = Fehler beim schreiben in den Listenstream, -3 = Listenstream nicht zum schreiben geöffnet
    // -4 = Listen leer, -5 = Abbruch durch Benutzer
    FUNCTION Indexdateilesen(Liste, AudiotypeListe: TListe; VAR Audioversatz: Integer): Integer;
    //  0 = Indexdatei gelesen, -1 = Indexdatei ist zu kurz
    // -2 = keine Indexdateikennung (idd), -3 = Fehler beim lesen aus dem Listenstream
    // -4 = Listenstream nicht zum lesen geöffnet, -5 = Abbruch durch Benutzer
    // -6 = keine Listen übergeben
    FUNCTION IndexDateischreiben: Integer;
    FUNCTION Listeerzeugen(Liste, AudiotypeListe: TListe; VAR Audioversatz: Integer): Integer;
    //  0 = Indexdatei gelesen, 1 = Indexdatei geschrieben
    // -1 = Datei läßt sich nicht öffnen, -2 = Datei läßt sich nicht lesen
    // -3 = Indexdatei läßt sich nicht öffnen/erzeugen, -4 = Indexdatei läßt sich nicht lesen
    // -5 = Indexdatei läßt sich nicht erzeugen, -6 = Indexdatei läßt sich nicht schreiben
    // -7 = Indexliste läßt sich nicht erzeugen, -8 = kein Dateiname vorhanden
    // -9 = Abbruch durch Benutzer, -10 = allgemeiner Fehler
  END;

CONST
  SampleRaten : ARRAY[0..3] OF ARRAY[0..3] OF Word =
     { Version 2.5   }
    ((11025, 12000, 8000, 0),
     (0, 0, 0, 0),
     { Version 2   }
     (22050, 24000, 16000, 0),
     { Version 1 }
     (44100, 48000, 32000, 0));

  Bitraten : ARRAY[0..3] OF ARRAY[1..3] OF ARRAY[0..15] OF Word =
       { Version 2.5, Layer III, II, I   }
     (((0, 8,16,24, 32, 40, 48, 56, 64, 80, 96,112,128,144,160,0),
       (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96,112,128,144,160,0),
       (0,32,48,56, 64, 80, 96,112,128,144,160,176,192,224,256,0)),
       { Version Unbekannt   }
       ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
       (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
       (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)),
       { Version 2, Layer III, II, I     }
      ((0, 8,16,24, 32, 40, 48, 56, 64, 80, 96,112,128,144,160,0),
       (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96,112,128,144,160,0),
       (0,32,48,56, 64, 80, 96,112,128,144,160,176,192,224,256,0)),
       { Version 1, Layer III, II, I     }
      ((0,32,40,48, 56, 64, 80, 96,112,128,160,192,224,256,320,0),
       (0,32,48,56, 64, 80, 96,112,128,160,192,224,256,320,384,0),
       (0,32,64,96,128,160,192,224,256,288,320,352,384,416,448,0)));

  AC3Sampleraten : ARRAY[0..3] OF Word =
       { samplerate : 0 bis 3}
       (48000, 44100, 32000, 0);

  AC3Bitraten : ARRAY[0..37] OF Word =
       { frmsizecod : 0 bis 37}
       (32, 32, 40, 40, 48, 48, 56, 56, 64, 64, 80, 80, 96, 96, 112, 112, 128, 128, 160, 160, 192, 192, 224, 224, 256, 256, 320, 320, 384, 384, 448, 448, 512, 512, 576, 576, 640, 640);

  AC3Framelaenge : ARRAY[0..3] OF ARRAY[0..37] OF Word =
       { samplerate : 0 bis 3, frmsizecod : 0 bis 37}
      ((64, 64,  80,  80,  96,  96, 112, 112, 128, 128, 160, 160, 192, 192, 224, 224, 256, 256, 320, 320, 384, 384, 448, 448, 512, 512, 640, 640,  768,  768,  896,  896, 1024, 1024, 1152, 1152, 1280, 1280),
       (69, 70,  87,  88, 104, 105, 121, 122, 139, 140, 174, 175, 208, 209, 243, 244, 278, 279, 348, 349, 417, 418, 487, 488, 557, 558, 696, 697,  835,  836,  975,  976, 1114, 1115, 1253, 1254, 1393, 1394),
       (96, 96, 120, 120, 144, 144, 168, 168, 192, 192, 240, 240, 288, 288, 336, 336, 384, 384, 480, 480, 576, 576, 672, 672, 768, 768, 960, 960, 1152, 1152, 1344, 1344, 1536, 1536, 1728, 1728, 1920, 1920),
       ( 0,  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0));

implementation

CONSTRUCTOR TAudioIndex.Create;
BEGIN
  INHERITED Create;
  Dateistream := NIL;
  Listenstream := NIL;
  Anhalten := False;
  FAudioDateiType := 0;
  FDateiname := '';
END;

DESTRUCTOR TAudioIndex.Destroy;
BEGIN
  Dateischliessen;
  Indexdateischliessen;
  INHERITED Destroy;
END;

FUNCTION TAudioIndex.DateiOeffnen(Name: STRING): Integer;
BEGIN
  IF Assigned(Dateistream) THEN
    IF (Name = FDateiname) AND (Name = Dateistream.DateiName) THEN
    BEGIN
      IF NOT (Dateistream.DateiMode = fmOpenRead) THEN
        Dateischliessen;                                     // Dateistream schliessen
    END
    ELSE
      Dateischliessen;                                       // Dateistream schliessen
  IF NOT Assigned(Dateistream) THEN
  BEGIN
    Dateischliessen;                                         // Dateistream vor neuer Zuweisung schliessen
    IF FileExists(Name) THEN                                 // die Datei muß vorhanden sein
    BEGIN
      FDateiname := Name;
      Dateistream := TDateiPuffer.Create(Name, fmOpenRead);  // und Dateistream öffnen
      IF Dateistream.DateiEnde THEN
        Result := -1                                         // Audiodatei läßt sich nicht öffnen
      ELSE
        Result := 0;                                         // Audiodatei zum lesen geöffnet
    END
    ELSE
      Result := -2;                                          // Datei Audiodatei existiert nicht
  END
  ELSE
    Result := 0;                                             // Audiodatei weiter zum lesen geöffnet
END;

PROCEDURE TAudioIndex.Dateischliessen;
BEGIN
  IF Assigned(Dateistream) THEN                            // Dateistream schliessen
  BEGIN
    Dateistream.Free;
    Dateistream := NIL;
  END;
  Indexdateischliessen;                                    // Listenstream schliessen
  FAudioDateiType := 0;                                    // AudioDateiType zurücksetzen
  FDateiname := '';                                        // Dateiname zurücksetzen
END;

FUNCTION TAudioIndex.IndexdateiNeu: Integer;
BEGIN
  Indexdateischliessen;
  IF NOT (FDateiname = '') THEN
  BEGIN
    Listenstream := TDateiPuffer.Create(FDateiname + '.idd', fmCreate); // Indexdatei neu erzeugen
    IF Listenstream.DateiEnde THEN
      Result := -1                                       // Indexdatei läßt sich nicht anlegen
    ELSE
      Result := 0;                                       // Indexdatei angelegt und zum schreiben geöffnet
  END
  ELSE
    Result := -2;                                        // kein Dateiname vorhanden
END;

FUNCTION TAudioIndex.IndexdateiOeffnen: Integer;
BEGIN
  IF Assigned(Listenstream) THEN
    IF FDateiname + '.idd' = Listenstream.DateiName THEN
    BEGIN
      IF NOT (Listenstream.DateiMode = fmOpenRead) THEN
        Indexdateischliessen;                                // Indexdatei schliessen
    END
    ELSE
      Indexdateischliessen;                                  // Indexdatei schliessen
  IF NOT Assigned(Listenstream) THEN
  BEGIN
    Indexdateischliessen;                                    // Indexdatei vor neuer Zuweisung schliessen
    IF NOT (FDateiname = '') THEN
      IF FileExists(FDateiname + '.idd') THEN                 // Indexdatei vorhanden
      BEGIN
        Listenstream := TDateiPuffer.Create(FDateiname + '.idd', fmOpenRead); // Indexdatei zum lesen öffnen
        IF Listenstream.DateiEnde THEN
          Result := -1                                       // Indexdatei läßt sich nicht öffnen
        ELSE
          Result := 0;                                       // Indexdatei zum lesen geöffnet
      END
      ELSE
      BEGIN
        Listenstream := TDateiPuffer.Create(FDateiname + '.idd', fmCreate); // Indexdatei neu erzeugen
        IF Listenstream.DateiEnde THEN
          Result := -1                                       // Indexdatei läßt sich nicht anlegen
        ELSE
          Result := 1;                                       // Indexdatei angelegt und zum schreiben geöffnet
      END
    ELSE
      Result := -2;                                          // kein Dateiname vorhanden
  END
  ELSE
    Result := 0;                                             // Indexdatei weiter zum lesen geöffnet
END;

PROCEDURE TAudioIndex.Indexdateischliessen;
BEGIN
  IF Assigned(Listenstream) THEN
  BEGIN
    IF Listenstream.Dateigroesse = 0 THEN
    BEGIN
      Listenstream.Free;                                   // Listenstream schliessen
      IF FileExists(FDateiname + '.idd') THEN               // Listenstream löschen
        DeleteFile(FDateiname + '.idd');
    END
    ELSE
      Listenstream.Free;                                   // Listenstream schliessen
    Listenstream := NIL;
  END;
  IndexdateiVersion := 0;                                  // IndexdateiVersion zurücksetzen
END;

PROCEDURE TAudioIndex.Indexdateiloeschen;
BEGIN
  Indexdateischliessen;
  IF FileExists(FDateiname + '.idd') THEN
    DeleteFile(FDateiname + '.idd');
END;

PROCEDURE TAudioIndex.PufferGroesseschreiben(Puffer: LongInt);
BEGIN
  IF Assigned(Dateistream) THEN
    Dateistream.SetPuffergroesse(Puffer);
END;
{
PROCEDURE TAudioIndex.Audioheaderlesen(Audioheader: TAudioHeader);

VAR Puffer : ARRAY[0..1] OF Byte;
    Adr_merken : Int64;

BEGIN
  Adr_merken := DateiStream.AktuelleAdr;
//  AudiodateiEnde := 0;
  Word(Puffer) := $0;
  WHILE (NOT Dateistream.DateiEnde) AND (NOT ((Word(Puffer) AND $FFE0) = $FFE0)) DO
  BEGIN
    Word(Puffer) := ((Word(Puffer) AND $FF) SHL 8);
    Dateistream.Lesen(Puffer[0]);
  END;
  IF Dateistream.DateiEnde THEN
  BEGIN
    Audioheader.Framelaenge := 0;                    // Fehler im Audioheader
    Dateistream.NeuePosition(Adr_merken);            // Anfangsadresse wiederherstellen
//    AudiodateiEnde := 2;                             // letztes Frame ist nicht vollständig
    Exit;
  END;
  WITH Audioheader DO
  BEGIN
    Adresse := DateiStream.AktuelleAdr - 2;
    Version := (Puffer[0] AND $18) SHR 3;
    Layer := (Puffer[0] AND $06) SHR 1;
    Protection := (Puffer[0] AND $01) = 1;
    IF (Version > 3) OR (Version = 1) OR (Layer > 3) OR (Layer < 1)THEN
    BEGIN
      Framelaenge := 0;
      Dateistream.NeuePosition(Adr_merken);          // Anfangsadresse wiederherstellen
      Exit;
    END;
    IF NOT Dateistream.LesenX(Puffer, 2) THEN
    BEGIN
      Framelaenge := 0;
      Dateistream.NeuePosition(Adr_merken);          // Anfangsadresse wiederherstellen
//      AudiodateiEnde := 2;                           // letztes Frame ist nicht vollständig
      Exit;
    END;
    Bitrate := (Puffer[0] AND $F0) SHR 4;
    Samplerate := (Puffer[0] AND $0C) SHR 2;
    Padding := (Puffer[0] AND $02) = 2;
    Privat := (Puffer[0] AND $01) = 1;
    Mode := (Puffer[1] AND $C0) SHR 6;
    ModeErweiterung := (Puffer[1] AND $30) SHR 4;
    Copyright := (Puffer[1] AND $08) = 8;
    Orginal := (Puffer[1] AND $04) = 4;
    Emphasis := (Puffer[1] AND $03);
    IF (Bitrate > 14) OR (Bitrate < 1) OR (Samplerate > 2) THEN
    BEGIN
      Framelaenge := 0;
      Dateistream.NeuePosition(Adr_merken);          // Anfangsadresse wiederherstellen
      Exit;
    END;
    Samplerateberechnet := Sampleraten[Version][Samplerate];
    Bitrateberechnet := Bitraten[Version][Layer][Bitrate];
    IF Version = 3 THEN                                        // Version 1
    BEGIN
      IF Layer = 3 THEN                                        // Layer 1
      BEGIN
        Framelaenge := Trunc(12 * Bitrateberechnet * 1000 / Samplerateberechnet + Integer(Padding)) * 4;
        Framezeit := 384000 / Samplerateberechnet;
      END
      ELSE
      BEGIN                                                    // Layer 2 und 3
        Framelaenge := Trunc(144 * Bitrateberechnet * 1000 / Samplerateberechnet + Integer(Padding));
        Framezeit := 1152000 / Samplerateberechnet;
      END;
    END
    ELSE                                                       // Version 2 und 2,5
    BEGIN
      IF Layer = 3 THEN                                        // Layer 1
      BEGIN
        Framelaenge := Trunc(6 * Bitrateberechnet * 1000 / Samplerateberechnet + Integer(Padding)) * 4;
        Framezeit := 192000 / Samplerateberechnet;
      END
      ELSE
      BEGIN                                                    // Layer 2 und 3
        Framelaenge := Trunc(72 * Bitrateberechnet * 1000 / Samplerateberechnet + Integer(Padding));
        Framezeit := 576000 / Samplerateberechnet;
      END;
    END;
  END;
  Dateistream.NeuePosition(Adr_merken);            // Anfangsadresse wiederherstellen
END;   }

FUNCTION TAudioIndex.Mpegheaderlesen(Audioheader: TAudioHeader; zumNaechstenHeader: Boolean; VAR AdrFehler: Integer): Integer;

VAR Puffer : ARRAY[0..1] OF Byte;
    Adr_merken : Int64;

BEGIN
  WITH Audioheader DO
  BEGIN
    Adr_merken := DateiStream.AktuelleAdr;
    AdrFehler := -2;
    Word(Puffer) := $0;
    WHILE (NOT Dateistream.DateiEnde) AND (NOT ((Word(Puffer) AND $FFE0) = $FFE0)) DO
    BEGIN
      Word(Puffer) := ((Word(Puffer) AND $FF) SHL 8);
      Dateistream.Lesen(Puffer[0]);
      Inc(AdrFehler);
    END;
    IF Dateistream.DateiEnde AND (NOT ((Word(Puffer) AND $FFE0) = $FFE0)) THEN
    BEGIN
      Framelaenge := 0;                                // Fehler im Audioheader
      IF (Word(Puffer) AND $FFE0) = $FFE0 THEN
      BEGIN
        Adresse := DateiStream.AktuelleAdr - 1;        // Adresse des Syncbytes
        Result := 2;                                   // letztes Frame ist nicht vollständig
      END
      ELSE
      BEGIN
        Adresse := Adr_merken;                         // Anfangsadresse ist Audiodateiende
        Result := -2;                                  // kein Syncbyte gefunden
      END;
    END
    ELSE
    BEGIN
      Adresse := DateiStream.AktuelleAdr - 2;          // Adresse des Syncbytes
      Version := (Puffer[0] AND $18) SHR 3;
      Layer := (Puffer[0] AND $06) SHR 1;
      Protection := (Puffer[0] AND $01) = 1;
      IF NOT Dateistream.LesenX(Puffer, 2) THEN
      BEGIN
        Framelaenge := 0;
        Result := 2;                                   // letztes Frame ist nicht vollständig
      END
      ELSE
      BEGIN
        Bitrate := (Puffer[0] AND $F0) SHR 4;
        Samplerate := (Puffer[0] AND $0C) SHR 2;
        Padding := (Puffer[0] AND $02) = 2;
        Privat := (Puffer[0] AND $01) = 1;
        Mode := (Puffer[1] AND $C0) SHR 6;
        ModeErweiterung := (Puffer[1] AND $30) SHR 4;
        Copyright := (Puffer[1] AND $08) = 8;
        Orginal := (Puffer[1] AND $04) = 4;
        Emphasis := (Puffer[1] AND $03);
        IF (Version > 3) OR (Version = 1) OR (Layer > 3) OR (Layer < 1) OR
           (Bitrate > 14) OR (Bitrate < 1) OR (Samplerate > 2) THEN
        BEGIN
          Framelaenge := 0;
          Result := -1;                                // Fehler im Audioheader
        END
        ELSE
        BEGIN
          Samplerateberechnet := Sampleraten[Version][Samplerate];
          Bitrateberechnet := Bitraten[Version][Layer][Bitrate];
          IF Version = 3 THEN                          // Version 1
          BEGIN
            IF Layer = 3 THEN                          // Layer 1
            BEGIN
              Framelaenge := Trunc(12 * Bitrateberechnet * 1000 / Samplerateberechnet + Integer(Padding)) * 4;
              Framezeit := 384000 / Samplerateberechnet;
            END
            ELSE
            BEGIN                                      // Layer 2 und 3
              Framelaenge := Trunc(144 * Bitrateberechnet * 1000 / Samplerateberechnet + Integer(Padding));
              Framezeit := 1152000 / Samplerateberechnet;
            END;
          END
          ELSE                                         // Version 2 und 2,5
          BEGIN
            IF Layer = 3 THEN                          // Layer 1
            BEGIN
              Framelaenge := Trunc(6 * Bitrateberechnet * 1000 / Samplerateberechnet + Integer(Padding)) * 4;
              Framezeit := 192000 / Samplerateberechnet;
            END
            ELSE
            BEGIN                                      // Layer 2 und 3
              Framelaenge := Trunc(72 * Bitrateberechnet * 1000 / Samplerateberechnet + Integer(Padding));
              Framezeit := 576000 / Samplerateberechnet;
            END;
          END;
          IF Framelaenge < 5 THEN
          BEGIN
            Framelaenge := 0;
            Result := -1;                              // Fehler im Audioheader
          END
          ELSE
          BEGIN
            IF NOT Dateistream.Vor(Framelaenge - 4) THEN // Dateiende erreicht
              IF Dateistream.Vor(Framelaenge - 5) THEN
                Result := 1                            // letztes Frame ist vollständig
              ELSE
                Result := 2                            // letztes Frame nicht vollständig
            ELSE
              Result := 0;                             // weitere Daten vorhanden
          END;
        END;
      END;
    END;
  END;
  IF NOT zumNaechstenHeader THEN
    Dateistream.NeuePosition(Adr_merken);              // Anfangsadresse wiederherstellen
END;
{
PROCEDURE TAudioIndex.AC3Audioheaderlesen(Audioheader: TAudioHeader);

VAR Puffer : ARRAY[0..1] OF Byte;
    Adr_merken : Int64;

BEGIN
  Adr_merken := DateiStream.AktuelleAdr;
//  AudiodateiEnde := 0;
  Word(Puffer) := $0;
  WHILE (NOT Dateistream.DateiEnde) AND (NOT (Word(Puffer) = $0B77)) DO
  BEGIN
    Word(Puffer) := ((Word(Puffer) AND $FF) SHL 8);
    Dateistream.Lesen(Puffer[0]);
  END;
  Audioheader.Adresse := DateiStream.AktuelleAdr - 2;
  IF Dateistream.DateiEnde THEN
  BEGIN
    Audioheader.Framelaenge := 0;                    // Fehler im Audioheader
    Dateistream.NeuePosition(Adr_merken);            // Anfangsadresse wiederherstellen
//    AudiodateiEnde := 2;                             // letztes Frame ist nicht vollständig
    Exit;
  END;
  IF NOT Dateistream.Vor(2) THEN                     // Prüfsumme überspringen
  BEGIN
    Audioheader.Framelaenge := 0;
    Dateistream.NeuePosition(Adr_merken);            // Anfangsadresse wiederherstellen
//    AudiodateiEnde := 2;                             // letztes Frame ist nicht vollständig
    Exit;
  END;
  IF NOT Dateistream.LesenX(Puffer, 2) THEN
  BEGIN
    Audioheader.Framelaenge := 0;
    Dateistream.NeuePosition(Adr_merken);            // Anfangsadresse wiederherstellen
//    AudiodateiEnde := 2;                             // letztes Frame ist nicht vollständig
    Exit;
  END;
  WITH Audioheader DO
  BEGIN
    Samplerate := (Puffer[0] AND $C0) SHR 6;                   // fscode
    Bitrate := Puffer[0] AND $3F;                              // frmsizecode
    Mode := Puffer[1] AND $03;                                 // bsmode
    IF (Samplerate > 2) OR (Bitrate > 37) THEN
    BEGIN
      Framelaenge := 0;
      Dateistream.NeuePosition(Adr_merken);          // Anfangsadresse wiederherstellen
      Exit;
    END;
    IF NOT Dateistream.Lesen(Puffer[0]) THEN
    BEGIN
      Audioheader.Framelaenge := 0;
      Dateistream.NeuePosition(Adr_merken);          // Anfangsadresse wiederherstellen
//      AudiodateiEnde := 2;                           // letztes Frame ist nicht vollständig
      Exit;
    END;
    ModeErweiterung := (Puffer[0] AND $E0) SHR 5;              // acmode
    Samplerateberechnet := AC3Sampleraten[Samplerate];
    Bitrateberechnet := AC3Bitraten[Bitrate];
    Framelaenge := AC3Framelaenge[Samplerate][Bitrate] * 2;
    Framezeit := 1536000 / Samplerateberechnet;
  END;
  Dateistream.NeuePosition(Adr_merken);            // Anfangsadresse wiederherstellen
END; }

FUNCTION TAudioIndex.AC3_headerlesen(Audioheader: TAudioHeader; zumNaechstenHeader: Boolean; VAR AdrFehler: Integer): Integer;

VAR Puffer : ARRAY[0..1] OF Byte;
    Adr_merken : Int64;

BEGIN
  WITH Audioheader DO
  BEGIN
    Adr_merken := DateiStream.AktuelleAdr;
    AdrFehler := -2;
    Word(Puffer) := $0;
    WHILE (NOT Dateistream.DateiEnde) AND (NOT (Word(Puffer) = $0B77)) DO
    BEGIN
      Word(Puffer) := ((Word(Puffer) AND $FF) SHL 8);
      Dateistream.Lesen(Puffer[0]);
      Inc(AdrFehler);
    END;
    IF Dateistream.DateiEnde THEN
    BEGIN
      Framelaenge := 0;                                // Fehler im Audioheader
      IF Word(Puffer) = $0B77 THEN
      BEGIN
        Adresse := DateiStream.AktuelleAdr - 1;        // Adresse des Syncbytes
        Result := 2;                                   // letztes Frame ist nicht vollständig
      END
      ELSE
      BEGIN
        Adresse := Adr_merken;                         // Anfangsadresse ist Audiodateiende
        Result := -2;                                  // kein Syncbyte gefunden
      END;
    END
    ELSE
    BEGIN
      Adresse := DateiStream.AktuelleAdr - 2;
      IF NOT Dateistream.Vor(2) THEN                   // Prüfsumme überspringen
      BEGIN
        Framelaenge := 0;
        Result := 2;                                   // letztes Frame ist nicht vollständig
      END
      ELSE
      BEGIN
        IF NOT Dateistream.LesenX(Puffer, 2) THEN
        BEGIN
          Framelaenge := 0;
          Result := 2;                                 // letztes Frame ist nicht vollständig
        END
        ELSE
        BEGIN
          Samplerate := (Puffer[0] AND $C0) SHR 6;     // fscode
          Bitrate := Puffer[0] AND $3F;                // frmsizecode
          Mode := Puffer[1] AND $03;                   // bsmode
          IF NOT Dateistream.Lesen(Puffer[0]) THEN
          BEGIN
            Framelaenge := 0;
            Result := 2;                               // letztes Frame ist nicht vollständig
          END
          ELSE
          BEGIN
            ModeErweiterung := (Puffer[0] AND $E0) SHR 5; // acmode
            CASE ModeErweiterung OF
              0, 1 : Copyright := (Puffer[0] AND $10) = 10; // lfeon
              2    : BEGIN
                       Emphasis := (Puffer[0] AND $18) SHL 1; // dsurmod  (Bit 4, 5 von Emphasis)
                       Copyright := (Puffer[0] AND $04) = 4;  // lfeon
                     END;
              3    : BEGIN
                       Emphasis := (Puffer[0] AND $18) SHR 3; // cmixlev  (Bit 0, 1 von Emphasis)
                       Copyright := (Puffer[0] AND $04) = 4;  // lfeon
                     END;
              4, 6 : BEGIN
                       Emphasis := (Puffer[0] AND $18) SHR 1; // surmixlev (Bit 2, 3 von Emphasis)
                       Copyright := (Puffer[0] AND $04) = 4;  // lfeon
                     END;
              5, 7 : BEGIN
                       Emphasis := (Puffer[0] AND $18) SHR 3; // cmixlev  (Bit 0, 1 von Emphasis)
                       Emphasis := (Puffer[0] AND $06) SHL 1; // surmixlev (Bit 2, 3 von Emphasis)
                       Copyright := (Puffer[0] AND $01) = 1;  // lfeon
                     END;
            END;
            IF (Samplerate > 2) OR (Bitrate > 37) THEN
            BEGIN
              Framelaenge := 0;
              Result := -1;                            // Fehler im Audioheader
            END
            ELSE
            BEGIN
              Samplerateberechnet := AC3Sampleraten[Samplerate];
              Bitrateberechnet := AC3Bitraten[Bitrate];
              Framelaenge := AC3Framelaenge[Samplerate][Bitrate] * 2;
              Framezeit := 1536000 / Samplerateberechnet;
              IF Framelaenge < 8 THEN
              BEGIN
                Framelaenge := 0;
                Result := -1;                          // Fehler im Audioheader
              END
              ELSE
              BEGIN
                IF NOT Dateistream.Vor(Framelaenge - 7) THEN // Dateieinde erreicht
                  IF Dateistream.Vor(Framelaenge - 8) THEN
                    Result := 1                        // letztes Frame ist vollständig
                  ELSE
                    Result := 2                        // letztes Frame nicht vollständig
                ELSE
                  Result := 0;                         // weitere Daten vorhanden
              END;
            END;
          END;
        END;
      END;
    END;
  END;
  IF NOT zumNaechstenHeader THEN
    Dateistream.NeuePosition(Adr_merken);              // Anfangsadresse wiederherstellen
END;

{
PROCEDURE TAudioIndex.Headerlesen(Audioheader: TAudioHeaderklein);

VAR Version : Byte;
    Layer : Byte;
    Bitrate : Byte;
    Samplerate : Byte;
    Padding : Boolean;
    Samplerateberechnet : Word;
    Bitrateberechnet : Word;
    Framelaenge : Word;
    Puffer : ARRAY[0..1] OF Byte;
    Adr_merken : Int64;

BEGIN
  Adr_merken := DateiStream.AktuelleAdr;
  AudiodateiEnde := 0;
  Word(Puffer) := $0;
  WHILE (NOT Dateistream.DateiEnde) AND (NOT ((Word(Puffer) AND $FFE0) = $FFE0)) DO
  BEGIN
    Word(Puffer) := ((Word(Puffer) AND $FF) SHL 8);
    Dateistream.Lesen(Puffer[0]);
  END;
  IF Dateistream.DateiEnde THEN                              // Dateieinde erreicht
  BEGIN
    Audioheader.Adresse := Adr_merken;
//    Dateistream.NeuePosition(Adr_merken);                    // Anfangsadresse wiederherstellen
    AudiodateiEnde := 2;                                     // letztes Frame nicht vollständig
    Exit;
  END;
  Audioheader.Adresse := DateiStream.AktuelleAdr - 2;
  Version := (Puffer[0] AND $18) SHR 3;
  Layer := (Puffer[0] AND $06) SHR 1;
  IF NOT Dateistream.LesenX(Puffer, 1) THEN                  // Dateieinde erreicht
  BEGIN
    Audioheader.Adresse := Adr_merken;
//    Dateistream.NeuePosition(Adr_merken);                    // Anfangsadresse wiederherstellen
    AudiodateiEnde := 2;                                     // letztes Frame nicht vollständig
    Exit;
  END;
  Bitrate := (Puffer[0] AND $F0) SHR 4;
  Samplerate := (Puffer[0] AND $0C) SHR 2;
  Padding := (Puffer[0] AND $02) = 2;
  IF (Version > 3) OR (Version = 1) OR (Layer > 3) OR (Layer < 1) OR
     (Bitrate > 14) OR (Bitrate < 1) OR (Samplerate > 2) THEN
  BEGIN
    Framelaenge := 0;
  END
  ELSE
  BEGIN
    Samplerateberechnet := Sampleraten[Version][Samplerate];
    Bitrateberechnet := Bitraten[Version][Layer][Bitrate];
    IF Version = 3 THEN                                        // Version 1
    BEGIN
      IF Layer = 3 THEN                                        // Layer 1
        Framelaenge := Trunc(12 * Bitrateberechnet * 1000 / Samplerateberechnet + Integer(Padding)) * 4
      ELSE                                                     // Layer 2 und 3
        Framelaenge := Trunc(144 * Bitrateberechnet * 1000 / Samplerateberechnet + Integer(Padding));
    END
    ELSE
    BEGIN                                                      // Version 2 und 2,5
      IF Layer = 3 THEN                                        // Layer 1
        Framelaenge := Trunc(6 * Bitrateberechnet * 1000 / Samplerateberechnet + Integer(Padding)) * 4
      ELSE                                                     // Layer 2 und 3
        Framelaenge := Trunc(72 * Bitrateberechnet * 1000 / Samplerateberechnet + Integer(Padding));
    END;
  END;
  IF Framelaenge < 4 THEN
  BEGIN
//    Audioheader.Adresse := Adr_merken;
//    Dateistream.NeuePosition(Adr_merken);
    AudiodateiEnde := 3;                                       // Fehler im Audioheader
  END
  ELSE
  BEGIN
    IF NOT Dateistream.Vor(Framelaenge - 3) THEN               // Dateieinde erreicht
    BEGIN
      IF Dateistream.Vor(Framelaenge - 4) THEN                 // letztes Frame ist vollständig
        AudiodateiEnde := 1
      ELSE
      BEGIN
        Audioheader.Adresse := Adr_merken;
        AudiodateiEnde := 2;                                   // letztes Frame nicht vollständig
      END;
    END;
  END;
END;

PROCEDURE TAudioIndex.AC3Headerlesen(Audioheader: TAudioHeaderklein);

VAR Bitrate : Byte;
    Samplerate : Byte;
    Framelaenge : Word;
    Puffer : ARRAY[0..1] OF Byte;
    Adr_merken : Int64;

BEGIN
  AudiodateiEnde := 0;
  Word(Puffer) := $0;
  Adr_merken := DateiStream.AktuelleAdr;
  WHILE (NOT Dateistream.DateiEnde) AND (NOT (Word(Puffer) = $0B77)) DO
  BEGIN
    Word(Puffer) := ((Word(Puffer) AND $FF) SHL 8);
    Dateistream.Lesen(Puffer[0]);
  END;
  IF Dateistream.DateiEnde THEN
  BEGIN
    Audioheader.Adresse := Adr_merken;
    AudiodateiEnde := 2;                                     // letztes Frame nicht vollständig
    Exit;
  END;
  Audioheader.Adresse := DateiStream.AktuelleAdr - 2;
  Dateistream.Vor(2);                                        // Prüfsumme überspringen
  IF NOT Dateistream.LesenX(Puffer, 2) THEN
  BEGIN
    Audioheader.Adresse := Adr_merken;
    AudiodateiEnde := 2;                                     // letztes Frame nicht vollständig
    Exit;
  END;
  Samplerate := (Puffer[0] AND $C0) SHR 6;                   // fscode
  Bitrate := Puffer[0] AND $3F;                              // frmsizecode
  IF (Samplerate > 2) OR (Bitrate > 37) THEN
  BEGIN
    Framelaenge := 0;
//    Dateistream.NeuePosition(Adr_merken);                    // Anfangsadresse wiederherstellen
  END
  ELSE
    Framelaenge := AC3Framelaenge[Samplerate][Bitrate] * 2;
  IF Framelaenge < 7 THEN
  BEGIN
    Meldungsfenster('Samplerate = ' + Inttostr(Samplerate) + chr(13) +
                    'Bitrate = ' + inttostr(Bitrate) + chr(13)+
                    'Framelänge = ' + inttostr(Framelaenge) + chr(13)+
                    'Eintrittsadresse = ' + inttostr(Adr_merken) + chr(13)+
                    'Headeradresse = ' + inttostr(Audioheader.Adresse));  
//    Audioheader.Adresse := Adr_merken;
//    Dateistream.NeuePosition(Adr_merken);
    AudiodateiEnde := 3;                                       // Fehler im Audioheader
  END
  ELSE
  BEGIN
    IF NOT Dateistream.Vor(Framelaenge - 6) THEN               // Dateieinde erreicht
    BEGIN
      IF Dateistream.Vor(Framelaenge - 7) THEN                 // letztes Frame ist vollständig
        AudiodateiEnde := 1
      ELSE
      BEGIN
        Audioheader.Adresse := Adr_merken;
        AudiodateiEnde := 2;                                   // letztes Frame nicht vollständig
      END;
    END;
  END;
END;    }

FUNCTION TAudioIndex.HeaderIndexdateiSchreiben(VAR Header: TAudioheaderklein): Integer;
BEGIN
  IF Listenstream.SchreibenDirekt(Header.Adresse, 8) = 8 THEN  // 8 Byte
    Result := 0
  ELSE
    Result := -1;
END;

FUNCTION TAudioIndex.HeaderIndexdateiLesen(VAR Header: TAudioheaderklein): Integer;

VAR Puffer : ARRAY[0..7] OF Byte;

BEGIN
  Int64(Puffer) := 0;
  IF Listenstream.LesenX(Puffer, 8) THEN                       // Adresse 64 Bit
  BEGIN
    Header.Adresse := Int64(Puffer);
    IF IndexdateiVersion < 3 THEN
      IF Listenstream.Vor(8) THEN
        Result := 0
      ELSE
        Result := -2                                           // Listenstream zu kurz
    ELSE
      Result := 0;
  END
  ELSE
    Result := -1;                                              // Lesefehler Adresse
END;

FUNCTION TAudioIndex.Audiotyplesen: Byte;

VAR Puffer : ARRAY[0..1] OF Byte;

BEGIN
  Result := 0;
  Dateistream.LesenY(Puffer, 2);
  IF (Word(Puffer) AND $FFE0) = $FFE0 THEN
    Result := 2;
  IF Word(Puffer) = $0B77 THEN
    Result := 3;
  DateiStream.Zurueck(2)
END;

FUNCTION TAudioIndex.Audiotypsuchen: Byte;

VAR Puffer : ARRAY[0..1] OF Byte;
    Adresse : Int64;

BEGIN
  Result := 0;
  Word(Puffer) := $0;
  Adresse := Dateistream.AktuelleAdr;
  WHILE (NOT Dateistream.DateiEnde) AND (Result = 0) DO
  BEGIN
    Word(Puffer) := ((Word(Puffer) AND $FF) SHL 8);
    Dateistream.Lesen(Puffer[0]);
    IF (Word(Puffer) AND $FFE0) = $FFE0 THEN
      Result := 2;
    IF Word(Puffer) = $0B77 THEN
      Result := 3;
  END;
  IF (Result = 2) OR (Result = 3) THEN
    DateiStream.Zurueck(2)
  ELSE
    DateiStream.NeuePosition(Adresse);
END;


{
FUNCTION TAudioIndex.AudioDateiTypesuchen: Byte;

VAR Framezaehler : Integer;
    AudioTyp : Byte;
    Adresse,
    Adressemerken : Int64;
    Audioheader : TAudioheaderklein;
//    SchleifenAnfangsZeit, SchleifenEndeZeit : TDateTime;     // zum messen der Schleifendauer

BEGIN
//  SchleifenAnfangsZeit := Time;                              // zum messen der Schleifenzeit
  Framezaehler := 0;
  AudioTyp := 0;
  Adresse := 0;
  Result := 0;
  AudiodateiEnde := 3;                                         // für den Schleifeneintritt
  Adressemerken := Dateistream.AktuelleAdr;
  Audioheader := TAudioheaderklein.Create;
  WHILE (NOT Dateistream.DateiEnde) AND (AudiodateiEnde > 2) AND (Framezaehler < 10) DO
  BEGIN
    AudiodateiEnde := 0;
    AudioTyp := Audiotypsuchen;
    Adresse := Dateistream.AktuelleAdr;
    WHILE (NOT Dateistream.DateiEnde) AND (AudiodateiEnde = 0) AND (Framezaehler < 10) DO
    BEGIN
      CASE AudioTyp OF
        2 : Headerlesen(Audioheader);
        3 : AC3Headerlesen(Audioheader);
      END;
      IF AudiodateiEnde = 0 THEN
        IF AudioTyp = Audiotypsuchen THEN
          Inc(Framezaehler)
        ELSE
          AudiodateiEnde := 4;
      IF AudiodateiEnde > 2 THEN
      BEGIN
        DateiStream.NeuePosition(Adresse + 1);
        Framezaehler := 0;
      END;
    END;
  END;
  IF (AudiodateiEnde < 3) THEN
  BEGIN
    Result := AudioTyp;
    DateiStream.NeuePosition(Adresse); 
  END
  ELSE
  BEGIN
    CASE AudiodateiEnde OF
      3 : Result := 255;         // Fehler im Audioheader
      4 : Result := 254;         // nach dem Audioheader ist kein Syncbyte
    END;
    DateiStream.NeuePosition(Adressemerken);
  END;
  Audioheader.Free;
//  SchleifenEndeZeit := Time;                // zum messen der Schleifenzeit
//  Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, SchleifenEndeZeit)));  // ----- " ------
END;    }

FUNCTION TAudioIndex.AudioDateiTypesuchen: Byte;

VAR Framezaehler,
    Ergebnis,
    AdrFehler : Integer;
    AudioTyp : Byte;
    Adresse,
    Adressemerken : Int64;
    Audioheader : TAudioheader;
//    SchleifenAnfangsZeit : TDateTime;                     // zum messen der Schleifendauer

BEGIN
//  SchleifenAnfangsZeit := Time;                           // zum messen der Schleifenzeit
  Framezaehler := 0;
  Adresse := 0;
  Result := 0;                                              // kein Syncbyte
  Adressemerken := Dateistream.AktuelleAdr;                 // Adresse merken
  Audioheader := TAudioheader.Create;
  TRY
    WHILE (NOT Dateistream.DateiEnde) AND (Framezaehler < 10) DO
    BEGIN
      Result := 0;                                          // kein Syncbyte
      AudioTyp := Audiotypsuchen;
      IF AudioTyp = 0 THEN
      BEGIN
        Framezaehler := 10;                                 // Schleifenende
      END;
      Adresse := Dateistream.AktuelleAdr;                   // Adresse merken
      WHILE (NOT Dateistream.DateiEnde) AND (Result < 255) AND (Framezaehler < 10) DO
      BEGIN
        CASE AudioTyp OF
          2 : Ergebnis := Mpegheaderlesen(Audioheader, True, AdrFehler);
          3 : Ergebnis := AC3_headerlesen(Audioheader, True, AdrFehler);
        ELSE
          Ergebnis := -3;                                   // sicherheitshalber
        END;
        IF (Ergebnis > -1) AND
           (AdrFehler < Audioheader.Framelaenge + 10) THEN
        BEGIN
          IF Ergebnis = 0 THEN
            Inc(Framezaehler)                               // Header OK, Zähler erhöhen
          ELSE
            Framezaehler := 10;                             // Dateiende erreicht, Schleifenende
          Result := AudioTyp;
        END
        ELSE
        BEGIN                                               // Fehler im Header
          DateiStream.NeuePosition(Adresse + 1);            // weiter ab Adresse + 1
          Framezaehler := 0;
          Result := 255;
        END;
      END;
    END;
    IF Result = 0 THEN
      DateiStream.NeuePosition(Adressemerken)
    ELSE
      DateiStream.NeuePosition(Adresse);
  FINALLY
    Audioheader.Free;
  END;
//  Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, Time)));  // zum messen der Schleifenzeit
END;

FUNCTION TAudioIndex.AudioDateiTypelesen: Byte;
BEGIN
  IF FAudioDateiType = 0 THEN
    IF Assigned(Dateistream) THEN
      IF Dateistream.DateiMode = fmOpenRead THEN
        FAudioDateiType := AudioDateiTypesuchen;
  Result := FAudioDateiType;
END;

FUNCTION TAudioIndex.Dateigroesselesen: Int64;
BEGIN
  IF Assigned(Dateistream) THEN
    Result := Dateistream.Dateigroesse
  ELSE
    Result := -1;
END;

FUNCTION TAudioIndex.DateiInformationLesen(VAR AudioHeader: TAudioHeader): Integer;

VAR AdrFehler : Integer;

BEGIN
  IF Assigned(Dateistream) THEN
    IF Dateistream.DateiMode = fmOpenRead THEN
    BEGIN
      Audioheader.Framelaenge := 0;
      IF FAudioDateiType = 0 THEN
        FAudioDateiType := AudioDateiTypesuchen;
      AudioHeader.AudioTyp := FAudioDateiType;
      CASE FAudioDateiType OF
        2   : Result := Mpegheaderlesen(Audioheader, False, AdrFehler);
        3   : Result := AC3_headerlesen(Audioheader, False, AdrFehler);
      ELSE
        Result := -3;                       // falscher Audiotype
      END;
    END
    ELSE
      Result := -4                          // Dateistream nicht zum lesen geöffnet
  ELSE
    Result := -4;                           // Dateistream nicht vorhanden
END;

FUNCTION TAudioIndex.DateiBereichLesen(Adresse: Int64; VAR Laenge: Integer; Puffer: ARRAY OF Byte; Adressenichtaendern: Boolean): Integer;

VAR Adressemerken : Int64;

BEGIN
  Result := 0;
  IF Assigned(Dateistream) THEN
    IF Dateistream.DateiMode = fmOpenRead THEN
    BEGIN
      Adressemerken := Dateistream.AktuelleAdr;
      IF Adresse > -1 THEN
        IF NOT Dateistream.NeuePosition(Adresse) THEN
          Result := -2;
      IF Result = 0 THEN
        IF Dateistream.AktuelleAdr + Laenge -1 < Dateistream.Dateigroesse THEN
        BEGIN
          IF NOT Dateistream.LesenX(Puffer, Laenge) THEN
            Result := -3;
        END
        ELSE
        BEGIN
          Laenge := Dateistream.Dateigroesse - Dateistream.AktuelleAdr;
          IF  NOT Dateistream.LesenX(Puffer, Laenge) THEN
            Result := -3
          ELSE
            Result := -1;
        END;
      IF Adressenichtaendern THEN
        Dateistream.NeuePosition(Adressemerken);
    END
    ELSE
      Result := -4                          // Dateistream nicht zum lesen geöffnet
  ELSE
    Result := -4;                           // Dateistream nicht vorhanden
END;

FUNCTION TAudioIndex.Framelesen(VAR Laenge: Integer; VAR Puffer: ARRAY OF Byte; Adressenichtaendern: Boolean): Integer;

VAR Adressemerken : Int64;
    Audiotype : Byte;

BEGIN
  Result := 0;
  IF Assigned(Dateistream) THEN
    IF Dateistream.DateiMode = fmOpenRead THEN
    BEGIN
        Adressemerken := Dateistream.AktuelleAdr;
        IF FAudioDateiType = 0 THEN
          FAudioDateiType := AudioDateiTypesuchen;
        REPEAT
           Audiotype := Audiotypsuchen;
        UNTIL (Audiotype = FAudioDateiType) OR (Audiotype = 0);
        IF Audiotype = FAudioDateiType THEN
          IF Dateistream.AktuelleAdr + Laenge -1 < Dateistream.Dateigroesse THEN
          BEGIN
            IF NOT Dateistream.LesenX(Puffer, Laenge) THEN
              Result := -3;
          END
          ELSE
          BEGIN
            Laenge := Dateistream.Dateigroesse - Dateistream.AktuelleAdr;
            IF  NOT Dateistream.LesenX(Puffer, Laenge) THEN
              Result := -3
            ELSE
              Result := -1;
          END
        ELSE
          Result := -5;  
        IF Adressenichtaendern THEN
          Dateistream.NeuePosition(Adressemerken);
    END
    ELSE
      Result := -4                          // Dateistream nicht zum lesen geöffnet
  ELSE
    Result := -4;                           // Dateistream nicht vorhanden
END;




FUNCTION TAudioIndex.Indexdateipruefen: Integer;

VAR Audioheader : TAudioheaderklein;
    I : Integer;
    Framegroesse,
    Adressemerken,
    Audioheaderadressemerken : Int64;
    Puffer : ARRAY[0..3] OF Byte;

BEGIN
  IndexdateiVersion := 0;
  Result := 0;
  IF Assigned(Listenstream) THEN
    IF Listenstream.DateiMode = fmOpenRead THEN
    BEGIN
      Listenstream.NeuePosition(0);
      IF Assigned(Dateistream) THEN
        IF Dateistream.DateiMode = fmOpenRead THEN
        BEGIN
          Adressemerken := Dateistream.AktuelleAdr;
          IF Listenstream.LesenX(Puffer, 4) THEN
          BEGIN
            IF (Puffer[0] = Ord('i')) AND (Puffer[1] = Ord('d')) AND (Puffer[2] = Ord('d')) THEN
            BEGIN                                                 // ist es eine Indexdatei?
              IndexdateiVersion := Puffer[3];
              IF IndexdateiVersion > 2 THEN                       // nur neuere Indexdateien prüfen
              BEGIN
                IF IndexdateiVersion > 3 THEN
                  IF NOT Listenstream.LesenX(Puffer, 2) THEN      // Audioversatz auslesen
                    Result := -4;                                 // Lesefehler Listenstream
                IF Result > -1 THEN
                BEGIN
                  I := 0;
                  Audioheader := TAudioheaderklein.Create;
                  TRY
                    Audioheaderadressemerken := 0;
                    WHILE (I < 6) AND (NOT Listenstream.DateiEnde) AND (Result > -1) DO
                    BEGIN
                      Audioheaderadressemerken := Audioheader.Adresse;
                      Result := HeaderIndexdateiLesen(Audioheader);
                      Inc(I);                                     // fünften Syncbyteindex suchen
                    END;
                    IF Result > -1 THEN
                    BEGIN
                      IF Listenstream.DateiEnde THEN
                      BEGIN
                        Dec(I);
                        Audioheader.Adresse := Audioheaderadressemerken;
                      END;
                      IF I > 0 THEN                               // wenigstens ein Syncbyteindex gefunden
                      BEGIN
                        IF Dateistream.NeuePosition(Audioheader.Adresse) THEN // an die entsprechende Stelle springen
                          IF Audiotyplesen > 0 THEN               // Syncbyte vorhanden?
                          BEGIN
                            Listenstream.NeuePosition(Listenstream.Dateigroesse - 16);  // vorletzter Indexeintrag
                            IF HeaderIndexdateiLesen(Audioheader) = 0 THEN
                            BEGIN
                              IF Dateistream.NeuePosition(Audioheader.Adresse) THEN
                                IF Audiotyplesen > 0 THEN         // Syncbyte vorhanden?
                                BEGIN
                                  Framegroesse := Audioheader.Adresse;   // Adresse merken
                                  Listenstream.NeuePosition(Listenstream.Dateigroesse - 8); // letzter Indexeintrag
                                  IF HeaderIndexdateiLesen(Audioheader) = 0 THEN
                                  BEGIN
                                    Framegroesse := Audioheader.Adresse - Framegroesse;  // Framegröße berechnen
                                    IF (Dateistream.Dateigroesse > Audioheader.Adresse - 1) AND
                                       (Dateistream.Dateigroesse < Audioheader.Adresse + Framegroesse + 10) THEN
                                      Result := 0                 // Dateigröße Ok --> Indexdatei Ok
                                    ELSE
                                      Result := -1;               // falsche Dateigröße --> falsche Indexdatei
                                  END
                                  ELSE
                                    Result := -4;                 // Lesefehler Listenstream
                                END
                                ELSE
                                  Result := -1                    // kein Syncbyte --> falsche Indexdatei
                              ELSE
                                Result := -5;                     // Lesefehler Dateistream
                            END
                            ELSE
                              Result := -4;                       // Lesefehler Listenstream
                          END
                          ELSE
                            Result := -1                          // kein Syncbyte --> falsche Indexdatei
                        ELSE
                          Result := -5;                           // Lesefehler Dateistream
                        Dateistream.NeuePosition(Adressemerken);  // Dateistream zurückstellen
                      END
                      ELSE
                        Result := -1;                             // kein Syncbyteeintrag in der Indexdatei
                    END
                    ELSE
                      Result := -4;                               // Lesefehler Listenstream
                  FINALLY
                    Audioheader.Free;                             // Audioheader freigeben
                  END;
                END;
              END
              ELSE
                Result := -1;                                     // alte Indexdatei
            END
            ELSE
              Result := -1;                                       // keine Indexdatei ("idd" fehlt)
          END
          ELSE
            Result := -4;
          Listenstream.NeuePosition(0);
        END
        ELSE
          Result := -3                                            // Dateistream nicht zum lesen geöffnet
      ELSE
        Result := -3;                                             // kein Dateistream vorhanden
    END
    ELSE
      Result := -2                                                // Listenstream nicht zum lesen geöffnet
  ELSE
    Result := -2;                                                 // kein Listenstream vorhanden
END;

FUNCTION TAudioIndex.Indexlistenerzeugen(Liste, AudiotypeListe: TListe): Integer;

VAR Audioheader : TAudioheaderklein;
    MpegHeader : TAudioheader;
    Adressemerken : Int64;
    Ergebnis,
    AdrFehler : Integer;

FUNCTION AudiotypeListe_bearbeiten: Boolean;
BEGIN
  IF Assigned(AudiotypeListe) THEN
    IF AudiotypeListe.Count > 0 THEN
      IF NOT ((MpegHeader.Version = TAudioheader(AudiotypeListe.Items[AudiotypeListe.Count - 1]).Version) AND
              (MpegHeader.Layer = TAudioheader(AudiotypeListe.Items[AudiotypeListe.Count - 1]).Layer) AND
              (MpegHeader.Bitrate = TAudioheader(AudiotypeListe.Items[AudiotypeListe.Count - 1]).Bitrate) AND
              (MpegHeader.Samplerate = TAudioheader(AudiotypeListe.Items[AudiotypeListe.Count - 1]).Samplerate) AND
              (MpegHeader.Mode = TAudioheader(AudiotypeListe.Items[AudiotypeListe.Count - 1]).Mode) AND
              (MpegHeader.ModeErweiterung = TAudioheader(AudiotypeListe.Items[AudiotypeListe.Count - 1]).ModeErweiterung)) THEN
      BEGIN
        AudiotypeListe.Add(MpegHeader);
        Result := True;
      END
      ELSE
      BEGIN
        MpegHeader.Free;
        Result := False;
      END
    ELSE
    BEGIN
      AudiotypeListe.Add(MpegHeader);
      Result := True;
    END
  ELSE
    Result := False;    
END;

PROCEDURE Liste_bearbeiten;
BEGIN
  IF Assigned(Liste) THEN
  BEGIN
    Audioheader.Adresse := MpegHeader.Adresse;
    Liste.Add(Audioheader);
  END;
END;

BEGIN
  IF Assigned(Dateistream) THEN
    IF Dateistream.DateiMode = fmOpenRead THEN
    BEGIN
      Result := 0;
      Ergebnis := 0;
      Adressemerken := Dateistream.AktuelleAdr;
      IF Assigned(FTextanzeige) THEN
        FTextanzeige(1, FDateiname);
      IF Assigned(FFortschrittsEndwert) THEN
        FFortschrittsEndwert^ := Dateistream.Dateigroesse;
      IF FAudioDateiType = 0 THEN
        FAudioDateiType := AudioDateiTypesuchen;
      IF NOT Assigned(AudiotypeListe) THEN
        MpegHeader := TAudioheader.Create;
      TRY
        WHILE (NOT Dateistream.DateiEnde) AND
              ((Ergebnis = 0) OR (Ergebnis = -1)) DO
        BEGIN
          IF Assigned(Liste) THEN
            Audioheader := TAudioheaderklein.Create;
          IF Assigned(AudiotypeListe) THEN
            MpegHeader := TAudioheader.Create;
          CASE FAudioDateiType OF
            2 : Ergebnis := Mpegheaderlesen(MpegHeader, True, AdrFehler);
            3 : Ergebnis := AC3_headerlesen(MpegHeader, True, AdrFehler);
          ELSE
            Ergebnis := -3;
          END;
          CASE Ergebnis OF
               0 : BEGIN
                     Liste_bearbeiten;
                     AudiotypeListe_bearbeiten;
                   END;
               1 : BEGIN
                     Liste_bearbeiten;
                     AudiotypeListe_bearbeiten;
                     IF Assigned(Liste) THEN
                     BEGIN
                       Audioheader := TAudioheaderklein.Create;
                       Audioheader.Adresse := Dateistream.Dateigroesse;
                       Liste.Add(Audioheader);
                     END;
                     Result := 0;                           // ordentliches Dateiende
                   END;
           -2, 2 : BEGIN
                     Liste_bearbeiten;
                     IF  Assigned(AudiotypeListe) THEN
                       MpegHeader.Free;
                     Result := 1;                           // letztes Frame unvollständig
                   END;
              -1 : BEGIN
                     Dateistream.NeuePosition(MpegHeader.Adresse + 1);
                     IF AudiotypeListe_bearbeiten THEN
                       Liste_bearbeiten
                     ELSE
                       IF  Assigned(Liste) THEN
                         Audioheader.Free;
                   END;
              -3 : BEGIN
                     IF  Assigned(Liste) THEN
                       Audioheader.Free;
                     IF  Assigned(AudiotypeListe) THEN
                       MpegHeader.Free;
                     Result := -1;                          // falscher Audiotype
                   END;
          END;
          IF Assigned(FFortschrittsanzeige) THEN            // Fortschrittsanzeige
            IF FFortschrittsanzeige(Dateistream.AktuelleAdr) THEN
            BEGIN
              Result := -5;                                 // Abbruch durch Benutzer
              Ergebnis := -5;
            END;
        END;
        Dateistream.NeuePosition(Adressemerken);
      FINALLY
        IF  NOT Assigned(AudiotypeListe) THEN
          MpegHeader.Free;
      END;
      IF Result < 0 THEN
      BEGIN
        IF Assigned(Liste) THEN
          Liste.Loeschen;
        IF Assigned(AudiotypeListe) THEN
          AudiotypeListe.Loeschen;
      END;
    END
    ELSE
      Result := -4                          // Dateistream nicht zum lesen geöffnet
  ELSE
    Result := -4;                           // Dateistream nicht vorhanden
END;

FUNCTION TAudioIndex.Indexdateierzeugen(Liste, AudiotypeListe: TListe): Integer;

VAR Audioheader : TAudioheaderklein;
    Puffer : ARRAY[0..3] OF Byte;
    I : Integer;

BEGIN
  IF Assigned(Liste) AND Assigned(AudiotypeListe) THEN
    IF (Liste.Count > 0) OR (AudiotypeListe.Count > 0) THEN
      IF Assigned(Listenstream) THEN
        IF (Listenstream.DateiMode = fmCreate) OR (Listenstream.DateiMode = fmOpenWrite) THEN
          IF Listenstream.Dateigroesse = 0 THEN
          BEGIN
            IF Assigned(FTextanzeige) THEN
              FTextanzeige(3, FDateiname);
            IF Assigned(FFortschrittsEndwert) THEN
              FFortschrittsEndwert^ := AudiotypeListe.Count + Liste.Count;
            Puffer[0] := Ord('i');                            // Puffer mit 'idd' füllen
            Puffer[1] := Ord('d');
            Puffer[2] := Ord('d');
            Puffer[3] := 3;                                   // Version der Indexdatei
            Listenstream.SchreibenDirekt(Puffer, 4);          // Puffer an den Anfang der Datei schreiben
            Result := 0;
            LongInt(Puffer) := 0;
      //      Listenstream.SchreibenDirekt(Puffer, 2);          // Audioversatz schreiben
      {      Listenstream.SchreibenDirekt(AudiotypeListe.Count, 2); // Länge der Liste in die Datei schreiben
            I := 0;
            WHILE (I < AudiotypeListe.Count) AND (Result > -1) DO // Headerliste in die Datei schreiben
            BEGIN
              Audioheader := TAudioheaderklein(AudiotypeListe.Items[I]);
              IF HeaderIndexdateiSchreiben(Audioheader) < 0 THEN
                Result := -3;
              Inc(I);
              IF Assigned(FFortschrittsanzeige) THEN           // Fortschrittsanzeige
                IF FFortschrittsanzeige(AudiotypeListe.Count + I) THEN
                  Result := -5;                               // Abbruch durch Benutzer
            END;  }
            I := 0;
            WHILE (I < Liste.Count) AND (Result > -1) DO      // Audioliste in die Datei schreiben
            BEGIN
              Audioheader := TAudioheaderklein(Liste.Items[I]);
              IF HeaderIndexdateiSchreiben(Audioheader) < 0 THEN
                Result := -3;
              Inc(I);
              IF Assigned(FFortschrittsanzeige) THEN           // Fortschrittsanzeige
                IF FFortschrittsanzeige(AudiotypeListe.Count + I) THEN
                  Result := -5;                               // Abbruch durch Benutzer
            END;
            IF Result = -5 THEN
            BEGIN
              Listenstream.Free;                              // Listenstream freigeben
              Indexdateiloeschen;                             // Wenn eine Indexdatei  besteht löschen
            END;
          END
          ELSE
            Result := -1                                  // Listenstream ist nicht leer
        ELSE
          Result := -2                                    // Listenstream nicht zum schreiben geöffnet
      ELSE
        Result := -2                                      // kein Listenstream
    ELSE
      Result := -4                                        // beide Listen leer
  ELSE
    Result := -4;                                         // keine Listen übergeben
END;

FUNCTION TAudioIndex.Indexdateilesen(Liste, AudiotypeListe: TListe; VAR Audioversatz: Integer): Integer;

VAR Audioheader : TAudioheaderklein;
    Mpegheader : TAudioheader;
    Puffer : ARRAY[0..3] OF Byte;
    I : Integer;

BEGIN
  Audioversatz := 0;
  IF Assigned(Liste) AND Assigned(AudiotypeListe) THEN
  BEGIN
    IF Assigned(Listenstream) THEN
      IF Listenstream.DateiMode = fmOpenRead THEN
        IF Listenstream.Dateigroesse > 10 THEN
        BEGIN
          Liste.Loeschen;                              // Liste löschen
          AudiotypeListe.Loeschen;                     // Liste löschen
          IF Assigned(FTextanzeige) THEN
            FTextanzeige(2, FDateiname);
          IF Assigned(FFortschrittsEndwert) THEN
            FFortschrittsEndwert^ := Listenstream.Dateigroesse;
          Listenstream.NeuePosition(0);
          IF Listenstream.LesenX(Puffer, 4) THEN
            IF (Puffer[0] = Ord('i')) AND (Puffer[1] = Ord('d')) AND (Puffer[2] = Ord('d')) THEN
            BEGIN                                        // die Indexliste muß mit "idd" beginnen
              Result := 0;
              IndexdateiVersion := Puffer[3];
              IF IndexdateiVersion > 3 THEN
              BEGIN
                IF Listenstream.LesenX(Puffer, 2) THEN   // Audioversatz lesen
                  Audioversatz := Integer(Puffer)
                ELSE
                  Result := -3;
              END;
              IF (IndexdateiVersion > 4) AND (Result > -1) THEN
              BEGIN
                IF Listenstream.LesenX(Puffer, 2) THEN   // AudiotypeListe auslesen
                BEGIN
                  I := Integer(Puffer);
                  WHILE (NOT Listenstream.DateiEnde) AND (I > 0) AND (Result > -1) DO
                  BEGIN
                    Mpegheader := TAudioheader.Create;
                    HeaderIndexdateiLesen(TAudioheaderklein(Mpegheader));
                    AudiotypeListe.Add(Mpegheader);
                    Dec(I);
                    IF Assigned(FFortschrittsanzeige) THEN  // Fortschrittsanzeige
                      IF FFortschrittsanzeige(Listenstream.AktuelleAdr) THEN
                        Result := -5;                    // Abbruch durch Benutzer
                  END;
                END
                ELSE
                  Result := -3;
              END;
              IF Result > -1 THEN
                IF NOT Listenstream.DateiEnde THEN
                BEGIN
                  WHILE (NOT Listenstream.DateiEnde) AND (Result > -1) DO
                  BEGIN
                    Audioheader := TAudioheaderklein.Create;
                    HeaderIndexdateiLesen(Audioheader);
                    IF Listenstream.DateiEnde AND (Audioheader.Adresse = 0) THEN
                      Audioheader.Free
                    ELSE
                      Liste.Add(Audioheader);
                    IF Assigned(FFortschrittsanzeige) THEN  // Fortschrittsanzeige
                      IF FFortschrittsanzeige(Listenstream.AktuelleAdr) THEN
                        Result := -5;                      // Abbruch durch Benutzer
                  END;
                END
                ELSE
                  Result := -1;                            // Indexdatei zu kurz
            END
            ELSE
              Result := -2                               // Indexdateikennung "idd" fehlt
          ELSE
            Result := -3;                              // Lesefehler
          Listenstream.NeuePosition(0);
        END
        ELSE
          Result := -1                                 // Indexdatei kleiner 10 Byte, zu kurz
      ELSE
        Result := -4                                   // Listenstream nicht zum lesen geöffnet
    ELSE
      Result := -4;                                    // kein Listenstream vorhanden
    IF Result < 0 THEN
    BEGIN
      Liste.Loeschen;                                  // Liste löschen
      AudiotypeListe.Loeschen;                         // Liste löschen
    END;
  END
  ELSE
    Result := -6;                                      // keine Listen übergeben
END;


FUNCTION TAudioIndex.IndexDateischreiben: Integer;

VAR Audioversatz : Integer;

BEGIN
  Result := Listeerzeugen(NIL, NIL, Audioversatz);
END;

FUNCTION TAudioIndex.Listeerzeugen(Liste, AudiotypeListe: TListe; VAR Audioversatz: Integer): Integer;

VAR Ergebnis : Integer;
    Listeloeschen,
    AudiotypeListeloeschen : Boolean;
//    SchleifenAnfangsZeit : TDateTime;                // zum messen der Schleifendauer

BEGIN
//  SchleifenAnfangsZeit := Time;                      // zum messen der Schleifenzeit
  Result := -10;
  IF NOT Assigned(Liste) THEN                          // keine Liste vorhanden
  BEGIN
    Listeloeschen := True;                             // merken das Liste erzeugt wurde
    Liste := TListe.Create;                            // Liste erzeugen
  END
  ELSE
    Listeloeschen := False;
  IF NOT Assigned(AudiotypeListe) THEN                 // keine AudiotypeListe vorhanden
  BEGIN
    AudiotypeListeloeschen := True;                    // merken das AudiotypeListe erzeugt wurde
    AudiotypeListe := TListe.Create;                   // AudiotypeListe erzeugen
  END
  ELSE
    AudiotypeListeloeschen := False;
  TRY
    IF FDateiname <> '' THEN                            // Dateiname muß existieren
    BEGIN
      Ergebnis := DateiOeffnen(FDateiname);
      IF Ergebnis > -1 THEN                            // Datei geöffnet
      BEGIN
        Ergebnis := IndexdateiOeffnen;
        IF Ergebnis > -1 THEN                          // Indexdatei geöffnet
        BEGIN
          IF Ergebnis = 0 THEN                         // Indexdatei zum lesen geöffnet
          BEGIN
            Ergebnis := Indexdateipruefen;
            IF Ergebnis = 0 THEN                       // Indexdatei gehört zur Datei
            BEGIN
              Ergebnis := Indexdateilesen(Liste, AudiotypeListe, Audioversatz);
              IF Ergebnis = 0 THEN
                Result := 0                            // Indexdatei gelesen
              ELSE
                IF (Ergebnis < 0) AND (Ergebnis > -4) THEN
                  Ergebnis := -1                       // Fehler beim lesen der Indexdatei, Neue erzeugen
                ELSE
                  CASE Ergebnis OF
                    -4 : Result := -4;                 // Fehler beim lesen der Indexdatei
                    -5 : Result := -9;                 // Abbruch durch Benutzer
                    -6 : Result := -10;                // allgemeiner Fehler
                  END;
            END
            ELSE
            BEGIN
              CASE Ergebnis OF
                -2 : Result := -3;                     // Indexdatei läßt sich nicht öffnen
                -3 : Result := -1;                     // Datei läßt sich nicht öffnen
                -4 : Result := -4;                     // Indexdatei läßt sich nicht lesen
                -5 : Result := -2;                     // Datei läßt sich nicht lesen
              END;
            END;
            IF Ergebnis = -1 THEN
            BEGIN
              Indexdateischliessen;
              Ergebnis := IndexdateiNeu;
              IF Ergebnis = 0 THEN                     // neue Indexdatei erstellt
                Ergebnis := 1                          // Liste erzeugen
              ELSE
                Result := -5;                          // Indexdatei läßt sich nicht erzeugen
            END;
          END;
          IF Ergebnis = 1 THEN
          BEGIN
            Ergebnis := Indexlistenerzeugen(Liste, AudiotypeListe);
            IF Ergebnis > -1 THEN
            BEGIN                                      // Listen erzeugt
              Ergebnis := Indexdateierzeugen(Liste, AudiotypeListe);
              IF Ergebnis < 0 THEN
                CASE Ergebnis OF
                  -1 : Result := -6;                   // Indexdatei läßt sich nicht schreiben
                  -2 : Result := -4;                   // Indexdatei läßt sich nicht lesen
                  -3 : Result := -4;                   // Indexdatei läßt sich nicht lesen
                  -4 : Result := -3;                   // Indexdatei läßt sich nicht öffnen
                  -5 : Result := -9;                   // Abbruch durch Benutzer
                END
              ELSE
                Result := 1;                           // Liste geschrieben
            END
            ELSE
              CASE Ergebnis OF
                -1 : Result := -7;                     // Indexliste läßt sich nicht erzeugen
                -4 : Result := -10;                    // Dateistream nicht zum lesen geöffnet
                -5 : Result := -9;                     // Abbruch durch Benutzer
              END;
          END;
        END
        ELSE
          CASE Ergebnis OF
            -1 : Result := -3;                         // Indexdatei läßt sich nicht öffnen/erzeugen
            -2 : Result := -5;                         // kein Dateiname vorhanden
          END;
      END
      ELSE
        Result := -1;                                  // Datei läßt sich nicht öffnen
    END
    ELSE
      Result := -8;                                    // kein Dateiname vorhanden
  FINALLY
    IF Listeloeschen THEN                              // wenn nötig Listen löschen und freigeben
    BEGIN
      Liste.Loeschen;
      Liste.Free;
    END;
    IF AudiotypeListeloeschen THEN
    BEGIN
      AudiotypeListe.Loeschen;
      AudiotypeListe.Free;
    END;
  END;
//  Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, Time)));  // zum anzeigen der Schleifendauer
END;
     
end.
 