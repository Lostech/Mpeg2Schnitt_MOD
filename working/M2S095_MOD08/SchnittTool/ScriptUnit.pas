unit ScriptUnit;

interface

USES Forms, Classes, SysUtils, Controls, StrUtils,
     AllgFunktionen,
     AllgVariablen,
     ProtokollUnit;

TYPE TKopiereQuelldateiteil = FUNCTION(Variablen: TStrings; Anfangoffset: Integer = 0; Endeoffset: Integer = 0): Integer OF OBJECT;

FUNCTION Scriptstarten(Ausgabescript: TStrings; Variablen: TStrings; Scriptname: STRING = ''; Marke: STRING = ':all'; pruefen: Boolean = False): Integer; OVERLOAD;
FUNCTION Scriptstarten(Ausgabedatei: STRING; Variablen: TStrings; Scriptname: STRING = ''; Marke: STRING = ':all'; pruefen: Boolean = False): Integer; OVERLOAD;
FUNCTION Scriptpruefen(Ausgabescript: TStrings; Variablen: TStrings; Scriptname: STRING = ''; Marke: STRING = ':all'): Integer; OVERLOAD;
FUNCTION Scriptpruefen(Ausgabedatei: STRING; Variablen: TStrings; Scriptname: STRING = ''; Marke: STRING = ':all'): Integer; OVERLOAD;

VAR AnzeigeListe : TStringList;
    KopiereQuelldateiteil : TKopiereQuelldateiteil;

implementation

// führt ein Script aus
//        0 : Ok
//       -1 : kein Ausgabescript (TStringList) übergeben, keine Variablen übergeben
// -2 .. -4 : Fehler in der Funktion Datei kopieren
//   -5, -6 : Fehler in der Funktion VariablenersetzenDatei
//   -7, -8 : Fehler in Run
//   ab -21 : Fehler im aufgerufenen Script                                     //aus Mangel an Rückgabenummern deaktiviert
FUNCTION Scriptstarten(Ausgabescript: TStrings; Variablen: TStrings; Scriptname: STRING = ''; Marke: STRING = ':all'; pruefen: Boolean = False): Integer; OVERLOAD;

VAR I : Integer;
    nichtpruefen : Boolean;
    HString,
    HString2,
    HString3,
    Zeile : STRING;
    HReal : Real;

FUNCTION Run(Zeile: STRING; warten: Boolean = True; anzeigen: Boolean = True): Integer;

VAR Programm,
    Parameter,
    aktVerzeichnis : STRING;
    Anzeige : TStringList;

BEGIN
  Result := 0;
  IF Zeile <> '' THEN
  BEGIN
    IF NOT (nichtpruefen AND pruefen) THEN
    BEGIN
      Programm := absolutPathAppl(KopiereParameter(Zeile, 1), Application.ExeName, False);
      Parameter := KopiereParameter(Zeile, 2, True);
      IF FileExists(Programm) THEN
      BEGIN
        IF NOT pruefen THEN
        BEGIN
          Screen.Cursor := crAppStart;
          aktVerzeichnis := GetCurrentDir;
          SetCurrentDir(ExtractFilePath(Programm));
          IF anzeigen THEN
            Anzeige := AnzeigeListe
          ELSE
            Anzeige := NIL;
          IF Unterprogramm_starten('"' + Programm + '" ' + Parameter, warten, Anzeige) THEN
          ELSE
            Result := -2;
          SetCurrentDir(aktVerzeichnis);
          Screen.Cursor := crDefault;
        END;
      END
      ELSE
      BEGIN
        Result := -2;
        Fehlertext := Programm;
      END;
    END;
  END
  ELSE
    Result := -1;
END;

FUNCTION SetVar(Zeile: STRING): Integer;

VAR Position : Integer;

BEGIN
  Result := 0;
  Position := PosX([' ', '='], Zeile, 1, False, False);                         // nächtes leerzeichen oder = suchen
  IF Position > 0 THEN
  BEGIN
    IF Zeile[Position] = ' ' THEN                                               // Leerzeichen gefunden
    BEGIN
      Position := PosX([' '], Zeile, Position, False, True);                    // Leerzeichen überspringen
        IF Zeile[Position] <> '=' THEN
          Position := 0;                                                        // kein = gefunden -> keine Variablenzuweisung
    END;
  END;
  IF Position > 0 THEN
  BEGIN
    IF NOT pruefen THEN
      Result := VariablenausText(Zeile, '=', ';', Variablen);
  END
  ELSE
    Result := -1;
END;

BEGIN
  IF Assigned(Ausgabescript) AND
     Assigned(Variablen) THEN
  BEGIN
    Result := 0;
    Scriptname := '[' + LowerCase(Scriptname) + ']';
    Marke := LowerCase(Marke);
    I := 0;
    WHILE (Result > -1) AND (I < Ausgabescript.Count) DO
    BEGIN
      IF Trim(Ausgabescript.Strings[I]) <> '' THEN                              // Leerzeilen überspringen
      BEGIN
        nichtpruefen := False;
        IF Pos('[', Trim(Ausgabescript.Strings[I])) = 1 THEN
          HString := LowerCase(Trim(Ausgabescript.Strings[I]))
        ELSE
          HString := LowerCase(KopiereVonBis(Trim(Ausgabescript.Strings[I]), '', ' ', False, False));
        IF HString = 'nocheck' THEN
        BEGIN
          nichtpruefen := True;
          HString := Trim(Copy(Ausgabescript.Strings[I], 9, Length(Ausgabescript.Strings[I]) - 8));
          Zeile := Trim(KopiereVonBis(HString, '', '//', False, False));
          HString := LowerCase(KopiereVonBis(HString, '', ' ', False, False));
        END
        ELSE
          Zeile := Trim(KopiereVonBis(Ausgabescript.Strings[I], '', '//', False, False));
        Zeile := VariablenersetzenText(Zeile, Variablen);
        Zeile := VariablenentfernenText(Zeile);
        IF Pos('[', HString) = 1 THEN
        BEGIN                                                                   // Scriptname gefunden
          IF (Scriptname <> '[]') AND                                           // Scriptname übergeben
             (Scriptname <> HString) THEN                                       // falscher Scriptname
          BEGIN
            REPEAT
              Inc(I);
              IF I < Ausgabescript.Count THEN
                HString := Trim(Ausgabescript.Strings[I]);
            UNTIL (I = Ausgabescript.Count) OR                                  // Dateiende
                  (Pos('[', HString) = 1);                                      // Bereich bis zum nächsten Scriptnamen überspringen
            Dec(I);
          END
          ELSE
            SetVar('Scriptname=' + Copy(Zeile, 2, Length(Zeile) - 2));
        END
        ELSE
        IF Pos(':', HString) = 1 THEN
        BEGIN                                                                   // Marke gefunden
          IF (Marke <> ':all') AND                                              // alles ausführen
             (Marke <> HString) AND                                             // passender Bereich
             (HString <> ':all') THEN                                           // All Bereich
          BEGIN
            REPEAT
              Inc(I);
              IF I < Ausgabescript.Count THEN
                HString := Trim(Ausgabescript.Strings[I]);
            UNTIL (I = Ausgabescript.Count) OR                                  // Dateiende
                  (Pos('[', HString) = 1) OR                                    // neuer Scriptabschnitt
                  (Pos(':', HString) = 1);                                      // Bereich bis zur nächsten Marke überspringen
            Dec(I);
          END;
        END
        ELSE
        IF HString = 'cpsourcefile' THEN                                        // Quelldatei(teil) kopieren
        BEGIN                                                                   // copy source file
          IF NOT pruefen THEN
          BEGIN
            IF Assigned(KopiereQuelldateiteil) THEN
              Result := KopiereQuelldateiteil(Variablen,
                                              StrToIntDef(KopiereParameter(Zeile, 2), 0),
                                              StrToIntDef(KopiereParameter(Zeile, 3), 0))
            ELSE
              Result := -1;
            IF Result < 0 THEN
              Result := Result - 1;  // entspricht -2, -3, -4
          END;
        END
        ELSE
        IF HString = 'copyx' THEN                                               // Textdatei kopieren und Variablen ersetzen
        BEGIN
          HString  := absolutPathAppl(KopiereParameter(Zeile, 2), Application.ExeName, False);
          HString2 := absolutPathAppl(KopiereParameter(Zeile, 3), Application.ExeName, False);
          IF pruefen THEN
          BEGIN
            IF NOT nichtpruefen THEN
              IF NOT FileExists(HString) THEN
              BEGIN
                Result := -6;
                Fehlertext := HString;
              END;
          END
          ELSE
          BEGIN
            HReal := StrToFloatDef(VariablenersetzenText('$FramesPerSec#', Variablen), 25);
            Result := VariablenersetzenDatei(HString, HString2, Variablen, '', '', HReal);
            IF Result < 0 THEN
              Result := Result - 4   // entspricht -5, -6
            ELSE
              VariablenentfernenDatei(HString2);
          END;
        END
        ELSE
        IF HString = 'run' THEN                                                 // Programm starten
        BEGIN
          HString := Copy(Zeile, 5, Length(Zeile) - 4);
          Result := Run(HString);
          IF Result < 0 THEN
            Result := Result - 6;  // entspricht -7, -8
        END
        ELSE
        IF HString = 'runnotwait' THEN                                          // Programm starten und nicht warten
        BEGIN
          HString := Copy(Zeile, 12, Length(Zeile) - 11);
          Result := Run(HString, False, False);                                 // nicht warten und deshalb auch keine Anzeige
          IF Result < 0 THEN
            Result := Result - 6;  // entspricht -7, -8
        END
        ELSE
        IF HString = 'runnotcml' THEN                                           // Programm starten, Kommandozeilenanzeige nicht übernehmen
        BEGIN
          HString := Copy(Zeile, 11, Length(Zeile) - 10);
          Result := Run(HString, True, False);                                  // warten, keine Kommandozeile
          IF Result < 0 THEN
            Result := Result - 6;  // entspricht -7, -8
        END
        ELSE
        IF HString = 'cmd' THEN                                                 // der Befehlszeileninterpreter wird dem Programm vorrangestellt
        BEGIN
          HString := Copy(Zeile, 5, Length(Zeile) - 4);
          Result := Run(GetEnvironmentVariable('COMSPEC') + ' /c ' + HString);
          IF Result < 0 THEN
            Result := Result - 6;  // entspricht -7, -8
        END
        ELSE
        IF HString = 'call' THEN                                                // ruft ein weiteres Script auf
        BEGIN
          HString := absolutPathAppl(KopiereParameter(Zeile, 2), Application.ExeName, False);  // Scriptdateiname
          HString2 := KopiereParameter(Zeile, 3);
          IF Pos(':', HString2) = 1 THEN
          BEGIN
            HString3 := HString2;
            HString2 := KopiereParameter(Zeile, 4);
          END
          ELSE
            HString3 := KopiereParameter(Zeile, 4);
          IF HString3 = '' THEN
            HString3 := ':all';
          Result := Scriptstarten(HString, Variablen, HString2, HString3, pruefen);
//          IF Result < 0 THEN                                                    //aus Mangel an Rückgabenummern deaktiviert
//            Result := Result - 20;
        END
        ELSE
        IF HString = 'echo' THEN                                                // Textausgabe
        BEGIN
          IF NOT pruefen THEN
          BEGIN
            HString := Copy(Zeile, 6, Length(Zeile) - 5);
            ProtokollUnit.Protokoll_schreiben(HString, 2);
          END;
        END
        ELSE
        IF (HString = 'rem') OR
           (HString = '//') THEN                                                // Kommentar
        ELSE
        IF HString = 'set' THEN                                                 // Variable zuweisen
        BEGIN
          HString := Copy(Zeile, 5, Length(Zeile) - 4);
          SetVar(HString);
        END
        ELSE
        IF SetVar(Zeile) = 0 THEN                                               // Variable zuweisen
        ELSE                                                                    // Programm starten
        BEGIN
          Result := Run(Zeile);
          IF Result < 0 THEN
            Result := Result - 6;  // entspricht -7, -8
        END;
      END;
      Inc(I);
    END;
  END
  ELSE
    Result := -1;
END;

// startet ein Script aus einer Datei
//        0 : Ok
// -1 .. -8 : Fehler in Scriptstarten
//      -10 : Datei existiert nicht
FUNCTION Scriptstarten(Ausgabedatei: STRING; Variablen: TStrings; Scriptname: STRING = ''; Marke: STRING = ':all'; pruefen: Boolean = False): Integer; OVERLOAD;

VAR AusgabeListe : TStringlist;

BEGIN
  IF FileExists(Ausgabedatei) THEN
  BEGIN
    AusgabeListe := TStringlist.Create;
    TRY
      AusgabeListe.LoadFromFile(Ausgabedatei);
      Result := Scriptstarten(AusgabeListe, Variablen, Scriptname, Marke, pruefen);
    FINALLY
      AusgabeListe.Free;
    END;
  END
  ELSE
    Result := -10;
END;

// führt ein Script aus
//        0 : Ok
//       -1 : kein Ausgabescript (TStringList) übergeben, keine Variablen übergeben
// -2 .. -4 : Fehler in der Funktion Datei kopieren
//   -5, -6 : Fehler in der Funktion VariablenersetzenDatei
//   -7, -8 : Fehler in Run
//   ab -21 : Fehler im aufgerufenen Script
FUNCTION Scriptpruefen(Ausgabescript: TStrings; Variablen: TStrings; Scriptname: STRING = ''; Marke: STRING = ':all'): Integer; OVERLOAD;
BEGIN
  Result := Scriptstarten(Ausgabescript, Variablen, Scriptname, Marke, True);
END;

FUNCTION Scriptpruefen(Ausgabedatei: STRING; Variablen: TStrings; Scriptname: STRING = ''; Marke: STRING = ':all'): Integer; OVERLOAD;
BEGIN
  Result := Scriptstarten(Ausgabedatei, Variablen, Scriptname, Marke, True);
END;


end.
