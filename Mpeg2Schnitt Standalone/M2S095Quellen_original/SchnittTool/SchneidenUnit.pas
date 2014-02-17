unit SchneidenUnit;

interface

USES Classes, ComCtrls, SysUtils, Forms, StdCtrls, Grids, Windows,
     Mpeg2Unit, DatenTypen, AusgabeDatenTypen, AllgFunktionen,
     DateienUnit, SchnittUnit, KapitelUnit, AusgabeUnit,
     Sprachen, AllgVariablen, VideoschnittUnit, AudioschnittUnit, ScriptUnit;

TYPE TFortschrittsanzeige = FUNCTION(Fortschritt: Int64): Boolean OF OBJECT;
     TTextanzeige = FUNCTION(Meldung: Integer; Text: STRING): Boolean OF OBJECT;

     TXXX = CLASS
       FUNCTION FortschrittsanzeigeListeSchneiden(Fortschritt: Int64): Boolean;
       FUNCTION TextanzeigeListeSchneiden(Meldung: Integer; Text: STRING): Boolean;
     END;


FUNCTION Speicherplatzpruefen(Dateiname: STRING; VGroesse, AGroesse: Int64): Integer; OVERLOAD;
FUNCTION Schneiden(Dateiname, Projektname: STRING; ProjektInfoObj: TProjektInfo = NIL): Integer; OVERLOAD;
FUNCTION Schneiden(ProjektInfoObj: TProjektInfo): Integer; OVERLOAD;

VAR XXX : TXXX;
    Fortschrittsanzeige : TFortschrittsanzeige;
    Textanzeige: TTextanzeige;
    Endwert : PInt64;
    Schnittpunkteeinzelnschneiden,
    MarkierteSchnittpunkte,
    nurAudioschneiden : Boolean;
//    FehlerText : STRING;

implementation

VAR EndwertListeSchneiden,
    PositionListeSchneiden : Int64;
    AktionListeSchneiden : Integer;

// Wird vom Schnittobjekt aufgerufen, Rückgabe True bedeutet abbrechen
FUNCTION TXXX.FortschrittsanzeigeListeSchneiden(Fortschritt: Int64): Boolean;
BEGIN
  IF Assigned(Fortschrittsanzeige) THEN
    IF AktionListeSchneiden = 4 THEN
      Result := Fortschrittsanzeige(PositionListeSchneiden + Fortschritt)
    ELSE
      Result := Fortschrittsanzeige(0)
  ELSE
    Result := False;
END;

// Wird vom Schnittobjekt aufgerufen, Rückgabe True bedeutet abbrechen
FUNCTION TXXX.TextanzeigeListeSchneiden(Meldung: Integer; Text: STRING): Boolean;
BEGIN
  IF Assigned(Textanzeige) THEN
    Result := Textanzeige(Meldung, Text)
  ELSE
    Result := False;
  AktionListeSchneiden := Meldung;
END;

// Kopiert einen Schnittpunkt mit Effektobjekten
//  1 : Zielobjekt selbst erzeugt und mit Daten gefüllt
//  0 : vorhandenes Zielobjekt mit Daten gefüllt
// -1 : kein Quellobjekt übergeben
FUNCTION Schnittkopieren(Quelle: TSchnittpunkt; VAR Ziel: TSchnittpunkt): Integer;

PROCEDURE EffektKopieren(Quelle, Ziel: TEffektEintrag);
BEGIN
  IF Assigned(Quelle) AND Assigned(Ziel) THEN
  BEGIN
    Ziel.AnfangEffektName := Quelle.AnfangEffektName;
    Ziel.AnfangEffektDateiname := Quelle.AnfangEffektDateiname;
    Ziel.AnfangLaenge := Quelle.AnfangLaenge;
    Ziel.AnfangEffektParameter := Quelle.AnfangEffektParameter;
    Ziel.EndeEffektName := Quelle.EndeEffektName;
    Ziel.EndeEffektDateiname := Quelle.EndeEffektDateiname;
    Ziel.EndeLaenge := Quelle.EndeLaenge;
    Ziel.EndeEffektParameter := Quelle.EndeEffektParameter;
  END;
END;

BEGIN
  IF Assigned(Quelle) THEN
  BEGIN
    IF NOT Assigned(Ziel) THEN
    BEGIN
      Ziel := TSchnittpunkt.Create;
      Result := 1
    END
    ELSE
      Result := 0;
    Ziel.Videoknoten := Quelle.Videoknoten;
    Ziel.Audioknoten := Quelle.Audioknoten;
    Ziel.Anfang := Quelle.Anfang;
    Ziel.Anfangberechnen := Quelle.Anfangberechnen;
    Ziel.Ende := Quelle.Ende;
    Ziel.Endeberechnen := Quelle.Endeberechnen;
    Ziel.VideoGroesse := Quelle.VideoGroesse;
    Ziel.AudioGroesse := Quelle.AudioGroesse;
    Ziel.Framerate := Quelle.Framerate;
    Ziel.Audiooffset := Quelle.Audiooffset;
    Ziel.VideoListe := Quelle.VideoListe;
    Ziel.VideoIndexListe := Quelle.VideoIndexListe;
    Ziel.AudioListe := Quelle.AudioListe;
    EffektKopieren(Quelle.VideoEffekt, Ziel.VideoEffekt);
    EffektKopieren(Quelle.AudioEffekt, Ziel.AudioEffekt);
  END
  ELSE
    Result := -1;
END;

// Laufwerksinformationen
//  3 : NTSC-Laufwerk
//  2 : FAT32-Laufwerk
//  1 : FAT-Laufwerk
// -1 : Laufwerkstyp nicht feststellbar
FUNCTION LaufwerksInfo(Laufwerk: Char): Integer;

VAR Root: ARRAY[0..20] OF Char;
    FileSysName, VolName: ARRAY[0..255] OF Char;
    SerialNum, MaxCLength, FileSysFlag: Longword;

BEGIN
  Root := 'C:\';
  Root[0] := Laufwerk;
  GetVolumeInformation(Root, VolName, 255, @SerialNum, MaxCLength, FileSysFlag, FileSysName, 255);
  IF FileSysName = 'FAT' THEN
    Result := 1
  ELSE
    IF FileSysName = 'FAT32' THEN
      Result := 2
    ELSE
      IF FileSysName = 'NTSC' THEN
        Result := 3
      ELSE
        Result := -1;
END;

// Speicherplatz auf Ziellaufwerk überprüfen
//  2 : kein Speicherplatzprüfen
//  1 : keine Prüfung möglich (z.B. Netzlaufwerk)
//  0 : genügend Speicherplatz vorhanden
// -1 : nicht genügend Speicherplatz vorhanden
// -2 : genügend Speicherplatz vorhanden aber Datei größer 4GB soll auf FAT oder FAT32 geschrieben werden
FUNCTION Speicherplatzpruefen(Dateiname: STRING; VGroesse, AGroesse: Int64): Integer; OVERLOAD;

VAR I : Integer;
    Laufwerk : Int64;

BEGIN
  Laufwerk := Diskfree(Byte(Ord(Uppercase(Dateiname)[1])-64));
  IF Laufwerk > -1 THEN
  BEGIN
    IF Laufwerk < (VGroesse + AGroesse) THEN
      Result := -1
    ELSE
    BEGIN
      I := LaufwerksInfo(Dateiname[1]);
      IF (I > -1) AND (I < 3) AND                                             // FAT oder FAT32 Laufwerk
         ((VGroesse > 4294967295) OR
          (AGroesse > 4294967295)) THEN                                       // 4 GByte -1
        Result := -2
      ELSE
        Result := 0;
    END;
  END
  ELSE
    Result := 1;
END;

FUNCTION Speicherplatzpruefen(Dateiname: STRING; SchnittListe: TStrings; VideoAudio: Integer = 0): Integer; OVERLOAD;

VAR I : Integer;
    VGroesse,
    AGroesse : Int64;

BEGIN
  IF ArbeitsumgebungObj.Speicherplatzpruefen THEN
  BEGIN
    VGroesse := 0;
    AGroesse := 0;
    I := 0;
    WHILE I < SchnittListe.Count DO
    BEGIN
      CASE VideoAudio OF
        1 : VGroesse := VGroesse + TSchnittpunkt(SchnittListe.Objects[I]).VideoGroesse;
        2 : AGroesse := AGroesse + TSchnittpunkt(SchnittListe.Objects[I]).AudioGroesse;
      ELSE
        VGroesse := VGroesse + TSchnittpunkt(SchnittListe.Objects[I]).VideoGroesse;
        AGroesse := AGroesse + TSchnittpunkt(SchnittListe.Objects[I]).AudioGroesse;
      END;
      Inc(I);
    END;
    Result := Speicherplatzpruefen(Dateiname, VGroesse, AGroesse);
  END
  ELSE
    Result := 2;
END;

// füllt die Schnittliste mit Dateinamen und prüft die Dateitypen pro Spur, gibt den Dateityp zurück
//  1 : kein Schnittpunkt verweist auf eine Datei
//  0 : Ok
// -1 : eine Datei läßt sich nicht öffnen
// -2 : unterschiedliche Dateitypen in einer Spur
// -3 : mindestens ein Schnittpunkt hat keine Datei (nur bei Video wichtig)
FUNCTION Schnittlistefuellen(SchnittListe: TStrings; Spur: Integer; VAR DateiTyp: Byte): Integer; OVERLOAD;

VAR I, J : Integer;
    Schnittpunkt : TSchnittpunkt;
//    Mpeg2Header : TMpeg2Header;
    MpegAudio : TMpegAudio;

BEGIN
  Result := 0;
  DateiTyp := 0;
  J := 0;
  FOR I := 0 TO SchnittListe.Count - 1 DO
  BEGIN
    Schnittpunkt := TSchnittpunkt(SchnittListe.Objects[I]);
    Schnittpunkt.VideoListe := NIL;                // im SchnittTool sind keine Listen vorhanden
    Schnittpunkt.VideoIndexListe := NIL;           // später werden sie ganz entfallen
    Schnittpunkt.AudioListe := NIL;
    IF Spur = 0 THEN                                                            // Video
      IF Assigned(Schnittpunkt.Videoknoten) AND
         Schnittpunkt.Videoknoten.HasChildren AND
         Assigned(Schnittpunkt.Videoknoten[0].Data) THEN
      BEGIN
        Schnittpunkt.VideoName := TDateieintrag(Schnittpunkt.Videoknoten[0].Data).Name;
        IF Schnittpunkt.VideoName <> '' THEN
        BEGIN
    {      Mpeg2Header := TMpeg2Header.Create;
          TRY
            IF Mpeg2Header.DateiOeffnen(Schnittpunkt.VideoName) THEN

            //  Vergleich der Eigenschaften der Sequenz- und Bildheader

            ELSE
            BEGIN
              Result := -1;
              Fehlertext := Schnittpunkt.VideoName;
            END;
          FINALLY
            Mpeg2Header.Free;
          END;    }
          Inc(J);                                                               // nur erhöhen wenn wirklich eine Videodatei existiert
        END;
      END
      ELSE
        Schnittpunkt.VideoName := ''
    ELSE
      IF Assigned(Schnittpunkt.Audioknoten) AND
         (Spur < Schnittpunkt.Audioknoten.Count) AND
         Assigned(Schnittpunkt.Audioknoten[Spur].Data) THEN
      BEGIN
        Schnittpunkt.AudioName := TDateieintragAudio(Schnittpunkt.Audioknoten[Spur].Data).Name;
        Schnittpunkt.Audiooffset := TDateieintragAudio(Schnittpunkt.Audioknoten[Spur].Data).Audiooffset;
        IF Schnittpunkt.AudioName <> '' THEN
        BEGIN
          MpegAudio := TMpegAudio.Create;
          TRY
            IF MpegAudio.Dateioeffnen(Schnittpunkt.AudioName) = 0 THEN
            BEGIN
              IF DateiTyp = 0 THEN
                DateiTyp := MpegAudio.AudioDateiType
              ELSE
                IF DateiTyp <> MpegAudio.AudioDateiType THEN
                  Result := -2;                                                 // Dateitypen stimmen nicht überein
            END
            ELSE
            BEGIN
              Result := -1;                                                     // Datei läßt sich nicht öffnen
              Fehlertext := Schnittpunkt.AudioName;
            END;
          FINALLY
            MpegAudio.Free;
          END;
          Inc(J);                                                               // nur erhöhen wenn wirklich eine Audiodatei existiert
        END;
      END
      ELSE
      BEGIN
        Schnittpunkt.AudioName := '';
        Schnittpunkt.Audiooffset := 0;
      END;
  END;
  IF Result = 0 THEN
    IF J > 0 THEN
      IF (Spur = 0) AND (J < SchnittListe.Count) THEN                           // nur für Video wichtig
        Result := -3                                                            // mindestens ein Schnittpunkt hat keine Datei
      ELSE
        Result := 0                                                             // alle Schnittpunkte haben eine Datei (bzw. mindestens eine Datei vorhanden)
    ELSE
      Result := 1;                                                              // kein Schnittpunkt hat eine Datei
END;

// füllt die Schnittliste mit Dateinamen und prüft die Dateitypen pro Spur
FUNCTION Schnittlistefuellen(SchnittListe: TStrings; Spur: Integer): Integer; OVERLOAD;

VAR DateiTyp : Byte;

BEGIN
  Result := Schnittlistefuellen(SchnittListe, Spur, DateiTyp);
END;

// schneidet den Videoteil der Schnittliste
//       0 : Ok
//      -1 : die Dateiendung der Spur konnte nicht ermittelt werden
//      -2 : der Zieldateiname kommt als Quelldateiname in der Schnittliste vor
//ab -1001 : Fehler in der Funktion Speicherplatzpruefen
//ab -2001 : Fehler in der Funktion Schnittlistefuellen
//ab -3001 : Fehler in der Funktion Videoschneiden
FUNCTION ListeSchneidenVideo(Dateiname: STRING; SchnittListe: TStrings; MuxListe: TStrings; ProjektInfoObj: TProjektInfo): Integer;

VAR Videoschnitt : TVideoschnitt;
    DateiEndung : STRING;
    I : Integer;

BEGIN
  Result := Speicherplatzpruefen(Dateiname, SchnittListe, 1);
  IF Result > -1 THEN
  BEGIN
    Result := Schnittlistefuellen(SchnittListe, 0);                               // und Fehlerprüfung
    IF Result = 0 THEN
    BEGIN
      IF NOT Dateiendungpruefen(ExtractFileExt(Dateiname), ArbeitsumgebungObj.DateiendungenVideo) THEN
      BEGIN                                                                       // keine Videodateiendung vorhanden
        DateiEndung := ExtractDateiendungSpur(0, SchnittListe);
        IF Dateiendung = '$leer#' THEN
          Result := -1
        ELSE
        BEGIN
          IF ArbeitsumgebungObj.StandardEndungenverwenden AND (ArbeitsumgebungObj.StandardEndungenVideo <> '') THEN
            DateiEndung := ArbeitsumgebungObj.StandardEndungenVideo;              // Standardendung verwenden
          Dateiname := Dateiname + DateiEndung;
        END;
      END;
      IF Result = 0 THEN
      BEGIN
        FOR I := 0 TO SchnittListe.Count - 1 DO
          IF Dateiname = TSchnittpunkt(SchnittListe.Objects[I]).VideoName THEN    // prüfen ob der Zieldateiname in der Schnittliste vorkommt
          BEGIN
            Result := -2;
            Fehlertext := Dateiname;
          END;
        IF Result = 0 THEN
        BEGIN
          Videoschnitt := TVideoschnitt.Create;
          TRY
            Videoschnitt.FortschrittsEndwert := @EndwertListeSchneiden;
            Videoschnitt.Textanzeige := XXX.TextanzeigeListeSchneiden;
            Videoschnitt.Fortschrittsanzeige := XXX.FortschrittsanzeigeListeSchneiden;
            IF Assigned(ProjektInfoObj) THEN
            BEGIN
              Videoschnitt.Timecodekorrigieren := ProjektInfoObj.Timecodekorrigieren;
              Videoschnitt.Bitratekorrigieren := ProjektInfoObj.Bitratekorrigieren;
              Videoschnitt.BitrateersterHeader := ProjektInfoObj.BitrateersterHeader;
              Videoschnitt.festeBitrate := ProjektInfoObj.festeBitrate;
              Videoschnitt.AspectratioersterHeader := ProjektInfoObj.AspectratioersterHeader;
              Videoschnitt.AspectratioOffset := ProjektInfoObj.AspectratioOffset;
              IF ProjektInfoObj.maxGOPLaengeverwenden THEN
                Videoschnitt.maxGOPLaenge := ArbeitsumgebungObj.maxGOPLaenge
              ELSE
                Videoschnitt.maxGOPLaenge := 0;
              Videoschnitt.IndexDateierstellen := ProjektInfoObj.IndexDateierstellen;
              Videoschnitt.D2VDateierstellen := ProjektInfoObj.D2VDateierstellen;
              Videoschnitt.IDXDateierstellen := ProjektInfoObj.IDXDateierstellen;
              Videoschnitt.Framegenauschneiden := ProjektInfoObj.Framegenauschneiden;
              Videoschnitt.ZusammenhaengendeSchnitteberechnen := ProjektInfoObj.ZusammenhaengendeSchnitteberechnen;
              Videoschnitt.EncoderDatei := ProjektInfoObj.Encoderdatei;
//              Videoschnitt.Effekte := ProjektInfoObj.VideoEffektdatei;
            END
            ELSE
            BEGIN
              Videoschnitt.Timecodekorrigieren := ArbeitsumgebungObj.Timecodekorrigieren;
              Videoschnitt.Bitratekorrigieren := ArbeitsumgebungObj.Bitratekorrigieren;
              Videoschnitt.BitrateersterHeader := ArbeitsumgebungObj.BitrateersterHeader;
              Videoschnitt.festeBitrate := ArbeitsumgebungObj.festeBitrate;
              Videoschnitt.AspectratioersterHeader := ArbeitsumgebungObj.AspectratioersterHeader;
              Videoschnitt.AspectratioOffset := ArbeitsumgebungObj.AspectratioOffset;
              IF ArbeitsumgebungObj.maxGOPLaengeverwenden THEN
                Videoschnitt.maxGOPLaenge := ArbeitsumgebungObj.maxGOPLaenge
              ELSE
                Videoschnitt.maxGOPLaenge := 0;
              Videoschnitt.IndexDateierstellen := ArbeitsumgebungObj.IndexDateierstellen;
              Videoschnitt.D2VDateierstellen := ArbeitsumgebungObj.D2VDateierstellen;
              Videoschnitt.IDXDateierstellen := ArbeitsumgebungObj.IDXDateierstellen;
              Videoschnitt.Framegenauschneiden := ArbeitsumgebungObj.Framegenauschneiden;
              Videoschnitt.ZusammenhaengendeSchnitteberechnen := ArbeitsumgebungObj.ZusammenhaengendeSchnitteberechnen;
//              Videoschnitt.EncoderDatei := ArbeitsumgebungObj.Encoderdatei;
//              Videoschnitt.Effekte := ArbeitsumgebungObj.VideoEffektdatei;
            END;
            Videoschnitt.minAnfang := ArbeitsumgebungObj.minAnfang;
            Videoschnitt.minEnde := ArbeitsumgebungObj.minEnde;
            Videoschnitt.Zwischenverzeichnis := ArbeitsumgebungObj.ZwischenVerzeichnis;
            Videoschnitt.Zieldateiname := Dateiname;
            Result := Videoschnitt.Schneiden(SchnittListe);
          FINALLY
            Videoschnitt.Free;
          END;
          IF Result > -1 THEN
          BEGIN
            PositionListeSchneiden := PositionListeSchneiden + EndwertListeSchneiden;
            IF Assigned(MuxListe) THEN
              MuxListe.Add('VideoFile=' + Dateiname);
          END
          ELSE
            Result := Result - 3000;
        END;
      END;
    END
    ELSE
      IF Result < 0 THEN
        Result := Result - 2000;
  END
  ELSE
    Result := Result - 1000;
END;

// schneidet den Audioteil der Schnittliste
//       0 : Ok
//      -1 : die Dateiendung der Spur konnte nicht ermittelt werden
//      -2 : der Zieldateiname kommt als Quelldateiname in der Schnittliste vor
//ab -1001 : Fehler in der Funktion Speicherplatzpruefen
//ab -2001 : Fehler in der Funktion Schnittlistefuellen
//ab -3001 : Fehler in der Funktion Audioschneiden
FUNCTION ListeSchneidenAudio(Dateiname: STRING; SchnittListe: TStrings; MuxListe: TStrings; ProjektInfoObj: TProjektInfo): Integer;

VAR Audioschnitt : TAudioschnitt;
    HDateiname,
    DateiEndung : STRING;
    Nummerieren,
    I, J : Integer;
    Audiotyp : Byte;

BEGIN
  Result := Speicherplatzpruefen(Dateiname, SchnittListe, 2);
  IF Result > -1 THEN
  BEGIN
    I := DateienUnit.SpurAnzahl - 1;
    IF I > 1 THEN                                                                 // mehr als eine Audiodatei
      IF Dateiendungpruefen(ExtractFileExt(Dateiname), ArbeitsumgebungObj.DateiendungenAudio) THEN
        Dateiname := ChangeFileExt(Dateiname, '');                                // Audioendung entfernen
    HDateiname := Dateiname;
    WHILE (I > 0) AND (Result > -1) DO
    BEGIN
      Result := Schnittlistefuellen(SchnittListe, I, Audiotyp);                   // und Fehlerprüfung
      IF Result = 0 THEN
      BEGIN
        IF NOT Dateiendungpruefen(ExtractFileExt(Dateiname), ArbeitsumgebungObj.DateiendungenAudio) THEN
        BEGIN                                                                     // keine Audiodateiendung vorhanden
          DateiEndung := ExtractDateiendungSpur(I, SchnittListe);
          IF DateiEndung = '$leer#' THEN
            Result := -1
          ELSE
            IF ArbeitsumgebungObj.StandardEndungenverwenden THEN
              CASE Audiotyp OF                                                    // Standardendung verwenden
                1 : IF ArbeitsumgebungObj.StandardEndungenPCM <> '' THEN DateiEndung := ArbeitsumgebungObj.StandardEndungenPCM;
                2 : IF ArbeitsumgebungObj.StandardEndungenMP2 <> '' THEN DateiEndung := ArbeitsumgebungObj.StandardEndungenMP2;
                3 : IF ArbeitsumgebungObj.StandardEndungenAC3 <> '' THEN DateiEndung := ArbeitsumgebungObj.StandardEndungenAC3;
              END;
        END
        ELSE
        BEGIN
          Dateiendung := ExtractFileExt(Dateiname);                               // Dateiname und Endung trennen
          Dateiname := ChangeFileExt(Dateiname, '');
        END;
        IF Result = 0 THEN
        BEGIN
          Nummerieren := Audioendungszaehler(SchnittListe, I);
          IF Nummerieren > 0 THEN
            Dateiname := Dateiname + IntToStr(Nummerieren) + DateiEndung          // Dateiname nummerieren
          ELSE
            Dateiname := Dateiname + DateiEndung;
          FOR J := 0 TO SchnittListe.Count - 1 DO
            IF Dateiname = TSchnittpunkt(SchnittListe.Objects[J]).AudioName THEN  // prüfen ob der Zieldateiname in der Schnittliste vorkommt
            BEGIN
              Result := -2;
              Fehlertext := Dateiname;
            END;
          IF Result = 0 THEN
          BEGIN
            Audioschnitt := TAudioschnitt.Create;
            TRY
              Audioschnitt.FortschrittsEndwert := @EndwertListeSchneiden;
              Audioschnitt.Textanzeige := XXX.TextanzeigeListeSchneiden;
              Audioschnitt.Fortschrittsanzeige := XXX.FortschrittsanzeigeListeSchneiden;
              IF Assigned(ProjektInfoObj) THEN
              BEGIN
                Audioschnitt.IndexDateierstellen := ProjektInfoObj.IndexDateierstellen;
//                Audioschnitt.Effekte := ProjektInfoObj.AudioEffektdatei;
              END
              ELSE
              BEGIN
                Audioschnitt.IndexDateierstellen := ArbeitsumgebungObj.IndexDateierstellen;
//                Audioschnitt.Effekte := ArbeitsumgebungObj.AudioEffektdatei;
              END;
              Audioschnitt.leereAudioframesMpeg := ArbeitsumgebungObj.leereAudioframesMpegliste;
              Audioschnitt.leereAudioframesAC3 := ArbeitsumgebungObj.leereAudioframesAC3liste;
              Audioschnitt.leereAudioframesPCM := ArbeitsumgebungObj.leereAudioframesPCMliste;
              Audioschnitt.Zwischenverzeichnis := ArbeitsumgebungObj.ZwischenVerzeichnis;
//              Audioschnitt.Zieldateioeffnen(Dateiname);
              Audioschnitt.Zieldateiname := Dateiname;
              Result := Audioschnitt.Schneiden(SchnittListe);
            FINALLY
              Audioschnitt.Free;
            END;
            IF Result > -1 THEN
            BEGIN
              PositionListeSchneiden := PositionListeSchneiden + EndwertListeSchneiden;
              IF Assigned(MuxListe) THEN
                MuxListe.Add('AudioFile' + IntToStr(I) + '=' + Dateiname);
            END
            ELSE
              Result := Result - 3000;
          END;
        END;
      END
      ELSE
        IF Result < 0 THEN
          Result := Result - 2000;
      Dateiname := HDateiname;
      Dec(I);
    END;
  END
  ELSE
    Result := Result - 1000;
END;

// schneidet eine komplette Liste
//        0 : Ok
//ab -10001 : Fehler beim Videoschneiden
//ab -20001 : Fehler beim Audioschneiden
//ab -30001 : Fehler beim erstellen der Kapiteldatei
//ab -40001 : Fehler bei der Ausgabe (Muxen)
FUNCTION ListeSchneiden(Dateiname, Projektname: STRING; SchnittListe: TStrings; ProjektInfoObj: TProjektInfo): Integer;

VAR AusgabeListe : TStringList;

BEGIN
  Result := 0;
  AusgabeListe := TStringList.Create;
  TRY
    IF (Assigned(ProjektInfoObj) AND NOT ProjektInfoObj.nurAudioschneiden) OR
       (NOT Assigned(ProjektInfoObj) AND NOT nurAudioschneiden) THEN
      Result := ListeSchneidenVideo(Dateiname, SchnittListe, AusgabeListe, ProjektInfoObj);
    IF Result > - 1 THEN
    BEGIN
      IF Dateiendungpruefen(ExtractFileExt(Dateiname), ArbeitsumgebungObj.DateiendungenVideo) THEN             // Videoendung entfernen
        Dateiname := ChangeFileExt(Dateiname, '');
      Result := ListeSchneidenAudio(Dateiname, SchnittListe, AusgabeListe, ProjektInfoObj);
      IF Result > -1 THEN
      BEGIN
        IF Dateiendungpruefen(ExtractFileExt(Dateiname), ArbeitsumgebungObj.DateiendungenAudio) THEN           // Audioendung entfernen
          Dateiname := ChangeFileExt(Dateiname, '');
        IF (Assigned(ProjektInfoObj) AND ProjektInfoObj.Kapiteldateierstellen) OR
           (NOT Assigned(ProjektInfoObj) AND ArbeitsumgebungObj.Kapiteldateierstellen) THEN
          Result := KapitelUnit.Kapitelspeichern(Dateiname, -1, -1, SchnittListe);
        IF Result > -1 THEN
        BEGIN
          IF (Assigned(ProjektInfoObj) AND ProjektInfoObj.Ausgabebenutzen) OR
             (NOT Assigned(ProjektInfoObj) AND ArbeitsumgebungObj.Ausgabebenutzen) THEN
          BEGIN
            Result := AusgabeUnit.Ausgabe(Projektname, AusgabeListe, SchnittListe, ProjektInfoObj);
            IF Result < 0 THEN
              Result := Result - 40000;
          END;
        END
        ELSE
          Result := Result - 30000;
      END
      ELSE
        Result := Result - 20000;
    END
    ELSE
      Result := Result - 10000;
  FINALLY
    AusgabeListe.Free;
  END;
END;

//prüft die verwendeten Scripte
// 0 : Ok
// ab -1 : Scriptfehler
FUNCTION Scriptepruefen(SchnittpunktListe: TStringList; ProjektInfoObj: TProjektInfo): Integer;

VAR Erg : Integer;
    Marke : STRING;
    Variablen : TStringList;
    Scripte : TStringList;
    Effekt : TEffektEintrag;

  FUNCTION EffektScriptepruefen(Audio: Boolean): Integer;

  VAR I : Integer;

  BEGIN
    Result := 0;
    Scripte := TStringList.Create;
    TRY
      I := 0;
      WHILE (I < SchnittpunktListe.Count) AND ((Result = 0) OR (Result = -20)) DO
      BEGIN
        IF Audio THEN
        BEGIN
          Effekt := TSchnittpunkt(SchnittpunktListe.Objects[I]).AudioEffekt;
          Marke := ':all';
        END
        ELSE
        BEGIN
          Effekt := TSchnittpunkt(SchnittpunktListe.Objects[I]).VideoEffekt;
          Marke := ':eff';
        END;
        IF Assigned(Effekt) THEN
        BEGIN
          IF (Effekt.AnfangLaenge = 0) AND (Effekt.EndeLaenge = 0) AND
             (Effekt.AnfangEffektName <> '') THEN                               // Effekt über den ganzen Schnitt
          BEGIN
            IF Scripte.IndexOf(Effekt.AnfangEffektName) = -1 THEN               // Effekt wurde noch nicht geprüft
            BEGIN
              Result := Scriptpruefen(Effekt.AnfangEffektDateiname, Variablen, Effekt.AnfangEffektName, Marke); // Anfangseffektscript prüfen
              Scripte.Add(Effekt.AnfangEffektName);
            END;
          END  
          ELSE
          BEGIN
            IF (Effekt.AnfangLaenge > 0) AND (Effekt.AnfangEffektName <> '') THEN
              IF Scripte.IndexOf(Effekt.AnfangEffektName) = -1 THEN             // Effekt wurde noch nicht geprüft
              BEGIN
                Result := Scriptpruefen(Effekt.AnfangEffektDateiname, Variablen, Effekt.AnfangEffektName, Marke); // Anfangseffektscript prüfen
                Scripte.Add(Effekt.AnfangEffektName);
              END;
            IF (Result = 0) AND (Effekt.EndeLaenge > 0) AND (Effekt.EndeEffektName <> '') THEN
              IF Scripte.IndexOf(Effekt.EndeEffektName) = -1 THEN               // Effekt wurde noch nicht geprüft
              BEGIN
                Result := Scriptpruefen(Effekt.EndeEffektDateiname, Variablen, Effekt.EndeEffektName, Marke);   // Endeeffektscript prüfen
                Scripte.Add(Effekt.EndeEffektName);
              END;
          END;
        END;
        Inc(I);
      END;
    FINALLY
      Scripte.Free;
    END;
  END;

BEGIN
  Result := 0;
  Variablen := TStringList.Create;
  TRY
    Variablen.Add('$Encoder#');
    Variablen.Add(ProjektInfoObj.Encoderdatei);
    Erg := EffektScriptepruefen(False);                                         // Videoeffektscripte prüfen
    IF Erg < 0 THEN
      Result := Result + Erg * 1000;
    Erg := EffektScriptepruefen(True);                                        // Audioeffektscripte prüfen
    IF Erg < 0 THEN
      Result := Result + Erg * 100;
    IF ProjektInfoObj.Framegenauschneiden OR
       ProjektInfoObj.maxGOPLaengeverwenden THEN
    BEGIN
      Erg := Scriptpruefen(ProjektInfoObj.Encoderdatei, Variablen, '', ':enc'); // Encoderscript prüfen
      IF Erg < 0 THEN
        Result := Erg * 10;
    END;
    IF ProjektInfoObj.Ausgabebenutzen THEN
    BEGIN
      Erg := Scriptpruefen(ProjektInfoObj.Ausgabedatei, Variablen);           // Ausgabesript prüfen
      IF Erg < 0 THEN
        Result := Result + Erg;
    END;
  FINALLY
    Variablen.Free;
  END;
END;

// schneidet eine Liste unter Beachtung des Parameters Schnittpunkteeinzelnschneiden
//  0 : Ok
// -1 : Schnittliste ist leer
FUNCTION Schneiden(Dateiname, Projektname: STRING; ProjektInfoObj: TProjektInfo = NIL): Integer;

VAR I : Integer;
    Schnittpunkt : TSchnittpunkt;
    SchnittpunktListe : TStringList;

BEGIN
  Verzeichniserstellen(ExtractFilePath(Dateiname));                             // Zielverzeichnis
  Verzeichniserstellen(ArbeitsumgebungObj.ZwischenVerzeichnis);                 // Zwischenverzeichnis für die Effektberechnung
  SchnittpunktListe := TStringList.Create;
  TRY
    IF Assigned(Endwert) THEN
    BEGIN
      Endwert^ := 0;
      IF Assigned(ProjektInfoObj) THEN
      BEGIN
        IF NOT ProjektInfoObj.nurAudioschneiden THEN
          Endwert^ := ProjektInfoObj.VideoGroesse;
        Endwert^ := Endwert^ + ProjektInfoObj.AudioGroesse;
      END
      ELSE    
        FOR I := 0 TO SchnittListe.Items.Count -1 DO
          IF (NOT MarkierteSchnittpunkte) OR SchnittListe.Selected[I] THEN
          BEGIN
            IF NOT nurAudioschneiden THEN
              Endwert^ := Endwert^ + TSchnittpunkt(SchnittListe.Items.Objects[I]).VideoGroesse;
            Endwert^ := Endwert^ + TSchnittpunkt(SchnittListe.Items.Objects[I]).AudioGroesse;
          END;
    END;
    FOR I := 0 TO SchnittListe.Items.Count -1 DO                                // Schnittliste füllen
      IF (NOT MarkierteSchnittpunkte) OR SchnittListe.Selected[I] THEN
      BEGIN
        Schnittpunkt := NIL;
        Schnittkopieren(TSchnittpunkt(SchnittListe.Items.Objects[I]), Schnittpunkt);
        SchnittpunktListe.AddObject('', Schnittpunkt);
      END;
    IF SchnittpunktListe.Count = 0 THEN
      Result := -1
    ELSE
    BEGIN
      Result := Scriptepruefen(SchnittpunktListe, ProjektInfoObj);
      IF Result < 0 THEN
        Result := Result - 50000;
    END;
{    IF Result = 0 THEN       // globale Prüfung des gesammten benötigten Speicherplatzes
    BEGIN
      IF (Assigned(ProjektInfoObj) AND NOT ProjektInfoObj.nurAudioschneiden) OR
         (NOT Assigned(ProjektInfoObj) AND NOT nurAudioschneiden) THEN
        Result := Speicherplatzpruefen(Dateiname, SchnittListe, 0)
      ELSE
        Result := Speicherplatzpruefen(Dateiname, SchnittListe, 2);
      IF Result < 0 THEN
        Result := Result - 60000
      ELSE
        Result := 0;
    END;   }
    IF Result = 0 THEN
    BEGIN
      PositionListeSchneiden := 0;
      IF (Assigned(ProjektInfoObj) AND ProjektInfoObj.Schnittpunkteeinzelnschneiden) OR
         (NOT Assigned(ProjektInfoObj) AND Schnittpunkteeinzelnschneiden) THEN
      BEGIN
        I := 0;
        WHILE (I < SchnittListe.Items.Count) AND
              (Result > -1) DO
        BEGIN
          IF (NOT MarkierteSchnittpunkte) OR SchnittListe.Selected[I] THEN
          BEGIN
            Stringliste_loeschen(SchnittpunktListe);
            Schnittpunkt := NIL;
            Schnittkopieren(TSchnittpunkt(SchnittListe.Items.Objects[I]), Schnittpunkt);
            SchnittpunktListe.AddObject('', Schnittpunkt);
            Result := ListeSchneiden(Dateiname, Projektname, SchnittpunktListe, ProjektInfoObj);
            Dateiname := DateinamePlusEins(Dateiname, ArbeitsumgebungObj.SchnittpunkteeinzelnFormat);
          END;
          Inc(I);
        END;
      END
      ELSE
        Result := ListeSchneiden(Dateiname, Projektname, SchnittpunktListe, ProjektInfoObj);
    END;
  FINALLY
    Stringliste_loeschen(SchnittpunktListe);
    SchnittpunktListe.Free;
  END;
END;

FUNCTION Schneiden(ProjektInfoObj: TProjektInfo): Integer;
BEGIN
  IF Assigned(ProjektInfoObj) THEN
    Result := Schneiden(ProjektInfoObj.Zieldateiname, ProjektInfoObj.Dateiname, ProjektInfoObj)
  ELSE
    Result := -2;
END;

INITIALIZATION
  XXX := TXXX.Create;

FINALIZATION
  XXX.Free;

end.
