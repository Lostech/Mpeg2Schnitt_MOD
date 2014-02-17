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

unit AudioschnittUnit;

interface

USES
  Dialogs,                  // Showmessage
  Classes,                  // Klassen
  SysUtils,                 // Dateioperationen, Stringfunktionen ...
  DateUtils,                // zum messen der Zeit die einige Funktionen benötigen
  ComCtrls,                 // für TTreeNode
  StrUtils,                 // für AnsiReplaceText
  Forms,                    // für Application
  Dateipuffer,              // Schreib- und Lesefunktionen mit Pufferung
  ProtokollUnit,            // zum protokollieren :-)
  Sprachen,                 // zum übersetzen der Meldungen
  AllgFunktionen,           // Zeit messen, Meldungsfenster
//  Optfenster,               // Effekttypen
  DatenTypen,               // für verwendete Datentypen
  SchnittTypenUnit,         // Schnittgrundtypen
  AudioIndexUnit,           // Audioindex
  ScriptUnit;               // Scriptverarbeitung

TYPE
  TAudioschnitt = CLASS(TSchnitt)
    Liste,
    AudioListe,
    NeueListe : TListe;
    Audioheader : TAudioheader;
    leereAudioframesMpeg : TStrings;
    leereAudioframesAC3 : TStrings;
    leereAudioframesPCM : TStrings;
    Versatz : Integer;
    TextString : STRING;
    PROCEDURE Zieldateinamesetzen(ZielDatei: STRING);                           // Property Zieldateiname
    FUNCTION Quelldateioeffnen(Dateiname: STRING; IndexListe: TListe): Integer;
    PROCEDURE IndexDateispeichern(Name: STRING; Liste : TListe);
    FUNCTION Indexlistefuellen(AnfangsAdr, EndAdr: Int64; Audioheader: TAudioheader): Integer;
    FUNCTION Audioheaderlesen(Dateiname: STRING; Position: Int64; Audioheader: TAudioheader): Integer;
    PROCEDURE KopiereSegment(AnfangsIndex, EndIndex: Int64);
    FUNCTION KopiereSegmentDatei(AnfangsAdr, EndAdr: Int64; QuellDateistream, ZielDateistream: TDateiPuffer): Integer;
    PROCEDURE NullAudio_einfuegen(AnfangsIndex, EndIndex: Int64; AudioHeader: TAudioHeader);
    PROCEDURE Variablensetzen(Variablen: TStrings; Audioheader: TAudioheader);
    FUNCTION TeilDateikopieren(Variablen: TStrings; Anfangoffset: Integer = 0; Endeoffset: Integer = 0): Integer;
    FUNCTION Effektberechnen(AnfangsIndex, EndIndex: Int64; Effektdateiname, Effektname, EffektParameter: STRING; EffektLaenge: Integer; Audioheader: TAudioHeader; SchnittTyp: STRING = ''): Integer;
    PROCEDURE EffektberechnenAnfang(AnfangsIndex, EndIndex: Int64; EffektEintrag: TEffektEintrag; Audioheader: TAudioHeader);
    PROCEDURE EffektberechnenEnde(AnfangsIndex, EndIndex: Int64; EffektEintrag: TEffektEintrag; Audioheader: TAudioHeader);
  public
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
//    FUNCTION Zieldateioeffnen(ZielDatei: STRING): Integer;
//    PROCEDURE Zieldateischliessen;
    FUNCTION Schneiden(SchnittListe: TStrings): Integer;
    PROPERTY Zieldateiname: STRING READ FZieldateiname WRITE Zieldateinamesetzen;
  END;

implementation

CONSTRUCTOR TAudioschnitt.Create;
BEGIN
  INHERITED Create;
  AudioListe := TListe.Create;
  NeueListe := TListe.Create;;
  Audioheader := TAudioheader.Create;
  leereAudioframesMpeg := NIL;
  leereAudioframesAC3 := NIL;
  leereAudioframesPCM := NIL;
  Versatz := 0;
  TextString := '';
END;

DESTRUCTOR TAudioschnitt.Destroy;
BEGIN
  IF Assigned(AudioListe) THEN
  BEGIN
    AudioListe.Loeschen;
    AudioListe.Free;
  END;  
  IF Assigned(NeueListe) THEN
  BEGIN
    IF FIndexDateierstellen THEN
      IndexDateispeichern(FZieldateiname, NeueListe);
    NeueListe.Loeschen;
    NeueListe.Free;
  END;
  IF Assigned(Audioheader) THEN
    Audioheader.Free;
  INHERITED Destroy;
END;

// bis neue Indexliste unverändert
FUNCTION TAudioschnitt.Audioheaderlesen(Dateiname: STRING; Position: Int64; Audioheader: TAudioheader): Integer;

VAR MpegAudio : TAudioIndex;
    Adresse : Int64;

BEGIN
  Result := 0;
  IF Assigned(Audioheader) THEN
  BEGIN
    MpegAudio := TAudioIndex.Create;
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

FUNCTION TAudioschnitt.Quelldateioeffnen(Dateiname: STRING; IndexListe: TListe): Integer;

VAR MpegAudio : TAudioIndex;

BEGIN
  Result := 0;
  IF NOT (Quelldateiname = Dateiname) THEN                             // neue Indexliste
  BEGIN
    IF IndexListe = NIL THEN
    BEGIN
      AudioListe.Loeschen;
      MpegAudio := TAudioIndex.Create;
      TRY
//        MpegAudio.Fortschrittsanzeige := FFortschrittsanzeige;
        MpegAudio.Textanzeige := FTextanzeige;
//        MpegAudio.FortschrittsEndwert := FFortschrittsEndwert;
        IF MpegAudio.DateiOeffnen(Dateiname) > -1 THEN
        BEGIN
          MpegAudio.DateiInformationLesen(Audioheader);
          IF Audioheader.Framelaenge > 0 THEN
          BEGIN
            MpegAudio.Listeerzeugen(AudioListe, NIL, Versatz);
            IF AudioListe.Count = 0 THEN
              Result := -4;
          END
          ELSE
            Result := -3;
        END
        ELSE
          Result := -2;
      FINALLY
        MpegAudio.Free;
      END;
      Liste := AudioListe;
    END
    ELSE
    BEGIN
      Result := Audioheaderlesen(Dateiname, -1, Audioheader);
      Liste := IndexListe;
    END;
    IF Result = -3 THEN
      Meldungsfenster(Meldunglesen(NIL, 'Meldung131', Dateiname, 'Fehler im ersten Header der Audiodatei $Text1#.') + Chr(13) +
                      Meldunglesen(NIL, 'Meldung123', FZieldateiname, 'Die Zieldatei $Text1# wird wieder gelöscht.'))
    ELSE
      IF Result = -2 THEN
        Meldungsfenster(Meldunglesen(NIL, 'Meldung114', Dateiname, 'Die Datei $Text1# läßt sich nicht öffnen.') + Chr(13) +
                        Meldunglesen(NIL, 'Meldung124', FZieldateiname, 'Es wird keine (vollständige) Datei $Text1# erzeugt.'));
    IF Result = 0 THEN
      Result := INHERITED Quelldateioeffnen(Dateiname);
    IF Result > -1 THEN
      Dateistream.Pufferfreigeben;
  END;
END;

// bis neue Indexliste unverändert
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
    IF Assigned(FTextanzeige) THEN
      FTextanzeige(3, Name + '.idd');
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
      Application.ProcessMessages;
    END;
    Listenstream.Free;
//    SchleifenEndeZeit := Time;                // zum messen der Schleifenzeit
//    Showmessage(IntToStr(MilliSecondsBetween(SchleifenAnfangsZeit, SchleifenEndeZeit)));  // ----- " ------
  END;
END;

PROCEDURE TAudioschnitt.Zieldateinamesetzen(ZielDatei: STRING);

VAR Audioheaderklein : TAudioheaderklein;

BEGIN
  IF NOT (FZieldateiname = ZielDatei) THEN
  BEGIN
    IF Assigned(NeueListe) THEN
    BEGIN
      IF FIndexDateierstellen THEN
        IndexDateispeichern(FZieldateiname, NeueListe);
      NeueListe.Loeschen;
      Audioheaderklein := TAudioheaderklein.Create;
      Audioheaderklein.Adresse := 0;
      NeueListe.Add(Audioheaderklein);
    END;
    INHERITED Zieldateinamesetzen(ZielDatei);
  END;
END;

// schneidet nach der übergebene Schnittliste
//  0 : Schnitt erfolgreich
FUNCTION TAudioschnitt.Schneiden(SchnittListe: TStrings): Integer;

VAR I : LongInt;
    Schnittpunkt : TSchnittpunkt;
    AnfangsIndex, EndIndex,
    EffektAnfang, EffektEnde : LongInt;
    MpegAudio : TAudioIndex;
    AudioNullHeader : TAudioheader;
    Audioschneiden : Boolean;
    Bildlaenge,
    Audioversatz : Real;
    DateiName : STRING;
    EffektEintrag : TEffektEintrag;

BEGIN
  Result := 0;
  Audioversatz := 0;
{  IF Videoschnittanhalten THEN                                             // Videoschnitt wurde angehalten
  BEGIN
    NeueListe.Loeschen;
    Exit;
  END;  }
  AudioNullHeader := TAudioheader.Create;                                  //-------------------------------
  TRY
    I := 0;
    IF Assigned(FFortschrittsEndwert) THEN
      FFortschrittsEndwert^ := 0;
    FortschrittsPosition := 0;
    Audioschneiden := False;
    WHILE I < SchnittListe.Count DO                                        // Audioschnitte in der Schnittliste suchen
    BEGIN
      Schnittpunkt := TSchnittpunkt(SchnittListe.Objects[I]);              // X. Schnitt
      IF Assigned(FFortschrittsEndwert) THEN
        FFortschrittsEndwert^ := FFortschrittsEndwert^ + Schnittpunkt.AudioGroesse;
      IF Schnittpunkt.AudioName <> '' THEN
      BEGIN
        MpegAudio := TAudioIndex.Create;
        IF MpegAudio.DateiOeffnen(Schnittpunkt.AudioName) = 0 THEN         // Audiodatei muß sich geöffnen lassen
        BEGIN
          MpegAudio.DateiInformationLesen(AudioNullHeader);                // Den Audiotyp und weitere Informationen über die erste gefundene Audiodatei lesen.
          Audioschneiden := True;                                          // Wurde mindestens ein Audioheader gefunden wird geschnitten
        END;
        MpegAudio.Free;                                                    // also kein Audio schneiden.
      END;
      Inc(I);
    END;                    //------------------------------
    IF Audioschneiden THEN
    BEGIN
      Result := -1;                                                         // Abbruch durch Anwender
      IF Zieldateioeffnen < 0 THEN
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
          IF Quelldateioeffnen(Schnittpunkt.AudioName, Schnittpunkt.AudioListe) < 0 THEN
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
              IF (EffektEintrag.AnfangEffektName <> '') OR (EffektEintrag.EndeEffektName <> '') THEN
                IF (EffektEintrag.AnfangLaenge = 0) AND (EffektEintrag.EndeLaenge = 0) AND
                   (EffektEintrag.AnfangEffektName <> '') THEN
                BEGIN                                             // Effekt über den ganzen Schnitt
                  EffektEnde := EndIndex;
                  EffektAnfang := EndIndex + 1;
                END
                ELSE
                BEGIN                                             // zwei Einzeleffekte
                  IF (EffektEintrag.AnfangLaenge > 0) AND (EffektEintrag.AnfangEffektName <> '') THEN
                    EffektEnde := Trunc(EffektEintrag.AnfangLaenge / Audioheader.Framezeit) + AnfangsIndex   // Anfangseffekt vorhanden
                  ELSE
                    EffektEnde := AnfangsIndex - 1;                                                              // kein Anfangseffekt
                  IF (EffektEintrag.EndeLaenge > 0) AND (EffektEintrag.EndeEffektName <> '') THEN
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
                EffektAnfang := EffektEnde + 1;                  // falsch berechnet? siehe Videoberechnung
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
//                      Effektberechnen(0, EffektEnde, Effektdateiname, EffektEintrag.AnfangEffektName, EffektEintrag.AnfangEffektParameter,
//                                      EffektEintrag.AnfangLaenge, Audioheader);
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
    END;
    IF Anhalten THEN
    BEGIN
      DateiName := FZieldateiname;
      Zieldateischliessen;
      IF FileExists(DateiName) THEN
        DeleteFile(DateiName);
    END
    ELSE
      Result := 0;
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
    IF Assigned(FTextanzeige) THEN
      FTextanzeige(4, TextString);
//    IF Assigned(FFortschrittsEndwert) THEN
//      FFortschrittsEndwert^ := EndIndex - AnfangsIndex + 1;
//      FFortschrittsEndwert^ := TAudioheaderklein(Liste[EndIndex]).Adresse -
//                               TAudioheaderklein(Liste[AnfangsIndex]).Adresse + 1;
//      FFortschrittsEndwert^ := EndIndex - AnfangsIndex + 1;
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
        IF (NOT Anhalten) AND Assigned(FFortschrittsanzeige) THEN    // Fortschrittsanzeige
          Anhalten := FFortschrittsanzeige(FortschrittsPosition + aktAdresse - AnfAdrDatei);
      UNTIL (I > EndIndex) OR Anhalten;
      FreeMem(Puffer, PufferGr);
      FortschrittsPosition := FortschrittsPosition +
                              TAudioheaderklein(Liste[EndIndex]).Adresse -
                              TAudioheaderklein(Liste[AnfangsIndex]).Adresse + 1;
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

VAR MpegAudio : TAudioIndex;
    AudioHeader1 : TAudioheader;
    Audioframe : TDateiPuffer;
    gefunden : Boolean;

BEGIN
//  Sartzeitsetzen;
  Result := 0;
  MpegAudio := TAudioIndex.Create;
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
//  Showmessage(IntToStr(Zeitdauerlesen_milliSek));
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
    Byte(Puffer[2]) := (Byte(Puffer[2]) AND $FE) OR Byte(Privat);
    Byte(Puffer[3]) := (Byte(Puffer[3]) AND $F7) OR (Byte(Copyright) SHL 3);
    Byte(Puffer[3]) := (Byte(Puffer[3]) AND $FB) OR (Byte(Orginal) SHL 2);
    END;
{    Byte(Puffer[2]) := (Byte(Puffer[2]) AND $FE) OR Byte(Privat);
    Byte(Puffer[3]) := (Byte(Puffer[3]) AND $F7) OR (Byte(Copyright) SHL 3);
    Byte(Puffer[3]) := (Byte(Puffer[3]) AND $FB) OR (Byte(Orginal) SHL 2); }
  END;
END;

FUNCTION AC3Frame_schreiben: Integer;

VAR MpegAudio : TAudioIndex;
    AudioHeader1 : TAudioheader;
    Audioframe : TDateiPuffer;
    gefunden : Boolean;

BEGIN
  Result := 0;
  MpegAudio := TAudioIndex.Create;
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

{PROCEDURE TAudioschnitt.Variablesetzen(Variablen: TStrings; Variable, Wert: STRING);

VAR I : Integer;

BEGIN
  IF Assigned(Variablen) AND
     (Variable <> '') THEN
    BEGIN
    I := 0;
    WHILE (I < Variablen.Count) AND                    // Variable in der Variablenliste suchen
          (Variablen[I] <> Variable) DO
      Inc(I, 2);
    WHILE I + 2 > Variablen.Count DO                   // Variable nicht gefunden
      Variablen.Add('');                               // entsprechend Einträge anhängen
    Variablen[I] := Variable;
    Variablen[I + 1] := Wert;
  END;
END; }

PROCEDURE TAudioschnitt.Variablensetzen(Variablen: TStrings; Audioheader: TAudioheader);

BEGIN
  IF Assigned(Audioheader) AND
     Assigned(Variablen) THEN
  BEGIN
    Variablesetzen(Variablen, '$Samplerate#', IntToStr(Audioheader.Samplerateberechnet));
    Variablesetzen(Variablen, '$Bitrate#', IntToStr(Audioheader.Bitrateberechnet));
    IF Audioheader.Protection THEN
      Variablesetzen(Variablen, '$Protection#', 'e');
    IF Audioheader.Privat THEN
      Variablesetzen(Variablen, '$Privat#', 'o');
    IF Audioheader.Copyright THEN
      Variablesetzen(Variablen, '$Copyright#', 'c');
    IF Audioheader.Audiotyp = 2 THEN
      CASE AudioHeader.Mode OF
        0: Variablesetzen(Variablen, '$Mode#', 's');
        1: Variablesetzen(Variablen, '$Mode#', 'j');
        2: Variablesetzen(Variablen, '$Mode#', 'd');
        3: Variablesetzen(Variablen, '$Mode#', 'm');
      END;
    IF Audioheader.Audiotyp = 3 THEN
      CASE AudioHeader.ModeErweiterung OF
        0: Variablesetzen(Variablen, '$Mode#', '1+1');
        1: Variablesetzen(Variablen, '$Mode#', '1/0');
        2: Variablesetzen(Variablen, '$Mode#', '2/0');
        3: Variablesetzen(Variablen, '$Mode#', '3/0');
        4: Variablesetzen(Variablen, '$Mode#', '2/1');
        5: Variablesetzen(Variablen, '$Mode#', '3/1');
        6: Variablesetzen(Variablen, '$Mode#', '2/2');
        7: Variablesetzen(Variablen, '$Mode#', '3/2');
      END;
    IF Audioheader.Audiotyp = 2 THEN
      CASE AudioHeader.Mode OF
        0: Variablesetzen(Variablen, '$NofChannels#', '2');
        1: Variablesetzen(Variablen, '$NofChannels#', '2');
        2: Variablesetzen(Variablen, '$NofChannels#', '2');
        3: Variablesetzen(Variablen, '$NofChannels#', '1');
      END;
    IF Audioheader.Audiotyp = 3 THEN
      IF AudioHeader.Copyright THEN
        CASE AudioHeader.ModeErweiterung OF
          0: Variablesetzen(Variablen, '$NofChannels#', '3');
          1: Variablesetzen(Variablen, '$NofChannels#', '2');
          2: Variablesetzen(Variablen, '$NofChannels#', '3');
          3: Variablesetzen(Variablen, '$NofChannels#', '4');
          4: Variablesetzen(Variablen, '$NofChannels#', '4');
          5: Variablesetzen(Variablen, '$NofChannels#', '5');
          6: Variablesetzen(Variablen, '$NofChannels#', '5');
          7: Variablesetzen(Variablen, '$NofChannels#', '6');
        END
      ELSE
        CASE AudioHeader.ModeErweiterung OF
          0: Variablesetzen(Variablen, '$NofChannels#', '2');
          1: Variablesetzen(Variablen, '$NofChannels#', '1');
          2: Variablesetzen(Variablen, '$NofChannels#', '2');
          3: Variablesetzen(Variablen, '$NofChannels#', '3');
          4: Variablesetzen(Variablen, '$NofChannels#', '3');
          5: Variablesetzen(Variablen, '$NofChannels#', '4');
          6: Variablesetzen(Variablen, '$NofChannels#', '4');
          7: Variablesetzen(Variablen, '$NofChannels#', '5');
        END;
  END;
END;

FUNCTION TAudioschnitt.TeilDateikopieren(Variablen: TStrings; Anfangoffset: Integer = 0; Endeoffset: Integer = 0): Integer;

VAR HInteger,
    HInteger2 : Integer;
    HString : STRING;
    HDateistream : TDateiPuffer;
    HAudioheader : TAudioheader;

BEGIN
  IF (Anfangoffset = 0) AND (Endeoffset = 0) THEN
  BEGIN
    Anfangoffset := StrToIntDef(VariablenersetzenText('$FramesBegin#', Variablen), 0);
    Endeoffset := StrToIntDef(VariablenersetzenText('$FramesEnd#', Variablen), 0);
  END;
  HString := VariablenersetzenText('$PartFile#', Variablen);
  HDateistream := TDateiPuffer.Create(HString, fmCreate);
  TRY
    HDateistream.Pufferfreigeben;
    HInteger := StrToIntDef(VariablenersetzenText('$BeginIndex#', Variablen), -1);
    HInteger2 := StrToIntDef(VariablenersetzenText('$EndIndex#', Variablen), -1);
    IF HInteger + Anfangoffset < 0 THEN                                         // kleiner Null
    BEGIN
      Anfangoffset := - HInteger;
      IF Anfangoffset > 0 THEN
        Anfangoffset := 0;
    END;
    IF HInteger2 + Endeoffset + 1 > Liste.Count - 1 THEN                        // Liste zu klein
    BEGIN
      Endeoffset := Liste.Count - HInteger2 - 2;
      IF Endeoffset < 0 THEN
        Endeoffset := 0;
    END;
    IF (HInteger > -1) AND (HInteger2 > -1) AND
       (HInteger + Anfangoffset > -1) AND (HInteger + Anfangoffset < Liste.Count) AND
       (HInteger2 + Endeoffset + 1 > -1) AND (HInteger2 + Endeoffset + 1 < Liste.Count) THEN  // Variablen prüfen
    BEGIN
      Result := KopiereSegmentDatei(TAudioheaderklein(Liste[HInteger + Anfangoffset]).Adresse,
                                    TAudioheaderklein(Liste[HInteger2 + Endeoffset + 1]).Adresse - 1,
                                    Dateistream, HDateistream);
      HInteger := HDateistream.Dateigroesse;
    END
    ELSE
      Result := -9;
  FINALLY
    HDateistream.Free;
  END;
  IF (Result = 0) AND
      FileExists(HString) THEN
  BEGIN
    HAudioheader := TAudioheader.Create;
    TRY
      Audioheaderlesen(HString, -1, HAudioheader);
      Variablensetzen(Variablen, HAudioheader);
      IF HAudioheader.Framelaenge > 0 THEN
        HInteger := Round(HInteger / HAudioheader.Framelaenge * HAudioheader.Framezeit) // Dateilänge in Millisekunden
      ELSE
        HInteger := 0;
        Variablesetzen(Variablen, '$FileLength#', IntToStr(HInteger));
      IF HInteger DIV 1000 > 10 THEN                                          // Dateilänge in Sekunden
        Variablesetzen(Variablen, '$LengthSec#', '10')
      ELSE
        IF HInteger DIV 1000 = 0 THEN
          Variablesetzen(Variablen, '$LengthSec#', '500')
        ELSE
          Variablesetzen(Variablen, '$LengthSec#', IntToStr(HInteger DIV 1000));
    FINALLY
      HAudioheader.Free;
    END;
  END;
END;

FUNCTION TAudioschnitt.Effektberechnen(AnfangsIndex, EndIndex: Int64; Effektdateiname, Effektname, EffektParameter: STRING; EffektLaenge: Integer; Audioheader: TAudioHeader; SchnittTyp: STRING = ''): Integer;

VAR HString : STRING;
    HDateistream : TDateiPuffer;
    HAudioheader : TAudioheader;
    Variablen : TStringList;

BEGIN
  Result := 0;
//  IF Assigned(Textanzeige) THEN
//    Textanzeige(4, TextString);
  IF NOT Anhalten THEN
  BEGIN
    IF AnfangsIndex < 0 THEN                                     // AnfangsIndex prüfen und eventuell
      AnfangsIndex := 0;                                         // auf Null setzen
    IF EndIndex > Liste.Count - 2 THEN                           // EndIndex prüfen und eventuell
      EndIndex := Liste.Count - 2;                               // auf maximalen Wert setzen
    IF (AnfangsIndex < EndIndex + 1) AND                         // Anfang liegt vor dem Ende
       (EffektLaenge <> 0) THEN                                  // Effektlänge ist vorhanden
    BEGIN
      Variablen := TStringList.Create;
      TRY
        Variablen.Add('$DateiName#');
        Variablen.Add(ChangeFileExt(ExtractfileName(Quelldateiname), ''));
        Variablen.Add('$Directory#');
        Variablen.Add(ExtractFileDir(Quelldateiname));
        Variablen.Add('$TempDirectory#');
        Variablen.Add(ohnePathtrennzeichen(Zwischenverzeichnis));
        Variablen.Add('$PartFile#');
        Variablen.Add(ErsetzeZeichen(Zwischenverzeichnis + 'PartFile-' + ExtractFileName(ChangeFileExt(Quelldateiname, '')) + '-' + IntToStr(AnfangsIndex) + '-' + IntToStr(EndIndex), ['&', ',']) + ExtractFileExt(Quelldateiname));
        Variablen.Add('$NewFile#');
        Variablen.Add(ErsetzeZeichen(Zwischenverzeichnis + 'NewFile-$Scriptname#-' + ExtractFileName(ChangeFileExt(Quelldateiname, '')) + '-' + IntToStr(AnfangsIndex) + '-' + IntToStr(EndIndex), ['&', ',']) + ExtractFileExt(Quelldateiname));
        Variablen.Add('$OverallLength#');
        Variablen.Add(IntToStr(EffektLaenge));
        Variablen.Add('$BeginIndex#');
        Variablen.Add(IntToStr(AnfangsIndex));
        Variablen.Add('$EndIndex#');
        Variablen.Add(IntToStr(EndIndex));
        Variablen.Add('$BeginAdr#');
        Variablen.Add(IntToStr(TAudioheaderklein(Liste[AnfangsIndex]).Adresse));
        Variablen.Add('$EndAdr#');
        Variablen.Add(IntToStr(TAudioheaderklein(Liste[EndIndex]).Adresse));
        Variablen.Add('$CutType#');
        Variablen.Add(SchnittTyp);
        Variablen.Add('$ProgramDirectory#');
        Variablen.Add(ExtractFileDir(Application.ExeName));
        Variablen.Add('$DeleteTempFiles#');
        Variablen.Add('1');
        Variablen.Add('$Encoder#');
        Variablen.Add(FEncoderDatei);
        Variablensetzen(Variablen, Audioheader);
        VariablenausText(EffektParameter, '=', ';', Variablen);
        ScriptUnit.KopiereQuelldateiteil := TeilDateikopieren;
        CASE Audioheader.Audiotyp OF
          1 : HString := ':pcm';
          2 : HString := ':mp2';
          3 : HString := ':ac3';
        ELSE
          HString := ':all';
        END;
        Result := ScriptUnit.Scriptstarten(Effektdateiname, Variablen, Effektname, HString);
        IF Result = 0 THEN
        BEGIN
          HAudioheader := TAudioheader.Create;
          TRY
            HString := VariablenersetzenText('$NewFile#', Variablen);
            Result := Audioheaderlesen(HString, -1, HAudioheader);
            IF Result = 0 THEN
            BEGIN
              HDateistream := TDateiPuffer.Create(HString, fmOpenRead);
              TRY
                HDateistream.Pufferfreigeben;
                HString := VariablenersetzenText('$EffectFramesBegin#', Variablen);
                AnfangsIndex := StrToIntDef(HString, 0) * HAudioheader.Framelaenge;
                HString := VariablenersetzenText('$EffectFramesEnd#', Variablen);
                EndIndex := HDateistream.Dateigroesse - 1 + (StrToIntDef(HString, 0) * HAudioheader.Framelaenge);
                Result := KopiereSegmentDatei(AnfangsIndex, EndIndex,
                                              HDateistream, Speicherstream);
              FINALLY
                HDateistream.Free;
              END;
              IF Result = 0 THEN
                Indexlistefuellen(AnfangsIndex, EndIndex, HAudioheader)
              ELSE
              BEGIN
                Anhalten := True;
                // Result anpassen
              END;
            END
            ELSE
            BEGIN
              Anhalten := True;
              // Result anpassen
            END;
          FINALLY
            HAudioheader.Free;
          END;
        END
        ELSE
        BEGIN
          Anhalten := True;
          // Result anpassen
        END;
        HString := VariablenersetzenText('$DeleteTempFiles#', Variablen);
        IF HString = '1' THEN
        BEGIN
          HString := VariablenersetzenText('$PartFile#', Variablen);
          DeleteFile(HString);
          DeleteFile(HString + 'idd');
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

PROCEDURE TAudioschnitt.EffektberechnenAnfang(AnfangsIndex, EndIndex: Int64; EffektEintrag: TEffektEintrag; Audioheader: TAudioHeader);

VAR Laenge,
    FehlerNr : Integer;

BEGIN
//  IF Assigned(Textanzeige) THEN
//    Textanzeige(4, TextString);
  IF Assigned(EffektEintrag) THEN
  BEGIN
    IF (NOT Anhalten) AND
       (AnfangsIndex < EndIndex + 1) THEN
    BEGIN
      IF (EffektEintrag.AnfangLaenge = 0) AND                     // Effekt geht über den ganzen Bereich
         (EffektEintrag.EndeLaenge = 0) THEN
        Laenge := -1
      ELSE
        Laenge := EffektEintrag.AnfangLaenge;
//      EffektAudioDaten := NIL;
      IF EffektEintrag.AnfangEffektName <> '' THEN
      BEGIN
//        EffektDaten := TStrings(FEffekte.Objects[EffektEintrag.AnfangEffektPosition]);
{        IF Assigned(EffektAudioDaten) THEN
          CASE Audioheader.Audiotyp OF
            1: EffektDaten := EffektAudioDaten.AudioEffektPCM;
            2: EffektDaten := EffektAudioDaten.AudioEffektMp2;
            3: EffektDaten := EffektAudioDaten.AudioEffektAC3;
          ELSE
            EffektDaten := NIL;
          END
        ELSE
          EffektDaten := NIL; }
{      END
      ELSE
        EffektDaten := NIL;
      IF Assigned(EffektDaten) THEN
      BEGIN                 }
        IF Laenge = -1 THEN
          FehlerNr := Effektberechnen(AnfangsIndex, EndIndex, EffektEintrag.AnfangEffektDateiname, EffektEintrag.AnfangEffektName,
                                      EffektEintrag.AnfangEffektParameter, Round((EndIndex - AnfangsIndex + 1) * Audioheader.Framezeit), Audioheader)
        ELSE
          FehlerNr := Effektberechnen(AnfangsIndex, EndIndex, EffektEintrag.AnfangEffektDateiname, EffektEintrag.AnfangEffektName,
                                      EffektEintrag.AnfangEffektParameter, Laenge, Audioheader, 'In');
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
  {      CASE FehlerNr OF
          -1: Fehlertext := '';
        ELSE
          Fehlertext := ''; 
        END;  }
      END;
    END;
  END;
END;

PROCEDURE TAudioschnitt.EffektberechnenEnde(AnfangsIndex, EndIndex: Int64; EffektEintrag: TEffektEintrag; Audioheader: TAudioHeader);

VAR FehlerNr : Integer;
//    EffektDaten : TStrings;

BEGIN
//  IF Assigned(Textanzeige) THEN
//    Textanzeige(4, TextString);
  IF Assigned(EffektEintrag) THEN
  BEGIN
    IF (NOT Anhalten) AND
       (AnfangsIndex < EndIndex + 1) THEN
    BEGIN
      IF EffektEintrag.EndeEffektName <> '' THEN
      BEGIN
//        EffektDaten := TStrings(FEffekte.Objects[EffektEintrag.EndeEffektPosition]);
{        IF Assigned(EffektAudioDaten) THEN
          CASE Audioheader.Audiotyp OF
            1: EffektDaten := EffektAudioDaten.AudioEffektPCM;
            2: EffektDaten := EffektAudioDaten.AudioEffektMp2;
            3: EffektDaten := EffektAudioDaten.AudioEffektAC3;
          ELSE
            EffektDaten := NIL;
          END
        ELSE
          EffektDaten := NIL;    }
{      END
      ELSE
        EffektDaten := NIL;
      IF Assigned(EffektDaten) THEN
      BEGIN                      }
        FehlerNr := Effektberechnen(AnfangsIndex, EndIndex, EffektEintrag.EndeEffektDateiname, EffektEintrag.EndeEffektName,
                                    EffektEintrag.EndeEffektParameter, EffektEintrag.EndeLaenge, Audioheader, 'Out');
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
   {     CASE FehlerNr OF
          -1: Fehlertext := '';
        ELSE
          Fehlertext := '';
        END;   }
      END;
    END;
  END;  
END;

end.
 