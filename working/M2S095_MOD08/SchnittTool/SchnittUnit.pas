unit SchnittUnit;

interface

USES StdCtrls, ComCtrls,
     DatenTypen,
     DateienUnit,
     AllgFunktionen,
     Sprachen,
     AllgVariablen;

FUNCTION Schnitteinfuegen(Listenpunkt: TSchnittpunkt; Text: STRING; Art: Integer = 0): Integer;
PROCEDURE Loeschen;

VAR Schnittliste : TListBox;

implementation

FUNCTION ersteZeile: Integer;
BEGIN
  Result := 0;
  WHILE (Result < Schnittliste.Items.Count) AND (NOT Schnittliste.Selected[Result]) DO
    Inc(Result);
  IF Result = Schnittliste.Items.Count THEN
    Result := -1;
END;

FUNCTION letzteZeile: Integer;
BEGIN
  Result := Schnittliste.Items.Count - 1;
  WHILE (Result > -1) AND (NOT Schnittliste.Selected[Result]) DO
    Dec(Result);
END;

FUNCTION Schnittpunktanzeige_berechnen(Index1, Index2: Integer): Integer;

VAR Schnittpunkt1,
    Schnittpunkt2,
    Schnittpunkt3,
    Schnittpunkt4 : TSchnittpunkt;

BEGIN
  Result := 0;
  IF (Index1 > -1) AND (Index1 < Schnittliste.Items.Count) THEN
    Schnittpunkt2 := Schnittliste.Items.Objects[Index1] AS TSchnittpunkt
  ELSE
  BEGIN
    Schnittpunkt2 := NIL;
    Index1 := -1;
    Result := -1;              // Index1 außerhalb der Schnittliste
  END;
  IF Index1 > 0 THEN
    Schnittpunkt1 := Schnittliste.Items.Objects[Index1 - 1] AS TSchnittpunkt
  ELSE
    Schnittpunkt1 := NIL;
  IF (Index2 > -1) AND (Index2 < Schnittliste.Items.Count) THEN
    Schnittpunkt3 := Schnittliste.Items.Objects[Index2] AS TSchnittpunkt
  ELSE
  BEGIN
    Schnittpunkt3 := NIL;
    Index2 := Schnittliste.Items.Count;
    Result := Result - 2;      // Index2 außerhalb der Schnittliste
  END;
  IF (Index2 + 1) < Schnittliste.Items.Count THEN
    Schnittpunkt4 := Schnittliste.Items.Objects[Index2 + 1] AS TSchnittpunkt
  ELSE
    Schnittpunkt4 := NIL;
  IF Assigned(Schnittpunkt1) AND Assigned(Schnittpunkt2) THEN
    IF DateienUnit.Videodateivergleich(Schnittpunkt1.Videoknoten, Schnittpunkt2.Videoknoten) AND
       (Schnittpunkt1.Ende = (Schnittpunkt2.Anfang - 1)) THEN
    BEGIN                // nichts berechnen da Schnittpunkte zusammengehören
      Schnittpunkt1.Endeberechnen := (Schnittpunkt1.Endeberechnen AND $3) + 4;
      Schnittpunkt2.Anfangberechnen := (Schnittpunkt2.Anfangberechnen AND $3) + 4;
    END
    ELSE
    BEGIN                // Orginalzustand herstellen da die Schnittpunkte nicht zusammengehören
      Schnittpunkt1.Endeberechnen := (Schnittpunkt1.Endeberechnen AND $3);
      Schnittpunkt2.Anfangberechnen := (Schnittpunkt2.Anfangberechnen AND $3);
    END
  ELSE
    IF Assigned(Schnittpunkt2) THEN  // Orginalzustand herstellen da es keinen ersten Schnittpunkt gibt
      Schnittpunkt2.Anfangberechnen := (Schnittpunkt2.Anfangberechnen AND $3);
  IF Assigned(Schnittpunkt3) AND Assigned(Schnittpunkt4) THEN
    IF DateienUnit.Videodateivergleich(Schnittpunkt3.Videoknoten, Schnittpunkt4.Videoknoten) AND
       (Schnittpunkt3.Ende = (Schnittpunkt4.Anfang - 1)) THEN
    BEGIN                // nichts berechnen da Schnittpunkte zusammengehören
      Schnittpunkt3.Endeberechnen := (Schnittpunkt3.Endeberechnen AND $3) + 4;
      Schnittpunkt4.Anfangberechnen := (Schnittpunkt4.Anfangberechnen AND $3) + 4;
    END
    ELSE
    BEGIN                // Orginalzustand herstellen da die Schnittpunkte nicht zusammengehören
      Schnittpunkt3.Endeberechnen := (Schnittpunkt3.Endeberechnen AND $3);
      Schnittpunkt4.Anfangberechnen := (Schnittpunkt4.Anfangberechnen AND $3);
    END
  ELSE
    IF Assigned(Schnittpunkt3) THEN  // Orginalzustand herstellen da es keinen lezten Schnittpunkt gibt
      Schnittpunkt3.Endeberechnen := (Schnittpunkt3.Endeberechnen AND $3);
END;

FUNCTION SchnittpunktFormatberechnen(Schnittpunkt: TSchnittpunkt): STRING;
BEGIN
  Result := ' ' + IntToStrFmt(DateienUnit.HauptknotenNr(Schnittpunkt.Videoknoten), 2) +
            ' ' + IntToStrFmt(DateienUnit.HauptknotenNr(Schnittpunkt.Audioknoten), 2) +
            ArbeitsumgebungObj.SchnittpunktTrennzeichen +
            BildnummerInZeitStr(ArbeitsumgebungObj.SchnittpunktFormat, Schnittpunkt.Anfang, Schnittpunkt.Framerate) +
            ArbeitsumgebungObj.SchnittpunktTrennzeichen +
            BildnummerInZeitStr(ArbeitsumgebungObj.SchnittpunktFormat, Schnittpunkt.Ende, Schnittpunkt.Framerate);
END;

FUNCTION Schnitteinfuegen(Listenpunkt: TSchnittpunkt; Text: STRING; Art: Integer = 0): Integer;

VAR ListenIndex : Integer;

BEGIN
  IF Assigned(Listenpunkt) THEN
  BEGIN
    IF Text = '' THEN
      Text := SchnittpunktFormatberechnen(Listenpunkt);
    CASE Art OF
      0 : BEGIN                                                                 // vor der Markierung
            ListenIndex := ersteZeile;
            IF ListenIndex < 0 THEN
              Result := SchnittListe.Items.AddObject(Text, Listenpunkt)
            ELSE
            BEGIN
              SchnittListe.Items.InsertObject(ListenIndex, Text, Listenpunkt);
              Result := ListenIndex;
            END;
          END;
      1 : BEGIN                                                                 // nach der Markierung
            ListenIndex := letzteZeile;
            IF ListenIndex < 0 THEN
              Result := SchnittListe.Items.AddObject(Text, Listenpunkt)
            ELSE
            BEGIN
              IF ListenIndex = SchnittListe.Count - 1 THEN
                Result := SchnittListe.Items.AddObject(Text, Listenpunkt)
              ELSE
              BEGIN
                Inc(ListenIndex);
                SchnittListe.Items.InsertObject(ListenIndex, Text, Listenpunkt);
                Result := ListenIndex;
              END;
              SchnittListe.Selected[ListenIndex] := True;
              Dec(ListenIndex);
              IF SchnittListe.Selected[ListenIndex] THEN
              BEGIN                                                             // Multiselekt ist eingeschaltet
                WHILE (ListenIndex > -1) AND SchnittListe.Selected[ListenIndex] DO
                  Dec(ListenIndex);
                Inc(ListenIndex);
                SchnittListe.Selected[ListenIndex] := False;
              END;
            END;
          END;
    ELSE                                                                        // am Ende
      Result := SchnittListe.Items.AddObject(Text, Listenpunkt);
//      ListenIndex := SchnittListe.Items.Count - 1;
    END;
//    Schnittpunktanzeige_berechnen(ListenIndex, ListenIndex);
  END
  ELSE
    Result := -1;
END;

PROCEDURE Loeschen;

VAR I : Integer;

BEGIN
  FOR I := 0 TO SchnittListe.Items.Count -1 DO
    TSchnittpunkt(SchnittListe.Items.Objects[I]).Free;
  SchnittListe.Clear;
  SchnittListe.ItemIndex := - 1;
END;

end.
