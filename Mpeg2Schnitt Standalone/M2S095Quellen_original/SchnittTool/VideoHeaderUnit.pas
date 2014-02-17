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

Aufbau des Sequenzheaders:

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

Aufbau des Bildgruppenheaders:

Bildgruppenheader: 00 00 01 B8    (4 Byte)

    25 Bit Timecode (1 Bit - Dropframe Flag - 1 wenn Framerate ungerade z.B. 29,97
                     5 Bit - Stunde
                     6 Bit - Minute
                     1 Bit - Marker
                     6 Bit - Sekunde
                     6 Bit - Bild)
     1 Bit Closed Group
     1 Bit Broken Link

Aufbau des Bildheaders:

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

unit VideoHeaderUnit;

interface

USES SysUtils,
     Dateipuffer,
     DateiStreamUnit;

TYPE
  TStartCodes = SET OF Byte;

CONST
  BildStartCode     = $00;
  SequenceStartCode = $B3;
  ErweiterterCode   = $B5;
  SequenceEndeCode  = $B7;
  GruppenStartCode  = $B8;
  ExSeqenceHeader   = $10;
  ExBildHeader      = $80;

  StartCodes: TStartCodes = [$00, $B3, $B7, $B8];

TYPE
  TTimecode = RECORD
    Ungerade : Boolean;
    Stunde : Byte;
    Minute : Byte;
    Marker : Boolean;
    Sekunde : Byte;
    Bilder : Byte;
  END;

  THeader = CLASS
  PRIVATE
    FExHeadersuchweite : Integer;
    FAdresse : Int64;
    Frueckwaerts : Boolean;
    FUNCTION SucheExHeader(Dateistream: TDateiStream; Headertyp: Byte; Position: Int64 = -1): Integer;
  PUBLIC
    CONSTRUCTOR Create(Dateiname: STRING = ''; Position: Int64 = -1);
    FUNCTION SucheHeader(Dateistream: TDateiStream; StartCodes: TStartCodes; Position: Int64 = -1): Integer; OVERLOAD;
    FUNCTION LeseHeader(Dateistream: TDateiStream; Position: Int64 = -1; Posmerken: Boolean = False): Integer; OVERLOAD; VIRTUAL;
    FUNCTION LeseHeader(Dateiname: STRING; Position: Int64 = -1): Integer; OVERLOAD;
    FUNCTION LeseHeader(Dateiname: STRING; Header: THeader; Position: Int64 = -1): Integer; OVERLOAD;
    PROPERTY ExHeadersuchweite : Integer READ FExHeadersuchweite WRITE FExHeadersuchweite;
    PROPERTY Adresse : Int64 READ FAdresse;
    PROPERTY rueckwaerts: Boolean READ Frueckwaerts WRITE Frueckwaerts;
  END;

  TSequenzHeader = CLASS(THeader)
  PRIVATE
    FBildBreite : Word;
    FBildHoehe : Word;
    FSeitenverhaeltnis : Byte;
    FFramerate : Byte;
    FBitrate : LongWord;
    FVBVPuffer : Word;
    FProfilLevel : Byte;
    FProgressive : Boolean;
    FChromaFormat : Byte;
    FLowDelay : Boolean;
  PUBLIC
    FUNCTION LeseHeader(Dateistream: TDateiStream; Position: Int64 = -1; Posmerken: Boolean = False): Integer; OVERLOAD; OVERRIDE;
    PROPERTY BildBreite : Word READ FBildBreite;
    PROPERTY BildHoehe : Word READ FBildHoehe;
    PROPERTY Seitenverhaeltnis : Byte READ FSeitenverhaeltnis;
    PROPERTY Framerate : Byte READ FFramerate;
    PROPERTY Bitrate : LongWord READ FBitrate;
    PROPERTY VBVPuffer : Word READ FVBVPuffer;
    PROPERTY ProfilLevel : Byte READ FProfilLevel;
    PROPERTY Progressive : Boolean READ FProgressive;
    PROPERTY ChromaFormat : Byte READ FChromaFormat;
    PROPERTY LowDelay : Boolean READ FLowDelay;
  END;

  TBildHeader = CLASS(THeader)
  PRIVATE
    FTempRefer : Word;
    FBildTyp : Byte;
    FVBVDelay : Word;
    FFCode0 : Byte;
    FFCode1 : Byte;
    FFCode2 : Byte;
    FFCode3 : Byte;
    FIntraDCPre : Byte;
    FBildStruktur : Byte;
    FOberstesFeldzuerst : Boolean;
    Fframe_pred_frame_dct : Boolean;
    Fconcealment_motion_vectors : Boolean;
    Fq_scale_type : Boolean;
    Fintra_vlc_format : Boolean;
    Falternate_scan : Boolean;
    Frepeat_first_field : Boolean;
    Fchroma_420_type : Boolean;
    Fprogressive_frame : Boolean;
    Fcomposite_display_flag : Boolean;
    Fv_axis : Boolean;
    Ffield_sequence : Byte;
    Fsub_carrier : Boolean;
    Fburst_amplitude : Byte;
    Fsub_carrier_phase : Byte;
  PUBLIC
    FUNCTION LeseHeader(Dateistream: TDateiStream; Position: Int64 = -1; Posmerken: Boolean = False): Integer; OVERLOAD; OVERRIDE;
    PROPERTY TempRefer : Word READ FTempRefer;
    PROPERTY BildTyp : Byte READ FBildTyp;
    PROPERTY VBVDelay : Word READ FVBVDelay;
    PROPERTY FCode0 : Byte READ FFCode0;
    PROPERTY FCode1 : Byte READ FFCode1;
    PROPERTY FCode2 : Byte READ FFCode2;
    PROPERTY FCode3 : Byte READ FFCode3;
    PROPERTY IntraDCPre : Byte READ FIntraDCPre;
    PROPERTY BildStruktur : Byte READ FBildStruktur;
    PROPERTY OberstesFeldzuerst : Boolean READ FOberstesFeldzuerst;
    PROPERTY frame_pred_frame_dct : Boolean READ Fframe_pred_frame_dct;
    PROPERTY concealment_motion_vectors : Boolean READ Fconcealment_motion_vectors;
    PROPERTY q_scale_type : Boolean READ Fq_scale_type;
    PROPERTY intra_vlc_format : Boolean READ Fintra_vlc_format;
    PROPERTY alternate_scan : Boolean READ Falternate_scan;
    PROPERTY repeat_first_field : Boolean READ Frepeat_first_field;
    PROPERTY chroma_420_type : Boolean READ Fchroma_420_type;
    PROPERTY progressive_frame : Boolean READ Fprogressive_frame;
    PROPERTY composite_display_flag : Boolean READ Fcomposite_display_flag;
    PROPERTY v_axis : Boolean READ Fv_axis;
    PROPERTY field_sequence : Byte READ Ffield_sequence;
    PROPERTY sub_carrier : Boolean READ Fsub_carrier;
    PROPERTY burst_amplitude : Byte READ Fburst_amplitude;
    PROPERTY sub_carrier_phase : Byte READ Fsub_carrier_phase;
  END;

  TBildgruppenHeader = CLASS
    Adresse : Int64;
    Timecode : TTimecode;
    GeschlosseneGr : Boolean;
    Geschnitten : Boolean;
  END;

implementation

// ----------------- THeader ---------------------------------------------------

CONSTRUCTOR THeader.Create(Dateiname: STRING = ''; Position: Int64 = -1);
BEGIN
  INHERITED Create;
  FExHeadersuchweite := 100;          // sucht den erweiterten Header innerhalb der nächsten x Byte
  IF Dateiname <> '' THEN
    LeseHeader(Dateiname, Position);
END;

// sucht den nächsten Header der in StartCodes vorkommt
//  Startcode : Ok, Startcode gefunden
// -1..-3 siehe TDateistream.LeseByte
FUNCTION THeader.SucheHeader(Dateistream: TDateiStream; StartCodes: TStartCodes; Position: Int64 = -1): Integer;

VAR Byte1 : Byte;
    Byte4 : Longword;

BEGIN
  IF (Position > 0) THEN
    DateiStream.Position := Position;
  Dateistream.rueckwaerts := Frueckwaerts;
  Byte4 := $FFFFFFFF;
  WHILE (Dateistream.Fehler = 0) AND
        (NOT (((Byte4 AND $FFFFFF00) = $100) AND
              ((Byte4 AND $FF) IN StartCodes))) DO
  BEGIN
    Byte1 := Dateistream.LeseByte;
    IF Frueckwaerts THEN
      Byte4 := (Byte4 SHR 8) OR (Longword(Byte1) SHL 24)
    ELSE
      Byte4 := (Byte4 SHL 8) OR Byte1;
  END;
  IF Dateistream.Fehler = 0 THEN
  BEGIN
    IF Frueckwaerts THEN
      Dateistream.Schieben(4);
    Result := Byte4 AND $FF;
  END
  ELSE
    Result := Dateistream.Fehler;
  Dateistream.rueckwaerts := False;
END;

FUNCTION THeader.SucheExHeader(Dateistream: TDateiStream; Headertyp: Byte; Position: Int64 = -1): Integer;

VAR Byte1 : Byte;
    Byte4 : Longword;
    I : Integer;
    Adr_merken : Int64;

BEGIN
  IF (Position > 0) THEN
    DateiStream.Position := Position;
  Adr_merken := DateiStream.Position;
  Byte4 := $FFFFFFFF;
  I := 0;
  WHILE (I < FExHeadersuchweite) AND
        (Dateistream.Fehler = 0) AND
        (NOT ((Byte4 AND $FFFFFF00) = $100)) DO
  BEGIN                                              // Startcode $000001 suchen
    Byte1 := Dateistream.LeseByte;
    Byte4 := (Byte4 SHL 8) OR Byte1;
    Inc(I);
  END;
  IF Dateistream.Fehler = 0 THEN
    IF (Byte4 AND $FFFFFF00) = $100 THEN             // Startcode gefunden
      IF (Byte4 AND $FF) = ErweiterterCode THEN
      BEGIN                                          // erweiterter Header
        Byte1 := Dateistream.LeseByte;
        IF Dateistream.Fehler = 0 THEN
          IF (Byte1 AND $F0) = Headertyp THEN        // entspricht dem Headertyp
            Result := 0
          ELSE
            Result := -6
        ELSE
          Result := Dateistream.Fehler;
      END
      ELSE
        Result := -5
    ELSE
      Result := -4
  ELSE
    Result := Dateistream.Fehler;
  IF Result < 0 THEN
    Dateistream.Position := Adr_merken;
END;

// virtuelle Funktion zum lesen der Headerdaten aus dem Dateistream
// -1 : keine Funktion implementiert
FUNCTION THeader.LeseHeader(Dateistream: TDateiStream; Position: Int64 = -1; Posmerken: Boolean = False): Integer;
BEGIN
  Result := -1;
END;

// öffnet die Datei zum lesen und liest den nächsten Header aus
// 0 : Ok
// -1 : Fehler beim öffnen der Datei
// -2.. siehe LeseHeader(Dateistream ...) des abgeleitenden Objektes
// -6.. siehe LeseHeader(Dateistream ...) des übergebenen Objektes
FUNCTION THeader.LeseHeader(Dateiname: STRING; Position: Int64 = -1): Integer;
BEGIN
  Result := LeseHeader(Dateiname, NIL, Position);
END;

FUNCTION THeader.LeseHeader(Dateiname: STRING; Header: THeader; Position: Int64 = -1): Integer;

VAR Dateistream : TDateiMapStream;
//VAR Dateistream : TDateiFileStream;

BEGIN
  Dateistream := TDateiMapStream.Create;
//  Dateistream := TDateiFileStream.Create;
  TRY
    Dateistream.Dateioeffnen(Dateiname);
    IF Dateistream.Fehler = 0 THEN
    BEGIN
      Result := LeseHeader(DateiStream, Position);
      IF Result < 0 THEN
        Result := Result -1;
    END
    ELSE
      Result := -1;
    IF (Result = 0) AND Assigned(Header) THEN
    BEGIN
      Result := Header.LeseHeader(Dateistream);
      IF Result < 0 THEN
        Result := Result -5;
    END;
  FINALLY
    Dateistream.Free;
  END;
END;

// ----------------- TSequenzHeader --------------------------------------------

// liest den nächsten Sequenzheader aus
//  0 : Ok
// -1..-3 Siehe TDateistream.LeseByte, TDateistream.LesePuffer
// -4 : kein Sequenzheader gefunden
// -5 : Sequenzheader nicht vollständig
FUNCTION TSequenzHeader.LeseHeader(Dateistream: TDateiStream; Position: Int64 = -1; Posmerken: Boolean = False): Integer;

VAR Adr_merken : Int64;
    Daten : ARRAY[0..7] OF Byte;

BEGIN
  Adr_merken := Dateistream.Position;
  Result := SucheHeader(Dateistream, [SequenceStartCode], Position);
  IF Result = SequenceStartCode THEN
  BEGIN
    Result := 0;
    IF Dateistream.LesePuffer(Daten, 8) = 8 THEN
    BEGIN
      FAdresse := DateiStream.Position - 12;
      FBildBreite := (Daten[0] SHL 4) + ((Daten[1] AND $F0) SHR 4);
      FBildHoehe := ((Daten[1] AND $0F) SHL 8) + Daten[2];
      FSeitenverhaeltnis := (Daten[3] AND $F0) SHR 4;
      FFramerate := Daten[3] AND $0F;
      FBitrate := Trunc(((Daten[4] SHL 10) + (Daten[5] SHL 2) + ((Daten[6] AND $C0) SHR 6)) * 400);
      FVBVPuffer := ((Daten[6] AND $1F) SHL 5) + ((Daten[7] AND $F8) SHR 3);
      FProfilLevel := 0;
      FProgressive := False;
      FChromaFormat := 0;
      FLowDelay := False;
      IF (Daten[7] AND $02) = 2 THEN
      BEGIN
        Dateistream.Position := Dateistream.Position + 63;
        Daten[7] := Dateistream.LeseByte;
        IF Dateistream.Fehler < 0 THEN
          Result := -5;
      END;
      IF Result = 0 THEN
        IF (Daten[7] AND $01) = 1 THEN
        BEGIN
          Dateistream.Position := Dateistream.Position + 64;
          IF Dateistream.Fehler < 0 THEN
            Result := -5;
        END;
    END
    ELSE
      Result := -5;
    IF Result = 0 THEN
    BEGIN
      IF SucheExHeader(Dateistream, ExSeqenceHeader) = 0 THEN
      BEGIN
        Dateistream.Position := Dateistream.Position - 1;
        IF Dateistream.LesePuffer(Daten, 6) = 6 THEN
        BEGIN
          FProfilLevel := ((Daten[0] AND $0F) SHL 4) + ((Daten[1] AND $F0) SHR 4);
          FProgressive := ((Daten[1] AND $08) SHR 3) = 1;
          FChromaFormat := (Daten[1] AND $06) SHR 1;
          FBildBreite := FBildBreite + ((Daten[1] AND $01) SHL 13) + ((Daten[2] AND $80) SHL 5);
          FBildHoehe := FBildHoehe + ((Daten[2] AND $60) SHL 7);
          FBitrate := FBitrate + ((Daten[2] AND $1F) SHL 25) + ((Daten[3] AND $FE) SHL 18);
          FVBVPuffer := FVBVPuffer + (Daten[4] SHL 10);
          FLowDelay := ((Daten[5] AND $80) SHR 7) = 1;
        END
        ELSE
          Result := -5;
      END;
    END;
  END
  ELSE
    Result := -4;
  IF Result < 0 THEN
    FFramerate := 0;
  IF Posmerken THEN
    Dateistream.Position := Adr_merken;
END;

// ----------------- TBildHeader --------------------------------------------

// liest den nächsten Bildheader aus
//  0 : Ok
// -1..-3 Siehe TDateistream.LeseByte, TDateistream.LesePuffer
// -4 : kein Bildheader gefunden
// -5 : Bildheader nicht vollständig
FUNCTION TBildHeader.LeseHeader(Dateistream: TDateiStream; Position: Int64 = -1; Posmerken: Boolean = False): Integer;

VAR Adr_merken : Int64;
    Daten : ARRAY[0..4] OF Byte;

BEGIN
  Adr_merken := DateiStream.Position;
  Result := SucheHeader(Dateistream, [BildStartCode], Position);
  IF Result = BildStartCode THEN
  BEGIN
    Result := 0;
    IF Dateistream.LesePuffer(Daten, 4) = 4 THEN
    BEGIN
      FAdresse := DateiStream.Position - 8;
      FTempRefer := (Daten[0] SHL 2) + ((Daten[1] AND $C0) SHR 6);
      FBildTyp := (Daten[1] AND $38) SHR 3;
      FVBVDelay := ((Daten[1] AND $07) SHL 13) + (Daten[2] SHL 5) + ((Daten[3] AND $F8) SHR 3);
      // Full pel forward Vector, Forward f Code, Full pel backward Vector, Backward f Code nicht ausgewertet
      // Extra Bit Picture (1 wenn Informationen folgen) nicht ausgewertet
    END
    ELSE
      Result := -5;
    IF Result = 0 THEN
    BEGIN
      IF SucheExHeader(Dateistream, ExBildHeader) = 0 THEN
      BEGIN
        Dateistream.Position := Dateistream.Position - 1;
        IF Dateistream.LesePuffer(Daten, 5) = 5 THEN
        BEGIN
          FFCode0 := (Daten[0] AND $0F);
          FFCode1 := (Daten[1] AND $F0);
          FFCode2 := (Daten[1] AND $0F);
          FFCode3 := (Daten[2] AND $F0);
          FIntraDCPre := (Daten[2] AND $0C) SHR 2;
          FBildStruktur := Daten[2] AND $03;
          FOberstesFeldzuerst := ((Daten[3] AND $80) SHR 7) = 1;
          Fframe_pred_frame_dct := ((Daten[3] AND $40) SHR 6) = 1;
          Fconcealment_motion_vectors := ((Daten[3] AND $20) SHR 5) = 1;
          Fq_scale_type := ((Daten[3] AND $10) SHR 4) = 1;
          Fintra_vlc_format := ((Daten[3] AND $08) SHR 3) = 1;
          Falternate_scan := ((Daten[3] AND $04) SHR 2) = 1;
          Frepeat_first_field := ((Daten[3] AND $02) SHR 1) = 1;
          Fchroma_420_type := (Daten[3] AND $01) = 1;
          Fprogressive_frame := ((Daten[4] AND $80) SHR 7) = 1;
          Fcomposite_display_flag := ((Daten[4] AND $40) SHR 6) = 1;
          IF Fcomposite_display_flag THEN
          BEGIN
            Fv_axis := ((Daten[4] AND $20) SHR 5) = 1;
            Ffield_sequence := ((Daten[4] AND $1C) SHR 2);
            Fsub_carrier := ((Daten[4] AND $02) SHR 1) = 1;
          //    Fburst_amplitude nicht ausgewertet
          //    Fsub_carrier_phase nicht ausgewertet
          END;
        END
        ELSE
          Result := -5;
      END;
    END;
  END
  ELSE
    Result := -4;
  IF Result < 0 THEN
    FBildTyp := 0;
  IF Posmerken THEN
    Dateistream.Position := Adr_merken;
END;

end.
