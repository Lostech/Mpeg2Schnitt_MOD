unit ProjektUnit;

interface

USES Classes, ComCtrls, StdCtrls, Grids, IniFiles, SysUtils, Forms,
     DatenTypen,
     AusgabeDatenTypen,
     DateienUnit,
     SchnittUnit,
     KapitelUnit,
     MarkenUnit,
     AllgFunktionen,
     Sprachen,
     AllgVariablen,
     DateinamenUnit;

FUNCTION ProjektInformationen({Dateiname: STRING;
                              VAR AudioSpuren, SchnittAnzahl: Integer;
                              VAR VideoGroesse, AudioGroesse: Int64;
                              VAR IniDatei, Zielverzeichnis, Zieldateiname,
                              Videoname, AudioTrennzeichen,
                              Ausgabedatei, Effektdatei: STRING;
                              VAR BilderProSek: Real; VAR feste_Bitrate, AusgabeIndex: Integer;
                              VAR Timecodekorrigieren, Bitratekorrigieren,
                              IndexDateierstellen, D2VDateierstellen,
                              KapitelDateierstellen, nurAudioschneiden,
                              Ausgabebenutzen: Boolean; }
                              ProjektInfoObj : TProjektInfo): Integer;
FUNCTION Projektladen(Dateiname: STRING; einfuegen: Boolean = False): Integer;

implementation

FUNCTION ProjektInformationen({Dateiname: STRING;
                              VAR AudioSpuren, SchnittAnzahl: Integer;
                              VAR VideoGroesse, AudioGroesse: Int64;
                              VAR IniDatei, Zielverzeichnis, Zieldateiname,
                              Videoname, AudioTrennzeichen,
                              Ausgabedatei, Effektdatei: STRING;
                              VAR BilderProSek: Real; VAR feste_Bitrate, AusgabeIndex: Integer;
                              VAR Timecodekorrigieren, Bitratekorrigieren,
                              IndexDateierstellen, D2VDateierstellen,
                              KapitelDateierstellen, nurAudioschneiden,
                              Ausgabebenutzen: Boolean;}
                              ProjektInfoObj: TProjektInfo): Integer;

VAR Projektdatei : TIniFile;
    Schleifenende : Boolean;
    I, J : Integer;
//    HString : STRING;

BEGIN
 { Result := 0;
  IF LowerCase(ExtractFileExt(Dateiname)) = '.m2e' THEN
    IF FileExists(Dateiname) THEN
    BEGIN
      Projektdatei := TIniFile.Create(DateiName);
      TRY
        IF Projektdatei.ReadInteger('Allgemein', 'Version', 1) > 2 THEN
          IF Projektdatei.SectionExists('Schnittpunkt-0') THEN
            IF (Projektdatei.SectionExists('Dateiknoten-' +
                Projektdatei.ReadString('Schnittpunkt-0', 'Videoknoten', '1'))) THEN
            BEGIN
              Videoname := Projektdatei.ReadString('Dateiknoten-' +
                           Projektdatei.ReadString('Schnittpunkt-0', 'Videoknoten', '1'), 'Videodatei', '');
              AudioSpuren := 0;
              Schleifenende := False;
              REPEAT
                IF Projektdatei.ValueExists('Dateiknoten-' + Projektdatei.ReadString('Schnittpunkt-0', 'Audioknoten', '1'),
                                            'Audiodatei-' + IntToStr(AudioSpuren + 1)) THEN
                BEGIN
                  IF Videoname = '' THEN
                    Videoname := Projektdatei.ReadString('Dateiknoten-' + Projektdatei.ReadString('Schnittpunkt-0', 'Audioknoten', '1'),
                                                         'Audiodatei-' + IntToStr(AudioSpuren + 1), '');
                  Inc(AudioSpuren);
                END
                ELSE
                  Schleifenende := True;
              UNTIL Schleifenende;
              IF Videoname <> '' THEN
              BEGIN
                SchnittAnzahl := 0;
                Schleifenende := False;
                REPEAT
                  IF Projektdatei.SectionExists('Schnittpunkt-' + IntToStr(SchnittAnzahl)) THEN
                  BEGIN
                    VideoGroesse := Videogroesse + StrToInt64Def(Projektdatei.ReadString('Schnittpunkt-' + IntToStr(SchnittAnzahl), 'VideoGroesse', '0'), 0);
                    AudioGroesse := AudioGroesse + StrToInt64Def(Projektdatei.ReadString('Schnittpunkt-' + IntToStr(SchnittAnzahl), 'AudioGroesse', '0'), 0);
                    Inc(SchnittAnzahl);
                  END
                  ELSE
                    Schleifenende := True;
                UNTIL Schleifenende;
                IniDatei := ProjektDatei.ReadString('Allgemein', 'Ini-Datei', '');
                Zielverzeichnis := Projektdatei.ReadString('Allgemein', 'Zielverzeichnis', '');
                Zieldateiname := Projektdatei.ReadString('Allgemein', 'Zieldateiname', ExtractFileName(ChangeFileExt(Dateiname,'')));
                AudioTrennzeichen := ProjektDatei.ReadString('Allgemein', 'AudioTrennzeichen', '');
                BilderProSek := ProjektDatei.ReadFloat('Schnittpunkt-0', 'Framerate', 25);
                feste_Bitrate := ProjektDatei.ReadInteger('Allgemein', 'feste_Bitrate', 0);
                Timecodekorrigieren := Projektdatei.ReadBool('Allgemein', 'Timecode_korrigieren', True);
                Bitratekorrigieren := Projektdatei.ReadBool('Allgemein', 'Bitrate_korrigieren', True);
                IndexDateierstellen := Projektdatei.ReadBool('Allgemein', 'IndexDateierstellen', True);
                D2VDateierstellen := Projektdatei.ReadBool('Allgemein', 'D2VDateierstellen', False);
                KapitelDateierstellen := Projektdatei.ReadBool('Allgemein', 'Kapiteldateierstellen', False);
                AusgabeIndex := Projektdatei.ReadInteger('Allgemein', 'Ausgabeindex', 0);
                Ausgabebenutzen := Projektdatei.ReadBool('Allgemein', 'Ausgabebenutzen', False);
                nurAudioschneiden := Projektdatei.ReadBool('Allgemein', 'nurAudioschneiden', False);
                Ausgabedatei := ProjektDatei.ReadString('Allgemein', 'Ausgabedatei', '');
                Effektdatei := ProjektDatei.ReadString('Allgemein', 'Effektdatei', '');
              END
              ELSE
                Result := -6;          // keine Video- oder Audiodatei zum ersten Schnitt gefunden
            END
            ELSE
              Result := -5             // keine Dateien im Projekt
          ELSE
            Result := -4               // keine Schnitte im Projekt
        ELSE
          Result := -3;                // ProjektVersion kleiner 3
      FINALLY
        Projektdatei.Free;
      END;
    END
    ELSE
      Result := -2                     // Datei existiert nicht
  ELSE
    Result := -1;      }                // keine Projektdatei
  Result := 0;
  IF LowerCase(ExtractFileExt(ProjektInfoObj.Dateiname)) = '.m2e' THEN
    IF FileExists(ProjektInfoObj.Dateiname) THEN
    BEGIN
      Projektdatei := TIniFile.Create(ProjektInfoObj.DateiName);
      TRY
        IF Projektdatei.ReadInteger('Allgemein', 'Version', 0) > 3 THEN  // Versionen kleiner 4 werden nicht unterstützt
          IF Projektdatei.SectionExists('Schnittpunkt-0') THEN
            IF (Projektdatei.SectionExists('Dateiknoten-' +
                Projektdatei.ReadString('Schnittpunkt-0', 'Videoknoten', '1'))) THEN
            BEGIN
              WITH ProjektInfoObj DO
              BEGIN
                AudioSpuren := 0;
                Schleifenende := False;
                REPEAT                                                          // Audiospuren zählen
                  IF Projektdatei.ValueExists('Dateiknoten-' + Projektdatei.ReadString('Schnittpunkt-0', 'Audioknoten', '1'),
                                              'Audiodatei-' + IntToStr(AudioSpuren + 1)) THEN
                    Inc(AudioSpuren)
                  ELSE
                    Schleifenende := True;
                UNTIL Schleifenende;
                SchnittAnzahl := 0;
                Schleifenende := False;
                REPEAT
                  IF Projektdatei.SectionExists('Schnittpunkt-' + IntToStr(SchnittAnzahl)) THEN
                  BEGIN
                    VideoGroesse := Videogroesse + StrToInt64Def(Projektdatei.ReadString('Schnittpunkt-' + IntToStr(SchnittAnzahl), 'VideoGroesse', '0'), 0);
                    AudioGroesse := AudioGroesse + StrToInt64Def(Projektdatei.ReadString('Schnittpunkt-' + IntToStr(SchnittAnzahl), 'AudioGroesse', '0'), 0);
                    Inc(SchnittAnzahl);
                  END
                  ELSE
                    Schleifenende := True;
                UNTIL Schleifenende;
                Videoname := '';
                I := 0;
                Schleifenende := False;
                WHILE (I < SchnittAnzahl) AND (NOT Schleifenende) DO            // ersten Videonamen suchen
                BEGIN
                  Videoname := Projektdatei.ReadString('Dateiknoten-' +
                               Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'Videoknoten', '1'),
                                                       'Videodatei', '');
                  IF Videoname <> '' THEN
                    Schleifenende := True;
                  Inc(I);
                END;
                IF Videoname = '' THEN
                BEGIN
                  I := 0;
                  Schleifenende := False;
                  WHILE (I < SchnittAnzahl) AND (NOT Schleifenende) DO          // ersten Audionamen suchen
                  BEGIN
                    J := 0;
                    WHILE (J < AudioSpuren) AND (NOT Schleifenende) DO
                    BEGIN
                      Videoname := Projektdatei.ReadString('Dateiknoten-' +
                                   Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'Audioknoten', '1'),
                                                           'Audiodatei-' + IntToStr(J + 1), '');
                      IF Videoname <> '' THEN
                        Schleifenende := True;
                      Inc(J);
                    END;
                    Inc(I);
                  END;
                END;
                IF Videoname <> '' THEN
                BEGIN
                  IniDatei := ProjektDatei.ReadString('Allgemein', 'Ini-Datei', '');
       {           HString := VariablenersetzenText(absolutPathAppl(HString, Application.ExeName, False),
                                                  ['$Videodirectory#', ExtractFileDir(Videoname),
                                                   '$Projectdirectory#', ExtractFileDir(DateiName)]);
                  HString := VariablenentfernenText(HString);
                  IF HString = '' THEN
                    HString := ExtractFilePath(Videoname);
                  Zieldateiname := mitPathtrennzeichen(HString);  }
       {           HString := VariablenersetzenText(HString,
                                                  ['$Videoname#', ExtractFileName(ChangeFileExt(Videoname, '')),
                                                   '$Projectname#', ExtractFileName(ChangeFileExt(DateiName, ''))]);
                  HString   := VariablenentfernenText(HString);
                  IF HString = '' THEN
                    HString := ExtractFileName(ChangeFileExt(DateiName, ''));
                  Zieldateiname := Zieldateiname + HString;   }
                  AudioTrennzeichen := ProjektDatei.ReadString('Allgemein', 'AudioTrennzeichen', '');
                  BilderProSek := ProjektDatei.ReadFloat('Schnittpunkt-0', 'Framerate', 25);
                  BitrateersterHeader := ProjektDatei.ReadInteger('Allgemein', 'BitrateersterHeader', 0);
                  festeBitrate := ProjektDatei.ReadInteger('Allgemein', 'feste_Bitrate', 0);
                  AspectratioersterHeader := ProjektDatei.ReadInteger('Allgemein', 'AspectratioersterHeader', 0);
                  AspectratioOffset := ProjektDatei.ReadInteger('Allgemein', 'AspectratioOffset', 0);
//                  maxGOPLaenge := ProjektDatei.ReadInteger('Allgemein', 'maxGOPLaenge', 0);
                  maxGOPLaengeverwenden := ProjektDatei.ReadBool('Allgemein', 'maxGOPLaenge_verwenden', False);
                  Timecodekorrigieren := Projektdatei.ReadBool('Allgemein', 'Timecode_korrigieren', True);
                  Bitratekorrigieren := Projektdatei.ReadBool('Allgemein', 'Bitrate_korrigieren', False);
                  IndexDateierstellen := Projektdatei.ReadBool('Allgemein', 'IndexDateierstellen', True);
                  D2VDateierstellen := Projektdatei.ReadBool('Allgemein', 'D2VDateierstellen', False);
                  IDXDateierstellen := Projektdatei.ReadBool('Allgemein', 'IDXDateierstellen', False);
                  KapitelDateierstellen := Projektdatei.ReadBool('Allgemein', 'Kapiteldateierstellen', False);
                  Ausgabebenutzen := Projektdatei.ReadBool('Allgemein', 'Ausgabebenutzen', False);
                  Schnittpunkteeinzelnschneiden := Projektdatei.ReadBool('Allgemein', 'Schnittpunkteeinzelnschneiden', False);
                  nurAudioschneiden := Projektdatei.ReadBool('Allgemein', 'nurAudioschneiden', False);
                  Framegenauschneiden := Projektdatei.ReadBool('Allgemein', 'Framegenauschneiden', False);
                  Ausgabedatei := absolutPathAppl(ProjektDatei.ReadString('Allgemein', 'Ausgabedatei', ''), Application.ExeName, False);
                  Encoderdatei := absolutPathAppl(ProjektDatei.ReadString('Allgemein', 'Encoderdatei', ''), Application.ExeName, False);
//                  VideoEffektdatei := absolutPathAppl(ProjektDatei.ReadString('Allgemein', 'Videoeffektdatei', ''), Application.ExeName, False);
//                  AudioEffektdatei := absolutPathAppl(ProjektDatei.ReadString('Allgemein', 'Audioeffektdatei', ''), Application.ExeName, False);
                  Zieldateiname := mitPathtrennzeichen(Verzeichnisnamenbilden(absolutPathAppl(Projektdatei.ReadString('Allgemein', 'Zielverzeichnis', ''), Application.ExeName, False),
                                                                              Videoname, Dateiname, Projektname));
                  Zieldateiname := Zieldateiname + Dateinamenbilden(Projektdatei.ReadString('Allgemein', 'Zieldateiname', ExtractFileName(ChangeFileExt(Dateiname,''))),
                                                                    Videoname, Dateiname, Projektname, Schnittpunkteeinzelnschneiden);
                END
                ELSE
                  Result := -6;        // keine Video- oder Audiodatei zum ersten Schnitt gefunden
              END;
            END
            ELSE
              Result := -5             // keine Dateien im Projekt
          ELSE
            Result := -4               // keine Schnitte im Projekt
        ELSE
          Result := -3;                // ProjektVersion kleiner 3
      FINALLY
        Projektdatei.Free;
      END;
    END
    ELSE
      Result := -2                     // Datei existiert nicht
  ELSE
    Result := -1;                      // keine Projektdatei
END;

FUNCTION Projektladen(Dateiname: STRING; einfuegen: Boolean = False): Integer;

VAR Projektdatei : TIniFile;
    I, J,
    Kapitel,
//    aktVideoIndex,
//    aktAudioIndex,
//    aktPosition,
    Audiooffset : Integer;
    aktEintrag : STRING;
    Schnittpunkt : TSchnittpunkt;
    KapitelEintrag : TKapitelEintrag;
    Knotenpunkt,
    Videoknoten,
    Audioknoten : TTreeNode;
    Knotenliste : TList;
    HString : STRING;
    SchleifenEnde1,
    SchleifenEnde2 : Boolean;
//    Schnittselektiert : Boolean;

BEGIN
//einfuegen := True;
  // Projektdateiversion 3 wurde mit der Programmversion 0.6m im September 2004 eingeführt
  // Projektdateiversion 4 wurde mit dem framegenauem Schnitt und Videoeffekten im Dezember 2006 eingeführt
  Result := 0;
  IF LowerCase(ExtractFileExt(Dateiname)) = '.m2e' THEN
    IF FileExists(Dateiname) THEN
  BEGIN
    Projektdatei := TIniFile.Create(Dateiname);
    Knotenliste := TList.Create;
    TRY
      Knotenliste.Add(NIL);
      IF Projektdatei.ReadInteger('Allgemein', 'Version', 0) > 3 THEN  // Versionen kleiner 4 werden nicht unterstützt
      BEGIN
          aktEintrag := '';
//          aktVideoIndex := Projektdatei.ReadInteger('Allgemein', 'aktVideoknoten', 0);
//          aktAudioIndex := Projektdatei.ReadInteger('Allgemein', 'aktAudioknoten', 0);
//          aktPosition := IniFile.ReadInteger('Allgemein', 'aktSchiebereglerPosition', 50);
        I := 1;
        REPEAT                                               // Dateienliste auslesen
          Knotenpunkt := NIL;
          IF Projektdatei.SectionExists('Dateiknoten-' + IntToStr(I)) THEN
          BEGIN
            SchleifenEnde1 := False;
            IF Projektdatei.ValueExists('Dateiknoten-' + IntToStr(I), 'Videodatei') THEN
            BEGIN
              HString := Projektdatei.ReadString('Dateiknoten-' + IntToStr(I), 'Videodatei', '');
              IF (HString = '') OR FileExists(HString) THEN  // Videodatei existiert oder Knoten ist leer
                Knotenpunkt := DateienUnit.VideoEintrageinfuegen(NIL, HString,
                                                                 Projektdatei.ReadString('Dateiknoten-' + IntToStr(I), 'Videoname', ''))
              ELSE
                Result := -20;                               // Videodatei existiert nicht
            END;
            J := 1;
            REPEAT
              IF Projektdatei.ValueExists('Dateiknoten-' + IntToStr(I), 'Audiodatei-' + IntToStr(J)) THEN
              BEGIN
                SchleifenEnde2 := False;
                HString := Projektdatei.ReadString('Dateiknoten-' + IntToStr(I), 'Audiodatei-' + IntToStr(J), '');
                Audiooffset := Projektdatei.ReadInteger('Dateiknoten-' + IntToStr(I), 'Audiooffset-' + IntToStr(J), 0);
                IF (HString = '') OR FileExists(HString) THEN // Audiodatei existiert oder Knoten ist leer
                  IF einfuegen THEN
                    Knotenpunkt := DateienUnit.AudioEintrageinfuegen(Knotenpunkt, HString, Audiooffset, -1,
                                                                     Projektdatei.ReadString('Dateiknoten-' + IntToStr(I), 'Audioname-' + IntToStr(J), ''))
                  ELSE
                    Knotenpunkt := DateienUnit.AudioEintrageinfuegen(Knotenpunkt, HString, Audiooffset, J,
                                                                     Projektdatei.ReadString('Dateiknoten-' + IntToStr(I), 'Audioname-' + IntToStr(J), ''))
                ELSE
                  Result := 20;                              // Audiodatei existiert nicht
                Inc(J);
              END
              ELSE
                SchleifenEnde2 := True;
            UNTIL SchleifenEnde2;
            IF NOT Assigned(Knotenpunkt) THEN
              Result := -20;                                 // Knoten wurde nicht angelegt
            Knotenpunkt := DateienUnit.Knotennameaendern(Knotenpunkt, Projektdatei.ReadString('Dateiknoten-' + IntToStr(I), 'Knotenname', ''), True);
            IF einfuegen THEN
              Knotenpunkt := GleichenKnotensuchen(Knotenpunkt);
//              IF (I * 1000 = aktVideoIndex) AND Knotenpunkt.HasChildren THEN
//                aktVideoknoten := Knotenpunkt.Item[0];              ????????????????????
//              IF (I = aktAudioIndex DIV 1000) AND aktDateien_anzeigen AND
//                 (aktAudioIndex Mod 1000 < Knotenpunkt.Count) THEN
//                aktAudioknoten := Knotenpunkt.Item[aktAudioIndex Mod 1000]; ????????????
            Knotenliste.Add(Knotenpunkt);
            Inc(I);
          END
          ELSE
            SchleifenEnde1 := True;
        UNTIL SchleifenEnde1;
        I := 0;
        REPEAT
          IF Projektdatei.SectionExists('Schnittpunkt-' + IntToStr(I)) THEN
          BEGIN
            SchleifenEnde1 := False;
            HString := Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'Schnittpunktname', '');
            J := Projektdatei.ReadInteger('Schnittpunkt-' + IntToStr(I), 'Videoknoten', 0);
            IF J < Knotenliste.Count THEN
              Videoknoten := Knotenliste.Items[J]
            ELSE
              Videoknoten := NIL;
            J := Projektdatei.ReadInteger('Schnittpunkt-' + IntToStr(I), 'Audioknoten', 0);
            IF J < Knotenliste.Count THEN
              Audioknoten := Knotenliste.Items[J]
            ELSE
              Audioknoten := NIL;
            IF Assigned(Videoknoten) OR Assigned(Audioknoten)  THEN
            BEGIN
              Schnittpunkt := TSchnittpunkt.Create;
              Schnittpunkt.Videoknoten := Videoknoten;
              Schnittpunkt.Audioknoten := Audioknoten;
              Schnittpunkt.Anfang := Projektdatei.ReadInteger('Schnittpunkt-' + IntToStr(I), 'Anfang', 0);;
              Schnittpunkt.Ende := Projektdatei.ReadInteger('Schnittpunkt-' + IntToStr(I), 'Ende', 0);;
              Schnittpunkt.Anfangberechnen := Projektdatei.ReadInteger('Schnittpunkt-' + IntToStr(I), 'Anfangberechnen', 0);
              Schnittpunkt.Endeberechnen := Projektdatei.ReadInteger('Schnittpunkt-' + IntToStr(I), 'Endeberechnen', 0);
              Schnittpunkt.VideoGroesse := StrToInt64Def(Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoGroesse', '0'), 0);
              Schnittpunkt.AudioGroesse := StrToInt64Def(Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioGroesse', '0'), 0);
              Schnittpunkt.Framerate := Projektdatei.ReadFloat('Schnittpunkt-' + IntToStr(I), 'Framerate', 25);
              Schnittpunkt.VideoEffekt.AnfangEffektName := Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoAnfangEffekt', '');
              Schnittpunkt.VideoEffekt.AnfangEffektDateiname := absolutPathAppl(Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoAnfangEffektdatei', ''), Application.ExeName, False);
              Schnittpunkt.VideoEffekt.AnfangLaenge := Projektdatei.ReadInteger('Schnittpunkt-' + IntToStr(I), 'VideoAnfangLaenge', 0);
              Schnittpunkt.VideoEffekt.AnfangEffektParameter := Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoAnfangParameter', '');
              Schnittpunkt.VideoEffekt.EndeEffektName := Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoEndeEffekt', '');
              Schnittpunkt.VideoEffekt.EndeEffektDateiname := absolutPathAppl(Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoEndeEffektdatei', ''), Application.ExeName, False);
              Schnittpunkt.VideoEffekt.EndeLaenge := Projektdatei.ReadInteger('Schnittpunkt-' + IntToStr(I), 'VideoEndeLaenge', 0);
              Schnittpunkt.VideoEffekt.EndeEffektParameter := Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'VideoEndeParameter', '');
              Schnittpunkt.AudioEffekt.AnfangEffektName := Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioAnfangEffekt', '');
              Schnittpunkt.AudioEffekt.AnfangEffektDateiname := absolutPathAppl(Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioAnfangEffektdatei', ''), Application.ExeName, False);
              Schnittpunkt.AudioEffekt.AnfangLaenge := Projektdatei.ReadInteger('Schnittpunkt-' + IntToStr(I), 'AudioAnfangLaenge', 0);
              Schnittpunkt.AudioEffekt.AnfangEffektParameter := Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioAnfangParameter', '');
              Schnittpunkt.AudioEffekt.EndeEffektName := Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioEndeEffekt', '');
              Schnittpunkt.AudioEffekt.EndeEffektDateiname := absolutPathAppl(Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioEndeEffektdatei', ''), Application.ExeName, False);
              Schnittpunkt.AudioEffekt.EndeLaenge := Projektdatei.ReadInteger('Schnittpunkt-' + IntToStr(I), 'AudioEndeLaenge', 0);
              Schnittpunkt.AudioEffekt.EndeEffektParameter := Projektdatei.ReadString('Schnittpunkt-' + IntToStr(I), 'AudioEndeParameter', '');
              IF einfuegen THEN
                SchnittUnit.Schnitteinfuegen(Schnittpunkt, '', ArbeitsumgebungObj.Schnittpunkteinfuegen)
              ELSE
                SchnittUnit.Schnitteinfuegen(Schnittpunkt, '', 2);
            END
            ELSE
              Result := -20;                           // kein zugehöriger Dateilisteneintrag
            Inc(I);
          END
          ELSE
            SchleifenEnde1 := True;
        UNTIL SchleifenEnde1;
        I := 1;
        REPEAT
          IF Projektdatei.SectionExists('Kapitel-' + IntToStr(I)) THEN
          BEGIN
            SchleifenEnde1 := False;
            HString := Projektdatei.ReadString('Kapitel-' + IntToStr(I), 'Kapitelname', '');
            J := Projektdatei.ReadInteger('Kapitel-' + IntToStr(I), 'Videoknoten', 0);
            IF J < Knotenliste.Count THEN
              Videoknoten := Knotenliste.Items[J]
            ELSE
              Videoknoten := NIL;
            J := Projektdatei.ReadInteger('Kapitel-' + IntToStr(I), 'Audioknoten', 0);
            IF J < Knotenliste.Count THEN
              Audioknoten := Knotenliste.Items[J]
            ELSE
              Audioknoten := NIL;
            Kapitel := Projektdatei.ReadInteger('Kapitel-' + IntToStr(I), 'Kapitelposition', -1);
            IF Kapitel > -1 THEN
              IF Assigned(Videoknoten) OR Assigned(Audioknoten) THEN
              BEGIN
                KapitelEintrag := TKapitelEintrag.Create;
                KapitelEintrag.Kapitel := Kapitel;
                KapitelEintrag.Videoknoten := VideoKnoten;
                KapitelEintrag.Audioknoten := AudioKnoten;
                KapitelEintrag.BilderproSek := Projektdatei.ReadFloat('Kapitel-' + IntToStr(I), 'Framerate', 25);
                IF einfuegen THEN
                  KapitelUnit.Kapiteleinfuegen(KapitelEintrag, HString, ArbeitsumgebungObj.Kapiteleinfuegen)
                ELSE
                  KapitelUnit.Kapiteleinfuegen(KapitelEintrag, HString, 2);
              END
              ELSE
                Result := -20                          // kein zugehöriger Dateilisteneintrag
            ELSE
              IF einfuegen THEN
                KapitelUnit.Kapiteleinfuegen(NIL, HString, ArbeitsumgebungObj.Kapiteleinfuegen)
              ELSE
                KapitelUnit.Kapiteleinfuegen(NIL, HString, 2);
            Inc(I);
          END
          ELSE
            SchleifenEnde1 := True;
        UNTIL SchleifenEnde1;
        I := 0;
        REPEAT
          IF Projektdatei.SectionExists('Marke-' + IntToStr(I)) THEN
          BEGIN
            SchleifenEnde1 := False;
            HString := Projektdatei.ReadString('Marke-' + IntToStr(I), 'Markenzeile', 'letzter');
            IF einfuegen THEN
              MarkenUnit.Zeileeinfuegen(HString, ArbeitsumgebungObj.Markeneinfuegen)
            ELSE
              MarkenUnit.Zeileeinfuegen(HString, 2);
            Inc(I);
          END
          ELSE
            SchleifenEnde1 := True;
        UNTIL SchleifenEnde1;
      END;
    FINALLY
      Projektdatei.Free;
      Knotenliste.Free;
    END;
  END
  ELSE
    Result := -1;
END;

end.
