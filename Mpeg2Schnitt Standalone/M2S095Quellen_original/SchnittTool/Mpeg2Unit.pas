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

--------------------------------------------------------------------------------------

 Aufbau der Indexdatei Video:

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

 Aufbau der Indexdatei Audio (für alle Audiotypen):

   3 Byte Zeichenkette 'idd'     (Indexdatei)
   1 Byte Versionsnummer
   Wiederholen bis Dateiende
     8 Byte (Int64) Adresse des Headers in der Datei (inclusive SyncBytes)
            ---pro Audioframe eine Adresse---
   Wiederholen Ende
   8 Byte Adresse nach dem letzten Byte des letzten Audioframes (meist Dateigröße)
   

Aufbau der Mpeg2 Header:  (diese kamen in von mir getesteten Mpeg2 Dateien (DVB) vor)

Sequenzheader: 00 00 01 B3      (mindestens 8 Byte + 64 Byte + 64 Byte)

    12 Bit Bildbreite (von 14 Bit)
    12 Bit Bildhöhe (von 14 Bit)
     4 Bit Seitenverhältnis (0001 = 1,0; 0010 = 3/4; 0011 = 9/16; 0100 = 1/2,21)
     4 Bit Framerate (0010 = 24; 0011 = 25; 0101 = 30 Bilder/sek.)
    18 Bit Bitrate (* 400 ms) (von 30 Bit)
     1 Bit Marker (= 1)
    10 Bit VBV Puffer (B = 16 * 1024 * VBV Puffer) (von 18 Bit)
     1 Bit Flag (= 0)
     1 Bit Lade Intra Quantiser Matrix
           [8*8 Byte]
     1 Bit Lade Nonintra Quantiser Matrix
           [8*8 Byte]

Bildergruppenheader: 00 00 01 B8    (4 Byte)

    25 Bit Timecode (1 Bit - Dropframe Flag - 1 wenn Framerate ungerade z.B. 29,97
                     5 Bit - Stunde
                     6 Bit - Minute
                     1 Bit - Marker
                     6 Bit - Sekunde
                     6 Bit - Bild)
     1 Bit Closed Group
     1 Bit Broken Link

Bildheader: 00 00 01 00      (mindestes 4 Byte)

    10 Bit Temporal Reference
     3 Bit Bildtype (001 = I; 010 = P; 011 = B)
    16 Bit VBV Delay
     wenn Bildtype = 2 oder 3
       1 Bit Full pel forward Vector (nicht benutzt = 0)
       3 Bit Forward f Code (nicht benutzt = 111)
     wenn Bildtype = 3
       1 Bit Full pel backward Vector (nicht benutzt = 0)
       3 Bit Backward f Code (nicht benutzt = 111)
     1 Bit Extra Bit Picture (1 wenn Informationen folgen)
       8 Bit Extra Information Picture (nicht benutzt)
           Wiederholung bis Extra Bit Picture = 0

Extensionheader: 00 00 01 B5

     4 Bit ExtensionID (0001)    (Sequenzheaderextension)       (6 Byte mit ExtensionID)
     8 Bit Profile und Level Indication
     1 Bit Progressive Sequence (1 = nur progressive Bilder)
     2 Bit Chroma Format (01 = 4:2:0; 10 = 4:2:2; 11 = 4:4:4)
     2 Bit Bildbreite Extension
     2 Bit Bildhöhe Extension       
    12 Bit Bitrate Extension
     1 Bit Marker
     8 Bit VBV Puffer Extension
     1 Bit low delay Flag
     2 Bit Framerate Extension n (zum Berechnen der Framerate)
     5 Bit Framerate Extension d (zum Berechnen der Framerate)
           Framerate = Frameratewert * (n + 1) ÷ (d + 1)

     4 Bit ExtensionID (0010)    (Sequenzdisplayextension)      (mindestens 5 Byte mit ExtensionID)
     3 Bit Videoformat
     1 Bit Color Description  (wenn 1 dann folgende Bits)
       (8 Bit Colour Primaries
        8 Bit Transfer Characteristics
        8 Bit Matrix Coefficients )
    14 Bit Display horizontal Size
     1 Bit Marker
    14 Bit Display vertical Size

     4 Bit ExtensionID (1000)    (Picture coding extension)     (mindestens 5 Byte mit ExtensionID)
     4 Bit f Code 00 vorwärts/horizontal
     4 Bit f Code 01 vorwärts/vertikal
     4 Bit f Code 10 rückwärts/horizontal
     4 Bit f Code 11 rückwärts/vertikal
     2 Bit Intra DC Precision
     2 Bit Bild Structur
     1 Bit Oberstes Feld zuerst
     1 Bit frame_pred_frame_dct
     1 Bit concealment_motion_vectors
     1 Bit q_scale_type
     1 Bit intra_vlc_format
     1 Bit alternate_scan
     1 Bit repeat_first_field
     1 Bit chroma_420_type
     1 Bit progressive_frame
     1 Bit composite_display_flag (wenn 1 dann folgende Bits)
       (1 Bit v_axis
        3 Bit field_sequence
        1 Bit sub_carrier
        7 Bit burst_amplitude
        8 Bit sub_carrier_phase )

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

----------------------------------------------------------------------------------------------}

unit Mpeg2Unit;

interface
uses
{$ifdef LINUX}
  QDialogs,                 // Showmessage

{$endif}
{$ifdef MSWINDOWS}
  Dialogs,                  // Showmessage

{$endif}
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
  DatenTypen;               // für verwendete Datentypen

type
{  TListe = CLASS(TList)     // TList gibt den Speicher seiner Objecte nicht richtig frei
    PROCEDURE Loeschen;     // gibt den Speicher aller Einträge frei und leert die Liste
    PROCEDURE LoeschenX(Nr: Integer);  // gibt den Speicher des Eintrages X frei und entfernt ihn aus der Liste
    DESTRUCTOR Destroy; OVERRIDE;
  END;  }

  TTimecode = RECORD
    Ungerade : Boolean;
    Stunde : Byte;
    Minute : Byte;
    Marker : Boolean;
    Sekunde : Byte;
    Bilder : Byte;
  END;

  TSequenzHeader = CLASS
    Adresse : Int64;
    BildBreite : Word;
    BildHoehe : Word;
    Seitenverhaeltnis : Byte;
    Framerate : Byte;
    Bitrate : LongWord;
    VBVPuffer : Word;
    ProfilLevel : Byte;
    Progressive : Boolean;
    ChromaFormat : Byte;
    LowDelay : Boolean;
  END;

  TBildgruppenHeader = CLASS
    Adresse : Int64;
    Timecode : TTimecode;
    GeschlosseneGr : Boolean;
    Geschnitten : Boolean;
  END;

  TBildHeader = CLASS
    Adresse : Int64;
    TempRefer : Word;
    BildTyp : Byte;
    VBVDelay : Word;
    FCode0 : Byte;
    FCode1 : Byte;
    FCode2 : Byte;
    FCode3 : Byte;
    IntraDCPre : Byte;
    BildStruktur : Byte;
    OberstesFeldzuerst : Boolean;
    frame_pred_frame_dct : Boolean;
    concealment_motion_vectors : Boolean;
    q_scale_type : Boolean;
    intra_vlc_format : Boolean;
    alternate_scan : Boolean;
    repeat_first_field : Boolean;
    chroma_420_type : Boolean;
    progressive_frame : Boolean;
    composite_display_flag : Boolean;
    v_axis : Boolean;
    field_sequence : Byte;
    sub_carrier : Boolean;
    burst_amplitude : Byte;
    sub_carrier_phase : Byte;
  END;

  THeaderklein = CLASS
    HeaderTyp : Byte;
    Adresse : Int64;
    TempRefer : Word;
    BildTyp : Byte;
  END;

  TBildIndex = CLASS
    BildNr : LongWord;
    BildIndex: LongWord;
    BildTyp : Byte;
  END;

{  TSchnittpunkt = CLASS
    VideoName : STRING;
    AudioName : STRING;
    Videoknoten : TTreeNode;
    Audioknoten : TTreeNode;
    Anfang : LongInt;
    Anfangberechnen : Byte;   //  Bit 0 = 0 : Bit 1 ungültig
                              //  Bit 0 = 1 : Bit 1 gültig
                              //  Bit 1 = 0 : Schnittpunktanfang ist ein I-Frame
                              //  Bit 1 = 1 : Schnittpunktanfang ist kein I-Frame
                              //  Bit 2 = 0 : Schnittpunktanfang passt nicht zum vorherigen Schnittpunkt
                              //  Bit 2 = 1 : Schnittpunktanfang passt zum vorherigen Schnittpunkt
                              //  Bit 7 = 0 : Schnittpunktanfang beim Schnitt eventuell framgenau berechnen
                              //  Bit 7 = 1 : Schnittpunktanfang beim Schnitt nicht framegenau berechnen sondern eventuell gültiges Bild suchen
    Ende : LongInt;
    Endeberechnen : Byte;     // wie Anfangberechnen
    VideoGroesse : Int64;
    AudioGroesse : Int64;
    Framerate : Real;
    Audiooffset : Integer;
    VideoListe,
    VideoIndexListe,
    AudioListe : TListe;
    VideoEffekt : TEffektEintrag;
    AudioEffekt : TEffektEintrag;
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
  END;   }

  TAudioHeader = CLASS
    Audiotyp : Byte;
    Adresse : Int64;
    Version : Byte;
    Layer : Byte;
    Protection : Boolean;
    Bitrate : Byte;
    Samplerate : Byte;
    Padding : Boolean;
    Privat : Boolean;
    Mode : Byte;
    ModeErweiterung : Byte;
    Copyright : Boolean;
    Orginal : Boolean;
    Emphasis : Byte;
    Samplerateberechnet : Word;
    Bitrateberechnet : Word;
    Framelaenge : Word;
    Framezeit : Real;
  END;

 { TAC3Header = CLASS
    Audiotyp : Byte;
    Adresse : Int64;
    --- : Byte;
    --- : Byte;
    --- : Boolean;
    Bitrate : Byte;
    Samplerate : Byte;
    --- : Boolean;
    --- : Boolean;
    bsMode : Byte;
    acMode : Byte;
    Lfeon : Boolean;
    --- : Boolean;
    MixLevel : Byte;  (Bit 0, 1 cmixlev, Bit 2, 3 surmixlev; Bit 4, 5 dsurmod)
    Samplerateberechnet : Word;
    Bitrateberechnet : Word;
    Framelaenge : Word;
    Framezeit : Real;
  END; }

  TAudioHeaderklein = CLASS
    Adresse : Int64;
  END;

  TFortschrittsanzeige = FUNCTION(Fortschritt: Int64): Boolean OF OBJECT;
  TTextanzeige = FUNCTION(Meldung: Integer; Text: STRING): Boolean OF OBJECT;

  TMpeg2Header = CLASS
    DateiStream : TDateiPuffer;
    Listenstream : TDateiPuffer;
    IndexdateiVersion : Integer;
    Dateiname : STRING;
    Listenname : STRING;
    PufferGr : LongWord;
 //   Listenaddr : TList;                // ---1---
 //   IndexListenaddr : TList;
    FortschrittsEndwert : PInt64;
    Fortschrittsanzeige : TFortschrittsanzeige;
    Textanzeige : TTextanzeige;
    Anhalten : Boolean;
    SequenzEndeIgnorieren : Boolean;
    CONSTRUCTOR Create;
    PROCEDURE Free;
    FUNCTION DateiOeffnen(Name: STRING): Boolean;
    PROCEDURE PufferGroesse(Puffer: LongInt);
    PROCEDURE NaechsterStartCode;
    PROCEDURE SequenzHeaderlesen(VAR SequenzHeader: TSequenzHeader);
    PROCEDURE BildgruppenHeaderlesen(VAR GruppenHeader: TBildgruppenHeader);
    PROCEDURE Bildheaderlesen(VAR BildHeader: TBildHeader);
    PROCEDURE HeaderIndexdateiLesen(VAR Header: THeaderklein);
    PROCEDURE HeaderIndexdateiSchreiben(VAR Header: THeaderklein);
    PROCEDURE HeaderLesen(VAR Header: THeaderklein);
    PROCEDURE DateiInformationLesen(VAR SequenzHeader: TSequenzHeader; VAR BildHeader: TBildHeader);
    FUNCTION Listenstreampruefen: Boolean;
    FUNCTION IndexDateischreiben: Boolean;
    FUNCTION Indexlisteerstellen(Liste, IndexListe: TListe): Boolean;
    FUNCTION Listeerzeugen(VAR Liste, IndexListe: TListe): Boolean;

  END;

{  TVideoschnitt = CLASS
    AdressDiff : Int64;
    BildZaehler : LongInt;
    BildDiff : Word;
    Dateiname : STRING;
    Zieldateiname : STRING;
//    Dateistream : TFilestream;
//    Speicherstream : TFilestream;
    Dateistream : TDateipuffer;
    Speicherstream : TDateipuffer;
    Liste,
    IndexListe,
    VideoListe,
    VideoIndexListe,
    NeueListe : TListe;
    FortschrittsEndwert : PInt64;
    FortschrittsPosition : Int64;
    Fortschrittsanzeige : TFortschrittsanzeige;
    Textanzeige : TTextanzeige;
    Anhalten : Boolean;
    Timecode_korrigieren,
    Bitrate_korrigieren : Boolean;
    festeBitrate : LongWord;
    IndexDatei_erstellen : Boolean;
    TextString : STRING;
    SequenzHeader: TSequenzHeader;
    BildHeader: TBildHeader;
    ersterSequenzHeader : Boolean;
    erstesBild : Boolean;
    Framegenau_schneiden : Boolean;
    D2VDatei_erstellen : Boolean;
    CONSTRUCTOR Create;
    PROCEDURE Free;
    PROCEDURE IndexDateispeichern(Name: STRING; Liste : TListe);
    PROCEDURE D2VDateispeichern(Name: STRING; Liste : TListe);
    PROCEDURE Zieldateioeffnen(ZielDatei: STRING);
    PROCEDURE Quelldateioeffnen(SchnittPunkt: TSchnittPunkt);
    PROCEDURE Zieldateischliessen;
    PROCEDURE Quelldateischliessen;
//    FUNCTION Videoteil_berechnen(Anfang, Ende: LongInt; Schnittpunkt: TSchnittpunkt): Integer;
    FUNCTION Schneiden(SchnittListe: TStrings): Integer;
    FUNCTION Effektberechnen(AnfangsIndex, EndIndex: Int64; EffektParameter: STRING; EffektLaenge: Integer; EffektDaten: TAusgabeDaten; Audioheader: TAudioHeader): Integer;
    FUNCTION KopiereVideoteil(AnfangsIndex, EndIndex: Int64): Integer;
    PROCEDURE KopiereSegment(geaendert: Boolean; AnfangsIndex, EndIndex: LongWord; Framerate: Real; anzeigen: Boolean);
    PROCEDURE SequenzEndeanhaengen;
  END;     }

  TMpegAudio = CLASS(TObject)
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

{  TAudioschnitt = CLASS
    Dateiname : STRING;
    Zieldateiname : STRING;
    Zwischenverzeichnis : STRING;
    Dateistream : TDateipuffer;
    Speicherstream : TDateipuffer;
    Liste,
    AudioListe,
    NeueListe : TListe;
    FortschrittsEndwert : PInt64;
    FortschrittsPosition : Int64;
    Fortschrittsanzeige : TFortschrittsanzeige;
    Textanzeige : TTextanzeige;
    Anhalten : Boolean;
    IndexDatei_erstellen : Boolean;
    TextString,
    Fehlertext : STRING;
    Audioheader : TAudioheader;
    Versatz : Integer;
    leereAudioframesMpeg : TStrings;
    leereAudioframesAC3 : TStrings;
    leereAudioframesPCM : TStrings;
    AudioEffekte : TStrings;
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
    PROCEDURE IndexDateispeichern(Name: STRING; Liste : TListe);
    PROCEDURE Zieldateioeffnen(ZielDatei: STRING);
    FUNCTION Quelldateierzeugen(Dateiname: STRING): Integer;
    FUNCTION Audioheaderlesen(Dateiname: STRING; Position: Int64; Audioheader: TAudioheader): Integer;
    PROCEDURE Quelldateioeffnen(SchnittPunkt: TSchnittPunkt);
    PROCEDURE Quelldateifreigeben;
    PROCEDURE Quelldateischliessen;
    PROCEDURE Zieldateischliessen;
    FUNCTION Schneiden(SchnittListe: TStrings): Integer;
    PROCEDURE KopiereSegment(AnfangsIndex, EndIndex: Int64);
    FUNCTION Indexlistefuellen(AnfangsAdr, EndAdr: Int64; Audioheader: TAudioheader): Integer;
    FUNCTION KopiereSegmentDatei(AnfangsAdr, EndAdr: Int64; QuellDateistream, ZielDateistream: TDateiPuffer): Integer;
    PROCEDURE NullAudio_einfuegen(AnfangsIndex, EndIndex: Int64; AudioHeader: TAudioHeader);
    FUNCTION Effektberechnen(AnfangsIndex, EndIndex: Int64; EffektParameter: STRING; EffektLaenge: Integer; EffektDaten: TAusgabeDaten; Audioheader: TAudioHeader): Integer;
    PROCEDURE EffektberechnenAnfang(AnfangsIndex, EndIndex: Int64; EffektEintrag: TEffektEintrag; Audioheader: TAudioHeader);
    PROCEDURE EffektberechnenEnde(AnfangsIndex, EndIndex: Int64; EffektEintrag: TEffektEintrag; Audioheader: TAudioHeader);
  END;      }

  TStartCodes = SET OF Byte;

CONST
  BildStartCode     = $00;
  SequenceStartCode = $B3;
  ErweiterterCode   = $B5;
  SequenceEndeCode  = $B7;
  GruppenStartCode  = $B8;
  AudioCode         = $A0;               // von mir festgelegt - falls Audio in die Liste soll

  StartCodes: TStartCodes = [$00, $B3, $B7, $B8];

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

VAR Videoschnittanhalten : Boolean = False;

FUNCTION NaechstesBild(Bild: Byte; Position: LongInt; IndexListe: TListe): LongInt;
FUNCTION VorherigesBild(Bild: Byte; Position: LongInt; IndexListe: TListe): LongInt;
FUNCTION Bildsuchen(Bild: Byte; Position: LongInt; IndexListe: TListe): LongInt;
FUNCTION Schnittberechnung(Liste, IndexListe: TListe; PosIn, PosOut: LongInt; VAR PosIn1, PosOut1, PosIn2, PosOut2: LongInt; VAR Temprefaendern: Boolean): Integer;

implementation

FUNCTION IndexListeSortieren(Item1, Item2: Pointer): Integer;
BEGIN
  Result := 0;
  IF TBildIndex(Item1).BildNr < TBildIndex(Item2).BildNr THEN
    Result := -1;
  IF TBildIndex(Item1).BildNr = TBildIndex(Item2).BildNr THEN
    Result := 0;
  IF TBildIndex(Item1).BildNr > TBildIndex(Item2).BildNr THEN
    Result := 1;
END;

{CONSTRUCTOR TSchnittpunkt.Create;
BEGIN
  INHERITED Create;
  Anfang := -1;
  Anfangberechnen := 0;
  Ende := -1;
  Endeberechnen := 0;
  VideoListe := NIL;
  VideoIndexListe := NIL;
  AudioListe := NIL;
  VideoEffekt := TEffektEintrag.Create;
  AudioEffekt := TEffektEintrag.Create;
END;

DESTRUCTOR TSchnittpunkt.Destroy;
BEGIN
  VideoEffekt.Free;
  AudioEffekt.Free;
  INHERITED Destroy;
END;        }

// ---------------------------- Allgemeine Funktionen ----------------------------------------

FUNCTION NaechstesBild(Bild: Byte; Position: LongInt; IndexListe: TListe): LongInt;

VAR Eintrag : TBildIndex;

BEGIN
  IF (Position < IndexListe.Count)  AND (IndexListe.Count > 0) THEN
  BEGIN
    IF Position < 0 THEN                
      Position := 0;
    Eintrag := IndexListe.Items[Position];
    WHILE (Position < IndexListe.Count - 1) AND (Eintrag.BildTyp > Bild) DO
    BEGIN
      Inc(Position);
      Eintrag := IndexListe.Items[Position];
    END;
    IF Eintrag.BildTyp > Bild THEN
      Result := -1
    ELSE
      Result := Position;
  END
  ELSE
    Result := -1;
END;

FUNCTION VorherigesBild(Bild: Byte; Position: LongInt; IndexListe: TListe): LongInt;

VAR Eintrag : TBildIndex;

BEGIN
  IF (Position > -1) AND (IndexListe.Count > 0) THEN
  BEGIN
    IF Position > IndexListe.Count - 1 THEN
      Position := IndexListe.Count - 1;
    Eintrag := IndexListe.Items[Position];
    WHILE (Position > 0) AND (Eintrag.BildTyp > Bild) DO
    BEGIN
      Dec(Position);
      Eintrag := IndexListe.Items[Position];
    END;
    IF Eintrag.BildTyp > Bild THEN
      Result := -1
    ELSE
      Result := Position;
  END
  ELSE
    Result := -1;
END;


FUNCTION Bildsuchen(Bild: Byte; Position: LongInt; IndexListe: TListe): LongInt;

VAR SchnittpunktVor,
    SchnittpunktRueck : LongInt;

BEGIN
  IF LongInt(Position) > IndexListe.Count - 1 THEN
    LongInt(Position) := IndexListe.Count - 1;
  SchnittpunktVor := NaechstesBild(Bild, Position, IndexListe);
  SchnittpunktRueck := VorherigesBild(Bild, Position, IndexListe);
  IF SchnittpunktVor < 0 THEN
    IF SchnittpunktRueck < 0 THEN
      Result := Position
    ELSE
      Result := SchnittpunktRueck
  ELSE
    IF SchnittpunktRueck < 0 THEN
      Result := SchnittpunktVor
    ELSE
      IF Position - SchnittpunktRueck < SchnittpunktVor - Position THEN
        Result := SchnittpunktRueck
      ELSE
        Result := SchnittpunktVor;
END;

FUNCTION Schnittberechnung(Liste, IndexListe: TListe; PosIn, PosOut: LongInt; VAR PosIn1, PosOut1, PosIn2, PosOut2: LongInt; VAR Temprefaendern: Boolean): Integer;

VAR I : Word;
    BildIndex : TBildIndex;
    Listenpunkt : THeaderklein;
    BildNr, BildNr2 : Word;

BEGIN
  Result := 0;
  PosIn1 := -1;
  PosOut1 := -1;
  PosIn2 := -1;
  PosOut2 := -1;
  BildIndex := IndexListe[PosIn];
  IF BildIndex.BildTyp = 1 THEN                                      // der Schnitt muß an einem I-Frame beginnen
  BEGIN
    Listenpunkt := Liste[BildIndex.BildIndex - 2];                   // SequenceStartCode
    IF Listenpunkt.HeaderTyp = SequenceStartCode THEN
    BEGIN
      PosIn1 := BildIndex.BildIndex - 2;
      Listenpunkt := Liste[BildIndex.BildIndex];
      IF Listenpunkt.HeaderTyp = BildStartCode THEN
      BEGIN
        BildNr := Listenpunkt.TempRefer;                             // TempReferenz > 0 --> offene Gruppe
        IF BildNr > 0 THEN                                           // Die nächsten Bilder (B-Frames)
        BEGIN                                                        // müssen entfernt werden.
          Listenpunkt := Liste[BildIndex.BildIndex + 1];             // Die Tempreferenze müssen in dieser Gruppe
          IF Listenpunkt.HeaderTyp = BildStartCode THEN              // neu geschrieben werden.
          BEGIN
            PosOut1 := BildIndex.BildIndex;
            Temprefaendern := True;
          END
          ELSE
          BEGIN
            Result := -6;                                            // Ist die TempReferenz > 0 muß nach einem I-Frame mindestens ein Bild kommen
            Exit;
          END;
          Listenpunkt := Liste[BildIndex.BildIndex + BildNr + 1];    // "herrenlose" B-Frames überspringen
          IF Listenpunkt.HeaderTyp = BildStartCode THEN
          BEGIN
            PosIn2 := BildIndex.BildIndex + BildNr + 1;
          END
          ELSE
          BEGIN
            Result := -5;                                            // nach den "herrenlosen" B-Frames sollte eigentlich ein P-Frame stehen
            Exit;
          END;
        END;
        BildIndex := IndexListe[PosOut];
        Listenpunkt := Liste[BildIndex.BildIndex];
        IF (Listenpunkt.HeaderTyp = BildStartCode) AND (BildIndex.BildTyp < 3) THEN
        BEGIN
          BildNr := Listenpunkt.TempRefer;                          // TempReferenz des letzten I- oder P-Frames
          I := 1;
          REPEAT                                                    // da die Bilder nicht in der angezeigten Reihenfolge gespeichert sind
            Listenpunkt := Liste[BildIndex.BildIndex + I];          // muß des letzte B-Frame mit kleinerer TempReferenz gesucht werden
            IF Listenpunkt.HeaderTyp = BildStartCode THEN
              BildNr2 := Listenpunkt.TempRefer
            ELSE
              BildNr2 := BildNr + 1;                                 // Sicherer Schleifenabbruch am GOPEnde
            Inc(I);
          UNTIL (BildNr < BildNr2) OR (BildIndex.BildIndex + I >= LongWord(Liste.Count)); // die TempReferenz ist großer als als die TempReferenz des letztes P- oder I-Frames
          PosOut2 := BildIndex.BildIndex + I - 2;                                         // oder das Ende der GOP ist erreicht
        END
        ELSE
          Result := -4;                                             // am Ende des Schnittes muß ein Bildheader stehen
      END
      ELSE
        Result := -3;                                               // der Schnitt muß mit einem Bildheader mit I-Frame beginnen
    END
    ELSE
      Result := -2;                                                 // 2 Header vorm 1. I-Frame muss ein Sequenzheader stehen
  END
  ELSE
    Result := -1;                                                   // Der Schnitt muß an einem I-Frame beginnen
END;

// ------------------------------ TListe ------------------------------------------------------

{PROCEDURE TListe.Loeschen;

VAR I : Integer;
    Eintrag : TObject;

BEGIN
  IF Count > 0 THEN
    FOR I := 0 TO Count - 1 DO
    BEGIN
      Eintrag := Items[I];
      Eintrag.Free;
    END;
  Clear;
  Capacity := Count;
END;

PROCEDURE TListe.LoeschenX(Nr: Integer);

VAR Eintrag : TObject;

BEGIN
  IF (Nr > - 1) AND (Nr < Count - 1) THEN
  BEGIN
    Eintrag := Items[Nr];
    Eintrag.Free;
 //   Delete[Nr];
  END;
END;

DESTRUCTOR TListe.Destroy;
BEGIN
  Loeschen;
  INHERITED Destroy;
END;   }

//------------------------------- TMpeg2Header ------------------------------------------------

CONSTRUCTOR TMpeg2Header.Create;
BEGIN
  INHERITED Create;
  Dateistream := NIL;
  Listenstream := NIL;
  PufferGr := 1048576;                              // 1 MByte
//  PufferGr := 524288;                               // 0.5 MByte
//  Listenaddr := NIL;                              // ---1---
//  IndexListenaddr := NIL;                         // ---1---
  Anhalten := False;
  SequenzEndeIgnorieren := True;
END;

PROCEDURE TMpeg2Header.Free;
BEGIN
  IF Assigned(Dateistream) THEN
  BEGIN
    Dateistream.Free;
    Dateistream := NIL;
  END;
  IF Assigned(Listenstream) THEN
  BEGIN
    Listenstream.Free;
    Listenstream := NIL;
  END;
{  IF Assigned(Listenaddr) THEN                     // Vorgesehen zur Listenverwaltung im
    Listenaddr.Free;                                // TMpeg2Header, funktioniert nicht
  IF Assigned(IndexListenaddr) THEN                 // siehe auch ---1---
    IndexListenaddr.Free;  }
  INHERITED Free;
END;

FUNCTION TMpeg2Header.DateiOeffnen(Name: STRING): Boolean;
BEGIN
  IF NOT (Dateistream = NIL) THEN                   // Dateistream vor neuer Zuweisung löschen
  BEGIN
    Dateistream.Free;
    Dateistream := NIL;
  END;
  IF NOT (Listenstream = NIL) THEN                  // Listenstream vor neuer Zuweisung löschen
  BEGIN
    Listenstream.Free;
    Listenstream := NIL;
  END;
  IF FileExists(Name) THEN
  BEGIN
    Dateiname := Name;
    Dateistream := TDateiPuffer.Create(Name, fmOpenRead);  // und Dateistream 'Videoname.mpg' öffnen
    IF Dateistream.DateiMode = fmOpenRead THEN
    BEGIN
      Result := True;
      Listenname := ChangeFileExt(Name, '.idd');
      IF FileExists(Listenname) THEN                         // Wenn schon eine ListenDatei 'Videoname.idd' besteht
      BEGIN
        Listenstream := TDateiPuffer.Create(Listenname, fmOpenRead);      // dann zum lesen öffnen
        IF NOT Listenstreampruefen THEN                                   // mit Mpeg2 Datei vergleichen
        BEGIN
          IF Assigned(Listenstream) THEN
            Listenstream.Free;                                            // bei Ungleichheit freigeben,
  //        DeleteFile(Listenname);                                         // löschen
          Listenstream := TDateiPuffer.Create(Listenname, fmCreate);      // und neue Datei erzeugen
        END;
      END
      ELSE
      BEGIN
        Listenstream := TDateiPuffer.Create(Listenname, fmCreate);        // ansonsten neue erzeugen
      END;
    END
    ELSE
      Result := False;                                                    // Datei 'Videoname.mpv' läßt sich nicht öffnen
  END
  ELSE
    Result := False;                                                      // Datei 'Videoname.mpv' existiert nicht
END;

PROCEDURE TMpeg2Header.PufferGroesse(Puffer: LongInt);
BEGIN
  IF Dateistream <> NIL THEN
    Dateistream.SetPufferGroesse(Puffer);
  PufferGr := Puffer;
END;

{PROCEDURE TMpeg2Header.NaechsterStartCode;
BEGIN
  Dateistream.Finden(1, 24);                                            // ist langsamer
END;}


PROCEDURE TMpeg2Header.NaechsterStartCode;

VAR Byte1 : Byte;
    Byte4 : Longword;

BEGIN
  Byte4 := $FFFFFFFF;
  WHILE (NOT Dateistream.DateiEnde) AND (NOT ((Byte4 AND $FFFFFF) = 1)) DO
  BEGIN
    Dateistream.Lesen(Byte1);
    Byte4 := (Byte4 SHL 8) OR Byte1;
  END;
END;

PROCEDURE TMpeg2Header.SequenzHeaderlesen(VAR SequenzHeader: TSequenzHeader);

VAR Daten : ARRAY[0..7] OF Byte;
    Adr_merken : Int64;

BEGIN
  Adr_merken := DateiStream.AktuelleAdr;
  IF NOT Dateistream.LesenX(Daten, 8) THEN
  BEGIN
    DateiStream.NeuePosition(Adr_merken);                    // Anfangsadresse wiederherstellen
    SequenzHeader.Framerate := 0;
    Exit;
  END;
  WITH SequenzHeader DO
  BEGIN
    Adresse := DateiStream.AktuelleAdr - 12;
    BildBreite := (Daten[0] SHL 4) + ((Daten[1] AND $F0) SHR 4);
    BildHoehe := ((Daten[1] AND $0F) SHL 8) + Daten[2];
    Seitenverhaeltnis := (Daten[3] AND $F0) SHR 4;
    Framerate := Daten[3] AND $0F;
    Bitrate := (Daten[4] SHL 10) + (Daten[5] SHL 2) + ((Daten[6] AND $C0) SHR 6);
    VBVPuffer := ((Daten[6] AND $1F) SHL 5) + ((Daten[7] AND $F8) SHR 3);
    ProfilLevel := 0;
    Progressive := False;
    ChromaFormat := 0;
    LowDelay := False;
    IF (Daten[7] AND $02) = 2 THEN
    BEGIN
      IF  NOT Dateistream.Vor(63) THEN
      BEGIN
        DateiStream.NeuePosition(Adr_merken);                    // Anfangsadresse wiederherstellen
        SequenzHeader.Framerate := 0;
        Exit;
      END;
      IF NOT Dateistream.Lesen(Daten[7]) THEN
      BEGIN
        DateiStream.NeuePosition(Adr_merken);                    // Anfangsadresse wiederherstellen
        SequenzHeader.Framerate := 0;
        Exit;
      END;
    END;
    IF (Daten[7] AND $01) = 1 THEN
      IF NOT Dateistream.Vor(64) THEN
      BEGIN
        DateiStream.NeuePosition(Adr_merken);                    // Anfangsadresse wiederherstellen
        SequenzHeader.Framerate := 0;
        Exit;
      END;
  END;
  NaechsterStartCode;
  IF NOT Dateistream.LesenX(Daten, 1) THEN
  BEGIN
    DateiStream.NeuePosition(Adr_merken);                        // Anfangsadresse wiederherstellen
    SequenzHeader.Framerate := 0;
    Exit;
  END;
  IF Daten[0] = $B5 THEN
  BEGIN
    IF NOT Dateistream.LesenX(Daten, 6) THEN
    BEGIN
      DateiStream.NeuePosition(Adr_merken);                     // Anfangsadresse wiederherstellen
      SequenzHeader.Framerate := 0;
      Exit;
    END;
    IF ((Daten[0] AND $F0) SHR 4) = 1 THEN                // erweiterter Sequenzheader?
    BEGIN
      WITH SequenzHeader DO
      BEGIN
        ProfilLevel := ((Daten[0] AND $0F) SHL 4) + ((Daten[1] AND $F0) SHR 4);
        Progressive := ((Daten[1] AND $08) SHR 3) = 1;
        ChromaFormat := (Daten[1] AND $06) SHR 1;
        BildBreite := BildBreite + ((Daten[1] AND $01) SHL 13) + ((Daten[2] AND $80) SHL 5);
        BildHoehe := BildHoehe + ((Daten[2] AND $60) SHL 7);
        Bitrate := Bitrate + ((Daten[2] AND $1F) SHL 25) + ((Daten[3] AND $FE) SHL 17);
        VBVPuffer := VBVPuffer + (Daten[4] SHL 10);
        LowDelay := ((Daten[5] AND $80) SHR 7) = 1;
      END;
    END
    ELSE
      Dateistream.Zurueck(10);
  END
  ELSE
    Dateistream.Zurueck(4);
  SequenzHeader.Bitrate := SequenzHeader.Bitrate * 400;  
END;

PROCEDURE TMpeg2Header.BildgruppenHeaderlesen(VAR GruppenHeader: TBildgruppenHeader);

VAR Daten : ARRAY[0..3] OF Byte;

BEGIN
  IF NOT Dateistream.LesenX(Daten, 4) THEN
    Exit;
  WITH GruppenHeader DO
  BEGIN
    Adresse := DateiStream.AktuelleAdr - 8;
    Timecode.Ungerade := (Daten[0] SHR 7) = 1;
    Timecode.Stunde := ((Daten[0] AND $7C) SHR 2);
    Timecode.Minute := ((Daten[0] AND $03) SHL 4) + ((Daten[1] AND $F0) SHR 4);
    Timecode.Marker := ((Daten[1] AND $08) SHR 3) = 1;
    Timecode.Sekunde := ((Daten[1] AND $07) SHL 3) + ((Daten[2] AND $E0) SHR 5);
    Timecode.Bilder := ((Daten[2] AND $1F) SHL 1) + ((Daten[3] AND $80) SHR 7);
    GeschlosseneGr := ((Daten[3] AND $40) SHR 6) = 1;
    Geschnitten := ((Daten[3] AND $20) SHR 5) = 1;
  END;
END;

PROCEDURE TMpeg2Header.Bildheaderlesen(VAR BildHeader: TBildHeader);

VAR Daten : ARRAY[0..4] OF Byte;
    Byte1 : Byte;
    Adr_merken : Int64;

BEGIN
  Adr_merken := DateiStream.AktuelleAdr;
  IF NOT Dateistream.LesenX(Daten, 4) THEN
  BEGIN
    DateiStream.NeuePosition(Adr_merken);                    // Anfangsadresse wiederherstellen
    BildHeader.BildTyp := 0;
    Exit;
  END;
  WITH BildHeader DO
  BEGIN
    Adresse := DateiStream.AktuelleAdr - 8;
    TempRefer := (Daten[0] SHL 2) + ((Daten[1] AND $C0) SHR 6);
    BildTyp := (Daten[1] AND $38) SHR 3;
    VBVDelay := ((Daten[1] AND $07) SHL 13) + (Daten[2] SHL 5) + ((Daten[3] AND $F8) SHR 3);
  END;
  NaechsterStartCode;
  IF NOT Dateistream.LesenX(Daten, 1) THEN
  BEGIN
    DateiStream.NeuePosition(Adr_merken);                    // Anfangsadresse wiederherstellen
    BildHeader.BildTyp := 0;
    Exit;
  END;
  IF Daten[0] = $B5 THEN
  BEGIN
    IF NOT Dateistream.LesenX(Daten, 5) THEN
    BEGIN
      DateiStream.NeuePosition(Adr_merken);                  // Anfangsadresse wiederherstellen
      BildHeader.BildTyp := 0;
      Exit;
    END;
    IF ((Daten[0] AND $F0) SHR 4) = 8 THEN       // erweiterter Bildheader
    BEGIN
      WITH BildHeader DO
      BEGIN
        FCode0 := (Daten[0] AND $0F);
        FCode1 := (Daten[1] AND $F0);
        FCode2 := (Daten[1] AND $0F);
        FCode3 := (Daten[2] AND $F0);
        IntraDCPre := (Daten[2] AND $0C) SHR 2;
        BildStruktur := Daten[2] AND $03;
        OberstesFeldzuerst := ((Daten[3] AND $80) SHR 7) = 1;
        frame_pred_frame_dct := ((Daten[3] AND $40) SHR 6) = 1;
        concealment_motion_vectors := ((Daten[3] AND $20) SHR 5) = 1;
        q_scale_type := ((Daten[3] AND $10) SHR 4) = 1;
        intra_vlc_format := ((Daten[3] AND $08) SHR 3) = 1;
        alternate_scan := ((Daten[3] AND $04) SHR 2) = 1;
        repeat_first_field := ((Daten[3] AND $02) SHR 1) = 1;
        chroma_420_type := (Daten[3] AND $01) = 1;
        progressive_frame := ((Daten[4] AND $80) SHR 7) = 1;
        composite_display_flag := ((Daten[4] AND $40) SHR 6) = 1;
        IF composite_display_flag THEN
        BEGIN
          v_axis := ((Daten[4] AND $20) SHR 5) = 1;
          IF NOT Dateistream.Lesen(Byte1) THEN
            Exit;
          field_sequence := ((Daten[4] AND $1C) SHR 2);
          sub_carrier := ((Daten[4] AND $02) SHR 1) = 1;
      //    burst_amplitude := 0;       // wird nicht gebraucht
      //    sub_carrier_phase := 0;     // wird nicht gebraucht
        END;
      END;
    END
    ELSE
      Dateistream.Zurueck(9);
  END
  ELSE
    Dateistream.Zurueck(4);
END;

PROCEDURE TMpeg2Header.HeaderIndexdateiLesen(VAR Header: THeaderklein);

VAR Puffer : ARRAY[0..7] OF Byte;

BEGIN
  IF NOT Listenstream.Lesen(Header.HeaderTyp) THEN     // Header Typ
  BEGIN
    Header.HeaderTyp := $FF;
    Exit;
  END;
  Int64(Puffer) := 0;
  IF IndexdateiVersion < 1 THEN
  BEGIN
    Listenstream.LesenX(Puffer, 4);         // Adresse 32 Bit
  END
  ELSE
  BEGIN
    Listenstream.LesenX(Puffer, 8);         // Adresse 64 Bit
  END;
  Header.Adresse := Int64(Puffer);
  IF Header.HeaderTyp = $00 THEN            // Bildheader
  BEGIN
    Int64(Puffer) := 0;
    Listenstream.LesenX(Puffer, 2);
    Header.TempRefer := Int64(Puffer);
    Listenstream.Lesen(Header.BildTyp);
  END;
  IF IndexdateiVersion < 2 THEN             // vollständige Indexliste
  BEGIN
    CASE Header.HeaderTyp OF
      $B3 : Listenstream.Vor(16);           // Informationen überspringen
      $B8 : Listenstream.Vor(8);
      $00 : Listenstream.Vor(23);
    END;
  END;
END;

PROCEDURE TMpeg2Header.HeaderIndexdateiSchreiben(VAR Header: THeaderklein);
BEGIN
  Listenstream.SchreibenDirekt(Header.HeaderTyp, SizeOf(Header.HeaderTyp));        // 1 Byte
  Listenstream.SchreibenDirekt(Header.Adresse, SizeOf(Header.Adresse));            // 8 Byte
  IF Header.HeaderTyp = $00 THEN
  BEGIN
    Listenstream.SchreibenDirekt(Header.TempRefer, SizeOf(Header.TempRefer));      // 2 Byte
    Listenstream.SchreibenDirekt(Header.BildTyp, SizeOf(Header.BildTyp));          // 1 Byte
  END;
END;
{
PROCEDURE TMpeg2Header.HeaderLesen(VAR Header: THeaderklein);

VAR Puffer : ARRAY[0..2] OF Byte;

BEGIN
  IF NOT Dateistream.LesenX(Puffer, 3) THEN
    Exit;
  Header.Adresse := DateiStream.AktuelleAdr - 6;
  Header.HeaderTyp := Puffer[0];
  IF Header.HeaderTyp = BildStartCode THEN
  BEGIN
    Header.TempRefer := (Puffer[1] SHL 2) + ((Puffer[2] AND $C0) SHR 6);
    Header.BildTyp := (Puffer[2] AND $38) SHR 3;
  END;
END;
}
PROCEDURE TMpeg2Header.HeaderLesen(VAR Header: THeaderklein);

VAR Byte1 : Byte;
    Puffer : ARRAY[0..1] OF Byte;

BEGIN
  IF NOT Dateistream.Lesen(Byte1) THEN
  BEGIN
    Header.HeaderTyp := $FF;
    Exit;
  END;
  Header.Adresse := DateiStream.AktuelleAdr - 4;
  Header.HeaderTyp := Byte1;
  CASE Header.HeaderTyp OF        // Je nach StartCode muss entsprechend vorgesprungen werden um nicht ausversehen
    BildStartCode     : BEGIN     // in den Daten einen "StartCode" zu finden.
                          Dateistream.LesenX(Puffer, 2);
                          Header.TempRefer := (Puffer[0] SHL 2) + ((Puffer[1] AND $C0) SHR 6);
                          Header.BildTyp := (Puffer[1] AND $38) SHR 3;
                          IF Header.BildTyp = 1 THEN
                            Dateistream.Vor(2)                   // I-Frame
                          ELSE
                            Dateistream.Vor(3);                  // P- und B-Frames
                        END;
                        // Durch das "extra_bit_picture" ist gewährleistet, das keine StartCode ähnliche
                        // Struktur entsteht. Ich verzichte deshalb auf das überspringen der Extrainformationen.
    SequenceStartCode : BEGIN
                          Dateistream.Vor(7);
                          Dateistream.Lesen(Byte1);
                          IF (Byte1 AND $02) = 2 THEN            // Intra Quantiser Matrix
                          BEGIN
                            Dateistream.Vor(56);
                            Dateistream.Lesen(Byte1);
                          END;
                          IF (Byte1 AND $01) = 1 THEN            // Nonintra Quantiser Matrix
                          BEGIN
                            Dateistream.Vor(64);
                          END;
                        END;
    ErweiterterCode   : BEGIN
                          Dateistream.Lesen(Byte1);
                          Byte1 := (Byte1 AND $F0) SHR 4;        // ExtensionID
                          CASE Byte1 OF
                            1 : Dateistream.Vor(5);              // Sequenzheaderextension
                            2 : BEGIN                            // Sequenzdisplayextension
                                  IF (Byte1 AND $01) = 1 THEN    // color_description_bit
                                    Dateistream.Vor(7)
                                  ELSE
                                    Dateistream.Vor(4);
                                END;
                            8 : BEGIN                            // Picture coding extension
                                  Dateistream.Vor(3);
                                  Dateistream.Lesen(Byte1);
                                  Byte1 := (Byte1 AND $40) SHR 6;
                                  IF Byte1 = 1 THEN              // composite_display_flag
                                    Dateistream.Vor(2);
                                END;
                          END;
                        END;
    GruppenStartCode  : BEGIN
                          Dateistream.Vor(4);
                        END;
  END;
END;

PROCEDURE TMpeg2Header.DateiInformationLesen(VAR SequenzHeader: TSequenzHeader; VAR BildHeader: TBildHeader);

VAR Code : Byte;
    Adr_merken : Int64;
    SequenzHeadergelesen,
    BildHeadergelesen : Boolean;

BEGIN
  Adr_merken := Dateistream.AktuelleAdr;
  SequenzHeadergelesen := False;
  BildHeadergelesen := False;
  Code := $FF;
  WHILE (NOT Dateistream.DateiEnde) AND (NOT (Code = SequenceEndeCode)) AND
        (NOT (SequenzHeadergelesen AND BildHeadergelesen)) DO
  BEGIN
    Code := $FF;
    WHILE (NOT (Code IN StartCodes)) AND (NOT Dateistream.Dateiende) DO
    BEGIN
      NaechsterStartCode;
      IF Dateistream.Dateiende THEN
        Code := $FF
      ELSE
        Dateistream.Lesen(Code);
    END;
    IF (Code = SequenceStartCode) AND NOT SequenzHeadergelesen THEN
    BEGIN
      SequenzHeaderlesen(SequenzHeader);
      SequenzHeadergelesen := True;
    END;
    IF (Code = BildStartCode) AND NOT BildHeadergelesen THEN
    BEGIN
      BildHeaderlesen(BildHeader);
      BildHeadergelesen := True;
    END;
  END;
  Dateistream.NeuePosition(Adr_merken);
END;

FUNCTION TMpeg2Header.Listenstreampruefen: Boolean;

VAR Header : THeaderklein;
    I : LongWord;
//    SchleifenAnfangsZeit, SchleifenEndeZeit : TDateTime;     // zum messen der Schleifendauer
    Puffer : ARRAY[0..3] OF Byte;

BEGIN
//  SchleifenAnfangsZeit := Time;                     // zum messen der Schleifenzeit
  IndexdateiVersion := 0;
  IF Listenstream.LesenX(Puffer, 4) THEN
  BEGIN
    IF (Puffer[0] = Ord('i')) AND (Puffer[1] = Ord('d')) AND (Puffer[2] = Ord('d')) THEN
      IndexdateiVersion := Puffer[3];
    IF IndexdateiVersion > 1 THEN                       // nur neue Indexdateien prüfen
    BEGIN
      I := 0;
      Header := THeaderklein.Create;
      REPEAT
        HeaderIndexdateiLesen(Header);
        IF Header.HeaderTyp IN StartCodes THEN          // 10ten Eintrag suchen
          Inc(I);
      UNTIL (I = 10) OR (Listenstream.DateiEnde) OR (Header.HeaderTyp = SequenceEndeCode);
      IF Header.HeaderTyp IN StartCodes THEN            // wurde wenigstens ein Header gefunden
      BEGIN
        IF Dateistream.DateiMode = fmOpenRead THEN      // und ist die Datei geöffnet
        BEGIN                                           // muß in der Datei
          Dateistream.NeuePosition(Header.Adresse);     // an der entsprechenden Stelle
          Dateistream.LesenY(Puffer, 4);
          IF LongWord(Puffer) = ($00000100 + Header.HeaderTyp) THEN
            Result := True                              // der gleiche Header stehen
          ELSE
            Result := False;                            // falsche Datei
        END
        ELSE
          Result := True;                               // prüfen nicht möglich
      END
      ELSE
        Result := False;                                // kein Sequenzheaderindex gefunden?
      IF Result THEN
      BEGIN
        Listenstream.NeuePosition(Listenstream.Dateigroesse - 9);  // letzter Indexeintrag ist
        HeaderIndexdateiLesen(Header);
        IF Header.HeaderTyp = SequenceEndeCode THEN     // ein SequenceEndeHeaderIndex
        BEGIN
          IF Dateistream.DateiMode = fmOpenRead THEN
          BEGIN
            Dateistream.NeuePosition(Header.Adresse);   // an der entsprechenden Stelle muß
            Dateistream.LesenY(Puffer, 4);              // auch ein SequenzEndeHeader sein
            IF (Dateistream.Dateigroesse = Header.Adresse) OR (LongWord(Puffer) = ($00000100 + SequenceEndeCode)) THEN
              Result := True                            // oder die Dateigröße muß mit dem
            ELSE                                        // Indexeintrag übereinstimmen
              Result := False;                          // (kein SequenzEndeHeader vorhanden)
          END
          ELSE
            Result := True;                             // prüfen nicht möglich
        END
        ELSE
          Result := False;
      END;
      Dateistream.NeuePosition(0);
      Header.Free;
    END
    ELSE
      Result := False;                                  // alte Indexdatei nicht geprüft
  END
  ELSE
    Result := False;                                    // Indexdatei nicht lesbar
  Listenstream.NeuePosition(0);
//  SchleifenEndeZeit := Time;                          // zum messen der Schleifenzeit
//  Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, SchleifenEndeZeit)));  // ----- " ------
END;

FUNCTION TMpeg2Header.IndexDateischreiben: Boolean;

VAR Header : THeaderklein;
    Puffer : ARRAY[0..3] OF Byte;

BEGIN
  Anhalten := False;
  IF Listenstream.Dateigroesse = 0 THEN                 // keine Listendatei vorhanden
  BEGIN
    IF Assigned(Textanzeige) THEN
      Textanzeige(1, Dateiname);
    IF Assigned(FortschrittsEndwert) THEN
      FortschrittsEndwert^ := Dateistream.Dateigroesse;
    Puffer[0] := Ord('i');                              // Puffer mit 'idd' füllen
    Puffer[1] := Ord('d');
    Puffer[2] := Ord('d');
    Puffer[3] := 2;                                     // Version der Indexdatei
    Listenstream.SchreibenDirekt(Puffer, 4);            // Puffer an den Anfang der Datei schreiben
    Header := THeaderklein.Create;
    WHILE (NOT Dateistream.DateiEnde) {AND (NOT (HeaderTyp = SequenceEndeCode))} AND (NOT Anhalten) DO
    BEGIN
      Header.HeaderTyp := $FF;
      WHILE (NOT (Header.HeaderTyp IN StartCodes)) AND (NOT Dateistream.Dateiende) DO
      BEGIN
        NaechsterStartCode;
        IF Dateistream.Dateiende THEN
          Header.HeaderTyp := $FF
        ELSE
          HeaderLesen(Header);
      END;
      IF Dateistream.Dateiende AND (NOT(Header.HeaderTyp = SequenceEndeCode)) THEN
      BEGIN
        Header.HeaderTyp := SequenceEndeCode;          // Videodatei ohne Sequenzendekennung
        Header.Adresse := Dateistream.Dateigroesse;
      END;
      HeaderIndexdateiSchreiben(Header);
      IF (NOT Anhalten) AND Assigned(Fortschrittsanzeige) THEN    // Fortschrittsanzeige
        Anhalten := Fortschrittsanzeige(Dateistream.AktuelleAdr);
    END;
    Header.Free;
    Dateistream.NeuePosition(0);
    IF Anhalten THEN
    BEGIN
      IF Assigned(Listenstream) THEN
      BEGIN
        Listenstream.Free;
        Listenstream := NIL;
      END;
      IF FileExists(Listenname) THEN                         // Wenn eine ListenDatei 'Videoname.idd' besteht
        DeleteFile(Listenname);                              // löschen
    END;
  END;
  IF FileExists(Listenname) THEN
    Result := True
  ELSE
    Result := False;
END;

FUNCTION TMpeg2Header.Indexlisteerstellen(Liste, IndexListe: TListe): Boolean;

VAR Header : THeaderklein;
    BildIndex : TBildIndex;
    BilderproGruppe,
    HoechsteTempRef,
    ReferDiff : Integer;
    I,
    Bildgruppenanfang : LongInt;

BEGIN
  I := 0;
  BilderproGruppe := 0;
  HoechsteTempRef := 0;
  Bildgruppenanfang := 0;
  ReferDiff := 0;
//  SchleifenAnfangsZeit := Time;                      // zum messen der Schleifenzeit
  WHILE I < Liste.Count DO                             // Indexliste erstellen
  BEGIN
    Header := Liste.Items[I];
    IF Header.HeaderTyp = GruppenStartCode THEN
    BEGIN
      IF HoechsteTempRef > (BilderproGruppe - 1) THEN  // Tempref. wurden bei einem früheren Schnitt nicht korrigiert
      BEGIN
        ReferDiff := 0;
{        ReferDiff := HoechsteTempRef - (BilderproGruppe - 1);
        I := I - BilderproGruppe - 2;
        FOR HoechsteTempRef := 1 TO BilderproGruppe DO // Die letzten Einträge der Indexliste löschen
          IndexListe.LoeschenX(IndexListe.Count - 1);  // Liste.LoeschenX funktioniert nicht
        BilderproGruppe := 0;     }
      END
      ELSE
        ReferDiff := 0;
      Bildgruppenanfang := Bildgruppenanfang + BilderproGruppe;
      BilderproGruppe := 0;
      HoechsteTempRef := 0;
    END;
    IF Header.HeaderTyp = BildStartCode THEN   // Bild
    BEGIN
      Inc(BilderproGruppe);
      BildIndex := TBildIndex.Create;
      BildIndex.BildNr := Bildgruppenanfang + Header.TempRefer + ReferDiff;
      BildIndex.BildIndex := I;
      BildIndex.BildTyp := Header.BildTyp;
      IndexListe.Add(BildIndex);
      IF Header.TempRefer > HoechsteTempRef THEN       // größte TempRefer merken damit die nächste
        HoechsteTempRef := Header.TempRefer;           // GOP mit der nächsthöheren Nummer beginnt
    END;
    Inc(I);
  END;
//  Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, Time)));  // zum messen der Schleifenzeit
//  SchleifenAnfangsZeit := Time;             // zum messen der Schleifenzeit
  IndexListe.Sort(IndexListeSortieren);
//  Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, Time)));  // zum messen der Schleifenzeit
  IF IndexListe.Count > 0 THEN
    Result := True
  ELSE
    Result := False;
END;

FUNCTION TMpeg2Header.Listeerzeugen(VAR Liste, IndexListe: TListe): Boolean;

VAR Header : THeaderklein;
//    BildIndex : TBildIndex;
//    BilderproGruppe,
//    HoechsteTempRef,
//    ReferDiff : Integer;
//    I,
//    Bildgruppenanfang : LongInt;
    Puffer : ARRAY[0..3] OF Byte;
    Headertyp : Byte;
    ListenEnde : Boolean;
//    SchleifenAnfangsZeit, SchleifenEndeZeit : TDateTime;     // zum messen der Schleifendauer

BEGIN
{  IF NOT Assigned(Liste) THEN                          // ---1---
  BEGIN
    Liste := TList.Create;
    Listenaddr := Liste;
  END;
  IF NOT Assigned(IndexListe) THEN                      // ---1---
  BEGIN
    IndexListe := TList.Create;
    IndexListenaddr := IndexListe;
  END;   }
  Anhalten := False;
//  SchleifenAnfangsZeit := Time;                     // zum messen der Schleifenzeit
  IF Listenstream.Dateigroesse > 0 THEN                    // ist eine Listendatei vorhanden dann auslesen
  BEGIN
    IF Assigned(Textanzeige) THEN
      Textanzeige(2, Dateiname);
    IF Assigned(FortschrittsEndwert) THEN
      FortschrittsEndwert^ := Listenstream.Dateigroesse;
    IndexdateiVersion := 0;
    Listenstream.LesenX(Puffer, 4);
    IF (Puffer[0] = Ord('i')) AND (Puffer[1] = Ord('d')) AND (Puffer[2] = Ord('d')) THEN
      IndexdateiVersion := Puffer[3]
    ELSE
      Listenstream.NeuePosition(0);
    HeaderTyp := $FF;
    WHILE (NOT Listenstream.DateiEnde) AND ((NOT (HeaderTyp = SequenceEndeCode)) OR SequenzEndeIgnorieren) AND (NOT Anhalten) DO
    BEGIN
      Header := THeaderklein.Create;
      HeaderIndexdateiLesen(Header);
      Liste.Add(Header);
      Headertyp := Header.HeaderTyp;
      IF (NOT Anhalten) AND Assigned(Fortschrittsanzeige) THEN    // Fortschrittsanzeige
        Anhalten := Fortschrittsanzeige(Listenstream.AktuelleAdr);
    END;
    IF NOT (Header.HeaderTyp = $B7) AND                 // Fehler in alten Indexdateien ausbügeln
           (IndexdateiVersion < 2) THEN
    BEGIN
      IF Header.HeaderTyp = $00 THEN                    // letzter Header ist ein Bildheader
      BEGIN
        Header := THeaderklein.Create;                  // Sequenzendeheader erzeuegen und
        Header.HeaderTyp := $B7;
        Header.Adresse := Dateistream.Dateigroesse;     // füllen
        Liste.Add(Header);
      END
      ELSE                                              // letzter Header ist irgendwas
      BEGIN
        Header.HeaderTyp := $B7;                        // zum Sequenzendeheader machen und
        Header.Adresse := Dateistream.Dateigroesse;     // füllen
      END;
    END;
  END
  ELSE
  BEGIN
    ListenEnde := False;
    IF Assigned(Textanzeige) THEN
      Textanzeige(1, Dateiname);
    IF Assigned(FortschrittsEndwert) THEN
      FortschrittsEndwert^ := Dateistream.Dateigroesse;
    Puffer[0] := Ord('i');                              // Puffer mit 'idd' füllen
    Puffer[1] := Ord('d');
    Puffer[2] := Ord('d');
    Puffer[3] := 2;                                     // Version der Indexdatei
    Listenstream.SchreibenDirekt(Puffer, 4);            // Puffer an den Anfang der Datei schreiben
    WHILE (NOT Dateistream.DateiEnde) {AND (NOT(HeaderTyp = SequenceEndeCode) OR SequenzEndeIgnorieren)} AND (NOT Anhalten) DO
    BEGIN
      Header := THeaderklein.Create;
      Header.HeaderTyp := $FF;
      WHILE (NOT (Header.HeaderTyp IN StartCodes)) AND (NOT Dateistream.Dateiende) DO
      BEGIN
        NaechsterStartCode;
        IF Dateistream.Dateiende THEN
          Header.HeaderTyp := $FF
        ELSE
          HeaderLesen(Header);
      END;
      IF Dateistream.Dateiende AND NOT(Header.HeaderTyp = SequenceEndeCode) THEN
      BEGIN
        IF NOT(THeaderklein(Liste[Liste.Count -1]).HeaderTyp = SequenceEndeCode) THEN
        BEGIN
          Header.HeaderTyp := SequenceEndeCode;          // Videodatei ohne Sequenzendekennung
          Header.Adresse := Dateistream.Dateigroesse;
          IF NOT ListenEnde THEN
            Liste.Add(Header);
          HeaderIndexdateiSchreiben(Header);
          Headertyp := Header.HeaderTyp;
        END
        ELSE
        BEGIN
          Headertyp := $FF;
          Header.Free;
        END;
      END
      ELSE
      BEGIN
        IF NOT ListenEnde THEN
          Liste.Add(Header);
        HeaderIndexdateiSchreiben(Header);
        Headertyp := Header.HeaderTyp;
      END;
      IF (HeaderTyp = SequenceEndeCode) AND
         (NOT SequenzEndeIgnorieren) THEN
        ListenEnde := True;
      IF (NOT Anhalten) AND Assigned(Fortschrittsanzeige) THEN    // Fortschrittsanzeige
        Anhalten := Fortschrittsanzeige(Dateistream.AktuelleAdr);
    END;
    Dateistream.NeuePosition(0);
    IF Anhalten THEN
    BEGIN
      IF Assigned(Listenstream) THEN
      BEGIN
        Listenstream.Free;
        Listenstream := NIL;
      END;
      IF FileExists(Listenname) THEN                         // Wenn eine ListenDatei 'Videoname.idd' besteht
        DeleteFile(Listenname);                              // löschen
    END;
  END;
//  SchleifenEndeZeit := Time;                           // zum messen der Schleifenzeit
//  Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, SchleifenEndeZeit)));  // ----- " ------
// ----------------------- IndexListe aus der Lister erzeugen und sortieren --------------------
  IF Anhalten THEN
    Liste.Loeschen
  ELSE
  BEGIN
 {   I := 0;
    BilderproGruppe := 1;
    HoechsteTempRef := 0;
    Bildgruppenanfang := -1;
//    SchleifenAnfangsZeit := Time;                      // zum messen der Schleifenzeit
    WHILE I < Liste.Count DO                             // Indexliste erstellen
    BEGIN
      Header := Liste.Items[I];
      IF Header.HeaderTyp = GruppenStartCode THEN
      BEGIN
        IF HoechsteTempRef > (BilderproGruppe - 1) THEN  // Tempref. wurden bei einem früheren Schnitt nicht korrigiert
        BEGIN
          ReferDiff := 0;
//          ReferDiff := HoechsteTempRef - (BilderproGruppe - 1);
//          I := I - BilderproGruppe - 2;
//          FOR HoechsteTempRef := 1 TO BilderproGruppe DO // Die letzten Einträge der Indexliste löschen
//            IndexListe.LoeschenX(IndexListe.Count - 1);  // Liste.LoeschenX funktioniert nicht
//          BilderproGruppe := 0;
        END
        ELSE
          ReferDiff := 0;
        Bildgruppenanfang := Bildgruppenanfang + (BilderproGruppe);
        BilderproGruppe := 0;
        HoechsteTempRef := 0;
      END;
      IF Header.HeaderTyp = BildStartCode THEN
      BEGIN
        Inc(BilderproGruppe);
        BildIndex := TBildIndex.Create;
        BildIndex.BildNr := Bildgruppenanfang + Header.TempRefer + ReferDiff;
        BildIndex.BildIndex := I;
        BildIndex.BildTyp := Header.BildTyp;
        IndexListe.Add(BildIndex);
        IF Header.TempRefer > HoechsteTempRef THEN       // größte TempRefer merken damit die nächste
          HoechsteTempRef := Header.TempRefer;           // GOP mit der nächsthöheren Nummer beginnt
      END;
      Inc(I);
    END;
//    SchleifenEndeZeit := Time;                // zum messen der Schleifenzeit
//    Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, SchleifenEndeZeit)));  // ----- " ------
//    SchleifenAnfangsZeit := Time;             // zum messen der Schleifenzeit
    IndexListe.Sort(IndexListeSortieren);   }
//    SchleifenEndeZeit := Time;                // zum messen der Schleifenzeit
//    Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, SchleifenEndeZeit)));  // ----- " ------
    Indexlisteerstellen(Liste, IndexListe);
  END;
  IF (Liste.Count > 0) AND (IndexListe.Count > 0) THEN
    Result := True
  ELSE
    Result := False;
END;

//----------------------------------------------------------------------------

{CONSTRUCTOR TVideoschnitt.Create;
BEGIN
  INHERITED Create;
  Dateiname := '';
  Zieldateiname := '';
  Dateistream := NIL;
  Speicherstream := NIL;
  VideoListe := TListe.Create;
  VideoIndexListe := TListe.Create;
  NeueListe := TListe.Create;;
  Anhalten := False;
  Timecode_korrigieren := True;
  Bitrate_korrigieren := True;
  festeBitrate := 0;
  IndexDatei_erstellen := True;
  SequenzHeader:= TSequenzHeader.Create;;
  BildHeader:= TBildHeader.Create;
END;

PROCEDURE TVideoschnitt.Free;
BEGIN
  IF Dateistream <> NIL THEN                                   // Wenn ein Dateistream geöffnet ist freigeben
  BEGIN
    Dateistream.Free;
    Dateistream := NIL;
  END;
  IF Speicherstream <> NIL THEN                                // Wenn ein Speicherstream geöffnet ist freigeben
  BEGIN
    Speicherstream.Free;
    Speicherstream := NIL;
  END;
  IF VideoListe <> NIL THEN
  BEGIN
    VideoListe.Loeschen;
    VideoListe.Free;                                           // Listen freigeben
  END;
  IF VideoIndexListe <> NIL THEN
  BEGIN
    VideoIndexListe.Loeschen;
    VideoIndexListe.Free;
  END;
  IF NeueListe <> NIL THEN
  BEGIN
    IF IndexDatei_erstellen THEN
      IndexDateispeichern(Zieldateiname, NeueListe);
    IF D2VDatei_erstellen THEN
      D2VDateispeichern(Zieldateiname, NeueListe);
    NeueListe.Loeschen;
    NeueListe.Free;
  END;
  IF Assigned(SequenzHeader) THEN
    SequenzHeader.Free;
  IF Assigned(BildHeader) THEN
    BildHeader.Free;
END;

PROCEDURE TVideoschnitt.IndexDateispeichern(Name: STRING; Liste : TListe);

VAR I : LongInt;
    Listenstream : TDateiPuffer;
    Header : THeaderklein;
    Puffer : ARRAY[0..3] OF Byte;
    BildTyp : Byte;
//    SchleifenAnfangsZeit : TDateTime;     // zum messen der Schleifendauer

BEGIN
  IF (Liste.Count > 0) AND (Name <> '') THEN
  BEGIN
//    SchleifenAnfangsZeit := Time;                              // zum messen der Schleifenzeit
    Listenstream := TDateiPuffer.Create(ChangeFileExt(Name, '.idd'), fmCreate);
    Puffer[0] := Ord('i');                              // Puffer mit 'idd' füllen
    Puffer[1] := Ord('d');
    Puffer[2] := Ord('d');
    Puffer[3] := 2;                                     // Version der Indexdatei
    Listenstream.SchreibenDirekt(Puffer, 4);            // Puffer an den Anfang der Datei schreiben
    FOR I := 0 TO Liste.Count -1 DO
    BEGIN
      Header := Liste[I];
      Listenstream.SchreibenDirekt(Header.HeaderTyp, SizeOf(Header.HeaderTyp));        // 1 Byte
      Listenstream.SchreibenDirekt(Header.Adresse, SizeOf(Header.Adresse));            // 8 Byte
      IF Header.HeaderTyp = $00 THEN
      BEGIN
        Listenstream.SchreibenDirekt(Header.TempRefer, SizeOf(Header.TempRefer));      // 2 Byte
        BildTyp := Header.BildTyp AND $07;
        Listenstream.SchreibenDirekt(BildTyp, SizeOf(Header.BildTyp)); // 1 Byte
      END;
    END;
    Listenstream.Free;
//    Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, Time)));  // zum messen der Schleifenzeit
  END;
END;

FUNCTION BildListeSortieren(Item1, Item2: Pointer): Integer;
BEGIN
  Result := 0;
  IF THeaderklein(Item1).TempRefer < THeaderklein(Item2).TempRefer THEN
    Result := -1;
  IF THeaderklein(Item1).TempRefer = THeaderklein(Item2).TempRefer THEN
    Result := 0;
  IF THeaderklein(Item1).TempRefer > THeaderklein(Item2).TempRefer THEN
    Result := 1;
END;

PROCEDURE TVideoschnitt.D2VDateispeichern(Name: STRING; Liste : TListe);

VAR I, GH : LongInt;
    Temprefer : Word;
    HString : STRING;
    D2VListe : TStringList;
    Header : THeaderklein;
    Bildliste : TListe;
    Adresse : Int64;
//    SchleifenAnfangsZeit : TDateTime;     // zum messen der Schleifendauer

BEGIN
  IF (Liste.Count > 0) AND (Name <> '') THEN
  BEGIN
//    SchleifenAnfangsZeit := Time;                              // zum messen der Schleifenzeit
    D2VListe := TStringList.Create;
    TRY
      D2VListe.Sorted := False;
      IF FileExists('D2VOrginal.d2v') THEN
        D2VListe.LoadFromFile('D2VOrginal.d2v')
      ELSE
      BEGIN
        D2VListe.Add('DVD2AVIProjectFile');
        D2VListe.Add('1');
        D2VListe.Add('');
        D2VListe.Add('');
        D2VListe.Add('Stream_Type=0,0,0');
        D2VListe.Add('iDCT_Algorithm=2');
        D2VListe.Add('YUVRGB_Scale=1');
        D2VListe.Add('Luminance=128,0');
        D2VListe.Add('Picture_Size=0,0,0,0,0,0');
        D2VListe.Add('Field_Operation=0');
        D2VListe.Add('Frame_Rate=25000');
        D2VListe.Add('Location=0,0,0,FFFFFF');
      END;
      D2VListe[2] := IntToStr(Length(Name)) + ' ' + Name;
      CASE SequenzHeader.Framerate OF
        1: HString := '23976';
        2: HString := '24000';
        3: HString := '25000';
        4: HString := '29970';
        5: HString := '30000';
        6: HString := '50000';
        7: HString := '59970';
        8: HString := '60000';
      ELSE
        HString := HString + '25000';
      END;
      D2VListe[10] := 'Frame_Rate=' + HString;
      Header := Liste[Liste.Count -1];
      D2VListe[11] := 'Location=0,0,0,' + IntToHex(Trunc(Header.Adresse / 2048), 1);
      D2VListe.Add('');
      Bildliste := TListe.Create;
      TRY
        Temprefer := 0;
        I := 0;
        IF I < Liste.Count THEN
          Header := Liste[I];                                 // erster Header
        WHILE (Header.HeaderTyp <> GruppenStartCode) AND (I < Liste.Count) DO
        BEGIN                                                 // Gruppenheader suchen
          Inc(I);
          IF I < Liste.Count THEN
            Header := Liste[I];
        END;
        WHILE I < Liste.Count DO                              // bis zum Ende der Liste wiederholen
        BEGIN
          IF I > 0 THEN                                       // kann vor dem Gruppenheader ein Sequenzheader stehen?
          BEGIN
            Header := Liste[I - 1];
            IF NOT(Header.HeaderTyp = SequenceStartCode) THEN // kein Sequenzheader gefunden
              Header := Liste[I];                             // --> Gruppenheader
          END
          ELSE
            Header := Liste[I];                               // Gruppenheader
          Adresse := Trunc(Header.Adresse / 2048) - 1;        // Adresse des Headers berechnen
          IF Adresse < 0 THEN
            Adresse := 0;
          HString := '7 0 ' + IntToHex(Adresse, 1);           // Gruppenadresse
          Inc(I);
          IF I < Liste.Count THEN
          BEGIN
            Header := Liste[I];                               // erstes Bild nach dem Gruppenheader
            Temprefer := Header.TempRefer;                    // tempoäre Referenz des Bildes merken
            BildListe.Add(Header);                            // zur Bildliste hinzufügen
          END;
          REPEAT
            Inc(I);
            IF I < Liste.Count THEN
            BEGIN
              Header := Liste[I];                             // nächstes Bild
              IF Header.TempRefer > Temprefer THEN            // nur Bilder mit größerer tempoären Referenz
                BildListe.Add(Header);                        // zur Bildliste hinzufügen
            END;
          UNTIL (Header.HeaderTyp <> BildStartCode) OR (I > Liste.Count - 1); // Bildgruppe zu Ende
          BildListe.Sort(BildListeSortieren);                 // Bildliste sortieren
          WHILE (Header.HeaderTyp <> GruppenStartCode) AND (I < Liste.Count) DO
          BEGIN                                               // nächsten Gruppenheader suchen
            Inc(I);
            IF I < Liste.Count THEN
              Header := Liste[I];
          END;
          GH := I;                                            // Gruppenheader merken
          Inc(I);
          IF I < Liste.Count THEN
          BEGIN
            Header := Liste[I];                               // erstes Bild nach dem Gruppenheader
            Temprefer := Header.TempRefer;                    // tempoäre Referenz des Bildes merken
          END;
          REPEAT
            Inc(I);
            IF I < Liste.Count THEN
            BEGIN
              Header := Liste[I];                             // nächstes Bild
              IF Header.TempRefer < Temprefer THEN            // nur Bilder mit kleinerer tempoären Referenz
                BildListe.Add(Header);                        // zur Bildliste hinzufügen
            END;
          UNTIL (Header.HeaderTyp <> BildStartCode) OR (I > Liste.Count - 1) // Bildgruppe zu Ende oder
                OR (Header.TempRefer > Temprefer);            // Bild mit höherer tenpoären Referenz gefunden
          FOR I := 0 TO Bildliste.Count - 1 DO                // Bildliste in die D2V-Listenzeile schreiben
          BEGIN
            Header := Bildliste[I];
            IF (GH > Liste.Count -1) AND (I = Bildliste.Count -1) THEN
              HString := HString + ' 9'                       // ans Ende der Liste kommt eine 9
            ELSE
              HString := HString + ' ' + IntToStr((Header.BildTyp AND $C0) SHR 6);
          END;                                                // Bildart in die D2V-Listenzeile schreiben
          D2VListe.Add(HString);                              // D2V-Listenzeile zur D2V-Liste hinzufügen
          BildListe.Clear;                                    // Bildliste löschen
          I := GH;                                            // Gruppenheader in Zähler laden
        END;
      FINALLY
        BildListe.Free;
      END;
//      D2VListe[D2VListe.Count - 1] := D2VListe[D2VListe.Count - 1] + ' 2 9'; 
      D2VListe.Add('');
      D2VListe.Add('FINISHED');
      D2VListe.SaveToFile(ChangeFileExt(Name, '.d2v'));       // D2V-Liste in die Datei schreiben
    FINALLY
      D2VListe.Free;
    END;
//    Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, Time)));  // zum messen der Schleifenzeit
  END;
END;

PROCEDURE TVideoschnitt.Zieldateioeffnen(ZielDatei: STRING);
BEGIN
  IF NOT (Zieldateiname = ZielDatei) THEN
  BEGIN
    IF Speicherstream <> NIL THEN
      Speicherstream.Free;
//    Speicherstream := TDateipuffer.Create(ZielDatei, fmCreate);
    IF IndexDatei_erstellen THEN
      IndexDateispeichern(Zieldateiname, NeueListe);
    NeueListe.Loeschen;
    Zieldateiname := ZielDatei;
  END;
END;

PROCEDURE TVideoschnitt.Zieldateischliessen;
BEGIN
  IF Speicherstream <> NIL THEN
  BEGIN
    Speicherstream.Free;
    Speicherstream := NIL;
  END;
  IF IndexDatei_erstellen THEN
    IndexDateispeichern(Zieldateiname, NeueListe);
  NeueListe.Loeschen;
  Zieldateiname := '';
END;

PROCEDURE TVideoschnitt.Quelldateioeffnen(SchnittPunkt: TSchnittPunkt);

VAR MpegHeader: TMpeg2Header;
//    SchleifenAnfangsZeit : TDateTime;            // zum messen der Schleifendauer

BEGIN
  IF NOT (Dateiname = SchnittPunkt.VideoName) THEN
  BEGIN
//    SchleifenAnfangsZeit := Time;                // zum messen der Schleifenzeit
    IF Dateistream <> NIL THEN
    BEGIN
      Dateistream.Free;
      Dateistream := NIL;
    END;
    MpegHeader:= TMpeg2Header.Create;
//    MpegHeader.Fortschrittsanzeige := Fortschrittsanzeige;
    MpegHeader.Textanzeige := Textanzeige;
//    MpegHeader.FortschrittsEndwert := FortschrittsEndwert;
    MpegHeader.Dateioeffnen(SchnittPunkt.VideoName);
    MpegHeader.DateiInformationLesen(SequenzHeader, BildHeader);
    IF SchnittPunkt.VideoListe = NIL THEN
    BEGIN
      VideoListe.Loeschen;                                                  // neue Liste einlesen
      VideoIndexListe.Loeschen;
      MpegHeader.Listeerzeugen(VideoListe, VideoIndexListe);
      Liste := VideoListe;
      IndexListe := VideoIndexListe;
    END
    ELSE
    BEGIN
      Liste := SchnittPunkt.VideoListe;
      IndexListe := SchnittPunkt.VideoIndexListe;
    END;
    MpegHeader.Free;
    Dateistream := TDateipuffer.Create(SchnittPunkt.VideoName, fmOpenRead);
    Dateistream.Pufferfreigeben;
    Dateiname := SchnittPunkt.VideoName;
//    Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, Time)));  // zum messen der Schleifenzeit
  END;
END;

PROCEDURE TVideoschnitt.Quelldateischliessen;
BEGIN
  IF Dateistream <> NIL THEN
  BEGIN
    Dateistream.Free;
    Dateistream := NIL;
  END;
  Dateiname := '';
  VideoListe.Loeschen;
  VideoIndexListe.Loeschen;
  Liste := NIL;
  IndexListe := NIL;
END;

FUNCTION TVideoschnitt.Effektberechnen(AnfangsIndex, EndIndex: Int64; EffektParameter: STRING; EffektLaenge: Integer; EffektDaten: TAusgabeDaten; Audioheader: TAudioHeader): Integer;

VAR Laenge,
    FehlerNr,
    VariablenZahl,
    VariablenZaehler : Integer;
    TeilDateiname,
    EffektDateiname,
    ProgrammParameter,
    aktVerzeichnis : STRING;
    HDateistream : TDateiPuffer;
    MpegAudio : TMpegAudio;
    HAudioheader : TAudioheader;
    Variablen : ARRAY OF STRING;

BEGIN

    I-Frame suchen
    P-Frame suchen
    Segment kopieren (inklusive der Header)
    D2V-Datei erzeugen
    Effekt aufrufen
    neues Stück kopieren

  Result := 0;
//  IF Assigned(Textanzeige) THEN
//    Textanzeige(4, TextString);
  IF NOT Anhalten THEN
  BEGIN
    AnfangsIndex := AnfangsIndex + ParameterausTextInt(EffektDaten.Parameter, 'FramesamAnfang', '=', ';', 0);
    EndIndex := EndIndex + ParameterausTextInt(EffektDaten.Parameter, 'FramesamEnde', '=', ';', 0);
    IF AnfangsIndex < 0 THEN                                     // AnfangsIndex prüfen und eventuell
      AnfangsIndex := 0;                                         // auf Null setzen
    IF EndIndex > IndexListe.Count - 1 THEN                      // EndIndex prüfen und eventuell
      EndIndex := IndexListe.Count - 1;                          // auf maximalen Wert setzen
    IF (AnfangsIndex < EndIndex + 1) AND                         // Anfang liegt vor dem Ende
       (EffektDaten.ProgrammName <> '') AND                      // Effektprogramm ist vorhanden
       (EffektLaenge <> 0) THEN                                  // Effektlänge ist vorhanden
    BEGIN
      Laenge := Trunc((EndIndex + 1 - AnfangsIndex) * BildlaengeausSeqHeaderFramerate(SequenzHeader.Framerate));
      TeilDateiname := Zwischenverzeichnis + 'Effekt-' + ExtractFileName(ChangeFileExt(DateiName, '')) + '-' + IntToStr(AnfangsIndex) + '-' + IntToStr(EndIndex) + ExtractFileExt(Dateiname);
      EffektDateiname := Zwischenverzeichnis + 'Effekt-' + EffektDaten.EffektName + '-' + ExtractFileName(ChangeFileExt(DateiName, '')) + '-' + IntToStr(AnfangsIndex) + '-' + IntToStr(EndIndex) + ExtractFileExt(Dateiname);
      SetLength(Variablen, 20);
      Variablen[0] := '$AudioFile#';
      Variablen[1] := TeilDateiname;
      Variablen[2] := '$EffectAudioFile#';
      Variablen[3] := EffektDateiname;
      Variablen[4] := '$OverallLength#';
      Variablen[5] := IntToStr(EffektLaenge);
      Variablen[6] := '$FileLength#';
      Variablen[7] := IntToStr(Laenge);
      Variablen[8] := '$Samplerate#';
      Variablen[9] := IntToStr(Audioheader.Samplerateberechnet);
      Variablen[10] := '$Bitrate#';
      Variablen[11] := IntToStr(Audioheader.Bitrateberechnet);
      Variablen[12] := '$Protection#';
      IF Audioheader.Protection THEN
        Variablen[13] := 'e';
      Variablen[14] := '$Privat#';
      IF Audioheader.Privat THEN
        Variablen[15] := 'o';
      Variablen[16] := '$Copyright#';
      IF Audioheader.Copyright THEN
        Variablen[17] := 'c';
      Variablen[18] := '$Mode#';
      IF Audioheader.Audiotyp = 2 THEN
        CASE AudioHeader.Mode OF
          0: Variablen[19] := 's';
          1: Variablen[19] := 'j';
          2: Variablen[19] := 'd';
          3: Variablen[19] := 'm';
        END;
      IF Audioheader.Audiotyp = 3 THEN
        CASE AudioHeader.ModeErweiterung OF
          0: Variablen[19] := '1+1';
          1: Variablen[19] := '1/0';
          2: Variablen[19] := '2/0';
          3: Variablen[19] := '3/0';
          4: Variablen[19] := '2/1';
          5: Variablen[19] := '3/1';
          6: Variablen[19] := '2/2';
          7: Variablen[19] := '3/2';
        END;
      VariablenZaehler := High(Variablen) + 1;
      VariablenZahl := VariablenZahlausText(EffektParameter, '=', ';');
      SetLength(Variablen, VariablenZaehler + VariablenZahl * 2);
      VariablenausText(EffektParameter, '=', ';', Variablen, VariablenZaehler);
      ProgrammParameter := VariablenersetzenText(EffektDaten.ProgrammParameter, Variablen);
      ProgrammParameter := VariablenentfernenText(ProgrammParameter);
      VariablenersetzenDatei(EffektDaten.OrginalparameterDatei, EffektDaten.ParameterDateiName, Variablen);
      VariablenentfernenDatei(EffektDaten.ParameterDateiName);
   //           Showmessage(Meldunglesen(NIL, 'Meldung132', ZielDateistream.Dateiname, 'Die Datei $Text1# konnte nicht erzeugt werden.'));
   //     Showmessage(Meldunglesen(NIL, 'Meldung114', QuellDateistream.DateiName, 'Die Datei $Text1# läßt sich nicht öffnen.'));
      HDateistream := TDateiPuffer.Create(TeilDateiname, fmCreate);
      TRY
        HDateistream.Pufferfreigeben;
        FehlerNr := KopiereSegmentDatei(TAudioheaderklein(Liste[AnfangsIndex]).Adresse,
                                        TAudioheaderklein(Liste[EndIndex + 1]).Adresse - 1,
                                        Dateistream, HDateistream);
      FINALLY
        HDateistream.Free;
      END;
      IF FehlerNr = 0 THEN
      BEGIN
        aktVerzeichnis := GetCurrentDir;
        SetCurrentDir(ExtractFilePath(EffektDaten.ProgrammName));
        IF Unterprogramm_starten(EffektDaten.ProgrammName + ' ' + ProgrammParameter , True) THEN
        BEGIN
          HAudioheader := TAudioheader.Create;
          TRY
            MpegAudio := TMpegAudio.Create;
            TRY
              FehlerNr := MpegAudio.DateiOeffnen(EffektDateiname);
              IF FehlerNr = 0 THEN
              BEGIN
                FehlerNr := MpegAudio.DateiInformationLesen(HAudioheader); // Audioheader auslesen
                IF FehlerNr = 0 THEN
                BEGIN
                END
                ELSE
                BEGIN
                  Anhalten := True;
                  Result := FehlerNr;
                  CASE FehlerNr OF
                    -1: Fehlertext := '';
                  ELSE
                    Fehlertext := '';
                  END;
                END;
              END
              ELSE
              BEGIN
                Anhalten := True;
                Result := FehlerNr;
                CASE FehlerNr OF
                  -1: Fehlertext := '';
                ELSE
                  Fehlertext := '';
                END;
              END;
            FINALLY
              MpegAudio.Free;
            END;
            IF FehlerNr = 0 THEN
            BEGIN
              HDateistream := TDateiPuffer.Create(EffektDateiname, fmOpenRead);
              TRY
                HDateistream.Pufferfreigeben;
                AnfangsIndex := ParameterausTextInt(EffektDaten.Parameter, 'EffektFamAnfang', '=', ';', 0) * HAudioheader.Framelaenge;
                EndIndex := HDateistream.Dateigroesse - 1 + (ParameterausTextInt(EffektDaten.Parameter, 'EffektFamEnde', '=', ';', 0) * HAudioheader.Framelaenge);
                FehlerNr := KopiereSegmentDatei(AnfangsIndex, EndIndex,
                                                HDateistream, Speicherstream);
              FINALLY
                HDateistream.Free;
              END;
              IF FehlerNr = 0 THEN
              BEGIN
                Indexlistefuellen(AnfangsIndex, EndIndex, HAudioheader);
              END
              ELSE
              BEGIN
                Anhalten := True;
                Result := FehlerNr;
                CASE FehlerNr OF
                  -1: Fehlertext := '';
                ELSE
                  Fehlertext := '';
                END;
              END;
            END;
          FINALLY
            HAudioheader.Free;
          END;
        END
        ELSE
        BEGIN
          Anhalten := True;
          Result := -10;
          CASE FehlerNr OF
            -1: Fehlertext := '';
          ELSE
            Fehlertext := '';
          END;
        END;
        SetCurrentDir(aktVerzeichnis);
      END
      ELSE
      BEGIN
        Anhalten := True;
          Result := FehlerNr;
        CASE FehlerNr OF
          -1: Fehlertext := '';
        ELSE
          Fehlertext := '';
        END;
      END;
//      DeleteFile(TeilDateiname);
//      DeleteFile(EffektDateiname);
    END;
  END;
END;

VAR Datei : TStringList;
    I, J, K : Integer;
    HAusgabeprogramm,
    HAusgabedatei,
    HZieldatei,
    HAusgabeparameter,
    Dateiname : STRING;

BEGIN
  IF Encoderprogramm <> '' THEN
    IF FileExists(Encoderprogramm) THEN
      IF (Encoderorginaldatei <> '') OR (EncoderParameter <> '') THEN
      BEGIN
        Dateiname := mitPathtrennzeichen(EncoderVerzeichnis) + ChangeFileExt(ExtractFileName(Schnittpunkt.Videoname); '') +
                     IntToStr(Anfang) + '_' + IntToStr(Ende) + ExtractFileExt(Schnittpunkt.Videoname);
        IF NOT FileExists(Dateiname) THEN
        BEGIN
          IF Encoderorginaldatei <> '' THEN
          BEGIN
            Datei := TStringList.Create;
            TRY
              Datei.LoadFromFile(Encoderorginaldatei);
              Datei.Text := AnsiReplaceText(Datei.Text, '$Zieldatei#', HZieldatei);
              Datei.SaveToFile(Encoderdatei);
            FINALLY
              Datei.Free;
            END;  
          END;
          IF EncoderParameter <> '' THEN
          BEGIN
            EncoderParameter := AnsiReplaceText(EncoderParameter, '$Zieldatei#', HZieldatei);
          END;
        END;
      END
      ELSE
        Result := -1                 // keine Möglichkeit Parameter zu übergeben
    ELSE
      Result := -2                   // Encoderprogramm nicht vorhanden
  ELSE
    Result := -3;                    // kein Encoderprogramm angegeben

END;

FUNCTION TVideoschnitt.Schneiden(SchnittListe: TStrings): Integer;

VAR I : Integer;
    GH, SH : LongInt;
    Schnittpunkt,
    Schnittpunkt2 : TSchnittpunkt;
    BildIndex : TBildIndex;
    Listenpunkt : THeaderklein;
    BildNr, J : Word;
    AnfangsIndex : Integer;
    Anfang, Ende : Integer;
    DateiName : STRING;
    Videoschneiden : Boolean;

BEGIN
  Result := 0;
  AdressDiff := 0;
  BildDiff := 0;
  BildZaehler := 0;
  Videoschnittanhalten := False;
  Anhalten := False;
  ersterSequenzHeader := True;
  IF Assigned(FortschrittsEndwert) THEN
    FortschrittsEndwert^ := 0;
  FortschrittsPosition := 0;
// ------------ Testen ob alle Schnitte mit Videodateinamen belegt sind --------
  Videoschneiden := True;
  I := 0;
  WHILE (I < SchnittListe.Count) AND Videoschneiden DO
  BEGIN
    Schnittpunkt := TSchnittpunkt(SchnittListe.Objects[I]);                // X. Schnitt
    IF Assigned(FortschrittsEndwert) THEN
      FortschrittsEndwert^ := FortschrittsEndwert^ + Schnittpunkt.VideoGroesse;
    IF Schnittpunkt.VideoName <> '' THEN
    BEGIN
    // Hier könnte man testen ob alle Videodateien die gleichen Eigenschaften haben
    END
    ELSE
      Videoschneiden := False;
    Inc(I);
  END;
  IF Videoschneiden AND (I > 0) THEN
  BEGIN
    Speicherstream := TDateipuffer.Create(Zieldateiname, fmCreate);
    IF Speicherstream.DateiMode <> fmCreate THEN
    BEGIN
      Anhalten := True;
      Result := -5;                                                        // Zieldatei nicht geöffnet
    END
    ELSE
      Anhalten := False;
    I := 0;                                                                // Schnittzähler
    WHILE (I < SchnittListe.Count) AND (NOT Anhalten) DO
    BEGIN
      Schnittpunkt := TSchnittpunkt(SchnittListe.Objects[I]);              // X. Schnitt
      TextString := IntToStr(I+1) + ' (' + Schnittpunkt.VideoName + ')';
      Quelldateioeffnen(Schnittpunkt);
      IF Liste.Count = 0 THEN                                              // Anwender hat beim erstellen der Liste auf Abbrechen gedrückt
      BEGIN
        Anhalten := True;
      END
      ELSE
      BEGIN
        erstesBild := True;
        IF Framegenau_schneiden THEN
          IF (Schnittpunkt.Anfangberechnen AND $80) = $80 THEN
          BEGIN
            Anfang := Bildsuchen(1, Schnittpunkt.Anfang, IndexListe);      // nächstgelegenes I-Frame suchen
            Schnittpunkt.Anfang := Anfang;
          END
          ELSE
          BEGIN
            Anfang := NaechstesBild(1, Schnittpunkt.Anfang, IndexListe);     // nächstes I-Frame suchen
    //        Videoteil_berechnen(Schnittpunkt.Anfang, Anfang - 1, Schnittpunkt);
          END
        ELSE
        BEGIN
          Anfang := Bildsuchen(1, Schnittpunkt.Anfang, IndexListe);        // nächstgelegenes I-Frame suchen
          Schnittpunkt.Anfang := Anfang;
        END;
        BildIndex := IndexListe[Anfang];
        GH := LongInt(BildIndex.BildIndex);                                // GH = Gruppenheader
        Listenpunkt := Liste[BildIndex.BildIndex];
        REPEAT                                                             // Gruppenheader suchen
          Dec(GH);
          IF NOT(GH < 0) THEN
            Listenpunkt := Liste[GH];
        UNTIL (Listenpunkt.HeaderTyp = GruppenStartCode) OR (GH < 0);
        IF Listenpunkt.HeaderTyp = GruppenStartCode THEN                   // Gruppenheader gefunden
        BEGIN
          SH := GH - 1;                                                    // SH = Sequenzheader
          IF NOT(SH < 0) THEN                                              // vor dem Gruppenheader ist noch Platz
            Listenpunkt := Liste[SH];
          IF NOT(Listenpunkt.HeaderTyp = SequenceStartCode) THEN           // kein Sequenzheader gefunden
          BEGIN
            IF ersterSequenzHeader THEN
            BEGIN
              REPEAT                                                       // Sequenzheader vor dem ersten Bild suchen
                Dec(SH);
                IF NOT(SH < 0) THEN
                  Listenpunkt := Liste[SH];
              UNTIL (Listenpunkt.HeaderTyp = SequenceStartCode) OR (SH < 0);
              IF NOT(Listenpunkt.HeaderTyp = SequenceStartCode) THEN       // kein Sequenzheader gefunden
              BEGIN
                SH := GH + 1;
                REPEAT                                                     // Sequenzheader nach dem ersten Bild suchen
                  Inc(SH);
                  IF SH < Liste.Count THEN
                    Listenpunkt := Liste[SH];
                UNTIL (Listenpunkt.HeaderTyp = SequenceStartCode) OR (SH > Liste.Count -1);
                IF NOT(Listenpunkt.HeaderTyp = SequenceStartCode) THEN
                  SH := -1;                                                // kein Sequenzheader gefunden
              END;
            END
            ELSE
              SH := -1;                                                    // kein Sequenzheader gefunden
          END;
          IF NOT(NOT(Listenpunkt.HeaderTyp = SequenceStartCode) AND ersterSequenzHeader) THEN
          BEGIN
            AnfangsIndex := BildIndex.BildIndex;
            Listenpunkt := Liste[BildIndex.BildIndex];
            IF Listenpunkt.HeaderTyp = BildStartCode THEN                  // der Anfangsindex muß auf ein Bild zeigen
            BEGIN
              BildNr := Listenpunkt.TempRefer;
              J := 0;
              REPEAT                                                       // nächstes Bild mit höherem Temprefer suchen
                Inc(J);
                IF BildIndex.BildIndex + J < LongWord(Liste.Count) THEN
                  Listenpunkt := Liste[BildIndex.BildIndex + J];
              UNTIL (Listenpunkt.TempRefer > BildNr) OR (NOT(Listenpunkt.HeaderTyp = BildStartCode)) OR (BildIndex.BildIndex + J > LongWord(Liste.Count -1));
              IF SH > -1 THEN
                KopiereSegment(False, SH, SH, Schnittpunkt.Framerate, False); // Sequenzheader kopieren und korrigieren (Bitrate)
              KopiereSegment(J > 1, GH, GH, Schnittpunkt.Framerate, False); // Gruppenheader kopieren und korrigieren (Timecode)
              IF J > 1 THEN                                                // nach dem Anfangsbild stehen Bilder mit kleinerer Temprefer
              BEGIN                                                        // diese Bilder müssen entfernt und die Tempreferenzen der Gruppe neu geschrieben werden
                KopiereSegment(True, BildIndex.BildIndex, BildIndex.BildIndex, Schnittpunkt.Framerate, False);  // erstes Bild kopieren und korrigieren (Tempreferenz)
                AnfangsIndex := BildIndex.BildIndex + J;
              END;
              J := 0;
              WHILE (I + 1 < SchnittListe.Count) AND (J = 0) DO            // zusammengehörende Schnittpunkte überspringen
              BEGIN
                Schnittpunkt2 := TSchnittpunkt(SchnittListe.Objects[I + 1]);
                IF (Schnittpunkt.VideoName = Schnittpunkt2.VideoName) AND
                   (Schnittpunkt.Ende = Schnittpunkt2.Anfang - 1) THEN
                BEGIN
                  Schnittpunkt := Schnittpunkt2;                           // die Schnittpunkte passen zusammen
                  Inc(I);                                                  // nächsten Schnittpunkt versuchen
                END
                ELSE
                  J := 1;                                                  // die Schnittpunkte passen nicht zusammen
              END;
              IF Framegenau_schneiden THEN
                IF (Schnittpunkt.Endeberechnen AND $80) = $80 THEN
                BEGIN
                  Ende := Bildsuchen(2, Schnittpunkt.Ende, IndexListe);   // nächstgelegenes I-, oder P-Frame suchen
                  Schnittpunkt.Ende := Ende;
                END
                ELSE
                BEGIN
                  Ende := VorherigesBild(2, Schnittpunkt.Ende, IndexListe); // vorheriges I-, oder P-Frame suchen
    //              Videoteil_berechnen(Ende + 1, Schnittpunkt.Ende, Schnittpunkt);
                END
              ELSE
              BEGIN
                Ende := Bildsuchen(2, Schnittpunkt.Ende, IndexListe);     // nächstgelegenes I-, oder P-Frame suchen
                Schnittpunkt.Ende := Ende;
              END;
              BildIndex := IndexListe[Ende];
              Listenpunkt := Liste[BildIndex.BildIndex];
              IF (Listenpunkt.HeaderTyp = BildStartCode) THEN             // der Endindex muß auf ein Bild zeigen
              BEGIN
                BildNr := Listenpunkt.TempRefer;                          // TempReferenz des letzten Bildes
                J := 0;
                REPEAT
                  Inc(J);                                                 // letztes Bild mit kleinerer Temprefer suchen
                  IF BildIndex.BildIndex + J < LongWord(Liste.Count) THEN
                    Listenpunkt := Liste[BildIndex.BildIndex + J];
                UNTIL (BildNr < Listenpunkt.TempRefer) OR (NOT(Listenpunkt.HeaderTyp = BildStartCode)) OR (BildIndex.BildIndex + J > LongWord(Liste.Count) - 1);
                  KopiereSegment(False, AnfangsIndex, BildIndex.BildIndex + J - 1, Schnittpunkt.Framerate, True); // Dateiteil kopieren und korrigieren (Tempreferenz und Timecode)
              END
              ELSE
                Result := -4;                                             // am Ende des Schnittes muß ein Bildheader stehen
            END
            ELSE
              Result := -3;                                               // der Schnitt muß mit einem Bildheader beginnen
          END
          ELSE
            Result := -2                                                  // in der Datei muß mindestens ein Sequenzheader vorhanden sein
        END
        ELSE
          Result := -1;                                                   // vor dem Anfangsschnitt muß ein Gruppenheader stehen
      END;
      Inc(I);                                                             // nächster Schnitt
    END;
    SequenzEndeanhaengen;
    IF Anhalten OR (Result < 0) THEN                                      // Abbruch durch Anwender oder Fehler
    BEGIN
      DateiName := Zieldateiname;                                         // Dateiname merken
      NeueListe.Loeschen;                                                 // neue Liste löschen, dadurch wird keine *.idd Datei gespeichert
      Zieldateischliessen;                                                // erzeugte Datei schliessen
      IF FileExists(DateiName) THEN                                       // und löschen
        DeleteFile(DateiName);
      Videoschnittanhalten := True;                                       // globale Variable, sagt weiteren Proceduren das Schluss ist
      IF Result = 0 THEN
        Result := -6;                                                     // Fehler in aufgerufener Prozedur oder Abbruch durch Anwender
    END;
  END;
END;

FUNCTION TVideoschnitt.KopiereVideoteil(AnfangsIndex, EndIndex: Int64): Integer;

VAR I : Integer;
    GH, SH : LongInt;
    Schnittpunkt,
    Schnittpunkt2 : TSchnittpunkt;
    BildIndex : TBildIndex;
    Listenpunkt : THeaderklein;
    BildNr, J : Word;
    Anfang, Ende : Integer;
    DateiName : STRING;

BEGIN
  Result := 0;
// Bildtypen prüfen?
  BildIndex := IndexListe[AnfangsIndex];
  GH := LongInt(BildIndex.BildIndex);                                // GH = Gruppenheader
  REPEAT                                                             // Gruppenheader suchen
    Listenpunkt := Liste[GH];
    Dec(GH);
  UNTIL (Listenpunkt.HeaderTyp = GruppenStartCode) OR (GH < 0);
  IF Listenpunkt.HeaderTyp = GruppenStartCode THEN                   // Gruppenheader gefunden
  BEGIN
    SH := GH - 1;                                                    // SH = Sequenzheader
    IF SH > -1 THEN                                                  // vor dem Gruppenheader ist noch Platz
      Listenpunkt := Liste[SH];
    IF NOT(Listenpunkt.HeaderTyp = SequenceStartCode) THEN           // direkt vor dem Gruppenheader steht kein Sequenzheader
    BEGIN
      IF ersterSequenzHeader THEN
      BEGIN
        REPEAT                                                       // Sequenzheader vor dem ersten Bild suchen
          Listenpunkt := Liste[SH];
          Dec(SH);
        UNTIL (Listenpunkt.HeaderTyp = SequenceStartCode) OR (SH < 0);
        IF NOT(Listenpunkt.HeaderTyp = SequenceStartCode) THEN       // vor dem ersten Bild kein Sequenzheader gefunden
        BEGIN
          SH := GH;
          REPEAT                                                     // Sequenzheader nach dem ersten Bild suchen
            Listenpunkt := Liste[SH];
            Inc(SH);
          UNTIL (Listenpunkt.HeaderTyp = SequenceStartCode) OR (SH > Liste.Count -1);
          IF NOT(Listenpunkt.HeaderTyp = SequenceStartCode) THEN
            SH := -1;                                                // kein Sequenzheader gefunden
        END;
      END
      ELSE
        SH := -1;                                                    // kein Sequenzheader gefunden
    END;
    IF NOT(NOT(Listenpunkt.HeaderTyp = SequenceStartCode) AND ersterSequenzHeader) THEN
    BEGIN
      AnfangsIndex := BildIndex.BildIndex;
      Listenpunkt := Liste[BildIndex.BildIndex];
      IF Listenpunkt.HeaderTyp = BildStartCode THEN                  // der Anfangsindex muß auf ein Bild zeigen
      BEGIN
        BildNr := Listenpunkt.TempRefer;
        J := 0;
        REPEAT                                                       // nächstes Bild mit höherem Temprefer suchen
          Inc(J);
          IF BildIndex.BildIndex + J < LongWord(Liste.Count) THEN
            Listenpunkt := Liste[BildIndex.BildIndex + J];
        UNTIL (Listenpunkt.TempRefer > BildNr) OR (NOT(Listenpunkt.HeaderTyp = BildStartCode)) OR (BildIndex.BildIndex + J > LongWord(Liste.Count -1));
        IF SH > -1 THEN
          KopiereSegment(False, SH, SH, Schnittpunkt.Framerate, False); // Sequenzheader kopieren und korrigieren (Bitrate)
        KopiereSegment(J > 1, GH, GH, Schnittpunkt.Framerate, False); // Gruppenheader kopieren und korrigieren (Timecode)
        IF J > 1 THEN                                                // nach dem Anfangsbild stehen Bilder mit kleinerer Temprefer
        BEGIN                                                        // diese Bilder müssen entfernt und die Tempreferenzen der Gruppe neu geschrieben werden
          KopiereSegment(True, BildIndex.BildIndex, BildIndex.BildIndex, Schnittpunkt.Framerate, False);  // erstes Bild kopieren und korrigieren (Tempreferenz)
          AnfangsIndex := BildIndex.BildIndex + J;
        END;
        J := 0;
        WHILE (I + 1 < SchnittListe.Count) AND (J = 0) DO            // zusammengehörende Schnittpunkte überspringen
        BEGIN
          Schnittpunkt2 := TSchnittpunkt(SchnittListe.Objects[I + 1]);
          IF (Schnittpunkt.VideoName = Schnittpunkt2.VideoName) AND
             (Schnittpunkt.Ende = Schnittpunkt2.Anfang - 1) THEN
          BEGIN
            Schnittpunkt := Schnittpunkt2;                           // die Schnittpunkte passen zusammen
            Inc(I);                                                  // nächsten Schnittpunkt versuchen
          END
          ELSE
            J := 1;                                                  // die Schnittpunkte passen nicht zusammen
        END;
        IF Framegenau_schneiden THEN
          IF (Schnittpunkt.Endeberechnen AND $80) = $80 THEN
          BEGIN
            Ende := Bildsuchen(2, Schnittpunkt.Ende, IndexListe);   // nächstgelegenes I-, oder P-Frame suchen
            Schnittpunkt.Ende := Ende;
          END
          ELSE
          BEGIN
            Ende := VorherigesBild(2, Schnittpunkt.Ende, IndexListe); // vorheriges I-, oder P-Frame suchen
    //          Videoteil_berechnen(Ende + 1, Schnittpunkt.Ende, Schnittpunkt);
          END
        ELSE
        BEGIN
          Ende := Bildsuchen(2, Schnittpunkt.Ende, IndexListe);     // nächstgelegenes I-, oder P-Frame suchen
          Schnittpunkt.Ende := Ende;
        END;
        BildIndex := IndexListe[Ende];
        Listenpunkt := Liste[BildIndex.BildIndex];
        IF (Listenpunkt.HeaderTyp = BildStartCode) THEN             // der Endindex muß auf ein Bild zeigen
        BEGIN
          BildNr := Listenpunkt.TempRefer;                          // TempReferenz des letzten Bildes
          J := 0;
          REPEAT
            Inc(J);                                                 // letztes Bild mit kleinerer Temprefer suchen
            IF BildIndex.BildIndex + J < LongWord(Liste.Count) THEN
              Listenpunkt := Liste[BildIndex.BildIndex + J];
          UNTIL (BildNr < Listenpunkt.TempRefer) OR (NOT(Listenpunkt.HeaderTyp = BildStartCode)) OR (BildIndex.BildIndex + J > LongWord(Liste.Count) - 1);
            KopiereSegment(False, AnfangsIndex, BildIndex.BildIndex + J - 1, Schnittpunkt.Framerate, True); // Dateiteil kopieren und korrigieren (Tempreferenz und Timecode)
        END
        ELSE
          Result := -4;                                             // am Ende des Schnittes muß ein Bildheader stehen
      END
      ELSE
        Result := -3;                                               // der Schnitt muß mit einem Bildheader beginnen
    END
    ELSE
      Result := -2                                                  // in der Datei muß mindestens ein Sequenzheader vorhanden sein
  END
  ELSE
    Result := -1;                                                   // vor dem Anfangsschnitt muß ein Gruppenheader stehen
END;

PROCEDURE TVideoschnitt.KopiereSegment(geaendert: Boolean; AnfangsIndex, EndIndex: LongWord; Framerate: Real; anzeigen: Boolean);

VAR Menge,
    Groesse,
    aktAdresse,
    PufferAdr,
    AnfAdrDatei,
    AnfAdrSpeicher : Int64;
    Puffer : PChar;
    I, J : LongWord;
    Listenpunkt,
    Headerklein : THeaderklein;
    Tempreferenz : Word;
    Zeit : TTimecode;
    Bitrate : Longword;
//    SchleifenAnfangsZeit, SchleifenEndeZeit : TDateTime;     // zum messen der Schleifendauer

BEGIN
  Groesse := 0;
  IF Assigned(Textanzeige) AND anzeigen THEN
    Textanzeige(4, TextString);
//  IF Assigned(FortschrittsEndwert) AND anzeigen THEN
//    FortschrittsEndwert^ := THeaderklein(Liste[EndIndex]).Adresse -
//                            THeaderklein(Liste[AnfangsIndex]).Adresse + 1; 
//    FortschrittsEndwert^ := EndIndex - AnfangsIndex + 1;
//  SchleifenAnfangsZeit := Time;                              // zum messen der Schleifenzeit
  IF EndIndex > LongWord(Liste.Count) - 2 THEN                 // EndIndex prüfen und eventuell
    EndIndex := LongWord(Liste.Count) - 2;                     // auf maximalen Wert setzen
  IF (AnfangsIndex < LongWord(Liste.Count) - 1) AND            // AnfangsIndex prüfen, ist er größer
     (AnfangsIndex < EndIndex + 1) THEN                        // es muß mindestens ein Bild kopiert werden
  BEGIN                                                        // als die Liste -1 nicht kopieren
    AnfAdrSpeicher := Speicherstream.AktuelleAdr;              // Startadresse der Zieldatei merken
    GetMem(Puffer, 1048576);                                   // 1 MByte
    I := AnfangsIndex;                                         // Zähler setzen zum Header suchen
    J := AnfangsIndex;                                         // Zähler setzen zum Header korrigieren
    Listenpunkt := Liste[I];
    aktAdresse := Listenpunkt.Adresse;                         // Startadresse zum kopieren
    AnfAdrDatei := aktAdresse;                                 // Startadresse der Quelldatei merken
    Dateistream.NeuePosition(aktAdresse);
    REPEAT
      REPEAT                                                   // Header suchen der gerade nooch in den Block passt
        Inc(I);
        IF I + 1 < LongWord(Liste.Count) THEN                  // am Ende der Liste kann man nicht auf den nächsten Header zugreifen
          Listenpunkt := Liste[I + 1];                         // die Endadresse eines Headers/Bildes ist die Anfangsadresse des nächsten Headers
      UNTIL ((Listenpunkt.Adresse - aktAdresse) > 1048576) OR  // der nächste Header passt nicht mehr in den Puffer
             (I > EndIndex);                                   // Ende des Abschnitts
      Listenpunkt := Liste[I];
      IF Listenpunkt.Adresse - aktAdresse > 1048576 THEN       // Fehler in alten Indexdateien
      BEGIN
        Meldungsfenster(Wortlesen(NIL, 'Meldung84', 'Der zu kopierende Teil der Datei passt nicht in den Kopierpuffer.') + Chr(13) +
                        Meldunglesen(NIL, 'Meldung85', Dateiname, 'Eventuell hilft es von der Datei $Text1# eine neue Indexdatei zu erstellen.'));
        Anhalten := True;
      END;
      IF NOT Anhalten THEN
      BEGIN
        Groesse := Listenpunkt.Adresse - aktAdresse;
        Menge := Dateistream.LesenDirekt(Puffer^, Groesse);
        IF Menge < Groesse THEN
        BEGIN
          IF Menge < 0 THEN
            Meldungsfenster(Meldunglesen(NIL, 'Meldung114', Dateiname, 'Die Datei $Text1# läßt sich nicht öffnen.'))
          ELSE
            Meldungsfenster(Meldunglesen(NIL, 'Meldung122', Dateiname, 'Die Datei $Text1# ist scheinbar zu kurz.'));
          Anhalten := True;
        END;
      END;
    // Abschnitt korrigieren, Indexdatei erstellen ---------------------------------------------
      IF NOT Anhalten THEN
      BEGIN
        REPEAT
          Listenpunkt := Liste[J];
          IF IndexDatei_erstellen OR D2VDatei_erstellen THEN    // Wenn eine neue Indexdatei erstellt werden soll,
          BEGIN
            Headerklein := THeaderklein.Create;                 // neuen Listenpunkt erzeugen,
            Headerklein.HeaderTyp := Listenpunkt.HeaderTyp;     // Headertyp eintragen,
            Headerklein.Adresse   := Listenpunkt.Adresse - AnfAdrDatei + AnfAdrSpeicher; // neue Adresse berechnen,
            NeueListe.Add(Headerklein);                         // und zur Liste hinzufügen.
          END
          ELSE
            Headerklein := NIL;
          IF Listenpunkt.HeaderTyp = BildStartCode THEN
          BEGIN
            Inc(BildZaehler);                                   // Bildzähler erhöhen
            IF erstesBild  THEN                                 // Ist das Bild das erste Bild im Abschnitt
            BEGIN                                               // muß eventuell die Tempreferenz neu geschrieben werden
              erstesBild := False;
              BildDiff := Listenpunkt.TempRefer                 // Bilddifferenz zum ersten kopierten Bild
            END;
            IF BildDiff > 0 THEN                                // TempReferenz neu schreiben
            BEGIN
              Tempreferenz := Listenpunkt.TempRefer - BildDiff;
              Byte(Puffer[Listenpunkt.Adresse - aktAdresse + 4]) := Tempreferenz SHR 2;
                                                                // Bit 10 - 2 von 10 Bit Tempref
              Byte(Puffer[Listenpunkt.Adresse - aktAdresse + 5]) := ((Tempreferenz AND $0003) SHL 6) OR
                                                                // Bit 1 und 0 von 10 Bit Tempref
                                           (Byte(Puffer[Listenpunkt.Adresse - aktAdresse + 5]) AND $3F);
                                                                // Bildtype (Bit 5, 4 und 3) und 3 Bit von VBVDelay
            END;
            IF (IndexDatei_erstellen  OR D2VDatei_erstellen) AND Assigned(Headerklein) THEN
            BEGIN
              Headerklein.TempRefer := Listenpunkt.TempRefer - BildDiff;  // Tempreferenz eintragen
              Headerklein.BildTyp   := Listenpunkt.BildTyp;               // Bildtyp eintragen
              IF D2VDatei_erstellen THEN
              BEGIN
                PufferAdr := Listenpunkt.Adresse - aktAdresse + 8;
                WHILE NOT((Byte(Puffer[PufferAdr]) = 0) AND (Byte(Puffer[PufferAdr + 1]) = 0) AND (Byte(Puffer[PufferAdr + 2]) = 1)) DO
                  Inc(PufferAdr);                                         // nächsten Startcode suchen
                IF (Byte(Puffer[PufferAdr + 3]) = $B5) AND ((Byte(Puffer[PufferAdr + 4]) AND $F0) = $80) THEN
                BEGIN                                                     // erweiterter Startcode mit "Picture coding extension"
                  Inc(PufferAdr, 7);
                  IF (Byte(Puffer[PufferAdr]) AND $80) = $80 THEN         // oberstes Bild zuerst
                    Headerklein.BildTyp := Headerklein.BildTyp OR $80;
                  IF (Byte(Puffer[PufferAdr]) AND $02) = $02 THEN         // repeat_first_field
                    Headerklein.BildTyp := Headerklein.BildTyp OR $40;
                END;
              END;
            END;
          END;
          IF Listenpunkt.HeaderTyp = GruppenStartCode THEN
          BEGIN
            BildDiff := 0;                                        // Bilddifferenz zurücksetzen
            IF Timecode_korrigieren THEN
            BEGIN
              Zeit.Stunde := Trunc(BildZaehler / 90000);          // Timecode aus Bildzähler berechnen
              Zeit.Minute := Trunc((BildZaehler - Zeit.Stunde * 90000) / 1500);
              Zeit.Sekunde := Trunc((BildZaehler - Zeit.Stunde * 90000 - Zeit.Minute * 1500) / Framerate);
              Zeit.Bilder := Round(BildZaehler - Zeit.Stunde * 90000 - Zeit.Minute * 1500 - Zeit.Sekunde * Framerate);
              Byte(Puffer[Listenpunkt.Adresse - aktAdresse + 4]) := (Byte(Puffer[Listenpunkt.Adresse - aktAdresse + 4]) AND $80) OR
                                                                  // 1 Bit Dropframe
                          ((Zeit.Stunde AND $3F) SHL 2) OR        // 5 Bit Stunde
                          ((Zeit.Minute AND $30) SHR 4);          // 2 Bit von Minute
              Byte(Puffer[Listenpunkt.Adresse - aktAdresse + 5]) := (Byte(Puffer[Listenpunkt.Adresse - aktAdresse + 5]) AND $08) OR
                                                                  // 1 Bit Marker
                          ((Zeit.Minute AND $0F) SHL 4) OR        // 4 Bit von Minute
                          ((Zeit.Sekunde AND $38) SHR 3);         // 3 Bit von Sekunde
              Byte(Puffer[Listenpunkt.Adresse - aktAdresse + 6]) := ((Zeit.Sekunde AND $07) SHL 5) OR
                                                                  // 3 Bit von Sekunde
                          ((Zeit.Bilder AND $3E) SHR 1);          // 5 Bit von Bild
              Byte(Puffer[Listenpunkt.Adresse - aktAdresse + 7]) := ((Zeit.Bilder AND $01) SHL 7) OR
                                                                  // 1 Bit von Bild
                          ((Byte(geaendert) SHL 6) OR             // wenn geändert dann Closed Group
                          (Byte(Puffer[Listenpunkt.Adresse - aktAdresse + 7]) AND $40)) OR
                                                                  // oder Orginalbit Closed Group
                          (Byte(Puffer[Listenpunkt.Adresse - aktAdresse + 7]) AND $20);
                                                                  // Bit für broken Link
            END;
          END;
          IF (Listenpunkt.HeaderTyp = SequenceStartCode) AND Bitrate_korrigieren AND ersterSequenzHeader THEN
          BEGIN
            ersterSequenzHeader := False;
            IF festeBitrate <> 0 THEN
              Bitrate := Round(festeBitrate / 400)
            ELSE
              Bitrate := Round(SequenzHeader.Bitrate / 400);
            PufferAdr := Listenpunkt.Adresse - aktAdresse + 8;
            Byte(Puffer[PufferAdr]) := (Bitrate AND $3FC00) SHR 10;
            Inc(PufferAdr);
            Byte(Puffer[PufferAdr]) := (Bitrate AND $3FC) SHR 2;
            Inc(PufferAdr);
            Byte(Puffer[PufferAdr]) := (Byte(Puffer[PufferAdr]) AND $3F) OR ((Bitrate AND $03) SHL 6);
            Inc(PufferAdr);
            IF (Byte(Puffer[PufferAdr]) AND $02) = 2 THEN
              Inc(PufferAdr, 64);
            IF (Byte(Puffer[PufferAdr]) AND $01) = 1 THEN
              Inc(PufferAdr, 65)
            ELSE
              Inc(PufferAdr);
            IF (Byte(Puffer[PufferAdr]) = 0) AND (Byte(Puffer[PufferAdr + 1]) = 0) AND (Byte(Puffer[PufferAdr + 2]) = 1) AND
               (Byte(Puffer[PufferAdr + 3]) = $B5) AND ((Byte(Puffer[PufferAdr + 4]) AND $F0) = $10) THEN
            BEGIN
              Inc(PufferAdr, 6);
              Byte(Puffer[PufferAdr]) := (Byte(Puffer[PufferAdr]) AND $E0) OR (Bitrate AND $3E000000) SHR 25;
              Inc(PufferAdr);
              Byte(Puffer[PufferAdr]) := (Byte(Puffer[PufferAdr]) AND $01) OR (Bitrate AND $01FC0000) SHR 18;

            END;
          END;
          Inc(J);
        UNTIL (J = I);
      END;

    //---------------------------------------------------- Korrigieren, Indexdatei erstellen Ende
      IF NOT Anhalten THEN
      BEGIN
        Menge := Speicherstream.SchreibenDirekt(Puffer^, Groesse);
        IF Menge < Groesse THEN
        BEGIN
          IF Speicherstream.AktuelleAdr > 4294967296 - 10 THEN
            Meldungsfenster(Wortlesen(NIL, 'Meldung82', 'Dateischreibfehler. Datei größer 4 GByte auf FAT32 Laufwerk geschrieben?'))
          ELSE
            Meldungsfenster(Wortlesen(NIL, 'Meldung83', 'Dateischreibfehler. Festplatte voll?'));
          Anhalten := True;
        END;
      END;
      Listenpunkt := Liste[I];
      aktAdresse := Listenpunkt.Adresse;
      IF (NOT Anhalten) AND Assigned(Fortschrittsanzeige) AND anzeigen THEN  // Fortschrittsanzeige
        Anhalten := Fortschrittsanzeige(FortschrittsPosition + aktAdresse - AnfAdrDatei);
//        Anhalten := Fortschrittsanzeige(I - AnfangsIndex);
    UNTIL (I > EndIndex) OR Anhalten;
    FreeMem(Puffer, 1048576);
    FortschrittsPosition := FortschrittsPosition +
                            THeaderklein(Liste[EndIndex]).Adresse -
                            THeaderklein(Liste[AnfangsIndex]).Adresse + 1;
  END;
//    SchleifenEndeZeit := Time;                // zum messen der Schleifenzeit
//    Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, SchleifenEndeZeit)));  // ----- " ------
END;

PROCEDURE TVideoschnitt.SequenzEndeanhaengen;

VAR Daten : LongWord;
    Headerklein : THeaderklein;

BEGIN
  IF IndexDatei_erstellen OR D2VDatei_erstellen THEN     // Wenn eine neue Indexdatei erstellt wurde,
  BEGIN
    Headerklein := THeaderklein.Create;                  // neuen Listenpunkt erzeugen,
    Headerklein.HeaderTyp := $B7;                        // Sequenzendecode eintragen,
    Headerklein.Adresse   := Speicherstream.AktuelleAdr; // Adresse eintragen,
    NeueListe.Add(Headerklein);                          // und zur Liste hinzufügen.
  END;
  Daten := $B7010000;
  Speicherstream.SchreibenDirekt(Daten, 4);
END;
               }
// ---------------------------------------------------------------------

{CONSTRUCTOR TAudioschnitt.Create;
BEGIN
  INHERITED Create;
  Dateiname := '';
  Dateistream := NIL;
  Speicherstream := NIL;
  AudioListe := TListe.Create;
  NeueListe := TListe.Create;;
  Anhalten := False;
  Audioheader := TAudioheader.Create;
END;

DESTRUCTOR TAudioschnitt.Destroy;
BEGIN
  IF Dateistream <> NIL THEN
  BEGIN
    Dateistream.Free;
    Dateistream := NIL;
  END;
  IF Speicherstream <> NIL THEN
  BEGIN
    Speicherstream.Free;
    Speicherstream := NIL;
  END;
  IF AudioListe <> NIL THEN
  BEGIN
    AudioListe.Loeschen;
    AudioListe.Free;
  END;  
  IF NeueListe <> NIL THEN
  BEGIN
    IF IndexDatei_erstellen THEN
      IndexDateispeichern(Zieldateiname, NeueListe);
    NeueListe.Loeschen;
    NeueListe.Free;
  END;
  IF Audioheader <> NIL THEN
    Audioheader.Free;
  INHERITED Destroy;  
END;

FUNCTION TAudioschnitt.Quelldateierzeugen(Dateiname: STRING): Integer;
BEGIN
  Result := 0;
  IF NOT Assigned(Dateistream) THEN
  BEGIN
    Dateistream := TDateipuffer.Create(Dateiname, fmOpenRead);
    IF Assigned(Dateistream) THEN
    BEGIN
      IF NOT (Dateistream.DateiMode = fmOpenRead) THEN
        Result := -2;
      Dateistream.Pufferfreigeben;
    END
    ELSE
      Result := -1;
  END;
END;

FUNCTION TAudioschnitt.Audioheaderlesen(Dateiname: STRING; Position: Int64; Audioheader: TAudioheader): Integer;

VAR MpegAudio : TMpegAudio;
    Adresse : Int64;

BEGIN
  Result := 0;
  IF Assigned(Audioheader) THEN
  BEGIN
    MpegAudio := TMpegAudio.Create;
    TRY
      IF MpegAudio.DateiOeffnen(Dateiname) > -1 THEN
      BEGIN
        Adresse := MpegAudio.DateiStream.AktuelleAdr;
        IF (Position > -1) AND
           (Adresse <> Position) THEN
        BEGIN
          IF MpegAudio.DateiStream.NeuePosition(Position) THEN
          BEGIN
            MpegAudio.DateiInformationLesen(Audioheader);
            MpegAudio.DateiStream.NeuePosition(Adresse);
          END
          ELSE
            Result := -4;       // neue Position läßt sich nicht setzen
        END
        ELSE
          MpegAudio.DateiInformationLesen(Audioheader);
        IF Audioheader.Framelaenge < 1 THEN
          Result := -3;         // Audioheader ungültig
      END
      ELSE
        Result := -2;           // Datei läßt sich nicht öffnen
    FINALLY
      MpegAudio.Free;
    END;
  END
  ELSE
    Result := -1;               // kein Audioheader übergeben
END;

PROCEDURE TAudioschnitt.Quelldateioeffnen(SchnittPunkt: TSchnittPunkt);

VAR Erg : Integer;
    MpegAudio : TMpegAudio;

BEGIN
  Erg := 0;
  IF NOT (Dateiname = SchnittPunkt.AudioName) THEN
  BEGIN
    Quelldateifreigeben;
    IF SchnittPunkt.AudioListe = NIL THEN
    BEGIN
      AudioListe.Loeschen;
      MpegAudio := TMpegAudio.Create;
      TRY
//        MpegAudio.Fortschrittsanzeige := Fortschrittsanzeige;
        MpegAudio.Textanzeige := Textanzeige;
//        MpegAudio.FortschrittsEndwert := FortschrittsEndwert;
        IF MpegAudio.DateiOeffnen(SchnittPunkt.AudioName) > -1 THEN
        BEGIN
          MpegAudio.DateiInformationLesen(Audioheader);
          IF Audioheader.Framelaenge > 0 THEN
            MpegAudio.Listeerzeugen(AudioListe, NIL, Versatz)
          ELSE
            Erg := -3;
        END
        ELSE
          Erg := -2;
      FINALLY
        MpegAudio.Free;
      END;
      Liste := AudioListe;
    END
    ELSE
    BEGIN
      Erg := Audioheaderlesen(SchnittPunkt.AudioName, -1, Audioheader);
      Liste := SchnittPunkt.AudioListe;
    END;
    IF Erg = -3 THEN
      Meldungsfenster(Meldunglesen(NIL, 'Meldung131', SchnittPunkt.AudioName, 'Fehler im ersten Header der Audiodatei $Text1#.') + Chr(13) +
                      Meldunglesen(NIL, 'Meldung123', Zieldateiname, 'Die Zieldatei $Text1# wird wieder gelöscht.'))
    ELSE
      IF Erg = -2 THEN
        Meldungsfenster(Meldunglesen(NIL, 'Meldung114', SchnittPunkt.AudioName, 'Die Datei $Text1# läßt sich nicht öffnen.') + Chr(13) +
                        Meldunglesen(NIL, 'Meldung124', Zieldateiname, 'Es wird keine (vollständige) Datei $Text1# erzeugt.'));
    Dateiname := SchnittPunkt.AudioName;
    Quelldateierzeugen(SchnittPunkt.AudioName);
  END;
END;

PROCEDURE TAudioschnitt.Quelldateifreigeben;
BEGIN
  IF Dateistream <> NIL THEN
  BEGIN
    Dateistream.Free;
    Dateistream := NIL;
  END;
END;

PROCEDURE TAudioschnitt.Quelldateischliessen;
BEGIN
  Quelldateifreigeben;
  Dateiname := '';
  AudioListe.Loeschen;
  Liste := NIL;
END;

PROCEDURE TAudioschnitt.IndexDateispeichern(Name: STRING; Liste : TListe);

VAR I : LongInt;
    Listenstream : TDateiPuffer;
    Header : TAudioHeaderklein;
    Puffer : ARRAY[0..3] OF Byte;
//    SchleifenAnfangsZeit, SchleifenEndeZeit : TDateTime;     // zum messen der Schleifendauer

BEGIN
  IF (Liste.Count > 0) AND (Name <> '') THEN
  BEGIN
//    SchleifenAnfangsZeit := Time;                              // zum messen der Schleifenzeit
    Listenstream := TDateiPuffer.Create(Name + '.idd', fmCreate);
    Puffer[0] := Ord('i');                              // Puffer mit 'idd' füllen
    Puffer[1] := Ord('d');
    Puffer[2] := Ord('d');
    Puffer[3] := 3;                                     // Version der Indexdatei
//    Puffer[3] := 4;                                     // Version der Indexdatei
    Listenstream.SchreibenDirekt(Puffer, 4);            // Puffer an den Anfang der Datei schreiben
//    Integer(Puffer) := Versatz;
//    Listenstream.SchreibenDirekt(Puffer, 2);            // Audioversatz in die Indexdatei schreiben
    FOR I := 0 TO Liste.Count -1 DO
    BEGIN
      Header := Liste[I];
      Listenstream.SchreibenDirekt(Header.Adresse, SizeOf(Header.Adresse));            // 8 Byte
    END;
    Listenstream.Free;
//    SchleifenEndeZeit := Time;                // zum messen der Schleifenzeit
//    Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, SchleifenEndeZeit)));  // ----- " ------
  END;
END;

PROCEDURE TAudioschnitt.Zieldateioeffnen(ZielDatei: STRING);

VAR Audioheaderklein : TAudioheaderklein;

BEGIN
  IF NOT (Zieldateiname = ZielDatei) THEN
  BEGIN
    IF Speicherstream <> NIL THEN
      Speicherstream.Free;
//    Speicherstream := TDateipuffer.Create(ZielDatei, fmCreate);
    IF IndexDatei_erstellen AND (NOT Anhalten) THEN
      IndexDateispeichern(Zieldateiname, NeueListe);
    NeueListe.Loeschen;
    Audioheaderklein := TAudioheaderklein.Create;
    Audioheaderklein.Adresse := 0;
    NeueListe.Add(Audioheaderklein);
    Zieldateiname := ZielDatei;
  END;
END;

PROCEDURE TAudioschnitt.Zieldateischliessen;
BEGIN
  IF Speicherstream <> NIL THEN
  BEGIN
    Speicherstream.Free;
    Speicherstream := NIL;
  END;
  IF IndexDatei_erstellen AND (NOT Anhalten) THEN
    IndexDateispeichern(Zieldateiname, NeueListe);
  NeueListe.Loeschen;
  Zieldateiname := '';
END;

FUNCTION TAudioschnitt.Schneiden(SchnittListe: TStrings): Integer;

VAR I : LongInt;
    Schnittpunkt : TSchnittpunkt;
    AnfangsIndex, EndIndex,
    EffektAnfang, EffektEnde : LongInt;
    MpegAudio : TMpegAudio;
    AudioNullHeader : TAudioheader;
    Audioschneiden : Boolean;
    Bildlaenge,
    Audioversatz : Real;
    DateiName : STRING;
    EffektEintrag : TEffektEintrag;

BEGIN
  Result := 0;
  Audioversatz := 0;
  IF Videoschnittanhalten THEN                                             // Videoschnitt wurde angehalten
  BEGIN
    Videoschnittanhalten := False;
    Exit;
  END;
  AudioNullHeader := TAudioheader.Create;                                  //-------------------------------
  TRY
    I := 0;
    Audioschneiden := False;
    IF Assigned(FortschrittsEndwert) THEN
      FortschrittsEndwert^ := 0;
    FortschrittsPosition := 0;
//    WHILE (I < SchnittListe.Count) AND (NOT Audioschneiden) DO             // Audioheader in der Schnittliste suchen
    WHILE (I < SchnittListe.Count) DO                                      // Audioheader in der Schnittliste suchen
    BEGIN
      Schnittpunkt := TSchnittpunkt(SchnittListe.Objects[I]);              // X. Schnitt
      IF Assigned(FortschrittsEndwert) THEN
        FortschrittsEndwert^ := FortschrittsEndwert^ + Schnittpunkt.AudioGroesse;
      IF Schnittpunkt.AudioName <> '' THEN
      BEGIN
        MpegAudio := TMpegAudio.Create;
        IF MpegAudio.DateiOeffnen(Schnittpunkt.AudioName) = 0 THEN         // Audiodatei muß sich geöffnen lassen
        BEGIN
          MpegAudio.DateiInformationLesen(AudioNullHeader);                // Den Audiotyp und weitere Informationen über die erste gefundene Audiodatei lesen.
//          IF AudioNullHeader.Framelaenge > 0 THEN
          Audioschneiden := True;                                          // Wurde mindestens ein Audioheader gefunden wird geschnitten
        END;
        MpegAudio.Free;                                                    // also kein Audio schneiden.
      END;
      Inc(I);
    END;                    //------------------------------
    IF Audioschneiden THEN
    BEGIN
      Result := -1;                                                         // Abbruch durch Anwender
      Speicherstream := TDateipuffer.Create(Zieldateiname, fmCreate);
      IF Speicherstream.DateiMode <> fmCreate THEN
      BEGIN
        Anhalten := True;
        Result := -2;                                                       // Zieldatei nicht geöffnet
      END
      ELSE
        Anhalten := False;
      I := 0;
      WHILE (I < SchnittListe.Count) AND (NOT Anhalten) DO                  // Schnittliste duchlaufen
      BEGIN
        Schnittpunkt := TSchnittpunkt(SchnittListe.Objects[I]);             // X. Schnitt
        TextString := IntToStr(I+1) + ' (' + Schnittpunkt.AudioName + ')';
        IF Schnittpunkt.AudioName <> '' THEN
        BEGIN
          Quelldateioeffnen(Schnittpunkt);
          IF Liste.Count = 0 THEN
          BEGIN
            Anhalten := True;
            Result := -3;                                                   // Quelldatei nicht geöffnet oder keine Liste
          END
          ELSE
          BEGIN
            AudioNullHeader.Audiotyp := AudioHeader.Audiotyp;               // den AudioNullHeader auf den letzten verwendeten Audioheader setzen
            AudioNullHeader.Adresse := AudioHeader.Adresse;
            AudioNullHeader.Version := AudioHeader.Version;
            AudioNullHeader.Layer := AudioHeader.Layer;
            AudioNullHeader.Protection := AudioHeader.Protection;
            AudioNullHeader.Bitrate := AudioHeader.Bitrate;
            AudioNullHeader.Samplerate := AudioHeader.Samplerate;
            AudioNullHeader.Padding := AudioHeader.Padding;
            AudioNullHeader.Privat := AudioHeader.Privat;
            AudioNullHeader.Mode := AudioHeader.Mode;
            AudioNullHeader.ModeErweiterung := AudioHeader.ModeErweiterung;
            AudioNullHeader.Copyright := AudioHeader.Copyright;
            AudioNullHeader.Orginal := AudioHeader.Orginal;
            AudioNullHeader.Emphasis := AudioHeader.Emphasis;
            AudioNullHeader.Samplerateberechnet := AudioHeader.Samplerateberechnet;
            AudioNullHeader.Bitrateberechnet := AudioHeader.Bitrateberechnet;
            AudioNullHeader.Framelaenge := AudioHeader.Framelaenge;
            AudioNullHeader.Framezeit := AudioHeader.Framezeit;
            IF Schnittpunkt.Framerate = 0 THEN
            BEGIN
              Anhalten := True;
              Result := -4;                                                 // Framerate ist 0
            END
            ELSE
            BEGIN
              Bildlaenge := 1000 / Schnittpunkt.Framerate;
              Protokoll_schreiben('Beginn Audioberechnung: ' + Schnittpunkt.AudioName + ' Schnittpunkt: ' + IntToStr(I + 1), 4);
              Protokoll_schreiben('Bildlänge: ' + FloatToStr(Bildlaenge) + ' ms', 4);
              Protokoll_schreiben('Audioframelänge: ' + FloatToStr(Audioheader.Framezeit) + ' ms', 4);
              Protokoll_schreiben('Audiodateilänge: ' + IntToStr(Liste.Count - 2) + ' Frames', 4);
              Protokoll_schreiben('Audiooffset: ' + IntToStr(Schnittpunkt.Audiooffset) + ' ms', 4);
              Protokoll_schreiben('Audioversatz 1: ' + FloatToStr(Audioversatz) + ' ms', 4);
              Protokoll_schreiben('Schnittpunkt Anfang: ' + FloatToStr(Schnittpunkt.Anfang * Bildlaenge) + ' ms', 4);
              AnfangsIndex := Round(((Schnittpunkt.Anfang * Bildlaenge) + Audioversatz - Versatz - Schnittpunkt.Audiooffset) / Audioheader.Framezeit);
              Protokoll_schreiben('AnfangsIndex: ' + IntToStr(AnfangsIndex) + ' Frames', 4);
              Audioversatz := (Schnittpunkt.Anfang * Bildlaenge) - (AnfangsIndex * Audioheader.Framezeit) + Audioversatz - Versatz - Schnittpunkt.Audiooffset;
              Protokoll_schreiben('Audioversatz 2: ' + FloatToStr(Audioversatz) + ' ms', 4);
              Protokoll_schreiben('Schnittpunkt Ende + 1: ' + FloatToStr((Schnittpunkt.Ende + 1) * Bildlaenge) + ' ms', 4);
              EndIndex := Round((((Schnittpunkt.Ende + 1) * Bildlaenge) - Audioversatz - Versatz - Schnittpunkt.Audiooffset) / Audioheader.Framezeit) - 1;
              Protokoll_schreiben('EndeIndex + 1: ' + IntToStr(EndIndex + 1) + ' Frames', 4);
              Audioversatz := ((EndIndex + 1) * Audioheader.Framezeit) - ((Schnittpunkt.Ende + 1) * Bildlaenge) + Audioversatz + Versatz + Schnittpunkt.Audiooffset;
              Protokoll_schreiben('Audioversatz 3: ' + FloatToStr(Audioversatz) + ' ms', 4);
              EffektEintrag := Schnittpunkt.AudioEffekt;
              IF (EffektEintrag.AnfangEffektPosition > 0) OR (EffektEintrag.EndeEffektPosition > 0) THEN
                IF (EffektEintrag.AnfangLaenge = 0) AND (EffektEintrag.EndeLaenge = 0) AND
                   (EffektEintrag.AnfangEffektPosition > 0) THEN
                BEGIN                                             // Effekt über den ganzen Schnitt
                  EffektEnde := EndIndex;
                  EffektAnfang := EndIndex + 1;
                END
                ELSE
                BEGIN                                             // zwei Einzeleffekte
                  IF (EffektEintrag.AnfangLaenge > 0) AND (EffektEintrag.AnfangEffektPosition > 0) THEN
                    EffektEnde := Trunc(EffektEintrag.AnfangLaenge / Audioheader.Framezeit) + AnfangsIndex   // Anfangseffekt vorhanden
                  ELSE
                    EffektEnde := AnfangsIndex - 1;                                                              // kein Anfangseffekt
                  IF (EffektEintrag.EndeLaenge > 0) AND (EffektEintrag.EndeEffektPosition > 0) THEN
                    EffektAnfang := EndIndex - Trunc(EffektEintrag.EndeLaenge / Audioheader.Framezeit)         // Endeeffekt vorhanden
                  ELSE
                    EffektAnfang := EndIndex + 1;                                                            // kein Endeeffekt
                END
              ELSE
              BEGIN                                               // keine Effekte
                EffektEnde := AnfangsIndex - 1;
                EffektAnfang := EndIndex + 1;
              END;
              IF EffektEnde > EndIndex THEN
                EffektEnde := EndIndex;
              IF EffektEnde > EffektAnfang - 1 THEN
                EffektAnfang := EffektEnde + 1;
              IF NOT Anhalten THEN
              BEGIN
                IF AnfangsIndex < 0 THEN
                  IF EndIndex < 0 THEN
                    NullAudio_einfuegen(AnfangsIndex, EndIndex, AudioNullHeader)
                  ELSE
                  BEGIN
                    NullAudio_einfuegen(AnfangsIndex, -1, AudioNullHeader);
                    IF EndIndex > Liste.Count - 2 THEN
                    BEGIN
                      EffektberechnenAnfang(0, EffektEnde, EffektEintrag, Audioheader);
                      KopiereSegment(EffektEnde + 1, EffektAnfang - 1);
                      EffektberechnenEnde(EffektAnfang, Liste.Count - 2, EffektEintrag, Audioheader);
                      NullAudio_einfuegen(Liste.Count - 1, EndIndex, AudioNullHeader);
                    END
                    ELSE
                    BEGIN
                      EffektberechnenAnfang(0, EffektEnde, EffektEintrag, Audioheader);
                      KopiereSegment(EffektEnde + 1, EffektAnfang - 1);
                      EffektberechnenEnde(EffektAnfang, EndIndex, EffektEintrag, Audioheader);
                    END;
                  END
                ELSE
                  IF EndIndex > Liste.Count - 2 THEN
                    IF AnfangsIndex > Liste.Count - 2 THEN
                      NullAudio_einfuegen(AnfangsIndex, EndIndex, AudioNullHeader)
                    ELSE
                    BEGIN
                      EffektberechnenAnfang(AnfangsIndex, EffektEnde, EffektEintrag, Audioheader);
                      KopiereSegment(EffektEnde + 1, EffektAnfang - 1);
                      EffektberechnenEnde(EffektAnfang, Liste.Count - 2, EffektEintrag, Audioheader);
                      NullAudio_einfuegen(Liste.Count - 1, EndIndex, AudioNullHeader);
                    END
                  ELSE
                  BEGIN
                    EffektberechnenAnfang(AnfangsIndex, EffektEnde, EffektEintrag, Audioheader);
                    KopiereSegment(EffektEnde + 1, EffektAnfang - 1);
                    EffektberechnenEnde(EffektAnfang, EndIndex, EffektEintrag, Audioheader);
                  END;
              END;
            END;
          END;
        END
        ELSE
        BEGIN
          IF Schnittpunkt.Framerate = 0 THEN
          BEGIN
            Anhalten := True;
            Result := -4;                                                 // Framerate ist 0
          END
          ELSE
          BEGIN
            Bildlaenge := 1000 / Schnittpunkt.Framerate;
            Protokoll_schreiben('Beginn Audioberechnung: ' + Schnittpunkt.AudioName + ' Schnittpunkt: ' + IntToStr(I + 1), 4);
            Protokoll_schreiben('Bildlänge: ' + FloatToStr(Bildlaenge) + ' ms', 4);
            Protokoll_schreiben('Audioframelänge: ' + FloatToStr(AudioNullHeader.Framezeit) + ' ms', 4);
            Protokoll_schreiben('Leeres Audio wird geschrieben', 4);
            Protokoll_schreiben('Audioversatz 1: ' + FloatToStr(Audioversatz) + ' ms', 4);
            Protokoll_schreiben('Schnittpunkt Anfang: ' + FloatToStr(Schnittpunkt.Anfang * Bildlaenge) + ' ms', 4);
            AnfangsIndex := Round(((Schnittpunkt.Anfang * Bildlaenge) + Audioversatz - Versatz) / AudioNullHeader.Framezeit);
            Protokoll_schreiben('AnfangsIndex: ' + IntToStr(AnfangsIndex) + ' Frames', 4);
            Audioversatz := (Schnittpunkt.Anfang * Bildlaenge) - (AnfangsIndex * AudioNullHeader.Framezeit) + Audioversatz - Versatz;
            Protokoll_schreiben('Audioversatz 2: ' + FloatToStr(Audioversatz) + ' ms', 4);
            Protokoll_schreiben('Schnittpunkt Ende + 1: ' + FloatToStr((Schnittpunkt.Ende + 1) * Bildlaenge) + ' ms', 4);
            EndIndex := Round((((Schnittpunkt.Ende + 1) * Bildlaenge) - Audioversatz - Versatz) / AudioNullHeader.Framezeit) - 1;
            Protokoll_schreiben('EndeIndex + 1: ' + IntToStr(EndIndex + 1) + ' Frames', 4);
            Audioversatz := ((EndIndex + 1) * AudioNullHeader.Framezeit) - ((Schnittpunkt.Ende + 1) * Bildlaenge) + Audioversatz + Versatz;
            Protokoll_schreiben('Audioversatz 3: ' + FloatToStr(Audioversatz) + ' ms', 4);
            IF NOT Anhalten THEN
              NullAudio_einfuegen(AnfangsIndex, EndIndex, AudioNullHeader);
          END;
        END;
        Inc(I);
      END;
//      Audioheaderklein := TAudioheaderklein.Create;
//      Audioheaderklein.Adresse := Speicherstream.AktuelleAdr;
//      NeueListe.Add(Audioheaderklein);
    END;
    IF Anhalten THEN
    BEGIN
      DateiName := Zieldateiname;
      Zieldateischliessen;
      IF FileExists(DateiName) THEN
        DeleteFile(DateiName);
    END
    ELSE
      Result := 0;                  // kein Fehler und nicht durch Anwender abgebrochen
  FINALLY
    AudioNullHeader.Free;
  END;
END;

PROCEDURE TAudioschnitt.KopiereSegment(AnfangsIndex, EndIndex: Int64);

VAR Menge,
    Groesse,
    aktAdresse,
    AnfAdrDatei,
    AnfAdrSpeicher : Int64;
    Puffer : PChar;
    I, PufferGr : Integer;
    Listenpunkt,
    Audioheaderklein : TAudioheaderklein;
//    SchleifenAnfangsZeit : TDateTime;                          // zum messen der Schleifendauer

BEGIN
  IF NOT Anhalten THEN
  BEGIN
    Groesse := 0;
    IF Assigned(Textanzeige) THEN
      Textanzeige(4, TextString);
//    IF Assigned(FortschrittsEndwert) THEN
//      FortschrittsEndwert^ := TAudioheaderklein(Liste[EndIndex]).Adresse -
//                              TAudioheaderklein(Liste[AnfangsIndex]).Adresse + 1;
//      FortschrittsEndwert^ := EndIndex - AnfangsIndex + 1;
  //  SchleifenAnfangsZeit := Time;                              // zum messen der Schleifenzeit
    IF AnfangsIndex < 0 THEN                                     // AnfangsIndex prüfen und eventuell
      AnfangsIndex := 0;                                         // auf Null setzen
    IF EndIndex > Liste.Count - 2 THEN                           // EndIndex prüfen und eventuell
      EndIndex := Liste.Count - 2;                               // auf maximalen Wert setzen
    IF (AnfangsIndex < Liste.Count - 1) AND                      // AnfangsIndex kleiner Liste
       (AnfangsIndex < EndIndex + 1) THEN                        // Anfang liegt vor dem Ende
    BEGIN
      AnfAdrSpeicher := Speicherstream.AktuelleAdr;              // Startadresse der Zieldatei merken
      PufferGr := 1048576;                                       // 1 MByte
      GetMem(Puffer, PufferGr);
      I := AnfangsIndex;                                         // Zähler setzen zum Header suchen
      Listenpunkt := Liste[I];
      aktAdresse := Listenpunkt.Adresse;                         // Startadresse zum kopieren
      AnfAdrDatei := aktAdresse;                                 // Startadresse der Quelldatei merken
      Dateistream.NeuePosition(aktAdresse);
      REPEAT
        REPEAT                                                   // Header suchen der gerade noch in den Block passt
          Inc(I);
          IF I + 1 < Liste.Count THEN                            // am Ende der Liste kann man nicht auf den nächsten Header zugreifen
            Listenpunkt := Liste[I + 1];                         // die Endadresse eines Headers/Bildes ist die Anfangsadresse des nächsten Headers
        UNTIL ((Listenpunkt.Adresse - aktAdresse) > PufferGr) OR // der nächste Header passt nicht mehr in den Puffer
               (I > EndIndex);                                   // Ende des Abschnitts
        Listenpunkt := Liste[I];
        IF NOT Anhalten THEN
        BEGIN
          Groesse := Listenpunkt.Adresse - aktAdresse;
          Menge := Dateistream.LesenDirekt(Puffer^, Groesse);
          IF Menge < Groesse THEN
          BEGIN
            IF Menge < 0 THEN
              Meldungsfenster(Meldunglesen(NIL, 'Meldung114', TextString, 'Die Datei $Text1# läßt sich nicht öffnen.'))
            ELSE
              Meldungsfenster(Meldunglesen(NIL, 'Meldung122', TextString, 'Die Datei $Text1# ist scheinbar zu kurz.'));
            Anhalten := True;
          END;
        END;
        IF NOT Anhalten THEN
        BEGIN
          Menge := Speicherstream.SchreibenDirekt(Puffer^, Groesse);
          IF Menge < Groesse THEN
          BEGIN
            IF Speicherstream.AktuelleAdr > 4294967296 - 10 THEN
              Meldungsfenster(Wortlesen(NIL, 'Meldung82', 'Dateischreibfehler. Datei größer 4 GByte auf FAT32 Laufwerk geschrieben?'))
            ELSE
              Meldungsfenster(Wortlesen(NIL, 'Meldung83', 'Dateischreibfehler. Festplatte voll?'));
            Anhalten := True;
          END;
        END;
        aktAdresse := Listenpunkt.Adresse;
        IF (NOT Anhalten) AND Assigned(Fortschrittsanzeige) THEN    // Fortschrittsanzeige
          Anhalten := Fortschrittsanzeige(FortschrittsPosition + aktAdresse - AnfAdrDatei);
//          Anhalten := Fortschrittsanzeige(I - AnfangsIndex);
      UNTIL (I > EndIndex) OR Anhalten;
      FreeMem(Puffer, PufferGr);
      FortschrittsPosition := FortschrittsPosition +
                              THeaderklein(Liste[EndIndex]).Adresse -
                              THeaderklein(Liste[AnfangsIndex]).Adresse + 1;
  //    SchleifenAnfangsZeit := Time;                              // zum messen der Schleifenzeit
      IF NOT Anhalten THEN
        FOR I := AnfangsIndex + 1 TO EndIndex + 1 DO             //  für alle kopierten Audioframes
        BEGIN
          Audioheaderklein := TAudioheaderklein.Create;          // einen neuen Header erzeugen
          Listenpunkt := Liste[I];                               // die Adresse neu berechnen
          Audioheaderklein.Adresse := Listenpunkt.Adresse - AnfAdrDatei + AnfAdrSpeicher;
          NeueListe.Add(Audioheaderklein);                       // und in die Liste speichern
        END;
    END;
  //    Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, Time)));  // zum messen der Schleifenzeit
  END;
END;

FUNCTION TAudioschnitt.Indexlistefuellen(AnfangsAdr, EndAdr: Int64; Audioheader: TAudioheader): Integer;

VAR aktAdresse,
    letzteAdr : Int64;
    Audioheaderklein : TAudioheaderklein;

BEGIN
  Result := 0;
  aktAdresse := 0;
  letzteAdr := TAudioheaderklein(NeueListe.Items[NeueListe.Count - 1]).Adresse;
  WHILE aktAdresse < EndAdr + 1 - AnfangsAdr DO
  BEGIN
    Audioheaderklein := TAudioheaderklein.Create;
    Inc(aktAdresse, Audioheader.Framelaenge);
    Audioheaderklein.Adresse := aktAdresse + letzteAdr;
    NeueListe.Add(Audioheaderklein);
  END;
END;

FUNCTION TAudioschnitt.KopiereSegmentDatei(AnfangsAdr, EndAdr: Int64; QuellDateistream, ZielDateistream: TDateiPuffer): Integer;

VAR Menge,
    Groesse,
    aktAdresse : Int64;
    Puffer : PChar;
    PufferGr : Integer;

BEGIN
//  IF Assigned(Textanzeige) THEN
//    Textanzeige(4, TextString);
//  IF Assigned(FortschrittsEndwert) THEN
//    FortschrittsEndwert^ := EndIndex - AnfangsIndex + 1;
  Result := 0;
  IF Assigned(QuellDateistream) AND Assigned(ZielDateistream) THEN
  BEGIN
    IF ((QuellDateistream.DateiMode AND $F) = fmOpenRead) OR
       ((QuellDateistream.DateiMode AND $F) = fmOpenReadWrite) THEN
      IF (ZielDateistream.DateiMode = fmCreate) OR
         ((ZielDateistream.DateiMode AND $F) = fmOpenWrite) OR
         ((ZielDateistream.DateiMode AND $F) = fmOpenReadWrite) THEN
      BEGIN
        IF AnfangsAdr < 0 THEN                                 // Anfangsadresse prüfen und eventuell
          AnfangsAdr := 0;                                     // auf Null setzen
        IF EndAdr > QuellDateistream.Dateigroesse - 1 THEN     // Endadresse prüfen und eventuell
          EndAdr := QuellDateistream.Dateigroesse - 1;         // auf maximalen Wert setzen
        IF (AnfangsAdr < EndAdr + 1) THEN                      // Anfang liegt vor dem Ende
        BEGIN
          PufferGr := 1048576;                             // 1 MByte
          GetMem(Puffer, PufferGr);
          TRY
            aktAdresse := AnfangsAdr;                      // Startadresse zum kopieren
            QuellDateistream.NeuePosition(aktAdresse);
            REPEAT
              IF (EndAdr - aktAdresse + 1) > PufferGr THEN
                Groesse := PufferGr
              ELSE
                Groesse := EndAdr - aktAdresse + 1;
              Menge := QuellDateistream.LesenDirekt(Puffer^, Groesse);
              IF Menge < Groesse THEN
              BEGIN
                IF Menge < 0 THEN
        //          Meldungsfenster(Meldunglesen(NIL, 'Meldung114', QuellDateistream.DateiName, 'Die Datei $Text1# läßt sich nicht öffnen.'))
                  Result := -4
                ELSE
        //          Meldungsfenster(Meldunglesen(NIL, 'Meldung122', QuellDateistream.DateiName, 'Die Datei $Text1# ist scheinbar zu kurz.'));
                  Result := -5;
                Anhalten := True;
              END
              ELSE
              BEGIN
                Menge := ZielDateistream.SchreibenDirekt(Puffer^, Groesse);
                IF Menge < Groesse THEN
                BEGIN
                  IF ZielDateistream.AktuelleAdr > 4294967296 - 10 THEN
                    Result := -8
        //            Meldungsfenster(Wortlesen(NIL, 'Meldung82', 'Dateischreibfehler. Datei größer 4 GByte auf FAT32 Laufwerk geschrieben?'))
                  ELSE
                    Result := -7;
        //            Meldungsfenster(Wortlesen(NIL, 'Meldung83', 'Dateischreibfehler. Festplatte voll?'));
                  Anhalten := True;
                END;
              END;
              aktAdresse := aktAdresse + Groesse;
        //      IF (NOT Anhalten) AND Assigned(Fortschrittsanzeige) THEN    // Fortschrittsanzeige
        //        Anhalten := Fortschrittsanzeige(aktAdresse - AnfangsAdr);
            UNTIL (aktAdresse > EndAdr) OR Anhalten;
          FINALLY
            FreeMem(Puffer, PufferGr);
          END;
        END
        ELSE
          Result := -4;
      END
      ELSE
        Result := -3
    ELSE
      Result := -2;
  END
  ELSE
    Result := -1;
END;

PROCEDURE TAudioschnitt.NullAudio_einfuegen(AnfangsIndex, EndIndex: Int64; AudioHeader: TAudioHeader);

VAR Puffer : PChar;
    Menge,
    I,
    Erg : Integer;
    Audioheaderklein : TAudioheaderklein;

FUNCTION PCMFrame_schreiben: Integer;
BEGIN
  Result := -1;
END;

FUNCTION Mpeg2Frame_schreiben: Integer;

VAR MpegAudio : TMpegAudio;
    AudioHeader1 : TAudioheader;
    Audioframe : TDateiPuffer;
    gefunden : Boolean;

BEGIN
//  Sartzeitsetzen;
  Result := 0;
  MpegAudio := TMpegAudio.Create;
  AudioHeader1 := TAudioheader.Create;
  TRY
    gefunden := False;
    I := 0;
    WHILE (I < leereAudioframesMpeg.Count) AND (NOT gefunden) DO
    BEGIN
      IF MpegAudio.DateiOeffnen(leereAudioframesMpeg[I]) = 0 THEN        // Audiodatei öffnen
      BEGIN
        MpegAudio.DateiInformationLesen(AudioHeader1);                   // Audiotyp und weitere Informationen lesen
        IF (AudioHeader1.Audiotyp = AudioHeader.Audiotyp) AND
           (AudioHeader1.Version = AudioHeader.Version) AND
           (AudioHeader1.Layer = AudioHeader.Layer) AND
           (AudioHeader1.Protection = AudioHeader.Protection) AND
           (AudioHeader1.Bitrate = AudioHeader.Bitrate) AND
           (AudioHeader1.Samplerate = AudioHeader.Samplerate) AND
           (AudioHeader1.Mode = AudioHeader.Mode) AND
           (AudioHeader1.ModeErweiterung = AudioHeader.ModeErweiterung) AND
           (AudioHeader1.Emphasis = AudioHeader.Emphasis) THEN
           gefunden := True
         ELSE
           Inc(I);
       END
       ELSE
         Inc(I);
    END;
  FINALLY
    MpegAudio.Free;
    AudioHeader1.Free;
  END;
//  Showmessage(IntToStr(Zeitdauerlesen));
  IF gefunden AND (I < leereAudioframesMpeg.Count) THEN
  BEGIN
    Audioframe := TDateiPuffer.Create('', fmOpenRead);
    TRY
      Audioframe.Dateioeffnen(leereAudioframesMpeg[I], fmOpenRead);
      Audioframe.Pufferfreigeben;
      Audioframe.NeuePosition(0);
      IF Audioframe.DateiMode = fmOpenRead THEN
      BEGIN
        Menge := Audioframe.LesenDirekt(Puffer^, AudioHeader.Framelaenge);
        IF NOT(Menge = AudioHeader.Framelaenge) THEN
          Result := 3;                                                   // Audioframedatei zu kurz
      END
      ELSE
        Result := 2;                                                     // Audioframedatei läßt sich nicht öffnen
    FINALLY
      Audioframe.Free;
    END;
  END
  ELSE
    Result := 1;                                                         // keine passende Audioframedatei gefunden
  WITH AudioHeader DO
  BEGIN
    IF Result > 0 THEN
    BEGIN
      FillChar(Puffer^, Framelaenge, 0);
      Byte(Puffer[0]) := $FF;
      Byte(Puffer[1]) := $E0;
      Byte(Puffer[1]) := Byte(Puffer[1]) OR ((Version AND $03) SHL 3);
      Byte(Puffer[1]) := Byte(Puffer[1]) OR ((Layer AND $03) SHL 1);
      Byte(Puffer[1]) := Byte(Puffer[1]) OR 1;
      Byte(Puffer[2]) := (Bitrate AND $0F) SHL 4;
      Byte(Puffer[2]) := Byte(Puffer[2]) OR ((Samplerate AND $03) SHL 2);
      Byte(Puffer[2]) := Byte(Puffer[2]) OR (Byte(Padding) SHL 1);
      Byte(Puffer[3]) := (Mode AND $03) SHL 6;
      Byte(Puffer[3]) := Byte(Puffer[3]) OR ((ModeErweiterung AND $03) SHL 4);
      Byte(Puffer[3]) := Byte(Puffer[3]) OR (Emphasis AND $03);
    END;
    Byte(Puffer[2]) := (Byte(Puffer[2]) AND $FE) OR Byte(Privat);
    Byte(Puffer[3]) := (Byte(Puffer[3]) AND $F7) OR (Byte(Copyright) SHL 3);
    Byte(Puffer[3]) := (Byte(Puffer[3]) AND $FB) OR (Byte(Orginal) SHL 2);
  END;
END;

FUNCTION AC3Frame_schreiben: Integer;

VAR MpegAudio : TMpegAudio;
    AudioHeader1 : TAudioheader;
    Audioframe : TDateiPuffer;
    gefunden : Boolean;

BEGIN
  Result := 0;
  MpegAudio := TMpegAudio.Create;
  AudioHeader1 := TAudioheader.Create;
  TRY
    gefunden := False;
    I := 0;
    WHILE (I < leereAudioframesAC3.Count) AND (NOT gefunden) DO
    BEGIN
      IF MpegAudio.DateiOeffnen(leereAudioframesAC3[I]) = 0 THEN         // Audiodatei öffnen
      BEGIN
        MpegAudio.DateiInformationLesen(AudioHeader1);                   // Audiotyp und weitere Informationen lesen
        IF (AudioHeader1.Audiotyp = AudioHeader.Audiotyp) AND
           (AudioHeader1.Bitrate = AudioHeader.Bitrate) AND
           (AudioHeader1.Samplerate = AudioHeader.Samplerate) AND
           (AudioHeader1.Mode = AudioHeader.Mode) AND
           (AudioHeader1.ModeErweiterung = AudioHeader.ModeErweiterung) AND
           (AudioHeader1.Copyright = AudioHeader.Copyright) THEN
           gefunden := True
         ELSE
           Inc(I);
       END
       ELSE
         Inc(I);
    END;
  FINALLY
    MpegAudio.Free;
    AudioHeader1.Free;
  END;
  IF gefunden AND (I < leereAudioframesAC3.Count) THEN
  BEGIN
    Audioframe := TDateiPuffer.Create('', fmOpenRead);
    TRY
      Audioframe.Dateioeffnen(leereAudioframesAC3[I], fmOpenRead);
      Audioframe.Pufferfreigeben;
      Audioframe.NeuePosition(0);
      IF Audioframe.DateiMode = fmOpenRead THEN
      BEGIN
        Menge := Audioframe.LesenDirekt(Puffer^, AudioHeader.Framelaenge);
        IF NOT(Menge = AudioHeader.Framelaenge) THEN
          Result := -3;                                                  // Audioframedatei zu kurz
      END
      ELSE
        Result := -2;                                                    // Audioframedatei läßt sich nicht öffnen
    FINALLY
      Audioframe.Free;
    END;
  END
  ELSE
    Result := -1;                                                        // keine passende Audioframedatei gefunden
END;

BEGIN
  Erg := 0;
  GetMem(Puffer, AudioHeader.Framelaenge);
  TRY
    FillChar(Puffer^, AudioHeader.Framelaenge, 0);
    CASE AudioHeader.Audiotyp OF
      1: Erg := PCMFrame_schreiben;
      2: Erg := Mpeg2Frame_schreiben;
      3: Erg := AC3Frame_schreiben;
    END;
    IF Erg > -1 THEN
    BEGIN
      FOR I := AnfangsIndex TO EndIndex DO
        IF NOT Anhalten THEN
        BEGIN
          Audioheaderklein := TAudioheaderklein.Create;            // einen neuen Header erzeugen
          Audioheaderklein.Adresse := Speicherstream.AktuelleAdr;  // die aktuelle Adresse eintragen
          NeueListe.Add(Audioheaderklein);                         // und in die Liste speichern
          Menge := Speicherstream.SchreibenDirekt(Puffer^, AudioHeader.Framelaenge);
          IF Menge < AudioHeader.Framelaenge THEN
          BEGIN
            IF Speicherstream.AktuelleAdr > 4294967296 - 10 THEN
              Meldungsfenster(Wortlesen(NIL, 'Meldung82', 'Dateischreibfehler. Datei größer 4 GByte auf FAT32 Laufwerk geschrieben?'))
            ELSE
              Meldungsfenster(Wortlesen(NIL, 'Meldung83', 'Dateischreibfehler. Festplatte voll?'));
            Anhalten := True;
          END;
        END;
    END
    ELSE
      Meldungsfenster(Wortlesen(NIL, 'Meldung220', 'Es wurde kein passender leerer Audioframe gefunden.' + Chr(13) +
                      Wortlesen(NIL, 'Meldung221', 'Video und Audio können unsynchron werden.')))
  FINALLY
    FreeMem(Puffer, AudioHeader.Framelaenge);
  END;
END;

FUNCTION TAudioschnitt.Effektberechnen(AnfangsIndex, EndIndex: Int64; EffektParameter: STRING; EffektLaenge: Integer; EffektDaten: TAusgabeDaten; Audioheader: TAudioHeader): Integer;

VAR Laenge,
    LaengeSek,
    FehlerNr,
    VarZahl,
    VarZaehler : Integer;
    HDateiname,
    HVerzeichnis,
    HProgrammName,
    HParameterdatei,
    TeilDateiname,
    EffektDateiname,
    HProgrammParameter,
    aktVerzeichnis : STRING;
    HDateistream : TDateiPuffer;
    HAudioheader : TAudioheader;
    Variablen : ARRAY OF STRING;

BEGIN
  Result := 0;
//  IF Assigned(Textanzeige) THEN
//    Textanzeige(4, TextString);
  IF NOT Anhalten THEN
  BEGIN
    AnfangsIndex := AnfangsIndex + ParameterausTextInt(EffektDaten.Parameter, 'FramesBegin', '=', ';', 0);
    EndIndex := EndIndex + ParameterausTextInt(EffektDaten.Parameter, 'FramesEnd', '=', ';', 0);
    IF AnfangsIndex < 0 THEN                                     // AnfangsIndex prüfen und eventuell
      AnfangsIndex := 0;                                         // auf Null setzen
    IF EndIndex > Liste.Count - 2 THEN                           // EndIndex prüfen und eventuell
      EndIndex := Liste.Count - 2;                               // auf maximalen Wert setzen
    IF (AnfangsIndex < EndIndex + 1) AND                         // Anfang liegt vor dem Ende
       (EffektDaten.ProgrammName <> '') AND                      // Effektprogramm ist vorhanden
       (EffektLaenge <> 0) THEN                                  // Effektlänge ist vorhanden
    BEGIN
      TeilDateiname := Zwischenverzeichnis + 'Effekt-' + ExtractFileName(ChangeFileExt(DateiName, '')) + '-' + IntToStr(AnfangsIndex) + '-' + IntToStr(EndIndex) + ExtractFileExt(Dateiname);
      EffektDateiname := Zwischenverzeichnis + 'Effekt-' + EffektDaten.EffektName + '-' + ExtractFileName(ChangeFileExt(DateiName, '')) + '-' + IntToStr(AnfangsIndex) + '-' + IntToStr(EndIndex) + ExtractFileExt(Dateiname);
      HDateistream := TDateiPuffer.Create(TeilDateiname, fmCreate);
      TRY
        HDateistream.Pufferfreigeben;
        FehlerNr := KopiereSegmentDatei(TAudioheaderklein(Liste[AnfangsIndex]).Adresse,
                                        TAudioheaderklein(Liste[EndIndex + 1]).Adresse - 1,
                                        Dateistream, HDateistream);
      FINALLY
        HDateistream.Free;
      END;
      IF FehlerNr = 0 THEN
      BEGIN
        HAudioheader := TAudioheader.Create;
        TRY
          Audioheaderlesen(TeilDateiname, -1, HAudioheader);
          Laenge := Trunc((EndIndex + 1 - AnfangsIndex) * HAudioheader.FrameZeit);
          LaengeSek := Trunc(Laenge / 1000);
          IF LaengeSek > 10 THEN
            LaengeSek := 10;
          IF LaengeSek = 0 THEN
            LaengeSek := 500;
          HDateiname := ChangeFileExt(ExtractfileName(DateiName), '');
          HVerzeichnis := ExtractFileDir(DateiName);
          HParameterdatei := VariablenersetzenText(EffektDaten.ParameterDateiName, ['$DateiName#', HDateiname, '$Directory#', HVerzeichnis, '$TempDirectory#', ohnePathtrennzeichen(Zwischenverzeichnis)]);
          HProgrammName := VariablenersetzenText(EffektDaten.ProgrammName, ['$DateiName#', HDateiname, '$Directory#', HVerzeichnis, '$TempDirectory#', ohnePathtrennzeichen(Zwischenverzeichnis), '$ParameterFile#', HParameterdatei]);
          SetLength(Variablen, 32);
          Variablen[0] := '$DateiName#';
          Variablen[1] := HDateiname;
          Variablen[2] := '$Directory#';
          Variablen[3] := HVerzeichnis;
          Variablen[4] := '$TempDirectory#';
          Variablen[5] := ohnePathtrennzeichen(Zwischenverzeichnis);
          Variablen[6] := '$ParameterFile#';
          Variablen[7] := HParameterdatei;
          Variablen[8] := '$AudioFile#';
          Variablen[9] := TeilDateiname;
          Variablen[10] := '$EffectAudioFile#';
          Variablen[11] := EffektDateiname;
          Variablen[12] := '$OverallLength#';
          Variablen[13] := IntToStr(EffektLaenge);
          Variablen[14] := '$FileLength#';
          Variablen[15] := IntToStr(Laenge);
          Variablen[16] := '$LengthSec#';
          Variablen[17] := IntToStr(LaengeSek);
          Variablen[18] := '$Samplerate#';
          Variablen[19] := IntToStr(HAudioheader.Samplerateberechnet);
          Variablen[20] := '$Bitrate#';
          Variablen[21] := IntToStr(HAudioheader.Bitrateberechnet);
          Variablen[22] := '$Protection#';
          IF HAudioheader.Protection THEN
            Variablen[23] := 'e';
          Variablen[24] := '$Privat#';
          IF HAudioheader.Privat THEN
            Variablen[25] := 'o';
          Variablen[26] := '$Copyright#';
          IF HAudioheader.Copyright THEN
            Variablen[27] := 'c';
          Variablen[28] := '$Mode#';
          IF HAudioheader.Audiotyp = 2 THEN
            CASE HAudioHeader.Mode OF
              0: Variablen[29] := 's';
              1: Variablen[29] := 'j';
              2: Variablen[29] := 'd';
              3: Variablen[29] := 'm';
            END;
          IF HAudioheader.Audiotyp = 3 THEN
            CASE HAudioHeader.ModeErweiterung OF
              0: Variablen[29] := '1+1';
              1: Variablen[29] := '1/0';
              2: Variablen[29] := '2/0';
              3: Variablen[29] := '3/0';
              4: Variablen[29] := '2/1';
              5: Variablen[29] := '3/1';
              6: Variablen[29] := '2/2';
              7: Variablen[29] := '3/2';
            END;
          Variablen[30] := '$NofChannels#';
          IF HAudioheader.Audiotyp = 2 THEN
            CASE HAudioHeader.Mode OF
              0: Variablen[31] := '2';
              1: Variablen[31] := '2';
              2: Variablen[31] := '2';
              3: Variablen[31] := '1';
            END;
          IF HAudioheader.Audiotyp = 3 THEN
            IF HAudioHeader.Copyright THEN
              CASE HAudioHeader.ModeErweiterung OF
                0: Variablen[31] := '3';
                1: Variablen[31] := '2';
                2: Variablen[31] := '3';
                3: Variablen[31] := '4';
                4: Variablen[31] := '4';
                5: Variablen[31] := '5';
                6: Variablen[31] := '5';
                7: Variablen[31] := '6';
              END
            ELSE
              CASE HAudioHeader.ModeErweiterung OF
                0: Variablen[31] := '2';
                1: Variablen[31] := '1';
                2: Variablen[31] := '2';
                3: Variablen[31] := '3';
                4: Variablen[31] := '3';
                5: Variablen[31] := '4';
                6: Variablen[31] := '4';
                7: Variablen[31] := '5';
              END;
          VarZaehler := High(Variablen) + 1;
          VarZahl := VariablenausText(EffektDaten.Parameter, '=', ';', Variablen, VarZaehler) +
                     VariablenausText(EffektParameter, '=', ';', Variablen, VarZaehler);
          SetLength(Variablen, VarZaehler + VarZahl * 2);
          VarZaehler := VarZaehler + VariablenausText(EffektDaten.Parameter, '=', ';', Variablen, VarZaehler) * 2;
          VariablenausText(EffektParameter, '=', ';', Variablen, VarZaehler);
          HProgrammParameter := VariablenersetzenText(EffektDaten.ProgrammParameter, Variablen);
          VariablenersetzenDatei(EffektDaten.OrginalparameterDatei, HParameterdatei, Variablen);
          HProgrammParameter := VariablenentfernenText(HProgrammParameter);
          VariablenentfernenDatei(HParameterdatei);
          Finalize(Variablen);
        FINALLY
          HAudioheader.Free;
        END;
     //           Meldungsfenster(Meldunglesen(NIL, 'Meldung132', ZielDateistream.Dateiname, 'Die Datei $Text1# konnte nicht erzeugt werden.'));
     //     Meldungsfenster(Meldunglesen(NIL, 'Meldung114', QuellDateistream.DateiName, 'Die Datei $Text1# läßt sich nicht öffnen.'));
        aktVerzeichnis := GetCurrentDir;
        SetCurrentDir(ExtractFilePath(HProgrammname));
        IF Unterprogramm_starten(HProgrammname + ' ' + HProgrammParameter , True) THEN
        BEGIN
          HAudioheader := TAudioheader.Create;
          TRY
            FehlerNr := Audioheaderlesen(EffektDateiname, -1, HAudioheader);
            IF FehlerNr = 0 THEN
            BEGIN
              HDateistream := TDateiPuffer.Create(EffektDateiname, fmOpenRead);
              TRY
                HDateistream.Pufferfreigeben;
                AnfangsIndex := ParameterausTextInt(EffektDaten.Parameter, 'EffectFramesBegin', '=', ';', 0) * HAudioheader.Framelaenge;
                EndIndex := HDateistream.Dateigroesse - 1 + (ParameterausTextInt(EffektDaten.Parameter, 'EffectFramesEnd', '=', ';', 0) * HAudioheader.Framelaenge);
                FehlerNr := KopiereSegmentDatei(AnfangsIndex, EndIndex,
                                                HDateistream, Speicherstream);
              FINALLY
                HDateistream.Free;
              END;
              IF FehlerNr = 0 THEN
              BEGIN
                Indexlistefuellen(AnfangsIndex, EndIndex, HAudioheader);
              END
              ELSE
              BEGIN
                Anhalten := True;
                Result := FehlerNr;
                CASE FehlerNr OF
                  -1: Fehlertext := '';
                ELSE
                  Fehlertext := '';
                END;
              END;
            END
            ELSE
            BEGIN
              Anhalten := True;
              Result := FehlerNr;
              CASE FehlerNr OF
                -1: Fehlertext := '';
              ELSE
                Fehlertext := '';
              END;
            END;
          FINALLY
            HAudioheader.Free;
          END;
        END
        ELSE
        BEGIN
          Anhalten := True;
          Result := -10;
          CASE FehlerNr OF
            -1: Fehlertext := '';
          ELSE
            Fehlertext := '';
          END;
        END;
        SetCurrentDir(aktVerzeichnis);
      END
      ELSE
      BEGIN
        Anhalten := True;
          Result := FehlerNr;
        CASE FehlerNr OF
          -1: Fehlertext := '';
        ELSE
          Fehlertext := '';
        END;
      END;
      DeleteFile(TeilDateiname);
      DeleteFile(EffektDateiname);
    END;
  END;
END;

PROCEDURE TAudioschnitt.EffektberechnenAnfang(AnfangsIndex, EndIndex: Int64; EffektEintrag: TEffektEintrag; Audioheader: TAudioHeader);

VAR Laenge,
    FehlerNr : Integer;
    EffektAudioDaten : TEffektAudioDaten;
    EffektDaten : TAusgabeDaten;

BEGIN
//  IF Assigned(Textanzeige) THEN
//    Textanzeige(4, TextString);
  IF Assigned(EffektEintrag) AND Assigned(AudioEffekte) THEN
  BEGIN
    IF (NOT Anhalten) AND
       (AnfangsIndex < EndIndex + 1) THEN
    BEGIN
      IF (EffektEintrag.AnfangLaenge = 0) AND                     // Effekt geht über den ganzen Bereich
         (EffektEintrag.EndeLaenge = 0) THEN
        Laenge := -1
      ELSE
        Laenge := EffektEintrag.AnfangLaenge;
      EffektAudioDaten := NIL;
      IF (EffektEintrag.AnfangEffektPosition > 0) AND
         (EffektEintrag.AnfangEffektPosition < AudioEffekte.Count) THEN
      BEGIN
        EffektAudioDaten := TEffektAudioDaten(AudioEffekte.Objects[EffektEintrag.AnfangEffektPosition]);
        IF Assigned(EffektAudioDaten) THEN
          CASE Audioheader.Audiotyp OF
            1: EffektDaten := EffektAudioDaten.AudioEffektPCM;
            2: EffektDaten := EffektAudioDaten.AudioEffektMp2;
            3: EffektDaten := EffektAudioDaten.AudioEffektAC3;
          ELSE
            EffektDaten := NIL;
          END
        ELSE
          EffektDaten := NIL;
      END
      ELSE
        EffektDaten := NIL;
      IF Assigned(EffektAudioDaten) AND
         Assigned(EffektDaten) THEN
      BEGIN
        FehlerNr := Effektberechnen(AnfangsIndex, EndIndex, EffektEintrag.AnfangEffektParameter,
                                    Laenge, EffektDaten, Audioheader);
        IF FehlerNr < 0 THEN
        BEGIN
          Anhalten := True;
    //        Result := FehlerNr;
          CASE FehlerNr OF
            -1: Fehlertext := '';
          ELSE
            Fehlertext := '';
          END;
        END;
      END
      ELSE
      BEGIN
        Anhalten := True;
  //        Result := FehlerNr;
  //      CASE FehlerNr OF
  //        -1: Fehlertext := '';
  //      ELSE
  //        Fehlertext := '';
  //      END;
      END;
    END;
  END;
END;

PROCEDURE TAudioschnitt.EffektberechnenEnde(AnfangsIndex, EndIndex: Int64; EffektEintrag: TEffektEintrag; Audioheader: TAudioHeader);

VAR FehlerNr : Integer;
    EffektAudioDaten : TEffektAudioDaten;
    EffektDaten : TAusgabeDaten;

BEGIN
//  IF Assigned(Textanzeige) THEN
//    Textanzeige(4, TextString);
  IF Assigned(EffektEintrag) AND Assigned(AudioEffekte) THEN
  BEGIN
    IF (NOT Anhalten) AND
       (AnfangsIndex < EndIndex + 1) THEN
    BEGIN
      EffektAudioDaten := NIL;
      IF (EffektEintrag.EndeEffektPosition > 0) AND
         (EffektEintrag.EndeEffektPosition < AudioEffekte.Count) THEN
      BEGIN
        EffektAudioDaten := TEffektAudioDaten(AudioEffekte.Objects[EffektEintrag.EndeEffektPosition]);
        IF Assigned(EffektAudioDaten) THEN
          CASE Audioheader.Audiotyp OF
            1: EffektDaten := EffektAudioDaten.AudioEffektPCM;
            2: EffektDaten := EffektAudioDaten.AudioEffektMp2;
            3: EffektDaten := EffektAudioDaten.AudioEffektAC3;
          ELSE
            EffektDaten := NIL;
          END
        ELSE
          EffektDaten := NIL;
      END
      ELSE
        EffektDaten := NIL;
      IF Assigned(EffektAudioDaten) AND
         Assigned(EffektDaten) THEN
      BEGIN
        FehlerNr := Effektberechnen(AnfangsIndex, EndIndex, EffektEintrag.EndeEffektParameter,
                                    EffektEintrag.EndeLaenge, EffektDaten, Audioheader);
        IF FehlerNr < 0 THEN
        BEGIN
          Anhalten := True;
    //        Result := FehlerNr;
          CASE FehlerNr OF
            -1: Fehlertext := '';
          ELSE
            Fehlertext := '';
          END;
        END;
      END
      ELSE
      BEGIN
        Anhalten := True;
  //        Result := FehlerNr;
  //      CASE FehlerNr OF
  //        -1: Fehlertext := '';
  //      ELSE
  //        Fehlertext := '';
  //      END;
      END;
    END;
  END;  
END;    }

// -----------------------------------------------------------------------------------------------------

CONSTRUCTOR TMpegAudio.Create;
BEGIN
  INHERITED Create;
  Dateistream := NIL;
  Listenstream := NIL;
  Anhalten := False;
  FAudioDateiType := 0;
  FDateiname := '';
END;

DESTRUCTOR TMpegAudio.Destroy;
BEGIN
  Dateischliessen;
  Indexdateischliessen;
  INHERITED Destroy;
END;

FUNCTION TMpegAudio.DateiOeffnen(Name: STRING): Integer;
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

PROCEDURE TMpegAudio.Dateischliessen;
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

FUNCTION TMpegAudio.IndexdateiNeu: Integer;
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

FUNCTION TMpegAudio.IndexdateiOeffnen: Integer;
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

PROCEDURE TMpegAudio.Indexdateischliessen;
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

PROCEDURE TMpegAudio.Indexdateiloeschen;
BEGIN
  Indexdateischliessen;
  IF FileExists(FDateiname + '.idd') THEN
    DeleteFile(FDateiname + '.idd');
END;

PROCEDURE TMpegAudio.PufferGroesseschreiben(Puffer: LongInt);
BEGIN
  IF Assigned(Dateistream) THEN
    Dateistream.SetPuffergroesse(Puffer);
END;
{
PROCEDURE TMpegAudio.Audioheaderlesen(Audioheader: TAudioHeader);

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

FUNCTION TMpegAudio.Mpegheaderlesen(Audioheader: TAudioHeader; zumNaechstenHeader: Boolean; VAR AdrFehler: Integer): Integer;

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
PROCEDURE TMpegAudio.AC3Audioheaderlesen(Audioheader: TAudioHeader);

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

FUNCTION TMpegAudio.AC3_headerlesen(Audioheader: TAudioHeader; zumNaechstenHeader: Boolean; VAR AdrFehler: Integer): Integer;

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
PROCEDURE TMpegAudio.Headerlesen(Audioheader: TAudioHeaderklein);

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

PROCEDURE TMpegAudio.AC3Headerlesen(Audioheader: TAudioHeaderklein);

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

FUNCTION TMpegAudio.HeaderIndexdateiSchreiben(VAR Header: TAudioheaderklein): Integer;
BEGIN
  IF Listenstream.SchreibenDirekt(Header.Adresse, 8) = 8 THEN  // 8 Byte
    Result := 0
  ELSE
    Result := -1;
END;

FUNCTION TMpegAudio.HeaderIndexdateiLesen(VAR Header: TAudioheaderklein): Integer;

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

FUNCTION TMpegAudio.Audiotyplesen: Byte;

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

FUNCTION TMpegAudio.Audiotypsuchen: Byte;

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
FUNCTION TMpegAudio.AudioDateiTypesuchen: Byte;

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

FUNCTION TMpegAudio.AudioDateiTypesuchen: Byte;

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

FUNCTION TMpegAudio.AudioDateiTypelesen: Byte;
BEGIN
  IF FAudioDateiType = 0 THEN
    IF Assigned(Dateistream) THEN
      IF Dateistream.DateiMode = fmOpenRead THEN
        FAudioDateiType := AudioDateiTypesuchen;
  Result := FAudioDateiType;
END;

FUNCTION TMpegAudio.Dateigroesselesen: Int64;
BEGIN
  IF Assigned(Dateistream) THEN
    Result := Dateistream.Dateigroesse
  ELSE
    Result := -1;
END;

FUNCTION TMpegAudio.DateiInformationLesen(VAR AudioHeader: TAudioHeader): Integer;

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

FUNCTION TMpegAudio.DateiBereichLesen(Adresse: Int64; VAR Laenge: Integer; Puffer: ARRAY OF Byte; Adressenichtaendern: Boolean): Integer;

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

FUNCTION TMpegAudio.Framelesen(VAR Laenge: Integer; VAR Puffer: ARRAY OF Byte; Adressenichtaendern: Boolean): Integer;

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




FUNCTION TMpegAudio.Indexdateipruefen: Integer;

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

FUNCTION TMpegAudio.Indexlistenerzeugen(Liste, AudiotypeListe: TListe): Integer;

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

FUNCTION TMpegAudio.Indexdateierzeugen(Liste, AudiotypeListe: TListe): Integer;

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

FUNCTION TMpegAudio.Indexdateilesen(Liste, AudiotypeListe: TListe; VAR Audioversatz: Integer): Integer;

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


FUNCTION TMpegAudio.IndexDateischreiben: Integer;

VAR Audioversatz : Integer;

BEGIN
  Result := Listeerzeugen(NIL, NIL, Audioversatz);
END;

FUNCTION TMpegAudio.Listeerzeugen(Liste, AudiotypeListe: TListe; VAR Audioversatz: Integer): Integer;

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
