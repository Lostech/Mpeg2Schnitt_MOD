unit KapitelUnit;

interface

USES Classes, Grids, SysUtils,
     DatenTypen,
     DateienUnit,
     AllgFunktionen,
     Sprachen,
     AllgVariablen;

FUNCTION Kapiteleinfuegen(Kapitel: TKapitelEintrag; Text: STRING; Art: Integer = 0): Integer;
FUNCTION Kapitelberechnen(Anfang, Ende: Integer; SchnittListe, BerechneteListe: TStrings): Integer;
FUNCTION Kapitelspeichern(Dateiname: STRING; Anfang, Ende: Integer; SchnittListe: TStrings): Integer;
PROCEDURE Loeschen;

VAR Kapitelliste : TStringGrid;

implementation

// die Markierung wird gesetzt (-1 behält die alte Markierung bei)
FUNCTION Markierungsetzen(Links, Oben, Rechts, Unten: Integer): Integer;

VAR Selektion : TGridRect;

BEGIN
  IF (Links < Rechts + 1) AND
     (Oben < Unten + 1) THEN
  BEGIN
    IF Links > KapitelListe.ColCount - 1 THEN
      Links := KapitelListe.ColCount - 1;
    IF Rechts > KapitelListe.ColCount - 1 THEN
      Rechts := KapitelListe.ColCount - 1;
    IF Oben = 0 THEN
      Oben := 1;
    IF Unten = 0 THEN
      Unten := 1;
    IF Oben > KapitelListe.RowCount - 1 THEN
      Oben := KapitelListe.RowCount - 1;
    IF Unten > KapitelListe.RowCount - 1 THEN
      Unten := KapitelListe.RowCount - 1;
    Selektion := KapitelListe.Selection;
    IF Links > -1 THEN
      Selektion.Left := Links;
    IF Oben > - 1 THEN
      Selektion.Top := Oben;
    IF Rechts > - 1 THEN
      Selektion.Right := Rechts;
    IF Unten > - 1 THEN
      Selektion.Bottom := Unten;
    KapitelListe.Selection := Selektion;
    Result := 0;
  END
  ELSE
    Result := -1;
END;

// verschiebt die Markierung entsprechend "Anzahl"
FUNCTION Markierungverschieben(Anzahl: Integer): Integer;

VAR Oben, Unten : Integer;

BEGIN
  IF (KapitelListe.Selection.Top < KapitelListe.Tag) AND
     (KapitelListe.Selection.Top > 0) THEN
  BEGIN
    Oben := KapitelListe.Selection.Top + Anzahl;
    Unten := KapitelListe.Selection.Bottom + Anzahl;
    IF Oben > KapitelListe.Tag THEN
    BEGIN
      Oben := KapitelListe.Tag;
      Unten := KapitelListe.Selection.Bottom + KapitelListe.Tag - KapitelListe.Selection.Top;
    END;
    IF Oben < 1 THEN
    BEGIN
      Oben := 1;
      Unten := KapitelListe.Selection.Bottom - KapitelListe.Selection.Top + 1;
    END;
    Result := Markierungsetzen(-1, Oben, -1, Unten);
  END
  ELSE
    Result := 0;
END;

// verschiebt mehrere Zeilen auf eine neue Position, alle Zeilen dazwischen rücken nach
FUNCTION Zeilenverschieben(Quelle, Ziel, Anzahl: Integer): Integer;

VAR I : Integer;

PROCEDURE Zeileverschieben(Quelle, Ziel: Integer);

VAR Zeile : TStringList;
    I : Integer;

BEGIN
  Zeile := TStringList.Create;
  TRY
    Zeile.Assign(KapitelListe.Rows[Quelle]);                                    // Quellzeile sichern
    IF Quelle < Ziel THEN                                                       // Quelle steht über Ziel (Quelle ist kleiner)
      FOR I := Quelle TO Ziel - 1 DO                                            // alle Zeilen eins nach oben verschieben
        KapitelListe.Rows[I] := KapitelListe.Rows[I + 1]
    ELSE                                                                        // Ziel steht über Quelle
      FOR I := Quelle DOWNTO Ziel + 1 DO                                        // alle Zeilen eins nach unten verschieben
        KapitelListe.Rows[I] := KapitelListe.Rows[I - 1];
    KapitelListe.Rows[Ziel] := Zeile;                                           // gesicherte Quelle auf Ziel kopieren
  FINALLY
    Zeile.Free;
  END;
END;

BEGIN
  IF (Quelle > 0) AND
     (Quelle + Anzahl - 1 < KapitelListe.Tag) AND
     (Ziel > 0) AND
     (Ziel + Anzahl - 1 < KapitelListe.Tag) THEN
  BEGIN
    Result := 0;
    IF Quelle < Ziel THEN                                                       // Quelle steht über Ziel (Quelle ist kleiner)
      FOR I := 1 TO Anzahl DO                                                   // Anzahl der zu verschiebenen Zeilen
        Zeileverschieben(Quelle, Ziel + Anzahl - 1)
    ELSE                                                                        // Ziel steht über Quelle
      FOR I := 1 TO Anzahl DO
        Zeileverschieben(Quelle + Anzahl -1, Ziel)
  END
  ELSE
    Result := -1;
END;

// fügt eine neue Zeile entsprechend "Art" ein
FUNCTION Kapiteleinfuegen(Kapitel: TKapitelEintrag; Text: STRING; Art: Integer = 0): Integer;

VAR Zeile : Integer;
    Selektion : TGridRect;

BEGIN
  CASE Art OF
    0: BEGIN
         Zeile := KapitelListe.Selection.Top;                                 // vor der Markierung
         IF Zeile > KapitelListe.Tag THEN
           Zeile := KapitelListe.Tag;
       END;
    1: BEGIN                                                                  // nach der Markierung
         Zeile := KapitelListe.Selection.Bottom;
         IF Zeile < KapitelListe.Tag THEN
           Inc(Zeile);
       END;
  ELSE
    Zeile := KapitelListe.Tag;                                                // am Ende
  END;
  KapitelListe.Tag := KapitelListe.Tag + 1;                                   // neue Zeile anhängen
  IF KapitelListe.Tag > KapitelListe.RowCount - 1 THEN
  BEGIN                                                                       // wenn nötig Zeilenzahl erhöhen
    Selektion := KapitelListe.Selection;                                      // ändern von RowCount ändert die Selektion
    KapitelListe.RowCount := KapitelListe.Tag + 1;
    KapitelListe.Selection := Selektion;
  END;
  Result := Zeilenverschieben(Zeile, Zeile + 1, KapitelListe.Tag - 1 - Zeile);
  IF Result = 0 THEN
  BEGIN                                                                       // Zeile mit Daten füllen
    IF Assigned(Kapitel) THEN
    BEGIN
      IF Text = '' THEN
        Text := DateienUnit.Knotenname(Kapitel.Videoknoten, Kapitel.Audioknoten);
      KapitelListe.Cells[0, Zeile] := IntToStrFmt(DateienUnit.HauptknotenNr(Kapitel.Videoknoten), 2);
      KapitelListe.Cells[1, Zeile] := IntToStrFmt(DateienUnit.HauptknotenNr(Kapitel.Audioknoten), 2);
      KapitelListe.Cells[2, Zeile] := BildnummerInZeitStr(ArbeitsumgebungObj.KapitelFormat, Kapitel.Kapitel, Kapitel.BilderProSek);
      KapitelListe.Objects[2, Zeile] := Kapitel;
      KapitelListe.Cells[3, Zeile] := Text;
    END
    ELSE
    BEGIN
      KapitelListe.Cells[0, Zeile] := ArbeitsumgebungObj.KapitelTrennzeile1;
      KapitelListe.Cells[1, Zeile] := ArbeitsumgebungObj.KapitelTrennzeile2;
      KapitelListe.Cells[2, Zeile] := ArbeitsumgebungObj.KapitelTrennzeile3;
      KapitelListe.Cells[3, Zeile] := Text;
    END;
    IF Art < 2 THEN                                                             // neue Zeile vor der Markierung und nach der Markierung eingefügt
      Markierungverschieben(1);
  END;
END;

// berechnet eine neue Kapitelliste an Hand der Schnittliste
// Anfang und Ende kennzeichnen den Bereich der Kapitelliste, -1 bedeutet komplette Liste
//  2 : Schnittliste ist leer
//  1 : Kapitelliste ist leer
//  0 : Ok
// -1 : Ende ist größer als die Kapitelliste oder Anfang ist größer Ende
// -2 : keine Schnittliste übergeben
// -3 : keine zu berechnende Kapitelliste übergeben
FUNCTION Kapitelberechnen(Anfang, Ende: Integer; SchnittListe, BerechneteListe: TStrings): Integer;

VAR I, J, K,
    Laenge : Integer;
    Schnittpunkt : TSchnittpunkt;
    KapitelEintrag : TKapitelEintrag;

BEGIN
  Result := 0;
  IF (Anfang < 1) THEN
    Anfang := 1;
  IF (Ende < 0) THEN
    Ende := KapitelListe.Tag - 1;
  IF KapitelListe.Tag > 1 THEN
    IF (Ende < KapitelListe.Tag) AND
       (Anfang < Ende + 1) THEN
      IF Assigned(SchnittListe) THEN
        IF SchnittListe.Count > 0 THEN
          IF Assigned(BerechneteListe) THEN
          BEGIN
            Laenge := 0;
            FOR I := 0 TO SchnittListe.Count -1 DO
            BEGIN
              Schnittpunkt := TSchnittpunkt(SchnittListe.Objects[I]);
              IF Assigned(Schnittpunkt) THEN
              BEGIN
                FOR J := Anfang TO Ende DO
                BEGIN
                  KapitelEintrag := TKapitelEintrag(KapitelListe.Objects[2, J]);
                  IF Assigned(Kapiteleintrag) THEN
                  BEGIN
                    K := DateienUnit.KnotenDatengleich(KapitelEintrag.Videoknoten, Schnittpunkt.Videoknoten);
                    IF K > 1 THEN
                      K := DateienUnit.KnotenDatengleich(KapitelEintrag.Audioknoten, Schnittpunkt.Audioknoten, True);
                    IF (K IN [0, 1]) AND
                       (KapitelEintrag.Kapitel >= Schnittpunkt.Anfang) AND (KapitelEintrag.Kapitel <= Schnittpunkt.Ende) THEN
                    BEGIN
                      BerechneteListe.Add(IntToStr(KapitelEintrag.Kapitel - Schnittpunkt.Anfang + Laenge));
                    END;
                  END;
                END;
                Laenge := Laenge + Schnittpunkt.Ende - Schnittpunkt.Anfang + 1;
              END;
            END;
          END
          ELSE
            Result := -3                                                        // keine Berechneteliste übergeben
        ELSE
          Result := 2                                                           // kein Schnittlisteneintrag
      ELSE
        Result := -2                                                            // keine Schnittliste übergeben
    ELSE
      Result := -1                                                              // Anfang, Ende ungültig
  ELSE
    Result := 1;                                                                // kein Kapitellisteneintrag
END;

// speichert eine berechnete Kapitelliste unter Dateiname
// Anfang und Ende kennzeichnen den Bereich der Kapitelliste, -1 bedeutet komplette Liste
//     1 : keine Kapitel vorhanden
//     0 : Ok
//    -1 : kein Dateiname übergeben
//    -2 : keine Schnittliste übergeben
//ab -11 : Fehler in der Funktion Kapitelberechnen
FUNCTION Kapitelspeichern(Dateiname: STRING; Anfang, Ende: Integer; SchnittListe: TStrings): Integer;

VAR I : Integer;
    BerechneteListe : TStringList;

BEGIN
  IF Dateiname <> '' THEN
    IF Assigned(SchnittListe) THEN
    BEGIN
      BerechneteListe := TStringList.Create;
      TRY
        Result := Kapitelberechnen(Anfang, Ende, SchnittListe, BerechneteListe);
        IF (Result = 0) THEN
          IF (BerechneteListe.Count > 0) THEN
          BEGIN
            FOR I := 0 TO BerechneteListe.Count -1 DO
              BerechneteListe.Strings[I] := BildnummerInZeitStr(ArbeitsumgebungObj.KapitelExportFormat,
                                                                StrToInt(BerechneteListe.Strings[I]) +
                                                                ArbeitsumgebungObj.KapitelExportOffset,
                                                                TSchnittpunkt(SchnittListe.Objects[0]).Framerate);
            BerechneteListe.SaveToFile(Dateiname + ArbeitsumgebungObj.StandardEndungenKapitel);
          END
          ELSE
            Result := 1
        ELSE
          IF Result < 0 THEN
            Result := Result - 10;
      FINALLY
        BerechneteListe.Free;
      END;
    END
    ELSE
      Result := -2                             // keine Schnittliste übergeben
  ELSE
    Result := -1;                              // kein Dateiname übergeben
END;

FUNCTION Zeilenloeschen(Anfang, Ende: Integer): Integer;

VAR I, J : Integer;

BEGIN
  IF (Anfang > 0) AND
     (Ende < KapitelListe.Tag) AND
     (Anfang < Ende + 1) THEN
  BEGIN
    Result := Zeilenverschieben(Ende + 1, Anfang, KapitelListe.Tag - Ende - 1);
    IF Result = 0 THEN
    BEGIN
      FOR I := KapitelListe.Tag - (Ende - Anfang + 1) TO KapitelListe.Tag - 1 DO
        FOR J := 0 TO KapitelListe.ColCount - 1 DO
        BEGIN
          IF Assigned(KapitelListe.Objects[J, I]) THEN
            KapitelListe.Objects[J, I].Free;
          KapitelListe.Cells[J, I] := '';
        END;
      KapitelListe.Tag := KapitelListe.Tag - (Ende - Anfang + 1);
//      KapitelListeZeilenberechnen;           // ------------ später ----------------
    END;
  END
  ELSE
    Result := -1;
END;

PROCEDURE Loeschen;
BEGIN
  IF Zeilenloeschen(1, KapitelListe.Tag - 1) = 0 THEN
    Markierungsetzen(-1, KapitelListe.Tag, -1, KapitelListe.Tag);
END;

end.
 