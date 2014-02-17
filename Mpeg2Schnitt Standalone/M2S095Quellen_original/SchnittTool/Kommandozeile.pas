unit Kommandozeile;

interface

USES Classes, SysUtils, StrUtils, ComCtrls, Types,
     ProtokollUnit,
     DatenTypen,
     AusgabeDatenTypen,
     AllgFunktionen;

FUNCTION Parameterlesen(Projektliste: TStringList; ProjektInfo: TProjektInfo; VAR ProgrammPosition: TRect; VAR PPCL: Boolean): Integer;

implementation

FUNCTION StrToRect(Text: STRING): TRect;
BEGIN
  Result.Left := StrToIntDef(KopiereParameter(Text, 1, ','), -1);
  Result.Top := StrToIntDef(KopiereParameter(Text, 2, ','), -1);
  Result.Right := StrToIntDef(KopiereParameter(Text, 3, ','), -1);
  Result.Bottom := StrToIntDef(KopiereParameter(Text, 4, ','), -1);
END;

FUNCTION Parameterlesen(Projektliste: TStringList; ProjektInfo: TProjektInfo; VAR ProgrammPosition: TRect; VAR PPCL: Boolean): Integer;

VAR I{, Erg} : Integer;
    Text,
    HString,
    SchnittpunktI : STRING;
    Audioknoten : TTreeNode;

BEGIN
  Result := 0;
  SchnittpunktI := '';
  ProgrammPosition.Left := -1;
  ProgrammPosition.Top := -1;
  ProgrammPosition.Right := -1;
  ProgrammPosition.Bottom := -1;
//  ZielDateinameCLaktiv := False;
//  FramegenauschneidenCLaktiv := False;
//  gleichSchneidenCL := False;
//  nachSchneidenbeendenCL := False;
//  aktArbeitsumgebungCLaktiv := False;
  Audioknoten := NIL;
  IF ParamCount > 0 THEN                                                        // Übergabeparameter vorhanden
  BEGIN
    I := 1;
    WHILE I < ParamCount + 1 DO
    BEGIN
      IF UpperCase(ParamStr(I)) = '/C' THEN                                     // Schneiden (Cut)
        Result := Result OR 2
      ELSE
        IF UpperCase(ParamStr(I)) = '/E' THEN                                   // Programm nach dem Schnitt beenden
          Result := Result OR 4
        ELSE
          IF UpperCase(ParamStr(I)) = '/X' THEN                                 // Rechner nach dem Schnitt ausschalten
            Result := Result OR 8
          ELSE
            IF UpperCase(ParamStr(I)) = '/NS' THEN                              // keine Oberfläche (no Surface)
              Result := Result OR 16
            ELSE
              IF UpperCase(ParamStr(I)) = '/OP' THEN                            // ein Projekt Modus (one Project)
                Result := Result OR 32
              ELSE
                IF UpperCase(LeftStr(ParamStr(I), 3)) = '/PN' THEN              // extra Projektname
                BEGIN
                  ProjektInfo.Projektname := RightStr(ParamStr(I), Length(ParamStr(I)) - 3);
                  IF ProjektInfo.Projektname = '' THEN
                  BEGIN
                    Inc(I);
                    ProjektInfo.Projektname := ParamStr(I);
                  END;
                  IF ProjektInfo.Projektname = '_' THEN
                    ProjektInfo.Projektname := '';
                END
                ELSE
                  IF UpperCase(LeftStr(ParamStr(I), 3)) = '/PP' THEN            // Programmposition
                  BEGIN
                    IF RightStr(ParamStr(I), Length(ParamStr(I)) - 3) = '' THEN
                    BEGIN
                      Inc(I);
                      ProgrammPosition := StrToRect(ParamStr(I));
                    END
                    ELSE
                      ProgrammPosition := StrToRect(RightStr(ParamStr(I), Length(ParamStr(I)) - 3));
                    PPCL := True;
                  END
                  ELSE
                  IF LowerCase(ExtractFileExt(ParamStr(I))) = '.mau' THEN       // Arbeitsumgebung laden
                  BEGIN
                    //
                  END
                ELSE
        IF LowerCase(ExtractFileExt(ParamStr(I))) = '.m2e' THEN                 // Projekte einfügen
        BEGIN
          IF Assigned(Projektliste) AND
             ((Result AND 1) = 0) THEN                                          // kein CL Schnitt
          Projektliste.Add(ParamStr(I));
        END
        ELSE
          IF (NOT Assigned(Projektliste)) OR                                    // CL Schnitt
             (Projektliste.Count = 0) THEN
          BEGIN
            IF Assigned(ProjektInfo) THEN
            BEGIN
              Result := Result OR 1;
              IF UpperCase(LeftStr(ParamStr(I), 2)) = '/Z' THEN
              BEGIN
                ProjektInfo.Zieldateiname := RightStr(ParamStr(I), Length(ParamStr(I)) - 2);
                IF ProjektInfo.Zieldateiname = '' THEN
                BEGIN
                  Inc(I);
                  ProjektInfo.Zieldateiname := ParamStr(I);
                END;
              END
              ELSE
                IF UpperCase(ParamStr(I)) = '/+F' THEN
                  ProjektInfo.Framegenauschneiden := True
                ELSE
                  IF UpperCase(ParamStr(I)) = '/-F' THEN
                    ProjektInfo.Framegenauschneiden := False
                  ELSE
                    IF UpperCase(LeftStr(ParamStr(I), 2)) = '/R' THEN
                    BEGIN
                      IF RightStr(ParamStr(I), Length(ParamStr(I)) - 2) = '' THEN
                      BEGIN
                        Inc(I);
                        HString := ParamStr(I);
                      END
                      ELSE
                        HString := RightStr(ParamStr(I), Length(ParamStr(I)) - 2);
                      TRY
                        ProjektInfo.BilderProSek := StrToFloat(HString);
                      EXCEPT
                        ProjektInfo.BilderProSek := 25;
                      END;
                    END
                    ELSE
                      IF UpperCase(LeftStr(ParamStr(I), 2)) = '/L' THEN
                      BEGIN
                        IF RightStr(ParamStr(I), Length(ParamStr(I)) - 2) = '' THEN
                        BEGIN
                          Inc(I);
                          HString := ParamStr(I);
                        END
                        ELSE
                          HString := RightStr(ParamStr(I), Length(ParamStr(I)) - 2);
                        TRY
                          IF StrToFloat(HString) > 0 THEN
                            ProjektInfo.BilderProSek := 1000 / StrToFloat(HString)
                        EXCEPT
                          ProjektInfo.BilderProSek := 25;
                        END;
                      END
                      ELSE
                        IF UpperCase(LeftStr(ParamStr(I), 2)) = '/I' THEN
                        BEGIN
                          IF SchnittpunktI <> '' THEN
                           { SchnittpunkteinfuegenCL(SchnittpunktI, '')};
                          SchnittpunktI := RightStr(ParamStr(I), Length(ParamStr(I)) - 2);
                          IF SchnittpunktI = '' THEN
                          BEGIN
                            Inc(I);
                            SchnittpunktI := ParamStr(I);
                          END;
                        END
                        ELSE
                          IF UpperCase(LeftStr(ParamStr(I), 2)) = '/O' THEN
                          BEGIN
                            IF RightStr(ParamStr(I), Length(ParamStr(I)) - 2) = '' THEN
                            BEGIN
                              Inc(I);
                              HString := ParamStr(I);
                            END
                            ELSE
                              HString := RightStr(ParamStr(I), Length(ParamStr(I)) - 2);
                          {  SchnittpunkteinfuegenCL(SchnittpunktI, HString); }
                            SchnittpunktI := '';
                          END
                          ELSE
                            IF UpperCase(LeftStr(ParamStr(I), 2)) = '/A' THEN
                            BEGIN
                              IF RightStr(ParamStr(I), Length(ParamStr(I)) - 2) = '' THEN
                              BEGIN
                                Inc(I);
                                HString := ParamStr(I);
                              END
                              ELSE
                                HString := RightStr(ParamStr(I), Length(ParamStr(I)) - 2);
                              IF Assigned(Audioknoten) AND
                                 Assigned(Audioknoten.Data) THEN
                              {  TDateieintragAudio(Audioknoten.Data).Audiooffset := StrToIntDef(HString, 0)};
                            END
                            ELSE
                              IF UpperCase(LeftStr(ParamStr(I), 2)) = '/H' THEN
                              BEGIN
                                IF RightStr(ParamStr(I), Length(ParamStr(I)) - 2) = '' THEN
                                BEGIN
                                  Inc(I);
                                  HString := ParamStr(I);
                                END
                                ELSE
                                  HString := RightStr(ParamStr(I), Length(ParamStr(I)) - 2);
                               { Erg := AudiodateieinfuegenKnoten(Dateien.Selected, HString);
                                IF Erg = -2 THEN
                                BEGIN
                                  IF Text <> '' THEN
                                    Text := Text + Chr(13);
                                  Text := Text + Meldunglesen(NIL, 'Meldung111', HString, 'Der Dateityp $Text1# wird nicht unterstützt.');
                                END
                                ELSE
                                  Audioknoten := DateienlisteneintragAudio_suchenKnoten(Dateien.Selected, HString); }
                              END
                              ELSE
                              BEGIN
                              {  Erg := Videodateieinfuegen(ParamStr(I));
                                IF Erg = -1 THEN
                                BEGIN
                                  Erg := Audiodateieinfuegen(ParamStr(I));
                                  IF Erg = 0 THEN
                                    Audioknoten := DateienlisteneintragAudio_suchenKnoten(Dateien.Selected, ParamStr(I));
                                END
                                ELSE
                                  Audioknoten := NIL;
                                IF Erg = -1 THEN
                                BEGIN
                                  IF Text <> '' THEN
                                    Text := Text + Chr(13);
                                  Text := Text + Meldunglesen(NIL, 'Meldung111', ParamStr(I), 'Der Dateityp $Text1# wird nicht unterstützt.');
                                END
                                ELSE
                                  Projektgeaendert_setzen(1);  }
                              END;
            END;
      END;
      Inc(I);
    END;
//    IF SchnittpunktI <> '' THEN
//      SchnittpunkteinfuegenCL(SchnittpunktI, '');
    IF Text <> '' THEN
      Protokoll_schreiben(Text);
  END;
end;


end.
