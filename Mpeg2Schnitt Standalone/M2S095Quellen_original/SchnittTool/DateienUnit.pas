unit DateienUnit;

interface

USES ComCtrls, Classes, SysUtils, StrUtils,
     DatenTypen,
     AllgFunktionen,
     Sprachen,
     AllgVariablen;

TYPE
  TDateieintrag = CLASS
    Name : STRING;
  END;

  TDateieintragAudio = CLASS(TDateieintrag)
    Audiooffset : Integer;
  END;

FUNCTION SpurAnzahl: Integer;
FUNCTION ExtractDateiendungSpur(Spur: Integer; Liste: TStrings = NIL): STRING;
FUNCTION Audioendungszaehler(SchnittListe: TStrings; Spur: Integer): Integer;
FUNCTION HauptknotenNr(Knoten: TTReeNode): Integer;
FUNCTION Knotennameaendern(Knoten: TTreeNode; Name: STRING; HKnoten: Boolean = False): TTReeNode;
FUNCTION VideoEintrageinfuegen(Knoten: TTreeNode; Videodatei: STRING; Videoname: STRING = ''): TTReeNode;
FUNCTION AudioEintrageinfuegen(Knoten: TTreeNode; Audiodatei: STRING; Audiooffset: Integer; Spur: Integer = -1; Audioname: STRING = ''): TTReeNode;
FUNCTION Videodateivergleich(Knoten1, Knoten2: TTreeNode): Boolean;
FUNCTION GleichenKnotensuchen(Knoten: TTreeNode): TTreeNode;
FUNCTION Knotenname(Knoten1, Knoten2: TTreeNode): STRING;
FUNCTION KnotenDatengleich(Knoten1, Knoten2: TTreeNode; Audio: Boolean = False): Integer;
PROCEDURE Loeschen;

VAR Dateiliste : TTreeView;
//    WortVideo : STRING = 'Video';
//    WortAudio : STRING = 'Audio';

implementation

FUNCTION ExtractAudioendung(Name, AudioTrennzeichen: STRING): STRING;

VAR PosPunkt,
    PosBackslash,
    PosTrennzeichen : Integer;

BEGIN
  PosPunkt := PosX('.', Name, Length(Name), True);
  IF PosPunkt = 0 THEN
    PosPunkt := Length(Name) + 1;
  PosBackslash := PosX('\', Name, PosPunkt - 1, True);
  IF AudioTrennzeichen = '' THEN
    PosTrennzeichen := PosPunkt
  ELSE
    PosTrennzeichen := PosX(AudioTrennzeichen, Name, PosPunkt - 1, True);
  IF PosTrennzeichen < PosBackslash + 1 THEN
    PosTrennzeichen := PosPunkt;
  Result := Copy(Name, PosTrennzeichen, Length(Name) + 1 - PosTrennzeichen);
END;

FUNCTION SpurAnzahl: Integer;
BEGIN
  IF Dateiliste.Items.Count > 0 THEN
    Result := Dateiliste.Items[0].Count
  ELSE
    Result := 0;  
END;

FUNCTION ExtractDateiendungSpur(Spur: Integer; Liste: TStrings = NIL): STRING;

VAR I, J : Integer;
    gefunden : Boolean;

BEGIN
  Result := '';
  gefunden := False;
  I := 0;
  WHILE (I < Dateiliste.Items.Count) AND (NOT gefunden) DO                      // Dateienliste durchsuchen
  BEGIN
    IF Dateiliste.Items[I].Level = 0 THEN                                       // nur Knoten der ersten Ebene betrachten
    BEGIN
      IF Assigned(Liste) THEN                                                   // ist eine Liste übergeben worden
      BEGIN
        J := 0;
        WHILE (J < Liste.Count) AND (NOT gefunden) DO                           // prüfen ob der Knoten in der Liste ist
        BEGIN
          IF Assigned(Liste.Objects[J]) THEN
            IF Spur = 0 THEN
            BEGIN
              IF TSchnittpunkt(Liste.Objects[J]).Videoknoten = Dateiliste.Items[I] THEN
                gefunden := True;                                               // Knoten ist in der Liste
            END
            ELSE
              IF TSchnittpunkt(Liste.Objects[J]).Audioknoten = Dateiliste.Items[I] THEN
                gefunden := True;                                               // Knoten ist in der Liste
          Inc(J);
        END;
      END
      ELSE
        gefunden := True;                                                       // keine Liste übergeben, alle Knoten betrachten
      IF gefunden THEN
        IF Spur < Dateiliste.Items[I].Count THEN                                // Knoten hat genug Unterknoten
          IF Assigned(Dateiliste.Items[I].Item[Spur].Data) THEN                 // Knoten hat Daten
            IF Spur = 0 THEN
              IF TDateieintrag(Dateiliste.Items[I].Item[Spur].Data).Name = '' THEN
                gefunden := False
              ELSE
                Result := ExtractFileExt(TDateieintrag(Dateiliste.Items[I].Item[Spur].Data).Name)
            ELSE
              IF TDateieintragAudio(Dateiliste.Items[I].Item[Spur].Data).Name = '' THEN
                gefunden := False
              ELSE                                                              // die Endung extrahieren, gefunden bleibt True
                Result := ExtractAudioendung(TDateieintragAudio(Dateiliste.Items[I].Item[Spur].Data).Name, ArbeitsumgebungObj.AudioTrennzeichen)
          ELSE
            gefunden := False                                                   // der Knoten hat keine Daten, weitersuchen
        ELSE
          gefunden := False;                                                    // der Knoten hat zu wenig Unterknoten, weitersuchen
    END;
    Inc(I);
  END;
  IF NOT gefunden THEN                                                          // keine Daten in den betrachteten Knoten dieser Spur
    Result := '$leer#';  
END;

FUNCTION Audioendungszaehler(SchnittListe: TStrings; Spur: Integer): Integer;

VAR I, Endunggleich : Integer;
    Endung : STRING;

BEGIN
  IF Dateiliste.Items.Count > 0 THEN
  BEGIN
    Endung := ExtractDateiendungSpur(Spur, SchnittListe);
    IF Endung <> '$leer#' THEN
    BEGIN
      Result := 0;
      Endunggleich := 0;
      FOR I := 1 TO Dateiliste.Items[0].Count - 1 DO
        IF Endung = ExtractDateiendungSpur(I, SchnittListe) THEN
        BEGIN
          Inc(Endunggleich);
          IF I = Spur THEN
            Result := Endunggleich;
        END;
      IF Endunggleich = 1 THEN
        Result := 0;                                                            // die Endung ist nicht mehrfach vorhanden
    END
    ELSE
      Result := -2;                                                             // in dieser Spur der Schnittliste sind keine Audiodateien
  END
  ELSE
    Result := -1;                                                               // Dateienliste leer
END;

FUNCTION HauptknotenNr(Knoten: TTReeNode): Integer;

VAR I : Integer;

BEGIN
  I := 0;
  Result := 0;
  WHILE I < Dateiliste.Items.Count DO
  BEGIN
    IF Dateiliste.Items[I].Level = 0 THEN
      Inc(Result);
    IF Dateiliste.Items[I] = Knoten THEN
      I := Dateiliste.Items.Count
    ELSE
      Inc(I);
  END;
END;

FUNCTION Knotennameformatieren(Knoten: TTreeNode; Name: STRING): STRING;

VAR I, J : Integer;

BEGIN
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level = 0 THEN
    BEGIN
      I := Pos(' ', Name);
      IF I > 0 THEN
        IF StrToIntDef(LeftStr(Name, I - 1), -1) > -1 THEN
          Result := IntToStrFmt(HauptknotenNr(Knoten), 2) + RightStr(Name, Length(Name) - I + 1)
        ELSE
          Result := IntToStrFmt(HauptknotenNr(Knoten), 2) + ' ' + TrimLeft(Name)
      ELSE
        Result := IntToStrFmt(HauptknotenNr(Knoten), 2) + ' ' + TrimLeft(Name);
    END
    ELSE
    BEGIN
      J := Pos(' -> ', Name);
      I := Knoten.Parent.IndexOf(Knoten);
      IF I = 0 THEN
      BEGIN
        IF J > 0 THEN
          Result := WortVideo + ' -> ' + RightStr(Name, Length(Name) - J - 3)
        ELSE
          Result := WortVideo + ' -> ' + TrimLeft(Name);
      END
      ELSE
      BEGIN
        IF J > 0 THEN
          Result := WortAudio + ' ' + IntToStr(I) + ' -> ' + RightStr(Name, Length(Name) - J - 3)
        ELSE
          Result := WortAudio + ' ' + IntToStr(I) + ' -> ' + TrimLeft(Name);
      END;
    END;
  END
  ELSE
    Result := '';
END;

FUNCTION KnotenStrukturerzeugen(Knotenname : STRING): TTReeNode;

VAR I : Integer;

BEGIN
  Result := Dateiliste.Items.Add(NIL, IntToStrFmt(HauptknotenNr(NIL) + 1, 2) + ' ' + ChangeFileExt(ExtractFileName(Knotenname), ''));
  Dateiliste.Items.AddChild(Result, WortVideo + ' -> ');
  FOR I := Result.Count TO Dateiliste.Items[0].Count - 1 DO
    Dateiliste.Items.AddChild(Result, WortAudio + ' ' + IntToStr(I) + ' -> ');
END;

FUNCTION AudioSpurerzeugen(Knoten: TTReeNode): TTReeNode;

VAR I : Integer;

BEGIN
  Result := NIL;
  I := 0;
  WHILE I < Dateiliste.Items.Count DO
  BEGIN
    IF Dateiliste.Items[I].Level = 0 THEN                                       // Hauptknoten
      IF Knoten = Dateiliste.Items[I] THEN                                      // aktueller Knoten ist der übergebene Knoten
        Result := Dateiliste.Items.AddChild(Dateiliste.Items[I], WortAudio + ' ' + IntToStr(Dateiliste.Items[I].Count) + ' -> ')
      ELSE
        Dateiliste.Items.AddChild(Dateiliste.Items[I], WortAudio + ' ' + IntToStr(Dateiliste.Items[I].Count) + ' -> ');
    Inc(I);
  END;
END;

FUNCTION AudioSpursuchen(Knoten: TTReeNode; Audioname: STRING): TTReeNode;

VAR I : Integer;

BEGIN
  Result := NIL;
  Audioname := ExtractAudioendung(Audioname, ArbeitsumgebungObj.AudioTrennzeichen);
  I := 1;
  WHILE (I < Knoten.Count) AND (NOT Assigned(Result)) DO
  BEGIN                                                                         // passenden Audioknoten suchen
    IF (NOT Assigned(Knoten.Item[I].Data)) AND
       (Audioname = ExtractDateiendungSpur(I, NIL)) THEN
      Result := Knoten.Item[I];
    Inc(I);
  END;
END;

PROCEDURE KnotenDatenloeschen(Knoten: TTreenode);

VAR Unterknoten : TTreenode;
    I : Integer;

BEGIN
  IF Knoten.HasChildren THEN                                                    // hat der Knoten Unterknoten
    FOR I := 0 TO Knoten.Count - 1 DO                                           // dann alle Unterkoten durchlaufen
    BEGIN
      Unterknoten := Knoten.Item[I];
      KnotenDatenloeschen(Unterknoten);                                         // Procedure rekursiv aufrufen
    END;
  IF Assigned(Knoten.Data) THEN                                                 // ist ein Datenobjekt vorhanden
  BEGIN
    TObject(Knoten.Data).Free;                                                  // dann freigeben und
    Knoten.Data := NIL;                                                         // mit NIL kennzeichnen
    Knoten.Text := LeftStr(Knoten.Text, Pos(' -> ', Knoten.Text) + 3);
// ------------------ Später ----------------------
{    IF Knoten.Parent <> VorschauKnoten THEN
    BEGIN
      IF Knoten = aktVideoknoten THEN
      BEGIN
        DateilisteaktualisierenVideo(Knoten, False);
        Schnittpunktanzeigeloeschen;
      END;
      IF (Knoten = aktAudioknoten) THEN
      BEGIN
        DateilisteaktualisierenAudio(Knoten, False);
        Schnittpunktanzeigeloeschen;
      END;
    END;
    IF Assigned(VorschauVideoknoten) AND (Knoten = VorschauVideoknoten) THEN
    BEGIN
      IF Assigned(VorschauListe) THEN
      BEGIN
        VorschauListe.Loeschen;
        VorschauListe.Free;
        VorschauListe := NIL;
      END;
      IF Assigned(VorschauIndexListe) THEN
      BEGIN
        VorschauIndexListe.Loeschen;
        VorschauIndexListe.Free;
        VorschauIndexListe := NIL;
      END;
      IF Assigned(VorschauSequenzHeader) THEN
      BEGIN
        VorschauSequenzHeader.Free;
        VorschauSequenzHeader := NIL;
      END;
      IF Assigned(VorschauBildHeader) THEN
      BEGIN
        VorschauBildHeader.Free;
        VorschauBildHeader := NIL;
      END;
      VorschauVideoknoten := NIL;
    END;
    IF Assigned(VorschauAudioknoten) AND (Knoten = VorschauAudioknoten) THEN
    BEGIN
      IF Assigned(VorschauAudioListe) THEN
      BEGIN
        VorschauAudioListe.Loeschen;
        VorschauAudioListe.Free;
        VorschauAudioListe := NIL;
      END;
      IF Assigned(VorschauAudioHeader) THEN
      BEGIN
        VorschauAudioHeader.Free;
        VorschauAudioHeader := NIL;
      END;
      VorschauAudioknoten := NIL;
    END;    }
  END;    
END;

FUNCTION Knotennameaendern(Knoten: TTreeNode; Name: STRING; HKnoten: Boolean = False): TTReeNode;
BEGIN
  IF Assigned(Knoten) THEN
  BEGIN
    IF HKnoten AND (Knoten.Level > 0) THEN
      Knoten := Knoten.Parent;
    Knoten.Text := Knotennameformatieren(Knoten, Name);
    Result := Knoten;
  END
  ELSE
    Result := NIL;
END;

FUNCTION VideoEintrageinfuegen(Knoten: TTreeNode; Videodatei: STRING; Videoname: STRING = ''): TTReeNode;

VAR Dateieintrag : TDateieintrag;

BEGIN
  IF NOT Assigned(Knoten) THEN
    Knoten := KnotenStrukturerzeugen(Videodatei);
  IF Knoten.Level > 0 THEN
    Knoten := Knoten.Parent;
  Dateieintrag := TDateieintrag.Create;
  Dateieintrag.Name := Videodatei;
  IF Knoten.HasChildren THEN
  BEGIN
    Result := Knoten.Item[0];
    IF Videoname = '' THEN
      Result.Text := Result.Text + Videodatei
    ELSE
      Result.Text := Knotennameformatieren(Result, Videoname);
    Result.Data := Dateieintrag;
  END
  ELSE
    Result := NIL;
END;

FUNCTION AudioEintrageinfuegen(Knoten: TTreeNode; Audiodatei: STRING; Audiooffset: Integer; Spur: Integer = -1; Audioname: STRING = ''): TTReeNode;

VAR Audiodateieintrag : TDateieintragAudio;

BEGIN
  IF NOT Assigned(Knoten) THEN
    Knoten := KnotenStrukturerzeugen(Audiodatei);
  IF Knoten.Level > 0 THEN
    Knoten := Knoten.Parent;
  Audiodateieintrag  :=  TDateieintragAudio.Create;
  Audiodateieintrag.Name := Audiodatei;
  Audiodateieintrag.Audiooffset := Audiooffset;
  IF Spur > -1 THEN
  BEGIN                                                                         // einfügen in vorgegebener Spur
{    IF Spur < Knoten.Count THEN
      Result := Knoten.Item[Spur]
    ELSE
      Result := NIL; }
    WHILE Spur > Knoten.Count - 1 DO
      AudioSpurerzeugen(Knoten);
    Result := Knoten.Item[Spur];
  END
  ELSE
    Result := AudioSpursuchen(Knoten, Audiodatei);
  IF NOT Assigned(Result) THEN                                                  // keinen passenden Audioknoten gefunden
    Result := AudioSpurerzeugen(Knoten);                                        // neuen Audioknoten erzeugen
  IF Assigned(Result) THEN
  BEGIN
    IF Audioname = '' THEN
      Result.Text := Result.Text + Audiodatei
    ELSE
      Result.Text := Knotennameformatieren(Result, Audioname);
    Result.Data := Audiodateieintrag;
  END;
END;

FUNCTION Videodateivergleich(Knoten1, Knoten2: TTreeNode): Boolean;
BEGIN
  IF Assigned(Knoten1) AND Assigned(Knoten2) AND
     Knoten1.HasChildren AND Knoten2.HasChildren AND
     Assigned(Knoten1[0].Data) AND Assigned(Knoten2[0].Data) THEN
    IF Knoten1 = Knoten2 THEN
      Result := True
    ELSE
      IF TDateieintrag(Knoten1[0].Data).Name = TDateieintrag(Knoten2[0].Data).Name THEN
        Result := True
      ELSE
        Result := False
  ELSE
    Result := False;
END;

FUNCTION GleichenKnotensuchen(Knoten: TTreeNode): TTreeNode;

VAR I, J : Integer;
    gefunden : Boolean;

BEGIN
  Result := NIL;
  IF Assigned(Knoten) THEN
  BEGIN
    IF Knoten.Level > 0 THEN
      Knoten := Knoten.Parent;
    gefunden := False;
    I := 0;
    WHILE (I < Dateiliste.Items.Count) AND (NOT gefunden) DO                    // durchläuft alle Knoten
    BEGIN
      IF (Dateiliste.Items[I] <> Knoten) AND                                    // den übergebenen Knoten ausschließen
         (Dateiliste.Items[I].Level = 0) AND                                    // nur Knoten der ersten Ebene betrachten
         (Dateiliste.Items[I].Count = Knoten.Count) THEN                        // Knoten müssen die gleichen Anzahl Unterknoten haben
      BEGIN
        gefunden := True;
        J := 0;
        WHILE (J < Dateiliste.Items[I].Count) AND gefunden DO                   // durchläuft alle Unterknoten
        BEGIN
          IF Assigned(Dateiliste.Items[I].Item[J].Data) AND Assigned(Knoten.Item[J].Data) THEN
          BEGIN                                                                 // beide Knoten haben Daten
            IF J = 0 THEN
            BEGIN                                                               // Videoknoten
              IF TDateiEintrag(Dateiliste.Items[I].Item[J].Data).Name <> TDateiEintrag(Knoten.Item[J].Data).Name THEN
                gefunden := False;                                              // Videodateinamen sind ungleich
            END
            ELSE
            BEGIN
              IF TDateiEintragAudio(Dateiliste.Items[I].Item[J].Data).Name <> TDateiEintragAudio(Knoten.Item[J].Data).Name THEN
                gefunden := False                                               // Audiodateinamen sind ungleich
              ELSE
                IF TDateiEintragAudio(Dateiliste.Items[I].Item[J].Data).Audiooffset <> TDateiEintragAudio(Knoten.Item[J].Data).Audiooffset THEN
                  gefunden := False;                                            // Audiooffset ist nicht gleich
            END;
          END
          ELSE
            IF Assigned(Dateiliste.Items[I].Item[J].Data) OR Assigned(Knoten.Item[J].Data) THEN
              gefunden := False;                                                // nur ein Knoten hat Daten
          Inc(J);
        END;
        IF gefunden THEN
        BEGIN                                                                   // gleichen Knoten gefunden
          Result := Dateiliste.Items[I];                                        // gefundenen Knoten zurückgeben
          KnotenDatenloeschen(Knoten);                                          // übergebenen Knoten löschen
          Dateiliste.Items.Delete(Knoten);
        END;
      END;
      Inc(I);
    END;
    IF NOT Assigned(Result) THEN
      Result := Knoten;                                                         // keinen gleichen Knoten gefunden
  END;
END;

FUNCTION Knotenname(Knoten1, Knoten2: TTreeNode): STRING;
BEGIN
  Result := '';
  IF Assigned(Knoten1) THEN
  BEGIN
    IF Knoten1.Level > 0 THEN
      Knoten1 := Knoten1.Parent;
    Result := Knoten1.Text;
  END;
  IF (Result = '') AND
     Assigned(Knoten2) THEN
  BEGIN
    IF Knoten2.Level > 0 THEN
      Knoten2 := Knoten2.Parent;
    Result := Knoten2.Text;
  END;
END;

// vergleicht die Dateien zweier Video- oder Audioknoten
//  8 : beide Knoten sind NIL
//  7 : Knoten2 hat keine Daten, Knoten1 ist NIL
//  6 : Knoten1 hat keine Daten, Knoten2 ist NIL
//  5 : beide Knoten haben keine Daten
//  4 : beide Knoten sind gleich und haben keine Daten
//  3 : beide Knoten haben eine leere Datei
//  2 : beide Knoten sind gleich und haben eine leere Datei
//  1 : beide Knoten haben die selbe Datei
//  0 : beide Knoten sind gleich und haben Daten
// -1 : die Dateien sind unterschiedlich
// -2 : nur Knoten1 hat Daten
// -3 : nur Knoten2 hat Daten
// -4 : Knoten1 hat Daten, Knoten2 ist NIL
// -5 : Knoten2 hat Daten, Knoten1 ist NIL
FUNCTION KnotenDateigleich(Knoten1, Knoten2: TTreeNode): Integer;
BEGIN
  IF Assigned(Knoten1) AND Assigned(Knoten2) THEN
    IF Knoten1 <> Knoten2 THEN
      IF Assigned(Knoten1.Data) AND Assigned(Knoten2.Data) THEN
        IF TDateieintrag(Knoten1.Data).Name = TDateieintrag(Knoten2.Data).Name THEN
          IF TDateieintrag(Knoten1.Data).Name = '' THEN
            Result := 3                // beide Knoten verweisen auf einen leeren String
          ELSE
            Result := 1                // beide Knoten verweisen auf die selbe Datei
        ELSE
          Result := -1                 // die Dateien sind unterschiedlich
      ELSE
        IF Assigned(Knoten1.Data) THEN
          Result := -2                 // nur Knoten1 hat Daten
        ELSE
          IF Assigned(Knoten2.Data) THEN
            Result := -3               // nur Knoten2 hat Daten
          ELSE
            Result := 5                // beide Knoten haben keine Datei
    ELSE
      IF Assigned(Knoten1.Data) THEN
        IF TDateieintrag(Knoten1.Data).Name = '' THEN
          Result := 2                  // beide Knoten sind gleich und heben einen leeren String
        ELSE
          Result := 0                  // beide Knoten sind gleich und haben Daten
      ELSE
        Result := 4                    // beide Knoten sind gleich, haben aber keine Daten
  ELSE
    IF Assigned(Knoten1) OR Assigned(Knoten2) THEN
      IF Assigned(Knoten1) THEN
        IF Assigned(Knoten1.Data) THEN
          Result := -4                 // Knoten1 hat Daten, Knoten2 ist NIL
        ELSE
          Result := 6                  // Knoten1 hat keine Daten, Knoten2 ist NIL
      ELSE
        IF Assigned(Knoten2.Data) THEN
          Result := -5                 // Knoten2 hat Daten, Knoten1 ist NIL
        ELSE
          Result := 7                  // Knoten2 hat keine Daten, Knoten1 ist NIL
    ELSE
      Result := 8;                     // beide Knoten NIL
END;

// vergleicht zwei Hauptknoten, Video oder Audio
//  9 : beide Knoten sind NIL
// -6 : keine Audioknoten vorhanden
// -7 : Anzahl der Unterknoten unterschiedlich
// -8 : ein Knoten hat keine Unterknoten
FUNCTION KnotenDatengleich(Knoten1, Knoten2: TTreeNode; Audio: Boolean = False): Integer;

VAR I : Integer;

BEGIN
  IF Assigned(Knoten1) THEN
    IF Knoten1.Level > 0 THEN                                                   // es wurde ein Knoten höherer Ebene übergeben
      Knoten1 := Knoten1.Parent;
  IF Assigned(Knoten2) THEN
    IF Knoten2.Level > 0 THEN                                                   // es wurde ein Knoten höherer Ebene übergeben
      Knoten2 := Knoten2.Parent;
    IF (Assigned(Knoten1) AND (NOT Knoten1.HasChildren)) OR
       (Assigned(Knoten2) AND (NOT Knoten2.HasChildren)) THEN
      Result := -8                                                              // Knoten müssen Unterknoten haben
    ELSE
      IF Assigned(Knoten1) AND Assigned(Knoten2) THEN                           // beide Knoten existieren
        IF Audio THEN
          IF Knoten1.Count = Knoten2.Count THEN
            IF Knoten1.Count > 1 THEN
            BEGIN
              Result := 0;
              I := 1;
              WHILE (I < Knoten1.Count) AND (Result > -1) DO
              BEGIN
                Result := KnotenDateigleich(Knoten1.Item[I], Knoten2.Item[I]);
                Inc(I);
              END;
            END
            ELSE
              Result := -6
          ELSE
            Result := -7                                                        // beide Knoten haben eine unterschiedliche Anzahl Unterknoten
        ELSE
          Result := KnotenDateigleich(Knoten1.Item[0], Knoten2.Item[0])
      ELSE
        IF Assigned(Knoten1) THEN
          IF Audio THEN
            IF Knoten1.Count > 1 THEN
            BEGIN
              Result := 0;
              I := 1;
              WHILE (I < Knoten1.Count)  AND (Result > -1) DO
              BEGIN
                Result := KnotenDateigleich(Knoten1.Item[I], NIL);
                Inc(I);
              END;
            END
            ELSE
              Result := -6
          ELSE
           Result := KnotenDateigleich(Knoten1.Item[0], NIL)
        ELSE
          IF Assigned(Knoten2) THEN
            IF Audio THEN
              IF Knoten1.Count > 1 THEN
              BEGIN
                Result := 0;
                I := 1;
                WHILE (I < Knoten2.Count)  AND (Result > -1) DO
                BEGIN
                  Result := KnotenDateigleich(NIL, Knoten2.Item[I]);
                  Inc(I);
                END;
              END
              ELSE
                Result := -6
            ELSE
             Result := KnotenDateigleich(Knoten2.Item[0], NIL)
          ELSE
            Result := 9;                                                        // beide Knoten sind leer
END;

PROCEDURE Loeschen;

VAR Knotenpunkt : TTreenode;
    I : Integer;

BEGIN
  FOR I := 0 TO Dateiliste.Items.Count - 1 DO                                   // alle Knoten durchlaufen
  BEGIN
    Knotenpunkt := Dateiliste.Items[I];
    IF Knotenpunkt.Level = 0 THEN                                               // und die Datenobjekte löschen
      KnotenDatenloeschen(Knotenpunkt);
  END;
  Dateiliste.Items.Clear;                                                       // alle Knoten löschen
//  aktVideoknoten := NIL;   // -------------- ist noch zu klären --------------
//  aktAudioknoten := NIL;   // -------------- ist noch zu klären --------------
//  VorschauKnoten := NIL;   // -------------- ist noch zu klären --------------
END;

end.
