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

----------------------------------------------------------------------------------------------}

unit VideoschnittUnit;

interface

USES
  Dialogs,                  // Showmessage
  Classes,                  // Klassen
  SysUtils,                 // Dateioperationen, Stringfunktionen ...
  DateUtils,                // zum messen der Zeit die einige Funktionen benötigen
  ComCtrls,                 // für TTreeNode
  StrUtils,                 // für AnsiReplaceText
  Forms,                    // für Application
  Dateipuffer,
  DateiStreamUnit,          // Schreib- und Lesefunktionen mit Pufferung
  ProtokollUnit,            // zum protokollieren :-)
  Sprachen,                 // zum übersetzen der Meldungen
  AllgFunktionen,           // Zeit messen, Meldungsfenster
//  Optfenster,               // Effekttypen
  DatenTypen,               // für verwendete Datentypen
  VideoHeaderUnit,          // Videoheadertypen
  SchnittTypenUnit,         // Schnittgrundtypen
  AudioIndexUnit,           // Audioindex
  ScriptUnit,               // Scriptverarbeitung
//------------------------------------------------------------------------------
// Videoliste, VideoIndexliste
  Mpeg2Unit;                
//------------------------------------------------------------------------------

TYPE
  TVideoschnitt = CLASS(TSchnitt)
    PufferGr : Integer;
    Puffer : PChar;
    Liste,
    IndexListe,
    VideoListe,
    VideoIndexListe,
    NeueListe : TListe;
    SequenzHeader: TSequenzHeader;
    BildHeader: TBildHeader;
    SequenzHeaderBitrateAdr,
    ExSequenzHeaderBitrateAdr,
    ersterSequenzHeaderBitrateAdr,
    ersterExSequenzHeaderBitrateAdr,
    ersterSequenzHeaderAspectratioAdr : Int64;
    SequenzHeaderBitratePuffer,
    ersterSequenzHeaderBitratePuffer : ARRAY[0..2] OF Byte;
    ersterSequenzHeaderAspectratioPuffer : Byte;
    SequenzHeaderBitrate,
    orginaleBitrate,
    maximaleBitrate,
    OffsetAspectratio,
    orginalAspectratio : Integer;
    SequenzHeaderBildNr : Integer;
    BildZaehler : LongInt;
    TextString : STRING;
    Sequenzheaderkopieren: Boolean;
    FTimecodekorrigieren,
    FBitratekorrigieren,
    FD2VDateierstellen,
    FIDXDateierstellen,
    FFramegenauschneiden : Boolean;
    FZusammenhaengendeSchnitteberechnen : Boolean;
//    FBitrateberechnen : Boolean;
    FBitrateersterHeader : Integer;
    FfesteBitrate : LongWord;
    FAspectratioersterHeader : Integer;
    FAspectratioOffset : Integer;
    FmaxGOPLaenge : Integer;
    FminAnfang,
    FminEnde : Integer;
    TempD2VDateierstellen : Boolean;
    FUNCTION Quelldateioeffnen(Dateiname: STRING; VideoListe1, VideoIndexListe1: TListe): Integer;
    PROCEDURE Quelldateischliessen;
    PROCEDURE Variablensetzen(Variablen: TStrings; Sequenzheader: TSequenzheader; Bildheader: TBildheader = NIL);
    FUNCTION TeilDateikopieren(Variablen: TStrings; Anfangoffset: Integer = 0; Endeoffset: Integer = 0): Integer;
    FUNCTION Effektberechnen(AnfangsIndex, EndIndex: Int64; Effektdateiname, Effektname, Marke, EffektParameter: STRING; EffektLaenge: Integer; Sequenzheader: TSequenzHeader; SchnittTyp: STRING = ''): Integer;
    FUNCTION KopiereVideoteil(AnfangsIndex, EndIndex: Int64; Framerate: Real; QuellDateistream, ZielDateistream: TDateiPuffer; ZielListe: TListe; Textanzeigen, Fortschrittanzeigen: Boolean; IstZieldatei: Boolean; VAR Bildzaehler: LongInt): Integer;
//    FUNCTION KopiereVideoteil(AnfangsIndex, EndIndex: Int64; Framerate: Real; QuellDateistream: TDateiStream; ZielDateistream: TDateiPuffer; ZielListe: TListe; VAR ersterSequenzHeader: Boolean; VAR BildZaehler : LongInt; Textanzeigen, Fortschrittanzeigen: Boolean): Integer;
//    PROCEDURE KopiereSegment(geaendert: Boolean; AnfangsIndex, EndIndex: LongWord; Framerate: Real; anzeigen: Boolean; QuellDateistream, ZielDateistream: TDateiPuffer; ZielListe: TListe; VAR erstesBild: Boolean; VAR BildDiff: Word; VAR BildZaehler : LongInt; VAR ersterSequenzHeader: Boolean);
    FUNCTION KopiereSegmentDatei(AnfangsAdr, EndAdr: Int64; QuellDateistream, ZielDateistream: TDateiPuffer; ZielListe: TListe; Framerate: Real;  aendern, Textanzeigen, Fortschrittanzeigen: Boolean; VAR erstesBild: Boolean; VAR BildDiff: Word; VAR Bildzaehler: LongInt; Bitrateberechnen: Boolean; IstZieldatei: Boolean; Anzeigetext: STRING = ''): Integer;
    PROCEDURE SequenzEndeanhaengen(Speicherstream: TDateiPuffer; Liste: TListe; IstZieldatei: Boolean);
    FUNCTION Aspectratioschreiben(SequenzHeaderAspectratioAdr: Int64; SequenzHeaderAspectratioPuffer: Byte; SequenzHeaderAspectratio: Integer; Speicherstream: TDateiPuffer): Integer;
    FUNCTION Bitrateschreiben(SequenzHeaderBitrateAdr, ExSequenzHeaderBitrateAdr: Int64; SequenzHeaderBitratePuffer: ARRAY OF Byte; SequenzHeaderBitrate: Integer; Speicherstream: TDateiPuffer): Integer;
    FUNCTION Bitrateneuberechnen(Speicherstream: TDateiPuffer; Liste: TListe): Integer;
// -------- Indexlisten ------------
    FUNCTION SequenzBildheaderlesen(Dateiname: STRING; Position: Int64; Sequenzheader: TSequenzheader; Bildheader: TBildheader): Integer; OVERLOAD;
    FUNCTION SequenzBildheaderlesen(Index: LongInt; Sequenzheader: TSequenzHeader; Bildheader: TBildHeader): Integer; OVERLOAD;
    FUNCTION OffsetAspectratiolesen(Index: LongInt): Integer;
    PROCEDURE IndexDateispeichern(Name: STRING; Liste : TListe);
    PROCEDURE IdxDateispeichern(Name: STRING; Liste : TListe);
    PROCEDURE D2VDateispeichern(Name: STRING; Liste : TListe);
    PROCEDURE LangeGOPsuchen(Anfang, Ende: Int64; VAR Frame1, Frame2: Int64; maxGOPLaenge: Integer; minEnde: Integer);
  public
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
//    FUNCTION Zieldateioeffnen(ZielDatei: STRING): Integer;
//    PROCEDURE Zieldateischliessen;
    FUNCTION Schneiden(SchnittListe: TStrings): Integer;
    PROPERTY Timecodekorrigieren : Boolean WRITE FTimecodekorrigieren;
    PROPERTY Bitratekorrigieren : Boolean WRITE FBitratekorrigieren;
    PROPERTY D2VDateierstellen : Boolean WRITE FD2VDateierstellen;
    PROPERTY IDXDateierstellen : Boolean WRITE FIDXDateierstellen;
    PROPERTY Framegenauschneiden : Boolean WRITE FFramegenauschneiden;
    PROPERTY ZusammenhaengendeSchnitteberechnen : Boolean WRITE FZusammenhaengendeSchnitteberechnen;
//    PROPERTY Bitrateberechnen: Boolean WRITE FBitrateberechnen;
    PROPERTY BitrateersterHeader : Integer WRITE FBitrateersterHeader;
    PROPERTY festeBitrate : LongWord WRITE FfesteBitrate;
    PROPERTY AspectratioersterHeader : Integer WRITE FAspectratioersterHeader;
    PROPERTY AspectratioOffset : Integer WRITE FAspectratioOffset;
    PROPERTY maxGOPLaenge : Integer WRITE FmaxGOPLaenge;
    PROPERTY minAnfang : Integer WRITE FminAnfang;
    PROPERTY minEnde : Integer WRITE FminEnde;
  END;


implementation

CONSTRUCTOR TVideoschnitt.Create;
BEGIN
  INHERITED Create;
  PufferGr := 1048576;
  GetMem(Puffer, PufferGr);                 // wenn der Speicher nicht nur einmal sondern bei jeder Benutzung der Funktion "KopiereSegmentDatei" zugewiesen wird gibt es einen EOutOfMemory Fehler
  VideoListe := TListe.Create;
  VideoIndexListe := TListe.Create;
  NeueListe := TListe.Create;
  SequenzHeader:= TSequenzHeader.Create;
  BildHeader:= TBildHeader.Create;
  FTimecodekorrigieren := True;
  FBitratekorrigieren := True;
  FD2VDateierstellen := False;
  TempD2VDateierstellen := False;
  FIDXDateierstellen := False;
  FFramegenauschneiden := False;
//  FBitrateberechnen := True;
  FBitrateersterHeader := 0;
  FfesteBitrate := 0;
  FAspectratioersterHeader := 0;
  FAspectratioOffset := 0;
  FmaxGOPLaenge := 15;
  FminAnfang := 0;
  FminEnde := 0;
END;

DESTRUCTOR TVideoschnitt.Destroy;
BEGIN
  FreeMem(Puffer, PufferGr);
  IF Assigned(VideoListe) THEN
  BEGIN
    VideoListe.Loeschen;
    VideoListe.Free;
  END;
  IF Assigned(VideoIndexListe) THEN
  BEGIN
    VideoIndexListe.Loeschen;
    VideoIndexListe.Free;
  END;
  IF Assigned(NeueListe) THEN
  BEGIN
    IF FIndexDateierstellen THEN
      IndexDateispeichern(FZieldateiname, NeueListe);
    IF FIDXDateierstellen THEN
      IdxDateispeichern(FZieldateiname, NeueListe);
    IF FD2VDateierstellen THEN
      D2VDateispeichern(FZieldateiname, NeueListe);
    NeueListe.Loeschen;
    NeueListe.Free;
  END;
  IF Assigned(SequenzHeader) THEN
    SequenzHeader.Free;
  IF Assigned(BildHeader) THEN
    BildHeader.Free;
  INHERITED Destroy;
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
    IF Assigned(FTextanzeige) THEN
      FTextanzeige(3, ChangeFileExt(Name, '.idd'));
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
      Application.ProcessMessages;
    END;
    Listenstream.Free;
//    Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, Time)));  // zum messen der Schleifenzeit
  END;
END;

PROCEDURE TVideoschnitt.IdxDateispeichern(Name: STRING; Liste : TListe);

VAR I : LongInt;
    Listenstream : TDateiPuffer;
    Header : THeaderklein;
    BildZaehler,
    HInt64 : Int64;

BEGIN
  IF (Liste.Count > 0) AND (Name <> '') THEN
  BEGIN
//    Sartzeitsetzen;
    Listenstream := TDateiPuffer.Create(ChangeFileExt(Name, '.idx'), fmCreate);
    TRY
      HInt64 := THeaderklein(Liste[Liste.Count - 1]).Adresse + 4;
      Listenstream.SchreibenDirekt(HInt64, 8);
      HInt64 := 12345678;
      Listenstream.SchreibenDirekt(HInt64, 8);
      BildZaehler := 0;
      FOR I := 0 TO Liste.Count -1 DO
      BEGIN
        Header := Liste[I];
        IF Header.HeaderTyp = $00 THEN
        BEGIN
          Inc(BildZaehler);
          IF Header.BildTyp AND $07 = 1 THEN                                    // I-Frame
          BEGIN
            HInt64 := Header.Adresse - 1;
            Listenstream.SchreibenDirekt(HInt64, 8);                            // 8 Byte
            Listenstream.SchreibenDirekt(BildZaehler, 8);                       // 8 Byte
          END;
        END;
      END;
    FINALLY
      Listenstream.Free;
    END;
//    Showmessage(IntToStr(Zeitdauerlesen_microSek));
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

VAR I, J : LongInt;
    Version : Integer;
    HString : STRING;
    D2VListe : TStringList;
    Header : THeaderklein;
    Bildliste : TListe;
    Adresse : Int64;
    HWord : Word;
    CloseGop : Boolean;
//    SchleifenAnfangsZeit : TDateTime;     // zum messen der Schleifendauer

BEGIN
  IF Assigned(Liste) AND (Liste.Count > 0) AND (Name <> '') THEN
  BEGIN
//    SchleifenAnfangsZeit := Time;                              // zum messen der Schleifenzeit
    D2VListe := TStringList.Create;
    TRY
      D2VListe.Sorted := False;
      IF FileExists('D2VOrginal.d2v') THEN
        D2VListe.LoadFromFile('D2VOrginal.d2v')
      ELSE
      BEGIN
        D2VListe.Add('DGIndexProjectFile13');
        D2VListe.Add('1');
        D2VListe.Add('');
        D2VListe.Add('');
        D2VListe.Add('Stream_Type=0');
        D2VListe.Add('MPEG_Type=2');
        D2VListe.Add('iDCT_Algorithm=2');
        D2VListe.Add('YUVRGB_Scale=1');
        D2VListe.Add('Luminance_Filter=0,0');
        D2VListe.Add('Clipping=0,0,0,0');
        D2VListe.Add('Aspect_Ratio=0:0');
        D2VListe.Add('Picture_Size=0x0');
        D2VListe.Add('Field_Operation=0');
        D2VListe.Add('Frame_Rate=25000 (25/1)');
        D2VListe.Add('Location=0,0,0,0');
      END;
      D2VListe.Add('');
      Version := StrToIntDef(RightStr(D2VListe[0], 2), -1);
      IF Version > 12 THEN
      BEGIN
        D2VListe[2] := Name;
        Adresse := 0;
        Bildliste := TListe.Create;
        TRY
          I := 0;
          WHILE I < Liste.Count DO                              // bis zum Ende der Liste wiederholen
          BEGIN
            CloseGop := True;
            Header := Liste[I];
            WHILE (Header.HeaderTyp <> BildStartCode) AND
                  (I < Liste.Count) DO
            BEGIN
              Inc(I);
              IF I < Liste.Count THEN
                Header := Liste[I];
            END;
            REPEAT
              IF I < Liste.Count THEN
              BEGIN
                Header := Liste[I];                             // nächster Header
                IF Header.HeaderTyp = BildStartCode THEN
                BEGIN
                  IF Header.BildTyp AND $3 = 1 THEN
                  BEGIN
                    Adresse := Header.Adresse;
                    IF Header.TempRefer > 0 THEN
                      CloseGop := False;
                  END;
                  BildListe.Add(Header);                        // zur Bildliste hinzufügen
                END;
              END;
              Inc(I);
            UNTIL (Header.HeaderTyp <> BildStartCode) OR
       //           (Header.BildTyp AND $3 = 1) OR
                  (I > Liste.Count - 1); // Bildgruppe zu Ende
            BildListe.Sort(BildListeSortieren);                 // Bildliste sortieren
{            bit 11  1 (Always 1 to signal start of data line)
             bit 10  1 (This line's pictures are part of a closed GOP)
                     0 (Open GOP)
             bit  9  1 (This line's pictures are part of a progressive sequence)
                     0 (Otherwise)
             bit 8  1 (This I picture starts a new GOP)
                    0 (Otherwise)
             bits 7-0  0 (Reserved)  }

{            bit 7  1 (Picture is decodable without the previous GOP)
                    0 (Otherwise)
             bit 6  Progressive_Frame Flag (See notes below)
                    0 (Interlaced)
                    1 (Progressive)
             bits 5-4  Picture_Coding_Type Flag
                    00 (Reserved)
                    01 (I-Frame)
                    10 (P-Frame)
                    11 (B-Frame)
             bits 3-2  00 (Reserved)
                       01 (Reserved)
                       10 (Reserved)
                       11 (Reserved)
             bit 1  TFF Flag
             bit 0  RFF Flag }
            HWord := $800 + (Byte(CloseGop) SHL 10) + $100;
            HString := IntToHex(HWord, 3) + ' 1 0 ' + IntToStr(Adresse) + ' 0 0'; // Gruppenadresse
            FOR J := 0 TO Bildliste.Count - 1 DO                // Bildliste in die D2V-Listenzeile schreiben
            BEGIN
              Header := Bildliste[J];
              IF Header.BildTyp AND $3 = 1 THEN
                CloseGop := True;
              HWord := (Byte(CloseGop) SHL 7) + ((Header.BildTyp AND $3) SHL 4);
              HString := HString + ' ' + IntToHex(HWord, 2);
            END;
            IF I > Liste.Count -1 THEN
              HString := HString + ' ff';
            HString := LowerCase(HString);
            D2VListe.Add(HString);                              // D2V-Listenzeile zur D2V-Liste hinzufügen
            BildListe.Clear;                                    // Bildliste löschen
          END;
        FINALLY
          BildListe.Free;
        END;
        D2VListe.Add('');
        D2VListe.Add('FINISHED  100.00% VIDEO');
      END;
      D2VListe.SaveToFile(ChangeFileExt(Name, '.d2v'));       // D2V-Liste in die Datei schreiben
    FINALLY
      D2VListe.Free;
    END;
  END;
END;
{
PROCEDURE TVideoschnitt.D2VDateispeichern(Name: STRING; Liste : TListe);

VAR I, GH : LongInt;
    Version : Integer;
    Temprefer : Word;
    HString : STRING;
    D2VListe : TStringList;
    Header : THeaderklein;
    Bildliste : TListe;
    Adresse : Int64;
    HWord : Word;
    CloseGop : Boolean;
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
      Header := Liste[Liste.Count -1];
      D2VListe[10] := 'Frame_Rate=' + HString;
      D2VListe[11] := 'Location=0,0,0,' + IntToHex(Trunc(Header.Adresse / 2048), 1);
      D2VListe.Add('');
      Bildliste := TListe.Create;
      TRY
        Temprefer := 0;
        I := 0;
        Header := Liste[I];                                   // erster Header
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
      END;
      D2VListe.SaveToFile(ChangeFileExt(Name, '.d2v'));       // D2V-Liste in die Datei schreiben
    FINALLY
      D2VListe.Free;
    END;
//    Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, Time)));  // zum messen der Schleifenzeit
  END;
END;       }

// öffnet die Quelldatei
// 1 ... -3 siehe TSchnitt.Quelldateioeffnen
// -4 : Fehler beim erzeugen der Indexlisten
FUNCTION TVideoschnitt.Quelldateioeffnen(Dateiname: STRING; VideoListe1, VideoIndexListe1: TListe): Integer;

VAR MpegHeader: TMpeg2Header;

BEGIN
  IF NOT (Quelldateiname = Dateiname) THEN
  BEGIN
    Quelldateischliessen;
    MpegHeader:= TMpeg2Header.Create;
    TRY
//      MpegHeader.Fortschrittsanzeige := Fortschrittsanzeige;
      MpegHeader.Textanzeige := FTextanzeige;
//      MpegHeader.FortschrittsEndwert := FortschrittsEndwert;
      IF MpegHeader.Dateioeffnen(Dateiname) THEN
      BEGIN
        MpegHeader.DateiInformationLesen(SequenzHeader, BildHeader);
        IF VideoListe1 = NIL THEN
        BEGIN
          MpegHeader.Listeerzeugen(VideoListe, VideoIndexListe);
          Liste := VideoListe;
          IndexListe := VideoIndexListe;
        END
        ELSE
        BEGIN
          Liste := VideoListe1;
          IndexListe := VideoIndexListe1;
        END;
      END;
    FINALLY
      MpegHeader.Free;
    END;
    IF Assigned(Liste) AND (Liste.Count > 0) THEN
    BEGIN
      Result := INHERITED Quelldateioeffnen(Dateiname);
      IF Result < 0 THEN
        Fehlertext := Dateiname;
    END
    ELSE
      Result := -4;
  END
  ELSE
    Result := 1;
END;

PROCEDURE TVideoschnitt.Quelldateischliessen;
BEGIN
  INHERITED Quelldateischliessen;
  VideoListe.Loeschen;
  VideoIndexListe.Loeschen;
  Liste := NIL;
  IndexListe := NIL;
END;

//------------------------------------------------------------------------------
// gehört in den Sequenz- bzw. Bildheader
{Fehler:
 -1 : kein Sequenzheader oder Bildheader übergeben (NIL)
 -2 : Datei läßt sich nicht öffnen
 -3 : Sequenzheader ungültig
 -4 : Bildheader ungültig
 -5 : Sequenzheader und Bildheader ungültig
 -6 : die Position in der Datei läßt sich nicht setzen
}
FUNCTION TVideoschnitt.SequenzBildheaderlesen(Dateiname: STRING; Position: Int64; Sequenzheader: TSequenzheader; Bildheader: TBildheader): Integer;

VAR Mpeg2Header : TMpeg2Header;
    Adresse : Int64;

BEGIN
  Result := 0;
  IF Assigned(Sequenzheader) OR
     Assigned(Bildheader) THEN
  BEGIN
    Mpeg2Header := TMpeg2Header.Create;
    TRY
      IF Mpeg2Header.DateiOeffnen(Dateiname) THEN
      BEGIN
        Adresse := Mpeg2Header.DateiStream.AktuelleAdr;
        IF (Position > -1) AND
           (Adresse <> Position) THEN
        BEGIN
          IF Mpeg2Header.DateiStream.NeuePosition(Position) THEN
          BEGIN
            Mpeg2Header.DateiInformationLesen(Sequenzheader, Bildheader);
            Mpeg2Header.DateiStream.NeuePosition(Adresse);
          END
          ELSE
            Result := -6;       // neue Position läßt sich nicht setzen
        END
        ELSE
          Mpeg2Header.DateiInformationLesen(Sequenzheader, Bildheader);
        IF Result = 0 THEN
        BEGIN
          IF Bildheader.BildTyp = 0 THEN
            Result := -4;       // Bildheader ungültig
          IF Sequenzheader.Framerate < 1 THEN
            IF Result = 0 THEN
              Result := -3      // Sequenzheader ungültig
            ELSE
              Result := -5;     // Sequenzheader und Bildheader ungültig
        END;
      END
      ELSE
        Result := -2;           // Datei läßt sich nicht öffnen
    FINALLY
      Mpeg2Header.Free;
    END;
  END
  ELSE
    Result := -1;               // kein Sequenzheader oder Bildheader übergeben
END;
//------------------------------------------------------------------------------

// gehört teilweise in das Indexstreamobjekt und teilweise in die Headerobjekte
FUNCTION TVideoschnitt.SequenzBildheaderlesen(Index: LongInt; Sequenzheader: TSequenzHeader; Bildheader: TBildHeader): Integer;

VAR Mpeg2Header : TMpeg2Header;
    Adresse,
    I : LongWord;

BEGIN
  Result := 0;
  IF Assigned(Sequenzheader) OR
     Assigned(Bildheader) THEN
  BEGIN
    I := TBildIndex(IndexListe[Index]).BildIndex;
    WHILE (I > 0) AND (THeaderklein(Liste[I]).HeaderTyp <> SequenceStartCode)DO
      Dec(I);
    IF THeaderklein(Liste[I]).HeaderTyp = SequenceStartCode THEN
    BEGIN
      Mpeg2Header := TMpeg2Header.Create;
      TRY
        Mpeg2Header.DateiStream := Dateistream;
        Adresse := Mpeg2Header.DateiStream.AktuelleAdr;
        IF Mpeg2Header.DateiStream.NeuePosition(THeaderklein(Liste[I]).Adresse) THEN
        BEGIN
          Mpeg2Header.DateiInformationLesen(Sequenzheader, Bildheader);
          Mpeg2Header.DateiStream.NeuePosition(Adresse);
        END
        ELSE
          Result := -6;         // neue Position läßt sich nicht setzen
        IF Result = 0 THEN
        BEGIN
          IF Bildheader.BildTyp = 0 THEN
            Result := -4;       // Bildheader ungültig
          IF Sequenzheader.Framerate < 1 THEN
            IF Result = 0 THEN
              Result := -3      // Sequenzheader ungültig
            ELSE
              Result := -5;     // Sequenzheader und Bildheader ungültig
        END;
        Mpeg2Header.DateiStream := NIL;
      FINALLY
        Mpeg2Header.Free;
      END;
    END
    ELSE
      Result := -2;
  END
  ELSE
    Result := -1;               // kein Sequenzheader oder Bildheader übergeben
END;

FUNCTION TVideoschnitt.OffsetAspectratiolesen(Index: LongInt): Integer;

VAR OffsetSequenzheader : TSequenzHeader;
    OffsetBildheader : TBildheader;
    I : LongWord;

BEGIN
  I := TBildIndex(IndexListe[Index]).BildIndex;
  WHILE (I > 0) AND (THeaderklein(Liste[I]).HeaderTyp <> SequenceStartCode)DO
    Dec(I);
  IF I = 0 THEN
    Result := Sequenzheader.Seitenverhaeltnis
  ELSE
  BEGIN
    OffsetSequenzheader := TSequenzHeader.Create;
    OffsetBildheader := TBildheader.Create;
    TRY
      IF SequenzBildheaderlesen(Index, OffsetSequenzheader, OffsetBildheader) = 0 THEN
        Result := OffsetSequenzheader.Seitenverhaeltnis
      ELSE
        Result := 0;  
    FINALLY
      OffsetSequenzheader.Free;
      OffsetBildheader.Free;
    END;
  END;
END;

//------------------------------------------------------------------------------

PROCEDURE TVideoschnitt.Variablensetzen(Variablen: TStrings; Sequenzheader: TSequenzheader; Bildheader: TBildheader = NIL);

BEGIN
  IF Assigned(Sequenzheader) AND
     Assigned(Variablen) THEN
  BEGIN
    Variablesetzen(Variablen, '$FrameWidth#', IntToStr(Sequenzheader.BildBreite));
    Variablesetzen(Variablen, '$FrameHeight#', IntToStr(Sequenzheader.BildHoehe));
    CASE SequenzHeader.Seitenverhaeltnis OF
      1: Variablesetzen(Variablen, '$Aspectratio#', '1:1');
      2: Variablesetzen(Variablen, '$Aspectratio#', '4:3');
      3: Variablesetzen(Variablen, '$Aspectratio#', '16:9');
      4: Variablesetzen(Variablen, '$Aspectratio#', '2.21:1');
    ELSE
      Variablesetzen(Variablen, '$Aspectratio#', '4:3');
    END;
    CASE SequenzHeader.Framerate OF
      1: Variablesetzen(Variablen, '$Framerate#', '23.976');
      2: Variablesetzen(Variablen, '$Framerate#', '24');
      3: Variablesetzen(Variablen, '$Framerate#', '25');
      4: Variablesetzen(Variablen, '$Framerate#', '29.97');
      5: Variablesetzen(Variablen, '$Framerate#', '30');
      6: Variablesetzen(Variablen, '$Framerate#', '50');
      7: Variablesetzen(Variablen, '$Framerate#', '59.97');
      8: Variablesetzen(Variablen, '$Framerate#', '60');
    ELSE
      Variablesetzen(Variablen, '$Framerate#', '25');
    END;
    Variablesetzen(Variablen, '$Bitrate#', IntToStr(Round(Sequenzheader.Bitrate / 1000)));
    Variablesetzen(Variablen, '$VBVPuffer#', IntToStr(Sequenzheader.VBVPuffer * 2));
    Variablesetzen(Variablen, '$ProfilLevel#', IntToStr(Sequenzheader.ProfilLevel));
    Variablesetzen(Variablen, '$Progressive#', IntToStr(Integer(Sequenzheader.Progressive)));
    CASE SequenzHeader.ChromaFormat OF
      1: Variablesetzen(Variablen, '$ChromaFormat#', '4:2:0');
      2: Variablesetzen(Variablen, '$ChromaFormat#', '4:2:2');
      3: Variablesetzen(Variablen, '$ChromaFormat#', '4:4:4');
    ELSE
      Variablesetzen(Variablen, '$ChromaFormat#', '4:2:2');
    END;
    Variablesetzen(Variablen, '$LowDelay#', IntToStr(Integer(Sequenzheader.LowDelay)));
    IF Assigned(Bildheader) THEN
    BEGIN
      Variablesetzen(Variablen, '$VBVDelay#', IntToStr(Bildheader.VBVDelay));
      Variablesetzen(Variablen, '$DCPrezision#', IntToStr(BildHeader.IntraDCPre + 8));
      CASE BildHeader.BildStruktur OF
        1: Variablesetzen(Variablen, '$Fieldstructur#', 'Top');
        2: Variablesetzen(Variablen, '$Fieldstructur#', 'Bottom');
        3: Variablesetzen(Variablen, '$Fieldstructur#', 'Frame');
      ELSE
        Variablesetzen(Variablen, '$Fieldstructur#', 'Frame');
      END;
      IF Bildheader.OberstesFeldzuerst THEN
        Variablesetzen(Variablen, '$Fieldfirst#', 'TFF')
      ELSE
        Variablesetzen(Variablen, '$Fieldfirst#', 'BFF');
    END;
  END;
END;

// kopiert eine Teildatei aus der Quelldatei
//  0 : Ok
// -1 : Variablen fehlerhaft
// -2 : Fehler in KopiereVideoteil
// -3 : Teildatei nicht erzeugt
FUNCTION TVideoschnitt.TeilDateikopieren(Variablen: TStrings; Anfangoffset: Integer = 0; Endeoffset: Integer = 0): Integer;

VAR AnfangIndex,
    EndeIndex,
    StartBild,
    EndBild,
    HInteger : LongInt;
    Framerate : Real;
    HString : STRING;
    Format : TFormatSettings;
    HDateistream : TDateiPuffer;
    HListe : TListe;

BEGIN
//  IF (Anfangoffset = 0) AND (Endeoffset = 0) THEN
//  BEGIN
//    Anfangoffset := StrToIntDef(VariablenersetzenText('$FramesBegin#', Variablen), 0);
//    Endeoffset := StrToIntDef(VariablenersetzenText('$FramesEnd#', Variablen), 0);
//  END;
  StartBild := 0;                                                               // nur damit der Compiler Ruhe gibt
  HString := VariablenersetzenText('$PartFile#', Variablen);
  AnfangIndex := StrToIntDef(VariablenersetzenText('$BeginIndex#', Variablen), -1);
  EndeIndex := StrToIntDef(VariablenersetzenText('$EndIndex#', Variablen), -1);
  Format.DecimalSeparator := '.';
  Framerate := StrToFloatDef(VariablenersetzenText('$Framerate#', Variablen), -1, Format);
  IF (AnfangIndex > -1) AND
     (EndeIndex > -1) AND
     (Framerate > 0) THEN
  BEGIN
    HListe := TListe.Create;
    HDateistream := TDateiPuffer.Create(HString, fmCreate);
    TRY
      IF Assigned(HDateistream) AND
         (HDateistream.DateiMode = fmCreate) THEN
      BEGIN
        Sequenzheaderkopieren := True;                                          // an den Anfang der Videodatei muß ein Sequenzheader kopiert werden
        HInteger := 0;
        StartBild := VorherigesBild(1, AnfangIndex, IndexListe);
        EndBild := NaechstesBild(2, EndeIndex, IndexListe);
        IF VariablenersetzenText('$DGIndexProject#', Variablen) = '1' THEN
          TempD2VDateierstellen := True;
        Result := KopiereVideoteil(StartBild, EndBild, Framerate,
                                   Dateistream, HDateistream, HListe, False, False, False, HInteger);
        IF Result > -1 THEN
        BEGIN
          SequenzEndeanhaengen(HDateistream, HListe, False);
          IndexDateispeichern(HString, HListe);
          IF TempD2VDateierstellen THEN
            D2VDateispeichern(HString, HListe);
        END;
        TempD2VDateierstellen := False;
        IF Result < 0 THEN
          Result := -2;
      END
      ELSE
        Result := -3;
    FINALLY
      HDateistream.Free;
      HListe.Free;
    END;
  END
  ELSE
    Result := -1;
  IF Result = 0 THEN
    IF FileExists(HString) THEN
    BEGIN
  {    HSequenzheader := TSequenzHeader.Create;
      HBildheader := TBildHeader.Create;
      TRY
  //      Result := SequenzBildheaderlesen(HString, -1, HSequenzheader, HBildheader);
        Result := SequenzBildheaderlesen(AnfangIndex, HSequenzheader, HBildheader);
        IF Result = 0 THEN
        BEGIN
          Variablensetzen(Variablen, HSequenzheader, HBildheader);
          HInteger := Trunc((EndeIndex + 1 - AnfangIndex) * 1000 / BilderProSekausSeqHeaderFramerate(HSequenzheader.Framerate));
          Variablesetzen(Variablen, '$FileLength#', IntToStr(HInteger));
        END;
      FINALLY
        HSequenzheader.Free;
        HBildheader.Free;
      END;      }
      HInteger := Trunc((EndeIndex + 1 - AnfangIndex) * 1000 / Framerate);
      Variablesetzen(Variablen, '$FileLength#', IntToStr(HInteger));
      EndBild := EndeIndex - StartBild + StrToIntDef(VariablenersetzenText('$Framescorrect#', Variablen), 0);
      StartBild := AnfangIndex - StartBild + StrToIntDef(VariablenersetzenText('$Framescorrect#', Variablen), 0);
      Variablesetzen(Variablen, '$StartFrame#', IntToStr(StartBild));
      Variablesetzen(Variablen, '$EndFrame#', IntToStr(EndBild));
    END
    ELSE
      Result := -3;
END;

{ Fehler:
    -1 : Ausgabeobjekt ist NIL oder Effektprogramm ist leer oder Effektlänge = 0
    -2 : Teildatei konnte nicht erstellt werden
    -3 : Fehler beim Aufruf des Effektprogramms
    -4 : Fehler beim öffnen der Effektdatei
ab -11 : Fehler in Sequenz- oder Bildheaderlesen
ab -21 : Fehler im Script
ab -41 : Fehler in kopiere Teildatei
}
FUNCTION TVideoschnitt.Effektberechnen(AnfangsIndex, EndIndex: Int64; Effektdateiname, Effektname, Marke, EffektParameter: STRING; EffektLaenge: Integer;
                                       Sequenzheader: TSequenzHeader; SchnittTyp: STRING = ''): Integer;

VAR HString : STRING;
    HDateistream : TDateiPuffer;
    HSequenzheader : TSequenzHeader;
    HBildheader : TBildHeader;
    Variablen : TStringList;
    HBoolean2: Boolean;
    HWord: Word;

BEGIN
  Result := 0;
  IF NOT Anhalten THEN
  BEGIN
    IF AnfangsIndex < 0 THEN                                  // AnfangsIndex prüfen und eventuell
      AnfangsIndex := 0;                                      // auf Null setzen
    IF EndIndex > Liste.Count - 2 THEN                        // EndIndex prüfen und eventuell
      EndIndex := Liste.Count - 2;                            // auf maximalen Wert setzen
    IF (AnfangsIndex < EndIndex + 1) THEN                     // Anfang liegt vor dem Ende
    BEGIN
      IF EffektLaenge <> 0 THEN                               // Effektlänge ist vorhanden
      BEGIN
        HString := ExtractFileName(ChangeFileExt(Quelldateiname, ''));
        Variablen := TStringList.Create;
        TRY
          Variablen.Add('$DateiName#');
          Variablen.Add(HString);
          Variablen.Add('$Directory#');
          Variablen.Add(ExtractFileDir(Quelldateiname));
          Variablen.Add('$TempDirectory#');
          Variablen.Add(ohnePathtrennzeichen(FZwischenverzeichnis));
          Variablen.Add('$PartFile#');
          HString := ErsetzeZeichen(HString, ['&', ',']);
          Variablen.Add(FZwischenverzeichnis + 'PartFile-' + HString + '-' + IntToStr(AnfangsIndex) + '-' + IntToStr(EndIndex) + ExtractFileExt(Quelldateiname));
          Variablen.Add('$PartFiled2v#');
          Variablen.Add(ChangeFileExt(Variablen.Strings[Variablen.Count - 2], '.d2v'));
          Variablen.Add('$NewFile#');
          Variablen.Add(FZwischenverzeichnis + 'NewFile-$Scriptname#-' + HString + '-' + IntToStr(AnfangsIndex) + '-' + IntToStr(EndIndex) + ExtractFileExt(Quelldateiname));
          Variablen.Add('$OverallLength#');
          Variablen.Add(IntToStr(EffektLaenge));
          Variablen.Add('$BeginIndex#');
          Variablen.Add(IntToStr(AnfangsIndex));
          Variablen.Add('$EndIndex#');
          Variablen.Add(IntToStr(EndIndex));
          Variablen.Add('$BeginAdr#');
          Variablen.Add(IntToStr(THeaderklein(Liste[AnfangsIndex]).Adresse));
          Variablen.Add('$EndAdr#');
          Variablen.Add(IntToStr(THeaderklein(Liste[EndIndex]).Adresse));
          Variablen.Add('$CutType#');
          Variablen.Add(SchnittTyp);
          Variablen.Add('$ProgramDirectory#');
          Variablen.Add(ExtractFileDir(Application.ExeName));
          Variablen.Add('$DeleteTempFiles#');
          Variablen.Add('1');
          Variablen.Add('$Bitrateberechnen#');
          Variablen.Add('1');
          Variablen.Add('$DGIndexProject#');
          Variablen.Add('1');
          Variablen.Add('$Encoder#');
          Variablen.Add(FEncoderDatei);
          HSequenzheader := TSequenzHeader.Create;
          HBildheader := TBildHeader.Create;
          TRY
            Result := SequenzBildheaderlesen(AnfangsIndex, HSequenzheader, HBildheader);
            IF Result = 0 THEN
              Variablensetzen(Variablen, HSequenzheader, HBildheader);
          FINALLY
            HSequenzheader.Free;
            HBildheader.Free;
          END;
          IF Result = 0 THEN
          BEGIN
            VariablenausText(EffektParameter, '=', ';', Variablen);
            ScriptUnit.KopiereQuelldateiteil := TeilDateikopieren;
            Result := ScriptUnit.Scriptstarten(Effektdateiname, Variablen, Effektname, Marke);
            IF Result = 0 THEN
            BEGIN
              HString := VariablenersetzenText('$NewFile#', Variablen);
              HString := VariablenentfernenText(HString);
              HDateistream := TDateiPuffer.Create(HString, fmOpenRead);
              TRY
                IF HDateistream.DateiMode = fmOpenRead THEN
                BEGIN
  //                HDateistream.Pufferfreigeben;
  //                HString := VariablenersetzenText('$EffectFramesBegin#', Variablen);
  //                AnfangsIndex := StrToIntDef(HString, 0) * HAudioheader.Framelaenge;
  //                HString := VariablenersetzenText('$EffectFramesEnd#', Variablen);
  //                EndIndex := HDateistream.Dateigroesse - 1 + (StrToIntDef(HString, 0) * HAudioheader.Framelaenge);
                  HString := VariablenersetzenText('$Bitrateberechnen#', Variablen);
                  HBoolean2 := False;
                  HWord := 0;
                  Result := KopiereSegmentDatei(0, HDateistream.Dateigroesse - 4, HDateistream, Speicherstream, NeueListe,
                                                  BilderProSekausSeqHeaderFramerate(Sequenzheader.Framerate),
                                                  False, False, True, HBoolean2, HWord, BildZaehler, HString = '1', True);
                  IF Result < 0 THEN
                    Result := Result - 40
                  ELSE
                    Sequenzheaderkopieren := True;              // nach jedem neu berechnetem Videoteil einen Sequenzheader einfügen
                END
                ELSE
                  Result := -4;
              FINALLY
                HDateistream.Free;
              END;
            END
            ELSE
              Result := Result - 20;
          END
          ELSE
            Result := Result - 10;
        HString := VariablenersetzenText('$DeleteTempFiles#', Variablen);
        IF HString = '1' THEN
        BEGIN
          HString := VariablenersetzenText('$PartFile#', Variablen);
          DeleteFile(HString);
          DeleteFile(ChangeFileExt(HString, '.idd'));
          DeleteFile(ChangeFileExt(HString, '.d2v'));
          HString := VariablenersetzenText('$NewFile#', Variablen);
          DeleteFile(HString);
        END;
        FINALLY
          Variablen.Free;
        END;  
      END
      ELSE
        Result := -1;
    END;
  END;
  IF Result < 0 THEN
    Anhalten := True;    
END;

//-------------------------- gehört in das Indexobjekt ------------------
PROCEDURE TVideoschnitt.LangeGOPsuchen(Anfang, Ende: Int64; VAR Frame1, Frame2: Int64; maxGOPLaenge: Integer; minEnde: Integer);

VAR GOPAnfang, IFrame, GOPEnde : Int64;

BEGIN
  IFrame := Anfang;
  GOPEnde := VorherigesBild(2, Anfang - 1, IndexListe);        // vorheriges I- oder P-Frame suchen
  IF GOPEnde < 0 THEN
    GOPEnde := -1;                                             // Filmanfang
  REPEAT
    GOPAnfang := GOPEnde + 1;
    IFrame := NaechstesBild(1, IFrame + 1, IndexListe);        // nächstes I-Frame suchen
    IF IFrame < 0 THEN
      IFrame := IndexListe.Count;                              // Filmende
    GOPEnde := VorherigesBild(2, IFrame - 1, IndexListe);      // vorheriges I- oder P-Frame suchen
    IF GOPEnde > Ende THEN
      GOPEnde := Ende;
  UNTIL (GOPEnde = Ende) OR (GOPEnde - GOPAnfang + 1 > maxGOPLaenge);
  IF GOPEnde - GOPAnfang + 1 > maxGOPLaenge THEN
  BEGIN
    Frame1 := VorherigesBild(2, GOPAnfang + maxGOPLaenge, IndexListe);
    IF IFrame - 1 - Frame1 < minEnde THEN
      Frame1 := VorherigesBild(2, IFrame - 1 - minEnde, IndexListe);
    Frame2 := IFrame - 1;
  END
  ELSE
  BEGIN
    Frame1 := Ende;
    Frame2 := Ende;
  END;
END;
//-----------------------------------------------------------------------

FUNCTION TVideoschnitt.Aspectratioschreiben(SequenzHeaderAspectratioAdr: Int64; SequenzHeaderAspectratioPuffer: Byte; SequenzHeaderAspectratio: Integer; Speicherstream: TDateiPuffer): Integer;

VAR HByte : Byte;
    aktAdresse : Int64;

BEGIN
  Result := 0;
  aktAdresse := Speicherstream.AktuelleAdr;
  IF SequenzHeaderAspectratioAdr > -1 THEN
  BEGIN
    Speicherstream.NeuePosition(SequenzHeaderAspectratioAdr);
    HByte := SequenzHeaderAspectratioPuffer OR (SequenzHeaderAspectratio SHL 4);
    Speicherstream.SchreibenDirekt(HByte, 1);
    Speicherstream.NeuePosition(aktAdresse);
  END;
END;

FUNCTION TVideoschnitt.Bitrateschreiben(SequenzHeaderBitrateAdr, ExSequenzHeaderBitrateAdr: Int64; SequenzHeaderBitratePuffer: ARRAY OF Byte; SequenzHeaderBitrate: Integer; Speicherstream: TDateiPuffer): Integer;

VAR HByte : Byte;
    aktAdresse : Int64;

BEGIN
  Result := 0;
  aktAdresse := Speicherstream.AktuelleAdr;
  IF SequenzHeaderBitrateAdr > -1 THEN
  BEGIN
    Speicherstream.NeuePosition(SequenzHeaderBitrateAdr);
    HByte := (SequenzHeaderBitrate AND $3FC00) SHR 10;
    Speicherstream.SchreibenDirekt(HByte, 1);
    HByte := (SequenzHeaderBitrate AND $3FC) SHR 2;
    Speicherstream.SchreibenDirekt(HByte, 1);
    HByte := SequenzHeaderBitratePuffer[0] OR ((SequenzHeaderBitrate AND $03) SHL 6);
    Speicherstream.SchreibenDirekt(HByte, 1);
  END;
  IF ExSequenzHeaderBitrateAdr > -1 THEN
  BEGIN
    Speicherstream.NeuePosition(ExSequenzHeaderBitrateAdr);
    HByte := SequenzHeaderBitratePuffer[1] OR ((SequenzHeaderBitrate AND $3E000000) SHR 25);
    Speicherstream.SchreibenDirekt(HByte, 1);
    HByte := SequenzHeaderBitratePuffer[2] OR ((SequenzHeaderBitrate AND $01FC0000) SHR 17);
    Speicherstream.SchreibenDirekt(HByte, 1);
  END;
  IF (SequenzHeaderBitrateAdr > -1) OR (ExSequenzHeaderBitrateAdr > -1) THEN
    Speicherstream.NeuePosition(aktAdresse);
END;

FUNCTION TVideoschnitt.Bitrateneuberechnen(Speicherstream: TDateiPuffer; Liste: TListe): Integer;

VAR Bitrate,
    Aspectratio,
    I : Integer;
    Bilder : LongInt;

BEGIN
  Result := 0;
  Bilder := 0;
  FOR I := 0 TO Liste.Count - 1 DO
    IF THeaderklein(Liste[I]).HeaderTyp = $00 THEN
      Inc(Bilder);
  CASE FBitrateersterHeader OF
    1 : Bitrate := orginaleBitrate;                                             // orginale Bitrate
    2 : IF Bilder > 0 THEN
          Bitrate := Round(Speicherstream.Dateigroesse  * 8 /
                     (Bilder / BilderProSekausSeqHeaderFramerate(SequenzHeader.Framerate))) // durchschnittliche Bitrate
        ELSE
          Bitrate := 0;
    3 : Bitrate := maximaleBitrate;                                             // maximale Bitrate
    4 : Bitrate := FfesteBitrate;                                               // feste Bitrate
  ELSE
    Bitrate := 0;                                                               // nicht ändern
  END;
  CASE FAspectratioersterHeader OF
    1 : Aspectratio := orginalAspectratio;
    2 : Aspectratio := 1;
    3 : Aspectratio := 2;
    4 : Aspectratio := 3;
    5 : Aspectratio := 4;
    6 : Aspectratio := OffsetAspectratio;
  ELSE
    Aspectratio := 0;                                                               // nicht ändern
  END;
  IF Aspectratio > 0 THEN
    Aspectratioschreiben(ersterSequenzHeaderAspectratioAdr, ersterSequenzHeaderAspectratioPuffer, Aspectratio, Speicherstream);
  IF Bitrate > 0 THEN
  BEGIN
    Bitrate := Round(Bitrate / 400);
    Bitrateschreiben(ersterSequenzHeaderBitrateAdr, ersterExSequenzHeaderBitrateAdr, ersterSequenzHeaderBitratePuffer, Bitrate, Speicherstream);
  END;
END;

{Fehler:
     -1 : Schnittliste NIL oder keine Schnitte in der Schnittliste
     -2 : Schnitte ohne Video in der Schnittliste
     -3 : einen Schnitt ohne Daten gefunden
ab  -21 : Fehler beim erzeugen der Zieldatei
ab  -41 : Fehler beim öffnen der Quelldatei
ab -101 : Fehler bei der Effektberechnung über den gesamten Schnitt
ab -201 : Fehler bei der Effektberechnung am Anfang des Schnittes
ab -301 : Fehler bei der framegenauen Berechnung am Anfang des Schnittes
ab -401 : Fehler beim kopieren eines Videoteils
ab -501 : Fehler bei der Effektberechnung am Ende des Schnittes
ab -601 : Fehler bei der framegenauen Berechnung am Ende des Schnittes
}
FUNCTION TVideoschnitt.Schneiden(SchnittListe: TStrings): Integer;

VAR I : Integer;
    SchnittpunktX,                                                              
    Schnittpunkt1,
    Schnittpunkt2 : TSchnittpunkt;
//    HAnfang,
    HInt1, HInt2,
    Anfang, Ende : Int64;
    DateiName : STRING;
    Schleifenende : Boolean;
    EffektEintrag : TEffektEintrag;

BEGIN
  Result := 0;
  BildZaehler := 0;
  SequenzHeaderBitrateAdr := -1;
  ExSequenzHeaderBitrateAdr := -1;
  SequenzheaderBitrate := -1;
  SequenzHeaderBildNr := -1;
  ersterSequenzHeaderBitrateAdr := -1;
  ersterExSequenzHeaderBitrateAdr := -1;
  ersterSequenzHeaderAspectratioAdr := -1;
  orginaleBitrate := -1;
  maximaleBitrate := -1;
  orginalAspectratio := -1;
  OffsetAspectratio := -1;
  Videoschnittanhalten := False;
  Anhalten := False;
  IF Assigned(FFortschrittsEndwert) THEN
    FFortschrittsEndwert^ := 0;
  FortschrittsPosition := 0;
  IF Assigned(SchnittListe) AND
     (SchnittListe.Count > 0) THEN
  BEGIN
    I := 0;
    WHILE (I < SchnittListe.Count) AND (Result = 0) DO            // Testen ob alle Schnitte mit Videodateinamen belegt sind
    BEGIN
      SchnittpunktX := TSchnittpunkt(SchnittListe.Objects[I]);     // X. Schnitt
      IF Assigned(FFortschrittsEndwert) THEN
        FFortschrittsEndwert^ := FFortschrittsEndwert^ + SchnittpunktX.VideoGroesse;
      IF SchnittpunktX.VideoName <> '' THEN
      BEGIN
      // Hier könnte man testen ob alle Videodateien die gleichen Eigenschaften haben
      END
      ELSE
        Result := -2;                                             // alle Schnitte müssen mit einer Videodatei belegt sein
      Inc(I);
    END;
    IF Result = 0 THEN
    BEGIN
      Result := Zieldateioeffnen;
      IF Result < 0 THEN                                          // Zieldatei kann nicht geöffnet werden
      BEGIN
        Result := Result - 20;
        Fehlertext := FZieldateiname;
      END
      ELSE
        Result := 0;                                              // ob die Zieldatei schon geöffnet war ist nicht wichtig
      IF Result = 0 THEN
      BEGIN
        I := 0;                                                   // Schnittzähler
        WHILE (I < SchnittListe.Count) AND (Result = 0) DO
        BEGIN
          Sequenzheaderkopieren := True;                          // vor jedem Schnitt soll ein Sequenheader eingefügt werden
          Schnittpunkt1 := TSchnittpunkt(SchnittListe.Objects[I]); // X. Schnitt
          IF Assigned(Schnittpunkt1) THEN
          BEGIN
            TextString := IntToStr(I + 1) + ' (' + Schnittpunkt1.VideoName + ')';
            Result := Quelldateioeffnen(Schnittpunkt1.VideoName, Schnittpunkt1.VideoListe, Schnittpunkt1.VideoIndexListe);
            IF Result < 0 THEN                                    // Quelldatei kann nicht geöffnet werden
              Result := Result - 40
            ELSE
              Result := 0;                                        // ob die Quelldatei schon geöffnet war ist nicht wichtig
            IF  Result = 0 THEN
            BEGIN
              IF orginaleBitrate = -1 THEN
                orginaleBitrate := Sequenzheader.Bitrate;
              IF orginalAspectratio = -1 THEN
                orginalAspectratio := Sequenzheader.Seitenverhaeltnis;
              IF OffsetAspectratio = -1 THEN
              BEGIN
                HInt1 := Schnittpunkt1.Anfang + Round(FAspectratioOffset / BildlaengeausSeqHeaderFramerate(Sequenzheader.Framerate));
                IF HInt1 > Schnittpunkt1.Ende THEN
                  HInt1 := Schnittpunkt1.Ende;
                OffsetAspectratio := OffsetAspectratiolesen(HInt1);
              END;
              EffektEintrag := Schnittpunkt1.VideoEffekt;
              IF Assigned(EffektEintrag) AND
                 (EffektEintrag.AnfangLaenge = 0) AND (EffektEintrag.EndeLaenge = 0) AND
                 (EffektEintrag.AnfangEffektName <> '') THEN
              BEGIN                                               // Effekt über den ganzen Schnitt
                Result := Effektberechnen(Schnittpunkt1.Anfang, Schnittpunkt1.Ende,
                                          EffektEintrag.AnfangEffektDateiname, EffektEintrag.AnfangEffektName,
                                          ':eff', EffektEintrag.AnfangEffektParameter,
                                          Schnittpunkt1.Ende - Schnittpunkt1.Anfang + 1,
                                          Sequenzheader);
                IF Result < 0 THEN
                  Result := Result - 100;
              END
              ELSE
              BEGIN                                               // zwei Einzeleffekte
                IF Assigned(EffektEintrag) AND
                   (EffektEintrag.AnfangLaenge > 0) AND (EffektEintrag.AnfangEffektName <> '') THEN
                  Anfang := NaechstesBild(1, Round(EffektEintrag.AnfangLaenge * Schnittpunkt1.Framerate / 1000) + Schnittpunkt1.Anfang, IndexListe)
                ELSE
                  IF FFramegenauschneiden AND                     // framegenau
                     ((Schnittpunkt1.Anfangberechnen AND $80) = $00) THEN  // berechnen
                  BEGIN
                    Anfang := NaechstesBild(1, Schnittpunkt1.Anfang, IndexListe);
                    IF (Anfang - Schnittpunkt1.Anfang > 0) AND (Anfang - Schnittpunkt1.Anfang < FminAnfang) THEN
                      Anfang := NaechstesBild(1, Schnittpunkt1.Anfang + FminAnfang, IndexListe);
                  END
                  ELSE
                  BEGIN                                           // nicht framegenau
                    Anfang := Bildsuchen(1, Schnittpunkt1.Anfang, IndexListe); // nächstgelegenes I-Frame suchen
                    Schnittpunkt1.Anfang := Anfang;
                  END;
//                HAnfang := Schnittpunkt.Anfang;
                IF FZusammenhaengendeSchnitteberechnen THEN
                  Schleifenende := True
                ELSE
                  Schleifenende := False;
                Schnittpunkt2 := Schnittpunkt1;
                WHILE (I + 1 < SchnittListe.Count) AND (NOT Schleifenende) DO // zusammengehörende Schnittpunkte überspringen
                BEGIN
                  SchnittpunktX := TSchnittpunkt(SchnittListe.Objects[I + 1]);  // nächster Schnitt
                  IF ((Schnittpunkt2.VideoEffekt.EndeLaenge = 0) OR (Schnittpunkt2.VideoEffekt.EndeEffektName = '')) AND       // kein Effekt am Ende des letzten Schnittpunkts
                     (((SchnittpunktX.VideoEffekt.AnfangLaenge = 0) AND (SchnittpunktX.VideoEffekt.EndeLaenge > 0)) OR (SchnittpunktX.VideoEffekt.AnfangEffektName = '')) AND // kein Effekt am Anfang des nächsten Schnittpunkts und kein Effekt über den gesamten nächsten Schnitt
                     (Schnittpunkt2.VideoName = SchnittpunktX.VideoName) AND    // gleiches Video bei beiden Schnitten
                     (Schnittpunkt2.Ende = SchnittpunktX.Anfang - 1) THEN       // der nächste Schnitt beginnt gleich nach dem letzten Schnitt
                  BEGIN
                    Schnittpunkt2 := SchnittpunktX;               // die Schnittpunkte passen zusammen, der nächste Schnitt wird zum letzten Schnitt
                    Inc(I);                                       // nächsten Schnittpunkt versuchen
                  END
                  ELSE
                    Schleifenende := True;                        // die Schnittpunkte passen nicht zusammen
                END;
                EffektEintrag := Schnittpunkt2.VideoEffekt;
                IF Assigned(EffektEintrag) AND
                   (EffektEintrag.EndeLaenge > 0) AND (EffektEintrag.EndeEffektName <> '') THEN
                  Ende := VorherigesBild(2, Schnittpunkt2.Ende - Round(EffektEintrag.EndeLaenge * Schnittpunkt2.Framerate / 1000), IndexListe) // Endeeffekt
                ELSE
                  IF FFramegenauschneiden AND                     // framegenau
                     ((Schnittpunkt2.Endeberechnen AND $80) = $00) THEN  // berechnen
                  BEGIN
                    Ende := VorherigesBild(2, Schnittpunkt2.Ende, IndexListe);
                    IF (Schnittpunkt2.Ende - Ende > 0) AND (Schnittpunkt2.Ende - Ende < FminEnde) THEN
                      Ende := VorherigesBild(2, Schnittpunkt2.Ende - FminEnde, IndexListe);
                  END
                  ELSE
                  BEGIN                                           // nicht framegenau
                    Ende := Bildsuchen(2, Schnittpunkt2.Ende, IndexListe); // nächstgelegenes I-, oder P-Frame suchen
                    Schnittpunkt2.Ende := Ende;
                  END;
                IF Anfang > Schnittpunkt2.Ende + 1 THEN
                  Anfang := Schnittpunkt2.Ende + 1;               // Der Anfangseffekt darf nicht länger als der Schnitt sein
                IF Anfang > Ende THEN
                  Ende := Anfang - 1;                             // Der Endeeffekt darf nicht vor dem Ende des Anfangseffektes beginnen
                EffektEintrag := Schnittpunkt1.VideoEffekt;
                IF Assigned(EffektEintrag) AND
                   (EffektEintrag.AnfangLaenge > 0) AND (EffektEintrag.AnfangEffektName <> '') THEN
                BEGIN                                             // Anfangseffekt
                  Result := Effektberechnen(Schnittpunkt1.Anfang, Anfang - 1,
                                            EffektEintrag.AnfangEffektDateiname, EffektEintrag.AnfangEffektName,
                                            ':eff', EffektEintrag.AnfangEffektParameter,
                                            Round(EffektEintrag.AnfangLaenge * Schnittpunkt1.Framerate / 1000),
                                            Sequenzheader, 'In');
                  IF Result < 0 THEN
                    Result := Result - 200;
                END
                ELSE
                BEGIN                                             // kein Anfangseffekt
                  IF FFramegenauschneiden AND                     // framegenau
                     ((Schnittpunkt1.Anfangberechnen AND $80) = $00) THEN  // berechnen
                  BEGIN
                    Result := Effektberechnen(Schnittpunkt1.Anfang, Anfang - 1,
                                              FEncoderDatei, '', ':enc', '', -1,
                                              Sequenzheader);
                    IF Result < 0 THEN
                      Result := Result - 300;
                  END;
                END;
                IF Result = 0 THEN
                BEGIN
                  REPEAT
                    HInt1 := Ende;
                    HInt2 := Ende;
                    IF FmaxGOPLaenge > 0 THEN
                      LangeGOPsuchen(Anfang, Ende, HInt1, HInt2, FmaxGOPLaenge, FminEnde);
                    Result := KopiereVideoteil(Anfang, HInt1, Schnittpunkt1.Framerate, Dateistream, Speicherstream, NeueListe, True, True, True, Bildzaehler);
                    IF Ende < HInt2 THEN
                      HInt2 := Ende;
                    IF Result < 0 THEN
                      Result := Result - 400;
                    IF (Result > -1) AND (HInt1 < HInt2) THEN
                    BEGIN
                      Result := Effektberechnen(HInt1 + 1, HInt2,
                                                FEncoderDatei, '', ':enc', '', -1,
                                                Sequenzheader);
                      IF Result < 0 THEN
                        Result := Result - 700;
                    END;
                    Anfang := HInt2 + 1;
                  UNTIL (HInt2 = Ende) OR (Result < 0);
            {      FOR x := 0 TO 5000 DO
                  BEGIN
//                    KopiereVideoteil(24, 30, Schnittpunkt.Framerate, Dateistream, Speicherstream, NeueListe, True, True, True, Bildzaehler);
                    KopiereSegmentDatei(0, 10000,
                                  Dateistream, Speicherstream, NeueListe,
                                  25, False, True, True,
                                  z, y, Bildzaehler, False,
                                  True, '');      // Dateiteil kopieren und korrigieren (Tempreferenz und Timecode)
                    FTextanzeige(4, IntToStr(x));
                  END;    }
                 EffektEintrag := Schnittpunkt2.VideoEffekt;
                 IF Result > -1 THEN
                    IF Assigned(EffektEintrag) AND
                       (EffektEintrag.EndeLaenge > 0) AND (EffektEintrag.EndeEffektName <> '') THEN
                    BEGIN                                         // Endeeffekt
                      Result := Effektberechnen(Ende + 1, Schnittpunkt2.Ende,
                                                EffektEintrag.EndeEffektDateiname, EffektEintrag.EndeEffektName,
                                                ':eff', EffektEintrag.EndeEffektParameter,
                                                Trunc(EffektEintrag.EndeLaenge * Schnittpunkt2.Framerate / 1000),
                                                Sequenzheader, 'Out');
                      IF Result < 0 THEN
                        Result := Result - 500;
                    END
                    ELSE                                          // kein Endeeffekt
                      IF FFramegenauschneiden AND                 // framegenau
                         ((Schnittpunkt2.Endeberechnen AND $80) = $00) THEN // berechnen
                      BEGIN
                        Result := Effektberechnen(Ende + 1, Schnittpunkt2.Ende,
                                                  FEncoderDatei, '', ':enc', '', -1,
                                                  Sequenzheader);
                        IF Result < 0 THEN
                          Result := Result - 600;
                      END;
                END;
              END;
            END;
          END
          ELSE
            Result := -3;                                         // Schnitt ohne Daten gefunden
          Inc(I);                                                 // nächster Schnitt
        END;
        IF Result = 0 THEN
        BEGIN
          SequenzEndeanhaengen(Speicherstream, Neueliste, True);
          Bitrateneuberechnen(Speicherstream, Neueliste);
        END;  
      END;
      IF Anhalten OR (Result < 0) THEN                            // Abbruch durch Anwender oder Fehler
      BEGIN
//------------------------------------------------------------------------------
        DateiName := FZieldateiname;                              // Dateiname merken
// Zieldateischliessen ohne eine Indexdatei zu schreiben sollte durch Optionen geregelt werden
        NeueListe.Loeschen;                                       // neue Liste löschen, dadurch wird keine *.idd Datei gespeichert
        Zieldateischliessen;                                      // erzeugte Datei schliessen
// die Zieldatei kann von der Funktion Zieldateischliessen im Basisobjekt erledigt werden
        IF FileExists(DateiName) THEN                             // und löschen
          DeleteFile(DateiName);
// der Sinn der Variable Videoschnittanhalten ist zu prüfen
        Videoschnittanhalten := True;                             // globale Variable, sagt weiteren Proceduren das Schluss ist
//------------------------------------------------------------------------------
      END;
    END;
  END
  ELSE
    Result := -1;                                                 // keine Schnitte in der Liste
END;

// kopiert ein Mpeg2Videoteilstück
//     0 : Ok
//    -1 : vor dem Anfangsschnitt muß ein Gruppenheader stehen
//    -2 : vor dem Anfangsschnitt muß mindestens ein Sequenzheader vorhanden sein
//    -3 : der Schnitt muß mit einem Bildheader beginnen
//    -4 : der Schnitt muß mit einem Bildheader enden
//ab -21 : Fehler in KopiereSegmentDatei des Sequenzheaders
//ab -41 : Fehler in KopiereSegmentDatei des Teils vor den herrenlosen Frames
//ab -61 : Fehler in KopiereSegmentDatei des Hauptteils
FUNCTION TVideoschnitt.KopiereVideoteil(AnfangsIndex, EndIndex: Int64;
                                        Framerate: Real;
                                        QuellDateistream, ZielDateistream: TDateiPuffer;
                                        ZielListe: TListe;
                                        Textanzeigen, Fortschrittanzeigen: Boolean;
                                        IstZieldatei: Boolean;
                                        VAR Bildzaehler: LongInt): Integer;

VAR HSequenzHeaderAdr,
    HSequenzHeaderEnde,
    HAnfangAdr1,
    HEndeAdr,
    HAnfangAdr2,
    HAdresse,
    Anfangadr, Endadr : Int64;
    erstesBild : Boolean;
    BildDiff : Word;

FUNCTION Headertype(Adresse: Int64): Integer;

VAR Puffer : ARRAY[0..3] OF Byte;

BEGIN
  QuellDateistream.NeuePosition(Adresse);
  QuellDateistream.LesenX(Puffer, 4);
  Result := Puffer[3];
END;

FUNCTION Startcodesuchenvorwaerts(VAR Adresse: Int64; CONST Header: TStartCodes = [$00, $B3, $B7, $B8]): Byte;

VAR Byte1 : Byte;
    Byte4 : Longword;

BEGIN
  QuellDateistream.NeuePosition(Adresse);
  Byte4 := $FFFFFFFF;
  WHILE (NOT QuellDateistream.DateiEnde) AND
        (NOT (((Byte4 AND $FFFFFF00) = $100) AND
        ((Byte4 AND $FF) IN Header))) DO
  BEGIN
    QuellDateistream.Lesen(Byte1);
    Byte4 := (Byte4 SHL 8) OR Byte1;
    Inc(Adresse);
  END;
  Result := Byte1;
  Dec(Adresse, 4);
END;

FUNCTION Startcodesuchenrueckwaerts(VAR Adresse: Int64; CONST Header: TStartCodes = [$00, $B3, $B7, $B8]): Byte;

VAR Byte1 : Byte;
    Byte4 : Longword;

BEGIN
  QuellDateistream.NeuePosition(Adresse);
  Byte4 := $FFFFFFFF;
  WHILE (Adresse > -1) AND
        (NOT (((Byte4 AND $FFFFFF) = $10000) AND
        (((Byte4 AND $FF000000) SHR 24) IN Header))) DO
  BEGIN
    QuellDateistream.Lesen(Byte1);
    Byte4 := (Byte4 SHL 8) OR Byte1;
    Dec(Adresse);
    QuellDateistream.NeuePosition(Adresse);
  END;
  Inc(Adresse);
  Result := (Byte4 AND $FF000000) SHR 24;
END;

FUNCTION grTempRefsuchen(VAR Adresse: Int64): Int64;

VAR TempRef,
    HTempRef: Word;
    Puffer : ARRAY [0..1] OF Byte;

BEGIN
  Result := -1;
//  QuellDateistream.LesenX(TempRef, 2);
//  TempRef := TempRef AND $FFC0;
  QuellDateistream.LesenX(Puffer, 2);
  TempRef := (Puffer[0] SHL 2) +                               // TempReferenz einlesen
             ((Puffer[1] AND $C0) SHR 6);
  REPEAT                                                       // nächstes Bild mit höherem Temprefer suchen
    Inc(Adresse, 6);
    IF Startcodesuchenvorwaerts(Adresse) = BildStartCode THEN
    BEGIN
      IF Result = -1 THEN
        Result := Adresse - 1;                                 // Ende des I-Frames
//      QuellDateistream.LesenX(HTempRef, 2);
//      HTempRef := HTempRef AND $FFC0;
      QuellDateistream.LesenX(Puffer, 2);
      HTempRef := (Puffer[0] SHL 2) +                          // TempReferenz einlesen
                  ((Puffer[1] AND $C0) SHR 6);
    END
    ELSE
      HTempRef := 9999;
  UNTIL (HTempRef > TempRef) OR (HTempRef = 9999) OR (QuellDateistream.DateiEnde);
  IF Result + 1 = Adresse THEN
    Result := -1;                                              // keine herrenlosen B-Frames
END;

BEGIN
//  Sartzeitsetzen;
  Result := 0;
  IF AnfangsIndex < EndIndex + 1 THEN
  BEGIN
  // Bildtypen prüfen? (am Anfang sind nur I-Frames erlaubt)
    erstesBild := True;
    BildDiff := 0;
  //------------------------------------------------------------------------------
  // Videoliste, Indexliste
    Anfangadr := THeaderklein(Liste[TBildIndex(IndexListe[AnfangsIndex]).BildIndex]).Adresse;
    Endadr := THeaderklein(Liste[TBildIndex(IndexListe[EndIndex]).BildIndex]).Adresse;
  // -----------------------------------------------------------------------------
    HSequenzHeaderAdr := -1;
    HSequenzHeaderEnde := -1;
    HAnfangAdr1 := -1;
    HAdresse := Anfangadr;
    IF Startcodesuchenrueckwaerts(HAdresse) = GruppenStartCode THEN    // Gruppenheader suchen
    BEGIN
      HAnfangAdr2 := HAdresse;                                         // Gruppenheaderadresse
      Dec(HAdresse);
      IF Startcodesuchenrueckwaerts(HAdresse) = SequenceStartCode THEN // Sequenzheader suchen
        HAnfangAdr2 := HAdresse                                        // Sequenzheaderadresse
      ELSE
      BEGIN                                                            // direkt vor dem Gruppenheader steht kein Sequenzheader
        IF Sequenzheaderkopieren THEN                                  // Sequenzheader ist nötig
        BEGIN
  //------------------------------------------------------------------------------
  // Videoliste, Indexliste
          AnfangsIndex := TBildIndex(IndexListe[AnfangsIndex]).BildIndex;
          REPEAT                                                       // Sequenzheader vor dem ersten Bild suchen
            Dec(AnfangsIndex);
          UNTIL (AnfangsIndex < 0) OR (THeaderklein(Liste[AnfangsIndex]).HeaderTyp = SequenceStartCode);
          IF AnfangsIndex < 0 THEN
            Result := -2                                               // kein Sequenzheader gefunden
          ELSE
          BEGIN
            HSequenzHeaderAdr := THeaderklein(Liste[AnfangsIndex]).Adresse;
            HSequenzHeaderEnde := THeaderklein(Liste[AnfangsIndex + 1]).Adresse - 1;
          END;
  // -----------------------------------------------------------------------------
        END;
      END;
      IF Result = 0 THEN
      BEGIN
        IF Headertype(Anfangadr) = BildStartCode THEN                  // die Anfangsadresse muß auf ein Bild zeigen
        BEGIN
          HEndeAdr := grTempRefsuchen(Anfangadr);
          IF HEndeAdr > -1 THEN
          BEGIN
            HAnfangAdr1 := HAnfangAdr2;                                // herrenlosen B-Frames vorhanden
            HAnfangAdr2 := Anfangadr;
          END;
          IF Headertype(Endadr) = BildStartCode THEN                   // der Endindex muß auf ein Bild zeigen
          BEGIN
            grTempRefsuchen(Endadr);                                   // Bilder mit kleinerer Tempreferenz mit kopieren
            IF HSequenzHeaderAdr > -1 THEN
            BEGIN
              Result := KopiereSegmentDatei(HSequenzHeaderAdr, HSequenzHeaderEnde,
                                  QuellDateistream, ZielDateistream, ZielListe,
                                  Framerate, False, False, Fortschrittanzeigen,
                                  erstesBild, BildDiff, Bildzaehler, FBitratekorrigieren,
                                  IstZieldatei);                  // Sequenzheader kopieren und korrigieren (Bitrate)
              IF Result < 0 THEN
                Result := Result - 20;
            END;
            IF Result = 0 THEN
            BEGIN
              IF HAnfangAdr1 > -1 THEN
              BEGIN                                                    // nach dem Anfangsbild stehen Bilder mit kleinerer Temprefer
                Result := KopiereSegmentDatei(HAnfangAdr1, HEndeAdr,
                                  QuellDateistream, ZielDateistream, ZielListe,
                                  Framerate, True, False, Fortschrittanzeigen,
                                  erstesBild, BildDiff, Bildzaehler, FBitratekorrigieren,
                                  IstZieldatei);                  // erstes Bild kopieren und korrigieren (Tempreferenz)
                IF Result < 0 THEN
                  Result := Result - 40;
              END;
              IF Result = 0 THEN
              BEGIN
                Result := KopiereSegmentDatei(HAnfangAdr2, Endadr - 1,
                                  QuellDateistream, ZielDateistream, ZielListe,
                                  Framerate, False, Textanzeigen, Fortschrittanzeigen,
                                  erstesBild, BildDiff, Bildzaehler, FBitratekorrigieren,
                                  IstZieldatei, TextString);      // Dateiteil kopieren und korrigieren (Tempreferenz und Timecode)
                IF Result < 0 THEN
                  Result := Result - 60;
              END;
            END;
          END
          ELSE
            Result := -4;                                              // am Ende des Schnittes muß ein Bildheader stehen
        END
        ELSE
          Result := -3;                                                // der Schnitt muß mit einem Bildheader beginnen
      END
      ELSE
        Result := -2                                                   // in der Datei muß mindestens ein Sequenzheader vorhanden sein
    END
    ELSE
      Result := -1;                                                    // vor dem Anfangsschnitt muß ein Gruppenheader stehen
  END;
//  Showmessage(Inttostr(Zeitdauerlesen_milliSek));
END;

// kopiert ein Teilstück eines Mpeg2Videoteils und korrigiert die Header
//   0 : Ok
//  -1 : Quellobjekt oder Zielobjekt ist NIL
//  -2 : Quelldatei nicht geöffnet
//  -3 : Zieldatei nicht geöffnet
//  -4 : -- kein Fehler --- Anfangsadresse liegt nicht vor der Endadresse
//  -5 : Fehler beim lesen aus der Quelldatei
//  -6 : Fehler beim schreiben in die Zieldatei
//  -7 : zu wenig in die Zieldatei geschrieben (weniger als 4GB)
//  -8 : zu wenig in die Zieldatei geschrieben (mehr als 4GB - 10 Byte)
//  -9 : zu wenig aus der Quelldatei gelesen
// -10 : während der Fortschrittsanzeige abgebrochen
FUNCTION TVideoschnitt.KopiereSegmentDatei(AnfangsAdr, EndAdr: Int64;
                                           QuellDateistream, ZielDateistream: TDateiPuffer;
                                           ZielListe: TListe;
                                           Framerate: Real;
                                           aendern,
                                           Textanzeigen, Fortschrittanzeigen: Boolean;
                                           VAR erstesBild: Boolean;
                                           VAR BildDiff: Word;
                                           VAR Bildzaehler: LongInt;
                                           Bitrateberechnen: Boolean;
                                           IstZieldatei: Boolean;
                                           Anzeigetext: STRING = ''): Integer;

VAR aktAdresse,
    AnfangsZielAdr : Int64;
 //   Puffer : PChar;
 //   PufferGr,
    Groesse,
    PufferPos,
    HBitrate : Integer;
    Headerklein : THeaderklein;
    Tempreferenz : Word;
    Stunde,
    Minute,
    Sekunde : Byte;
    Bilder : Word;

FUNCTION PufferPossetzen(AdrDiff: Integer; Benoetigt: Integer = 1): Integer;

VAR Menge : Integer;

BEGIN
  Result := 0;
  PufferPos := PufferPos + AdrDiff;
  WHILE (Result = 0) AND (PufferPos + Benoetigt > Groesse) DO
  BEGIN
    IF aktAdresse + Groesse > EndAdr THEN          // Ende erreicht
      Result := 1
    ELSE
      IF PufferPos < Groesse THEN
        Groesse := PufferPos;
    aktAdresse := aktAdresse + Groesse;
    PufferPos := PufferPos - Groesse;
    IF Groesse > 0 THEN
    BEGIN
//------------------------------------------------------------------------------
// es ist zu überlegen ob die Prüfung der geschriebenen Datenmenge in das neue Dateistreamobjekt ausgelagert wird
      Menge := ZielDateistream.SchreibenDirekt(Puffer^, Groesse);
      IF Menge < Groesse THEN
        IF Menge < 0 THEN
          Result := -6                               // Fehler beim Zieldatei schreiben
        ELSE
          IF ZielDateistream.AktuelleAdr > 4294967296 - 10 THEN
            Result := -8                             // zu wenig geschrieben, 4GB-Grenze erreicht
          ELSE
            Result := -7;                            // zu wenig geschrieben
//------------------------------------------------------------------------------
    END;
    IF Result = 0 THEN
    BEGIN
      IF (EndAdr - aktAdresse + 1) > PufferGr THEN
        Groesse := PufferGr
      ELSE
        Groesse := EndAdr - aktAdresse + 1;
//------------------------------------------------------------------------------
// es ist zu überlegen ob die Prüfung der gelesenen Datenmenge in das neue Dateistreamobjekt ausgelagert wird
      IF aktAdresse <> QuellDateistream.AktuelleAdr THEN
        QuellDateistream.NeuePosition(aktAdresse);
      Menge := QuellDateistream.LesenDirekt(Puffer^, Groesse);
      IF Menge < Groesse THEN
        IF Menge < 0 THEN
          Result := -5                               // Fehler beim Quelldatei lesen
        ELSE
          Result := -9;                              // zu wenig gelesen
//------------------------------------------------------------------------------
    END;
  END;
END;

BEGIN
  IF Assigned(FTextanzeige) AND Textanzeigen THEN
    FTextanzeige(4, Anzeigetext);
  IF Assigned(QuellDateistream) AND Assigned(ZielDateistream) THEN
  BEGIN
    IF ((QuellDateistream.DateiMode AND $F) = fmOpenRead) OR
       ((QuellDateistream.DateiMode AND $F) = fmOpenReadWrite) THEN
      IF (ZielDateistream.DateiMode = fmCreate) OR
         ((ZielDateistream.DateiMode AND $F) = fmOpenWrite) OR
         ((ZielDateistream.DateiMode AND $F) = fmOpenReadWrite) THEN
      BEGIN
        IF AnfangsAdr < 0 THEN                             // Anfangsadresse prüfen und eventuell
          AnfangsAdr := 0;                                 // auf Null setzen
        IF EndAdr > QuellDateistream.Dateigroesse - 1 THEN // Endadresse prüfen und eventuell
          EndAdr := QuellDateistream.Dateigroesse - 1;     // auf maximalen Wert setzen
        IF (AnfangsAdr < EndAdr + 1) THEN                  // Anfang liegt vor dem Ende
        BEGIN
          AnfangsZielAdr := ZielDateistream.AktuelleAdr;
          QuellDateistream.Pufferfreigeben;
   //       PufferGr := 1048576;                             // 1 MByte
   //       GetMem(Puffer, PufferGr);                        // in den Konstruktor verlagert da sonst Speicherfehler EOutOfMemory
   //       TRY
            Groesse := 0;
            PufferPos := 0;
            aktAdresse := AnfangsAdr;                      // Startadresse zum kopieren
            REPEAT                                         // Datenbereich korrigieren
              Result := PufferPossetzen(0, 4);
              WHILE (Result = 0) AND                       // Header suchen
                    NOT((Byte(Puffer[PufferPos]) = 0) AND
                    (Byte(Puffer[PufferPos + 1]) = 0) AND
                    (Byte(Puffer[PufferPos + 2]) = 1))DO
                Result := PufferPossetzen(1, 4);
              IF Result = 0 THEN
              BEGIN
                CASE Byte(Puffer[PufferPos + 3]) OF
                BildStartCode :                            // Bildstartcode gefunden
                BEGIN
                  Inc(BildZaehler);                        // Bildzähler erhöhen
                  Result := PufferPossetzen(4, 2);
                  IF Result = 0 THEN
                  BEGIN
                    Tempreferenz := (Byte(Puffer[PufferPos]) SHL 2) + // TempReferenz einlesen
                                    ((Byte(Puffer[PufferPos + 1]) AND $C0) SHR 6);
                    IF erstesBild  THEN                    // Ist es das ersten Bild des Abschnitts
                    BEGIN                                  // muß die Bilddifferenz gesetzt werden
                      erstesBild := False;
                      BildDiff := Tempreferenz;            // Bilddifferenz zum ersten kopierten Bild
                    END;
                    IF BildDiff > 0 THEN                   // TempReferenz neu schreiben
                    BEGIN
                      Tempreferenz := Tempreferenz - BildDiff; // TempReferenz berechnen
                      Byte(Puffer[PufferPos]) := Tempreferenz SHR 2;  // Bit 10 - 2 von 10 Bit Tempref
                      Byte(Puffer[PufferPos + 1]) := ((Tempreferenz AND $0003) SHL 6) OR // Bit 1 und 0 von 10 Bit Tempref
                                                     (Byte(Puffer[PufferPos + 1]) AND $3F); // Bildtype (Bit 5, 4 und 3) und 3 Bit von VBVDelay
                    END;
                    IF (FIndexDateierstellen OR FD2VDateierstellen OR
                        FIDXDateierstellen OR TempD2VDateierstellen) AND // Wenn eine neue Indexdatei erstellt werden soll,
                       Assigned(ZielListe) THEN
                    BEGIN
                      Headerklein := THeaderklein.Create;  // neuen Listenpunkt erzeugen,
                      Headerklein.HeaderTyp := BildStartCode; // Headertyp eintragen,
                      Headerklein.Adresse   := aktAdresse - AnfangsAdr + AnfangsZielAdr + PufferPos - 4; // neue Adresse berechnen,
                      Headerklein.TempRefer := Tempreferenz; // Tempreferenz eintragen
                      Headerklein.BildTyp   := (Byte(Puffer[PufferPos + 1]) AND $38) SHR 3; // Bildtyp eintragen
                      ZielListe.Add(Headerklein);          // und zur Liste hinzufügen.
                    END
                    ELSE
                      Headerklein := NIL;
                    Result := PufferPossetzen(4, 5);
                    WHILE (Result = 0) AND
                          NOT((Byte(Puffer[PufferPos]) = 0) AND
                          (Byte(Puffer[PufferPos + 1]) = 0) AND
                          (Byte(Puffer[PufferPos + 2]) = 1))DO
                      Result := PufferPossetzen(1, 5);
                    IF Result = 0 THEN
                    BEGIN
                      IF (Byte(Puffer[PufferPos + 3]) = ErweiterterCode) AND
                         (Byte(Puffer[PufferPos + 4]) AND $F0 = $80) THEN  // erweiterter Header mit "Picture coding extension"
                      BEGIN
                        Result := PufferPossetzen(7, 1);
                        IF Result = 0 THEN
                        BEGIN
                          IF (FD2VDateierstellen OR TempD2VDateierstellen) AND
                              Assigned(Headerklein) THEN
                          BEGIN
                            IF (Byte(Puffer[PufferPos]) AND $80) = $80 THEN // oberstes Bild zuerst
                              Headerklein.BildTyp := Headerklein.BildTyp OR $80;
                            IF (Byte(Puffer[PufferPos]) AND $02) = $02 THEN // repeat_first_field
                              Headerklein.BildTyp := Headerklein.BildTyp OR $40;
                          END;
                          Result := PufferPossetzen(1);
                        END;
                      END
                      ELSE
                        Result := PufferPossetzen(4);
                    END;
                  END;
                END;
                GruppenStartCode :                         // Gruppenstartcode gefunden
                BEGIN
                  Result := PufferPossetzen(4, 4);
                  IF Result = 0 THEN
                  BEGIN                                    // Puffer reicht für den GruppenHeader
                    BildDiff := 0;                         // Bilddifferenz zurücksetzen
                    IF FTimecodekorrigieren THEN
                    BEGIN
                      Stunde := Trunc(BildZaehler / 90000); // Timecode aus Bildzähler berechnen
                      Minute := Trunc((BildZaehler - Stunde * 90000) / 1500);
                      Sekunde := Trunc((BildZaehler - Stunde * 90000 - Minute * 1500) / Framerate);
                      Bilder := Round(BildZaehler - Stunde * 90000 - Minute * 1500 - Sekunde * Framerate);
                      Byte(Puffer[PufferPos]) := (Byte(Puffer[PufferPos]) AND $80) OR // 1 Bit Dropframe
                                                 ((Stunde AND $3F) SHL 2) OR          // 5 Bit Stunde
                                                 ((Minute AND $30) SHR 4);            // 2 Bit von Minute
                      Byte(Puffer[PufferPos + 1]) := (Byte(Puffer[PufferPos + 1]) AND $08) OR // 1 Bit Marker
                                                     ((Minute AND $0F) SHL 4) OR      // 4 Bit von Minute
                                                     ((Sekunde AND $38) SHR 3);       // 3 Bit von Sekunde
                      Byte(Puffer[PufferPos + 2]) := ((Sekunde AND $07) SHL 5) OR     // 3 Bit von Sekunde
                                                     ((Bilder AND $3E) SHR 1);        // 5 Bit von Bild
                      Byte(Puffer[PufferPos + 3]) := ((Bilder AND $01) SHL 7) OR      // 1 Bit von Bild
                                                     ((Byte(aendern) SHL 6) OR        // wenn aendern dann Closed Group
                                                     (Byte(Puffer[PufferPos + 3]) AND $40)) OR // oder Orginalbit Closed Group
                                                     (Byte(Puffer[PufferPos + 3]) AND $20); // Bit für broken Link
                    END;
                    IF (FIndexDateierstellen OR FD2VDateierstellen OR
                        FIDXDateierstellen OR TempD2VDateierstellen) AND // Wenn eine neue Indexdatei erstellt werden soll,
                       Assigned(ZielListe) THEN
                    BEGIN
                      Headerklein := THeaderklein.Create;  // neuen Listenpunkt erzeugen,
                      Headerklein.HeaderTyp := GruppenStartCode; // Headertyp eintragen,
                      Headerklein.Adresse   := aktAdresse - AnfangsAdr + AnfangsZielAdr + PufferPos - 4; // neue Adresse berechnen,
                      ZielListe.Add(Headerklein);          // und zur Liste hinzufügen.
                    END;
                    Result := PufferPossetzen(4);
                  END;
                END;
                SequenceStartCode :                        // Sequenzstartcode gefunden
                BEGIN
                  IF IstZieldatei THEN
                  BEGIN
                    IF SequenzHeaderBildNr > -1 THEN
                    BEGIN
                      HBitrate := Round((aktAdresse - AnfangsAdr + AnfangsZielAdr + PufferPos -
                                         (SequenzHeaderBitrateAdr - 8)) * 8 /
                                        ((BildZaehler - SequenzHeaderBildNr) / Framerate) / 400); // durchschnittliche Bitrate
                      SequenzHeaderBildNr := -1;
                      IF SequenzHeaderBitrate <> HBitrate THEN
                      BEGIN
                        SequenzHeaderBitrate := HBitrate;
                        IF SequenzHeaderBitrateAdr > -1 THEN
                          IF (SequenzHeaderBitrateAdr > aktAdresse - AnfangsAdr + AnfangsZielAdr - 1) AND
                             (SequenzHeaderBitrateAdr + 2 - (aktAdresse - AnfangsAdr + AnfangsZielAdr) < PufferGr) THEN       // Speicherbereich ist noch im Puffer
                          BEGIN
                            Byte(Puffer[SequenzHeaderBitrateAdr - (aktAdresse - AnfangsAdr + AnfangsZielAdr)]) := (SequenzHeaderBitrate AND $3FC00) SHR 10;
                            Byte(Puffer[SequenzHeaderBitrateAdr + 1 - (aktAdresse - AnfangsAdr + AnfangsZielAdr)]) := (SequenzHeaderBitrate AND $3FC) SHR 2;
                            Byte(Puffer[SequenzHeaderBitrateAdr + 2 - (aktAdresse - AnfangsAdr + AnfangsZielAdr)]) := (Byte(Puffer[SequenzHeaderBitrateAdr + 2 - (aktAdresse - AnfangsAdr + AnfangsZielAdr)]) AND $3F) OR ((SequenzHeaderBitrate AND $03) SHL 6);
                            SequenzHeaderBitrateAdr := -1;
                          END;
                        IF ExSequenzHeaderBitrateAdr > -1 THEN
                          IF (ExSequenzHeaderBitrateAdr > aktAdresse - AnfangsAdr + AnfangsZielAdr - 1) AND
                             (ExSequenzHeaderBitrateAdr + 1 - (aktAdresse - AnfangsAdr + AnfangsZielAdr) < PufferGr) THEN       // Speicherbereich ist noch im Puffer
                          BEGIN
                            Byte(Puffer[ExSequenzHeaderBitrateAdr - (aktAdresse - AnfangsAdr + AnfangsZielAdr)]) := (Byte(Puffer[ExSequenzHeaderBitrateAdr - (aktAdresse - AnfangsAdr + AnfangsZielAdr)]) AND $E0) OR (SequenzHeaderBitrate AND $3E000000) SHR 25;
                            Byte(Puffer[ExSequenzHeaderBitrateAdr + 1 - (aktAdresse - AnfangsAdr + AnfangsZielAdr)]) := (Byte(Puffer[ExSequenzHeaderBitrateAdr + 1 - (aktAdresse - AnfangsAdr + AnfangsZielAdr)]) AND $01) OR (SequenzHeaderBitrate AND $01FC0000) SHR 17;
                            ExSequenzHeaderBitrateAdr := -1;
                          END;
                        Bitrateschreiben(SequenzHeaderBitrateAdr, ExSequenzHeaderBitrateAdr, SequenzHeaderBitratePuffer, SequenzHeaderBitrate, ZielDateistream);
                        SequenzHeaderBitrateAdr := -1;
                        ExSequenzHeaderBitrateAdr := -1;
                      END;
                    END;
                    IF SequenzHeaderBitrate * 400 > maximaleBitrate THEN
                      maximaleBitrate := SequenzHeaderBitrate * 400;
                  END;
                  Result := PufferPossetzen(7);
                  IF Result = 0 THEN
                  BEGIN
                    IF IstZieldatei THEN
                      IF ersterSequenzHeaderAspectratioAdr = -1 THEN
                      BEGIN
                        ersterSequenzHeaderAspectratioAdr := aktAdresse - AnfangsAdr + AnfangsZielAdr + PufferPos;
                        ersterSequenzHeaderAspectratioPuffer := Byte(Puffer[PufferPos]) AND $0F;
                      END;
                    Result := PufferPossetzen(1, 4);
                    IF Result = 0 THEN
                    BEGIN
                      IF IstZieldatei THEN
                      BEGIN
                        IF Bitrateberechnen THEN
                        BEGIN
                          SequenzHeaderBitrateAdr := aktAdresse - AnfangsAdr + AnfangsZielAdr + PufferPos;
                          SequenzHeaderBitratePuffer[0] := Byte(Puffer[PufferPos + 2]) AND $3F;
                          SequenzHeaderBildNr := BildZaehler;
                        END;
                        IF ersterSequenzHeaderBitrateAdr = -1 THEN
                        BEGIN
                          ersterSequenzHeaderBitrateAdr := aktAdresse - AnfangsAdr + AnfangsZielAdr + PufferPos;
                          ersterSequenzHeaderBitratePuffer[0] := Byte(Puffer[PufferPos + 2]) AND $3F;
                        END;
                        SequenzHeaderBitrate := (Byte(Puffer[PufferPos]) SHL 10) + (Byte(Puffer[PufferPos + 1]) SHL 2) + ((Byte(Puffer[PufferPos + 2]) AND $C0) SHR 6);
                      END;
                      IF (FIndexDateierstellen OR FD2VDateierstellen OR
                          FIDXDateierstellen OR TempD2VDateierstellen) AND // Wenn eine neue Indexdatei erstellt werden soll,
                         Assigned(ZielListe) THEN
                      BEGIN
                        Headerklein := THeaderklein.Create;  // neuen Listenpunkt erzeugen,
                        Headerklein.HeaderTyp := SequenceStartCode; // Headertyp eintragen,
                        Headerklein.Adresse   := aktAdresse - AnfangsAdr + AnfangsZielAdr + PufferPos - 8; // neue Adresse berechnen,
                        ZielListe.Add(Headerklein);          // und zur Liste hinzufügen.
                      END;
                      Result := PufferPossetzen(3);
                      IF Result = 0 THEN
                      BEGIN
                        IF (Byte(Puffer[PufferPos]) AND $02) = 2 THEN
                          Result := PufferPossetzen(64);
                        IF Result = 0 THEN
                          IF (Byte(Puffer[PufferPos]) AND $01) = 1 THEN
                            Result := PufferPossetzen(65, 5)
                          ELSE
                            Result := PufferPossetzen(1, 5);
                      END;
                      WHILE (Result = 0) AND
                            NOT((Byte(Puffer[PufferPos]) = 0) AND
                            (Byte(Puffer[PufferPos + 1]) = 0) AND
                            (Byte(Puffer[PufferPos + 2]) = 1))DO
                        Result := PufferPossetzen(1, 5);
                      IF Result = 0 THEN
                      BEGIN
                        IF (Byte(Puffer[PufferPos + 3]) = ErweiterterCode) AND
                           (Byte(Puffer[PufferPos + 4]) AND $F0 = $10) THEN // erweiterter Header mit "Sequenzheaderextension"
                        BEGIN
                          Result := PufferPossetzen(6, 2);
                          IF Result = 0 THEN
                          BEGIN
                            IF IstZieldatei THEN
                            BEGIN
                              IF Bitrateberechnen THEN
                              BEGIN
                                ExSequenzHeaderBitrateAdr := aktAdresse - AnfangsAdr + AnfangsZielAdr + PufferPos;
                                SequenzHeaderBitratePuffer[1] := Byte(Puffer[PufferPos]) AND $E0;
                                SequenzHeaderBitratePuffer[2] := Byte(Puffer[PufferPos + 1]) AND $01;
                              END;
                              IF ersterExSequenzHeaderBitrateAdr = -1 THEN
                              BEGIN
                                ersterExSequenzHeaderBitrateAdr := aktAdresse - AnfangsAdr + AnfangsZielAdr + PufferPos;
                                ersterSequenzHeaderBitratePuffer[1] := Byte(Puffer[PufferPos]) AND $E0;
                                ersterSequenzHeaderBitratePuffer[2] := Byte(Puffer[PufferPos + 1]) AND $01;
                              END;
                              SequenzHeaderBitrate := SequenzHeaderBitrate + ((Byte(Puffer[PufferPos]) AND $1F) SHL 25) + ((Byte(Puffer[PufferPos + 1]) AND $FE) SHL 17);
                            END;
                            Result := PufferPossetzen(4);
                          END;
                        END
                        ELSE
                          Result := PufferPossetzen(4);
                      END;
                      Sequenzheaderkopieren := False;
                    END;
                  END;
                END;
                {BEGIN
                  Result := PufferPossetzen(8, 4);
                  IF Result = 0 THEN
                  BEGIN                                    // Puffer reicht für den SequenceHeader mit 2 * 64 Byte Matrixen
                    IF (Bitrate > -1) AND ersterSequenzHeader THEN
                    BEGIN
                      Byte(Puffer[PufferPos]) := (Bitrate AND $3FC00) SHR 10;
                      Byte(Puffer[PufferPos + 1]) := (Bitrate AND $3FC) SHR 2;
                      Byte(Puffer[PufferPos + 2]) := (Byte(Puffer[PufferPos + 2]) AND $3F) OR ((Bitrate AND $03) SHL 6);
                    END;
                    IF (FIndexDateierstellen OR FD2VDateierstellen) AND // Wenn eine neue Indexdatei erstellt werden soll,
                       Assigned(ZielListe) THEN
                    BEGIN
                      Headerklein := THeaderklein.Create;  // neuen Listenpunkt erzeugen,
                      Headerklein.HeaderTyp := SequenceStartCode; // Headertyp eintragen,
                      Headerklein.Adresse   := aktAdresse - AnfangsAdr + AnfangsZielAdr + PufferPos - 8; // neue Adresse berechnen,
                      ZielListe.Add(Headerklein);          // und zur Liste hinzufügen.
                    END;
                    Result := PufferPossetzen(3);
                    IF Result = 0 THEN
                    BEGIN
                      IF (Byte(Puffer[PufferPos]) AND $02) = 2 THEN
                        Result := PufferPossetzen(64);
                      IF Result = 0 THEN
                        IF (Byte(Puffer[PufferPos]) AND $01) = 1 THEN
                          Result := PufferPossetzen(65, 5)
                        ELSE
                          Result := PufferPossetzen(1, 5);
                    END;
                    WHILE (Result = 0) AND
                          NOT((Byte(Puffer[PufferPos]) = 0) AND
                          (Byte(Puffer[PufferPos + 1]) = 0) AND
                          (Byte(Puffer[PufferPos + 2]) = 1))DO
                      Result := PufferPossetzen(1, 5);
                    IF Result = 0 THEN
                    BEGIN
                      IF (Byte(Puffer[PufferPos + 3]) = ErweiterterCode) AND
                         (Byte(Puffer[PufferPos + 4]) AND $F0 = $10) THEN // erweiterter Header mit "Sequenzheaderextension"
                      BEGIN
                        Result := PufferPossetzen(6, 2);
                        IF Result = 0 THEN
                        BEGIN
                          IF (Bitrate > -1) AND ersterSequenzHeader THEN
                          BEGIN
                            Byte(Puffer[PufferPos]) := (Byte(Puffer[PufferPos]) AND $E0) OR (Bitrate AND $3E000000) SHR 25;
                            Byte(Puffer[PufferPos + 1]) := (Byte(Puffer[PufferPos + 1]) AND $01) OR (Bitrate AND $01FC0000) SHR 18;
                          END;
                          Result := PufferPossetzen(4);
                        END;
                      END
                      ELSE
                        Result := PufferPossetzen(4);
                    END;
                    ersterSequenzHeader := False;
                    Sequenzheaderkopieren := False;
                  END;
                END;}
                ELSE                                       // Else der Case-Anweisung
                  Result := PufferPossetzen(4);
                END;
              END;
              IF (Result > -1) AND Assigned(FFortschrittsanzeige) AND Fortschrittanzeigen THEN // Fortschrittsanzeige
                IF FFortschrittsanzeige(FortschrittsPosition + aktAdresse - AnfangsAdr) THEN
                  Result := -10;
            UNTIL (Result <> 0);
     //     FINALLY                            // in den Destruktor verlagert
     //       FreeMem(Puffer, PufferGr);
     //     END;
          QuellDateistream.PufferInitialisieren;
          IF Fortschrittanzeigen THEN
            FortschrittsPosition := FortschrittsPosition + EndAdr - AnfangsAdr + 1;
          IF Result > 0 THEN
            Result := 0;                                   // Result > 0 ist für aufrufende Funktionen nicht interessant
        END
        ELSE
          Result := 0;                                     // --- kein Fehler --- Anfang liegt nicht vor dem Ende
      END
      ELSE
        Result := -3                                       // Zieldatei nicht geöffnet
    ELSE
      Result := -2;                                        // Quelldatei nicht geöffnet
  END
  ELSE
    Result := -1;                                          // Quell- oder Zielobjekt fehlt
END;

PROCEDURE TVideoschnitt.SequenzEndeanhaengen(Speicherstream: TDateiPuffer; Liste: TListe; IstZieldatei: Boolean);

VAR Daten : LongWord;
    Headerklein : THeaderklein;
    HBitrate : Integer;

BEGIN
  IF Assigned(Speicherstream) THEN
  BEGIN
    IF IstZieldatei THEN
    BEGIN
      IF SequenzHeaderBildNr > -1 THEN
      BEGIN
        HBitrate := Round((Speicherstream.AktuelleAdr -
                           (SequenzHeaderBitrateAdr - 8)) * 8 /
                          ((BildZaehler - SequenzHeaderBildNr) /
                           BilderProSekausSeqHeaderFramerate(SequenzHeader.Framerate)) / 400); // durchschnittliche Bitrate
        SequenzHeaderBildNr := -1;
        IF SequenzHeaderBitrate <> HBitrate THEN
        BEGIN
          SequenzHeaderBitrate := HBitrate;
          Bitrateschreiben(SequenzHeaderBitrateAdr, ExSequenzHeaderBitrateAdr, SequenzHeaderBitratePuffer, SequenzHeaderBitrate, Speicherstream);
          SequenzHeaderBitrateAdr := -1;
          ExSequenzHeaderBitrateAdr := -1;
        END;
      END;
      IF SequenzHeaderBitrate * 400 > maximaleBitrate THEN
        maximaleBitrate := SequenzHeaderBitrate * 400;
    END;
    IF Assigned(Liste) AND
      (FIndexDateierstellen OR FD2VDateierstellen OR
       FIDXDateierstellen OR TempD2VDateierstellen) THEN    // Wenn eine neue Indexdatei erstellt wurde,
    BEGIN
      Headerklein := THeaderklein.Create;                  // neuen Listenpunkt erzeugen,
      Headerklein.HeaderTyp := $B7;                        // Sequenzendecode eintragen,
      Headerklein.Adresse   := Speicherstream.AktuelleAdr; // Adresse eintragen,
      Liste.Add(Headerklein);                              // und zur Liste hinzufügen.
    END;
    Daten := $B7010000;
    Speicherstream.SchreibenDirekt(Daten, 4);
  END;
END;

end.
