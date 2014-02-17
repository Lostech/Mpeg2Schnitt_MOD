unit AusgabeUnit;

interface

USES Forms, Classes, SysUtils,
     DatenTypen,
     AusgabeDatenTypen,
     AllgFunktionen,
     AllgVariablen,
     KapitelUnit,
     ScriptUnit;

FUNCTION Ausgabe(Projektname: STRING; AusgabeListe,  SchnittListe: TStrings; ProjektInfoObj: TProjektInfo): Integer;

implementation

// startet ein externes Programm zur Ausgabe (Muxen) mit Parameterübergabe
//     3 : nur Video- oder Audiodatei(en) vorhanden
//     2 : Ausgabeliste ist leer
//     1 : Ausgabedatei ist leer --> keine Ausgabe
//     0 : Ok
//    -1 : Ausgabedatei existiert nicht
//    -2 : keine Ausgabeliste übergeben
//    -3 : keine Schnittliste übergeben
//ab -11 : Fehler in der Funktion Kapitelberechnen
//ab -21 : Fehler in der Funktion Scripstarten
FUNCTION Ausgabe(Projektname: STRING; AusgabeListe, SchnittListe: TStrings; ProjektInfoObj: TProjektInfo): Integer;

VAR I : Integer;
    BerechneteListe : TStringList;
    Variablen : TStringList;
    HString,
    Ausgabedatei : STRING;

BEGIN
  IF Assigned(ProjektInfoObj) THEN
    Ausgabedatei := ProjektInfoObj.Ausgabedatei
  ELSE
    Ausgabedatei := ArbeitsumgebungObj.Ausgabedatei;
  IF Ausgabedatei <> '' THEN
    IF FileExists(Ausgabedatei) THEN
      IF Assigned(AusgabeListe) THEN
        IF AusgabeListe.Count > 0 THEN
          IF Assigned(SchnittListe) THEN
          BEGIN
            Variablen := TStringList.Create;
            TRY
              I := 0;
              WHILE I < AusgabeListe.Count DO                     // Variablen mit Video- und Audiodaten füllen
              BEGIN
                Variablen.Add('$' + KopiereVonBis(AusgabeListe.Strings[I], '', '=', False, False) + '#');
                Variablen.Add(KopiereVonBis(AusgabeListe.Strings[I], '=', '', False, False));
                Inc(I);
              END;
              IF (Variablen.Count > 3) AND (LowerCase(Variablen[0]) = '$videofile#') THEN
              BEGIN
                BerechneteListe := TStringList.Create;
                TRY
                  Result := KapitelUnit.Kapitelberechnen(-1, -1, SchnittListe, BerechneteListe);
                  IF Result > -1 THEN
                  BEGIN
                    I := 0;
                    WHILE I < BerechneteListe.Count DO              // Variablen mit Kapiteldaten füllen
                    BEGIN
                      Variablen.Add('$Chapter' + IntToStr(I + 1) + '#');
                      Variablen.Add(BerechneteListe.Strings[I]);
                      Inc(I);
                    END;
                  END
                  ELSE
                    Result := Result - 10;
                FINALLY
                  BerechneteListe.Free;
                END;
                HString := KopiereVonBis(AusgabeListe.Strings[0], '=', '', False, False);
                Variablen.Add('$VideoName#');
                Variablen.Add(ChangeFileExt(ExtractfileName(HString), ''));
                Variablen.Add('$VideoDirectory#');
                Variablen.Add(ExtractFileDir(HString));
                Variablen.Add('$ProjectName#');
                IF Projektname = '' THEN
                  Variablen.Add(Variablen.Strings[Variablen.Count - 4])
                ELSE
                  Variablen.Add(ChangeFileExt(ExtractfileName(Projektname), ''));
                Variablen.Add('$ProjectDirectory#');
                IF Projektname = '' THEN
                  Variablen.Add(Variablen.Strings[Variablen.Count - 4])
                ELSE
                  Variablen.Add(ExtractFileDir(Projektname));
                Variablen.Add('$TempDirectory#');
                Variablen.Add(ohnePathtrennzeichen(ArbeitsumgebungObj.Zwischenverzeichnis));
                Variablen.Add('$ProgramDirectory#');
                Variablen.Add(ExtractFileDir(Application.ExeName));
                Variablen.Add('$FramesPerSec#');
                IF Assigned(ProjektInfoObj) THEN
                  Variablen.Add(FloatToStr(ProjektInfoObj.BilderProSek))
                ELSE
                  IF SchnittListe.Count > 0 THEN
                    Variablen.Add(FloatToStr(TSchnittpunkt(Schnittliste.Objects[0]).Framerate))
                  ELSE
                    Variablen.Add('25');
                ScriptUnit.KopiereQuelldateiteil := NIL;
                Result := ScriptUnit.Scriptstarten(Ausgabedatei, Variablen);
                IF Result < 0 THEN
                  Result := Result - 20;
              END
              ELSE
                Result := 3;
            FINALLY
              Variablen.Free;
            END;
          END
          ELSE
            Result := -5
        ELSE
          Result := 2
      ELSE
        Result := -4
    ELSE
      Result := -1
  ELSE
    Result := 1;
END;

end.
