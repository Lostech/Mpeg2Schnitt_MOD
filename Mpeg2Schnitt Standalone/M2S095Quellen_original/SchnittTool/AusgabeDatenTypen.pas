unit AusgabeDatenTypen;

interface

USES Classes, IniFiles, Forms, SysUtils, StrUtils,
     DatenTypen, AllgFunktionen, Sprachen;

TYPE
{  TAusgabe = CLASS
    Demuxerdatei : STRING;
    Encoderdatei : STRING;
    Ausgabedatei : STRING;
    DemuxerIndex : Integer;
    EncoderIndex : Integer;
    AusgabeIndex : Integer;
    DemuxerListe : TStringList;
    EncoderListe : TStringList;
    AusgabeListe : TStringList;
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
    FUNCTION ExterneProgrammeladen(Demuxer, Encoder, Ausgabe: STRING): Integer;
    FUNCTION ExterneProgrammespeichern(Demuxer, Encoder, Ausgabe: STRING): Integer;
  END;

  TEffekte = CLASS
    VideoEffektdatei : STRING;
    AudioEffektdatei : STRING;
    VideoEffekte : TStringList;
    AudioEffekte : TStringList;
    Videoeffektvorgaben : TStringList;
    Audioeffektvorgaben : TStringList;
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
    FUNCTION Effekteladen(VideoEffekt, AudioEffekt: STRING): Integer;
    FUNCTION Effektespeichern(VideoEffekt, AudioEffekt: STRING): Integer;
  END;  }

  TProjektInfo = CLASS
    Dateiname,
    Projektname,
    IniDatei,
    Zieldateiname,
    Videoname,
    AudioTrennzeichen,
    Ausgabedatei,
    Encoderdatei: STRING;
    AudioSpuren,
    SchnittAnzahl,
    BitrateersterHeader,    // 0 = nicht ändern, 1 = orginale Bitrate, 2 = durchschnittliche Bitrate, 3 = maximale Bitrate, 4 = feste Bitrate
    festeBitrate,
    AspectratioersterHeader, // 0 = nicht ändern, 1 = 1/1, 2 = 3/4, 3 = 9/16, 4 = 1/2.21, 5 = vom xten Header
    AspectratioOffset{,
    maxGOPLaenge }: Integer;
    VideoGroesse,
    AudioGroesse: Int64;
    BilderProSek: Real;
    Timecodekorrigieren,
    Bitratekorrigieren,
    IndexDateierstellen,
    D2VDateierstellen,
    IDXDateierstellen,
    KapitelDateierstellen,
    nurAudioschneiden,
    Ausgabebenutzen,
    maxGOPLaengeverwenden,
    Schnittpunkteeinzelnschneiden,
    Framegenauschneiden,
    ZusammenhaengendeSchnitteberechnen : Boolean;
    CONSTRUCTOR Create;
  END;

implementation
{
CONSTRUCTOR TAusgabe.Create;
BEGIN
  INHERITED Create;
  DemuxerListe := TStringList.Create;
  EncoderListe := TStringList.Create;
  AusgabeListe := TStringList.Create;
  DemuxerListe.Add(WortkeineAusgabe);
  EncoderListe.Add(WortkeineAusgabe);
  AusgabeListe.Add(WortkeineAusgabe);
END;

DESTRUCTOR TAusgabe.Destroy;
BEGIN
  StringListe_loeschen(DemuxerListe);
  DemuxerListe.Free;
  DemuxerListe := NIL;
  StringListe_loeschen(EncoderListe);
  EncoderListe.Free;
  EncoderListe := NIL;
  StringListe_loeschen(AusgabeListe);
  AusgabeListe.Free;
  AusgabeListe := NIL;
  INHERITED Destroy;
END;

CONSTRUCTOR TEffekte.Create;
BEGIN
  INHERITED Create;
  VideoEffekte := TStringList.Create;
  AudioEffekte := TStringList.Create;
  VideoEffekte.Add(WortkeinEffekt);
  AudioEffekte.Add(WortkeinEffekt); 
  Videoeffektvorgaben := TStringList.Create;
  Audioeffektvorgaben := TStringList.Create;
END;

DESTRUCTOR TEffekte.Destroy;
BEGIN
  StringListe_loeschen(VideoEffekte);
  VideoEffekte.Free;
  VideoEffekte := NIL;
  StringListe_loeschen(AudioEffekte);
  AudioEffekte.Free;
  AudioEffekte := NIL;
  StringListe_loeschen(Videoeffektvorgaben);
  Videoeffektvorgaben.Free;
  Videoeffektvorgaben := NIL;
  StringListe_loeschen(Audioeffektvorgaben);
  Audioeffektvorgaben.Free;
  Audioeffektvorgaben := NIL;
  INHERITED Destroy;
END;

FUNCTION Dateilesen(Datei: STRING; VAR DateiVariable: STRING; Liste: TStringList): Integer;

VAR I : Integer;
    HListe,
    Dateiliste : TStringList;

BEGIN
  Result := 0;
  IF (Datei <> DateiVariable) AND
     (Datei <> '') THEN
    IF FileExists(Datei) THEN
    BEGIN
      DateiVariable := Datei;
      Stringliste_loeschen(Liste);
      Liste.Add(WortkeineAusgabe);
      Hliste := NIL;
      Dateiliste := TStringList.Create;
      TRY
        Dateiliste.LoadFromFile(Datei);
        FOR I := 0 TO Dateiliste.Count - 1 DO
        BEGIN
          IF (LeftStr(Dateiliste.Strings[I], 1) = '[') AND
             (RightStr(Dateiliste.Strings[I], 1) = ']') THEN
          BEGIN
            HListe := TStringList.Create;
            Liste.AddObject(Copy(Dateiliste.Strings[I], 2, Length(Dateiliste.Strings[I]) - 2), Hliste);
          END
          ELSE
            IF Assigned(HListe) THEN
              HListe.Add(Dateiliste.Strings[I]);
        END;
      FINALLY
        Dateiliste.Free;
      END;
    END
    ELSE
      Result := -1;
END;

FUNCTION Dateischreiben(Datei: STRING; VAR DateiVariable: STRING; Liste: TStringList): Integer;

VAR I, J : Integer;
    Dateiliste : TStringList;

BEGIN
  Result := 0;
  IF Datei <> '' THEN
  BEGIN
    DateiVariable := Datei;
    IF FileExists(Datei) THEN
      DeleteFile(Datei);
    IF NOT FileExists(Datei) THEN
    BEGIN
      Dateiliste := TStringList.Create;
      TRY
        FOR I := 1 TO Liste.Count -1 DO
        BEGIN
          Dateiliste.Add('[' + Liste.Strings[I] + ']');
          IF Assigned(Liste.Objects[I]) THEN
            FOR J := 0 TO TStringList(Liste.Objects[I]).Count - 1 DO
              Dateiliste.Add(TStringList(Liste.Objects[I]).Strings[J]);
        END;
        Dateiliste.SaveToFile(Datei);
      FINALLY
        Dateiliste.Free;
      END;
    END
    ELSE
      Result := -1;
  END;
END;

FUNCTION TAusgabe.ExterneProgrammeladen(Demuxer, Encoder, Ausgabe: STRING): Integer;

VAR Erg : Integer;

BEGIN
  Result := 0;
//  Result := Dateilesen(Decoder, Decoderdatei, DecoderListe);
  Erg := Dateilesen(Encoder, Encoderdatei, EncoderListe);
  IF Erg < 0 THEN
    Result := Result - 2;
  Erg := Dateilesen(Ausgabe, Ausgabedatei, AusgabeListe);
  IF Erg < 0 THEN
    Result := Result - 4;
END;

FUNCTION TAusgabe.ExterneProgrammespeichern(Demuxer, Encoder, Ausgabe: STRING): Integer;

VAR Erg : Integer;

BEGIN
  Result := 0;
//  Result := Dateischreiben(Decoder, Decoderdatei, DecoderListe);
  Erg := Dateischreiben(Encoder, Encoderdatei, EncoderListe);
  IF Erg < 0 THEN
    Result := Result - 2;
  Erg := Dateischreiben(Ausgabe, Ausgabedatei, AusgabeListe);
  IF Erg < 0 THEN
    Result := Result - 4;
END;

FUNCTION TEffekte.Effekteladen(VideoEffekt, AudioEffekt: STRING): Integer;

VAR Erg : Integer;

BEGIN
  Result := Dateilesen(VideoEffekt, VideoEffektdatei, VideoEffekte);
  Erg := Dateilesen(AudioEffekt, AudioEffektdatei, AudioEffekte);
  IF Erg < 0 THEN
    Result := Result - 2;
END;

FUNCTION TEffekte.Effektespeichern(VideoEffekt, AudioEffekt: STRING): Integer;

VAR Erg : Integer;

BEGIN
  Result := Dateischreiben(VideoEffekt, VideoEffektdatei, VideoEffekte);
  Erg := Dateischreiben(AudioEffekt, AudioEffektdatei, AudioEffekte);
  IF Erg < 0 THEN
    Result := Result - 2;
END;
}
CONSTRUCTOR TProjektInfo.Create;
BEGIN
  INHERITED Create;
  Projektname := 'kein Projekt';
END;

end.
